<#
Editor: Visual Studio Code
Script Name: Update-HorizonClient.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 05/21/2025
Description: Checks for existing installation of Omnissa Horizon Client.
             If installed, downloads and installs the latest version silently.
             If not installed, exits the script.
#>

$horizonDisplayName = "Horizon Client"
$downloadUrl = "https://download3.omnissa.com/software/CART26FQ1_WIN_2503/Omnissa-Horizon-Client-2503-8.15.0-14236595709.exe"
$destinationPath = "C:\Temp\VMware-Horizon-Client.exe"

# Search both 64-bit and 32-bit uninstall registry paths
$registryPaths = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

$installed = $registryPaths | ForEach-Object {
    Get-ItemProperty -Path $_ -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like "*$horizonDisplayName*" }
}

if (-not $installed) {
    return
}

# Ensure C:\Temp exists
if (-not (Test-Path "C:\Temp")) { New-Item -Path "C:\Temp" -ItemType Directory -Force | Out-Null }

# Download installer using BitsTransfer
Start-BitsTransfer -Source $downloadUrl -Destination $destinationPath

# Run the installer silently
Start-Process -FilePath $destinationPath -ArgumentList "/silent /norestart" -Wait

# Clean up installer
Remove-Item -LiteralPath $destinationPath -Force

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU5OmF6Xfilr2p0cyNI9H/VOqt
# /hegggMQMIIDDDCCAfSgAwIBAgIQN+o39s47b7xKGeApp7qR0DANBgkqhkiG9w0B
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
# CQQxFgQUq/dhsOpizdqniSqHUH5cD+aLuc8wDQYJKoZIhvcNAQEBBQAEggEAnr/0
# ycctKbC8uhHtUjrzVtGROtVAkdD/JtlZJKKDUvyZRYEgSmLNoEL1UC75n7e3RIkw
# juIfuQeJc3Vpm5PUQjHUqSZlsO++0GjmSIWNcAUK+8cKEyuUDB1cFdrxuezrxaoP
# yWZ4rYopH2TUYc0z84hes7ugqDHFwFcFks4EoeTS77bP7FoDspYg/OgdWDW9OyD0
# 7Bjf4/6Xfm8ObUFY8u+c438VDg6cozTDJ+ibnVQPiOxHmuhwWe2rX7XYR85YHJvS
# 5L/LERqRqwbSqVTjs2hNhOMdEiK8X0Y9HTjZ9d9nK2DbXYSAuAXftw4XkYyODYd8
# 3+lXEvp7dZJOKHIaag==
# SIG # End signature block
