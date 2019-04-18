<#
.SYNOPSIS
	Adds Queue to RabbitMQ server.
.DESCRIPTION
	The cmdlet is using REST Api provided by RabbitMQ Management Plugin.
.PARAMETER BaseUri
	URL of RabbitMQManagement. Default is $RabbitMQManagementUrl (http://localhost:15672).
.PARAMETER Credential
	Credentials to use when logging to RabbitMQ server. Default is $RabbitMQGuest (guest/guest).
.PARAMETER Name
	Name of RabbitMQ Queue.
.PARAMETER VirtualHost
	Name of the virtual host to filter channels by.
.PARAMETER Durable
	Determines whether the queue should be durable.
.PARAMETER AutoDelete
	Determines whether the queue should be deleted automatically after all consumers have finished using it.
.LINK
	https://www.rabbitmq.com/management.html : RabbitMQ Management plugin Help.
.LINK
	http://localhost:15672/api/index.html : REST API Help.
.LINK
	https://github.com/RamblingCookieMonster/RabbitMQTools : Sample of Add-Queue cmdlet.
#>
function Add-Queue
{
	[CmdletBinding(SupportsShouldProcess=$false, ConfirmImpact="Low")]
	param
	(
		[parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position=0)]
		[Alias("queue", "QueueName")]
		[string[]]$Name,

		[parameter(Mandatory, ValueFromPipelineByPropertyName)]
		[Alias("vh", "vhost")]
		[string]$VirtualHost,

		[parameter(ValueFromPipelineByPropertyName)]
		[switch]$Durable,

		[parameter(ValueFromPipelineByPropertyName)]
		[switch]$AutoDelete,

		[string]$BaseUri = $RabbitMQManagementUrl,

		[PSCredential]$Credential = $RabbitMQGuest
	)

	PROCESS
	{
		$url =  "$($BaseUri.TrimEnd("/"))/api/queues/$([System.Web.HttpUtility]::UrlEncode($VirtualHost))/$([System.Web.HttpUtility]::UrlEncode($Name))"
		$body = @{}
		if ($Durable) { $body.Add("durable", $true) }
		if ($AutoDelete) { $body.Add("auto_delete", $true) }
		Invoke-RestMethod $url -Credential $Credential -DisableKeepAlive -ContentType "application/json" -Method Put -Body ($body | ConvertTo-Json) | Out-Null
	}
}