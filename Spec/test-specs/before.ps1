Import-Module Jester

Describe "Something" `
    {
        Before `
            {
            Write-Host "Before"
            }
        It "is executed" `
            {
            Write-Host "It"
            }
    }
    
Invoke-Jester -Test *