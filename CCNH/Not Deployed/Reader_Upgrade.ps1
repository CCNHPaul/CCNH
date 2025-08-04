<#
Editor: Visual Studio Code
Script Name: Reader_upgrade.ps1
Author: Paul Hanlon for Chathlic Charities NH 
Created: 4/11/2024
Description: This PowerShell script automates the process of downloading Reader and upgrading from 32bit to 64bit
#>

# Create directories
$arDirectory = "C:\Temp\AR"
New-Item -Path $ARDirectory -ItemType Directory -Force

# Define URLs and paths
$arUrl = "https://www.cc-nh.org/wp-content/uploads/holdplease/AdobeReader.zip"
$arOutputPath = Join-Path $arDirectory "AdobeReader.zip"

# Download Reader
try {
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $arUrl -OutFile $AROutputPath -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
} catch {
    Write-Host "Failed to download Reader."
    Exit 1001
}

# Extract and install Reader
Expand-Archive -LiteralPath $arOutputPath -DestinationPath $arDirectory
Start-Process .\setup.exe -NoNewWindow -Wait

# Cleanup
Remove-Item -LiteralPath $arDirectory -Force -Recurse

