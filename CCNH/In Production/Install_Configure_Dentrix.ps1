<#
Editor: Visual Studio Code
Script Name: Install_Configure_Dentrix.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 03/11/2025
Description: Installs Dentrix from C:\Temp, configures SQL Alias, and sets up an ODBC System DSN.
#>

# Define Variables
$InstallerLocal = "C:\Temp\Setup_DE_11.0.20.1141.i1.exe"
$INILocal = "C:\Temp\DEInstallOptions.ini"

# Run silent installation
Start-Process -FilePath $InstallerLocal -ArgumentList "/S:$INILocal" -Wait -NoNewWindow

# Configure SQL Alias & ODBC DSN
$AliasName = "Dentrix"
$SQLServerName = "172.16.10.25\DENTRIXPROD"
$DSNName = "Dentrix"
$DatabaseName = "DentrixDB"
$SQLUser = "enterprise"
$SQLPassword = "Dx_1019!"

Function Set-SQLAlias {
    param ([string]$AliasName, [string]$SQLServer)
    $RegPath64 = "HKLM:\SOFTWARE\Microsoft\MSSQLServer\Client\ConnectTo"
    $RegPath32 = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\MSSQLServer\Client\ConnectTo"

    New-Item -Path $RegPath64 -Force | Out-Null
    New-Item -Path $RegPath32 -Force | Out-Null

    New-ItemProperty -Path $RegPath64 -Name $AliasName -Value "DBMSSOCN,$SQLServer" -PropertyType String -Force
    New-ItemProperty -Path $RegPath32 -Name $AliasName -Value "DBMSSOCN,$SQLServer" -PropertyType String -Force
}

Function Set-ODBCDSN {
    param ([string]$DSNName, [string]$ServerName, [string]$DatabaseName, [string]$SQLUser, [string]$SQLPassword)
    $ODBCRegPath = "HKLM:\SOFTWARE\ODBC\ODBC.INI\$DSNName"

    New-Item -Path $ODBCRegPath -Force | Out-Null
    Set-ItemProperty -Path $ODBCRegPath -Name "Driver" -Value "SQL Server"
    Set-ItemProperty -Path $ODBCRegPath -Name "Description" -Value "Dentrix SQL Server DSN"
    Set-ItemProperty -Path $ODBCRegPath -Name "Server" -Value $ServerName
    Set-ItemProperty -Path $ODBCRegPath -Name "Database" -Value $DatabaseName
    Set-ItemProperty -Path $ODBCRegPath -Name "UserID" -Value $SQLUser
    Set-ItemProperty -Path $ODBCRegPath -Name "Password" -Value $SQLPassword
    Set-ItemProperty -Path "HKLM:\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" -Name $DSNName -Value "SQL Server"
}

# Execute SQL Alias & ODBC Setup
Set-SQLAlias -AliasName $AliasName -SQLServer $SQLServerName
Set-ODBCDSN -DSNName $DSNName -ServerName $SQLServerName -DatabaseName $DatabaseName -SQLUser $SQLUser -SQLPassword $SQLPassword

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUxOLgPgZPWM7A507tKnmHLr8X
# O/egggMQMIIDDDCCAfSgAwIBAgIQN+o39s47b7xKGeApp7qR0DANBgkqhkiG9w0B
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
# CQQxFgQUL67I0VKRuIsqcsXnz4pndxPO6IcwDQYJKoZIhvcNAQEBBQAEggEAZpKN
# 6aojoq3fkkqtRi2xanPy/0JneTQLvF59HDCcLvekS+ODtW/PZgHUKy9cC/hUhJXP
# qvPjm/loW6W0FhyUShdwVDDLDtQVENaN9V5y3Xs8jrHANlrm2BwIhF3sw//6H9BW
# eWNY7wJmU1c81qP4/QkAGuR87UM5QJv9cbRsWWCNgvpoRapg6MpHdUZDJ0ed5SWf
# HTnQDXoJGef40fwNj+007ifn/dXgJ0xaJNuviZyqIJ4RnGFDEGRk7u3beOmnSwfq
# 3bPt9JXCo5hk1a0Lm3BpfxxyAfOtpoO5YWjft3nDywne7G5w8YKxYRMQCPGsntkU
# upLbb/hv5rUQih3VtQ==
# SIG # End signature block
