<#
.SYNOPSIS
	Invoke PSScriptAnalyzer on the PowerShell Module.
#>
.(Join-Path $PSScriptRoot ".common.ps1")


<#
.SYNOPSIS
	Simplifies the call to Invoke-ScriptAnalyzer of the PSScriptAnalyzer module.
#>
function Invoke-ScriptAnalyzer
{
	[CmdletBinding()]
	[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "")]
	param
	(
		[Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidateScript({ Test-Path $_ -PathType Container })]
		[Alias("p")]
		[string]$Path,

		[ValidateNotNull()]
		[string[]]$ExcludeRule = @()
	)

	BEGIN
	{
		$count = 0
	}
	PROCESS
	{
		$scriptName = $null

		$ExcludeRule = $ExcludeRule + @("PSAvoidUsingCmdletAliases","PSAvoidUsingConvertToSecureStringWithPlainText")
		(PSScriptAnalyzer\Invoke-ScriptAnalyzer $Path -Recurse -ExcludeRule $ExcludeRule -Verbose:$false) | % -Process `
		{
			$warn = $_
			$count += 1
			if ($warn.ScriptName -ne $scriptName)
			{
				$scriptName = $warn.ScriptName
				Write-Host "$nl$scriptName" -ForegroundColor Cyan
				Write-Host "`t($($warn.ScriptPath))"
			}

			switch ($warn.Severity)
			{
				Information { $color = [System.ConsoleColor]::Gray   }
				Warning     { $color = [System.ConsoleColor]::Yellow }
				default     { $color = [System.ConsoleColor]::Red    }
			}

			Write-Host "($($warn.Line)) $($warn.RuleName) : $($warn.Message)" -ForegroundColor $color
		}
	}
	END
	{
		Write-Result -Message "$($nl)$($nl)Result : "-NoNewline
		if ($count -eq 0) { Write-Result "No problems found." }
		else { Write-Host "$count problem(s)." -ForegroundColor DarkRed -BackgroundColor Gray }
	}
}

#) Start Analysis
Write-Information "Analysing..."
Import-Module "$p_lib\PSScriptAnalyzer\*\PSScriptAnalyzer.psd1"
Invoke-ScriptAnalyzer -Path $p_dev_module

#) End
Pause
trap { Write-Trap }