powershell ".\Spec.ps1;if ( Invoke-Jester %* ) { exit 0 } else { exit 1 };"
echo %ERRORLEVEL%