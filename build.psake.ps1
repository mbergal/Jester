$psake.use_exit_on_error = $tru

properties `
    {
    $rootDir    = $psake.build_script_dir
    $buildDir   = Join-Path $rootDir build
    $nuspec     = Join-Path $rootDir Jester.nuspec
    $vendorDir  = Join-Path $rootDir vendor
    $nugetExe  =  Join-Path $vendorDir tools\NuGet.exe 
    }

Task default -depends Package

Task Package -depends Make-Nuget

Task Make-Nuget `
    {
    CleanDir $buildDir
    NugetPack -NuSpec $rootDir\Jester.nuspec -OutputDirectory $buildDir
    }

function CleanDir( [Parameter(Mandatory=$true)][string]  $Directory )
    {
    if ( Test-Path $Directory  ) {
        rmdir $Directory -Recurse
        }

    mkdir $Directory | Out-Null
    }

function NugetPack( [Parameter(Mandatory=$true)][string] $NuSpec,
                    [Parameter(Mandatory=$true)][string] $OutputDirectory ) 
    {
    & $nugetExe pack $NuSpec -OutputDirectory $OutputDirectory
    }