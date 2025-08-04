<#
Editor: Visual Studio Code
Script Name: Set-ProxyAddresses-ByOU.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 05/08/2025
Description: Adds proxyAddresses to all AD users in a specified OU in the format smtp:Firstname.Lastname@nh-cc.org, preserving existing values.
#>

$TargetOU = "OU=NHFB,OU=SS Sites,OU=Accounts,DC=CC-NH,DC=local"

Import-Module ActiveDirectory
Get-ADUser -SearchBase $TargetOU -Filter * -Properties GivenName, Surname, proxyAddresses | ForEach-Object {
    if ($_.GivenName -and $_.Surname) {
        $newProxy = "smtp:$($_.GivenName).$($_.Surname)@nh-cc.org"
        if ($_.proxyAddresses -notcontains $newProxy) {
            Set-ADUser -Identity $_.DistinguishedName -Add @{ proxyAddresses = $newProxy }
        }
    }
}
