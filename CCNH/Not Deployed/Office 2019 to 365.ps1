$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Office\16.0\Common\OfficeUpdate"
$regName = "vltosubscription"
$regValue = 1  # Set to 1 to enable upgrade, 0 to disable

# Check if the registry path exists, if not create it
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force
}

# Set the registry value
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord

Write-Host "Registry setting applied: $regName = $regValue"

