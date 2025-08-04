<#
Editor: Visual Studio Code
Script Name: Sync-IntuneDevice-GUI.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 08/01/2025
Description: GUI to sync one device by name or launch SyncAllIntune.ps1 in its own console.
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Azure AD app credentials
$tenantId     = 'b7b66b49-5ab3-40ef-894c-8c7c9fa00728'
$clientId     = '618614de-78e6-441f-a03c-3688c086a1f4'
$clientSecret = '52H8Q~lhf~tuKyT8_rK.lrflfrqXMzCGIqMI~a_y'

function Get-GraphToken {
    param($tenantId, $clientId, $clientSecret)
    $body = @{
        grant_type    = 'client_credentials'
        client_id     = $clientId
        client_secret = $clientSecret
        scope         = 'https://graph.microsoft.com/.default'
    }
    (Invoke-RestMethod -Method Post `
      -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" `
      -Body $body).access_token
}

function Invoke-DeviceSync {
    param($deviceName)
    $token = Get-GraphToken -tenantId $tenantId -clientId $clientId -clientSecret $clientSecret
    $dev   = Invoke-RestMethod -Method Get `
      -Uri "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices?`$filter=deviceName eq '$deviceName'&`$select=id" `
      -Headers @{ Authorization = "Bearer $token" }
    if ($dev.value) {
        Invoke-RestMethod -Method Post `
          -Uri "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices/$($dev.value[0].id)/syncDevice" `
          -Headers @{ Authorization = "Bearer $token" }
        [System.Windows.Forms.MessageBox]::Show("Sync requested for '$deviceName'","Success",
            [System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information)
    }
    else {
        [System.Windows.Forms.MessageBox]::Show("Device '$deviceName' not found.","Error",
            [System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error)
    }
}

# Build the form
$form = New-Object System.Windows.Forms.Form -Property @{
    Text          = 'Intune Device Sync'
    Size          = New-Object System.Drawing.Size(380,170)
    StartPosition = 'CenterScreen'
}

# Label
$lbl = New-Object System.Windows.Forms.Label -Property @{
    Text     = 'Enter device name:'
    AutoSize = $true
    Location = New-Object System.Drawing.Point(10,20)
}
$form.Controls.Add($lbl)

# TextBox
$txt = New-Object System.Windows.Forms.TextBox -Property @{
    Size     = New-Object System.Drawing.Size(360,20)
    Location = New-Object System.Drawing.Point(10,45)
}
$form.Controls.Add($txt)

# Sync Device button
$btnSync = New-Object System.Windows.Forms.Button -Property @{
    Text     = 'Sync Device'
    Size     = New-Object System.Drawing.Size(110,30)
    Location = New-Object System.Drawing.Point(10,80)
}
$btnSync.Add_Click({
    if ($txt.Text) { Invoke-DeviceSync -deviceName $txt.Text }
    else {
        [System.Windows.Forms.MessageBox]::Show("Please enter a device name.","Warning",
            [System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Warning)
    }
})
$form.Controls.Add($btnSync)

# Sync All button
$btnAll = New-Object System.Windows.Forms.Button -Property @{
    Text     = 'Sync All'
    Size     = New-Object System.Drawing.Size(110,30)
    Location = New-Object System.Drawing.Point(130,80)
}
$btnAll.Add_Click({
    # path to the standalone script
    $allScript = Join-Path $PSScriptRoot 'SyncAllIntune.ps1'

    # build the PowerShell command line (with proper quoting)
    $psCmd = '-NoProfile -ExecutionPolicy Bypass -File "' + $allScript +
             '" -tenantId "'    + $tenantId     +
             '" -clientId "'    + $clientId     +
             '" -clientSecret "'+ $clientSecret + '"'

    # launch a CMD window that runs PowerShell and then stays open
    Start-Process 'cmd.exe' -ArgumentList "/K powershell.exe $psCmd"
})
$form.Controls.Add($btnAll)

# Show the form
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
