function Invoke-InSandbox( $context, $befores, $afters, $it )
    {
    # $befores |  %{ @( "-- before --", $_ ) } | Out-Host
    # $it      |  %{ @( "-- it ---", $_ ) } | Out-Host

    try {
        if ( $befores -ne $null )
                {
                foreach( $before in $befores ) 
                    {
                    . $MyInvocation.MyCommand.Module $before
                    }
                }
        }
    catch [System.Exception] 
        {
        Write-Host -Foreground Red $_.Exception.Message
        Write-Host -Foreground Red $_.InvocationInfo.PositionMessage.TrimStart( "`n`r")
        return "failure"
        }

    . $MyInvocation.MyCommand.Module $it

    try {
        if ( $afters -ne $null )
                {
                foreach( $after in $afters ) 
                    {
                    . $MyInvocation.MyCommand.Module $after
                    }
                }
        }
    catch [System.Exception] 
        {
        Write-Host -Foreground Red $_.Exception.Message
        Write-Host -Foreground Red $_.InvocationInfo.PositionMessage.TrimStart( "`n`r")
        }


    return "success"
    }

Export-ModuleMember Invoke-InSandbox
