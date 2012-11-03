Import-Module (Resolve-RelativePath Api.psm1)
Import-Module (Resolve-RelativePath InvokeTests.psm1)
Import-Module (Resolve-RelativePath Progress.psm1)
Import-Module (Resolve-RelativePath Model.psm1)

. (Resolve-RelativePath Matchers.ps1)
. (Resolve-RelativePath JesterFailure.ps1)


$ErrorActionPreference = "Stop"

function Invoke-Jester( [Parameter(ParameterSetName="Show")][switch] $Show, 
                        [Parameter(ParameterSetName="Test")][string] $Test = "*",
                        [Parameter(ParameterSetName="Test")][switch] $NoExecute = $false,
                        [Parameter(ParameterSetName="Test")][switch] $NoOutline = $false )
    {
    if ( (Get-RootSuite).Children.Length -gt 0 )
        {
        if ( $Show ) 
            {
            Show-Tests
            }
        else
            {
            Invoke-Tests `
                -Suite $null `
                -Test $Test `
                -NoExecute:$NoExecute `
                -NoOutline:$NoOutline
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
