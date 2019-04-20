function ConvertFrom-UTCTime {
    [CmdLetbinding()]
    param(
        [Object] $Time,
        [switch] $ToLocalTime
    )
    if ($null -eq $Script:TimeZoneBias) {
        $TimeZoneBias = (Get-CimInstance -ClassName Win32_TimeZone).Bias
    } else {
        $TimeZoneBias = $Script:TimeZoneBias
    }
    if ($Time -is [DateTime]) {
        $ConvertedTime = $Time
    } else {
        if ($null -eq $Time -or $Time -eq '') {
            return
        } else {
            $Time = $Time -replace ', at', '' -replace 'UTC', ''
            [DateTime] $ConvertedTime = [DateTime]::Parse($Time)
        }
    }
    if ($ToLocal) {
        $ConvertedTime.AddMinutes($TimeZoneBias)
    } else {
        $ConvertedTime
    }
}