<#
Editor: Visual Studio Code
Script Name: Assign-M365BusinessPremium.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 01/30/2025
Description: Assigns Microsoft 365 Business Premium (SKU: SPB) licenses to users from a CSV file.
             Removes Microsoft 365 Business Basic (SKU: SPE_F1) if present before assignment.
#>

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.ReadWrite.All"

# Define SKUs
$SkuIdBusinessPremium = "cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46"  # Microsoft 365 Business Premium
$SkuIdBusinessBasic = "3b555118-da6a-4418-894f-7df1e2096870"  # Microsoft 365 Business Basic

# Import users from CSV
$Users = Import-Csv "C:\Temp\CMC_CCNH_M365_List.csv"

foreach ($User in $Users) {
    $UPN = $User.Email

    # Get current assigned licenses
    $CurrentLicenses = (Get-MgUserLicenseDetail -UserId $UPN).SkuId

    # Determine if Business Basic is assigned
    $RemoveLicenses = @()
    if ($CurrentLicenses -contains $SkuIdBusinessBasic) {
        $RemoveLicenses += $SkuIdBusinessBasic
    }

    # Assign Business Premium and remove Business Basic if present
    Set-MgUserLicense -UserId $UPN -AddLicenses @{SkuId=$SkuIdBusinessPremium} -RemoveLicenses $RemoveLicenses
    
    Write-Host "Updated licenses for $UPN"
}

Write-Host "License update process completed."
