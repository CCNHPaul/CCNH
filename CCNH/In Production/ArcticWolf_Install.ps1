<#
Editor: Visual Studio Code
Script Name: ArcticWolf_Install.ps1
Author: Paul Hanlon for Catholic Charities NH 
Created: 9/27/2023
Description: This PowerShell script automates the process of downloading ArcticWolf Agent and installing it.
Update 9/28/2023 added service check and start, service not found continues with the install. 
#>

# Create directories
$awDirectory = "C:\Temp\AW"
New-Item -Path $awDirectory -ItemType Directory -Force | Out-Null

# Define URLs and paths
$awUrl = "https://www.cc-nh.org/wp-content/uploads/holdplease/arcticwolf.zip"
$awOutputPath = Join-Path $awDirectory "arcticwolf.zip"

# Download ArcticWolf using BITS
try {
    $ProgressPreference = 'SilentlyContinue'
    Start-BitsTransfer -Source $awUrl -Destination $awOutputPath -TransferType Download
} catch {
    Write-Host "Failed to download ArcticWolf."
    Exit 1001
}

# Extract and install ArcticWolf
Expand-Archive -LiteralPath $awOutputPath -DestinationPath $awDirectory
Start-Process (Join-Path $awDirectory "arcticwolf.msi") -ArgumentList "/quiet" -Wait

# Cleanup
Remove-Item -LiteralPath $awDirectory -Force -Recurse

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUvA33lg6DX3AZimQmrQAH/BHF
# yfagggMQMIIDDDCCAfSgAwIBAgIQN+o39s47b7xKGeApp7qR0DANBgkqhkiG9w0B
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
# CQQxFgQUQYm8YYkaNpSYmn1p8gcsBDkpkPAwDQYJKoZIhvcNAQEBBQAEggEACice
# KQjTNxtvyo8oVBGg3f9mMFjGErc/9cA405ROUjW/xTscnXKTEyoIJNxQxNJu2STH
# zt1HFqqv4Kd/yxljbolObfJwtsopPHBx/j2+VfYcOWW6Iko1O0A3d5t9EO39EYNo
# y3APwx6USARGs+qqJCnA/6ydVnG6wBPn+MWNCbDNDgBEqWAXNJT/G5oMemV64YXH
# gF0wuo9zIJW1HM6Y4s72+3Cgk26pobTmbXC/GK1YjuiUB9i2q91wK0yup3X2L133
# 4d1yn1Lw3Q6wMgJsI2DmzV4zPWnO9bxkmG8qDrnbALOs8Ik29hdjOVOduaAx4Zih
# rcmLO/BBDR39oh5nKg==
# SIG # End signature block
