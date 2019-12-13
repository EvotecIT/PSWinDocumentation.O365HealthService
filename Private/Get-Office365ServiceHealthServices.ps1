function Get-Office365ServiceHealthServices {
    [CmdLetbinding()]
    param(
        [System.Collections.IDictionary] $Authorization,
        [string] $TenantDomain
    )
    try {
        $Services = (Invoke-RestMethod -Uri "https://manage.office.com/api/v1.0/$($TenantDomain)/ServiceComms/Services" -Headers $Authorization -Method Get)
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        Write-Warning -Message "Get-Office365ServiceHealthServices - Error: $ErrorMessage"
        return
    }
    $Output = @{ }
    $Output.Simple = foreach ($Service in $Services.Value) {
        [PSCustomObject][ordered] @{
            #ID          = $Service.ID
            Service = $Service.DisplayName
        }
    }

    $Output.Extended = foreach ($Service in $Services.Value) {
        foreach ($Feature in  $Service.Features) {
            [PSCustomObject][ordered] @{
                #ID                 = $Service.ID
                Service = $Service.DisplayName
                Feature = $Feature.DisplayName
                #FeatureName        = $Feature.Name
            }
        }
    }
    return $Output
}
