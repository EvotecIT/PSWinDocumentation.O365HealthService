function Get-Office365ServiceHealthMessages {
    [CmdLetbinding()]
    param(
        [System.Collections.IDictionary] $Authorization,
        [string] $TenantDomain,
        [switch] $ToLocalTime
    )
    $AllMessages = (Invoke-RestMethod -Uri "https://manage.office.com/api/v1.0/$($TenantDomain)/ServiceComms/Messages" -Headers $Authorization -Method Get)

    $Output = @{}
    $Simple = foreach ($Message in $AllMessages.Value) {
        $LastUpdatedTime = ConvertFrom-UTCTime -ToLocalTime:$ToLocalTime -Time $Message.LastUpdatedTime
        [PSCustomObject][ordered] @{
            Id                      = $Message.Id
            Title                   = $Message.Title
            ImpactDescription       = $Message.ImpactDescription
            LastUpdatedTime         = $LastUpdatedTime
            LastUpdatedDaysAgo      = Convert-TimeToDays -StartTime $LastUpdatedTime -EndTime $Script:Today
            MessageType             = $Message.MessageType
            Status                  = $Message.Status
            Severity                = $Message.Severity
            StartTime               = ConvertFrom-UTCTime -ToLocalTime:$ToLocalTime -Time $Message.StartTime

            #Workload                     = $Message.Workload
            Workload                = $Message.WorkloadDisplayName
            ActionType              = $Message.ActionType
            Classification          = $Message.Classification
            EndTime                 = ConvertFrom-UTCTime -ToLocalTime:$ToLocalTime -Time $Message.EndTime
            #Feature                      = $Message.Feature
            Feature                 = $Message.FeatureDisplayName
            UserFunctionalImpact    = $Message.UserFunctionalImpact
            PostIncidentDocumentUrl = $Message.PostIncidentDocumentUrl
            AffectedTenantCount     = $Message.AffectedTenantCount
            AffectedUserCount       = $Message.AffectedUserCount
            AffectedWorkload        = $Message.AffectedWorkloadDisplayNames -join ','
            #AffectedWorkloadNames        = $Message.AffectedWorkloadNames -join ','
        }
    }

    $Extended = foreach ($Message in $AllMessages.Value) {
        $Messages = $Message.Messages
        foreach ($M in $Messages) {
            $LastUpdatedTime = ConvertFrom-UTCTime -ToLocalTime:$ToLocalTime -Time $Message.LastUpdatedTime
            $PublishedTime = ConvertFrom-UTCTime -ToLocalTime:$ToLocalTime -Time $M.PublishedTime
            [PSCustomObject][ordered] @{
                Id                      = $Message.Id
                Title                   = $Message.Title
                ImpactDescription       = $Message.ImpactDescription
                LastUpdatedTime         = $LastUpdatedTime
                LastUpdatedDaysAgo      = Convert-TimeToDays -StartTime $LastUpdatedTime -EndTime $Script:Today
                MessageType             = $Message.MessageType
                Status                  = $Message.Status
                Severity                = $Message.Severity
                StartTime               = ConvertFrom-UTCTime -Time $Message.StartTime -ToLocalTime:$ToLocalTime
                Message                 = $M.MessageText
                PublishedTime           = ConvertFrom-UTCTime -ToLocalTime:$ToLocalTime -Time $M.PublishedTime
                PublishedDaysAgo        = Convert-TimeToDays -StartTime $PublishedTime -EndTime $Script:Today
                #Workload                     = $Message.Workload
                Workload                = $Message.WorkloadDisplayName
                ActionType              = $Message.ActionType
                Classification          = $Message.Classification
                EndTime                 = ConvertFrom-UTCTime -ToLocalTime:$ToLocalTime -Time $Message.EndTime
                #Feature                      = $Message.Feature
                Feature                 = $Message.FeatureDisplayName
                UserFunctionalImpact    = $Message.UserFunctionalImpact
                PostIncidentDocumentUrl = $Message.PostIncidentDocumentUrl
                AffectedTenantCount     = $Message.AffectedTenantCount
                AffectedUserCount       = $Message.AffectedUserCount
                AffectedWorkload        = $Message.AffectedWorkloadDisplayNames -join ','
                #AffectedWorkloadNames        = $Message.AffectedWorkloadNames -join ','
            }
        }
    }

    # Below this point ConvertFrom-UTCTime is not needed as rest of data is built on code above


    # Simplified Message Center
    $MessageCenterInformationSimple = foreach ($_ in $Simple) {
        if ($_.MessageType -eq 'MessageCenter') { $_ }
    }
    $Output.MessageCenterInformationSimple = foreach ($_ in $MessageCenterInformationSimple) {
        [PSCustomObject][ordered] @{
            ID                 = $_.ID
            Title              = $_.Title
            LastUpdatedTime    = $_.LastUpdatedTime
            LastUpdatedDaysAgo = $_.LastUpdatedDaysAgo
            Severity           = $_.Severity
            StartTime          = $_.StartTime
            EndTime            = $_.EndTime
            ActionType         = $_.ActionType
            Classification     = $_.Classification
            AffectedService    = $_.AffectedWorkload
            MessageType        = $_.MessageType
        }
    }
    # More information Message Center
    $MessageCenterInformation = foreach ($_ in $Extended) {
        if ($_.MessageType -eq 'MessageCenter') { $_ }
    }
    $Output.MessageCenterInformation = foreach ($_ in $MessageCenterInformation) {
        [PSCustomObject][Ordered] @{
            ID                 = $_.ID
            PublishedTime      = $_.PublishedTime
            PublishedDaysAgo   = $_.PublishedDaysAgo
            Title              = $_.Title
            Message            = $_.Message
            LastUpdatedTime    = $_.LastUpdatedTime
            LastUpdatedDaysAgo = $_.LastUpdatedDaysAgo
            Severity           = $_.Severity
            StartTime          = $_.StartTime
            EndTime            = $_.EndTime
            ActionType         = $_.ActionType
            Classification     = $_.Classification
            AffectedService    = $_.AffectedWorkload
            MessageType        = $_.MessageType
        }
    }

    # Simplified Message Center
    $IncidentsSimple = foreach ($_ in $Simple) {
        if ($_.MessageType -eq 'Incident') { $_ }
    }
    $Output.IncidentsSimple = foreach ($_ in $IncidentsSimple) {
        [PSCustomObject][ordered] @{
            Service                 = $_.Workload
            Feature                 = $_.Feature
            ID                      = $_.ID
            Title                   = $_.Title
            ImpactDescription       = $_.ImpactDescription
            LastUpdatedTime         = $_.LastUpdatedTime
            LastUpdatedDaysAgo      = $_.LastUpdatedDaysAgo
            UserFunctionalImpact    = $_.UserFunctionalImpact
            PostIncidentDocumentUrl = $_.PostIncidentDocumentUrl
            Severity                = $_.Severity
            StartTime               = $_.StartTime
            EndTime                 = $_.EndTime
            #ActionType        = $_.ActionType
            Classification          = $_.Classification
            #AffectedService         = $_.AffectedWorkload
            AffectedTenantCount     = $_.AffectedTenantCount
            AffectedUserCount       = $_.AffectedUserCount
            MessageType             = $_.MessageType
        }
    }
    # More information Message Center
    $Incidents = foreach ($_ in $Extended) {
        if ($_.MessageType -eq 'Incident') { $_ }
    }
    $Output.Incidents = foreach ($_ in $Incidents) {
        [PSCustomObject][Ordered] @{
            Service                 = $_.Workload
            Feature                 = $_.Feature
            ID                      = $_.ID
            Title                   = $_.Title
            ImpactDescription       = $_.ImpactDescription
            PublishedTime           = $_.PublishedTime
            PublishedDaysAgo        = $_.PublishedDaysAgo
            Message                 = $_.Message
            LastUpdatedTime         = $_.LastUpdatedTime
            LastUpdatedDaysAgo      = $_.LastUpdatedDaysAgo
            UserFunctionalImpact    = $_.UserFunctionalImpact
            PostIncidentDocumentUrl = $_.PostIncidentDocumentUrl
            Severity                = $_.Severity
            StartTime               = $_.StartTime
            EndTime                 = $_.EndTime
            #ActionType        = $_.ActionType
            Classification          = $_.Classification
            #AffectedService         = $_.AffectedWorkload
            AffectedTenantCount     = $_.AffectedTenantCount
            AffectedUserCount       = $_.AffectedUserCount
            MessageType             = $_.MessageType
        }
    }

    $Output.Messages = foreach ($Entry in $Extended) {
        $LimitedEntry = foreach ($_ in $Entry) { if ($_.MessageType -eq 'Incident') { $_ }} # Faster Where-Object
        foreach ($_ in $LimitedEntry) {
            $Object = [PsCustomObject][Ordered] @{
                Service              = $_.Workload
                Status               = $_.Status
                PublishedTime        = $_.PublishedTime
                PublishedDaysAgo     = $_.PublishedDaysAgo
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
            foreach ($SubMessage in $_.Message.Split([Environment]::NewLine)) {
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
                    $Object.StartTime = ConvertFrom-UTCTime -Time $Time -ToLocalTime:$ToLocalTime
                } elseif ($SubMessage -like 'Preliminary root cause: *') {
                    $Object.PreliminaryRootCause = $SubMessage -replace 'Preliminary root cause: ', ''
                } elseif ($SubMessage -like 'Next update by: *') {
                    $Time = ($SubMessage -replace 'Next update by: ', '').Trim()
                    $Object.NextUpdateBy = ConvertFrom-UTCTime -Time $Time -ToLocalTime:$ToLocalTime
                } elseif ($SubMessage -like 'Final status: *') {
                    $Object.FinalStatus = ($SubMessage -replace 'Final status: ', '').Trim()
                } else {
                    $Object.Other = $SubMessage.Trim()
                }
            }
            $Object
        }
    }
    #$Output.IncidentsSimple = foreach ($_ in $Simple) { if ($_.MessageType -eq 'Incident') { $_ }}
    #$Output.Incidents = foreach ($_ in $Extended) { if ($_.MessageType -eq 'Incident') { $_ }}

    $Output.PlannedMaintenanceSimple = foreach ($_ in $Simple) { if ($_.MessageType -eq 'PlannedMaintenance') { $_ }}
    $Output.PlannedMaintenance = foreach ($_ in $Extended) { if ($_.MessageType -eq 'PlannedMaintenance') { $_ }}
    return $Output
}