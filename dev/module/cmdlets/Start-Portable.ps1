<#
.SYNOPSIS
	Start RabbitMQ portable.
.PARAMETER Credential
	Credentials to use when logging to RabbitMQ server.
	guest/guest by default.
#>
function Start-Portable
{
	[CmdletBinding(SupportsShouldProcess=$false)]
	[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
	param
	(
		[Parameter(Mandatory=$false)]
		[PSCredential]$Credential = $RabbitMQGuest
	)

	if (Test-Erlang)
	{
		Write-Information "RabbitMQ portable already started."
	}
	else
	{
		#) Setup
		Write-Verbose "Set erlang ini file content..."
		Set-ErlangIni
		Write-Verbose "Enable management plugin..."
		Enable-ManagementPlugin

		#) Start
		Write-Verbose "Start RabbitMQ..."
		&$p_rabbitmq_serverBAT -detached
		# Waiting for the start of RabbitMQ and the management plugin
		Wait-ManagementPlugin -Credential $Credential
	}
}