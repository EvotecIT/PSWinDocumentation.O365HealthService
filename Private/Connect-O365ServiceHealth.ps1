function Connect-O365ServiceHealth {
    param(
        [string][alias('ClientID')] $ApplicationID,
        [string][alias('ClientSecret')] $ApplicationKey,
        [string] $TenantDomain
    )
    $Body = @{
        grant_type    = "client_credentials"
        resource      = "https://manage.office.com"
        client_id     = $ApplicationID
        client_secret = $ApplicationKey
    }

    $Authorization = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($TenantDomain)/oauth2/token?api-version=1.0" -Body $body

    if ($Authorization) {
        @{'Authorization' = "$($Authorization.token_type) $($Authorization.access_token)"}
    } else {
        $null
    }
}