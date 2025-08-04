# Initialize list to store user profiles
$UserProfilesList = [System.Collections.Generic.List[PSCustomObject]]::new()

# Get user profiles from registry
$UserProfiles = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\*" | 
    Where-Object {$_.PSChildName -match "S-1-5-..-.*"} | 
    Select-Object @{Name = 'SID'; Expression = {$_.PSChildName}},
                   @{'Property'='UserHive'; 'Value'={"$($_.ProfileImagePath)\NTUSER.DAT"}}
foreach ($UserProfile in $UserProfiles) {
    # Add user profile to the list only if the NTUSER.DAT file exists for that user profile
    if (Test-Path $UserProfile.UserHive) {
        $UserProfilesList.Add($UserProfile) | Out-Null
    }
}

# Add default user profile to the list
$DefaultUser = [PSCustomObject]@{
    SID = 'DEF';
    UserHive = "$((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList").Default)\NTUSER.DAT"
} 
if (Test-Path $DefaultUser.UserHive) {
    $UserProfilesList.Add($DefaultUser) | Out-Null
}

# Loop through each user profile to set screen saver settings
foreach ($UserProfile in $UserProfilesList) {
    try {
        if (Test-Path $UserProfile.UserHive) {
            # Load user's registry hive
            New-PSDrive -PSProvider Registry -Name HKU -Root "HKEY_USERS" | Out-Null

            # Set screen saver settings
            Set-ItemProperty -Path "HKU:\$($UserProfile.SID)\Control Panel\Desktop" -Name "ScreenSaveActive" -Value 1
            Set-ItemProperty -Path "HKU:\$($UserProfile.SID)\Control Panel\Desktop" -Name "SCRNSAVE.EXE" -Value "C:\Windows\System32\Ribbons.scr"
            Set-ItemProperty -Path "HKU:\$($UserProfile.SID)\Control Panel\Desktop" -Name "ScreenSaveTimeOut" -Value 900
            Set-ItemProperty -Path "HKU:\$($UserProfile.SID)\Control Panel\Desktop" -Name "ScreenSaverIsSecure" -Value 1
        }
    } catch {
        Write-Error "Error processing user profile $($UserProfile.SID): $_"
    } finally {
        # Unload user's registry hive
        if (Test-Path "HKU:\") {
            Remove-PSDrive HKU | Out-Null
        }
    }
}
# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUcZzh3/wGpgTywkri4mFPywIB
# z7KgggMQMIIDDDCCAfSgAwIBAgIQaeC0KMRN3rZOn8/BhmrnWzANBgkqhkiG9w0B
# AQsFADAeMRwwGgYDVQQDDBNDQ05IIFNjcmlwdCBTaWduaW5nMB4XDTI0MTIyMDEz
# NDk0MVoXDTI1MTIyMDE0MDk0MVowHjEcMBoGA1UEAwwTQ0NOSCBTY3JpcHQgU2ln
# bmluZzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMVtWGjRaYpp///+
# 8pBVB8GuWIH8QKNBrCfvNqryCiqlZXLmc4R6pqcMfe3oncM7E2C5Sf5x386lMaKa
# vthmaIGMdS1clB9U+w1c8UMwXFKIUiYebMc8D/vp2pVbOU1aw9Y3B/mFs+605mCT
# nHiiRFIQynRDPGEBw8G15PVqGcQXWj2MLIKEGfCy5QIAXBenX5VRAAvGitltYqSm
# ihoLbry0bo5SVn8jjWlo2WC+2j6huBYdlkXkPBLS43rxJpkRNnxxoeo6TI5FFBxF
# C/i03LhY1wEWTcFhQBusMEpwcvk4gCYm6vJMCmXBPbwiNnQZst2b6COQ8Tcd/IKP
# OsGe58ECAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMB0GA1UdDgQWBBTsBBnVKbLEb8V5iO4PGYOWnV007jANBgkqhkiG9w0BAQsF
# AAOCAQEAGXpxyJgGAPqVfWGvA8tT9OYhfJVrJLjE1niCyUClUPYDLdoj9lNeEQ0K
# jD75F2ka+1fNmQFT0FnRj53Jd1MFNr1w5MpOoWCVCByppK0DzD9Ih1JHATXlBMWK
# ioduyhMWwY1CRchMEFzEFSAQzvR1NBDfRT7jqs0XlM19GEomeuHa/siHW64J3I3F
# KJWDCMfhg0UmnUHmPgFwMng0mNy9CwXaFJZI9Zhr3szD9KY1H+Gb8kbW9ViahioI
# Eugk17w4tedagel3uVl84+EWOZCQH1MJYx3yjnXmy/YNKPHDQSXkub7+uu3i1Otx
# p3Wyx06lqwTWjIDazQuohqKUYzCF/TGCAdMwggHPAgEBMDIwHjEcMBoGA1UEAwwT
# Q0NOSCBTY3JpcHQgU2lnbmluZwIQaeC0KMRN3rZOn8/BhmrnWzAJBgUrDgMCGgUA
# oHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0B
# CQQxFgQUM2q0LV0QGsaEqkByMBwIJl9prk0wDQYJKoZIhvcNAQEBBQAEggEAcMOR
# 9PA09GKW2371BE2iKJ8ynYTW4RBimpzBMBM1EfG19jawAIhi/dnY+RmoZqaA/Grz
# AWtsrbME0dRWgdQ+Fnzejw6H+4LbwkhY3RnQpSuLHpDb4zqqxJ5LvBDsUhelO1ps
# D+LJpZqCo6hkbEQpLVbLYi9LSHImxXjoujolo3iCTLsmTWcWvjSU/Qkcqn+xSLM0
# AIHxzKgpTiiVx5npplNtYalbGzUE6tuso/THGdgaoQ16eVUDff3wjDyv4/d6Kl2W
# e9i9F6AB/m6EZldPybJQqO1HbiO9btQ4Z/r5YmsRJGDkWuP+Ah3Atc6LyR1xL4mX
# oWcJ13VGDEUlPsI9GA==
# SIG # End signature block
