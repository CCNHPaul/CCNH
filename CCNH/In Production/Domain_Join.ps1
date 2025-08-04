$domain = "cc-nh.local"
$username = "$domain\administrator"
$password = "ptfb2009!!" | ConvertTo-SecureString -asPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username, $password)

Add-Computer -DomainName $domain -Credential $credential
