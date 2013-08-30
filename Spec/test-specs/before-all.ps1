$ErrorActionPreference="Stop"
Import-Module (Join-Path (Split-Path -Parent $PSCommandPath) ..\..\src\Jester.psd1 ) -Force


Describe "Outer" `
    {
    Before -All `
        {
        Write-Host "Before -All Outer"
        }

    Describe "Inner" `
        {
        Before -All `
            {
            Write-Host "Before -All Inner"
            }
        It "is executed 1" `
            {
            Write-Host "It 1"
            }
        It "is executed 2" `
            {
            Write-Host "It 2"
            }
        }
    }
    
Invoke-Jester -Test * -NoOutline