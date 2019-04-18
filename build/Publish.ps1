<#
.SYNOPSIS
	Publish as a 7-Zip archive to the `\deploy` directory
#>
.(Join-Path $PSScriptRoot ".common.ps1")

#) Get Version
Write-Step "Get current version"
$version  = (Import-PowerShellDataFile $p_dev_module_PSD1).ModuleVersion
$mqversion = (Import-PowerShellDataFile $p_dev_versionsPSD1) 
Write-Result "Version : $version, RabbitMQ : $($mqversion['RabbitMQ']), Erlang: $($mqversion['Erlang'])"

#) Cleaning
Write-Step "Cleaning"
# Remove created archive
gci "$p_deploy\*.7z" | % FullName | % { Remove-Item $_ -Force }
# Remove current RabbitMQ datas
if (Test-Path $p_dev_rabbitmqdata) { Remove-Item -Path $p_dev_rabbitmqdata -Recurse -Force }
# Remove Erlang ini file
if (Test-Path $p_dev_erl_bin_INI) { Remove-Item -Path $p_dev_erl_bin_INI -Force }

#) Publish
Write-Step "Compress"
$outputName = "RabbitMQPortable-$($version)_rabbitmq-$($mqversion['RabbitMQ'])_erlang-$($mqversion['Erlang']).7z"
Import-Module "$p_lib\7Zip4Powershell\*\7Zip4PowerShell.psd1"
Compress-7Zip -ArchiveFileName "$p_deploy\$outputName" -Path "$p_dev" -Format SevenZip -CompressionLevel Ultra

#) End
Write-Result "Archive created on `"$p_deploy\$outputName`"."
Pause
trap { Write-Trap }