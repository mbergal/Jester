$ErrorActionPreference="Stop"
Import-Module (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) ..\..\Jester.psd1 ) 


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