# AppLocker Configuration

This repo contains an powershell scripts to configure the Windows AppLocker feature on an Windows 10 client. AppLocker enables you to restrict access from users to some applications like cmd, powershell or regedit. You can define which applications you want to block for users in the applocker.xml file in this repo.

## Install:
```powershell
PowerShell.exe -ExecutionPolicy Bypass -Command .\W10_AppLockerConfigurator.ps1 -install
```

## Uninstall:
```powershell
PowerShell.exe -ExecutionPolicy Bypass -Command .\W10_AppLockerConfigurator.ps1 -uninstall
```

### Parameter definitions:
- -install configures applocker to block access to for cmd.exe, powershell.exe, powershell_ise.exe, regedit.exe and reg.exe standard users on your windows 10 clients
- -uninstall removes currently nothing
 
## Logfiles:
The scripts create a logfile with the name of the .ps1 script in the folder C:\Windows\Logs.

## Requirements:
- PowerShell 5.0
- Windows 10

Created by @niklasrast 