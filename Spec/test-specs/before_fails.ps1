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
            Write-Host "Not executed It"
            }
        It "this is not going to be executed too" `
            {
            Write-Host "Not executed It 2"
            }
        }
    Describe "This will still work" `
        {
        It "OK" `
            {
            Write-Host "Next suite is executed"
            }
        }
    }
    
Invoke-Jester -Test * -NoOutline