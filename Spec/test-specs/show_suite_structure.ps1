Import-Module Jester

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