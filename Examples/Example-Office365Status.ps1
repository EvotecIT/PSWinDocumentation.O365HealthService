Import-Module PSWinDocumentation.O365HealthService -Force

$ApplicationID = ''
$ApplicationKey = ''
$TenantDomain = 'evotec.pl'

$O365 = Get-Office365Health -ApplicationID $ApplicationID -ApplicationKey $ApplicationKey -TenantDomain $TenantDomain
$O365