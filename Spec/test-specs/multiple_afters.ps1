$ErrorActionPreference="Stop"
Import-Module (Join-Path (Split-Path -Parent $PSCommandPath) ..\..\src\Jester.psd1 ) -Force



Describe "Outer" `
    {
        After `
            {
            Write-Host "Outer After"
            }
    Describe "Inner" `
        {
        After `
            {
            Write-Host "Inner After"
            }
        It "is executed" `
            {
            Write-Host "It"
            }
        }
    }
    
Invoke-Jester -Test * -NoOutline