Describe "Add-Numbers" {
    Before {
        . "$SuiteDirectory\Add-Numbers.ps1"
        }

    It "adds positive numbers" -Block {
        $sum = Add-Numbers 2 3
        $sum | Should-Be 5
    }

    It "adds negative numbers" {
        $sum = Add-Numbers (-2) (-2)
        $sum | Should-Be -4
    }

    It "adds one negative number to positive number" {
        $sum = Add-Numbers (-2) 2
        $sum | Should-Be 0
    }

    It "concatenates strings if given strings" {
        $sum = Add-Numbers two three
        $sum | Should-Be "twothree"
    }

}



# Import-Module Jester; Add-Numbers.Tests.ps1 | Invoke-Jester -Show   