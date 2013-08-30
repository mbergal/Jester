$ErrorActionPreference="Stop"
Import-Module (Join-Path (Split-Path -Parent $PSCommandPath) ..\..\src\Jester.psd1 ) -Force

Describe "Something" `
    {
        After `
            {
            throw "After fails"
            }
        It "is executed" `
            {
            Write-Host "It"
            }
    }
    
Invoke-Jester -Test *