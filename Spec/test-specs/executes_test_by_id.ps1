$ErrorActionPreference="Stop"
Import-Module (Join-Path (Split-Path -Parent $PSCommandPath) ..\..\src\Jester.psd1 )

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
    

Invoke-Jester -Test 1.2 -NoOutline
