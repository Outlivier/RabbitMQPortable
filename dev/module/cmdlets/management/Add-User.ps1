<#
.SYNOPSIS
	Adds user to RabbitMQ server.
.DESCRIPTION
	The cmdlet is using REST Api provided by RabbitMQ Management Plugin.
.PARAMETER BaseUri
	URL of RabbitMQManagement. Default is $RabbitMQManagementUrl (http://localhost:15672).
.PARAMETER Credential
	Credentials to use when logging to RabbitMQ server. Default is $RabbitMQGuest (guest/guest).
.PARAMETER Name
	Name of user to create.
.PARAMETER Password
	Password of user to create.
.PARAMETER Tags
	Comma-separated list of user tags.
.EXAMPLE
	PS C:\>Add-MQUser -Name "Admin" -Password "p4ssw0rd" -Tag "administrator"
.LINK
	https://www.rabbitmq.com/management.html : RabbitMQ Management plugin Help.
.LINK
	http://localhost:15672/api/index.html : REST API Help.
.LINK
	https://github.com/RamblingCookieMonster/RabbitMQTools : Sample of Add-User cmdlet.
#>
function Add-User
{
	[CmdletBinding(SupportsShouldProcess=$false, ConfirmImpact="Low")]
	[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
	param
	(
		[string]$BaseUri = $RabbitMQManagementUrl,

		[PSCredential]$Credential = $RabbitMQGuest,

		[Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[string]$Name,

		[parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[string]$Password,

		[parameter(Mandatory,  ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[ValidateSet("administrator", "monitoring", "policymaker", "management","impersonator","none")]
		[string[]]$Tags
	)

	PROCESS
	{
		$url =  "$($BaseUri.TrimEnd("/"))/api/users/$([System.Web.HttpUtility]::UrlEncode($Name))"
		$body = @{
			'password' = $Password
			'tags' = $Tags -join ','
		} | ConvertTo-Json
		Invoke-RestMethod $url -Credential $Credential -DisableKeepAlive -ContentType "application/json" -Method Put -Body $body | Out-Null
	}
}