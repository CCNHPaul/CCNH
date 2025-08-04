<#
Editor: Visual Studio Code
Script Name: HelpdeskTicket-Form.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 04/24/2025
Description: Launches a Windows Forms-based user interface for submitting categorized helpdesk tickets via Outlook. Supports dynamic form inputs, field validation, and optional file attachments.

Change Log:

Updated: 05/14/2025 – v1.0.1
- Initial deployment of the Helpdesk Ticket form to all users.
- Implemented core fields including issue type, location, phone number, and description.
- Introduced dropdown menus for selecting specific issue types and locations.

Updated: 05/20/2025 – v1.0.2
- Added validation for all required fields: Issue Type, Specific Issue, Location, Phone Number (minimum 10 digits), and Description.
- Implemented custom warning dialog for incomplete submissions.
- Improved error handling for missing or invalid input.

Updated: 05/27/2025 – v1.1
- Introduced support for file attachments via the "Attach File(s)" button and OpenFileDialog.
- Configured email integration to include selected files in the submitted Outlook ticket.

Updated: 06/01/2025 – v1.2
- Enabled drag-and-drop functionality for file attachments directly into the description field.
- Enhanced form layout for improved readability and usability.

Updated: 06/05/2025 – v1.3
- Added darm mode support for the form and confirmation dialogs.
- Implemented dynamic image selection based on dark mode setting.
- Improved overall aesthetics and user experience with consistent styling.

Updated: 07/15/2025 – v1.4
- Added new issue categories for improved ticket classification.
- Enhanced form validation to include new categories.
- Updated dropdown menus to reflect new issue types and locations.
- Improved error handling for Outlook email submission failures.

Updated: 07/25/2025 – v1.5
- Added a check for Outlook process before sending email.
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$imagePathA = "C:\Button\Helpdesk Button\logoA.png"
$imagePathB = "C:\Button\Helpdesk Button\logoB.png"

function Show-ConfirmationBox {
    param (
        [string]$Message,
        [string]$Title = "Submission Confirmed",
        [bool]$UseDarkMode = $false
    )

    $popupForm = New-Object System.Windows.Forms.Form
    $popupForm.Text = $Title
    $popupForm.Width = 375
    $popupForm.Height = 175
    $popupForm.StartPosition = "CenterParent"
    $popupForm.FormBorderStyle = 'FixedDialog'
    $popupForm.MaximizeBox = $false
    $popupForm.MinimizeBox = $false
    $popupForm.ControlBox = $false
    $popupForm.TopMost = $true

    $label = New-Object System.Windows.Forms.Label
    $label.Text = $Message
    $label.AutoSize = $true
    $label.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Regular)
    $label.Location = New-Object System.Drawing.Point(30, 40)
    $popupForm.Controls.Add($label)

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Width = 80
    $okButton.Height = 30
    $okButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
    $okButton.Location = New-Object System.Drawing.Point(($popupForm.ClientSize.Width - 150), ($popupForm.ClientSize.Height - 50))
    $okButton.Anchor = "Bottom,Right"
    $okButton.Add_Click({ $popupForm.Close() })
    $popupForm.Controls.Add($okButton)

    if ($UseDarkMode) {
        Set-DarkMode -control $popupForm -enableDark:$true
    }

    $popupForm.ShowDialog()
}

