<#
.SYNOPSIS
	Get current version of Erlang and RabbitMQ.
.OUTPUTS
	[System.Collections.Hashtable] Dictionary where Key is 'Erlang' or 'RabbitMQ' and value is the version number as string.
.EXAMPLE
	PS C:\>Get-Version
	Name                           Value
	----                           -----
	RabbitMQ                       3.7.14
	Erlang                         21.3
#>
function Get-Version
{
	[CmdletBinding(SupportsShouldProcess=$false)]
	[OutputType([System.Collections.Hashtable])]
	param()

	Import-PowerShellDataFile -LiteralPath $p_versionsPSD1
}