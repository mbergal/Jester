$ErrorActionPreference = "Stop"

Import-Module (Resolve-RelativePath Model)

function Describe( [Parameter(Mandatory=$true)][string]     $Name, 
                   [Parameter(Mandatory=$true)][scriptblock] $Block, 
                                                            $Id = $null )
    {
    $parentSuite = Get-CurrentSuite
    $newSuite = New-Suite `
        -Id         $Id `
        -Name       $Name `
        -Definition $Block `
        -Parent     $parentSuite `
        -Source     @( Get-PSCallStack )[1].ScriptName

    Set-CurrentSuite $newSuite

    Add-Suite  $parentSuite $script:currentSuite

    . $Block;


    Set-CurrentSuite $parentSuite
    }

function It( [Parameter(Mandatory=$true)][string]      $Name, 
             [Parameter(Mandatory=$true)][scriptblock] $Block, 
                                                       $Id = $null )
    {
    Add-Test (Get-CurrentSuite) (New-Test `
                                        -Id         $Id `
                                        -Name       $Name `
                                        -Definition $Block `
                                        -Parent     $script:currentSuite `
                                        -Source     @( Get-PSCallStack )[1].ScriptName)
    }

function Before( [scriptblock] $Block )
    {
    (Get-CurrentSuite).Befores += $Block
    }

function After( [scriptblock] $Block )
    {
    (Get-CurrentSuite).Afters += $Block
    }

function Set-CurrentSuite( $suite )
    {
    $script:currentSuite = $suite;
    }

function Get-CurrentSuite()
    {
    return $script:currentSuite;
    }

$script:currentSuite = Get-RootSuite

Export-ModuleMember Describe
Export-ModuleMember Before
Export-ModuleMember After
Export-ModuleMember It