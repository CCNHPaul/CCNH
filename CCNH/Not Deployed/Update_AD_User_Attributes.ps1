<#
Editor: Visual Studio Code
Script Name: Update_AD_User_Attributes.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 12/23/2024
Description: This script updates the "Office" attribute of users in specified OUs and uses it to populate extensionAttribute1. It handles multiple OUs dynamically and logs errors for failed updates.
#>

# Import the Active Directory module to interact with Active Directory objects.
Import-Module ActiveDirectory

# Define the Organizational Unit (OU) to target and the corresponding office location.
$OU = "OU=HQ,OU=Accounts,DC=CC-NH,DC=local"  # Modify this to your specific target OU.
$OfficeLocation = "HQ"

# Fetch all users in the specified OU and set their Office attribute to the defined location.
Get-ADUser -Filter * -SearchBase $OU | ForEach-Object {
    Set-ADUser -Identity $_ -Office $OfficeLocation
}

# Define a list of additional OUs to process and update Office attributes accordingly.
$OUsToProcess = @(
    "OU=SS Sites,OU=Accounts,DC=CC-NH,DC=local",
    "OU=HC Sites,OU=Accounts,DC=CC-NH,DC=local"
)

# Loop through each OU in the list to process user accounts.
foreach ($OU in $OUsToProcess) {
    # Fetch all users in the current OU.
    Get-ADUser -Filter * -SearchBase $OU -Properties DistinguishedName | ForEach-Object {
        # Extract the Distinguished Name (DN) of the user.
        $UserDN = $_.DistinguishedName

        # Extract the immediate parent OU from the Distinguished Name.
        $OUPath = ($UserDN -split ',')[1]  # Get the second component of the DN.
        $OUName = $OUPath -replace '^OU=', ''  # Remove "OU=" prefix to get a clean OU name.

        try {
            # Update the Office attribute with the extracted OU name.
            Set-ADUser -Identity $_.DistinguishedName -Office $OUName
        }
        catch {
            # Log an error message if updating the user fails.
            # Consider logging errors to a file or event log for better traceability.
        }
    }
}

# Specify the main Organizational Unit (OU) for further processing.
$OU = "OU=Accounts,DC=CC-NH,DC=local"

# Retrieve all user accounts in the specified OU, including their Office and extensionAttribute1 attributes.
$Users = Get-ADUser -Filter * -SearchBase $OU -Properties Office, extensionAttribute1

# Loop through each user account to update extensionAttribute1.
foreach ($User in $Users) {
    # Fetch the Office location attribute for the user.
    $OfficeLocation = $User.Office

    # Update the extensionAttribute1 with the Office location if it exists and is not empty.
    if (-not [string]::IsNullOrEmpty($OfficeLocation)) {
        Set-ADUser -Identity $User.SamAccountName -Replace @{extensionAttribute1 = $OfficeLocation }
    } 
}

# End of script.
