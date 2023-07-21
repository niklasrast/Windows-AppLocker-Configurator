<#
    .SYNOPSIS 
    Windows 10 

    .DESCRIPTION
    Install:   PowerShell.exe -ExecutionPolicy Bypass -Command .\INSTALL-AppLockerConfigurator.ps1 -install
    Uninstall:   PowerShell.exe -ExecutionPolicy Bypass -Command .\INSTALL-AppLockerConfigurator.ps1 -uninstall

    .ENVIRONMENT
    PowerShell 5.0

    .AUTHOR
    Niklas Rast
#>

[CmdletBinding()]
param(
	[Parameter(Mandatory = $true, ParameterSetName = 'install')]
	[switch]$install,
	[Parameter(Mandatory = $true, ParameterSetName = 'uninstall')]
	[switch]$uninstall
)

$ErrorActionPreference = "SilentlyContinue"
#Use "C:\Windows\Logs" for System Installs and "$env:TEMP" for User Installs
$logFile = ('{0}\{1}.log' -f "C:\Windows\Logs", [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name))

#Test if registry folder exists
if ($true -ne (test-Path -Path "HKLM:\SOFTWARE\COMPANY")) {
    New-Item -Path "HKLM:\SOFTWARE\" -Name "COMPANY" -Force
}

if ($install)
{
    Start-Transcript -path $logFile
        try
        {         
            #Install applocker.xml
            Set-AppLockerPolicy -XMLPolicy "${PSScriptRoot}\applocker_block.xml"
            
            #Register package in registry
            New-Item -Path "HKLM:\SOFTWARE\COMPANY\" -Name "AppLockerConfigurator"
            New-ItemProperty -Path "HKLM:\SOFTWARE\COMPANY\AppLockerConfigurator" -Name "Version" -PropertyType "String" -Value "1.0.0" -Force
        } 
        catch
        {
            $PSCmdlet.WriteError($_)
        }
    Stop-Transcript
}

if ($uninstall)
{
    Start-Transcript -path $logFile
        try
        {
            #Uninstall
            Set-AppLockerPolicy -XMLPolicy "${PSScriptRoot}\applocker_allow.xml"

            #Remove package registration in registry
            Remove-Item -Path "HKLM:\SOFTWARE\COMPANY\AppLockerConfigurator" -Recurse -Force 
        }
        catch
        {
            $PSCmdlet.WriteError($_)
        }
    Stop-Transcript
}
