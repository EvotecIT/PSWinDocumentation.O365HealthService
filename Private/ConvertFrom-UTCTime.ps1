function ConvertFrom-UTCTime {
    [CmdLetbinding()]
    param(
        [Object] $Time,
        [switch] $ToLocalTime
    )
    if ($null -eq $Script:TimeZoneBias) {
        try {
            $TimeZoneBias = (Get-TimeZone -ErrorAction Stop).BaseUtcOffset.TotalMinutes
        } catch {
            Write-Warning "ConvertFrom-UTCTime - couldn't get timezone. Please report on GitHub."
            $TimeZoneBias = 0
        }
    } else {
        $TimeZoneBias = $Script:TimeZoneBias
    }
    if ($Time -is [DateTime]) {
        $ConvertedTime = $Time
    } else {
        if ($null -eq $Time -or $Time -eq '') {
            return
        } else {
            $NewTime = $Time -replace ', at', '' -replace 'UTC', '' -replace 'at' -replace '(^.+?,)'
            try {
                [DateTime] $ConvertedTime = [DateTime]::Parse($NewTime)
            } catch {
                Write-Warning "ConvertFrom-UTCTime - couldn't convert time. Please report on GitHub - $Time. Skipping conversion..."
                return $Time
            }
        }
    }
    if ($ToLocal) {
        $ConvertedTime.AddMinutes($TimeZoneBias)
    } else {
        $ConvertedTime
    }
}