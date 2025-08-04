<#
Editor: Visual Studio Code
Script Name: Install-Pulse.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 02/28/2025
Description: Downloads Pulse Secure Client and installs the client silently.
#>

# Define download URL and target path
$DownloadURL = "https://qies-west.cms.gov/dana-cached/psal/PulseSecureAppLauncher.msi"
$InstallerPath = "C:\Temp\PulseSecure.msi"
$TempDownloadPath = "C:\Temp\PulseSecure.msi"

# Ensure the temp directory exists
if (-Not (Test-Path "C:\Temp")) {
    New-Item -Path "C:\Temp" -ItemType Directory | Out-Null
}

# Download the installer
Start-BitsTransfer -Source $DownloadURL -Destination $TempDownloadPath

# Rename the downloaded file to PulseSecure.msi
if (Test-Path $TempDownloadPath) {
    Rename-Item -Path $TempDownloadPath -NewName "PulseSecure.msi" -Force
} else {
    exit 1
}

# Verify the installer exists
if (-Not (Test-Path $InstallerPath)) {
    exit 1
}

# Install Pulse Secure Client silently with predefined server
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$InstallerPath`" /quiet /qn /norestart" -Wait -NoNewWindow

# Delete download files
Remove-Item -Path $InstallerPath -Force

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUZX94er/+2qROHzvj0P2yY7TS
# 9+SgggMQMIIDDDCCAfSgAwIBAgIQN+o39s47b7xKGeApp7qR0DANBgkqhkiG9w0B
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
# CQQxFgQUVJmnalqgKGK1ga6fUpfAlwkZavEwDQYJKoZIhvcNAQEBBQAEggEAocMV
# 6C/8Stpq9iCUYEEaecYtDCSdBM6LjtXao3B/FLKpkKggu80OKnb75Sl6sP2+5tW/
# E0VUEtsc3JZxv8jBea2YAZGTl1NC/B/L1CAlyGCmkuapB2xZwvcoCSCxosMdVBKZ
# MqxpdgmV3Yf/g7Ds26n4jTCHeuq6mpexPPTq+U91l/+jrfXuCWwSN7umfpciL2ui
# gUnZOHu3IRGk9upjpHiJJOI2kAf6faCmqu0r4aVK+67MXd1ykOkr0vXbHAUvX9g0
# LQb4e+wXZ7LZF2CXNGOS8avtH6kuepmGbLY4/rDj5NjqKuuzsgthyBmk6D8W/Kx0
# jFuKyhIcZtCveCtTBQ==
# SIG # End signature block
