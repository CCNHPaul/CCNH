# Get the output from manage-bde and convert it to a string
$Protectors = manage-bde -protectors -get C: | Out-String

# Use regex to find the Numerical Password ID
$NumericalPasswordId = [regex]::Match($Protectors, 'Numerical Password:\s*ID:\s*\{[A-F0-9\-]+\}') | ForEach-Object { 
    $_.Value -replace 'Numerical Password:\s*ID:\s*\{|\}', ''
}

# Display the Numerical Password ID (for verification)
$NumericalPasswordId

# Backup the Numerical Password ID to Active Directory
Backup-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId "{${NumericalPasswordId}}"

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUkBCTbq6OPvXzZOQKrx/8v5zv
# ErSgggMQMIIDDDCCAfSgAwIBAgIQN+o39s47b7xKGeApp7qR0DANBgkqhkiG9w0B
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
# CQQxFgQUdaPRE9Q3qHuZIx/wXB8neZUj8PowDQYJKoZIhvcNAQEBBQAEggEAEt4B
# ZOsq+ohbXBdrUUnfVZHM0QtrOQv5MVKKDCbjh2XEQihPL317Hi4Jhpueah+jG1gn
# BTveZQT0TtfIDvReBwTO2okvxmkWkwVdiUiGwK31SvGIIzVvSHmOc1+HNNAz7SBY
# XH7K7QGT9j7WGxa91YE5gAitBOiY508Q9OatRRO42pM9+vomS4guyUJ5l0cS5SsD
# K2cG/5xBtWAMEbswMnqi7NHK7kxmh8bqjj/3YNAM6jtwtP7y7MMU8rYg7QJSfwAZ
# IgHZrejA8LwdFvcOmZh7OwLzdnOat3SAjD57uyaIii+GibTyUYRTfZgvKWunTAaB
# Ly8DTPZ/uVWRy6l1qg==
# SIG # End signature block