function Show-CustomWarning {
    param (
        [string]$Message,
        [string]$Title = "Missing Information",
        [bool]$UseDarkMode = $false
    )

    $popupForm = New-Object System.Windows.Forms.Form
    $popupForm.Text = $Title
    $popupForm.Width = 750
    $popupForm.Height = 225
    $popupForm.StartPosition = "CenterParent"
    $popupForm.FormBorderStyle = 'FixedDialog'
    $popupForm.MaximizeBox = $false
    $popupForm.MinimizeBox = $false
    $popupForm.ControlBox = $false
    $popupForm.TopMost = $true

    $label = New-Object System.Windows.Forms.Label
    $label.Text = $Message
    $label.AutoSize = $true
    $label.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
    $label.Location = New-Object System.Drawing.Point(30, 30)
    $popupForm.Controls.Add($label)

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "Okay"
    $okButton.Width = 80
    $okButton.Height = 30
    $okButton.Location = New-Object System.Drawing.Point(($popupForm.ClientSize.Width - 150), ($popupForm.ClientSize.Height - 50))
    $okButton.Anchor = "Bottom,Right"
    $okButton.Add_Click({ $popupForm.Close() })
    $popupForm.Controls.Add($okButton)

    # 👇 Apply dark mode if requested
    if ($UseDarkMode) {
        Set-DarkMode -control $popupForm -enableDark:$true
    }

    $popupForm.ShowDialog()
}

$locationOptions = @(
    "HQ", "PDO", "WHC", "HCHM", "HCHW", "MTC", "STA", "STF", "STJ", "STJA", "STT", 
    "STV", "CG", "DOB", "DOC", "DOLA", "DOLE", "DOLI", "DOM", "DON", "DOR", "GATS",
    "LH", "MAH", "NG", "NHFB", "OPM", "STCH"
) | Sort-Object

function Set-DarkMode {
    param (
        [System.Windows.Forms.Control]$control,
        [bool]$enableDark
    )

    if ($enableDark) {
        $control.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
        $control.ForeColor = [System.Drawing.Color]::White
    }
    else {
        $control.BackColor = [System.Drawing.SystemColors]::Window
        $control.ForeColor = [System.Drawing.SystemColors]::ControlText
    }

    foreach ($child in $control.Controls) {
        Set-DarkMode -control $child -enableDark:$enableDark
    }
}

function Get-SystemDarkMode {
    try {
        $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
        $value = Get-ItemPropertyValue -Path $regPath -Name AppsUseLightTheme -ErrorAction Stop
        return ($value -eq 0)  # 0 = Dark mode enabled
    }
    catch {
        return $false  # Default to light mode if key missing
    }
}

$darkModeSetting = Get-SystemDarkMode

