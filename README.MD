<center>

[![PowerShellGallery Version](https://img.shields.io/powershellgallery/v/PSWinDocumentation.O365HealthService.svg)](https://www.powershellgallery.com/packages/PSWinDocumentation.O365HealthService)

[![PowerShellGallery Platform](https://img.shields.io/powershellgallery/p/PSWinDocumentation.O365HealthService.svg)](https://www.powershellgallery.com/packages/PSWinDocumentation.O365HealthService)
[![PowerShellGallery Preview Version](https://img.shields.io/powershellgallery/vpre/PSWinDocumentation.O365HealthService.svg?label=powershell%20gallery%20preview&colorB=yellow)](https://www.powershellgallery.com/packages/PSWinDocumentation.O365HealthService)

![Top Language](https://img.shields.io/github/languages/top/evotecit/PSWinDocumentation.O365HealthService.svg)
![Code](https://img.shields.io/github/languages/code-size/evotecit/PSWinDocumentation.O365HealthService.svg)
[![PowerShellGallery Downloads](https://img.shields.io/powershellgallery/dt/PSWinDocumentation.O365HealthService.svg)](https://www.powershellgallery.com/packages/PSWinDocumentation.O365HealthService)

</center>

# PSWinDocumentation.O365HealthService - PowerShell Module

`PSWinDocumentation.O365HealthService` is a Powershell module that has a single goal of getting Office 365 Health Status

### Overview:

- How to/What it really use and how you can use it: https://evotec.xyz/powershell-way-to-get-all-information-about-office-365-service-health/
- Step by Step to Get App ID and App Key: https://evotec.xyz/preparing-azure-app-registrations-permissions-for-office-365-health-service/

### Changelog
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

```
Install-Module PSWinDocumentation.O365HealthService -Force
```


### Example 1

Here's a live demo generated using Dashimo: https://evotec.xyz/wp-content/uploads/2019/05/Health.html

```powershell
Import-Module PSWinDocumentation.O365HealthService -Force
Import-Module Dashimo -Force

$ApplicationID = ''
$ApplicationKey = ''
$TenantDomain = 'evotec.pl' # CustomDomain (onmicrosoft.com won't work), alternatively you can use DirectoryID

$O365 = Get-Office365Health -ApplicationID $ApplicationID -ApplicationKey $ApplicationKey -TenantDomain $TenantDomain -ToLocalTime -Verbose

Dashboard -FilePath $PSScriptRoot\Health.html -Show {
    Tab -Name 'Services' {
        Section -Invisible {
            Section -Name 'Service List' {
                Table -DataTable $O365.Services
            }
            Section -Name 'Service & Feature List' {
                Table -DataTable $O365.ServicesExtended
            }
        }
    }
    Tab -Name 'Current Status' {
        Section -Invisible {
            Section -Name 'Current Status' {
                Table -DataTable $O365.CurrentStatus
            }
            Section -Name 'Current Status Extended' {
                Table -DataTable $O365.CurrentStatusExtended
            }
        }
    }
    Tab -Name 'Historical Status' {
        Section -Invisible {
            Section -Name 'Historical Status' {
                Table -DataTable $O365.HistoricalStatus
            }
            Section -Name 'Historical Status Extended' {
                Table -DataTable $O365.HistoricalStatusExtended
            }
        }
    }
    Tab -Name 'Message Center Information' {
        Section -Invisible {
            Section -Name 'Message Center' {
                Table -DataTable $O365.MessageCenterInformation
            }
            Section -Name 'Message Center Extended' {
                Table -DataTable $O365.MessageCenterInformationExtended -InvokeHTMLTags
            }
        }
    }
    Tab -Name 'Incidents' {
        Section -Invisible {
            Section -Name 'Incidents' {
                Table -DataTable $O365.Incidents
            }
            Section -Name 'Incidents Extended' {
                Table -DataTable $O365.IncidentsExtended
            }
        }
    }
    Tab -Name 'Incidents Messages' {
        Section -Invisible {
            Section -Name 'Incidents Messages' {
                Table -DataTable $O365.IncidentsMessages
            }
        }
    }
    Tab -Name 'Planned Maintenance' {
        Section -Invisible {
            Section {
                Table -DataTable $O365.PlannedMaintenance
            }
            Section {
                Table -DataTable $O365.PlannedMaintenanceExtended
            }
        }
    }
}
```

### Example 2

``` PowerShell
Import-Module PSWinDocumentation.O365HealthService -Force

$ApplicationID = ''
$ApplicationKey = ''
$TenantDomain = 'evotec.pl' # CustomDomain (onmicrosoft.com won't work), alternatively you can use DirectoryID

$O365 = Get-Office365Health -ApplicationID $ApplicationID -ApplicationKey $ApplicationKey -TenantDomain $TenantDomain -ToLocalTime -Verbose
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

$O365 = Get-Office365Health -ApplicationID $ApplicationID -ApplicationKey $ApplicationKey -TenantDomain $TenantDomain -ToLocalTime -Verbose
$O365.CurrentStatus | Format-Table -AutoSize

```

Output:

```

Service                                 ServiceStatus       Feature                        FeatureStatus       IncidentIds StatusTime
-------                                 -------------       -------                        -------------       ----------- ----------
Exchange Online                         Restoring service   Sign-in                        Normal service      EX177902    21.04.2019 16:54:19
Exchange Online                         Restoring service   E-Mail and calendar access     Normal service      EX177902    21.04.2019 16:54:19
Exchange Online                         Restoring service   E-Mail timely delivery         Normal service      EX177902    21.04.2019 16:54:19
Exchange Online                         Restoring service   Management and Provisioning    Restoring service   EX177902    21.04.2019 16:54:19
Exchange Online                         Restoring service   Voice mail                     Normal service      EX177902    21.04.2019 16:54:19
Microsoft Kaizala                       Normal service      Kaizala Messaging              Normal service                  21.04.2019 16:54:19
Microsoft Kaizala                       Normal service      Kaizala Management Portal      Normal service                  21.04.2019 16:54:19
Skype for Business                      Service degradation Audio and Video                Normal service      LY177449    21.04.2019 16:54:19
Skype for Business                      Service degradation Federation                     Normal service      LY177449    21.04.2019 16:54:19
Skype for Business                      Service degradation Management and Provisioning    Normal service      LY177449    21.04.2019 16:54:19
Skype for Business                      Service degradation Sign-In                        Normal service      LY177449    21.04.2019 16:54:19
Skype for Business                      Service degradation All Features                   Service degradation LY177449    21.04.2019 16:54:19
Skype for Business                      Service degradation Dial-In Conferencing           Normal service      LY177449    21.04.2019 16:54:19
Skype for Business                      Service degradation Online Meetings                Normal service      LY177449    21.04.2019 16:54:19
Skype for Business                      Service degradation Instant Messaging              Normal service      LY177449    21.04.2019 16:54:19
Skype for Business                      Service degradation Presence                       Normal service      LY177449    21.04.2019 16:54:19
Skype for Business                      Service degradation Mobility                       Normal service      LY177449    21.04.2019 16:54:19
Skype for Business                      Service degradation Cloud PBX                      Normal service      LY177449    21.04.2019 16:54:19
Skype for Business                      Service degradation PSTN Calling                   Normal service      LY177449    21.04.2019 16:54:19
Skype for Business                      Service degradation Meeting Broadcast              Normal service      LY177449    21.04.2019 16:54:19
Microsoft Teams                         Normal service      Teams Components               Normal service                  21.04.2019 16:54:19
Mobile Device Management for Office 365 Normal service      Mobile Device Management       Normal service                  21.04.2019 16:54:19
Office Online                           Normal service      Excel Online                   Normal service                  21.04.2019 16:54:19
Office Online                           Normal service      OneNote Online                 Normal service                  21.04.2019 16:54:19
Office Online                           Normal service      PowerPoint Online              Normal service                  21.04.2019 16:54:19
Office Online                           Normal service      Word Online                    Normal service                  21.04.2019 16:54:19
Office Online                           Normal service      Visio Online                   Normal service                  21.04.2019 16:54:19
OneDrive for Business                   Normal service      OneDrive for Business          Normal service                  21.04.2019 16:54:19
Identity Service                        Normal service      Sign-In                        Normal service                  21.04.2019 16:54:19
Identity Service                        Normal service      Administration                 Normal service                  21.04.2019 16:54:19
Office 365 Portal                       Normal service      Portal                         Normal service                  21.04.2019 16:54:19
Office 365 Portal                       Normal service      Administration                 Normal service                  21.04.2019 16:54:19
Office 365 Portal                       Normal service      Purchase and Billing           Normal service                  21.04.2019 16:54:19
Planner                                 Normal service      Planner                        Normal service                  21.04.2019 16:54:19
SharePoint Online                       Normal service      Provisioning                   Normal service                  21.04.2019 16:54:19
SharePoint Online                       Normal service      SharePoint Features            Normal service                  21.04.2019 16:54:19
SharePoint Online                       Normal service      Tenant Admin                   Normal service                  21.04.2019 16:54:19
SharePoint Online                       Normal service      Search and Delve               Normal service                  21.04.2019 16:54:19
SharePoint Online                       Normal service      Custom Solutions and Workflows Normal service                  21.04.2019 16:54:19
SharePoint Online                       Normal service      Project Online                 Normal service                  21.04.2019 16:54:19
SharePoint Online                       Normal service      Office Web Apps                Normal service                  21.04.2019 16:54:19
SharePoint Online                       Normal service      SP Designer                    Normal service                  21.04.2019 16:54:19
SharePoint Online                       Normal service      Access Services                Normal service                  21.04.2019 16:54:19
SharePoint Online                       Normal service      InfoPath Online                Normal service                  21.04.2019 16:54:19
Microsoft StaffHub                      Normal service      Service and web access issues  Normal service                  21.04.2019 16:54:19
Microsoft StaffHub                      Normal service      Web client issues              Normal service                  21.04.2019 16:54:19
Microsoft StaffHub                      Normal service      Android client issues          Normal service                  21.04.2019 16:54:19
Microsoft StaffHub                      Normal service      iOS client issues              Normal service                  21.04.2019 16:54:19
Sway                                    Normal service      Sway                           Normal service                  21.04.2019 16:54:19
Yammer Enterprise                       Normal service      Yammer Components              Normal service                  21.04.2019 16:54:19
```