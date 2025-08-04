<#
Editor: Visual Studio Code
Script Name: Install_Office365_Silent_06/26/2025
Author: Paul Hanlon
Created: 06/26/2025
Description: Downloads, configures, and silently installs Office 365 using the Office Deployment Tool (ODT).
#>

# Set up working directory
$workDir = "$env:TEMP\Office365Install"
$officeDir = "$workDir\Office"
New-Item -ItemType Directory -Path $officeDir -Force | Out-Null
Set-Location $workDir

# Download Office Deployment Tool (ODT) from user-provided source
$odtUrl = "https://download.microsoft.com/download/6c1eeb25-cf8b-41d9-8d0d-cc1dbc032140/officedeploymenttool_18827-20140.exe"
$odtExe = "$workDir\officedeploymenttool.exe"
Invoke-WebRequest -Uri $odtUrl -OutFile $odtExe

# Extract setup files
Start-Process -FilePath $odtExe -ArgumentList "/quiet /extract:$workDir" -Wait

# Check for setup.exe existence
$setupPath = "$workDir\setup.exe"
if (-Not (Test-Path $setupPath)) {
    Write-Error "Extraction failed. 'setup.exe' not found in $workDir"
    exit 1
}

# Create configuration XML
$configXml = @"
<Configuration>
  <Add OfficeClientEdition="64" Channel="MonthlyEnterprise" SourcePath="$officeDir">
    <Product ID="O365ProPlusRetail">
      <Language ID="en-us" />
    </Product>
  </Add>
  <Display Level="None" AcceptEULA="TRUE" />
  <Property Name="AUTOACTIVATE" Value="1" />
  <Property Name="FORCEAPPSHUTDOWN" Value="TRUE" />
</Configuration>
"@

# Write XML to disk
$configPath = "$workDir\configuration.xml"
$configXml | Out-File -FilePath $configPath -Encoding utf8

# Download Office files
Start-Process -FilePath $setupPath -ArgumentList "/download $configPath" -Wait

# Run silent install
Start-Process -FilePath $setupPath -ArgumentList "/configure $configPath" -Wait
