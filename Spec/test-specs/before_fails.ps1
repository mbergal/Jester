Import-Module Jester

Describe "Something" `
    {
    Describe "This will fail" `
        {
        Before `
            {
            throw "Before fails"
            }
        It "this is not going to be executed" `
            {
            }
        It "this is not going to be executed too" `
            {
            }
        }
    Describe "This will still work" `
        {
        It "OK" `
            {
            }
        }

    }
    
Invoke-Jester -Test *