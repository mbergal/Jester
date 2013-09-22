$psake.use_exit_on_error = $tru

properties `
    {
    $buildNumber = 0
    $apikey      = $null
    $nugetServer = $null 
    $rootDir     = $psake.build_script_dir
    $objDir      = Join-Path $rootDir obj
    $buildDir    = Join-Path $rootDir build
    $nuspec      = Join-Path $rootDir Jester.nuspec
    $vendorDir   = Join-Path $rootDir vendor
    $nugetExe    = Join-Path $vendorDir tools\NuGet.exe 
    $nuspec      = Join-Path $rootDir Jester.nuspec
#    $nupkg       = Join-Path $buildDir 
    }

Task default -depends Package

Task Package -depends Make-Nuget

Task Make-Nuget `
    {
    CleanDir $buildDir
    CleanDir $objDir

    $nuspecContent = [xml](Get-Content $nuspec)
    $version = $nuspecContent.package.metadata.version
    $parsed = [System.Version]::Parse( $version )
    $nuspecContent.package.metadata.version = [string]( New-Object -Type System.Version  -ArgumentList $parsed.Major, $parsed.Minor, $buildNumber )

    $nuspecPath = Join-Path $objDir "Jester.nuspec"
    $nuspecContent.Save( $nuspecPath )

    NugetPack -NuSpec $nuspecPath -OutputDirectory $buildDir
    }

Task Test `
    {
    powershell ".\Spec\Spec.ps1;if ( -not ( Invoke-Jester ) ) { exit 1 };"
    }

function CleanDir( [Parameter(Mandatory=$true)][string]  $Directory )
    {
    if ( Test-Path $Directory  ) {
        rmdir $Directory -Recurse
        }

    mkdir $Directory | Out-Null
    }

Task Release -depends  Make-Nuget `
    {
    Assert ($apiKey -ne $null) "apiKey should not be null"
    Assert ($nugetServer -ne $null) "nugetServer should not be null"

    $nupkg = ls ( $buildDir + "\Jester.*.nupkg" )
    . $nugetExe push $nupkg -s $nugetServer $apiKey
    }

function NugetPack( [Parameter(Mandatory=$true)][string] $NuSpec,
                    [Parameter(Mandatory=$true)][string] $OutputDirectory ) 
    {
    & $nugetExe pack $NuSpec -OutputDirectory $OutputDirectory
    }