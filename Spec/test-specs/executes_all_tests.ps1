$ErrorActionPreference="Stop"
Import-Module (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) ..\..\Jester.psd1 ) -Force


Describe "Something" `
    {
    It "Test 1" `
        {
        Write-Host "Test 1"
        }
    It "Test 2" `
        {
        Write-Host "Test 2"
        }
    It "Test 3" `
        {
        Write-Host "Test 3"
        }
    }
    
Invoke-Jester -Test * -NoOutline