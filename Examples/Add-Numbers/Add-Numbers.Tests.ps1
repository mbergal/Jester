Import-Module (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) ..\..\Jester.psd1 )

Describe "Add-Numbers" {
    Before {
        . ($Context.SuiteDirectory + "\Add-Numbers.ps1")
        }

    It "adds positive numbers" -Block {
        $sum = Add-Numbers 2 3
        $sum | ShouldBe 5
    }

    It "adds negative numbers" {
        $sum = Add-Numbers (-2) (-2)
        $sum | ShouldBe -4
    }

    It "adds one negative number to positive number" {
        $sum = Add-Numbers (-2) 2
        $sum | ShouldBe 0
    }

    It "concatenates strings if given strings" {
        $sum = Add-Numbers two three
        $sum | ShouldBe "twothree"
    }

}



Invoke-Jester 