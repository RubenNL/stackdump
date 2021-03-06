<#
 .SYNOPSIS
 Starts Python with the Stackdump modules in its path.
 .DESCRIPTION
 Starts Python, by using the path specified in the PYTHON_CMD file located in 
 the same directory as this script (create as necessary) or python.exe that
 resolves in the current PATH.
 
 The Python instance will be checked to ensure it is the right version before
 the command is executed.
 
 All parameters given will be passed directly to Python. If none are given, the
 interactive interpreter starts.
 .EXAMPLE
 Start-Python python/src/stackdump/commands/import_site.py
 #>

$ScriptDir = Split-Path $MyInvocation.MyCommand.Path
$PythonCmd = 'python.exe'

if (Test-Path (Join-Path $ScriptDir 'PYTHON_CMD')) {
	$PythonCmd = Get-Content (Join-Path $ScriptDir 'PYTHON_CMD')
}

$AbsPythonCmd = @(Get-Command $PythonCmd -ErrorAction SilentlyContinue)[0].Path
if ($AbsPythonCmd -ne $null) {
	$PythonVer = "$(& $AbsPythonCmd -V 2>&1)".Trim().Split(' ')[1]
	$PythonVerMajor, $PythonVerMinor, $bleh = $PythonVer.Split('.')
	if (($PythonVerMajor -eq '2') -and ($PythonVerMinor -ge '5')) {
		# this is an appropriate version of Python, run it
		Write-Host "Using Python $AbsPythonCmd"
		
		$env:PYTHONPATH="$(Join-Path $ScriptDir 'python/packages');$(Join-Path $ScriptDir 'python/src');$env:PYTHONPATH"
		& $AbsPythonCmd @args
	}
	else {
		Write-Error "Python $PythonVer is not compatible with Stackdump. Use Python 2.5 to 2.7."
	}
}
else {
	Write-Error "Python could not be located. Specify its path using PYTHON_CMD or check the path in PYTHON_CMD."
}