function Show-EmailForm {
    $formWidth = 500
    $baseHeight = 325
    $padding = 10

    $form = New-Object System.Windows.Forms.Form
    $iconPath = Join-Path -Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -ChildPath "helpdesk.ico"
    if (Test-Path $iconPath) {
        $form.Icon = New-Object System.Drawing.Icon($iconPath)
    }
    $form.Text = "CCNH Helpdesk Ticket"
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.Width = $formWidth
    $form.Height = $baseHeight
    $form.MinimumSize = New-Object System.Drawing.Size($formWidth, $baseHeight)

    $flowPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $flowPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
    $flowPanel.FlowDirection = [System.Windows.Forms.FlowDirection]::TopDown
    $flowPanel.WrapContents = $false
    $flowPanel.AutoScroll = $true
    $flowPanel.Padding = New-Object System.Windows.Forms.Padding($padding)
    $form.Controls.Add($flowPanel)

    # Choose the correct image based on dark mode setting
    $imagePath = if ($darkModeSetting) { $imagePathA } else { $imagePathB }

    if (Test-Path $imagePath) {
        $image = [System.Drawing.Image]::FromFile($imagePath)
        $pictureBox = New-Object System.Windows.Forms.PictureBox
        $pictureBox.Image = $image
        $pictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
        $pictureBox.Width = $formWidth - 4 * $padding
        $pictureBox.Height = [math]::Min(150, [math]::Round($image.Height * ($pictureBox.Width / $image.Width)))
        $flowPanel.Controls.Add($pictureBox)
        $baseHeight += $pictureBox.Height
    }


    $labelSubject = New-Object System.Windows.Forms.Label
    $labelSubject.Text = "Issue Type:"
    $labelSubject.AutoSize = $true
    $flowPanel.Controls.Add($labelSubject)

    $comboBoxSubject = New-Object System.Windows.Forms.ComboBox
    $comboBoxSubject.Width = $formWidth - 4 * $padding
    $comboBoxSubject.DropDownStyle = 'DropDownList'
    $comboBoxSubject.Items.Add("-- Select Issue --")
    $comboBoxSubject.Items.AddRange(@(
            "Account Access",
            "Email Issue",
            "Hardware Issue",
            "Hardware Request",
            "HUB Issues",
            "Login/Account Access",
            "Network Connectivity",
            "Software Issue"
        ))
    $comboBoxSubject.SelectedIndex = 0
    $flowPanel.Controls.Add($comboBoxSubject)

    # Subcategory box
    $comboBoxSubCategory = New-Object System.Windows.Forms.ComboBox
    $comboBoxSubCategory.Width = $formWidth - 4 * $padding
    $comboBoxSubCategory.IntegralHeight = $false
    $comboBoxSubCategory.DropDownHeight = 300  
    $comboBoxSubCategory.DropDownStyle = 'DropDownList'
    $comboBoxSubCategory.Items.Add("-- Select Specific --")
    $comboBoxSubCategory.SelectedIndex = 0
    $flowPanel.Controls.Add($comboBoxSubCategory)

    $labelLocation = New-Object System.Windows.Forms.Label
    $labelLocation.Text = "Your Location:"
    $labelLocation.AutoSize = $true
    $flowPanel.Controls.Add($labelLocation)
    
    $comboBoxLocation = New-Object System.Windows.Forms.ComboBox
    $comboBoxLocation.Width = $formWidth - 4 * $padding
    $comboBoxLocation.DropDownStyle = 'DropDownList'
    $comboBoxLocation.IntegralHeight = $false
    $comboBoxLocation.DropDownHeight = 400
    $comboBoxLocation.Items.Add("-- Select Location --")
    $comboBoxLocation.Items.AddRange($locationOptions)
    $comboBoxLocation.SelectedIndex = 0
    $flowPanel.Controls.Add($comboBoxLocation)    

    # Create label
    # --- Phone Label + TextBox Container ---
    $panelPhone = New-Object System.Windows.Forms.FlowLayoutPanel
    $panelPhone.FlowDirection = 'TopDown'
    $panelPhone.AutoSize = $true

    $labelPhone = New-Object System.Windows.Forms.Label
    $labelPhone.Text = "Phone Number:"
    $labelPhone.AutoSize = $true
    $panelPhone.Controls.Add($labelPhone)
    $panelPhone.Margin = '0,0,0,0'
    $labelPhone.Height = 20
    $panelPhone.Padding = '0,0,0,0'
    $panelPhone.Anchor = 'Top'
    
    $textBoxPhone = New-Object System.Windows.Forms.TextBox
    $textBoxPhone.Width = 100
    $panelPhone.Controls.Add($textBoxPhone)
    $textBoxPhone.Add_KeyPress({
            if (-not [char]::IsControl($_.KeyChar)) {
                if (-not [char]::IsDigit($_.KeyChar) -or $textBoxPhone.Text.Length -ge 11) {
                    $_.Handled = $true
                }
            }
        })


    # --- Extension Label + TextBox Container ---
    $panelExtension = New-Object System.Windows.Forms.FlowLayoutPanel
    $panelExtension.FlowDirection = 'TopDown'
    $panelExtension.AutoSize = $true
    $panelExtension.Width = 100
    $panelExtension.Margin = '0,0,0,0'
    $panelExtension.Padding = '0,0,0,0'
    $panelExtension.Anchor = 'Top'

    $labelExtension = New-Object System.Windows.Forms.Label
    $labelExtension.Text = "Extension:"
    $labelExtension.AutoSize = $true
    $labelExtension.Height = 20
    $panelExtension.Controls.Add($labelExtension)

    $textBoxExtension = New-Object System.Windows.Forms.TextBox
    $textBoxExtension.Width = 75
    $panelExtension.Controls.Add($textBoxExtension)
    # Input restriction (only digits)
    $textBoxExtension.Add_KeyPress({
            if (-not [char]::IsControl($_.KeyChar)) {
                if (-not [char]::IsDigit($_.KeyChar) -or $textBoxExtension.Text.Length -ge 6) {
                    $_.Handled = $true
                }
            }
        })


    # --- Parent panel to hold both side-by-side ---
    $panelPhoneGroup = New-Object System.Windows.Forms.FlowLayoutPanel
    $panelPhoneGroup.FlowDirection = 'LeftToRight'
    $panelPhoneGroup.AutoSize = $true
    $panelPhoneGroup.Controls.Add($panelPhone)
    $panelPhoneGroup.Controls.Add($panelExtension)
    $panelPhoneGroup.Margin = '0,0,0,0'
    $panelPhoneGroup.Padding = '0,0,0,0'


    # Add to the main form flow panel
    $flowPanel.Controls.Add($panelPhoneGroup)

    $categoryOptions = @{
        "Account Access"               = @(
            "Email Access",
            "File Access",
            "Folder Access",
            "Network Drive Access",
            "Other - Describe Below",
            "Printer Access"
        )
        "Email Issue"          = @(
            "Cannot Receive",
            "Cannot Send",
            "Login Issue",
            "Outlook Not Syncing",
            "Send As Permissions",
            "Shared Mailbox Access",
            "Spam"
        )
        "Hardware Issue"       = @(
            "Computer",
            "Docking Station",
            "Keyboard/Mouse",
            "Monitor",
            "Other - Describe Below",
            "Phone",
            "Printer"
        )
        "Hardware Request"     = @(
            "Desktop",
            "Docking Station",
            "Keyboard/Mouse",
            "Laptop",
            "Monitor",
            "Phone"
        )
        "HUB Issues"           = @(
            "App/Desktop Not Loading",
            "Black Screen After Login",
            "Disconnected from Session",
            "Login Issues",
            "Other - Describe Below"
        )
        "Login/Account Access" = @(
            "Account Locked",
            "Computer Login",
            "Email Login",
            "Multi-Factor Authentication",
            "No Access",
            "Other - Describe Below",
            "Password Reset",
            "Printer Access"
        )
        "Network Connectivity" = @(
            "Cannot Reach Server",
            "Ethernet",
            "Internet Down",
            "Network Drive Access",
            "Slow Connection",
            "Wi-Fi"
        )
        "Software Issue"       = @(
            "Abila",
            "Edge/Chrome",
            "Excel",
            "Microix",
            "Other - Describe Below",
            "Outlook",
            "PCC",
            "PDF Reader",
            "Word",
            "Zoom"
        )
    }

    $comboBoxSubject.Add_SelectedIndexChanged({
            $comboBoxSubCategory.Items.Clear()
            $comboBoxSubCategory.Items.Add("-- Select Specific --")
            $selected = $comboBoxSubject.SelectedItem
            if ($categoryOptions.ContainsKey($selected)) {
                $comboBoxSubCategory.Items.AddRange($categoryOptions[$selected])
            }
            $comboBoxSubCategory.SelectedIndex = 0
        })

    $labelDescription = New-Object System.Windows.Forms.Label
    $labelDescription.Text = "Description:"
    $labelDescription.AutoSize = $true
    $flowPanel.Controls.Add($labelDescription)

    $textBoxDescription = New-Object System.Windows.Forms.TextBox
    $textBoxDescription.Multiline = $true
    $textBoxDescription.ScrollBars = "Vertical"
    $textBoxDescription.Width = $formWidth - 4 * $padding
    $textBoxDescription.Height = 175
    $textBoxDescription.AllowDrop = $true
    $textBoxDescription.Font = New-Object System.Drawing.Font("Segoe UI", 10)

    $flowPanel.Controls.Add($textBoxDescription)

    # Placeholder logic
    $placeholderText = "Describe your issue below (include any error messages, steps to reproduce, etc.). Attach files by dragging them to this window or pressing Attach Files."
    $textBoxDescription.Text = $placeholderText
    $textBoxDescription.ForeColor = [System.Drawing.Color]::Gray

    $textBoxDescription.Add_Enter({
            if ($textBoxDescription.Text -eq $placeholderText) {
                $textBoxDescription.Text = ""
                $textBoxDescription.ForeColor = if ($darkModeSetting) {
                    [System.Drawing.Color]::White
                }
                else {
                    [System.Drawing.Color]::Black
                }
            }
        })

    $textBoxDescription.Add_Leave({
            if ([string]::IsNullOrWhiteSpace($textBoxDescription.Text)) {
                $textBoxDescription.Text = $placeholderText
                $textBoxDescription.ForeColor = [System.Drawing.Color]::Gray
            }
        })
    
    # -- File Attachment Support --
    $buttonAttachFiles = New-Object System.Windows.Forms.Button
    $buttonAttachFiles.Text = "Attach File(s)"
    $buttonAttachFiles.Width = 120
    $buttonAttachFiles.Height = 30

    $labelAttachedFiles = New-Object System.Windows.Forms.Label
    $labelAttachedFiles.Text = "No files attached."
    $labelAttachedFiles.AutoSize = $true

    # Store attached files
    $attachedFiles = New-Object System.Collections.Generic.List[string]

    $buttonAttachFiles.Add_Click({
            $fileDialog = New-Object System.Windows.Forms.OpenFileDialog
            $fileDialog.Title = "Select File(s) to Attach"
            $fileDialog.Filter = "All files (*.*)|*.*"
            $fileDialog.Multiselect = $true
            if ($fileDialog.ShowDialog() -eq "OK") {
                foreach ($file in $fileDialog.FileNames) {
                    $attachedFiles.Add($file)
                }
                if ($attachedFiles.Count -gt 0) {
                    $labelAttachedFiles.Text = "$($attachedFiles.Count) file(s) attached."
                }
                else {
                    $labelAttachedFiles.Text = "No files attached."
                }
            }
        })


    $flowPanel.Controls.Add($buttonAttachFiles)
    $flowPanel.Controls.Add($labelAttachedFiles)
    # -- End File Attachment Support --

    # Allow file drop
    $textBoxDescription.AllowDrop = $true

    # Handle DragEnter (shows copy cursor)
    $textBoxDescription.Add_DragEnter({
            if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
                $_.Effect = [Windows.Forms.DragDropEffects]::Copy
            }
            else {
                $_.Effect = [Windows.Forms.DragDropEffects]::None
            }
        })

    # Handle DragDrop
    $textBoxDescription.Add_DragDrop({
            $files = $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)
            if ($files) {
                # Ensure attachedFiles is still accessible!
                foreach ($file in $files) {
                    if (-not $attachedFiles.Contains($file)) {
                        $attachedFiles.Add($file)
                    }
                }
                # Update label for attached files
                if ($attachedFiles.Count -gt 0) {
                    $labelAttachedFiles.Text = "$($attachedFiles.Count) file(s) attached."
                }
                else {
                    $labelAttachedFiles.Text = "No files attached."
                }
            }
        })

    $baseHeight += 100

    $buttonSubmit = New-Object System.Windows.Forms.Button
    $buttonSubmit.Text = "Submit"
    $buttonSubmit.Width = 100
    $buttonSubmit.Height = 30
    $buttonSubmit.Anchor = [System.Windows.Forms.AnchorStyles]::Top
    $flowPanel.Controls.Add($buttonSubmit)

    $buttonSubmit.Add_Click({
            if ($comboBoxSubject.SelectedItem -eq "-- Select Issue --" -or
                $comboBoxSubCategory.SelectedItem -eq "-- Select Specific --" -or
                $comboBoxLocation.SelectedItem -eq "-- Select Location --" -or
                ([string]::IsNullOrWhiteSpace($textBoxPhone.Text) -or $textBoxPhone.Text.Length -lt 10) -or
                [string]::IsNullOrWhiteSpace($textBoxDescription.Text) -or $textBoxDescription.Text -eq $placeholderText) {
    
                Show-CustomWarning -Message "Please complete all required fields: Issue, Specific Issue, Location, Phone Number (10+ digits), and Description." -UseDarkMode:$darkModeSetting
            }

    
            else {
                $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
                $form.Close()
            }
        })

    Set-DarkMode -control $form -enableDark:$darkModeSetting


    $form.Height = $baseHeight + 90

    $result = $form.ShowDialog()
    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        return @{
            Subject     = "$($comboBoxSubject.SelectedItem) - $($comboBoxSubCategory.SelectedItem)";
            Location    = "$($comboBoxLocation.SelectedItem)";
            Description = $textBoxDescription.Text;
            Phone       = "$($textBoxPhone.Text) x$($textBoxExtension.Text)";
            Attachments = $attachedFiles.ToArray()
            DarkMode    = $darkModeSetting;
        }
        
    }
    else {
        return $null
    }        
}

