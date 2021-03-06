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

    Add-Suite  $parentSuite (Get-CurrentSuite)

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

function Before( [scriptblock] $Block, [switch]$All = $false )
    {
    if ( $All ) 
        {
        (Get-CurrentSuite).BeforeAlls += $Block
        }
    else 
        {
        (Get-CurrentSuite).Befores += $Block    
        }
    }

function After( [scriptblock] $Block )
    {
    (Get-CurrentSuite).Afters += $Block
    }

Export-ModuleMember Describe
Export-ModuleMember Before
Export-ModuleMember After
Export-ModuleMember It