<#
Editor: Visual Studio Code
Script Name: Umbrella_Install.ps1
Author: Paul Hanlon for Chathlic Charities NH 
Created: 5/28/2024
Description: This PowerShell script automates the process of downloading Cisco Umbrella and installing it.
#>

# Uninstall old Umbrella
Get-Package -Name "*Cisco Secure*" | Uninstall-Package -Force -ErrorAction SilentlyContinue

# Define variables
$umbreDirectory = "C:\Temp\Umbrella"
$umbreUrl = "https://www.cc-nh.org/wp-content/uploads/holdplease/CiscoUmbrella.zip"

# Create directories
New-Item -Path $umbreDirectory -ItemType Directory -Force

# Download Cisco Umbrella
try {
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $umbreUrl -OutFile (Join-Path $umbreDirectory "CiscoUmbrella.zip") -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
} catch {
    Write-Host "Failed to download Cisco Umbrella."
    Exit 1001
}

# Extract and install Cisco Umbrella
Expand-Archive -LiteralPath (Join-Path $umbreDirectory "CiscoUmbrella.zip") -DestinationPath $umbreDirectory
Start-Process (Join-Path $umbreDirectory "cisco-secure-client-win-5.1.3.62-core-vpn-predeploy-k9.msi") -ArgumentList "/norestart /passive PRE_DEPLOY_VPN=1 /quiet" -Wait
Start-Process (Join-Path $umbreDirectory "cisco-secure-client-win-5.1.3.62-umbrella-predeploy-k9.msi") -ArgumentList "/norestart /passive /quiet" -wait

# Cleanup
Remove-Item -LiteralPath $umbreDirectory -Force -Recurse

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUIX/PSgUxb3cT7VIS3OEHlvDN
# WlSgggMQMIIDDDCCAfSgAwIBAgIQN+o39s47b7xKGeApp7qR0DANBgkqhkiG9w0B
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
# CQQxFgQULac20u3r5KwQnYyFxttDD+DFx9QwDQYJKoZIhvcNAQEBBQAEggEAjszr
# gyLF8e99iJg40w2Hx5RUWR2+0Zy4SiF7YbLKyKYbvq5oz/4x2gwbdLFOk2GMkzHP
# NcPv2fQxGJ02LifaFuSkKJzPIZFOIWIz4VfeWs6oJfuM8BXFcFqrdKLRYGJtK0fi
# VpvL7lpy3QcfhbYyLLvE6Ls73DS9cmklITukiIpDsPFAq51kLS3JlkKxgFlSrkDp
# J5uBzbXLUXtiT9a3eNfx2pbbql0kUx1fZz6XPqvI35GO4Sc9TIrbFVFv9/KSzyut
# qeX65r+HVfXTkNykEGsU/6aDKZBxOmwtgRee2mGRjOXmbRhjRuKXQlP7lHzxjTva
# 2j1O9IkFC6kD4+sFwQ==
# SIG # End signature block
