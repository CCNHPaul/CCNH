# Define the path to the XML file in C:\Windows\Temp
$xmlFilePath = "C:\Windows\Temp\WiFiProfile.xml"

# Create the XML content
$xmlContent = @"
<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
  <name>MTC-Business</name>
  <SSIDConfig>
    <SSID>
      <name>MTC-Business</name>
    </SSID>
    <nonBroadcast>false</nonBroadcast>
  </SSIDConfig>
  <connectionType>ESS</connectionType>
  <connectionMode>auto</connectionMode>
  <MSM>
    <security>
      <authEncryption>
        <authentication>WPA2PSK</authentication>
        <encryption>AES</encryption>
        <useOneX>false</useOneX>
      </authEncryption>
      <sharedKey>
        <keyType>passPhrase</keyType>
        <protected>false</protected>
        <keyMaterial>Bus1nEssOnly!</keyMaterial>
      </sharedKey>
    </security>
  </MSM>
  <MacRandomization xmlns="http://www.microsoft.com/networking/WLAN/profile/v3">
    <enableRandomization>false</enableRandomization>
  </MacRandomization>
</WLANProfile>
"@

# Save the XML content to a file in C:\Windows\Temp
$xmlContent | Set-Content -Path $xmlFilePath -Encoding UTF8

# Run the Netsh command to add the profile
Start-Process "netsh" -ArgumentList "wlan add profile filename=`"$xmlFilePath`"" -NoNewWindow -Wait

# Check if the profile was added successfully
$profileAdded = (netsh wlan show profiles | Select-String -Pattern "Business")

# If the profile was added successfully, delete the XML file
if ($profileAdded) {
    Remove-Item -Path $xmlFilePath -Force
    Write-Host "Wi-Fi profile added and file deleted successfully."
} else {
    Write-Host "Failed to add Wi-Fi profile."
}

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU5zlG/NNaW4MM0AHFGJ1rubuZ
# CEGgggMQMIIDDDCCAfSgAwIBAgIQN+o39s47b7xKGeApp7qR0DANBgkqhkiG9w0B
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
# CQQxFgQU73Ja3T87Xd38Oo+95an/Uq0x8x8wDQYJKoZIhvcNAQEBBQAEggEASsL1
# CRiTtqyF1YTqCXIUYP65HfdIs9+v6Ry8DQzA22Y5a6a6LFsqGJ+C4EQh9XccQSLB
# 2gb3wndJa2GKD7pJaa2AX6jW7vcATdQJ+7C2uuLHbBPVjEn/YwNh/G2vxkSyT9A5
# 3dzW9ulX4woNTqfIb4+9kpBR9TkCslw2vMyDYh9oZBT4eRpxykDyykITRtfX1JJ/
# hyxJCbl+XfN22C+w2gwe398ZbLGb5LUvajKb3Z+tWRrsaGBuYkBTf1ShR+K6iXSF
# wSfZymC+xuzi8RNmh2q/8HCSwbQPAjEoXoHuVZPzRRvjIX+IVcLNHn1X31oLs+v5
# yS58X9u++SSUcCatMQ==
# SIG # End signature block
