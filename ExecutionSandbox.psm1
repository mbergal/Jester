$ErrorActionPreference = "Stop"
Import-Module (Resolve-RelativePath Announcers.psm1)
   
function Invoke-InSandbox( [Parameter(Mandatory=$true)]  $RunPlan,
                           [Parameter(Mandatory=$true)]  $Announcer )
    {
    $befores    = $RunPlan.Befores 
    $afters     = $RunPlan.Afters
    $Context    = $RunPlan.context
    $body       = $RunPlan.Body
    $children   = $RunPlan.Children
    $test       = $RunPlan.Test
    
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

    if ( $body )
        {
        Show-Progress $Announcer -Test $test 

        try {
            . $MyInvocation.MyCommand.Module $body   | Out-Null 
            }
        catch [System.Exception]
            {
            Write-Host -Foreground Red $_.Exception.Message
            Write-Host -Foreground Red $_.InvocationInfo.PositionMessage.TrimStart( "`n`r")
            Show-Progress $Announcer -Test $test -Result "failure"
            }
        Show-Progress $Announcer -Test $test -Result "success"
        }



    foreach ( $child in $children )
        {
        Invoke-InSandbox -RunPlan $child -Announcer $Announcer
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
    }

Export-ModuleMember Invoke-InSandbox
