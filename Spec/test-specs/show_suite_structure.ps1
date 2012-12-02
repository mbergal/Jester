$ErrorActionPreference="Stop"
Import-Module (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) ..\..\Jester.psd1 )


Describe "Outer Suite" `
    {
    Describe "Inner Suite" `
        {
        It "Test" `
            {
            }
        }
    }
    
Invoke-Jester -Show