$ErrorActionPreference="Stop"
Import-Module (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) ..\..\Jester.psd1 ) -Force


Describe "Something" `
    {
        Before `
            {
            Write-Host "Before"
            }
        It "is executed" `
            {
            Write-Host "It"
            }
    }
    
Invoke-Jester -Test * -NoOutline