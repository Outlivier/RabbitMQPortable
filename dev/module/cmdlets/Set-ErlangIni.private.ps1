<#
.SYNOPSIS
	Change the content of the file `\erlang\bin\erl.ini`.
#>
function Set-ErlangIni
{
	[CmdletBinding(SupportsShouldProcess=$false, ConfirmImpact="Low")]
	[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
	param()

	$erlinicontent  = "[erlang]$nl"
	$erlinicontent += "Bindir={0}$nl"
	$erlinicontent += "Progname=erl$nl"
	$erlinicontent += "Rootdir={1}$nl$nl"

	$erlBindir  = "$p_erlang_erts\bin" -replace "\\","\\" # Path separator in Erlang ini file
	$erlRootdir = "$p_erlang"          -replace "\\","\\" # is double slash

	$erlinicontent = $erlinicontent -f ($erlBindir, $erlRootdir)
	[System.IO.File]::WriteAllText("$p_erlang_bin_erlINI", $erlinicontent, (new-object System.Text.UTF8Encoding($false)))
}