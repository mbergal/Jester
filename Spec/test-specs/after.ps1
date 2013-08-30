$ErrorActionPreference="Stop"
Import-Module (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) ..\..\src\Jester.psd1 ) -Force

Describe "Something" `
    {
        After `
            {
            Write-Host "After"
            }
        It "is executed" `
            {
            Write-Host "It"
            }
    }
    
Invoke-Jester -Test * -NoOutline