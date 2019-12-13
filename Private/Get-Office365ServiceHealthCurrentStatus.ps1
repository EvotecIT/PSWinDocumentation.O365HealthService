function Get-Office365ServiceHealthCurrentStatus {
    [CmdLetbinding()]
    param(
        [System.Collections.IDictionary] $Authorization,
        [string] $TenantDomain,
        [switch] $ToLocalTime
    )
    try {
        $CurrentStatus = (Invoke-RestMethod -Uri "https://manage.office.com/api/v1.0/$($TenantDomain)/ServiceComms/CurrentStatus" -Headers $Authorization -Method Get)
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        Write-Warning -Message "Get-Office365ServiceHealthCurrentStatus - Error: $ErrorMessage"
        return
    }
    $Output = @{ }
    $Output.Simple = foreach ($Status in $CurrentStatus.Value) {
        [PSCustomObject][ordered] @{
            #ID          = $Status.ID
            Service       = $Status.WorkloadDisplayName
            #Status              = $Status.Status
            ServiceStatus = $Status.StatusDisplayName
            StatusTime    = ConvertFrom-UTCTime -ToLocalTime:$ToLocalTime -Time $Status.StatusTime
            IncidentIds   = $Status.IncidentIds -join ', '
            #Workload            = $Status.Workload
        }
    }

    $Output.Extended = foreach ($Status in $CurrentStatus.Value) {
        foreach ($Feature in  $Status.FeatureStatus) {
            [PSCustomObject][ordered] @{
                #ID                   = $Status.ID
                Service       = $Status.WorkloadDisplayName
                ServiceStatus = $Status.StatusDisplayName
                Feature       = $Feature.FeatureDisplayName
                FeatureStatus = $Feature.FeatureServiceStatusDisplayName
                IncidentIds   = $Status.IncidentIds -join ', '
                #Status                          = $Status.Status
                StatusTime    = ConvertFrom-UTCTime -ToLocalTime:$ToLocalTime -Time $Status.StatusTime
                #Workload             = $Status.Workload
                #FeatureName          = $Feature.FeatureName
                #FeatureServiceStatus            = $Feature.FeatureServiceStatus

            }
        }
    }
    return $Output
}