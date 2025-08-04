<#
Editor: Visual Studio Code
Script Name: Uninstall_All_Teams_Versions.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 01/14/2025
Description: This script locates and uninstalls both Microsoft Teams installed via the Microsoft Store (Appx package) and MSI/EXE installations.
#>

# Function to uninstall Microsoft Store (Appx) version of Teams
function Uninstall-TeamsStoreApp {
    Write-Output "Checking for Microsoft Store (Appx) version of Teams..."
    $AppxTeams = Get-AppxPackage -AllUsers | Where-Object { $_.Name -like "*Teams*" }
    if ($AppxTeams) {
        $AppxTeams | ForEach-Object {
            Write-Output "Removing Appx package: $($_.Name)"
            Remove-AppxPackage -Package $_.PackageFullName -AllUsers -ErrorAction SilentlyContinue
        }
        Write-Output "Microsoft Store (Appx) version of Teams removed."
    } else {
        Write-Output "No Microsoft Store (Appx) version of Teams found."
    }
}

# Function to uninstall MSI/EXE-installed version of Teams
function Uninstall-TeamsMSI {
    Write-Output "Checking for MSI/EXE-installed version of Teams..."
    $TeamsPath = "C:\Program Files (x86)\Microsoft\Teams"  # Typical install location for x64 Teams
    $TeamsUpdaterPath = "$env:LOCALAPPDATA\Microsoft\Teams\Update.exe" # Squirrel-based updater
    $UninstallKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    $UninstallKeyPathWOW = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"

    # Check and remove Teams via the known path
    if (Test-Path -Path $TeamsUpdaterPath) {
        Write-Output "Uninstalling Teams using Update.exe..."
        & $TeamsUpdaterPath --uninstall -s
        Write-Output "MSI/EXE version of Teams uninstalled using Update.exe."
    } elseif (Test-Path -Path $TeamsPath) {
        Write-Output "Uninstalling Teams by deleting its folder..."
        Remove-Item -Path $TeamsPath -Recurse -Force -ErrorAction SilentlyContinue
        Write-Output "MSI/EXE version of Teams folder deleted."
    } else {
        Write-Output "No Teams found in standard installation paths."
    }

    # Remove any Teams-related registry keys under Uninstall
    Write-Output "Removing Teams registry keys from Uninstall entries..."
    $RegKeys = @(Get-ChildItem $UninstallKeyPath, $UninstallKeyPathWOW | Where-Object { $_.GetValue("DisplayName") -like "*Teams*" })
    if ($RegKeys) {
        foreach ($Key in $RegKeys) {
            Write-Output "Removing registry key: $($Key.PSPath)"
            Remove-Item -Path $Key.PSPath -Recurse -Force
        }
        Write-Output "Teams registry keys removed."
    } else {
        Write-Output "No Teams-related registry keys found."
    }
}

# Run both uninstallation methods
Uninstall-TeamsStoreApp
Uninstall-TeamsMSI

Write-Output "All detected versions of Microsoft Teams have been processed for removal."

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU6k8AjJ/lpoxRtk16pvq3/89E
# TcugggMQMIIDDDCCAfSgAwIBAgIQN+o39s47b7xKGeApp7qR0DANBgkqhkiG9w0B
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
# CQQxFgQUi1+jInhu5QJRr14iqOqeu4FE49MwDQYJKoZIhvcNAQEBBQAEggEAluXy
# YGIalnnXomd4hW+Fe77KgGum/XvJ7z4aH/URISjt6jLUu8JwS4PyWbXIllx/nUE8
# oLsO6eGN7pJHCFdgI9dd1/bnCYp0HDOWSr3OLPXhKXTXnzAm7lgc0J4kyZJ6oZC8
# nJOa3OEEner6UW59J8P8NfhEHoHftXorMtfgzAwfU4JQMcsfxDfzbmqho0z3YNUa
# kHA9Hov61Lie0SwoIbzM3+PddXamtSTM5DKMIzk5z0U92pIp9ZRZMjMoZ28F1sEy
# /RwBJJeTC97yl/OXBZNonddAvF2Joh73RtBLoZkpdgOJ5logT5MoEJ4ETuVkQChM
# 8WfavRZy09iU2OTgJg==
# SIG # End signature block
