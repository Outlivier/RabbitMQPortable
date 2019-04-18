#————————————————————————————————————————————————————————————————————————————————————————
#region Constants and variables
#————————————————————————————————————————————————————————————————————————————————————————
#) Paths
$p_r0                      = (Split-Path $PSScriptRoot).TrimEnd([System.IO.Path]::DirectorySeparatorChar)
$p_versionsPSD1            = "$p_r0\versions.psd1"
$p_erlang                  = "$p_r0\erlang"
$p_erlang_bin_erlINI       = "$p_r0\erlang\bin\erl.ini"
$p_erlang_erts             = "$p_r0\erlang\erts-10.3"
$p_module_cmdlets          = "$p_r0\module\cmdlets"
$p_rabbitmq                = "$p_r0\rabbitmq"
$p_rabbitmq_rabbitmqctlBAT = "$p_r0\rabbitmq\sbin\rabbitmqctl.bat"
$p_rabbitmq_pluginBAT      = "$p_r0\rabbitmq\sbin\rabbitmq-plugins.bat"
$p_rabbitmq_serverBAT      = "$p_r0\rabbitmq\sbin\rabbitmq-server.bat"
$p_rabbitmqdata            = "$p_r0\rabbitmq-data"

$p_versionsPSD1,$p_erlang,$p_erlang_bin_erlINI,$p_erlang_erts,$p_rabbitmq,$p_rabbitmq_rabbitmqctlBAT,$p_rabbitmq_pluginBAT,`
$p_rabbitmq_serverBAT,$p_rabbitmqdata ` | Out-Null # Avoid syntax analysis warning abaout unused variables

#) Default Credential / Ports / URI
if (!(Test-Path "variable:RabbitMQManagementDefaultPort"))
{
	Set-Variable -Name "RabbitMQManagementDefaultPort" -Value 15672 -Option Constant -Scope Script
}
if (!(Test-Path "variable:RabbitMQManagementUrl"))
{
	Set-Variable -Name "RabbitMQManagementUrl" -Value "http://localhost:$RabbitMQManagementDefaultPort" -Scope Local
}
if (!(Test-Path "variable:RabbitMQGuest"))
{
	$password = ConvertTo-SecureString 'guest' -AsPlainText -Force
	Set-Variable -Name "RabbitMQGuest" -Value (New-Object System.Management.Automation.PSCredential ('guest', $password)) -Scope Local
}
Export-ModuleMember -Variable "RabbitMQManagementUrl","RabbitMQGuest"

#) Shortcut for new line
if (!(Test-Path "variable:nl"))
{
	Set-Variable -Name "nl" -Value ([System.Environment]::NewLine) -Option Constant -Scope Script
}
#endregion


#————————————————————————————————————————————————————————————————————————————————————————
#region Loading
#————————————————————————————————————————————————————————————————————————————————————————
#) Load cmdlets
gci -Path "$p_module_cmdlets\*.ps1" -Recurse | % FullName | % { . $_ }

#) Load System.Web required by management cmdlets
Add-Type -AssemblyName System.Web

#) Set environment variables
Set-EnvironmentVariables
#endregion