<#
Editor: Visual Studio Code
Script Name: Merge_AD_AAD.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 06/10/2025
Description: Automates merging of on-prem AD accounts with Azure AD using ImmutableID matching. 
Moves all users first to Do Not Sync OU, then one-by-one assigns ImmutableID and moves back to their original OU.
Removes deletion of deleted users and pauses after initial sync for user confirmation.
#>

# Path to CSV file
$CsvPath = "C:\Temp\Merge_Users.csv"

# Import the CSV
$UserList = Import-Csv -Path $CsvPath

#--- Static parameters ---
$DoNotSyncOU = "OU=Azure AD - Do Not Sync,OU=Accounts,DC=CC-NH,DC=local"

# Define the target computer name
$ComputerName = "HUB-DC1-VM"

# Define credentials (ensure these are secured in a production environment)
$Username = "cc-nh.local\administrator"
$Password = "ptfb2009!!"

# Convert password to a secure string
$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force

# Create PSCredential object
$Credential = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)

Import-Module ActiveDirectory
Import-Module AzureAD

#--- Connect to Azure AD ONCE outside the loop ---
Write-Output "Please log into Azure AD..."
Connect-AzureAD

# --- Store original OUs for all users ---
$UserOUs = @{}

# --- Step 1: Move ALL users to 'Do Not Sync' OU and remember their original OU ---
foreach ($User in $UserList) {
    $ADUserSamAccountName = $User.ADUserSamAccountName

    if ([string]::IsNullOrWhiteSpace($ADUserSamAccountName)) {
        Write-Warning "Skipping user with empty ADUserSamAccountName."
        Continue
    }

    Try {
        $ADUser = Get-ADUser -Identity $ADUserSamAccountName
        # Extract the user's current OU by removing the CN portion from DistinguishedName
        $CurrentOU = ($ADUser.DistinguishedName -replace '^CN=[^,]+,', '') 
        # Save original OU for later
        $UserOUs[$ADUserSamAccountName] = $CurrentOU

        Write-Output "Moving $ADUserSamAccountName from $CurrentOU to Do Not Sync OU..."
        Move-ADObject -Identity $ADUser.DistinguishedName -TargetPath $DoNotSyncOU
    }
    Catch {
        Write-Error "Failed to move user $ADUserSamAccountName to Do Not Sync OU: $_"
        Continue
    }
}

# --- Step 2: Trigger AD Connect Delta Sync once for all users moved ---
Try {
    Invoke-Command -ComputerName $ComputerName -Credential $Credential -ScriptBlock {
        Write-Host "Starting delta sync..." -ForegroundColor Yellow
        Start-ADSyncSyncCycle -PolicyType Delta -ErrorAction SilentlyContinue
        Write-Host "Delta sync completed successfully." -ForegroundColor Green
    } -ErrorAction Stop
    # Wait for sync to complete
}
Catch {
    Write-Warning "Unable to trigger sync. Ensure AD Connect is installed and this server has permission."
}

# --- PAUSE after sync and wait for user to continue ---
Read-Host -Prompt "Initial sync completed. Press Enter to continue with individual user merges..."

# --- Step 3: Process users one-by-one: assign ImmutableID, move back to their original OU ---
foreach ($User in $UserList) {
    $ADUserSamAccountName = $User.ADUserSamAccountName
    $AzureUserUPN = $User.AzureUserUPN

    if ([string]::IsNullOrWhiteSpace($ADUserSamAccountName) -or [string]::IsNullOrWhiteSpace($AzureUserUPN)) {
        Write-Warning "Skipping entry with missing ADUserSamAccountName or AzureUserUPN. ADUserSamAccountName='$ADUserSamAccountName', AzureUserUPN='$AzureUserUPN'"
        Continue
    }

    Write-Output "----- Processing $ADUserSamAccountName / $AzureUserUPN -----"

    # Calculate ImmutableID from On-Prem GUID
    Try {
        $ADUser = Get-ADUser -Identity $ADUserSamAccountName
        $ByteArray = $ADUser.ObjectGUID.ToByteArray()
        $ImmutableID = [System.Convert]::ToBase64String($ByteArray)
        Write-Output "Generated ImmutableID: $ImmutableID"
    }
    Catch {
        Write-Error "Failed to retrieve or convert ObjectGUID: $_"
        Continue
    }

    # Assign ImmutableID to Cloud User
    Try {
        Write-Output "Assigning ImmutableID to Azure user..."
        Set-AzureADUser -ObjectId $AzureUserUPN -ImmutableId $ImmutableID
    }
    Catch {
        Write-Error "Failed to assign ImmutableID: $_"
        Continue
    }

    # Retrieve original OU from stored hash table
    $OriginalOU = $UserOUs[$ADUserSamAccountName]
    if (-not $OriginalOU) {
        Write-Warning "Original OU not found for user $ADUserSamAccountName. Skipping move back."
        Continue
    }

    # Move AD User Back to Original OU
    Try {
        Move-ADObject -Identity $ADUser.DistinguishedName -TargetPath $OriginalOU
        Write-Output "Moved $ADUserSamAccountName back to original OU: $OriginalOU"
    }
    Catch {
        Write-Error "Failed to move $ADUserSamAccountName back to original OU: $_"
        Continue
    }

    Write-Output "✅ Merge process completed for $ADUserSamAccountName / $AzureUserUPN."
}

# --- Step 4: Final sync after all users processed ---
Write-Output "Starting final delta sync to complete all merges..."

Try {
    Invoke-Command -ComputerName $ComputerName -Credential $Credential -ScriptBlock {
        Write-Host "Starting delta sync..." -ForegroundColor Yellow
        Start-ADSyncSyncCycle -PolicyType Delta -ErrorAction SilentlyContinue
        Write-Host "Delta sync completed successfully." -ForegroundColor Green
    } -ErrorAction Stop
}
Catch {
    Write-Warning "Unable to trigger final sync. Ensure AD Connect is installed and this server has permission."
}

Write-Output "All user merges completed successfully."
# Disconnect from Azure AD
Disconnect-AzureAD