$userInput = Show-EmailForm

if ($userInput -and $userInput.Subject -and $userInput.Description) {
    try {
        # Check if Outlook process is running; if not, start it and wait a bit
        if (-not (Get-Process -Name OUTLOOK -ErrorAction SilentlyContinue)) {
            Start-Process outlook
            Start-Sleep -Seconds 5
        }

        $Outlook = New-Object -ComObject Outlook.Application
        $Mail = $Outlook.CreateItem(0)

        $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
        $osVersion = $osInfo.Caption
        $osBuild = $osInfo.BuildNumber
        $uptimeSpan = (Get-Date) - $osInfo.LastBootUpTime
        $uptimeDays = [math]::Round($uptimeSpan.TotalDays, 2)
        $serviceTag = (Get-CimInstance -Class Win32_BIOS).SerialNumber
        $model = (Get-CimInstance -Class Win32_ComputerSystem).Model

        try {
            $fullDisplayName = (Get-CimInstance -ClassName Win32_UserAccount -Filter "Name='$env:USERNAME'").FullName
            if ([string]::IsNullOrWhiteSpace($fullDisplayName)) {
                $fullDisplayName = $env:USERNAME
            }
        }
        catch {
            $fullDisplayName = $env:USERNAME
        }
        
        $diskInfo = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" |
            Select-Object DeviceID, @{Name = "FreeGB"; Expression = { [math]::Round($_.FreeSpace / 1GB, 2) } }, @{Name = "TotalGB"; Expression = { [math]::Round($_.Size / 1GB, 2) } }

        $ipAddress = (Get-NetIPAddress -AddressFamily IPv4 -PrefixOrigin DHCP | Where-Object { $_.IPAddress -notlike '169.*' }).IPAddress -join ', '

        $systemInfo = @"
--- System Information ---
Computer Name: $env:COMPUTERNAME
User Name: $env:USERNAME
Operating System: $osVersion (Build $osBuild)
Model: $model
Service Tag: $serviceTag
IP Address: $ipAddress
System Uptime: $uptimeDays days
Disk Space: $(($diskInfo | ForEach-Object {"$($_.DeviceID): $($_.FreeGB)GB free of $($_.TotalGB)GB"}) -join '; ')
"@

        $Mail.Subject = "$($userInput.Location) - $fullDisplayName - $($userInput.Subject)"
        $Mail.Body = "Phone Number: $($userInput.Phone)`r`n`r`n$($userInput.Description)`r`n`r`n$systemInfo"
        $Mail.Recipients.Add("tickets@nh-cc.org")

        # -- File Attachment Support --
        if ($userInput.Attachments -and $userInput.Attachments.Count -gt 0) {
            foreach ($file in $userInput.Attachments) {
                if (Test-Path $file) { $Mail.Attachments.Add($file) }
            }
        }
        # -- End File Attachment Support --

        $Mail.Send()
        Show-ConfirmationBox -Message "Your ticket has been submitted successfully." -UseDarkMode:$userInput.DarkMode
    }
    catch {
        Show-ConfirmationBox -Message "Your ticket failed to send, Call 603-935-7776." -UseDarkMode:$userInput.DarkMode
    }
}

