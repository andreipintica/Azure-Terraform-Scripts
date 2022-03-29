#Module Output
output "rgName" {
    value = azurerm_resource_group.rg.name
}
output "rgLocation" {
    value = azurerm_resource_group.rg.location
}

output "vmName" {
  value = { for k,v in local.vmData : azurerm_linux_virtual_machine.vm[k].name=>azurerm_linux_virtual_machine.vm[k].private_ip_address }
}

output "subnetId" {
  value = {for i in local.vmSubnet : data.azurerm_subnet.subnet[i].name=>data.azurerm_subnet.subnet[i].id }
}

output "vmId" {
  value = { for k,v in local.vmData : azurerm_linux_virtual_machine.vm[k].name=>azurerm_linux_virtual_machine.vm[k].id }
}

output "vmIdentity" {
  value = { for k,v in local.vmData : azurerm_linux_virtual_machine.vm[k].name=>azurerm_linux_virtual_machine.vm[k].identity[0].principal_id }
}