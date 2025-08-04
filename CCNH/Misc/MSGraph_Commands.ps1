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





function Decode-Jwt {
    param([string]$Jwt)
    # Split into header.payload.signature
    $parts = $Jwt.Split('.')
    # Fix base64 padding, decode the payload (part[1])
    $payload = $parts[1].PadRight($parts[1].Length + (4 - ($parts[1].Length % 4)) % 4, '=')
    $bytes   = [Convert]::FromBase64String($payload)
    $json    = [Text.Encoding]::UTF8.GetString($bytes)
    return $json | ConvertFrom-Json
}


# Your app details
$tenantId    = 'b7b66b49-5ab3-40ef-894c-8c7c9fa00728'
$clientId    = '618614de-78e6-441f-a03c-3688c086a1f4'
$clientSecret= '52H8Q~lhf~tuKyT8_rK.lrflfrqXMzCGIqMI~a_y'

# Acquire token (form-urlencoded!)
$tokenBody = @{
  grant_type    = 'client_credentials'
  client_id     = $clientId
  client_secret = $clientSecret
  scope         = 'https://graph.microsoft.com/.default'
}
$tokenResp = Invoke-RestMethod -Method Post `
  -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" `
  -ContentType 'application/x-www-form-urlencoded' `
  -Body $tokenBody

# Make sure we actually got a token
if (-not $tokenResp.access_token) {
  Write-Error "Failed to get access_token. Response was:`n$($tokenResp | ConvertTo-Json -Depth 4)"
  return
}

$token = $tokenResp.access_token
Write-Host "Got token, length:" $token.Length


####
$claims = Decode-Jwt $token
"Roles in token: " + ($claims.roles -join ', ')
