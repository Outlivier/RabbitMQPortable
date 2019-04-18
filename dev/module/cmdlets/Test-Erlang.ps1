<#
.SYNOPSIS
	Test if Erlang process is running, meaning RabbitMQ is started.
.DESCRIPTION
	Test that an erl process exists with the path corresponding.
.OUTPUTS
	[System.Boolean] $True if a running erl process exists with the good path, $False otherwise.
#>
function Test-Erlang
{
	[CmdletBinding(SupportsShouldProcess=$false)]
	[OutputType([System.Boolean])]
	param()

	(get-process | ? { $_.Name -eq "erl" -and ($_.Path.StartsWith($p_erlang)) }) -or $false
}