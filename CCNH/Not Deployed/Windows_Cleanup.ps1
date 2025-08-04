<#
Editor: Visual Studio Code
Script Name: Disk_Cleanup.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 7/17/2024
Description: This script configures and executes the Disk Cleanup tool to clean various system file categories. It checks for administrative privileges before making changes.
#>

# Check if the script is running as Administrator
# If not, exit the script to prevent execution without required privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    exit
}

# Define an array of registry paths for different cleanup options in Disk Cleanup
$cleanupOptions = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin", # Recycle Bin, not approved but can be useful
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files", # Temporary Files
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error memory dump files", # System Error Memory Dump Files
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error minidump files", # System Error Mini Dump Files
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Update Cleanup", # Windows Update Cleanup
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Previous Installations", # Previous Windows Installations
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Downloaded Program Files", # Downloaded Program Files
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Internet Files", # Temporary Internet Files
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\DirectX Shader Cache", # DirectX Shader Cache
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Delivery Optimization Files", # Delivery Optimization Files
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Language Resource Files", # Language Resource Files
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Device driver packages", # Device Driver Packages
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows upgrade log files", # Windows Upgrade Log Files
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Microsoft Defender Antivirus", # Microsoft Defender Antivirus Files
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnails"                   # Thumbnails Cache
)

# Iterate through each cleanup option registry path
foreach ($path in $cleanupOptions) {
    # Check if the registry path exists
    if (Test-Path $path) {
        # Set the cleanup state flag to enable the category for cleanup
        Set-ItemProperty -Path $path -Name StateFlags0100 -Value 2 -ErrorAction Stop
    }
}

# Execute the Disk Cleanup tool with the configured options
# '/sagerun:100' runs the Disk Cleanup with the settings saved under state 100
Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:100" -Wait
