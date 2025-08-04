############### Path & User ###############
$basePath = "\\hub-hcfp-vm\HCH users"
$userToGrant = "CC-NH\hchscanners"  

############### Apply FullControl permissions to all folders recursively ###############
Get-ChildItem -Path $basePath -Recurse -Directory | ForEach-Object {
    $folder = $_.FullName
    Write-Host "Applying permissions to: $folder" -ForegroundColor Cyan
    
    $acl = Get-Acl -Path $folder
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($userToGrant, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.SetAccessRule($rule)
    Set-Acl -Path $folder -AclObject $acl
}

############### Apply Modify permissions to all folders recursively ###############
Get-ChildItem -Path $basePath -Recurse -Directory | ForEach-Object {
    $folder = $_.FullName
    Write-Host "Applying permissions to: $folder" -ForegroundColor Cyan
    
    $acl = Get-Acl -Path $folder
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($userToGrant, "Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.SetAccessRule($rule)
    Set-Acl -Path $folder -AclObject $acl
}

############### Apply ReadAndExecute + Read, Write permissions to all folders recursively ###############
$rights = [System.Security.AccessControl.FileSystemRights]::ReadAndExecute `
        -bor [System.Security.AccessControl.FileSystemRights]::ListDirectory `
        -bor [System.Security.AccessControl.FileSystemRights]::Read `
        -bor [System.Security.AccessControl.FileSystemRights]::Write

Get-ChildItem -Path $basePath -Recurse -Directory | ForEach-Object {
    $folder = $_.FullName
    Write-Host "Applying custom permissions to: $folder" -ForegroundColor Cyan

    $acl = Get-Acl -Path $folder
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($userToGrant, $rights, "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.SetAccessRule($rule)
    Set-Acl -Path $folder -AclObject $acl
}