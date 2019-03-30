function Get-Office365ServiceHealthHistoricalStatus {
    [CmdLetbinding()]
    param(
        [System.Collections.IDictionary] $Authorization,
        [string] $TenantDomain
    )
    $HistoricalStatus = (Invoke-RestMethod -Uri "https://manage.office.com/api/v1.0/$($TenantDomain)/ServiceComms/HistoricalStatus" -Headers $Authorization -Method Get)

    $Output = @{}
    $Output.Simple = foreach ($Status in $HistoricalStatus.Value) {
        [PSCustomObject] @{
            ID                  = $Status.ID
            IncidentIds         = $Status.IncidentIds -join ', '
            Status              = $Status.Status
            StatusDisplayName   = $Status.StatusDisplayName
            StatusTime          = $Status.StatusTime
            Workload            = $Status.Workload
            WorkloadDisplayName = $Status.WorkloadDisplayName
        }
    }
    $Output.Exteneded = foreach ($Status in $HistoricalStatus.Value) {
        foreach ($Feature in  $Status.FeatureStatus) {
            [PSCustomObject] @{
                ID                              = $Status.ID
                IncidentIds                     = $Status.IncidentIds -join ', '
                Status                          = $Status.Status
                StatusDisplayName               = $Status.StatusDisplayName
                StatusTime                      = $Status.StatusTime
                Workload                        = $Status.Workload
                WorkloadDisplayName             = $Status.WorkloadDisplayName
                FeatureDisplayName              = $Feature.FeatureDisplayName
                FeatureName                     = $Feature.FeatureName
                FeatureServiceStatus            = $Feature.FeatureServiceStatus
                FeatureServiceStatusDisplayName = $Feature.FeatureServiceStatusDisplayName
            }
        }
    }
    return $Output
}