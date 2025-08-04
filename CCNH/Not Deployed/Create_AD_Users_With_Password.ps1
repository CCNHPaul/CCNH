<#
Editor: Visual Studio Code
Script Name: Create_AD_Users_With_Password.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 01/13/2025
Description: Reads a CSV file with user details and creates corresponding accounts in Active Directory. Sets accounts to require password change at next login.
#>

# Import Active Directory module
Import-Module ActiveDirectory

# Define the path to the CSV file
$CSVFilePath = "C:\Temp\CMC_EmployeeOutput_Test.csv"  

# Import users from the CSV file
$Users = Import-Csv -Path $CSVFilePath

foreach ($User in $Users) {
    try {
        # Create new user
        $ADUserParams = @{
            SamAccountName          = $User.SamAccountName
            UserPrincipalName       = $User.UserPrincipalName
            Name                    = "$($User.FirstName) $($User.LastName)"
            GivenName               = $User.FirstName
            DisplayName             = "$($User.FirstName) $($User.LastName)"
            Surname                 = $User.LastName
            Title                   = $User.Title
            Department              = $User.Department
            Office                  = $User.Office
            StreetAddress           = $User.Street
            City                    = $User.City
            State                   = $User.'State/Province'
            PostalCode              = $User.'Zip/Postal Code'
            Country                 = $User.'Country/Region'
            Path                    = "OU=PD,OU=HC Sites,OU=Accounts,DC=CC-NH,DC=local"  
            Enabled                 = $true
            AccountPassword         = (ConvertTo-SecureString "WelcomeToCCNH!" -AsPlainText -Force)  
            ChangePasswordAtLogon   = $true  
        }

        New-ADUser @ADUserParams

        Write-Host "Successfully created user: $($User.SamAccountName)" -ForegroundColor Green

    } catch {
        Write-Host "Failed to create user: $($User.SamAccountName). Error: $_" -ForegroundColor Red
    }
}
