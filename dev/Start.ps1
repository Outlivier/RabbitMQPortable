<#
.SYNOPSIS
	Import RabbitMQPortable module and starts RabbitMQ.
#>
[CmdletBinding()]
param()

$global:InformationPreference = "Continue"
Import-Module "$PSScriptRoot\module\RabbitMQPortable.psd1"
Start-MQPortable