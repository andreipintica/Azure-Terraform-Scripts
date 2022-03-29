variable "env" {
  type = string
  default = "dev"
}
variable "vmDiagSta" {
  type = string
}
variable "rgVmDiagSta" {
  type = string
}

variable "configFileName" {
  type = string
}
variable "rgName" {
  type = string
}

variable "keyVault" {
  type = string
}

variable "keyVaultRg" {
  type = string
}

variable "vnetName" {
  type = string
}

variable "vnetRg" {
  type = string
}

variable "location" {
  type    = string
  default = "westeurope"
}

#Managed Disk Storage tier
variable "vmStorageTier" {
  type    = string
  default = "Premium_LRS"
}

variable "createOption" {
  type    = string
  default = "Empty"
}
