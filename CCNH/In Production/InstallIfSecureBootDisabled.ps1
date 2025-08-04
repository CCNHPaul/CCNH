<#
Editor: Visual Studio Code
Script Name: InstallIfSecureBootDisabled.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 07/30/2025
Description: Checks if Secure Boot is disabled; if so, runs installer silently. Legacy BIOS (error) treated as Secure Boot enabled.
#>

$installerPath = "C:\Temp\Dell Secure Boot\SecureBootOn.exe"

Start-Process -FilePath $installerPath -Wait
