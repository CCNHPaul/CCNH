<#
Editor: Visual Studio Code
Script Name: Installed_Software_Report.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 9/8/2022
Description: This script retrieves a list of installed software from the Windows Registry 
and outputs the results to a text file.
#>

# Define a function named Software to retrieve installed software details
function Software {
    # Define registry paths where installed software information is stored
    $registryPaths = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
        "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall*"
    )
    
    # Retrieve installed software details from registry and select relevant properties
    $INSTALLED = $registryPaths | ForEach-Object { Get-ItemProperty $_ } | 
        Select-Object DisplayName, DisplayVersion, UninstallString
    
    # Filter out null entries and remove duplicates
    $INSTALLED | Where-Object DisplayName -ne $null | Sort-Object -Property DisplayName -Unique
}

# Define output directory and file path
$OutputDir = "C:\Temp"
$OutputFile = "$OutputDir\Installed_Software.csv"

# Ensure the output directory exists
if (!(Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# Execute the Software function and export the result to a CSV file
Software | Export-Csv -Path $OutputFile -NoTypeInformation -Force
