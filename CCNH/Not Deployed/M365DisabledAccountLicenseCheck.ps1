# Import necessary modules
Import-Module ActiveDirectory
Import-Module MSOnline

# Define the path to save the final CSV file
$csvFilePath = "C:\Temp\DisabledAccountsWithLicense.csv"

# Connect to Microsoft 365
Connect-MsolService

# Get all disabled user accounts in AD
$disabledAccounts = Get-ADUser -Filter { Enabled -eq $false } -Properties DisplayName, SamAccountName, UserPrincipalName, Enabled, LastLogonDate

# Create an array to store the  results
$results = @()

# Check each disabled user to see if they have a license in Microsoft 365 using SamAccountName
foreach ($user in $disabledAccounts) {
    # Get relevant properties from AD
    $displayName = $user.DisplayName
    $samAccountName = $user.SamAccountName
    $userPrincipalName = $user.UserPrincipalName
    $lastLogonDate = $user.LastLogonDate

    # Initialize a flag for M365 license status
    $hasLicense = $false

    # Check if the user exists in Microsoft 365 by searching with SamAccountName
    $m365User = Get-MsolUser -SearchString $samAccountName

    if ($null -ne $m365User) {
        # If the user is found in M365, check if they have any licenses
        $hasLicense = $m365User.Licenses.Count -gt 0
    }

    # Add the results to the array
    $results += [pscustomobject]@{
        DisplayName       = $displayName
        SamAccountName    = $samAccountName
        UserPrincipalName = $userPrincipalName
        LastLogonDate     = $lastLogonDate
        HasLicense        = $hasLicense
    }
}

# Export the  data to a single CSV file
$results | Export-Csv -Path $csvFilePath -NoTypeInformation

Write-Host "CSV with disabled AD accounts and M365 license status saved to: $csvFilePath"

