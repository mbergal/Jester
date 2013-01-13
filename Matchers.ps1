$ErrorActionPreference = "Stop"

function ShouldThrow( [Parameter(ValueFromPipeline=$True)][scriptblock] $block, [string]$message = '' )
    {
    try {
        & $block
        }
    catch
        {
        $exception = $global:Error[0]
        $actualMessage = $exception.Exception.Message
        if ( -not [string]::IsNullOrEmpty( $message ) -and $message -ne $actualMessage )
            {
            throw New-Object JesterFailure( "Thrown exception with message `"$message`"", "Thrown exception with message `"$actualMessage`"", $null )    
            }
        return
        }
    throw New-Object JesterFailure( "Thrown exception", "No exception was thrown", $null )    
    }
    
function ShouldBe( [Parameter(ValueFromPipeline=$true)] $actual, [Parameter(Position=0)]$expected )
    {
    if ( $actual -eq $null -and $expected -eq $null )
        {}
    elseif ( $actual -eq $null -or $expected -eq $null ) 
        {
        throw New-Object JesterFailure( 
            (Convert-ToStringRepresenation $expected), 
            (Convert-ToStringRepresenation $actual), 
            "" );
        }
    else 
        {
        $diff = Compare-Object $actual $expected
        if ( $diff )
            { 
            throw New-Object JesterFailure( 
                (Convert-ToStringRepresenation $expected), 
                (Convert-ToStringRepresenation  $actual), 
                ( $diff | Out-String ) ) 
            }
        }
    }

function Convert-ToStringRepresenation( $object )
    {
    if ( $object -is "Object[]" )
        {
        "@( "
        $first = $true
        foreach( $item in $object )
            {
            if ( -not $first ) { ", " }
            Convert-ToStringRepresenation $item  
            $first = $false
            }
        ")"
        }
    elseif ( $object -is "string" )
        {
        "'" + $object + "'"
        }
    else 
        {
        $object;
        }
    }

function ShouldContain( [Parameter(ValueFromPipeline=$true)] $actual, [string]  $substring )
    {
    if ( -not ( ([string]$actual).Contains( $substring ) ) )
        { throw New-Object JesterFailure( "To contain $substring", "`"$actual`" didn't contain `"$substring`"", "" )}
    return $actual
    }

function ShouldBeTrue(  [Parameter(ValueFromPipeline=$true)] $actual )
    {
    if ( -not $actual )
        { throw New-Object JesterFailure( $true, $actual, "" ) }
    return $actual
    }

function Should-Not-Be( [Parameter(ValueFromPipeline=$true)] $actual, [Parameter(Position=0)]$expected )
    {
    if ( $actual -eq $expected ) 
        { throw New-Object JesterFailure( "not $expected", $actual ) }
    }

function Should-Be-Null( [Parameter(ValueFromPipeline=$true)] $actual )
    {
    if ( $actual -ne $null ) 
        { throw New-Object JesterFailure( "null", "$actual" ) }
    }

function Should-Not-Be-Null( [Parameter(ValueFromPipeline=$true)] $actual )
    {
    if ( $actual -eq $null ) 
        { throw New-Object JesterFailure( "not null", "null" ) }
    }

function Should-Exist( [Parameter(ValueFromPipeline=$true)] $actual )
    {
    if (-not (Test-Path $actual)) 
		{ throw New-Object JesterFailure("$actual should exist","$actual not found")}
    }

function Should-Not-Exist( [Parameter(ValueFromPipeline=$true)] $actual )
    {
    if (Test-Path $actual) 
		{ throw New-Object JesterFailure("$actual should not exist","$actual was found")}
    }

