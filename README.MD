<center>

<p align="center">
  <a href="https://www.powershellgallery.com/packages/PSWinDocumentation.O365HealthService"><img src="https://img.shields.io/powershellgallery/v/PSWinDocumentation.O365HealthService.svg"></a>
  <a href="https://www.powershellgallery.com/packages/PSWinDocumentation.O365HealthService"><img src="https://img.shields.io/powershellgallery/vpre/PSWinDocumentation.O365HealthService.svg?label=powershell%20gallery%20preview&colorB=yellow"></a>
  <a href="https://github.com/EvotecIT/PSWinDocumentation.O365HealthService"><img src="https://img.shields.io/github/license/EvotecIT/PSWinDocumentation.O365HealthService.svg"></a>
</p>

<p align="center">
  <a href="https://www.powershellgallery.com/packages/PSWinDocumentation.O365HealthService"><img src="https://img.shields.io/powershellgallery/p/PSWinDocumentation.O365HealthService.svg"></a>
  <a href="https://github.com/EvotecIT/PSWinDocumentation.O365HealthService"><img src="https://img.shields.io/github/languages/top/evotecit/PSWinDocumentation.O365HealthService.svg"></a>
  <a href="https://github.com/EvotecIT/PSWinDocumentation.O365HealthService"><img src="https://img.shields.io/github/languages/code-size/evotecit/PSWinDocumentation.O365HealthService.svg"></a>
  <a href="https://github.com/EvotecIT/PSWinDocumentation.O365HealthService"><img src="https://img.shields.io/powershellgallery/dt/PSWinDocumentation.O365HealthService.svg"></a>
</p>

<p align="center">
  <a href="https://twitter.com/PrzemyslawKlys"><img src="https://img.shields.io/twitter/follow/PrzemyslawKlys.svg?label=Twitter%20%40PrzemyslawKlys&style=social"></a>
  <a href="https://evotec.xyz/hub"><img src="https://img.shields.io/badge/Blog-evotec.xyz-2A6496.svg"></a>
  <a href="https://www.linkedin.com/in/pklys"><img src="https://img.shields.io/badge/LinkedIn-pklys-0077B5.svg?logo=LinkedIn"></a>
</p>

</center>

# PSWinDocumentation.O365HealthService - PowerShell Module

`PSWinDocumentation.O365HealthService` is a Powershell module that has a single goal of getting Office 365 Health Status

## Overview

- How to/What it really use and how you can use it: https://evotec.xyz/powershell-way-to-get-all-information-about-office-365-service-health/
- Step by Step to Get App ID and App Key: https://evotec.xyz/preparing-azure-app-registrations-permissions-for-office-365-health-service/

### Changelog

