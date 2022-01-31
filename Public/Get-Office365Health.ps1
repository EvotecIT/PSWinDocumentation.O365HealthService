function Get-Office365Health {
    [CmdLetbinding()]
    param(
        [string][alias('ClientID')] $ApplicationID,
        [string][alias('ClientSecret')] $ApplicationKey,
        [string] $TenantDomain,
        [PSWinDocumentation.Office365Health[]] $TypesRequired = [PSWinDocumentation.Office365Health]::All
    )
    $StartTime = Start-TimeLog
    try {
        $Script:TimeZoneBias = (Get-TimeZone -ErrorAction Stop).BaseUtcOffset.TotalMinutes
    } catch {
        Write-Warning "ConvertFrom-UTCTime - couldn't get timezone. Please report on GitHub."
        $Script:TimeZoneBias = 0
    }
    $Script:Today = Get-Date
    if ($null -eq $TypesRequired -or $TypesRequired -contains [PSWinDocumentation.Office365Health]::All) {
        $TypesRequired = Get-Types -Types ([PSWinDocumentation.Office365Health])
    }
    $Authorization = Connect-O365ServiceHealth -ApplicationID $ApplicationID -ApplicationKey $ApplicationKey -TenantDomain $TenantDomain
    if ($null -eq $Authorization) {
        return
    }
    if (Find-TypesNeeded -TypesRequired $TypesRequired -TypesNeeded @([PSWinDocumentation.Office365Health]::Services)) {
        $Services = Get-Office365ServiceHealthServices -Authorization $Authorization -TenantDomain $TenantDomain
    }
    if (Find-TypesNeeded -TypesRequired $TypesRequired -TypesNeeded @(
            [PSWinDocumentation.Office365Health]::CurrentStatus,
            [PSWinDocumentation.Office365Health]::CurrentStatusExtended
        )) {
        $CurrentStatus = Get-Office365ServiceHealthCurrentStatus -Authorization $Authorization -TenantDomain $TenantDomain -ToLocalTime:$ToLocalTime
    }
    if (Find-TypesNeeded -TypesRequired $TypesRequired -TypesNeeded @(
            [PSWinDocumentation.Office365Health]::Incidents,
            [PSWinDocumentation.Office365Health]::IncidentsExtended
            [PSWinDocumentation.Office365Health]::IncidentsUpdates
        )) {
        $Issues = Get-Office365ServiceHealthIssues -Authorization $Authorization
    }
    if (Find-TypesNeeded -TypesRequired $TypesRequired -TypesNeeded @(
            [PSWinDocumentation.Office365Health]::MessageCenterInformation,
            [PSWinDocumentation.Office365Health]::MessageCenterInformationExtended
        )) {
        $Messages = Get-Office365ServiceHealthMessages -Authorization $Authorization
    }
    $Output = [ordered] @{}
    if (Find-TypesNeeded -TypesRequired $TypesRequired -TypesNeeded @([PSWinDocumentation.Office365Health]::Services)) {
        $Output.Services = $Services.Simple
    }
    if (Find-TypesNeeded -TypesRequired $TypesRequired -TypesNeeded @([PSWinDocumentation.Office365Health]::CurrentStatus)) {
        $Output.CurrentStatus = $CurrentStatus.Simple
    }
    if (Find-TypesNeeded -TypesRequired $TypesRequired -TypesNeeded @([PSWinDocumentation.Office365Health]::CurrentStatusExtended)) {
        $Output.CurrentStatusExtended = $CurrentStatus.Extended
    }
    if (Find-TypesNeeded -TypesRequired $TypesRequired -TypesNeeded @([PSWinDocumentation.Office365Health]::MessageCenterInformation)) {
        $Output.MessageCenterInformation = $Messages.MessageCenterInformation | Sort-Object -Property LastUpdatedTime -Descending
    }
    if (Find-TypesNeeded -TypesRequired $TypesRequired -TypesNeeded @([PSWinDocumentation.Office365Health]::MessageCenterInformationExtended)) {
        $Output.MessageCenterInformationExtended = $Messages.MessageCenterInformationExtended | Sort-Object -Property LastUpdatedTime -Descending
    }
    if (Find-TypesNeeded -TypesRequired $TypesRequired -TypesNeeded @([PSWinDocumentation.Office365Health]::Incidents)) {
        $Output.Incidents = $Issues.Incidents | Sort-Object -Property LastUpdatedTime -Descending
    }
    if (Find-TypesNeeded -TypesRequired $TypesRequired -TypesNeeded @([PSWinDocumentation.Office365Health]::IncidentsExtended)) {
        $Output.IncidentsExtended = $Issues.IncidentsExtended | Sort-Object -Property LastUpdatedTime -Descending
    }
    if (Find-TypesNeeded -TypesRequired $TypesRequired -TypesNeeded @([PSWinDocumentation.Office365Health]::IncidentsUpdates)) {
        $Output.IncidentsUpdates = $Issues.IncidentsUpdates | Sort-Object -Property LastUpdatedTime -Descending
    }
    $EndTime = Stop-TimeLog -Time $StartTime -Option OneLiner
    Write-Verbose "Get-Office365Health - Time to process: $EndTime"
    return $Output
}