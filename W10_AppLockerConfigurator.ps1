<#
    .SYNOPSIS 
    Windows 10 

    .DESCRIPTION
    Install:   PowerShell.exe -ExecutionPolicy Bypass -Command .\W10_AppLockerConfigurator.ps1 -install
    Uninstall:   PowerShell.exe -ExecutionPolicy Bypass -Command .\W10_AppLockerConfigurator.ps1 -uninstall

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

$ErrorActionPreference="SilentlyContinue"
$logFile = ('{0}\{1}.log' -f "C:\Windows\Logs", [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name))

if ($install)
{
    Start-Transcript -path $logFile
        try
        {         
            #Install applocker.xml
            Set-AppLockerPolicy -XMLPolicy "${PSScriptRoot}\applocker.xml"
            
            New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" -Name "W10_AppLockerConfigurator" -Force
            New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\W10_AppLockerConfigurator" -Name "Version" -PropertyType "String" -Value "1.0" -Force
            New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\W10_AppLockerConfigurator" -Name "Revision" -PropertyType "String" -Value "001" -Force
            New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\W10_AppLockerConfigurator" -Name "LogFile" -PropertyType "String" -Value "${logFile}" -Force
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
            #Uninstall Script here...
            Write-Host -ForegroundColor Red "AppLocker Policys können nicht automatisiert deinstalliert werden. Bitte deinstallieren Sie diese manuell über die lokale Sicherheitsrichtlinie"
            
            Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\W10_AppLockerConfigurator" -Force -Recurse
        }
        catch
        {
            $PSCmdlet.WriteError($_)
        }
    Stop-Transcript
}