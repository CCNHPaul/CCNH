<#
Editor: Visual Studio Code
Script Name: Windows_Upgrade.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 5/14/2024
Description: This PowerShell script downloads the Windows 11 ISO file, mounts it, and then runs the setup.exe in silent mode with EULA acceptance to install Windows 11. 
The script waits for the installation process to complete before unmounting the ISO.
#>

# ISO Download Link
$isoLink = "https://software.download.prss.microsoft.com/dbazure/Win11_24H2_English_x64.iso?t=841cfdd9-cf2e-40b5-b785-68b33466a4b8&P1=1747487768&P2=601&P3=2&P4=UwbB4TivW7CV6pA4XBpohsKomrpsjFw7MK%2f%2f1Cosbe3UZbc%2bL7HBa4pKf0I2hpyInYBCzivWeV3TcTpcStd5vPYIxw3k8W4OXBx0eavNIP8AFzRXhTjqAg3ssqtPze2yq6PYZJiwV%2bV3hWtVVeMI80IUhN1NCZG4WEZaXSqR3SKd06qZkSJjS6WDdHUM2%2fM0l9PnbQl2T3hqNg8z%2bIQN3iQWESItfFA%2fxiNZrNsDjPvpLstN7mEsS6Yq14cO2PzOdEt2xfRqC%2fIwB0AxUqcbWlGpwz3DoAThLJW0AW1avDOC1WrXutps5KMOGDCZrLCVF3xFbz96TXueiurNqHMHmg%3d%3d"
$isoPath = "C:\temp\Win11_24H2.iso"

# Download the Windows 11 ISO
Start-BitsTransfer -Source $isoLink -Destination $isoPath

# Path to the Windows 11 ISO file

# Mount the ISO and get the drive letter
$isoDrive = (Mount-DiskImage -ImagePath $isoPath -PassThru | Get-Volume).DriveLetter

# Start the setup.exe in silent mode with EULA acceptance using cmd.exe
$setupArguments = '/auto upgrade /quiet /eula accept /compat ignorewarning /copylogs C:\Temp\WinUpgrade'
$setupPath = "$($isoDrive):\setup.exe"
$cmdArguments = "/c $setupPath $setupArguments"

# Use cmd.exe to run the setup with the specified arguments
$setupProcess = Start-Process -FilePath "cmd.exe" -ArgumentList $cmdArguments -Wait

# Wait for the setup process and any child processes to complete
while (Get-Process -Id $setupProcess.Id -ErrorAction SilentlyContinue) { Start-Sleep -Seconds 10 }

# Unmount the ISO after installation
Dismount-DiskImage -ImagePath $isoPath

