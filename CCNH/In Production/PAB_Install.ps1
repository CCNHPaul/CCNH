<#
Editor: Visual Studio Code
Script Name: PAB_Install.ps1
Author: Paul Hanlon for Catholic Charities NH 
Created: 4/12/2024
Description: This PowerShell script automates the process of downloading Reader and upgrading from 32bit to 64bit.
#>

# Remove old install first
Get-Package -Name 'Phi*' | Uninstall-Package -Force

# Create directories
$pabDirectory = "C:\Temp\PAB"
New-Item -Path $pabDirectory -ItemType Directory -Force | Out-Null

# Define URLs and paths
$pabUrl = "https://www.cc-nh.org/wp-content/uploads/holdplease/PhishAlertButtonSetup.exe"
$pabOutputPath = Join-Path $pabDirectory "PhishAlertButtonSetup.exe"

# Download Phish Alert Button using BITS
try {
    $ProgressPreference = 'SilentlyContinue'
    Start-BitsTransfer -Source $pabUrl -Destination $pabOutputPath -TransferType Download
} catch {
    Write-Host "Failed to download Phish Alert Button."
    Exit 1001
}

# Install Phish Alert Button with silent install parameters
Start-Process -FilePath $pabOutputPath -ArgumentList '/q', '/ComponentArgs', '"KnowBe4 Phish Alert Button":"LICENSEKEY=""USA2735036D9C2FA00F9E69954AEE07E96"""' -Wait

# Cleanup
Remove-Item -LiteralPath $pabDirectory -Force -Recurse

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU6FQwHSVU9PzhD3Sl7GkQR1CL
# /WOgggMQMIIDDDCCAfSgAwIBAgIQN+o39s47b7xKGeApp7qR0DANBgkqhkiG9w0B
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
# CQQxFgQUUz+iR27o2DQpJLBF3Cg43XmKqPgwDQYJKoZIhvcNAQEBBQAEggEAtQOf
# 0HGrI+PKRqmmGHubPhu6RVQekjk/orvHLNw7ZS1YMOLuKyaorTr85+EJxCxIsSaf
# 18Z/bJpVJWD/d3BRQu9wNnKXVsppn1kVAx/boSSRWoZhV0IZQslHpkq4qVfvmQlo
# zEku/FLCR0Xk5fkVmmjdWUKB3Y9aQG7y1TD7oM7bS6BqIVNdJ35IjVR3wFcgETfW
# wSbK1dl2Pn8pl42OaKf0nsEJZPPUS3mwk3MSXZejV1114CRQGqu1hq71W/VuLyrI
# B5LpHEymHGRvqKLcLLH6zBp1w9YJMmT5OXfXhM21HEQbgYWPN9WjqadRh/DK688O
# TFiCCZiltyh0aGsmBg==
# SIG # End signature block
