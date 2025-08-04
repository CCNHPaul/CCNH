$pcName = Read-Host -Prompt "Enter the computer name to join to the domain"
Rename-Computer -NewName "$pcName" -DomainCredential (New-Object System.Management.Automation.PSCredential ("cc-nh\administrator", ("*****" | ConvertTo-SecureString -AsPlainText -Force)))

-Force -Restart
