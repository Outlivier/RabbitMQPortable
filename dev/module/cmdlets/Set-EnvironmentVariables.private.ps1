<#
.SYNOPSIS
	Défines required environment variables for RabbitMQ.
#>
function Set-EnvironmentVariables
{
	[CmdletBinding(SupportsShouldProcess=$false)]
	[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
	[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
	param()

	$env:ERLANG_HOME       = $p_erlang
	$env:RABBITMQ_SERVER   = $p_rabbitmq
	if ($env:PATH -notcontains "RABBITMQ_SERVER")
	{
		$env:PATH += ";%RABBITMQ_SERVER%\sbin"
	}
	$env:RABBITMQ_BASE = $p_rabbitmqdata
}