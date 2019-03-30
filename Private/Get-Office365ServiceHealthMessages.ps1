function Get-Office365ServiceHealthMessages {
    param(
        [System.Collections.IDictionary] $Authorization,
        [string] $TenantDomain
    )
    $Messages = (Invoke-RestMethod -Uri "https://manage.office.com/api/v1.0/$($TenantDomain)/ServiceComms/Messages" -Headers $Authorization -Method Get)

    $Output = @{}
    $Simple = foreach ($Message in $Test.Value) {
        $Messages = $Message.Messages
        [PSCustomObject] @{
            Id                           = $Message.Id
            Title                        = $Message.Title
            ImpactDescription            = $Message.ImpactDescription
            LastUpdatedTime              = $Message.LastUpdatedTime
            MessageType                  = $Message.MessageType
            Status                       = $Message.Status
            Severity                     = $Message.Severity
            StartTime                    = $Message.StartTime


            Workload                     = $Message.Workload
            WorkloadDisplayName          = $Message.WorkloadDisplayName
            ActionType                   = $Message.ActionType
            Classification               = $Message.Classification
            EndTime                      = $Message.EndTime
            Feature                      = $Message.Feature
            FeatureDisplayName           = $Message.FeatureDisplayName
            UserFunctionalImpact         = $Message.UserFunctionalImpact
            PostIncidentDocumentUrl      = $Message.PostIncidentDocumentUrl
            AffectedTenantCount          = $Message.AffectedTenantCount
            AffectedUserCount            = $Message.AffectedUserCount
            AffectedWorkloadDisplayNames = $Message.AffectedWorkloadDisplayNames -join ','
            AffectedWorkloadNames        = $Message.AffectedWorkloadNames -join ','
        }
    }

    $Exteneded = foreach ($Message in $Test.Value) {
        $Messages = $Message.Messages
        foreach ($M in $Messages) {
            [PSCustomObject] @{
                Id                           = $Message.Id
                Title                        = $Message.Title
                ImpactDescription            = $Message.ImpactDescription
                LastUpdatedTime              = $Message.LastUpdatedTime
                MessageType                  = $Message.MessageType
                Status                       = $Message.Status
                Severity                     = $Message.Severity
                StartTime                    = $Message.StartTime
                Message                      = $M.MessageText

                Workload                     = $Message.Workload
                WorkloadDisplayName          = $Message.WorkloadDisplayName
                ActionType                   = $Message.ActionType
                Classification               = $Message.Classification
                EndTime                      = $Message.EndTime
                Feature                      = $Message.Feature
                FeatureDisplayName           = $Message.FeatureDisplayName
                UserFunctionalImpact         = $Message.UserFunctionalImpact
                PostIncidentDocumentUrl      = $Message.PostIncidentDocumentUrl
                AffectedTenantCount          = $Message.AffectedTenantCount
                AffectedUserCount            = $Message.AffectedUserCount
                AffectedWorkloadDisplayNames = $Message.AffectedWorkloadDisplayNames -join ','
                AffectedWorkloadNames        = $Message.AffectedWorkloadNames -join ','
            }
        }
    }

    $Output.MessageCenterInformationSimple = $Simple | & { process { if ($_.MessageType -eq 'MessageCenter' ) { $_ } } }
    $Output.IncidentsSimple = $Simple | & { process { if ($_.MessageType -eq 'Incident' ) { $_ } } }

    $Output.MessageCenterInformation = $Exteneded | & { process { if ($_.MessageType -eq 'MessageCenter' ) { $_ } } }
    $Output.Incidents = $Exteneded | & { process { if ($_.MessageType -eq 'Incident' ) { $_ } } }
    return $Output
}