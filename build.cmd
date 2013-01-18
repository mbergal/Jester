@%~dp0vendor\tools\nuget.exe Install %~dp0vendor\packages.config -o %~dp0vendor\packages
@%~dp0vendor\packages\psake.4.2.0\tools\psake.cmd build.psake.ps1 %*