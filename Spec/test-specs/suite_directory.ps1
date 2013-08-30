$ErrorActionPreference="Stop"
Import-Module (Join-Path (Split-Path -Parent $PSCommandPath) ..\..\src\Jester.psd1 ) -Force

Describe "Outer Suite" `
    {
    Describe "Inner Suite" `
        {
        It "Test" `
            {
            Write-Host "`$Context.SuiteDirectory=", $Context.SuiteDirectory
            }
        }
    }
    
Invoke-Jester -NoOutline