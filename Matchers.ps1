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
            throw New-Object JesterFailure( "Thrown exception with message `"$message`"", "Thrown exception with message `"$actualMessage`"" )    
            }
        return
        }
    throw New-Object JesterFailure( "Thrown exception", "No exception was thrown" )    
    }
    
function ShouldBe( [Parameter(ValueFromPipeline=$true)] $actual, [Parameter(Position=0)]$expected )
    {
    $diff = Compare-Object $actual $expected
    if ( $diff ) 
        { throw New-Object JesterFailure( $expected, $actual, ( $diff | Out-String )) }
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

