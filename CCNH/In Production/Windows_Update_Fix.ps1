<#
Editor: Visual Studio Code
Script Name: Reset-WindowsUpdateComponents.ps1
Author: Paul Hanlon for Catholic Charities NH (Modified by ChatGPT)
Created: 01/22/2025
Description: PowerShell script to reset Windows Update components and associated services.
#>

# Ensure the script is run as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator." -ForegroundColor Red
    Exit 1
}

# Function to stop services with retries
function Stop-ServiceWithRetry {
    param (
        [string]$ServiceName,
        [int]$RetryCount = 5
    )
    $attempt = 0
    do {
        $attempt++
        Write-Host "Stopping $ServiceName (Attempt $attempt of $RetryCount)..."
        try {
            Stop-Service -Name $ServiceName -Force -ErrorAction Stop
        } catch {
            Write-Host "Error stopping $ServiceName $_" -ForegroundColor Yellow
        }
        Start-Sleep -Seconds 2
        $status = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
    } while ($status.Status -ne 'Stopped' -and $attempt -lt $RetryCount)

    if ($status.Status -ne 'Stopped') {
        Write-Host "Failed to stop $ServiceName after $RetryCount attempts." -ForegroundColor Red
        Exit 1
    } else {
        Write-Host "$ServiceName stopped successfully."
    }
}

# List of services to stop and later restart
$services = @("bits", "wuauserv", "appidsvc", "cryptsvc")
foreach ($service in $services) {
    Stop-ServiceWithRetry -ServiceName $service
}

# Function to take ownership of directories
function Take-Ownership {
    param (
        [string]$Path
    )
    Write-Host "Taking ownership of $Path..."
    $takeown = Start-Process -FilePath "takeown.exe" -ArgumentList "/f `"$Path`" /r /d y" -NoNewWindow -Wait -PassThru
    if ($takeown.ExitCode -ne 0) {
        Write-Host "Failed to take ownership of $Path. Exiting." -ForegroundColor Red
        Exit 1
    } else {
        Write-Host "Successfully took ownership of $Path."
    }
}

# Clear Windows Update temporary files
$paths = @(
    "$env:windir\SoftwareDistribution\download",
    "$env:windir\system32\Catroot2"
)

foreach ($path in $paths) {
    if (Test-Path -Path $path) {
        Take-Ownership -Path $path
        Write-Host "Deleting $path..."
        try {
            Remove-Item -Path $path -Recurse -Force -ErrorAction Stop
            Write-Host "$path deleted successfully."
        } catch {
            Write-Host "Failed to delete $path $_" -ForegroundColor Yellow
        }
    } else {
        Write-Host "Path $path does not exist. Skipping..."
    }
}

# Reset Winsock
Write-Host "Resetting Winsock..."
try {
    netsh winsock reset | Out-Null
    netsh winsock reset proxy | Out-Null
    Write-Host "Winsock reset successfully."
} catch {
    Write-Host "Failed to reset Winsock: $_" -ForegroundColor Red
}

# Re-register Windows Update DLLs using full path lookup in system directories
Write-Host "Re-registering Windows Update DLLs..."
$DLLs = @("atl.dll", "urlmon.dll", "mshtml.dll", "shdocvw.dll", "browseui.dll", "jscript.dll", "vbscript.dll", "scrrun.dll", "msxml.dll", "msxml3.dll", "msxml6.dll", "actxprxy.dll", "softpub.dll", "wintrust.dll", "dssenh.dll", "rsaenh.dll", "gpkcsp.dll", "sccbase.dll", "slbcsp.dll", "cryptdlg.dll", "oleaut32.dll", "ole32.dll", "shell32.dll", "initpki.dll", "wuapi.dll", "wuaueng.dll", "wuaueng1.dll", "wucltui.dll", "wups.dll", "wups2.dll", "wuweb.dll", "qmgr.dll", "qmgrprxy.dll", "wucltux.dll", "muweb.dll", "wuwebv.dll")
$systemDirs = @("$env:windir\system32", "$env:windir\SysWOW64")
foreach ($DLL in $DLLs) {
    $dllFound = $false
    foreach ($dir in $systemDirs) {
        $dllPath = Join-Path -Path $dir -ChildPath $DLL
        if (Test-Path $dllPath) {
            try {
                & regsvr32.exe /s $dllPath
                Write-Host "Registered $dllPath successfully."
            } catch {
                Write-Host "Failed to register $dllPath $_" -ForegroundColor Yellow
            }
            $dllFound = $true
            break
        }
    }
    if (-not $dllFound) {
        Write-Host "$DLL not found in system directories. Skipping registration."
    }
}

# Start services
Write-Host "Starting services..."
foreach ($service in $services) {
    try {
        Start-Service -Name $service -ErrorAction Stop
        Write-Host "Started service: $service."
    } catch {
        Write-Host "Failed to start service: $service. Error: $_" -ForegroundColor Red
    }
}

Write-Host "Task completed successfully! Please restart your computer." -ForegroundColor Green

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUVP3vHPFC9yaKVC31VGgWs97N
# dbagggMQMIIDDDCCAfSgAwIBAgIQN+o39s47b7xKGeApp7qR0DANBgkqhkiG9w0B
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
# CQQxFgQUwaGFmQCyuzijVYT1IlPadmyPiFowDQYJKoZIhvcNAQEBBQAEggEAs7LN
# O/ePUV3T42FO/yM5cDNFdi5UOqDeJQ00G+bjre/k+akHRnue6ol7fAvpfGjcqwxq
# WeTEhVycM0Z6hV2HsMx/HGjDC0O/lwynRJSITqvchDwj617ZDHbSOpuGD2WpJTQA
# 886hqlY6Q8Q30DYAHkQYCgoL9LfnhWa9iIuHi50zhBqiDY5kkw933EJG/ds1uxw1
# Fa+UJgJQCmMron+s0gPaz28dPbK8hTgfkxPYmbHHyg2ecvnvT6qLz3LdPB9RnipG
# b5QTMt9uXvTpg7rOA+wIuxyiYFdKGsPf29a0WW/dx2IylDAK2egZZoZL2OCeU3vH
# 7r9JNgAJFo0CxKxa0Q==
# SIG # End signature block
