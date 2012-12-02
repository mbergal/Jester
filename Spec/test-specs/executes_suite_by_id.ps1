$ErrorActionPreference="Stop"
Import-Module (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) ..\..\Jester.psd1 ) -Force

Describe "Something" `
    {
    Describe "Suite 1" `
        {
        It "Test 1" `
            {
            Write-Host "Suite 1 Test 1"
            }
        It "Test 2" `
            {
            Write-Host "Suite 1 Test 2"
            }
        It "Test 3" `
            {
            Write-Host "Suite 1 Test 3"
            }
        }
    Describe "Suite 2" `
        {
        It "Test 1" `
            {
            Write-Host "Suite 2 Test 1"
            }
        It "Test 2" `
            {
            Write-Host "Suite 2 Test 2"
            }
        It "Test 3" `
            {
            Write-Host "Suite 2 Test 3"
            }
        }
    }

Invoke-Jester -Test 1.2 -NoOutline

