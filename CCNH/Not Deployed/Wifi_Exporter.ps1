# Capture Wifi
netsh wlan show profiles

# Define folder for export and WiFi name
$ExportFolder = "C:\Temp"
$WiFiName = "Business"
$ExportedFile = "$ExportFolder\Wi-Fi-$WiFiName.xml"

# Capture Wifi profiles
Write-Output "Capturing available WiFi profiles..."
netsh wlan show profiles

# Export specific WiFi profile to XML
Write-Output "Exporting WiFi profile '$WiFiName' to $ExportFolder..."
netsh wlan export profile name=$WiFiName folder=$ExportFolder key=clear

# Import WiFi profile from XML
Write-Output "Importing WiFi profile from $ExportedFile..."
netsh wlan add profile filename=$ExportedFile

