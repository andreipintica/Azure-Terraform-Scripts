### Example: Windows Virtual Machine with Automatic VM Guest Patching and Hotpatching Enabled

🔧 Technologies & Tools

![](https://img.shields.io/badge/Microsoft-Azure-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a) 
![](https://www.svgrepo.com/show/306846/terraform.svg)

**This example provisions a Windows Virtual Machine with Automatic VM Guest Patching and Hotpatching Enabled.

###patch_mode - (Optional) 
```
Specifies the mode of in-guest patching to this Windows Virtual Machine. Possible values are Manual, AutomaticByOS and AutomaticByPlatform. Defaults to AutomaticByOS. For more informaton on patch modes please see the product documentation.
```

### Info: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine 
### Info: https://docs.microsoft.com/en-us/azure/virtual-machines/automatic-vm-guest-patching#patch-orchestration-modes