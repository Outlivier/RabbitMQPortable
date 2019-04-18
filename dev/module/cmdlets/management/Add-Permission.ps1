<#
.SYNOPSIS
	Adds permissions to virtual host for a user.
.DESCRIPTION
	The cmdlet is using REST Api provided by RabbitMQ Management Plugin.
.PARAMETER BaseUri
	URL of RabbitMQManagement. Default is $RabbitMQManagementUrl (http://localhost:15672).
.PARAMETER Credential
	Credentials to use when logging to RabbitMQ server. Default is $RabbitMQGuest (guest/guest).
.PARAMETER VirtualHost
	Virtual host to set permission for.
.PARAMETER User
	Name of user to set permission for.
.PARAMETER Configure
	Configure permission regexp.
.PARAMETER Read
	Read permission regexp.
.PARAMETER Write
	Write permission regexp.
.EXAMPLE
	PS C:\>Add-MQPermission '/' Admin .* .* .*
.LINK
	https://www.rabbitmq.com/management.html : RabbitMQ Management plugin Help.
.LINK
	http://localhost:15672/api/index.html : REST API Help.
.LINK
	https://github.com/RamblingCookieMonster/RabbitMQTools : Sample of Add-Permission cmdlet.
#>
function Add-Permission
{
	[CmdletBinding(SupportsShouldProcess=$false, ConfirmImpact="Low")]
	[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
	param
	(
		[parameter(Mandatory, Position=0,ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias("vhost", "vh")]
		[string]$VirtualHost,

		[parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position=1)]
		[string]$User,

		[parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position=2)]
		[string]$Configure,

		[parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=3)]
		[string]$Read,

		[parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=4)]
		[string]$Write,

		[string]$BaseUri = $RabbitMQManagementUrl,

		[PSCredential]$Credential = $RabbitMQGuest
	)

	PROCESS
	{
		$url =  "$($BaseUri.TrimEnd("/"))/api/permissions/$([System.Web.HttpUtility]::UrlEncode($VirtualHost))/$([System.Web.HttpUtility]::UrlEncode($User))"
		$body = @{
			'configure' = $Configure
			'read' = $Read
			'write' = $Write
		} | ConvertTo-Json
		Invoke-RestMethod $url -Credential $Credential -DisableKeepAlive -ContentType "application/json" -Method Put -Body $body | Out-Null
	}
}