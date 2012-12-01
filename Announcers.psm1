$ErrorActionPreference = "Stop"

Import-Module (Resolve-RelativePath Model.psm1)

$script:testsRun = 0;
$script:testsFailed = 0;
$script:outputAtTestStart = @();

function Start-Progress( [Parameter(Mandatory=$true)] $This )
    {
    & ($This.StartProgress) 
    }

function Stop-Progress( [Parameter(Mandatory=$true)] $This )
    {
    & ($This.StopProgress) 
    }

function Show-Progress( [Parameter(Mandatory=$true)] $This, $Test, [string] $Result  )
    {
    & ($This.ShowProgress) -Test $Test -Result $Result
    }

function New-ConsoleAnnouncer()
    {
    return New-Object PSObject -Property @{
        StartProgress = `
            {
            $script:testsRun = 0;
            $script:testsFailed = 0;
            $script:testsSucceeded = 0;
            }
        StopProgress = `
            {
            Write-Host
            Write-Host "Ran $script:testsRun tests ( $script:testsFailed failed, $script:testsSucceeded succeeded )"
            }
        ShowProgress = `
            {
            param( $test, [string] $result );
            if ( $test.IsTest )
                {
                switch( $result )
                    {
                    "success" 
                        {
                        $t = Get-Content "t"
                        Stop-Transcript | Out-Null
                        if ( $null -eq (Compare-Object $script:outputAtTestStart $t ) )
                            {
                            [console]::SetCursorPosition( 0, [console]::CursorTop - 1 );
                            }
                        $script:testsSucceeded += 1; 
                        Write-TestLine -Test $test -Color Green
                        }
                    "failure" 
                        { 
                        $t = Get-Content "t"
                        Stop-Transcript | Out-Null
                        if ( $null -eq (Compare-Object $script:outputAtTestStart $t ) )
                            {
                            [console]::SetCursorPosition( 0, [console]::CursorTop - 1 );
                            }
                        
                        $script:testsFailed += 1; 
                        Write-TestLine -Test $test -Color Red
                        } 
                    ""
                        {
                        $color = 'White'
                        $script:testsRun += 1    
                        Write-TestLine -Test $test -Color White
                        Start-Transcript "t" | Out-Null
                        $script:outputAtTestStart = Get-Content "t";                        
                        }
                    default { throw "Unknown test result `"$result`"" }
                    }

                }
            else 
                {
                Write-TestLine -Test $test -Color Yellow
                }
            }
        }
    }

function Write-TestLine( [Parameter(Mandatory=$true)]           $Test, 
                         [Parameter(Mandatory=$true)][string]   $Color,
                         [string]                               $Result )
    {
    Write-Host -NoNewLine ([string]::Format( "{0,-10}", $Test.Id ))
    Write-Host -Foreground $color ( " " * 4 * ( (Get-Level $Test) -1 ) ), $Test.Name 
    }


function New-NullAnnouncer()
    {
    return New-Object PSObject -Property @{
        StartProgress = `
            {
            }
        StopProgress = `
            {
            }
        ShowProgress = `
            {
            param( $test, [string] $result );
            }
        }
    }
