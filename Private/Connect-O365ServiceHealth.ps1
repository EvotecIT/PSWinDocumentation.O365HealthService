function Connect-O365ServiceHealth {
    [cmdletBinding(DefaultParameterSetName = 'ClearText')]
    param(
        [parameter(Mandatory, ParameterSetName = 'Encrypted')]
        [parameter(Mandatory, ParameterSetName = 'ClearText')][string][alias('ClientID')] $ApplicationID,
        [parameter(Mandatory, ParameterSetName = 'ClearText')][string][alias('ClientSecret')] $ApplicationKey,
        [parameter(Mandatory, ParameterSetName = 'Encrypted')][string][alias('ClientSecretEncrypted')] $ApplicationKeyEncrypted,
        [parameter(Mandatory, ParameterSetName = 'Credential')][PSCredential] $Credential,

        [parameter(Mandatory, ParameterSetName = 'Encrypted')]
        [parameter(Mandatory, ParameterSetName = 'ClearText')]
        [parameter(Mandatory, ParameterSetName = 'Credential')]
        [string] $TenantDomain
    )

    $connectGraphSplat = @{
        ApplicationID           = $ApplicationID
        ApplicationKey          = $ApplicationKey
        ApplicationKeyEncrypted = $ApplicationKeyEncrypted
        Credential              = $Credential
        TenantDomain            = $TenantDomain
        Resource                = 'https://graph.microsoft.com/.default'
    }
    Remove-EmptyValue -Hashtable $connectGraphSplat
    Connect-Graph @connectGraphSplat
}