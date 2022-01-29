function Connect-O365ServiceHealth {
    [CmdLetbinding()]
    param(
        [string][alias('ClientID')] $ApplicationID,
        [string][alias('ClientSecret')] $ApplicationKey,
        [string] $TenantDomain,
        [switch] $TlsDefault
    )
    $Body = @{
        grant_type    = "client_credentials"
        scope         = "https://graph.microsoft.com/.default"
        client_id     = $ApplicationID
        client_secret = $ApplicationKey
    }
    try {
        if (-not $TlsDefault) {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        }
        $Authorization = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($TenantDomain)/oauth2/v2.0/token" -Body $body -ErrorAction Stop
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        Write-Warning -Message "Connect-O365ServiceHealth - Error: $ErrorMessage"
    }
    if ($Authorization) {
        @{'Authorization' = "$($Authorization.token_type) $($Authorization.access_token)" }
    } else {
        $null
    }
}