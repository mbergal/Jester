$ErrorActionPreference = "Stop"

Import-Module (Resolve-RelativePath Progress.psm1)
Import-Module (Resolve-RelativePath Model.psm1) 
Import-Module (Resolve-RelativePath ExecutionSandbox.psm1)


function Invoke-Tests(  [string]    $Test, 
                        [switch]    $NoExecute,
                        [switch]    $NoOutline
                         )
    {
    function Invoke-Tests(  [object]    $Suite = $null,     
                            [string]    $Test
                         )
        {
        foreach( $testOrSuite in $Suite.Children )
            {
            switch ( $testOrSuite.Type )
                {
                "Suite"                   
                    {
                    $suite = $testOrSuite
                    if ( Test-Suite -Suite $suite  -Contains $Test )
                        {
                        Invoke-Suite -Suite $suite  -Test $Test -NoExecute:$NoExecute -NoOutline:$NoOutline
                        }
                    }
                "Test" 
                    {
                    Invoke-Test $testOrSuite -NoOutline:$NoOutline
                    }
                }
            }
        }

    function Invoke-Suite( $suite, $test, $NoExecute, $NoOutline )
        {
        Start-Suite -Suite $suite
        Invoke-Tests  $suite -Test $Test -NoExecute:$NoExecute -NoOutline:$NoOutline
        Finish-Suite -Suite $suite
        }

    function Start-Suite( [Parameter(Mandatory=$true)] $Suite )
        {
        if ( -not $NoOutline )
            {
            Show-Progress $Suite
            }
        }

    function Finish-Suite( [Parameter(Mandatory=$true)] $Suite )
        {
        }

    if ( -not $NoOutline ) { Start-Progress }
    Invoke-Tests `
        -Suite (Get-RootSuite) `
        -Test $Test `
        -NoExecute:$NoExecute
    if ( -not $NoOutline ) { Stop-Progress }
    }

function Test-Suite( $Suite, [string] $Contains )
    {
    $testOrSuiteName = $Suite.Name
    if ( $Suite.Name -eq $Contains `
        -or $Contains -eq "*" `
        -or $Suite.Id -eq $Contains ) 
        { 
        return $true 
        }
    else 
        { 
        if ( $Suite.Children -ne $null )
            {
            foreach( $childSuiteOrTest in $Suite.Children )
                {
                if ( Test-Suite $childSuiteOrTest -Contains $Contains )
                    {
                    return $true;
                    }
                }
            }
        }
    }
    
function Invoke-Test( $Test, $NoOutline )
    {
    ( $context, $befores, $afters, $it ) = Prepare-Test $Test
    $result = Invoke-InSandbox $context $befores $afters $it
    if ( -not $NoOutline )
        {
        Show-Progress $test -Result $result
        }
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
