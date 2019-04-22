# PSWinDocumentation.O365HealthService - PowerShell Module

`PSWinDocumentation.O365HealthService` is a Powershell module that has a single goal of getting Office 365 Health Status




``` PowerShell
Import-Module PSWinDocumentation.O365HealthService -Force

$ApplicationID = ''
$ApplicationKey = ''
$TenantDomain = 'evotec.pl'

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



``` PowerShell
Import-Module PSWinDocumentation.O365HealthService -Force

$ApplicationID = ''
$ApplicationKey = ''
$TenantDomain = 'evotec.pl'

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