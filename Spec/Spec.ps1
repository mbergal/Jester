$ErrorActionPreference = "Stop"

Import-Module (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) ..\Jester.psd1 )

Describe "Jester" {
    Before {
        function Invoke-Test( $path, [object] $Expected = $null, [object] $Contains = $null )
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
                
                }
            Describe "And tests are specified with wildcard" {
                It "executes suites and tests matching wildcard" {
                    }
                }
            }
        }
        

    Describe "Test Fixtures" {
        Describe "When before is specified" {
            It "it is executed before test" {
                Invoke-Test '.\test-specs\before.ps1' -Expected  @( "Before", "It" )
                }
            }
        Describe "When before is specified in multiple nested suites" -Id "mbe" {
            It "it is executed before test" {
                Invoke-Test '.\test-specs\multiple_befores.ps1' -Expected  @( "Outer Before", "Inner Before", "It" )
                }
            }
        Describe "When before fails" {
            It "Following befores do not get executed" {
                Invoke-Test '.\test-specs\before_fails.ps1'  -Contains @( "Next suite is executed" )
                }
            It "Suites inside suite that contains failing before are not executed" {
                Invoke-Test '.\test-specs\before_fails.ps1'  -Contains @( "Next suite is executed" )
                }
            It "Tests inside suites are not executed and considered failed" {
                Invoke-Test '.\test-specs\before_fails.ps1'  -Contains @( "Next suite is executed" )
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
}
