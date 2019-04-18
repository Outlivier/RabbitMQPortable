<#
.SYNOPSIS
	Waits for RabbitMQ and management plugin to start.
.DESCRIPTION
	Waits the avaibility of REST API URL `http://localhost:15672/api/overview`
.PARAMETER Credential
	Credentials to use when logging to RabbitMQ server.
.PARAMETER Timeout
	Maximum time to wait in seconds.
#>
function Wait-ManagementPlugin
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[PSCredential]$Credential,

		[int]$Timeout = 30
	)

	$uri = "$RabbitMQManagementUrl/api/overview"
	$Success = $false
	$TimeLeft = [timespan]::fromseconds($Timeout)
	$LastException = $null

	Write-Information "Waiting for $uri availability..."

	do
	{
		$StopWatch = [Diagnostics.Stopwatch]::StartNew()
		try
		{
			Invoke-RestMethod $uri -method "get" -Credential $Credential -DisableKeepAlive | Out-Null
			$Success = $true
		}
		catch { $LastException = $_ }

		$StopWatch.Stop()
		$TimeLeft -=$StopWatch.Elapsed
	}
	while (($Success -eq $false) -and ($TimeLeft -ge 0))

	if ($Success)
	{
		Write-Verbose "RabbitMQ started."
	}
	else
	{
		Write-Error "RabbitMQ management plugin is not responding on `"$uri`". Last error was $LastException."
	}
}