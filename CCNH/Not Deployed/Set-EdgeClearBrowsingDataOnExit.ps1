<#
Editor: Visual Studio Code
Script Name: Set-EdgeClearBrowsingDataOnExit.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 03/13/2025
Description: Add sites to the Edge ClearBrowsingDataOnExitList registry key
This will clear the browsing data for the specified sites when the browser is closed
Add new sites using the format '["[*.]example.com", "[*.]example2.com"]' and separate multiple sites with commas
#>

$SiteList = '["[*.]pointclickcare.com"]'  # Define the list of sites to clear data on exit

# Registry path for Microsoft Edge policy settings (Current User)
$RegPath = "HKCU:\SOFTWARE\Policies\Microsoft\Edge"  # Registry path for Edge policies under Current User

# Check if the registry path exists, create it if not
if (!(Test-Path $RegPath)) { 
    New-Item -Path $RegPath -Force 
}

# Set the policy to clear browsing data for the specified sites
Set-ItemProperty -Path $RegPath -Name "ClearBrowsingDataOnExitList" -Value $SiteList -Type String
