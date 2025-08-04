<#
Editor: Visual Studio Code
Script Name: Windows_Activation_Checker.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 12/20/2024
Description: This script checks if Windows is activated and activates it using a specified product key if it is not.
#>

# Function to check if Windows is already activated
function IsWindowsActivated {
    # Use Get-CimInstance to retrieve information about installed software licensing products
    $activated = ((Get-CimInstance -ClassName SoftwareLicensingProduct -Filter "Name like 'Windows%'" | 
                  Where-Object PartialProductKey) |
                  Select-Object Description, LicenseStatus).LicenseStatus -eq 1 # Check if any installed products have a LicenseStatus of 'Licensed'
    return $activated # Return true if Windows is activated, otherwise false
}

# Check if Windows is already activated
if (IsWindowsActivated) {
    # If activated, display a message and exit
    Write-Host "Windows is already activated."
} else {
    # If Windows is not activated, proceed to activation
    # Specify the product key to use for activation (replace with a valid product key)
    $productKey = "R2NHG-DFQ27-BC3J4-PQPY9-Y7V2F"  # Placeholder product key for demonstration

    # Function to set and activate the product key
    function SetProductKey {
        param($key) # Accept the product key as a parameter
        # Use cscript.exe and slmgr.vbs to install the product key
        cscript.exe $env:SystemRoot\System32\slmgr.vbs -ipk $key
        # Activate Windows using the installed product key
        cscript.exe $env:SystemRoot\System32\slmgr.vbs /ato
    }

    # Call the SetProductKey function with the specified product key
    SetProductKey($productKey)

    # Display a message indicating that activation is complete
    Write-Host "Activation complete."
}

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUgFDvbypzWiQTbcMhgydvWSdn
# b+egggMQMIIDDDCCAfSgAwIBAgIQN+o39s47b7xKGeApp7qR0DANBgkqhkiG9w0B
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
# CQQxFgQU29+iN8kCT5T81VKKU5iQfT2GWmIwDQYJKoZIhvcNAQEBBQAEggEAKDel
# 9ElbwwL6kUiBqhNGiBYodzcpytmZSectRc7Z6K6ZniUqlE/S/Xs73yGHsnHpvONH
# qJl5RXMwIk+8yADabqRDu1mVEwg17zOlNan2t4D+b7UeYRbRmJFuhRrU6a/fRTwr
# WaDpCW8Ny62bFVQRep6SjFViCjDj1UUcb4/PyA9tn0bm+RkMH5/s4q2o5Nm/m0pu
# 4MoQd9h4AcEgv+sLQB9CznUuKOu2XktsLeO/TZN3mfX8/VSCv69C/snklAkVEZxn
# 4PzMs2GF6m+tpPK46GZbWmsezD8jMdbgYgTVg20j4HRfhBquoTqU1jz5gPm/GULU
# IU9Cd6t4dbio7AFrXQ==
# SIG # End signature block
