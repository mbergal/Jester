Import-Module (Join-Path (Split-Path -Parent $PSCommandPath) ..\..\src\Jester.psd1 ) -Force

Describe "Suite" `
    {
    It "Test" `
        {
        Write-Host "Test"
        }
    }
    
Invoke-Jester 