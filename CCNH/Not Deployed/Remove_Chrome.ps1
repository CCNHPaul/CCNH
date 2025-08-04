# Define the path for both system level and user level installations of Google Chrome
$systemPaths = @("C:\Program Files\Google\Chrome\Application", "$env:PROGRAMFILES(X86)\Google\Chrome\Application")
$userInstallationPath = "$env:LOCALAPPDATA\Google\Chrome\Application"

# Function to uninstall Google Chrome from a given path
function Uninstall-Chrome($path) {
    $setupFile = Join-Path -Path $path -ChildPath "setup.exe"
    
    if (Test-Path $setupFile) {
        Start-Process $setupFile "/s /norestart --channel=stable --system-level --verbose-logging --force-uninstall" -Wait
    } else {
        Write-Host "No Chrome installation found at path: $path"
    }
}

# Uninstall Google Chrome from system level installations (both 32 and 64 bit)
foreach ($systemPath in $systemPaths) {
    Uninstall-Chrome -path $systemPath
}

# Uninstall Google Chrome from user installation
Uninstall-Chrome -path $userInstallationPath
