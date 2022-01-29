function Get-Office365ServiceHealthMessages {
    [CmdLetbinding()]
    param(
        [System.Collections.IDictionary] $Authorization
    )
    try {
        $AllMessages = Invoke-Graph -Uri "https://graph.microsoft.com/v1.0/admin/serviceAnnouncement/messages" -Method GET -Headers $Authorization -FullUri

        #$AllMessages = (Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/admin/serviceAnnouncement/messages" -Headers $Authorization -Method Get)
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        Write-Warning -Message "Get-Office365ServiceHealthMessages - Error: $ErrorMessage"
        return
    }
    $Output = @{ }
    $Output.MessageCenterInformation = foreach ($Message in $AllMessages) {
        $ActionRequiredDays = Convert-TimeToDays -StartTime $Message.actionRequiredByDateTime -EndTime $Script:Today
        [PSCustomObject] @{
            Id                       = $Message.Id
            Title                    = $Message.Title
            Service                  = $Message.services
            LastUpdatedTime          = $Message.lastModifiedDateTime
            LastUpdatedDays          = Convert-TimeToDays -StartTime $Message.lastModifiedDateTime -EndTime $Script:Today
            ActionRequiredByDateTime = $Message.actionRequiredByDateTime
            ActionRequiredDays       = if ($ActionRequiredDays -eq 0) { $null } else { $ActionRequiredDays }
            Tags                     = $Message.Tags
            Roadmap                  = ($Message.details | Where-Object { $_.name -eq 'roadmapids' }).Value
            Category                 = $Message.category
        }
    }
    $Output.MessageCenterInformationExtended = foreach ($Message in $AllMessages) {
        [PSCustomObject] @{
            Id                       = $Message.Id
            Title                    = $Message.Title
            Service                  = $Message.services
            LastUpdatedTime          = $Message.lastModifiedDateTime
            LastUpdatedDays          = Convert-TimeToDays -StartTime $Message.lastModifiedDateTime -EndTime $Script:Today
            ActionRequiredByDateTime = $Message.actionRequiredByDateTime
            ActionRequiredDays       = if ($ActionRequiredDays -eq 0) { $null } else { $ActionRequiredDays }
            Tags                     = $Message.Tags
            Roadmap                  = ($Message.details | Where-Object { $_.name -eq 'roadmapids' }).Value
            Category                 = $Message.category
            IsMajorChange            = $Message.isMajorChange
            Severity                 = $Message.Severity
            StartTime                = $Message.startDateTime
            EndTime                  = $Message.endDateTime
            Bloglink                 = ($Message.details | Where-Object { $_.name -eq 'bloglink' }).Value
            Message                  = $Message.body.content
            ViewPoint                = $Message.viewPoint
        }
    }
    $Output
}