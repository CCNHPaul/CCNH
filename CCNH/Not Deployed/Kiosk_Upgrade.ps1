<#
Editor: Visual Studio Code
Script Name: Kiosk_Upgrade.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 07/17/2025
Description: PowerShell script imports TeamViewer registry,
installs TeamViewer Host silently via MSI without customconfig,
assigns device, installs selected RMM silently, and joins domain — no checks.
#>

# Elevate script to run as Administrator if not already
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Determine script and installers folder paths
$scriptRoot = if ($PSCommandPath) { Split-Path -Parent $PSCommandPath } elseif ($MyInvocation.MyCommand.Path) { Split-Path -Parent $MyInvocation.MyCommand.Path } else { Get-Location }
$installersPath = Join-Path $scriptRoot

# Install TeamViewer Host silently
$tvHostInstaller = Join-Path $installersPath "TeamViewer_Host.msi"
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$tvHostInstaller`" /qn" -Wait

Start-Sleep -Seconds 20

# Assign TeamViewer client to account (replace ID with your own)
Start-Process -FilePath "cmd.exe" -ArgumentList '/c', '"C:\Program Files\TeamViewer\TeamViewer.exe" assignment --id 0001CoABChDOhQbQZkAR8JjFWgU1d5M3EigIACAAAgAJAJ0W2jmC5aSXscl-nVCrph5J1gWSUqfHhJJ0b2DoBXTHGkCk1dqBXV_nRQZte6D8wSS7mK42-SktXNKyHsoYtw4pUpmzpq067GIBDg_O8joUuglVH65I-gR2dSbnqmk1vc-2IAEQsf6Ptw4='

# Define installers as a hashtable
$installers = @{
    "MTC.EXE" = "Site MTC"
    "STA.EXE" = "Site STA"
    "STF.EXE" = "Site STF"
    "STT.EXE" = "Site STT"
    "STV.EXE" = "Site STV"
    "WHC.EXE" = "Site WHC"
}

# Define a fixed ordered list of keys
$installerKeys = @("MTC.EXE", "STA.EXE", "STF.EXE", "STT.EXE", "STV.EXE", "WHC.EXE")

# Display the numbered list
for ($i = 0; $i -lt $installerKeys.Count; $i++) {
    $key = $installerKeys[$i]
    Write-Output ("{0}. {1} - {2}" -f ($i + 1), $key, $installers[$key])
}

# Prompt until valid selection
do {
    $selection = Read-Host "Enter the number corresponding to the installer"
} while (-not ([int]::TryParse($selection, [ref]$null)) -or $selection -lt 1 -or $selection -gt $installerKeys.Count)

[int]$selection = $selection

# Select the installer based on user input
$selectedInstaller = $installerKeys[$selection - 1]
$selectedInstallerPath = Join-Path $installersPath $selectedInstaller

# Run the selected installer silently
Start-Process -FilePath $selectedInstallerPath -ArgumentList "/silent" -Wait

# Define domain join credentials
$domain = "cc-nh.local"
$username = "$domain\administrator"
$password = "ptfb2009!!" | ConvertTo-SecureString -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username, $password)

# Join computer to domain
Add-Computer -DomainName $domain -Credential $credential

# Final wait before reboot or script exit
Read-Host "Done.... Waiting for reboot"
