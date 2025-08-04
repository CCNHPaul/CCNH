<#
Editor: Visual Studio Code
Script Name: Intune_Join_Physical.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 07/25/2025
Description: Joins only physical devices to Azure AD + Intune, skipping VMware VMs
#>

# Detect VM and skip if model indicates virtual environment
$model = (Get-WmiObject -Class Win32_ComputerSystem).Model
if ($model -match "Virtual" -or $model -match "VMware") { exit }

# Trigger device registration (Hybrid Azure AD Join)
dsregcmd /join

# Trigger MDM enrollment (Intune)
$enrollScript = {
    $namespaceName = "root\cimv2\mdm\dmmap"
    $className = "MDM_EnterpriseModernAppManagement_AppManagement01"
    $methodName = "StartEnroll"
    $session = New-CimSession
    Invoke-CimMethod -Namespace $namespaceName -ClassName $className -MethodName $methodName -CimSession $session
}
Invoke-Command -ScriptBlock $enrollScript
