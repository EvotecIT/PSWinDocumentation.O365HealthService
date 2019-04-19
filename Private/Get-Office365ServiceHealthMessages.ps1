function Get-Office365ServiceHealthMessages {
    param(
        [System.Collections.IDictionary] $Authorization,
        [string] $TenantDomain
    )
    $AllMessages = (Invoke-RestMethod -Uri "https://manage.office.com/api/v1.0/$($TenantDomain)/ServiceComms/Messages" -Headers $Authorization -Method Get)

    $Output = @{}
    $Simple = foreach ($Message in $AllMessages.Value) {
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

    $Exteneded = foreach ($Message in $AllMessages.Value) {
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
                PublishedTime                = $M.PublishedTime

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

    $Messages = foreach ($Entry in $Exteneded) {
        $LimitedEntry = foreach ($_ in $Entry) { if ($_.MessageType -eq 'Incident') { $_ }} # Faster Where-Object
        foreach ($Message in $LimitedEntry.Message) {
            $Object = [PsCustomObject] @{
                Service              = $LimitedEntry.WorkloadDisplayName
                Status               = $LimitedEntry.Status
                PublishedTime        = ConvertFrom-UTCTime -Time $LimitedEntry.PublishedTime -ToLocalTime
                Title                = ''
                UserImpact           = ''
                MoreInfo             = ''
                CurrentStatus        = ''
                ScopeOfImpact        = ''
                StartTime            = ''
                PreliminaryRootCause = ''
                NextUpdateBy         = ''
                FinalStatus          = ''
                Other                = ''
            }
            foreach ($SubMessage in $Message.Split([Environment]::NewLine)) {
                # | Where-Object {  ($_).Trim() -ne '' }) {
                if ($SubMessage -like 'Title: *') {
                    $Object.Title = $SubMessage -replace 'Title: ', ''
                } elseif ($SubMessage -like 'User Impact: *') {
                    $Object.UserImpact = $SubMessage -replace 'User Impact: ', ''
                } elseif ($SubMessage -like 'More info: *') {
                    $Object.MoreInfo = $SubMessage -replace 'More info: ', ''
                } elseif ($SubMessage -like 'Current status: *') {
                    $Object.CurrentStatus = $SubMessage -replace 'Current status: ', ''
                } elseif ($SubMessage -like 'Scope of impact: *') {
                    $Object.ScopeOfImpact = $SubMessage -replace 'Scope of impact: ', ''
                } elseif ($SubMessage -like 'Start time: *') {
                    $Time = $SubMessage -replace 'Start time: ', ''
                    $Object.StartTime = ConvertFrom-UTCTime -Time $Time -ToLocalTime
                } elseif ($SubMessage -like 'Preliminary root cause: *') {
                    $Object.PreliminaryRootCause = $SubMessage -replace 'Preliminary root cause: ', ''
                } elseif ($SubMessage -like 'Next update by: *') {
                    $Time = ($SubMessage -replace 'Next update by: ', '').Trim()
                    $Object.NextUpdateBy = ConvertFrom-UTCTime -Time $Time -ToLocalTime
                } elseif ($SubMessage -like 'Final status: *') {
                    $Object.FinalStatus = ($SubMessage -replace 'Final status: ', '').Trim()
                } else {
                    $Object.Other = $SubMessage.Trim()
                }
            }
            $Object
        }
    }
    $Output.MessageCenterInformationSimple = foreach ($_ in $Simple) { if ($_.MessageType -eq 'MessageCenter') { $_ }}
    $Output.MessageCenterInformation = foreach ($_ in $Exteneded) { if ($_.MessageType -eq 'MessageCenter') { $_ }}

    $Output.IncidentsSimple = foreach ($_ in $Simple) { if ($_.MessageType -eq 'Incident') { $_ }}
    $Output.Incidents = foreach ($_ in $Exteneded) { if ($_.MessageType -eq 'Incident') { $_ }}

    $Output.PlannedMaintenanceSimple = foreach ($_ in $Simple) { if ($_.MessageType -eq 'PlannedMaintenance') { $_ }}
    $Output.PlannedMaintenance = foreach ($_ in $Exteneded) { if ($_.MessageType -eq 'PlannedMaintenance') { $_ }}

    $Output.Messages = $Messages
    return $Output
}