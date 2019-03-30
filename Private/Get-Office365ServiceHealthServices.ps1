function Get-Office365ServiceHealthServices {
    param(
        [System.Collections.IDictionary] $Authorization,
        [string] $TenantDomain
    )
    $Services = (Invoke-RestMethod -Uri "https://manage.office.com/api/v1.0/$($TenantDomain)/ServiceComms/Services" -Headers $Authorization -Method Get)

    $Output = @{}
    $Output.Simple = foreach ($Service in $Services.Value) {
        [PSCustomObject] @{
            ID          = $Service.ID
            DisplayName = $Service.DisplayName
        }
    }

    $Output.Exteneded = foreach ($Service in $Services.Value) {
        foreach ($Feature in  $Service.Features) {
            [PSCustomObject] @{
                ID                 = $Service.ID
                DisplayName        = $Service.DisplayName
                FeatureDisplayName = $Feature.DisplayName
                FeatureName        = $Feature.Name
            }
        }
    }
    return $Output
}
