Import-Module Jester

Describe "Outer" `
    {
        Before `
            {
            Write-Host "Outer Before"
            }
    Describe "Inner" `
        {
        Before `
            {
            Write-Host "Inner Before"
            }
        It "is executed" `
            {
            Write-Host "It"
            }
        }
    }
    
Invoke-Jester -Test * -NoOutline