Import-Module Jester

Describe "Something" `
    {
        After `
            {
            throw "After fails"
            }
        It "is executed" `
            {
            Write-Host "It"
            }
    }
    
Invoke-Jester -Test *