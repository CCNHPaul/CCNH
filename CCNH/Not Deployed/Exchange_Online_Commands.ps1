# Install Exchange Online Management Module
Install-Module -Name ExchangeOnlineManagement
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName paul.hanlon@nh-cc.org
Restore-InactiveMailbox -Identity "user@domain.com" -TargetMailbox "user@domain.com"

# Find mailboxes that have Litigation Hold enabled
Get-Mailbox -Filter {LitigationHoldEnabled -eq $true} | Select-Object DisplayName,UserPrincipalName,LitigationHoldEnabled


# Get all soft-deleted mailboxes
$softDeletedMailboxes = Get-Mailbox -SoftDeletedMailbox -ResultSize Unlimited
$softDeletedMailboxes | Format-Table DisplayName,PrimarySmtpAddress,WhenSoftDeleted
Undo-SoftDeletedMailbox -SoftDeletedObject "whc.adminassist3@nh-cc.org"

# Output soft-deleted mailboxes
if ($softDeletedMailboxes.Count -gt 0) {
    $softDeletedMailboxes | Select-Object DisplayName,PrimarySmtpAddress,WhenSoftDeleted
} else {
    Write-Host "No soft-deleted mailboxes found."
}

# Get the list of completed restore requests
$completedRequests = Get-MailboxRestoreRequest | Where-Object { $_.Status -eq "Completed" }

# Remove the completed restore requests
$completedRequests | ForEach-Object { Remove-MailboxRestoreRequest -Identity $_.Identity -Confirm:$false }

# Get the list of failed restore requests
$failedRequests = Get-MailboxRestoreRequest | Where-Object { $_.Status -eq "Failed" }

# Remove the failed restore requests
$failedRequests | ForEach-Object { Remove-MailboxRestoreRequest -Identity $_.Identity -Confirm:$false }

# check Dynamic Distribution List Members
Get-Recipient -RecipientPreviewFilter (Get-DynamicDistributionGroup "GrHQ").RecipientFilter | Select-Object Name, PrimarySMTPAddress

Get-Recipient -Identity "dhildenbrand" | Format-List

# Get Distribution List Members
Get-DistributionGroupMember -Identity "GrCCNH" | Select-Object Name, PrimarySMTPAddress

# Mailbox Commands
Get-Mailbox email | Format-List DelayHoldApplied,DelayReleaseHoldApplied
Get-MailboxFolderStatistics nmellitt@nhfoodbank.org -FolderScope RecoverableItems | Format-List Name,FolderAndSubfolderSize,ItemsInFolderAndSubfolders
Set-Mailbox email -RemoveDelayHoldApplied
Set-Mailbox email -RemoveDelayReleaseHoldApplied
Start-ManagedFolderAssistant -Identity nmellitt@nhfoodbank.org -HoldCleanup

while($true)
{
    Start-ManagedFolderAssistant -Identity nmellitt@nhfoodbank.org -HoldCleanup
    write-host "waiting"; start-sleep -seconds 5;
}

Get-DistributionGroup -Filter {Name -like "GR*"} | Select-Object Name, PrimarySmtpAddress, ManagedBy | Export-Csv -Path "C:\Temp\GR_DistributionGroups.csv" -NoTypeInformation

Get-DistributionGroup | Where-Object { $_.Name -imatch "^gr" } | Select-Object Name, PrimarySmtpAddress, ManagedBy | Export-Csv -Path "C:\Temp\GR_DistributionGroups.csv" -NoTypeInformation

$Groups = Get-DistributionGroup | Where-Object { $_.Name -imatch "^gr" }

$Results = foreach ($Group in $Groups) {
    $Members = Get-DistributionGroupMember -Identity $Group.Name | Select-Object -ExpandProperty Name
    [PSCustomObject]@{
        GroupName           = $Group.Name
        PrimarySmtpAddress  = $Group.PrimarySmtpAddress
        ManagedBy           = ($Group.ManagedBy -join "; ")
        Members             = ($Members -join "; ")
    }
}

