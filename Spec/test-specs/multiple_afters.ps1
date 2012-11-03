Import-Module Jester

Describe "Outer" `
    {
        After `
            {
            Write-Host "Outer After"
            }
    Describe "Inner" `
        {
        After `
            {
            Write-Host "Inner After"
            }
        It "is executed" `
            {
            Write-Host "It"
            }
        }
    }
    
Invoke-Jester -Test *