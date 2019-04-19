Import-Module PSWinDocumentation.O365HealthService -Force
Import-Module Dashimo -Force

$ApplicationID = ''
$ApplicationKey = ''
$TenantDomain = 'evotec.pl'

$O365 = Get-Office365Health -ApplicationID $ApplicationID -ApplicationKey $ApplicationKey -TenantDomain $TenantDomain

Dashboard -FilePath $PSScriptRoot\Health.html -Show {
    Tab -Name 'Services' {
        Section -Invisible {
            Section {
                Table -DataTable $O365.Services
            }
            Section {
                Table -DataTable $O365.ServicesExteneded
            }
        }
    }
    Tab -Name 'Current Status' {
        Section -Invisible {
            Section {
                Table -DataTable $O365.CurrentStatus
            }
            Section {
                Table -DataTable $O365.CurrentStatusExteneded
            }
        }
    }
    Tab -Name 'Historical Status' {
        Section -Invisible {
            Section {
                Table -DataTable $O365.HistoricalStatus
            }
            Section {
                Table -DataTable $O365.HistoricalStatusExteneded
            }
        }
    }
    Tab -Name 'Message Center Information' {
        Section -Invisible {
            Section {
                Table -DataTable $O365.MessageCenterInformation
            }
            Section {
                Table -DataTable $O365.MessageCenterInformationExtended
            }
        }
    }
    Tab -Name 'Incidents' {
        Section -Invisible {
            Section {
                Table -DataTable $O365.Incidents
            }
            Section {
                Table -DataTable $O365.IncidentsExteneded
            }
        }
    }
    Tab -Name 'Planned Maintenance' {
        Section -Invisible {
            Section {
                Table -DataTable $O365.PlannedMaintenance
            }
            Section {
                Table -DataTable $O365.PlannedMaintenanceExteneded
            }
        }
    }
    Tab -Name 'Messages' {
        Section -Invisible {
            Section {
                Table -DataTable $O365.Messages
            }
        }
    }
}