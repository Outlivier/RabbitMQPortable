<#
.SYNOPSIS
	Download required modules
#>
.(Join-Path $PSScriptRoot ".common.ps1") -Verbose

Write-Step "Check and download modles"
$modules = Import-PowerShellDataFile $p_lib_modulesPSD1
foreach ($moduleName in $modules.Keys)
{
	$moduleVersion = $modules[$moduleName]
	if (Test-Path "$p_lib\$moduleName\$moduleVersion")
	{
		Write-Information "Module $moduleName v$moduleVersion is present."
	}
    else
	{
		Write-Information "Downloading $moduleName v$moduleVersion..."
		if (Test-Path "$p_lib\$moduleName") { Remove-Item "$p_lib\$moduleName" -Force -Recurse }
		Find-Module -Name $moduleName -Repository "PSGallery" -RequiredVersion $moduleVersion | Save-Module -Path $p_lib
	}
}

Write-Result "Required modules downloaded."
Pause
trap { Write-Trap }