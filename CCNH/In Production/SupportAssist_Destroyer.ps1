<#
Editor: Visual Studio Code
Script Name: SupportAssist_Destroyer.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 7/17/2024
Description: This script forcefully uninstalls all Dell software packages, downloads Dell Command Update, and installs it silently. The process includes cleanup of temporary files used during the operation.
#>

# Force all Dell package uninstall
# Retrieves all installed packages starting with 'Dell' and removes them forcefully.
Get-Package -Name 'Dell*' | Uninstall-Package -Force

# Create directories
# Specifies the directory path for temporary storage and ensures its creation.
$DellDirectory = "C:\Temp\Dell"
New-Item -Path $DellDirectory -ItemType Directory -Force

# Define URLs and paths
# Defines the URL for downloading the Dell Command Update executable and the local path for saving the file.
$DellUrl = "https://dl.dell.com/FOLDER11914128M/1/Dell-Command-Update-Windows-Universal-Application_9M35M_WIN_5.4.0_A00.EXE"
$DellOutputPath = Join-Path $DellDirectory "Dell-Command-Update.EXE"

# Download Dell Command Update
# Uses Invoke-WebRequest to download the Dell Command Update installer silently.
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri $DellUrl -OutFile $DellOutputPath -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"

# Install Dell Command Update
# Executes the downloaded Dell Command Update installer with silent mode arguments.
$dellExePath = Join-Path $DellDirectory "Dell-Command-Update.EXE"
Start-Process -FilePath $dellExePath -ArgumentList "/s" -WorkingDirectory $DellDirectory -Wait -NoNewWindow

# Clean up
# Deletes the temporary directory and all its contents to clean up after installation.
Remove-Item -LiteralPath $DellDirectory -Force -Recurse

# Exit script successfully
exit 0

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUQXtoR1pjEptQJ3rwRx9GwMdp
# VaOgggMQMIIDDDCCAfSgAwIBAgIQN+o39s47b7xKGeApp7qR0DANBgkqhkiG9w0B
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
# CQQxFgQUQbF1RfVlUqP6QAfxzHFwtkmVBWwwDQYJKoZIhvcNAQEBBQAEggEAwuqA
# dSlfFQREeoMMVF7o/xg8xAwqYFS7ImrsLWVP4zF/fZhq26WgUuP9SVuAVpTVtsME
# y4ygQ3f77cMQodz4OAIajM6/E1CRj9/ExHIxlsKYSUSdoYW5YIMv4ZjwuozwgQXq
# hET+Ldj7BTunOE0D9W1PVcACW7crDkxbdYdENhGzOKkttY120MV1Pcb8T7yWXkeu
# +fQ3SHwxcEoUQO92itmpjGHCHngA/HXNla0OdAJr2fAU/Eu7KRvv+lQQ+rMnL3nN
# 7s7N+4RODIwVG1VEIO+Z09duy4UWbLS8z7zoqFMONbHdlt6SIJk6XnEoURUuQWMj
# FNofEf5ewXrZusqtNw==
# SIG # End signature block
