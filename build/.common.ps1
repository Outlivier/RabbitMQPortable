<#
.SYNOPSIS
	Script dot sourced by all build scripts.
#>


<#
|| Preferences
#>
$global:ErrorActionPreference = "Stop"
if ($Verbose) { $global:VerbosePreference = "Continue" }
$global:InformationPreference = "Continue"
$nl = [System.Environment]::NewLine

<#
|| Paths
#>
$p_r0               = Split-Path $PSScriptRoot
$p_deploy           = "$p_r0\deploy"
$p_dev              = "$p_r0\dev"
$p_dev_versionsPSD1 = "$p_r0\dev\versions.psd1"
$p_dev_erl_bin_INI  = "$p_r0\dev\erlang\bin\erl.ini"
$p_dev_module       = "$p_r0\dev\module"
$p_dev_module_PSD1  = "$p_r0\dev\module\RabbitMQPortable.psd1"
$p_dev_rabbitmqdata = "$p_r0\dev\rabbitmq-data"
$p_lib              = "$p_r0\lib"
$p_lib_modulesPSD1  = "$p_r0\lib\modules.psd1"

<#
|| Trap
#>
function Write-Trap
{
	[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "")]
	[CmdletBinding()]
	param()

	# On définit ErrorActionPreference à stop, ce qui veut dire que le script sera arrêté sur toute erreur non gérée.
	# Si le script n'a pas été lancé avec -noexit (comportement par défaut de PowerShell), on fait un pause
	# pour éviter que la console ne se ferme tout de suite sans que l'utilisateur ait le temps de lire l'erreur.
	# Malheureusement, et c'est un bug de PowerShell, cela ne fonctionne pas dans les fichiers dot-sourcés.
	Write-Host -ForegroundColor Red "An error was trapped : "
	Write-Host -ForegroundColor Red -BackgroundColor Black  "$($Error[0] | Out-String)"
	Pause
}

<#
|| Writes
#>
function Write-Step
{
	[CmdletBinding()]
	param
	(
		[parameter(Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
		$Message,
		[switch]$NoNewline
	)
	PROCESS
	{
		Write-Host
		Write-Host ('─' * 50) -ForegroundColor DarkCyan
		Write-Host $Message -NoNewline:$NoNewline -ForegroundColor DarkCyan
	}
}

function Write-Result
{
	[CmdletBinding()]
	param
	(
		[parameter(Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
		$Message,
		[switch]$NoNewline
	)
	PROCESS
	{
		Write-Host $Message -NoNewline:$NoNewline -ForegroundColor Green
	}
}