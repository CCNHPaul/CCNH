<#
Editor: Visual Studio Code
Script Name: Deploy-HelpdeskButton.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 05/27/2025
Description: Moves a specified file to two separate locations, each using separate network credentials.
#>

# --- Parameters: EDIT THESE ---
$sourcePath      = 'C:\Temp\Helpdesk Button Staged\HelpDesk_Button.ps1'
$destination1    = '\\CC-NH.local\SysVol\CC-NH.local\Files\Helpdesk Button\HelpDesk_Button.ps1'

# Credentials for first destination
$user1 = 'cc-nh.local\administrator'
$pass1 = 'ptfb2009!!'

# --- Function to Map and Move ---
function Move-WithCredentials {
    param (
        [string]$destPath,
        [string]$username,
        [string]$password,
        [string]$filePath
    )
    $networkPath = Split-Path $destPath -Parent

    # Create credential object
    $securePass = ConvertTo-SecureString $password -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential ($username, $securePass)

    # Map network path using credential
    New-PSDrive -Name "TEMPDRIVE" -PSProvider FileSystem -Root $networkPath -Credential $cred -ErrorAction Stop | Out-Null

    # Copy file to destination
    Copy-Item $filePath -Destination $destPath -Force

    # Remove mapping
    Remove-PSDrive -Name "TEMPDRIVE" -Force
}

# --- Move to Destination 1 ---
Move-WithCredentials -destPath $destination1 -username $user1 -password $pass1 -filePath $sourcePath
