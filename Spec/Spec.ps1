$ErrorActionPreference = "Stop"

Import-Module (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) ..\Jester.psd1 )

Describe "Jester" {
    Before {
        function Invoke-Test( $path, [object] $Expected = $null, [object] $Contains = $null, [object] $NotContains = $null )
            {
            $result =  & powershell.exe $path
            if ( $Expected -ne $null )
                {
                (,$result) | ShouldBe $Expected    
                }
            if ( $Contains -ne $null )
                {
                $result | Where-Object { $_ -eq $Contains } | Measure | Select-Object { $_.Count -ge 1 }  | ShouldBeTrue
                }
            if ( $NotContains -ne $null )
                {
                $result | Where-Object { $_ -eq $NotContains } | Measure | Select-Object { $_.Count -eq 0 }  | ShouldBeTrue
                }
            }
        }

    Describe "Invocation" {
        Before {
            }
        
        Describe "When invoked with -Show" {
            It "Shows suite structure" {
                Invoke-Test '.\test-specs\show_suite_structure.ps1' 
                }
            }

        Describe "When invoked with -Test" {
            It "Executes tests" {
                throw "Not implemented"                
                }
            Describe "And tests are specified with wildcard" {
                It "executes suites and tests matching wildcard" {
                    throw "Not implemented"
                    }
                }
            }
        }
        

    Describe "Test Fixtures" {
        Describe "Before" `
            {
            Describe "When before is specified" {
                It "it is executed before test" {
                    Invoke-Test '.\test-specs\before.ps1' -Expected  @( "Before", "It" )
                    }
                }
            Describe "When before is specified in multiple nested suites" -Id "mbe" {
                It "It is executed before test" {
                    Invoke-Test '.\test-specs\multiple_befores.ps1' -Expected  @( "Outer Before", "Inner Before", "It" )
                    }
                }
            Describe "When before fails" {
                It "Following befores do not get executed" {
                    Invoke-Test '.\test-specs\before_fails.ps1'  -NotContains @( "Not executed Before" )
                    }
                It "Tests inside suites with failed befores are not executed" {
                    Invoke-Test '.\test-specs\before_fails.ps1'  -NotContains @( "Not executed It" )
                    }
                It "Other suites are executed" {
                    Invoke-Test '.\test-specs\before_fails.ps1'  -Contains @( "Next suite is executed" )
                    }
                }
            }

        Describe "After" `
            {
            Describe "When after is specified" {
                It "it is executed after test" {
                    Invoke-Test '.\test-specs\after.ps1'  -Expected @( "It", "After" )
                    }
                }
            Describe "When after is specified in multiple nested suites" {
                It "it is executed in the sequence from inner suite to outer suite" {
                    throw "Not implemented"
                    }
                }
            Describe "When after fails" {
                It "it is executed before test" {
                    throw "Not implemented"
                    }
                }
            }

        Describe "Context" `
            {
            It "It should have `$Context.SuiteDirectory pointing to directory where suite file is located" `
                {
                Invoke-Test '.\test-specs\suite_directory.ps1'  -NotContains "$Context.SuiteDirectory= "
                }
            }
        }

    Describe "Execution" `
        {
        Describe "When test fails" `
            {
            It "Should be shown as failed" `
                {
                Invoke-Test '.\test-specs\failed_test.ps1' | ShouldContain "1.1            Test [Failed]"
                }
            It "Should be counted in failed tests" `
                {
                Invoke-Test '.\test-specs\failed_test.ps1' | ShouldContain "Ran 1 tests ( 1 failed, 0 succeeded )"
                }
            }
        }

    Describe "Matchers" `
        {
        Describe "ShouldBe" `
            {
            It "Should match `$null and `$null" `
                {
                $null | ShouldBe $null
                }
            It "Should not match `$null and  not `$null" `
                {
                ShouldThrow { $null | ShouldBe 1 }
                ShouldThrow { 1 | ShouldBe $null }
                }
            }

        Describe "ShouldContain" `
            {
            It "Should match if substring is contained in actual" `
                {
                "Abc" | ShouldContain -Substring "bc"
                }
            It "Should not match if substring is not contained in actual" `
                {
                ShouldThrow { "Abc" | ShouldContain -Substring "bce" }
                }
            }

        Describe "ShouldThrow" `
            {
            It "Should match if exception is thrown" `
                {
                $exceptionThrown = $false
                try {
                    ShouldThrow { throw "Error" }       
                    }
                catch
                    {
                    $exceptionThrown = $true
                    }
                -not $exceptionThrown | ShouldBeTrue
                }

            It "Should not match if no exception is thrown" `
                {
                $exceptionThrown = $false
                try {
                    ShouldThrow {}       
                    }
                catch
                    {
                    $exceptionThrown = $true
                    }
                $exceptionThrown | ShouldBeTrue
                }
            }
        }
}
