function Get-Office365ServiceHealthServices {
    [CmdLetbinding()]
    param(
        [System.Collections.IDictionary] $Authorization,
        [string] $TenantDomain
    )
    try {
        $Services = Invoke-Graphimo -Uri "https://graph.microsoft.com/v1.0/admin/serviceAnnouncement/healthOverviews" -Method GET -Headers $Authorization -FullUri
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        Write-Warning -Message "Get-Office365ServiceHealthServices - Error: $ErrorMessage"
        return
    }
    $Output = @{ }
    $Output.Simple = foreach ($Service in $Services) {
        [PSCustomObject][ordered] @{
            ID      = $Service.ID
            Service = $Service.service
        }
    }
    return $Output
}
