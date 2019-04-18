<#
.SYNOPSIS
	Enable management plugin.
.LINK
	https://www.rabbitmq.com/management.html.
#>
function Enable-ManagementPlugin
{
	[CmdletBinding(SupportsShouldProcess=$false)]
	param()

	&$p_rabbitmq_pluginBAT enable rabbitmq_management
}