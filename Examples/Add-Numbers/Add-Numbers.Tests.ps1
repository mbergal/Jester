$ErrorActionPreference = "Stop"
Import-Module (Join-Path (Split-Path -Parent $PSCommandPath) ..\..\Src\Jester.psd1 )

Describe "Add-Numbers" {
    Before -All {
        Write-Host "before all"
        Mock Get-Date { Write-Host "AA" }
        }

    Before {
        . ((Split-Path -Parent $PSCommandPath) + "\Add-Numbers.ps1")
        }

    It "adds positive numbers" -Block {
        $sum = Add-Numbers 2 3
        $sum | ShouldBe 5
        Get-Date
    }

    It "adds negative numbers" {
        $sum = Add-Numbers (-2) (-2)
        $sum | ShouldBe -4
        Get-Date
    }

    It "adds one negative number to positive number" {
        $sum = Add-Numbers (-2) 2
        $sum | ShouldBe 0
        Get-Date
    }

    It "concatenates strings if given strings" {
        $sum = Add-Numbers two three
        $sum | ShouldBe "twothree"
    }

}



Invoke-Jester 