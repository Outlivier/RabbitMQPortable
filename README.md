# RabbitMQPortable
Launch RabbitMQ from PowerShell without installation. Experimental version.  
Tested only on Windows 10 with Powershell 5.1.



# Table of Contents
1. [Usage](#Usage)
	1. [Troubleshoot](#Troubleshoot)
	2. [PowerShell Module](#PowerShell-Module)
2. [Known issues](#Known-issues)
3. [Dev](#Dev)
	1. [Clone](#Clone)
	2. [Deployment](#Deployment)
	3. [Update RabbitMQ Version](#Update-RabbitMQ-Version)
	4. [Todo](#Todo)
4. [References](#References)



# Usage #

* Download latest archive in [releases page](https://github.com/Outlivier/RabbitMQPortable/releases).
* Expand archive.
* Execute `Start.ps1`. RabbitMQ with management plugin is launched [detached](https://www.rabbitmq.com/install-windows-manual.html#running-windows) on localhost with default port and default configuration.
* Execute `Stop.ps1` to stop RabbitMQ and Erlang.

## Troubleshoot ##

* To check the functioning of erlang, you can do `&".\erlang\bin\erl.exe"`, and the erlang console must appear.

## PowerShell Module ##

* A module is provided with function for RabbitMQ Portable, and wrapper around the management REST API.
The management wrapper are a ultra-simplified small substract of [RabbitMQTools](https://github.com/RamblingCookieMonster/RabbitMQTools).

* Importing the module : `Import-Module ".\module\rabbitmqportable.psd1"`.
* Don't forget you can change the prefix used by the cmdlets (MQ by default) : `Import-Module ".\module\rabbitmqportable.psd1" -Prefix "RabbitMQPortable"`.

# Known issues #

* The MSVCR120.dll dll seems necessary for Erlang. It seems to be installed in Windows 10, but is not available in Windows 2012 R2.  
If Erlang requires the dll, it will be necessary to install Visual C++ Redistributable Packages for Visual Studio 2013 : `choco install vcredist2013`.
* PowerShell 5.0+ with .net FrameWork 4.5 is required because of .net framework bug on encoding '/' inside an URL : [stackoverflow : Mysticism: Invoke-WebRequest working only via ISE](https://stackoverflow.com/questions/41937964/mysticism-invoke-webrequest-working-only-via-ise/42533778#42533778).



# Dev #

## Clone ##

TODO

After cloning, execute `\build\Get-Modules.ps1` to download required modules to `\lib` directory.

## Deployment ##

* Execute `\build\Invoke-ScriptAnalyzer.ps1` and check that there are no more problems.
* Execute `\build\Publish.ps1`.

## Update RabbitMQ Version ##

* Edit file on `\dev\versions.psd1` and set the versions number.
* Erlang
	* Delete the folder `\dev\erlang`.
	* Download the installation program from the [Official website](https://www.erlang.org/downloads).
	* Install in a virtual machine.
	* Copy the content of the folder `C:\Program Files\erl10.3` from the virtual machine into the local folder `\dev\erlang` (without `Uninstall.exe`).
* RabbitMQ
	* Delete the folder `\dev\rabbitmq`.
	* Download the `Windows binary` archive from the [official website](https://www.rabbitmq.com/download.html).
	* Expand the archive to `\dev\rabbitmq`.

## TODO ##

* Set environment variable for RabbitMQ configuration file path in order to change ports number.



# References #

* [stackoverflow : RabbitMQ portable on Windows?](https://stackoverflow.com/questions/19783529/rabbitmq-portable-on-windows)
* [GitHub : RabbitMqPortable](https://github.com/isindicic/RabbitMqPortable)
* [RabbitMQ : Installing on Windows (manual)](https://www.rabbitmq.com/install-windows-manual.html)
* [RabbitMQ : File and Directory Locations](https://www.rabbitmq.com/relocate.html)
* [RabbitMQ : Management Plugin](https://www.rabbitmq.com/management.html)
* API Rest RabbitMQ : http://localhost:15672/api/index.html
* [RabbitMQTools](https://github.com/RamblingCookieMonster/RabbitMQTools) : PowerShell module containing cmdlets to manage RabbitMQ.
* [PSRabbitMq](https://github.com/RamblingCookieMonster/PSRabbitMQ) : PowerShell module to send and receive messages from a RabbitMq server.