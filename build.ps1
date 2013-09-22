param( [string] $Task, $properties  )

Write-Host "!$properties!"
$thisDir = (Split-Path -Parent $PSCommandPath)
. "$thisDir\vendor\tools\nuget.exe" Install "$thisDir\vendor\packages.config" -o "$thisDir\vendor\packages"
. "$thisDir\vendor\packages\psake.4.2.0\tools\psake.ps1" build.psake.ps1 -Task $task -Properties $properties -scriptPath "$thisDir\vendor\packages\psake.4.2.0\tools"