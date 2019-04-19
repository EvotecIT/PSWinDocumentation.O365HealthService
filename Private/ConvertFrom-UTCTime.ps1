function ConvertFrom-UTCTime {
    [CmdLetbinding()]
    param(
        [String] $Time,
        [switch] $ToLocalTime
    )
    $Time = $Time -replace ', at', '' -replace 'UTC', ''
    $TimeZoneBias = (Get-CimInstance -ClassName Win32_TimeZone).Bias
    [DateTime] $Time = [DateTime]::Parse($Time)
    if ($ToLocal) {
        $Time.AddMinutes($TimeZoneBias)
    } else {
        $Time
    }
}