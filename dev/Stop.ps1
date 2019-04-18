<#
.SYNOPSIS
	Import RabbitMQPortable module and stops RabbitMQ.
#>
[CmdletBinding()]
param()

$global:InformationPreference = "Continue"
Import-Module "$PSScriptRoot\module\RabbitMQPortable.psd1"
Stop-MQPortable