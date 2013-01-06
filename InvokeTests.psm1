$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

Import-Module (Resolve-RelativePath Announcers.psm1) 
Import-Module (Resolve-RelativePath Model.psm1) 
Import-Module (Resolve-RelativePath ExecutionSandbox.psm1) 


function Invoke-Tests(  [string]                        $Test, 
                        [switch]                        $NoExecute,
                        [Parameter(Mandatory=$true)]    $Announcer
                         )
    {

    function Invoke-Suite( [Parameter(Mandatory=$true)]     $suite, 
                           [Parameter(Mandatory=$true)]     $test, 
                           [Parameter(Mandatory=$true)]     $NoExecute,
                           [Parameter(Mandatory=$true)]     $Announcer )
        {
        Show-Progress $Announcer $Suite
        if ( $suite.BeforeAlls -ne $null )
                {
                foreach( $before in $suite.BeforeAlls ) 
                    {
                    . $MyInvocation.MyCommand.Module $before  | Out-Null
                    }
                }

        Invoke-Tests  $suite -Test $Test -NoExecute:$NoExecute -Announcer $Announcer
        }

    $runPlan = New-SuiteRunPlan -Suite (Get-RootSuite) -Test $Test
    # Show-RunPlan -RunPlan $runPlan
    Start-Progress $Announcer
    Invoke-InSandbox -RunPlan $runPlan -Announcer $Announcer
    Stop-Progress $Announcer
    }

function Show-RunPlan( $RunPlan, [string]$Indent = "" )
    {
    $RunPlan | Select-Object -Property Id,@{Name="Name";Expression={ $Indent + $_.Name } },Type
    foreach( $child in $RunPlan.Children )
        {
        Show-RunPlan -RunPlan $child -Indent ($Indent + "    ")
        }
    }

function New-SuiteRunPlan(  [object]    $Suite = $null,     
                            [string]    $Test,
                            [object]    $Announcer )
    {
    $runPlan = New-Object -Type PSObject -Property @{ 
        Suite   = $Suite
        Test    = $null 
        Befores = @( $Suite.BeforeAlls )
        Id      = $Suite.Id
        Body    = $null
        Type    = "Suite"
        Name    = $Suite.Name
        Children = @() }

    foreach( $testOrSuite in $Suite.Children )
        {
        if ( SuiteMatches -Suite $testOrSuite -Match $Test )
            {
            switch ( $testOrSuite.Type )
                {
                "Suite" { $runPlan.Children += New-SuiteRunPlan -Suite $testOrSuite -Test * }
                "Test"  { $runPlan.Children += New-TestRunPlan -Test $testOrSuite }
                }
            }
        elseif ( $testOrSuite.IsSuite -and ( SuiteChildrenMatch -Suite $testOrSuite -Match $Test ) )
            {
            Invoke-Suite -Suite $testOrSuite  -Test $Test -NoExecute:$NoExecute -Announcer $Announcer
            }
        }
    return $runPlan
    }

function New-TestRunPlan( $Test )
    {
    $context = New-Object PSObject -Property @{
        SuiteLocation = $test.Source
        SuiteDirectory = (Split-Path -Parent $test.Source)
        }

    $parentsChain = Get-SuiteChain $test
    $befores = @( $parentsChain | %{ $_.Befores } )
    $afters = @( $parentsChain | %{ $_.Afters } )
    if ( $afters -ne $null )
        {
        [array]::Reverse( $afters )
        }

    $runPlan = New-Object -Type PSObject -Property @{ 
        Suite = $null
        Test  = $Test 
        Id    = $Test.Id
        Befores = $befores
        Body  = $Test.Definition
        Afters = $afters
        Type  = "Test"
        Name  = $Test.Name
        Children = @() }
    return $runPlan
    }

function SuiteMatches( $Suite, [string] $Match )
    {
    return  `
        $Match -eq "*"  `
        -or $Suite.Id -eq $Match
    }
    
function SuiteChildrenMatch( $Suite, [string] $Match )
    {
    if ( SuiteMatches -Suite $Suite -Match $Match ) 
        {
        return $true
        }

    if ( $Suite.IsSuite )
        {
        foreach( $childSuiteOrTest in $Suite.Children )
            {
            if ( SuiteChildrenMatch $childSuiteOrTest -Match $Match )
                {
                return $true
                }
            }
        }
    return $false
    }

function Invoke-Test( [Parameter(Mandatory=$true)]   $Test,
                      [Parameter(Mandatory=$true)]   $Announcer )
    {
    ( $context, $befores, $afters, $it ) = Prepare-Test $Test

    Show-Progress $Announcer -Test $test 
    $result = Invoke-InSandbox $context $befores $afters $it
    Show-Progress $Announcer -Test $test -Result $result
    }

Export-ModuleMember Invoke-Tests
