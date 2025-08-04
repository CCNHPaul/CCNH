<#
Editor: Visual Studio Code
Script Name: ArcticWolf_Fix.ps1
Author: Paul Hanlon for Chathlic Charities NH 
Created: 9/27/2023
Description: This script will remove Arctic Wolf and install it again. This should fix the Degraded Agent message. 
#>

# Uninstall Arctic Wolf
Get-Package -name *Arctic* | Uninstall-Package -Force

# Create directories
$awDirectory = "C:\Temp\AW"
New-Item -Path $awDirectory -ItemType Directory -Force

# Define URLs and paths
$awUrl = "https://www.cc-nh.org/wp-content/uploads/holdplease/arcticwolf.zip"
$awOutputPath = Join-Path $awDirectory "arcticwolf.zip"

# Download ArcticWolf
try {
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $awUrl -OutFile $awOutputPath
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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUzMl5nkVckwB0+Mi1BozApxRS
# Fk+gggMQMIIDDDCCAfSgAwIBAgIQN+o39s47b7xKGeApp7qR0DANBgkqhkiG9w0B
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
# CQQxFgQU1MkusNuWCAPp63gKemg5JAZCPqowDQYJKoZIhvcNAQEBBQAEggEAn9BQ
# yFTdgGQuLMyT6mdwmPI8CPP0XoWbap/ofT/UffB7COCThWoiIa0y7BaAUtZaupqe
# n6+N6EFvGvRWN4BalSCTHV2fcmALXTu3hiAeytTy1l+kiyoRiipqzXAzUKhg8I5N
# skJDwO7iMavqXVrwAa+WmRD/ZACBHJQlrDBPfSoLtto8He4MIQ3dukiAkdsk4zRu
# 7c7wvwk/NO+Q26V/iQHnIJ1jFWrOrEksJsvzBuPxjZfGvBS/jUS5N17tCwXcGeAx
# jOQ1DD4uJYddKeTCPt1h+I+TI6uiozitQEBFz8dAiu/TY3PpF0cK5XReNsgBhfq0
# +Ms8swx1KjXgyZkrgw==
# SIG # End signature block