$Results | Export-Csv -Path "C:\Temp\GR_DistributionGroups_WithMembers.csv" -NoTypeInformation


Get-DistributionGroupMember -Identity "HQ@nh-cc.org" | Select-Object Name, PrimarySmtpAddress | Export-Csv -Path "C:\Temp\HQ_DistributionGroupMembers.csv" -NoTypeInformation

Add-MailboxPermission -Identity "spiritualenrichment@nh-cc.org" -User "phanlon@nh-cc.org" -AccessRights FullAccess

Get-MailboxPermission -Identity "spiritualenrichment@nh-cc.org" | Where-Object { $_.User -like "cdan*" }
Get-RecipientPermission -Identity "spiritualenrichment@nh-cc.org"
Send-MailMessage -From "spiritualenrichment@nh-cc.org" -To "phanlon@nh-cc.org" -Subject "Test Email" -Body "This is a test" -SmtpServer "smtp.office365.com" -Credential (Get-Credential) -Port 587 -UseSsl

Get-DistributionGroupMember -Identity "GrAll" | Where-Object { $_.PrimarySmtpAddress -eq "hr@presmarynh.org" }

Get-DynamicDistributionGroup -Identity "grccnh" | Format-List RecipientFilter,IncludedRecipients

Get-Recipient -RecipientPreviewFilter (Get-DynamicDistributionGroup -Identity "GrCCNH").RecipientFilter

(Get-Recipient -RecipientPreviewFilter ((Get-DynamicDistributionGroup -Identity "grccnh").RecipientFilter)).PrimarySmtpAddress


Get-DynamicDistributionGroup -Identity "GrCCNH" | Format-List RecipientFilter
Set-DynamicDistributionGroup -Identity "GrCCNH" -RecipientFilter "((((RecipientType -eq 'UserMailbox') -or (RecipientType -eq 'MailContact'))) -and (-not(Name -like 'SystemMailbox{*')) -and (-not(Name -like 'CAS_{*')) -and (-not(RecipientTypeDetailsValue -eq 'MailboxPlan')) -and (-not(RecipientTypeDetailsValue -eq 'DiscoveryMailbox')) -and (-not(RecipientTypeDetailsValue -eq 'PublicFolderMailbox')) -and (-not(RecipientTypeDetailsValue -eq 'ArbitrationMailbox')) -and (-not(RecipientTypeDetailsValue -eq 'AuditLogMailbox')) -and (-not(RecipientTypeDetailsValue -eq 'AuxAuditLogMailbox')) -and (-not(RecipientTypeDetailsValue -eq 'SupervisoryReviewPolicyMailbox')) -and (-not(RecipientTypeDetailsValue -eq 'GuestMailUser')) -and (-not(PrimarySmtpAddress -eq 'ccnh.it@nh-cc.org')) -and (-not(PrimarySmtpAddress -eq 'ithelpdesk@nh-cc.org')) -and (-not(PrimarySmtpAddress -eq 'MtCarmelRehab-Emergency@nh-cc.org')))"

# Connect to MSOnline
Connect-MsolService

# Get licensed users and their license details
$licensedUsers = Get-MsolUser -All | Where-Object { $_.IsLicensed -eq $true } | ForEach-Object {
    [PSCustomObject]@{
        UserPrincipalName = $_.UserPrincipalName
        LicenseTypes      = ($_.Licenses.AccountSkuId -join ", ")
    }
}

# Define the output file path
$outputCsv = "C:\Temp\LicensedUsersWithLicenses.csv"

# Export to CSV
$licensedUsers | Export-Csv -Path $outputCsv -NoTypeInformation

Write-Host "Licensed users and their license types have been exported to $outputCsv"


Connect-MgGraph -Scopes "User.Read.All", "Directory.Read.All"

Get-MgSubscribedSku | Where-Object {$_.SkuPartNumber -like "*Business*"} | Select-Object SkuId, SkuPartNumber


Get-Recipient -RecipientPreviewFilter (Get-DynamicDistributionGroup "GrHQ").RecipientFilter | Select-Object DisplayName,PrimarySmtpAddress
