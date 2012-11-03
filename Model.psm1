function New-Suite( [string]        $Id, 
                    [string]        $Name,
                    [scriptblock]   $Definition, 
                                    $Parent )
    {
    return New-Object PSObject -Property @{ Type       = "Suite"
                                            Id         = $Id
                                            DefaultId  = ""
                                            Name       = $Name
                                            Definition = $Definition
                                            Parent     = $Parent
                                            Children   = @() 
                                            Afters     = @()
                                            Befores    = @() 
                                            IsTest     = $false
                                            IsSuite    = $true
                                            }
    }

function New-Test( [string]      $Id, 
                   [string]      $Name, 
                   [scriptblock] $Definition,
                                 $Parent,
                   [parameter(mandatory=$true)][string] $Source )
    {
    return New-Object PSObject -Property @{ Type       = "Test"
                                            Id         = $Id
                                            DefaultId  = ""
                                            Name       = $Name
                                            Definition = $Definition
                                            Source     = $Source
                                            Parent     = $Parent 
                                            IsTest     = $true
                                            IsSuite    = $false
                                            };
    }

function Add-Suite( $parent, $child )
    {
    $parent.Children += $child
    $child.Parent = $parent
    $child.DefaultId = New-DefaultId $child
    if ( [string]::IsNullOrEmpty( $child.Id ) )
        {
        $child.Id = $child.DefaultId
        }
    }

function Add-Test( $parent, $child )
    {
    $parent.Children += $child
    $child.Parent = $parent
    $child.DefaultId = New-DefaultId $child
    if ( [string]::IsNullOrEmpty( $child.Id ) )
        {
        $child.Id = $child.DefaultId
        }
    }

function New-DefaultId( $child )
    {
    $parent = $child.Parent
    if ( [string]::IsNullOrEmpty( $parent.DefaultId ) )
        {
        return (Get-ChildIndex $child).ToString()
        }
    else 
        {
        return $parent.DefaultId + "." + (Get-ChildIndex $child)
        }
    }

function Get-ChildIndex( $child )
    {
    return [array]::IndexOf( $child.Parent.Children, $child ) + 1
    }

function Get-RootSuite()
    {
    return $script:rootSuite;
    }


function Get-SuiteStructure( $suite )
    {
    $suite | Select-SuiteStructure
    foreach( $child in $suite.Children )
        {
        switch ( $child.Type )
            {
            "Suite" { 
                    Get-SuiteStructure -Suite $child -Level $level +1
                    }
            "Test"  {
                    $child | Select-TestStructure   
                    }
            }
        }
    }

function Get-Level( $child )
    {
    $level = 0
    $parent = $child.Parent;
    while ( $parent -ne $null )
        {
        $level += 1
        $parent = $parent.Parent
        }
    return $level;
    }

function Get-SuiteChain( $suite )
    {
    $chain = @();
    while ( $suite.Parent -ne $null )
        {
        $chain += $suite.Parent;
        $suite = $suite.Parent;
        }
    [array]::reverse( $chain );
    return $chain;
    }

function Select-SuiteStructure( [parameter(ValueFromPipeline=$true)]$suite )
    {
    $suite | Select-Object  @{ Name="Level"; Expression={ Get-Level $_} }, `
                            Type, `
                            Id, `
                            Name, `
                            Definition, `
                            Parent, `
                            Source `
    }


function Select-TestStructure( [parameter(ValueFromPipeline=$true)]$test )
    {
    $test | Select-Object @{ Name="Level"; Expression={ Get-Level $_} }, `
                          Type, `
                          Id, `
                          Name, `
                          Definition, `
                          Parent, `
                          Source 

    }

function Is-Test( $testOrSuite )
    {
    return $testOrSuite.Type -eq "Test"
    }

function Is-Suite( $testOrSuite )
    {
    return $testOrSuite.Type -eq "Suite"
    }

$script:rootSuite = New-Suite 

Export-ModuleMember New-Suite
Export-ModuleMember Add-Suite
Export-ModuleMember New-Test
Export-ModuleMember Add-Test
Export-ModuleMember Get-RootSuite
Export-ModuleMember Get-Level
Export-ModuleMember Get-SuiteChain

