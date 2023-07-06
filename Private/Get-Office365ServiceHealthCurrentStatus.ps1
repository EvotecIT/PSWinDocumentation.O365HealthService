function Get-Office365ServiceHealthCurrentStatus {
    [CmdLetbinding()]
    param(
        [System.Collections.IDictionary] $Authorization,
        [string] $TenantDomain,
        [switch] $ToLocalTime
    )
    try {
        $CurrentStatus = Invoke-Graphimo -Uri "https://graph.microsoft.com/v1.0/admin/serviceAnnouncement/healthOverviews?`$expand=issues" -Method GET -Headers $Authorization -FullUri
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        Write-Warning -Message "Get-Office365ServiceHealthCurrentStatus - Error: $ErrorMessage"
        return
    }
    $Output = @{ }
    $Output.Simple = foreach ($Status in $CurrentStatus) {
        [PSCustomObject][ordered] @{
            ID            = $Status.ID
            Service       = $Status.Service
            ServiceStatus = $Status.Status
            StatusTime    = $Script:Today
            Incidents     = ($Status.issues | Where-Object { $_.IsResolved -eq $false }).id
        }
    }

    $Output.Extended = foreach ($Status in $CurrentStatus) {
        [PSCustomObject][ordered] @{
            ID                    = $Status.ID
            Service               = $Status.Service
            ServiceStatus         = $Status.Status
            StatusTime            = $Script:Today
            Incidents             = ($Status.issues | Where-Object { $_.IsResolved -eq $false }).id
            FeaturesAffected      = ($Status.issues | Where-Object { $_.IsResolved -eq $false }).feature
            FeaturesAffectedGroup = ($Status.issues | Where-Object { $_.IsResolved -eq $false }).featureGroup
        }
    }
    return $Output
}