# Output the start time
$startTime = Get-Date
Write-Host "Preventing System Shutdown" -ForegroundColor Green
Write-Host "Script Start Time: $startTime" -ForegroundColor Magenta

# Initialize the timestamp of the last processed event
$lastEventTime = $startTime
# Initialize the last report time to the start time
$lastReportTime = $startTime

while ($true) {
    try {
        # Query the latest shutdown event (ID 1074)
        $shutdownEvent = Get-WinEvent -FilterHashtable @{LogName='System'; Id=1074} -MaxEvents 1

        if ($shutdownEvent) {
            # Check if the event is newer than the last processed event
            if ($shutdownEvent.TimeCreated -gt $lastEventTime) {
                # Update the last processed event time
                $lastEventTime = $shutdownEvent.TimeCreated

                # Try to abort the shutdown
                shutdown /a 2>&1 | Out-Null

                # Check the exit code of the shutdown command
                if ($LASTEXITCODE -eq 0) {
                    $abortTime = Get-Date
                    Write-Host "Shutdown aborted at: $abortTime" -ForegroundColor Gray
                }
                else {
                    Write-Host "Failed to abort shutdown. Exit code: $LASTEXITCODE" -ForegroundColor Red
                }
            }
        }
    }
    catch {
        # Optionally, output the error for debugging
        Write-Host "Error: $_"
    }

    # Check if 30 minutes have passed since the last report
    $currentTime = Get-Date
    if (($currentTime - $lastReportTime).TotalMinutes -ge 30) {
        Write-Host "Current time: $currentTime" -ForegroundColor Cyan
        # Update the last report time
        $lastReportTime = $currentTime
    }

    # Wait before checking again
    Start-Sleep -Seconds 1
}

