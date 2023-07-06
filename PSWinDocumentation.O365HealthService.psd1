@{
    AliasesToExport      = @()
    Author               = 'Przemyslaw Klys'
    CmdletsToExport      = @()
    CompanyName          = 'Evotec'
    CompatiblePSEditions = @('Desktop', 'Core')
    Copyright            = '(c) 2011 - 2023 Przemyslaw Klys @ Evotec. All rights reserved.'
    Description          = 'Office 365 Health Service'
    FunctionsToExport    = 'Get-Office365Health'
    GUID                 = '5879b6ed-e0da-4815-ad68-d345253bfe54'
    ModuleVersion        = '1.0.4'
    PowerShellVersion    = '5.1'
    PrivateData          = @{
        PSData = @{
            Tags       = @('Windows', 'Office365', 'O365', 'PSWinDocumentation', 'HealthService', 'Linux', 'Osx')
            IconUri    = 'https://evotec.xyz/wp-content/uploads/2018/10/PSWinDocumentation.png'
            ProjectUri = 'https://github.com/EvotecIT/PSWinDocumentation.O365HealthService'
        }
    }
    RequiredModules      = @(@{
            ModuleName    = 'PSSharedGoods'
            ModuleVersion = '0.0.264'
            Guid          = 'ee272aa8-baaa-4edf-9f45-b6d6f7d844fe'
        }, @{
            ModuleName    = 'Graphimo'
            ModuleVersion = '0.0.18'
            Guid          = '48605140-a2a9-44f3-b682-3efc5cc9f2c1'
        })
    RootModule           = 'PSWinDocumentation.O365HealthService.psm1'
}