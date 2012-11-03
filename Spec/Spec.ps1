$ErrorActionPreference = "Stop"

Import-Module (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) ..\Jester.psd1 )

Describe "Invocation" {
    Before {
        }
    
    Describe "When invoked with -Show" {
        It "Shows suite structure" {
            
            }
        }

    Describe "When invoked with -Test" {
        It "Executes tests" {
            
            }
        Describe "And tests are specified with wildcard" {
            It "executes suites and tests matching wildcard" {
                }
            }
        }
    }
    

Describe "Test Fixtures" {
    Before {
        function Invoke-Test( $path, $expectedOutput )
            {
            (,($result = & powershell.exe $path)) | ShouldBe $expectedOutput
            }
        }
    Describe "When before is specified" {
        It "it is executed before test" {
            Invoke-Test '.\test-specs\before.ps1'  @( "Before", "It" )
            }
        }
    Describe "When before is specified in multiple nested suites" -Id "mbe" {
        It "it is executed before test" {
            Invoke-Test '.\test-specs\multiple_befores.ps1'  @( "Outer Before", "Inner Before", "It" )
            }
        }
    Describe "When before fails" -Id bfa {
        Before {
            throw "Before fails"
            }
        It "it is executed before test" {
            }
        }
    Describe "When after is specified" {
        It "it is executed before test" {
            }
        }
    Describe "When after is specified in multiple nested suites" {
        It "it is executed before test" {
            }
        }
    Describe "When after fails" {
        It "it is executed before test" {
            }
        }
    }


