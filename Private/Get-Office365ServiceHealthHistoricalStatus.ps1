function Get-Office365ServiceHealthHistoricalStatus {
    [CmdLetbinding()]
    param(
        [System.Collections.IDictionary] $Authorization,
        [string] $TenantDomain,
        [switch] $ToLocalTime
    )
    $HistoricalStatus = (Invoke-RestMethod -Uri "https://manage.office.com/api/v1.0/$($TenantDomain)/ServiceComms/HistoricalStatus" -Headers $Authorization -Method Get)

    $Output = @{}
    $Output.Simple = foreach ($Status in $HistoricalStatus.Value) {
        $StatusTime = ConvertFrom-UTCTime -ToLocalTime:$ToLocalTime -Time $Status.StatusTime
        [PSCustomObject][ordered] @{
            #ID          = $Status.ID
            Service       = $Status.WorkloadDisplayName
            ServiceStatus = $Status.StatusDisplayName
            IncidentIds   = $Status.IncidentIds -join ', '
            #Status              = $Status.Status

            StatusTime    = $StatusTime
            StatusDaysAgo = Convert-TimeToDays -StartTime $StatusTime -EndTime $Script:Today
            #Workload            = $Status.Workload

        }
    }
    $Output.Exteneded = foreach ($Status in $HistoricalStatus.Value) {
        foreach ($Feature in  $Status.FeatureStatus) {
            $StatusTime = ConvertFrom-UTCTime -ToLocalTime:$ToLocalTime -Time $Status.StatusTime
            [PSCustomObject][ordered] @{
                #ID                   = $Status.ID
                Service       = $Status.WorkloadDisplayName
                ServiceStatus = $Status.StatusDisplayName
                Feature       = $Feature.FeatureDisplayName
                FeatureStatus = $Feature.FeatureServiceStatusDisplayName
                IncidentIds   = $Status.IncidentIds -join ', '
                #Status                          = $Status.Status
                StatusTime    = $StatusTime
                StatusDaysAgo = Convert-TimeToDays -StartTime $StatusTime -EndTime $Script:Today
                #Workload                        = $Status.Workload
                #FeatureName                     = $Feature.FeatureName
                #FeatureServiceStatus            = $Feature.FeatureServiceStatus

            }
        }
    }
    return $Output
}