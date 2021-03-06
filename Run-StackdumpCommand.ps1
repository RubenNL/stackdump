<#
 .SYNOPSIS
 Executes a Stackdump management command.
 .DESCRIPTION
 Executes the Stackdump management command specified using the -Command 
 parameter (or implicitly via the first positional parameter). All 
 remaining arguments are passed to the management command.
 
 This cmdlet uses the Start-Python cmdlet to execute the commands, so Python 
 needs to be able to be located for this cmdlet to work.
 
 Use the List-StackdumpCommands cmdlet to see the possible commands.
 .EXAMPLE
 Run-StackdumpCommand download_site_info
 #>
 param(
 	[Parameter(Mandatory=$true, Position=1)][string]$Command,
	[Parameter(ValueFromRemainingArguments=$true)][String[]]$CommandArgs
)

$ScriptDir = Split-Path $MyInvocation.MyCommand.Path
$CommandsDir = Join-Path $ScriptDir 'python\src\stackdump\commands'

$CommandPath = Join-Path $CommandsDir "$Command.py"

if (Test-Path $CommandPath) {
	& "$ScriptDir\Start-Python.ps1" $CommandPath @CommandArgs
}
else {
	Write-Error "The command '$Command' could not be found. Use List-StackdumpCommands to see a list of valid commands."
}
