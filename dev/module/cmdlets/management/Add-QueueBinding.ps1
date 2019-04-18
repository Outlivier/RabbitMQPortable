<#
.SYNOPSIS
	Adds binding between RabbitMQ exchange and queue.
.DESCRIPTION
	The cmdlet is using REST Api provided by RabbitMQ Management Plugin.
.PARAMETER BaseUri
	URL of RabbitMQManagement. Default is $RabbitMQManagementUrl (http://localhost:15672).
.PARAMETER Credential
	Credentials to use when logging to RabbitMQ server. Default is $RabbitMQGuest (guest/guest).
.PARAMETER Name
	Name of RabbitMQ Queue.
.PARAMETER VirtualHost
	Name of the virtual host.
.PARAMETER ExchangeName
	Name of RabbitMQ Exchange.
.PARAMETER Name
	Name of RabbitMQ Queue.
.PARAMETER RoutingKey
	Routing key.
.PARAMETER Headers
	Headers hashtable
.LINK
	https://www.rabbitmq.com/management.html : RabbitMQ Management plugin Help.
.LINK
	http://localhost:15672/api/index.html : REST API Help.
.LINK
	https://github.com/RamblingCookieMonster/RabbitMQTools : Sample of Add-QueueBinding cmdlet.
#>
function Add-QueueBinding
{
	[CmdletBinding(SupportsShouldProcess=$false)]
	param
	(
		[parameter(Mandatory, ValueFromPipelineByPropertyName, Position=0)]
		[Alias("vh", "vhost")]
		[string]$VirtualHost,

		[parameter(Mandatory, ValueFromPipelineByPropertyName, Position=1)]
		[Alias("exchange", "source")]
		[string]$ExchangeName,

		[parameter(Mandatory, ValueFromPipelineByPropertyName, Position=2)]
		[Alias("queue", "QueueName", "destination")]
		[string]$Name,

		[parameter(Mandatory=$false, ValueFromPipelineByPropertyName, Position=3, ParameterSetName='RoutingKey')]
		[Alias("rk", "routing_key")]
		[string]$RoutingKey,

		[parameter(Mandatory, ValueFromPipelineByPropertyName, Position=3, ParameterSetName='Headers')]
		[Hashtable]$Headers = @{},

		[string]$BaseUri = $RabbitMQManagementUrl,

		[PSCredential]$Credential = $RabbitMQGuest
	)

	PROCESS
	{
		$url =  "$($BaseUri.TrimEnd("/"))/api/bindings/$([System.Web.HttpUtility]::UrlEncode($VirtualHost))/e/$([System.Web.HttpUtility]::UrlEncode($ExchangeName))/q/$([System.Web.HttpUtility]::UrlEncode($Name))"
		$body = @{
			"routing_key" = $RoutingKey
			"arguments" = $headers
		} | ConvertTo-Json
		Invoke-RestMethod $url -Credential $Credential -DisableKeepAlive -ContentType "application/json" -Method Post -Body $body | Out-Null
	}
}