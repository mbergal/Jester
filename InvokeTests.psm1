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
    function Invoke-Tests(  [object]    $Suite = $null,     
                            [string]    $Test,
                            [object]    $Announcer
                         )
        {
        foreach( $testOrSuite in $Suite.Children )
            {
            if ( SuiteMatches -Suite $testOrSuite -Match $Test )
                {
                switch ( $testOrSuite.Type )
                    {
                    "Suite"                   
                        {
                        Invoke-Suite -Suite $testOrSuite -Test * -NoExecute:$NoExecute -Announcer $Announcer
                        }
                    "Test" 
                        {
                        Invoke-Test -Test $testOrSuite -Announcer $Announcer
                        }
                    }
                }
            elseif ( $testOrSuite.IsSuite -and ( SuiteChildrenMatch -Suite $testOrSuite -Match $Test ) )
                {
                Invoke-Suite -Suite $testOrSuite  -Test $Test -NoExecute:$NoExecute -Announcer $Announcer
                }
            }
        }

    function Invoke-Suite( [Parameter(Mandatory=$true)]     $suite, 
                           [Parameter(Mandatory=$true)]     $test, 
                           [Parameter(Mandatory=$true)]     $NoExecute,
                           [Parameter(Mandatory=$true)]     $Announcer )
        {
        Show-Progress $Announcer $Suite
        Invoke-Tests  $suite -Test $Test -NoExecute:$NoExecute -Announcer $Announcer
        # Finish-Suite -Suite $suite
        }

    Start-Progress $Announcer
    Invoke-Tests `
        -Suite (Get-RootSuite) `
        -Test $Test `
        -NoExecute:$NoExecute `
        -Announcer $Announcer
    Stop-Progress $Announcer
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

function Prepare-Test( $test, [switch]$NoExecute )
    {
    $context = New-Object PSObject -Property @{
        SuiteLocation = $test.Source
        SuiteDirectory = (Split-Path -Parent $test.Source)
        }

    $SuiteDirectory = Split-Path -Parent $test.Source

    $parentsChain = Get-SuiteChain $test

    $befores = @( $parentsChain | %{ $_.Befores } )
    $afters = @( $parentsChain | %{ $_.Afters } )
    if ( $afters -ne $null )
        {
        [array]::Reverse( $afters )
        }
    $it = $test.Definition
    return @( $context, $befores, $afters, $it )
    }

Export-ModuleMember Invoke-Tests
