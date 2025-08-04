<#
Editor: Visual Studio Code
Script Name: AW_Sysmon_Install.ps1
Author: Paul Hanlon for Catholic Charities NH 
Created: 9/27/2023
Description: 
This PowerShell script automates the download and installation of ArcticWolf and Sysmon. 
It handles directory creation, file extraction, service installation, and cleanup.
#>

# Create directories
$awDirectory = "C:\Temp\AW"
$sysmonDirectory = "C:\Temp\Sysmon"
New-Item -Path $awDirectory, $sysmonDirectory -ItemType Directory -Force | Out-Null

# Define URLs and paths
$awUrl = "https://www.cc-nh.org/wp-content/uploads/holdplease/arcticwolf.zip"
$sysmonUrl = "https://download.sysinternals.com/files/Sysmon.zip"
$awOutputPath = Join-Path $awDirectory "arcticwolf.zip"
$sysmonOutputPath = Join-Path $sysmonDirectory "Sysmon.zip"

# Download ArcticWolf using BITS
try {
    $ProgressPreference = 'SilentlyContinue'
    Start-BitsTransfer -Source $awUrl -Destination $awOutputPath -TransferType Download
} catch {
    Write-Host "Failed to download ArcticWolf."
    Exit 1001
}

# Download Sysmon using BITS
try {
    Start-BitsTransfer -Source $sysmonUrl -Destination $sysmonOutputPath -TransferType Download
} catch {
    Write-Host "Failed to download Sysmon."
    Exit 1002
}

# Extract and install ArcticWolf
Expand-Archive -LiteralPath $awOutputPath -DestinationPath $awDirectory
Start-Process (Join-Path $awDirectory "arcticwolf.msi") -ArgumentList "/quiet" -Wait

# Extract and install Sysmon
Expand-Archive -LiteralPath $sysmonOutputPath -DestinationPath $sysmonDirectory

# Define the full path for sysmon64.exe
$sysmonExePath = "$sysmonDirectory\sysmon64.exe"

# Check if Sysmon is already installed
if (Test-Path $sysmonExePath) {
    # Uninstall any previous versions of Sysmon
    Start-Process -FilePath $sysmonExePath -ArgumentList "-u", "force" -Wait -NoNewWindow
    Start-Sleep -s 10
}

# Install Sysmon
Start-Process -FilePath $sysmonExePath -ArgumentList "-i", "-accepteula" -Wait -NoNewWindow
Start-Sleep -s 10

# Cleanup
Remove-Item -LiteralPath $awDirectory, $sysmonDirectory -Force -Recurse

