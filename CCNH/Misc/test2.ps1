<#
Editor: Visual Studio Code
Script Name: MigrateLocalProfileToDomain_GUI.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 06/27/2025
Description: GUI tool to migrate a local user profile to a domain user profile by updating registry and permissions.
#>

Add-Type -AssemblyName System.Windows.Forms

# Create Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Local to Domain Profile Migration"
$form.Size = New-Object System.Drawing.Size(400,250)
$form.StartPosition = "CenterScreen"

# Local Username Label & TextBox
$labelLocalUser = New-Object System.Windows.Forms.Label
$labelLocalUser.Location = New-Object System.Drawing.Point(10,20)
$labelLocalUser.Size = New-Object System.Drawing.Size(150,20)
$labelLocalUser.Text = "Local Username:"
$form.Controls.Add($labelLocalUser)

$textBoxLocalUser = New-Object System.Windows.Forms.TextBox
$textBoxLocalUser.Location = New-Object System.Drawing.Point(160,18)
$textBoxLocalUser.Size = New-Object System.Drawing.Size(200,20)
$form.Controls.Add($textBoxLocalUser)

# Domain Name Label & TextBox
$labelDomain = New-Object System.Windows.Forms.Label
$labelDomain.Location = New-Object System.Drawing.Point(10,60)
$labelDomain.Size = New-Object System.Drawing.Size(150,20)
$labelDomain.Text = "Domain Name:"
$form.Controls.Add($labelDomain)

$textBoxDomain = New-Object System.Windows.Forms.TextBox
$textBoxDomain.Location = New-Object System.Drawing.Point(160,58)
$textBoxDomain.Size = New-Object System.Drawing.Size(200,20)
$form.Controls.Add($textBoxDomain)

# Domain Username Label & TextBox
$labelDomainUser = New-Object System.Windows.Forms.Label
$labelDomainUser.Location = New-Object System.Drawing.Point(10,100)
$labelDomainUser.Size = New-Object System.Drawing.Size(150,20)
$labelDomainUser.Text = "Domain Username:"
$form.Controls.Add($labelDomainUser)

$textBoxDomainUser = New-Object System.Windows.Forms.TextBox
$textBoxDomainUser.Location = New-Object System.Drawing.Point(160,98)
$textBoxDomainUser.Size = New-Object System.Drawing.Size(200,20)
$form.Controls.Add($textBoxDomainUser)

# Status label
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Location = New-Object System.Drawing.Point(10, 140)
$statusLabel.Size = New-Object System.Drawing.Size(360,40)
$statusLabel.Text = ""
$form.Controls.Add($statusLabel)

# Button
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(150,180)
$button.Size = New-Object System.Drawing.Size(100,30)
$button.Text = "Migrate Profile"
$form.Controls.Add($button)

# Function to get SID from username
function Get-SID($User) {
    try {
        $ntAccount = New-Object System.Security.Principal.NTAccount($User)
        $sid = $ntAccount.Translate([System.Security.Principal.SecurityIdentifier])
        return $sid.Value
    } catch {
        return $null
    }
}

# Button click event
$button.Add_Click({
    $localUser = $textBoxLocalUser.Text.Trim()
    $domain = $textBoxDomain.Text.Trim()
    $domainUser = $textBoxDomainUser.Text.Trim()

    if ([string]::IsNullOrEmpty($localUser) -or [string]::IsNullOrEmpty($domain) -or [string]::IsNullOrEmpty($domainUser)) {
        [System.Windows.Forms.MessageBox]::Show("Please fill in all fields.", "Error", 'OK', 'Error')
        return
    }

    $statusLabel.Text = "Starting migration..."
    $form.Refresh()

    $localProfilePath = "C:\Users\$localUser"
    if (-not (Test-Path $localProfilePath)) {
        [System.Windows.Forms.MessageBox]::Show("Local profile path does not exist: $localProfilePath", "Error", 'OK', 'Error')
        $statusLabel.Text = "Migration failed."
        return
    }

    $fullDomainUser = "$domain\$domainUser"
    $domainUserSID = Get-SID $fullDomainUser
    if (-not $domainUserSID) {
        [System.Windows.Forms.MessageBox]::Show("Could not find SID for domain user: $fullDomainUser", "Error", 'OK', 'Error')
        $statusLabel.Text = "Migration failed."
        return
    }

    # Registry profile list path
    $profileListKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"

    # Remove existing key for domain user SID if exists
    if (Test-Path "$profileListKey\$domainUserSID") {
        Remove-Item -Path "$profileListKey\$domainUserSID" -Recurse -Force
    }

    # Create new key for domain user SID
    New-Item -Path "$profileListKey\$domainUserSID" -Force | Out-Null
    New-ItemProperty -Path "$profileListKey\$domainUserSID" -Name "ProfileImagePath" -Value $localProfilePath -PropertyType String -Force | Out-Null
    New-ItemProperty -Path "$profileListKey\$domainUserSID" -Name "Flags" -Value 0 -PropertyType DWord -Force | Out-Null
    New-ItemProperty -Path "$profileListKey\$domainUserSID" -Name "State" -Value 0 -PropertyType DWord -Force | Out-Null

    # Take ownership of profile folder
    $statusLabel.Text = "Taking ownership of profile folder..."
    $form.Refresh()
    Start-Process -FilePath "takeown.exe" -ArgumentList "/F `"$localProfilePath`" /R /D Y" -Wait -NoNewWindow

    # Set permissions
    $statusLabel.Text = "Setting permissions for $fullDomainUser..."
    $form.Refresh()
    Start-Process -FilePath "icacls.exe" -ArgumentList "`"$localProfilePath`" /grant `"$fullDomainUser`":(OI)(CI)F /T" -Wait -NoNewWindow

    $statusLabel.Text = "Migration completed successfully! Log off and log in as $domainUser."
    [System.Windows.Forms.MessageBox]::Show("Migration completed successfully! Log off and log in as $domainUser.", "Success", 'OK', 'Information')
})

# Show form
[void]$form.ShowDialog()