- 1.0.1 - 31.01.2022
  - Fixes cross-platform timezone issue [#10](https://github.com/EvotecIT/PSWinDocumentation.O365HealthService/issues/10)

- 1.0.0 - 29.01.2022
  - Microsoft disabled the Health Service API. Migrated code to Graph API.
  - There are **breaking changes** on the output (aka a bit differently formatted information), less types, different columns, etc.
  - Check examples for more information.
  - Permission requirements changed

![https://evotec.xyz/wp-content/uploads/2022/01/img_61f59e2b000c3.png](https://evotec.xyz/wp-content/uploads/2022/01/img_61f59e2b000c3.png)

- 0.2.4. -13.12.2019
  - Enforces TLS 1.2 as it may be problematic otherwise. Hopefully doesn't break anything
    - Added parameter `TlsDefault` to `Get-Office365Health -TlsDefault` as a way to circumvent that new feature, just in case. Subject to removal later on
- 0.2.3 - 7.11.2019
  - Optimized module removing depedencies (PSSharedGoods) on release
    - It's still used during development
- 0.2.2 - 13.05.2019
  - Fix for mispelled extended word (sorry again..)
- 0.2.1 - 08.05.2019
  - Fix for mispelled extended word (sorry)
- 0.2.0 - 03.05.2019
  - Fix for date changes that Microsoft introduced
- 0.1.0 - 22.04.2019
  - First public release

![Image](https://evotec.xyz/wp-content/uploads/2019/05/img_5cd34ae647da9.png)

### Install

```powershell
Install-Module PSWinDocumentation.O365HealthService -Force
```


### Example 1

Here's a live demo generated using Dashimo: https://evotec.xyz/wp-content/uploads/2019/05/Health.html

```powershell
Import-Module PSWinDocumentation.O365HealthService -Force
Import-Module PSWriteHTML -Force

$ApplicationID = ''
$ApplicationKey = ''
$TenantDomain = 'evotec.pl' # CustomDomain (onmicrosoft.com won't work), alternatively you can use DirectoryID

$O365 = Get-Office365Health -ApplicationID $ApplicationID -ApplicationKey $ApplicationKey -TenantDomain $TenantDomain -Verbose

Dashboard -FilePath $PSScriptRoot\Health.html {
    TabOption -BorderRadius 0px -BackgroundColorActive DimGrey
    SectionOption -BorderRadius 0px -HeaderBackGroundColor DimGrey
    TableOption -DataStore JavaScript -ArrayJoinString "; " -ArrayJoin -BoolAsString
    Tab -Name 'Services' {
        Section -Name 'Service List' {
            Table -DataTable $O365.Services -Filtering
        }
    }
    Tab -Name 'Current Status' {
        Section -Invisible {
            Section -Name 'Current Status' {
                Table -DataTable $O365.CurrentStatus {
                    TableCondition -Name 'ServiceStatus' -Value 'serviceOperational' -BackgroundColor MintGreen -FailBackgroundColor Salmon
                } -Filtering
            }
            Section -Name 'Current Status Extended' {
                Table -DataTable $O365.CurrentStatusExtended {
                    TableCondition -Name 'ServiceStatus' -Value 'serviceOperational' -BackgroundColor MintGreen -FailBackgroundColor Salmon
                } -Filtering
            }
        }
    }
    Tab -Name 'Message Center Information' {
        #Section -Invisible {
        Section -Name 'Message Center' {
            Table -DataTable $O365.MessageCenterInformation -Filtering
        }
        Section -Name 'Message Center Extended' {
            Table -DataTable $O365.MessageCenterInformationExtended -InvokeHTMLTags -Filtering
        }
        #}
    }
    Tab -Name 'Incidents' {
        Section -Invisible {
            Section -Name 'Incidents' {
                Table -DataTable $O365.Incidents -Filtering {
                    TableCondition -Name 'IsResolved' -Value $true -BackgroundColor MintGreen -FailBackgroundColor Salmon -ComparisonType bool
                }
            }
            Section -Name 'Incidents Extended' {
                Table -DataTable $O365.IncidentsExtended -Filtering {
                    TableCondition -Name 'IsResolved' -Value $true -BackgroundColor MintGreen -FailBackgroundColor Salmon -ComparisonType bool
                }
            }
        }
        Section -Name 'Incidents Messages' {
            Table -DataTable $O365.IncidentsUpdates -InvokeHTMLTags -Filtering
        }
    }
} -Online -ShowHTML
```

### Example 2

``` PowerShell
Import-Module PSWinDocumentation.O365HealthService -Force

$ApplicationID = ''
$ApplicationKey = ''
$TenantDomain = 'evotec.pl' # CustomDomain (onmicrosoft.com won't work), alternatively you can use DirectoryID

$O365 = Get-Office365Health -ApplicationID $ApplicationID -ApplicationKey $ApplicationKey -TenantDomain $TenantDomain -Verbose
$O365.CurrentStatus | Format-Table -AutoSize

```

Output:

```
Service                                 ServiceStatus       StatusTime          IncidentIds
-------                                 -------------       ----------          -----------
Exchange Online                         Restoring service   21.04.2019 16:54:19 EX177902
Microsoft Kaizala                       Normal service      21.04.2019 16:54:19
Skype for Business                      Service degradation 21.04.2019 16:54:19 LY177449
Microsoft Teams                         Normal service      21.04.2019 16:54:19
Mobile Device Management for Office 365 Normal service      21.04.2019 16:54:19
Office Online                           Normal service      21.04.2019 16:54:19
OneDrive for Business                   Normal service      21.04.2019 16:54:19
Identity Service                        Normal service      21.04.2019 16:54:19
Office 365 Portal                       Normal service      21.04.2019 16:54:19
Planner                                 Normal service      21.04.2019 16:54:19
SharePoint Online                       Normal service      21.04.2019 16:54:19
Microsoft StaffHub                      Normal service      21.04.2019 16:54:19
Sway                                    Normal service      21.04.2019 16:54:19
Yammer Enterprise                       Normal service      21.04.2019 16:54:19
```

### Example 3


``` PowerShell
Import-Module PSWinDocumentation.O365HealthService -Force

$ApplicationID = ''
$ApplicationKey = ''
$TenantDomain = 'evotec.pl' # CustomDomain (onmicrosoft.com won't work), alternatively you can use DirectoryID

$O365 = Get-Office365Health -ApplicationID $ApplicationID -ApplicationKey $ApplicationKey -TenantDomain $TenantDomain -Verbose
$O365.CurrentStatus | Format-Table -AutoSize

```

Output:

```

ID                       Service                                   ServiceStatus      StatusTime          Incidents
--                       -------                                   -------------      ----------          ---------
Exchange                 Exchange Online                           serviceDegradation 29.01.2022 21:14:47 {EX316072, EX316697}
OrgLiveID                Identity Service                          serviceOperational 29.01.2022 21:14:47
OSDPPlatform             Microsoft 365 suite                       serviceOperational 29.01.2022 21:14:47
Lync                     Skype for Business                        serviceOperational 29.01.2022 21:14:47
SharePoint               SharePoint Online                         serviceOperational 29.01.2022 21:14:47
DynamicsCRM              Dynamics 365 Apps                         serviceOperational 29.01.2022 21:14:47
RMS                      Azure Information Protection              serviceOperational 29.01.2022 21:14:47
yammer                   Yammer Enterprise                         serviceOperational 29.01.2022 21:14:47
MobileDeviceManagement   Mobile Device Management for Office 365   serviceOperational 29.01.2022 21:14:47
Planner                  Planner                                   serviceOperational 29.01.2022 21:14:47
SwayEnterprise           Sway                                      serviceOperational 29.01.2022 21:14:47
PowerBIcom               Power BI                                  serviceOperational 29.01.2022 21:14:47
Intune                   Microsoft Intune                          serviceOperational 29.01.2022 21:14:47
OneDriveForBusiness      OneDrive for Business                     serviceOperational 29.01.2022 21:14:47
microsoftteams           Microsoft Teams                           serviceOperational 29.01.2022 21:14:47
StaffHub                 Microsoft StaffHub                        serviceOperational 29.01.2022 21:14:47
kaizalamessagingservices Microsoft Kaizala                         serviceOperational 29.01.2022 21:14:47
Bookings                 Microsoft Bookings                        serviceOperational 29.01.2022 21:14:47
officeonline             Office for the web                        serviceOperational 29.01.2022 21:14:47
O365Client               Microsoft 365 Apps                        serviceOperational 29.01.2022 21:14:47
PowerAppsM365            Power Apps in Microsoft 365               serviceOperational 29.01.2022 21:14:47
MicrosoftFlow            Microsoft Power Automate                  serviceOperational 29.01.2022 21:14:47
MicrosoftFlowM365        Microsoft Power Automate in Microsoft 365 serviceOperational 29.01.2022 21:14:47
Forms                    Microsoft Forms                           serviceOperational 29.01.2022 21:14:47
Microsoft365Defender     Microsoft 365 Defender                    serviceOperational 29.01.2022 21:14:47
Stream                   Microsoft Stream                          serviceOperational 29.01.2022 21:14:47
Viva                     Microsoft Viva                            serviceOperational 29.01.2022 21:14:47
cloudappsecurity         Microsoft Defender for Cloud Apps         serviceOperational 29.01.2022 21:14:47
```