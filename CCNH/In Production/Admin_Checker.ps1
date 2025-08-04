<#
Editor: Visual Studio Code
Script Name: Admin_Checker.ps1
Author: Paul Hanlon for Chathlic Charities NH
Created: 11/2/2023
Description: This PowerShell script will check the Administrators group 
and remove all user that are not in the $allowedAdmins variable below
#>

# Define the allowed administrator accounts
$allowedAdmins = @('ccadmin', 'administrator', 'Domain Admins', 'Admin')

# Get the members of the local Administrators group
$adminGroup = Get-LocalGroupMember -Group "Administrators"

# Loop through each member in the group
foreach ($member in $adminGroup) {
    $userName = $member.Name.Split('\')[-1] # Extract just the username
    # If the current member is not in the allowed list, remove them
    if ($userName -notin $allowedAdmins) {
        Remove-LocalGroupMember -Group "Administrators" -Member $member.Name
        Write-Host "Removed user: $($member.Name) from Administrators group"
    }
}
Exit 0

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUgDDuHE9xcQPdIPeWeQlbEJo/
# UKigggMQMIIDDDCCAfSgAwIBAgIQN+o39s47b7xKGeApp7qR0DANBgkqhkiG9w0B
# AQUFADAeMRwwGgYDVQQDDBNDQ05IIFNjcmlwdCBTaWduaW5nMB4XDTI1MDEyNzE0
# NTc0N1oXDTMwMDEyNzE1MDc0N1owHjEcMBoGA1UEAwwTQ0NOSCBTY3JpcHQgU2ln
# bmluZzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMu0DzJUDs4nWBBx
# xgEFvgNA/kGUz/g/fNp4kFwgbW1SiOJiBC6az2BvU5R06W1DCfwJYxcS/91gbG13
# YajO6sF1ttzM6O+aGeO937B6WTDqUX1UmPfNv6DLYyZmI5DwA/1APQlzsrr5ayF3
# qv6StW58R0LWloQo5bppGsNaOfUjd8k7DhutVPSjFzqtTS2Gts7lLz/pGMNZHZkU
# AfMC6+xFkGvXL7VqohjROohKDSOA7GcnBjdWkx/Y1MAPkRaEhcBwDiJfGjRcwzLh
# 7DD7rZwvlvEwO0sMyRSrqRUYUIIFFGGBz4Ft+GQq6xZZpyfYRwV0B8/MlWrovJoC
# 22uhkU0CAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMB0GA1UdDgQWBBQn5QfXn4LbdA3x4ge/dbbZLGci+zANBgkqhkiG9w0BAQUF
# AAOCAQEAaWxZvqMKrRVfSpmEANBkAn0qktpr5O1qh0Q8/99yDlOk4FqKTYKIn/a6
# CAQBDK5MRCVsHL1IoCJzTma0I2tgiYxPqJTI71Sgc4vcDqqawT5W0vTwDFi3hw9q
# /kpy85v7ojZTss5ngM67aYZnOYn6qN4WD3iIBxbV37VAztdcu0umAFnmU64eedG2
# tSoqnBEbm3e49K1q7JZk1hONcVJHRPaa6GMOwp5emVj/fMyvxLKlq5rohoqVThw9
# jEy4wAt0UTuS/xAi+nLp9DwD7uqUt909kf1GW+dluC3O5prJ+L1R7c6OdMlnw3R3
# S3X3oaAUyfQblCTu6RKxrvBywRSFNzGCAdMwggHPAgEBMDIwHjEcMBoGA1UEAwwT
# Q0NOSCBTY3JpcHQgU2lnbmluZwIQN+o39s47b7xKGeApp7qR0DAJBgUrDgMCGgUA
# oHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0B
# CQQxFgQUlejMJtejpG7qBHSrqPPOkns7yfQwDQYJKoZIhvcNAQEBBQAEggEATH7K
# qMKFvdQejrDWZPoyxTGocs4rFjx79MWLfjSJ1mjeOemUOvBMabR+hjAFl4Tft/lk
# sDhwVoVVRAZ0a8dLBg5zsitmE4WfEJttLxMvfPF6YJWrL0Q9aJfm13d3EDmRn7sH
# PA4js+Z5gmPjBLNHNRUKtjFSLecLp9hMCC2I7P4/V5TwDLHdXhx25ak2XwmJkq9y
# QFZZO3KhxMWRCcWjJRbR53eex0kSUrxAHxvyHUFtGQaf9t6S4EjKnWqKmGWTeiO0
# nHptx0uUSHuyc5MNzIieEBFZyWzx4v0Ku6iIUcHlLjnrafHXTCXDhmPZhXPMiQY7
# vossJt3tJHEVLzLXOA==
# SIG # End signature block
