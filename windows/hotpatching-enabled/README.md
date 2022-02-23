### Example: Windows Virtual Machine with Automatic VM Guest Patching and Hotpatching Enabled

🔧 Technologies & Tools

![](https://img.shields.io/badge/Code-Terraform-informational?style=flat&logo=Terraform&logoColor=white&color=2bbc8a) 
![](https://img.shields.io/badge/Cloud-MicrosoftAzure-informational?style=flat&logo=MicrosoftAzure&logoColor=white&color=2bbc8a)

**This example provisions a Windows Virtual Machine with Automatic VM Guest Patching and Hotpatching Enabled.

###patch_mode - (Optional) 
```
Specifies the mode of in-guest patching to this Windows Virtual Machine. Possible values are Manual, AutomaticByOS and AutomaticByPlatform. Defaults to AutomaticByOS. For more informaton on patch modes please see the product documentation.
```

### Info: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine 
### Info: https://docs.microsoft.com/en-us/azure/virtual-machines/automatic-vm-guest-patching#patch-orchestration-modes