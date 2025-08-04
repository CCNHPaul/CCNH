<#
Editor: Visual Studio Code
Script Name: DCU_BIOS_Update.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 9/1/2023
Description: This PowerShell script automates the process of updating the Bios of Dell laptops with Dell Command Update.
#>

# Set the working directory to the DCU installation location
Set-Location ($(if (Test-Path "C:\Program Files\Dell\CommandUpdate") { "C:\Program Files\Dell\CommandUpdate" } else { "C:\Program Files (x86)\Dell\CommandUpdate" }))

# Configure DCU to update BIOS, Firmware, Drivers, and Applications
$configureCommand = ".\dcu-cli.exe /configure ""-updatetype=bios,firmware,driver"""

# Suspend BitLocker and apply all updates including BIOS
$applyUpdatesCommand = ".\dcu-cli.exe /applyUpdates -autoSuspendBitLocker=Enable"

# Execute the commands using cmd.exe to handle potential quoting issues
Start-Process cmd.exe -ArgumentList "/c $configureCommand" -Wait -NoNewWindow
Start-Process cmd.exe -ArgumentList "/c $applyUpdatesCommand" -Wait -NoNewWindow

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU8uHEOupcuIUdHhJXqLBNuHsi
# RpigggMQMIIDDDCCAfSgAwIBAgIQN+o39s47b7xKGeApp7qR0DANBgkqhkiG9w0B
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
# CQQxFgQUkFmwXi5SGpqnF+++INpcZ1nkDRkwDQYJKoZIhvcNAQEBBQAEggEARDoE
# t6TjAKQFpeCX01j/SdsNympczfNKP5HHWEpZZc4jWkhSEjOJD9XEY6yWR1zNnGxT
# ruvlJ4NHk3g+0hpLuFEa7LWaMDCV30v8+w1nIfvmmyfopPzPW6q9nrDmVp+x6h/c
# 2BqtLI8a0o6AJbzJg/0UpjKVunhg9h7ozn3ltmFIbxZ2mVN7XQIslRvmAweoDIRd
# XuQbjIsCCyKmA+VreCZJ3LfQe9jOFb88/TmVlj9bd7/PUQnmejdN5nav0Z5DvJGE
# 3dGHg93L4Ej3E0+tfY/6VCOK7XtQr42nqF5k1QHJyFitZWkdQoToKnRXskNmPexO
# dpZSgHySKj/z6mWhYw==
# SIG # End signature block
