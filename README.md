Welcome to my Terraform github repository. 

🔧 Technologies & Tools

![](https://img.shields.io/badge/Code-Terraform-informational?style=flat&logo=Terraform&logoColor=white&color=2bbc8a) 
![](https://img.shields.io/badge/Cloud-MicrosoftAzure-informational?style=flat&logo=MicrosoftAzure&logoColor=white&color=2bbc8a)

## Examples for the Virtual Machine resources

In 1.x versions of the Provider, Terraform has a single resource for Virtual Machines: azurerm_virtual_machine.

Version 2.0 of the Azure Provider introduces several new resources which supersede the existing azurerm_virtual_machine resource:

azurerm_linux_virtual_machine
azurerm_windows_virtual_machine
[More details can be found in this issue] (https://github.com/hashicorp/terraform-provider-azurerm/issues/2807) however these resources will replace the existing azurerm_virtual_machine resource in the long-term.

