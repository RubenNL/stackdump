<#
 .SYNOPSIS
 Starts the Stackdump web server.
 .DESCRIPTION
 Starts the Stackdump web server, using the Start-Python.ps1 script.
 
 No parameters are accepted.
 .EXAMPLE
 Start-StackdumpWeb
 #>

$ScriptDir = Split-Path $MyInvocation.MyCommand.Path

# ensure the data directory exists
if (-not (Test-Path (Join-Path $ScriptDir 'data'))) {
	mkdir (Join-Path $ScriptDir 'data')
}

& "$ScriptDir\Start-Python.ps1" "$ScriptDir\python\src\stackdump\app.py"
