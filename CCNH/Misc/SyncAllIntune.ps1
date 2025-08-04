<#
Editor: Visual Studio Code
Script Name: SyncAllIntune.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 08/01/2025
Description: Sync **all** managed Intune devices when run standalone.
#>

# 1) Your Azure AD app’s details:
$tenantId   = 'b7b66b49-5ab3-40ef-894c-8c7c9fa00728'
$clientId   = '618614de-78e6-441f-a03c-3688c086a1f4'
$clientSecret = '52H8Q~lhf~tuKyT8_rK.lrflfrqXMzCGIqMI~a_y'

# 2) Grab a token via client-credentials:
$tokenBody = @{
    grant_type    = 'client_credentials'
    client_id     = $clientId
    client_secret = $clientSecret
    scope         = 'https://graph.microsoft.com/.default'
}
$tokenResp = Invoke-RestMethod -Method Post `
    -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" `
    -Body $tokenBody
$token = $tokenResp.access_token

# 3) Get all managed devices:
$devices = Invoke-RestMethod -Method Get `
  -Uri 'https://graph.microsoft.com/v1.0/deviceManagement/managedDevices?$select=id,deviceName' `
  -Headers @{ Authorization = "Bearer $token" }

# 4) Loop and trigger syncDevice on each:
foreach ($d in $devices.value) {
    Invoke-RestMethod -Method Post `
      -Uri "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices/$($d.id)/syncDevice" `
      -Headers @{ Authorization = "Bearer $token" }
    Write-Host "Sync requested for $($d.deviceName)"
}
exit 0
# End of script