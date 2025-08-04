<#
Editor: Visual Studio Code
Script Name: Change-UserPasswords.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 01/29/2025
Description: This script updates the password for all users in a specified Organizational Unit (OU). It generates a password in the format "WelcomeToCCNH!XXXX" where XXXX is a random 4-digit number, applies it to the users, and logs the changes to a CSV file.
#>

# Import Active Directory module
Import-Module ActiveDirectory

# Define the Organizational Unit (OU) - Change this to your target OU
$OU = "OU=TDP,OU=HC Sites,OU=Accounts,DC=cc-nh,DC=local"

# Define the output CSV file
$OutputCSV = "C:\Temp\UpdatedPasswords.csv"

# Retrieve users from the specified OU
$Users = Get-ADUser -Filter * -SearchBase $OU -Properties EmailAddress

# Initialize an array to store user data
$Results = @()

# Process each user
foreach ($User in $Users) {
    # Generate a new password using the template
    $RandomNumber = Get-Random -Minimum 1000 -Maximum 9999
    $NewPassword = "WelcomeToCCNH!$RandomNumber"

    # Convert password to Secure String
    $SecurePassword = ConvertTo-SecureString -String $NewPassword -AsPlainText -Force

    # Attempt to reset the user's password
    try {
        Set-ADAccountPassword -Identity $User.SamAccountName -NewPassword $SecurePassword -Reset
        Set-ADUser -Identity $User.SamAccountName -ChangePasswordAtLogon $true

        # Store the information for logging
        $Results += [PSCustomObject]@{
            DisplayName = $User.Name
            UserPrincipalName = $User.UserPrincipalName
            Email = $User.EmailAddress
            NewPassword = $NewPassword
        }

    } catch {
        Write-Warning "Failed to update password for $($User.UserPrincipalName): $_"
    }
}

# Export results to CSV
$Results | Export-Csv -Path $OutputCSV -NoTypeInformation

Write-Host "Password update completed. Details saved to $OutputCSV."
