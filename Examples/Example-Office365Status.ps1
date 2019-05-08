Import-Module PSWinDocumentation.O365HealthService -Force

$ApplicationID = ''
$ApplicationKey = ''
$TenantDomain = 'evotec.pl' # CustomDomain (onmicrosoft.com won't work), alternatively you can use DirectoryID

$O365 = Get-Office365Health -ApplicationID $ApplicationID -ApplicationKey $ApplicationKey -TenantDomain $TenantDomain
$O365