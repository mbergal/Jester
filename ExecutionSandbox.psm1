$ErrorActionPreference = "Stop"

function Invoke-InSandbox( $context, $befores, $afters, $it )
    {
    $Context = $context
    try {
        if ( $befores -ne $null )
                {
                foreach( $before in $befores ) 
                    {
                    . $MyInvocation.MyCommand.Module $before  | Out-Null
                    }
                }
        }
    catch [System.Exception] 
        {
        Write-Host -Foreground Red $_.Exception.Message
        Write-Host -Foreground Red $_.InvocationInfo.PositionMessage.TrimStart( "`n`r")
        return "failure"
        }

    try {
        . $MyInvocation.MyCommand.Module $it   | Out-Null
        }
    catch [System.Exception]
        {
        Write-Host -Foreground Red $_.Exception.Message
        Write-Host -Foreground Red $_.InvocationInfo.PositionMessage.TrimStart( "`n`r")
        return "failure" 
        }
    

    try {
        if ( $afters -ne $null )
                {
                foreach( $after in $afters ) 
                    {
                    . $MyInvocation.MyCommand.Module $after | Out-Null
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
