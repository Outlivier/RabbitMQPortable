<#
.SYNOPSIS
	Adds Exchange to RabbitMQ server.
.DESCRIPTION
	The cmdlet is using REST Api provided by RabbitMQ Management Plugin.
.PARAMETER BaseUri
	URL of RabbitMQManagement. Default is $RabbitMQManagementUrl (http://localhost:15672).
.PARAMETER Credential
	Credentials to use when logging to RabbitMQ server. Default is $RabbitMQGuest (guest/guest).
.PARAMETER Name
	Name of RabbitMQ Exchange.
.PARAMETER Type
	Type of the Exchange to create.
.PARAMETER Durable
	Determines whether the exchange should be Durable.
.PARAMETER AutoDelete
	Determines whether the exchange will be deleted once all queues have finished using it.
.PARAMETER Internal
	Determines whether the exchange should be Internal.
.PARAMETER AlternateExchange
	Allows to set alternate exchange to which all messages which cannot be routed will be send.
.PARAMETER VirtualHost
	Name of RabbitMQ Virtual Host.
.LINK
	https://www.rabbitmq.com/management.html : RabbitMQ Management plugin Help.
.LINK
	http://localhost:15672/api/index.html : REST API Help.
.LINK
	https://github.com/RamblingCookieMonster/RabbitMQTools : Sample of Add-Exchange cmdlet.
#>
function Add-Exchange
{
	[CmdletBinding(SupportsShouldProcess=$false, ConfirmImpact="Low")]
	[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
	param
	(
		[parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position=0)]
		[Alias("Exchange", "ExchangeName")]
		[string[]]$Name,

		[parameter(Mandatory, ValueFromPipelineByPropertyName)]
		[ValidateSet("topic", "fanout", "direct", "headers", "x-jms-topic")]
		[string]$Type,

		[parameter(ValueFromPipelineByPropertyName)]
		[switch]$Durable,

		[parameter(ValueFromPipelineByPropertyName)]
		[switch]$AutoDelete,

		[parameter(ValueFromPipelineByPropertyName)]
		[switch]$Internal,

		[parameter(ValueFromPipelineByPropertyName)]
		[Alias("alt")]
		[string]$AlternateExchange,

		[parameter(Mandatory,ValueFromPipelineByPropertyName)]
		[Alias("vh", "vhost")]
		[string]$VirtualHost,

		[string]$BaseUri = $RabbitMQManagementUrl,

		[PSCredential]$Credential = $RabbitMQGuest
	)

	PROCESS
	{
		$url =  "$($BaseUri.TrimEnd("/"))/api/exchanges/$([System.Web.HttpUtility]::UrlEncode($VirtualHost))/$([System.Web.HttpUtility]::UrlEncode($name))"

		$body = @{
			type = "$Type"
		}
		if ($Durable) { $body.Add("durable", $true) }
		if ($AutoDelete) { $body.Add("auto_delete", $true) }
		if ($Internal) { $body.Add("internal", $true) }
		if ($AlternateExchange) { $body.Add("arguments", @{ "alternate-exchange"=$AlternateExchange }) }

		Invoke-RestMethod $url -Credential $Credential -DisableKeepAlive -ContentType "application/json" -Method Put -Body ($body | ConvertTo-Json) | Out-Null
	}
}