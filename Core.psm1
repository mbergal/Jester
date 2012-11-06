#
# This has been copied from what UofI.Powershell.Tools, 
# it supports much more use cases than I have @
#

$ErrorActionPreference = "Stop"

function Resolve-RelativePath( $path, $invocation )
    {
    $driveName = ''
    if ( -not $ExecutionContext.SessionState.Path.IsPSAbsolute( $path, [ref]$driveName  ) -and -not $path.StartsWith( "\\" ) ) # special case for UNC paths
        {
        if ( $invocation -eq $null ) {
            $invocation = @(Get-PSCallStack)[1].InvocationInfo
            if ( $invocation -eq $null ) # we are calling Resolve-RelativePath from command line
                {
                $invocationPath = (Get-Location).Path
                }
            else
                {
                $invocationPath = Get-InvocationLocation $invocation
                }
            }

        $resolvedPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath( ( Join-Path ( Split-Path -Parent $invocationPath ) $path ) )
        if ( $resolvedPath.EndsWith( "\." ) ) # special case (not really needed, but nice and very common )
            {
            $resolvedPath = $resolvedPath.Substring( 0, $resolvedPath.Length - 2 )
            }
        return $resolvedPath
        }
    else
        {
        return  $path       
        }
    }

Import-Module (Resolve-RelativePath Api.psm1)
Import-Module (Resolve-RelativePath InvokeTests.psm1)
Import-Module (Resolve-RelativePath Progress.psm1)
Import-Module (Resolve-RelativePath Model.psm1)

. (Resolve-RelativePath Matchers.ps1)
. (Resolve-RelativePath JesterFailure.ps1)


function Invoke-Jester
    {
    [CmdletBinding(DefaultParameterSetName="Test")]
    param( [Parameter(ParameterSetName="Show")][switch] $Show, 
           [Parameter(ParameterSetName="Test")][string] $Test = "*",
           [Parameter(ParameterSetName="Test")][switch] $NoExecute = $false,
           [Parameter(ParameterSetName="Test")][switch] $NoOutline = $false )

    if ( $NoOutline )
        {
        $announcer = New-NullAnnouncer
        }
    else
        {
        $announcer = New-ConsoleAnnouncer
        }

    if ( (Get-RootSuite).Children.Length -gt 0 )
        {
        if ( $Show ) 
            {
            Show-Tests
            }
        else
            {
            Invoke-Tests `
                -Test $Test `
                -NoExecute:$NoExecute `
                -Announcer $announcer
            }
        }
    else
        {
        throw "No suites defined"
        }
    }

function Show-Tests
    {
    $tests = Get-SuiteStructure (Get-RootSuite) | Select-Object Level, Id, Type, Name, Source 
    $tests | Select-Object Id, @{Name="Name"; Expression={ "   " * ( $_.Level - 1 ) + $_.Name } } | ft -Property Id,  Name -AutoSize
    }

Export-ModuleMember After
Export-ModuleMember Before
Export-ModuleMember Invoke-Jester
Export-ModuleMember Describe
Export-ModuleMember It
Export-ModuleMember ShouldBe
Export-ModuleMember ShouldBeTrue
