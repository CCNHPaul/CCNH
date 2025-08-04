<#
Editor: Visual Studio Code
Script Name: Add-ADUsersToGroup.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 05/20/2025
Description: Adds all users from a specified OU to a specified AD group.
#>

Import-Module ActiveDirectory

$TargetOU = "OU=STT,OU=HC Sites,OU=Accounts,DC=CC-NH,DC=local"
$GroupName = "STT Users"

Get-ADUser -SearchBase $TargetOU -Filter * | ForEach-Object {
    Add-ADGroupMember -Identity $GroupName -Members $_.DistinguishedName
}
