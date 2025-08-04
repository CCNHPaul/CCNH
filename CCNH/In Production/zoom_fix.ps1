<#
Editor: Visual Studio Code
Script Name: Zoom_Fix.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 2/20/2024
Description: This PowerShell script will uninstall the Zoom client installed, then download the newest from Zoom and VDI plugin itself.
Then it will install the packages.
#>

# Set folder name
$FolderName = "C:\Temp\ZoomFix"
# Test if folder exists, remove contents it if it does
if (Test-Path $FolderName -ErrorAction SilentlyContinue) {
    Remove-Item -LiteralPath "$FolderName\*" -Force -Recurse -ErrorAction SilentlyContinue
}
# Create folder
New-Item $FolderName -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

# Set file paths
$CleanZoomZip = "$FolderName\CleanZoom.zip"
$CleanZoomPath = "$FolderName\CleanZoom.exe"
$ZoomInstallPath = "$FolderName\ZoomInstallerFull.msi"
$ZoomPluginPath = "$FolderName\ZoomVmwareMediaPlugin.msi"

 # Download VDI and Client softwear plus CleanZoom using BITS
Start-BitsTransfer -Source "https://assets.zoom.us/docs/msi-templates/CleanZoom.zip" -Destination $CleanZoomZip -TransferType Download
Start-BitsTransfer -Source "https://zoom.us/download/vdi/6.1.10.25260/ZoomVDIUniversalPluginx64.msi?archType=x64" -Destination $ZoomPluginPath -TransferType Download
Start-BitsTransfer -Source "https://zoom.us/client/latest/ZoomInstallerFull.msi?archType=x64" -Destination $ZoomInstallPath -TransferType Download

# Unzip CleanZoom
Expand-Archive -LiteralPath $CleanZoomZip -DestinationPath $FolderName -ErrorAction SilentlyContinue

# Run CleanZoom
Start-Process -Wait -FilePath $CleanZoomPath -ArgumentList "/qn" -PassThru -ErrorAction SilentlyContinue

# Create PSDrive for registry editing in HKCR
New-PSDrive -PSProvider Registry -Root HKEY_CLASSES_ROOT -Name HKCR -ErrorAction SilentlyContinue

# Get Zoom install registry entries and remove them
Get-ChildItem -Path HKCR:\Installer\Products -Recurse -ErrorAction SilentlyContinue | Get-ItemProperty | Where-Object {$_.ProductName -like "Zoom*"} | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

# Get Zoom install registry entries from WOW64 node and remove them
Get-ChildItem -Path HKCR:\WOW6432Node\CLSID -Recurse -EA SilentlyContinue | Get-ItemProperty -Name "(default)" -EA Ignore | Where-Object "(default)" -like "Zoom*" | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
Get-ChildItem -Path HKCR:\WOW6432Node\APPID -Recurse -EA SilentlyContinue | Get-ItemProperty -Name "(default)" -EA Ignore | Where-Object "(default)" -like "Zoom*" | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

# Dispose of HKCR PSDrive
Remove-PSDrive -Name HKCR -ErrorAction SilentlyContinue

# Create PSDrive for registry editing in HKLM
New-PSDrive -PSProvider Registry -Root HKEY_LOCAL_MACHINE -Name HKLM -ErrorAction SilentlyContinue

# Delete registry entry for very old Zoom
Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ -Recurse -ErrorAction SilentlyContinue | Get-ItemProperty -Name "DisplayName" -EA Ignore | Where-Object "DisplayName".ToUpper() -like "ZOOM*" | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
Get-ChildItem -Path HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\ -Recurse -ErrorAction SilentlyContinue | Get-ItemProperty -Name "DisplayName" -EA Ignore | Where-Object "DisplayName".ToUpper() -like "ZOOM*" | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

# Dispose of HKLM PSDrive
Remove-PSDrive -Name HKLM -ErrorAction SilentlyContinue

# Install Zoom with auto-update enabled
Start-Process -Wait -FilePath $ZoomInstallPath -ArgumentList '/qn ZConfig="AU2_EnableAutoUpdate=1;AU2_SetUpdateChannel=0;AU2_EnableShowZoomUpdates=1;AU2_EnableManualUpdate=1"' -PassThru -ErrorAction SilentlyContinue


# Install Zoom Plugin
Start-Process -Wait -FilePath $ZoomPluginPath -ArgumentList '/qn CUSTOMINSTALL=2 INSTALLFORVMWARE=1 DISABLEAUS=TRUE' -PassThru -ErrorAction SilentlyContinue

# Cleanup
Remove-Item -Path "$FolderName" -Recurse -Force

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUf7UHQS2dDWZiC/8zs+ht0aNd
# HpygggMQMIIDDDCCAfSgAwIBAgIQN+o39s47b7xKGeApp7qR0DANBgkqhkiG9w0B
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
# CQQxFgQUSJt19xzP1L5MgNQnwTr1z7EkFeAwDQYJKoZIhvcNAQEBBQAEggEAepcW
# PJoNI1BO/+oyQpV5fX3MkJaahXfX5vl8RQyRN0togJaLotTDy8w7SnwfrOkV906v
# QmY4EvjnaBrbPM3RNKIbJgJIhrTWVSM/L0d7+bTLhYKhrIDWVClMF5YogYztHRNf
# 8nVvoa7kPaV3x4VKSdOpUyv0Fqs0BrgcBzvS4h2G49H+JuWUyZa11yI2WEL/3Zqn
# uhMC7j25eSJKMBfvV1m80pRr+j5eGYzNrseaBzFbHuchZ+dWAHN8NK5GZKJLcl8p
# 0/yLnCgbfjDhaYxOEZ9v8lvn6QTsduvcRFz4BTOEBKWQSFclBMCO9enYZ3vWWu06
# oBg4XY+2ddrC4gUQoQ==
# SIG # End signature block
