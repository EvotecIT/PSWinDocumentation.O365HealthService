function Get-Office365ServiceHealthIssues {
    [CmdLetbinding()]
    param(
        [System.Collections.IDictionary] $Authorization
    )
    try {
        $AllMessages = Invoke-Graph -Uri "https://graph.microsoft.com/v1.0/admin/serviceAnnouncement/issues" -Method GET -Headers $Authorization -FullUri
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        Write-Warning -Message "Get-Office365ServiceHealthIssues - Error: $ErrorMessage"
        return
    }
    $Output = @{ }
    $Output.Incidents = foreach ($Message in $AllMessages) {
        [PSCustomObject] @{
            Id              = $Message.Id
            Title           = $Message.Title
            Impact          = $Message.impactDescription
            IsResolved      = $Message.IsResolved
            # HighImpact      = $Message.highImpact
            Classification  = $Message.classification
            Origin          = $Message.origin
            Service         = $Message.service
            LastUpdatedTime = $Message.lastModifiedDateTime
            LastUpdatedDays = Convert-TimeToDays -StartTime $Message.lastModifiedDateTime -EndTime $Script:Today
            Status          = $Message.status
            Feature         = $Message.feature
            FeatureGroup    = $Message.featureGroup
            NotifyInApp     = ($Message.details | Where-Object { $_.Name -eq 'NotifyInApp' }).Value -eq $true
            UpdatesCount    = $Message.posts.count
        }
    }
    $Output.IncidentsExtended = foreach ($Message in $AllMessages) {
        [PSCustomObject] @{
            Id              = $Message.Id
            Title           = $Message.Title
            Impact          = $Message.impactDescription
            IsResolved      = $Message.IsResolved
            # HighImpact      = $Message.highImpact
            Classification  = $Message.classification
            Origin          = $Message.origin
            Service         = $Message.service
            LastUpdatedTime = $Message.lastModifiedDateTime
            LastUpdatedDays = Convert-TimeToDays -StartTime $Message.lastModifiedDateTime -EndTime $Script:Today
            Status          = $Message.status
            Feature         = $Message.feature
            FeatureGroup    = $Message.featureGroup
            NotifyInApp     = ($Message.details | Where-Object { $_.Name -eq 'NotifyInApp' }).Value -eq $true
            UpdatesCount    = $Message.posts.count
            Updates         = $Message.Posts | ForEach-Object {
                $Object = [ordered] @{}
                foreach ($SubMessage in $_.description.content.Split("`n")) {
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
                    } elseif ($SubMessage -like 'Root cause: *') {
                        $Object.RootCause = $SubMessage -replace 'Root cause: ', ''
                    } elseif ($SubMessage -like 'Next update by: *') {
                        $Time = ($SubMessage -replace 'Next update by: ', '').Trim()
                        $Object.NextUpdateBy = ConvertFrom-UTCTime -Time $Time -ToLocalTime:$ToLocalTime
                    } elseif ($SubMessage -like 'Final status: *') {
                        $Object.FinalStatus = ($SubMessage -replace 'Final status: ', '').Trim()
                    } else {
                        $Object.Other = $SubMessage.Trim()
                    }
                }
                [PSCustomObject] @{
                    Id                   = $Message.Id
                    Service              = $Message.service
                    Created              = $_.createdDateTime
                    Type                 = $_.postType
                    Title                = $Object.Title
                    UserImpact           = $Object.UserImpact
                    MoreInfo             = $Object.MoreInfo
                    CurrentStatus        = $Object.CurrentStatus
                    ScopeOfImpact        = $Object.ScopeOfImpact
                    StartTime            = $Object.StartTime
                    PreliminaryRootCause = $Object.PreliminaryRootCause
                    RootCause            = $Object.RootCause
                    FinalStatus          = $Object.FinalStatus
                    NextUpdateBy         = $Object.NextUpdateBy
                    Other                = $Object.Other
                }
            }
        }
    }
    $Output.IncidentsUpdates = foreach ($Message in $Output.IncidentsExtended) {
        foreach ($Post in $Message.Updates) {
            $Post
        }
    }
    $Output
}