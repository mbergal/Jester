Import-Module (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) ..\..\Jester.psd1 )

Describe "Suite" `
    {
    It "Test" `
        {
        Write-Host "Test"
        }
    }
    
Invoke-Jester 