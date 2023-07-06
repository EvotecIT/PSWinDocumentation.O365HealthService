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
            #Write-Verbose -Message "ConvertFrom-UTCTime - Converting time: $Time"
            $NewTime = $Time -replace ', at', '' -replace ' by', '' -replace 'UTC', '' -replace ' at', ''
            $NewTIme = $NewTime -replace 'Monday,', '' -replace 'Tuesday,', '' -replace 'Wednesday,', '' -replace 'Thursday,', '' -replace 'Friday,', '' -replace 'Saturday,', '' -replace 'Sunday,', ''
            try {
                [DateTime] $ConvertedTime = [DateTime]::Parse($NewTime)
            } catch {
                Write-Warning "ConvertFrom-UTCTime - couldn't convert time $Time (after conversion $NewTime). Exception: $($_.Exception.Message). Skipping conversion..."
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