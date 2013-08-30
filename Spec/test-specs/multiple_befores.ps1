$ErrorActionPreference="Stop"
Import-Module (Join-Path (Split-Path -Parent $PSCommandPath) ..\..\src\Jester.psd1 ) -Force

Describe "Outer" `
    {
        Before `
            {
            Write-Host "Outer Before"
            }
    Describe "Inner" `
        {
        Before `
            {
            Write-Host "Inner Before"
            }
        It "is executed" `
            {
            Write-Host "It"
            }
        }
    }
    
Invoke-Jester -Test * -NoOutline