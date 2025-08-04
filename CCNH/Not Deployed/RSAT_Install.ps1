# Function to display job status
function Show-JobStatus {
    $jobTable = @()
    Get-Job | ForEach-Object {
        $job = $_
        $jobStatus = $job.State
        $jobName = $job.Name
        $jobTable += [PSCustomObject]@{
            "JobName" = $jobName
            "Status" = $jobStatus
        }
    }
    $jobTable | Sort-Object Status | Format-Table -AutoSize
}

# Check if the computer is a server or workstation.
$os = Get-CimInstance -ClassName Win32_OperatingSystem

if ($os.ProductType -eq 3) {
    # For Windows Server operating systems, install RSAT features
    $RSATFeatures = Get-WindowsFeature | Where-Object {$_.Name -like "RSAT*"}
    $RSATFeatures | ForEach-Object {
        $RSATFeature = $_
        $RSATFeatureName = $RSATFeature.Name
        $JobName = "$($RSATFeature.DisplayName)"
        Start-Job -Name $JobName -ScriptBlock {
            param($FeatureName)
            Install-WindowsFeature -Name $FeatureName -IncludeAllSubFeature
        } -ArgumentList $RSATFeatureName
    }
} else {
    # For Windows Client operating systems, install RSAT capabilities
    $RSATCapabilities = Get-WindowsCapability -Name RSAT* -Online
    $RSATCapabilities | ForEach-Object {
        $RSATCapability = $_
        $RSATCapabilityName = $RSATCapability.Name
        $JobName = "$($RSATCapability.DisplayName)"
        Start-Job -Name $JobName -ScriptBlock {
            param($CapabilityName)
            Add-WindowsCapability -Name $CapabilityName -Online
        } -ArgumentList $RSATCapabilityName
    }
}

# Monitor job status
while (Get-Job -State "Running") {
    Clear-Host
    Show-JobStatus
    Start-Sleep -Seconds 5
}

# Display final job status
Clear-Host
Show-JobStatus