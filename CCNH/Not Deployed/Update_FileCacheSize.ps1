<#
Editor: Visual Studio Code
Script Name: Update_FileCacheSize.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 12/20/2024
Description: This PowerShell script updates the CacheSizeInMB and MaxCacheSizeInMB
values in the FileCacheServiceAgent configuration file to 5120 MB (5 GB).
#>

# Define the path to the XML configuration file
$filePath = "C:\ProgramData\MspPlatform\FileCacheServiceAgent\config\FileCacheServiceAgent.xml"

# Read the content of the XML file
$content = Get-Content $filePath

# Update the CacheSizeInMB value to 5120 MB
$content = $content -replace '<CacheSizeInMB>\d+</CacheSizeInMB>', '<CacheSizeInMB>5120</CacheSizeInMB>'

# Update the MaxCacheSizeInMB value to 5120 MB
$content = $content -replace '<MaxCacheSizeInMB>\d+</MaxCacheSizeInMB>', '<MaxCacheSizeInMB>5120</MaxCacheSizeInMB>'

# Save the updated content back to the XML file
Set-Content -Path $filePath -Value $content

