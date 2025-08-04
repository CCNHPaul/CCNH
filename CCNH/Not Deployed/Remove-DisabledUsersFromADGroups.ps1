<#
Editor: Visual Studio Code
Script Name: Remove-DisabledUsersFromADGroups.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 07/15/2025
Description: This script searches all AD groups within a specified OU and removes users who are disabled accounts from those groups,
excluding users whose SamAccountName starts with specified prefixes with or without a dot.
#>

# Import Active Directory module (make sure RSAT tools are installed)
Import-Module ActiveDirectory

# Specify the distinguished name of the OU to search
$OU = "OU=Security Groups,DC=CC-NH,DC=local"

# Define prefixes to exclude (ignoring case), allowing optional dot after prefix
$excludePrefixes = @('sta', 'stt', 'stv', 'stf', 'whc', 'mtc')

# Build regex pattern to match any prefix with optional dot (e.g. sta or sta.)
$pattern = '^(' + ($excludePrefixes -join '|') + ')(\.|$)'

# Get all groups in the specified OU
$groups = Get-ADGroup -SearchBase $OU -Filter *

foreach ($group in $groups) {
    # Get all members of the group that are users
    $members = Get-ADGroupMember -Identity $group.DistinguishedName -Recursive | Where-Object { $_.objectClass -eq 'user' }

    foreach ($member in $members) {
        # Get user properties including enabled status
        $user = Get-ADUser -Identity $member.SamAccountName -Properties Enabled

        if ($user.Enabled -eq $false) {
            # Check if user's SamAccountName starts with excluded prefix (case-insensitive)
            if ($user.SamAccountName -notmatch $pattern) {
                # Remove the disabled user from the group
                Remove-ADGroupMember -Identity $group.DistinguishedName -Members $user.SamAccountName -Confirm:$false
                Write-Host "Removed disabled user $($user.SamAccountName) from group $($group.Name)"
            } else {
                Write-Host "Skipped disabled user $($user.SamAccountName) due to prefix exclusion"
            }
        }
    }
}
