function Get-Office365ServiceHealthMessages {
    [CmdLetbinding()]
    param(
        [System.Collections.IDictionary] $Authorization
    )
    try {
        $AllMessages = Invoke-Graphimo -Uri "https://graph.microsoft.com/v1.0/admin/serviceAnnouncement/messages" -Method GET -Headers $Authorization -FullUri
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
            LastUpdatedTime          = if ($Message.lastModifiedDateTime) { [DateTime]::Parse($Message.lastModifiedDateTime) } else { $null }
            LastUpdatedDays          = Convert-TimeToDays -StartTime $Message.lastModifiedDateTime -EndTime $Script:Today
            ActionRequiredByDateTime = if ( $Message.actionRequiredByDateTime) { [DateTime]::Parse($Message.actionRequiredByDateTime) } else { $null }
            ActionRequiredDays       = if ($ActionRequiredDays -eq 0) { $null } else { - $ActionRequiredDays }
            Tags                     = $Message.Tags
            RoadmapId                = ($Message.details | Where-Object { $_.name -eq 'roadmapids' }).Value
            Category                 = $Message.category
        }
    }
    $Output.MessageCenterInformationExtended = foreach ($Message in $AllMessages) {
        $ActionRequiredDays = Convert-TimeToDays -StartTime $Message.actionRequiredByDateTime -EndTime $Script:Today
        [PSCustomObject] @{
            Id                       = $Message.Id
            Title                    = $Message.Title
            Service                  = $Message.services
            LastUpdatedTime          = if ($Message.lastModifiedDateTime) { [DateTime]::Parse($Message.lastModifiedDateTime) } else { $null }
            LastUpdatedDays          = Convert-TimeToDays -StartTime $Message.lastModifiedDateTime -EndTime $Script:Today
            ActionRequiredByDateTime = if ($Message.actionRequiredByDateTime) { [DateTime]::Parse($Message.actionRequiredByDateTime) } else { $null }
            ActionRequiredDays       = if ($ActionRequiredDays -eq 0) { $null } else { - $ActionRequiredDays }
            Tags                     = $Message.Tags
            Bloglink                 = ($Message.details | Where-Object { $_.name -eq 'bloglink' }).Value
            RoadmapId                = ($Message.details | Where-Object { $_.name -eq 'roadmapids' }).Value
            RoadmapIdLinks           = ($Message.details | Where-Object { $_.name -eq 'roadmapids' }).Value | ForEach-Object {
                "https://www.microsoft.com/en-us/microsoft-365/roadmap?filters=&searchterms=$_"
            }
            Category                 = $Message.category
            IsMajorChange            = $Message.isMajorChange
            Severity                 = $Message.Severity
            StartTime                = If ($Message.startDateTime) { [DateTime]::Parse($Message.startDateTime) } else { $null }
            EndTime                  = if ($Message.endDateTime) { [DateTime]::Parse($Message.endDateTime) } else { $null }
            Message                  = $Message.body.content
        }
    }
    $Output
}