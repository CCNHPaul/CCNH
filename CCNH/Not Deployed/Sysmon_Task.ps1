# PowerShell script to create a scheduled task and download a script from a network location

# Script details
$sourcePath = "\\hub-fs01-vm\CCNH\IT\Sysmon_Install.ps1"
$destinationDirectory = "C:\temp\startup"
$destinationPath = Join-Path $destinationDirectory "Sysmon_Install.ps1"
$taskName = "MonthlySysmonInstall"
$taskDescription = "Runs Sysmon_Install.ps1 once a month"

# Ensure destination directory exists
New-Item -Path $destinationDirectory -ItemType Directory -Force

# Copy the script from the network location
Copy-Item -Path $sourcePath -Destination $destinationPath -Force

# Task scheduler settings
$action = New-ScheduledTaskAction -Execute "Powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$destinationPath`""

# Setting trigger for 1st day of every month at a specific time (e.g., 10 AM)
# Modify the time as per your requirement
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date -Hour 10 -Minute 0) -RepetitionInterval (New-TimeSpan -Days 30)

$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Register the task
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Description $taskDescription

Write-Host "Scheduled Task created and script downloaded successfully."

