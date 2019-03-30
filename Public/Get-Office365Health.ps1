function Get-Office365Health {
    [CmdLetbinding()]
    param(
        [string][alias('ClientID')] $ApplicationID,
        [string][alias('ClientSecret')] $ApplicationKey,
        [string] $TenantDomain
    )

    $Authorization = Connect-O365ServiceHealth -ApplicationID $ApplicationID -ApplicationKey $ApplicationKey -TenantDomain $TenantDomain
    if ($null -ne $Authorization) {
        $Services = Get-Office365ServiceHealthServices -Authorization $Authorization -TenantDomain $TenantDomain
        $CurrentStatus = Get-Office365ServiceHealthCurrentStatus -Authorization $Authorization -TenantDomain $TenantDomain
        $HistoricalStatus = Get-Office365ServiceHealthHistoricalStatus -Authorization $Authorization -TenantDomain $TenantDomain
        $Messages = Get-Office365ServiceHealthMessages -Authorization $Authorization -TenantDomain $TenantDomain
    }
    $Output = [ordered] @{}
    $Output.ServicesSimple = $Services.Simple
    $Output.ServicesExteneded = $Services.Exteneded
    $Output.CurrentStatusSimple = $CurrentStatus.Simple
    $Output.CurrentStatusExteneded = $CurrentStatus.Exteneded
    $Output.HistoricalStatusSimple = $HistoricalStatus.Simple
    $Output.HistoricalStatusExteneded = $HistoricalStatus.Exteneded
    $Output.MessageCenterInformationSimple = $Messages.MessageCenterInformationSimple | Sort-Object -Property LastUpdatedTime -Descending
    $Output.MessageCenterInformation = $Messages.MessageCenterInformation | Sort-Object -Property LastUpdatedTime -Descending
    $Output.IncidentsSimple = $Messages.IncidentsSimple | Sort-Object -Property LastUpdatedTime -Descending
    $Output.Incidents = $Messages.Incidents | Sort-Object -Property LastUpdatedTime -Descending
    return $Output
}