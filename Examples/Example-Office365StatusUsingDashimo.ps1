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