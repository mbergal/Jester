Import-Module Jester

Describe "Something" `
    {
        After `
            {
            Write-Host "After"
            }
        It "is executed" `
            {
            Write-Host "It"
            }
    }
    
Invoke-Jester -Test * -NoOutline