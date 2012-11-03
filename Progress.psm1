Import-Module (Resolve-RelativePath Model.psm1)

$script:testsRun = 0;
$script:testsFailed = 0;

function Start-Progress()
    {
    $script:testsRun = 0;
    $script:testsFailed = 0;
    $script:testsSucceeded = 0;
    }


function Stop-Progress()    
    {
    Write-Host
    Write-Host "Ran $script:testsRun tests ( $script:testsFailed failed, $script:testsSucceeded succeeded )"
    }


function Show-Progress( $test, [string] $result )    
    {
    if ( $test.IsTest )
        {
        $color = "white"   
        $script:testsRun += 1    
        switch( $result )
            {
            "success" 
                { 
                $script:testsSucceeded += 1; 
                $color = "green";  
                }
            "failure" 
                { 
                $script:testsFailed += 1; 
                $color = "red"; 
                } 
            default { throw "Unknown test result `"$result`"" }
            }

        }
    else 
        {
        $color = "yellow"   
        }
    Write-Host -NoNewLine ([string]::Format( "{0,-10}", $test.Id ))
    Write-Host -Foreground $color ( " " * 4 * (( Get-Level $test) -1 ) ), $test.Name
    }