<#
.SYNOPSIS
	Stop RabbitMQ portable.
#>
function Stop-Portable
{
	[CmdletBinding(SupportsShouldProcess=$false)]
	[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
	param()

	&$p_rabbitmq_rabbitmqctlBAT stop

	# Wait that process erl close
	Write-Verbose "Waiting erl process end..."
	while (Test-Erlang)
	{
		Start-Sleep -Seconds 1
	}

	# The proces "empd" is not closed by the stop command
	Get-Process | ? { ($_.name -eq "epmd") -and $_.Path.StartsWith($p_erlang) } | Stop-Process | Out-Null
}