<#
Editor: Visual Studio Code
Script Name: Script_Signer_GUI.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 12/20/2024
Description: This PowerShell script signs all PowerShell scripts (*.ps1) in a specified folder
using a specified certificate to ensure script authenticity and integrity.
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create a Form (GUI Window)
$form = New-Object System.Windows.Forms.Form
$form.Text = "PowerShell Script Signer"
$form.Size = New-Object System.Drawing.Size(600, 400)
$form.StartPosition = "CenterScreen"
$form.AllowDrop = $true
$form.TopMost = $false

# Create a ListBox to display dropped files
$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Size = New-Object System.Drawing.Size(560, 300)
$listBox.Location = New-Object System.Drawing.Point(10, 10)
$form.Controls.Add($listBox)

# Create a Label for status messages
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Drag and drop PowerShell scripts (*.ps1) into the window to sign them."
$statusLabel.Size = New-Object System.Drawing.Size(560, 20)
$statusLabel.Location = New-Object System.Drawing.Point(10, 320)
$form.Controls.Add($statusLabel)

# DragEnter event to allow files to be dropped
$form.Add_DragEnter({
    if ($_.Data.GetDataPresent([System.Windows.Forms.DataFormats]::FileDrop)) {
        $_.Effect = [System.Windows.Forms.DragDropEffects]::Copy
    } else {
        $_.Effect = [System.Windows.Forms.DragDropEffects]::None
    }
})

# DragDrop event to handle dropped files and sign them
$form.Add_DragDrop({
    $files = $_.Data.GetData([System.Windows.Forms.DataFormats]::FileDrop)
    foreach ($file in $files) {
        if ($file -like "*.ps1") {
            $listBox.Items.Add($file)

            # Retrieve the certificate for script signing
            $cert = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.Subject -eq "CN=CCNH Script Signing" }
            if ($null -eq $cert) {
                $statusLabel.Text = "Certificate not found. Ensure 'CN=CCNH Script Signing' exists in your Personal store."
                return
            }

            # Sign the script
            try {
                Set-AuthenticodeSignature -FilePath $file -Certificate $cert | Out-Null
                $statusLabel.Text = "Successfully signed: $file"
            } catch {
                $statusLabel.Text = "Failed to sign script: $file. Error: $_"
            }
        } else {
            $statusLabel.Text = "Only .ps1 files are allowed: $file"
        }
    }
})

# Show the Form
[void]$form.ShowDialog()

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUad/HA9YsppKt1UNykTlY0qRy
# x0CgggMQMIIDDDCCAfSgAwIBAgIQN+o39s47b7xKGeApp7qR0DANBgkqhkiG9w0B
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
# CQQxFgQU7lz5cx0J7jfELchSQgLm4DJpEsowDQYJKoZIhvcNAQEBBQAEggEAmYvN
# HghcRybZigmPoqG/vaKd9tyUDl+9f4kYgYNyaTuECdRNBfhtYqLvqx5TDavengC2
# rnbT0FTyJ/8QAo7YfE3uPogA+reeW9031ec9FyKW7ZHrj5u7dtcO9eA5m8Sgy3es
# APUt7Uhq/kDqsdd5FTv//5/tdxhUuyythiHoaxjC0cg3tClryolM9qWhByeRaE/E
# rFBMSPOzakKbBf7nj61jQNTp528GnSLXfG13rCnqYJ1ksZ6mBmhd4GWG19bjnyBu
# db78vH36JV26aX/Pc217Wer2QgK3XJjjf9YZiY2PTW7XiFOrInAPzvphbqSpN3H+
# W0M3U8rTdY0P02j4Xw==
# SIG # End signature block
