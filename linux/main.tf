# This module you can create a Linux VM with 1 NIC         


locals {

  #import json content
  vmData = jsondecode(file(var.configFileName))
  
  #create list of vm disks
  vmDisks = flatten([for vm_key, vm in local.vmData : [for i in vm.disks : { size = i.size, lunId = i.lunId, vmName = vm_key, zone = vm.zone }]])
  
  #create map with unique identfier of vm disks
  vmDisksMap = { for k, v in local.vmDisks : "${v.vmName}Disk${title(v.lunId)}" => { lunId = v.lunId, size = v.size, vmName = v.vmName, zone = v.zone } }
  
  #create list of unique network tiers
  vmSubnet = distinct(flatten([for i in local.vmData : i.subnet]))
}

# Data Source for existing Core Keyvault - for local sudoer secrets
data "azurerm_key_vault" "kv" {
  name                = var.keyVault
  resource_group_name = var.keyVaultRg
}

# Data source for existing subnet to match information provided in json
data "azurerm_subnet" "subnet" {
  for_each             = toset(local.vmSubnet)
  name                 = each.value
  virtual_network_name = var.vnetName
  resource_group_name  = var.vnetRg
}


# Resources provisioning #

resource "azurerm_resource_group" "rg" {
  name     = var.rgName
  location = var.location
  tags = {
    ProvisioningMode = "Terraform",
    ProvisioningDate = timestamp()
  }
  lifecycle {
    ignore_changes = [
      tags["ProvisioningDate"],
    ]
  }
}


#######################################################################################

# Create Password for vm
resource "random_password" "vmPass" {
  for_each         = local.vmData
  length           = 16
  special          = true
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  override_special = "!@#$%"
}

# save password in keyvault secret
resource "azurerm_key_vault_secret" "vmSecret" {
  for_each     = local.vmData
  name         = lower(each.key)
  value        = random_password.vmPass[each.key].result
  key_vault_id = data.azurerm_key_vault.kv.id
  tags = {
    ProvisioningMode = "Terraform",
    ProvisioningDate = timestamp()
  }
  lifecycle {
    ignore_changes = [
      value,
      tags["ProvisioningDate"],
    ]
  }
}

# import storage account for VM diag
data "azurerm_storage_account" "vmDiag" {
  name                     = var.vmDiagSta
  resource_group_name      = var.rgVmDiagSta
}

# Create 1 NIC for each VM
resource "azurerm_network_interface" "vmNic0" {
  for_each            = local.vmData
  name                = "${each.key}Nic0"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet[each.value.subnet].id 
    private_ip_address_allocation = "Dynamic"
  }
}

# Create VM
resource "azurerm_linux_virtual_machine" "vm" {
  for_each                        = local.vmData
  name                            = each.key
  computer_name                   = each.key
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location
  size                            = each.value.size
  admin_username                  = each.value.vmAdminName
  admin_password                  = random_password.vmPass[each.key].result 
  disable_password_authentication = "false"

  network_interface_ids = [
    azurerm_network_interface.vmNic0[each.key].id,
  ]
  boot_diagnostics {
    storage_account_uri = data.azurerm_storage_account.vmDiag.primary_blob_endpoint
  }

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    name                 = "${each.key}OsDisk"
    caching              = "ReadWrite"
    storage_account_type = var.vmStorageTier 
    disk_size_gb         = each.value.osDiskSize
  }

  source_image_reference {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
    version   = each.value.version
  }

  zone = each.value.zone

  tags = {
    ProvisioningMode = "Terraform",
    ProvisioningDate = timestamp()
  }

  lifecycle {
    ignore_changes = [
      tags["ProvisioningDate"],
    ]
  }
}

resource "azurerm_virtual_machine_extension" "azureAdAuth" {
  for_each             = local.vmData
  name                 = "AADloginForLinux"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm[each.key].id
  publisher            = "Microsoft.Azure.ActiveDirectory.LinuxSSH"
  type                 = "AADLoginForLinux"
  type_handler_version = "1.0"
}

resource "azurerm_managed_disk" "dataDisk" {
  for_each             = local.vmDisksMap
  name                 = each.key
  resource_group_name  = azurerm_resource_group.rg.name
  location             = var.location
  storage_account_type = var.vmStorageTier
  create_option        = var.createOption
  disk_size_gb         = each.value.size
  zones                = [each.value.zone]

  tags = {
    ProvisioningMode = "Terraform",
    ProvisioningDate = timestamp()
  }
  lifecycle {
    ignore_changes = [
      tags["ProvisioningDate"],
    ]
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "dataDisk-Attachment" {
  for_each           = local.vmDisksMap
  managed_disk_id    = azurerm_managed_disk.dataDisk[each.key].id
  virtual_machine_id = azurerm_linux_virtual_machine.vm[each.value.vmName].id
  lun                = each.value.lunId
  caching            = "ReadWrite"
}