<#
Editor: Visual Studio Code
Script Name: Prayer.ps1
Author: Paul Hanlon for Catholic Charities NH
Created: 07/25/2025
Description: Prayer GUI with image, one comment box, submit button, email send, default mode only.

Version History:

Updated 07/25/2025 – v1.0
- Initial version created with basic GUI elements and functionality.

Updated: 07/28/2025 – v1.1  
- Added welcome popup and confirmation dialog.
- Integrated image display in the GUI.
- Enhanced layout and styling for better user experience.
- Added input validation for the comment box.
- Conducted user testing and incorporated feedback.
- Finalized version for deployment.

Updated: 07/28/2025 – v1.2
- Unified popup themes for consistent fonts, sizes, button styles, and window properties.

#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$imagePath = "C:\Button\Prayer\pray_image.png"  # Use the default (non-dark) image

# Common theme settings
$CommonFont = New-Object System.Drawing.Font("Segoe UI", 11)
$ButtonFont = New-Object System.Drawing.Font("Segoe UI", 10)
$FormBorderStyle = 'FixedDialog'
$FormStartPosition = 'CenterScreen'
$ButtonWidth = 80
$ButtonHeight = 30
$ButtonMargin = 20

function Show-WelcomePopup {
    $message = @"
Welcome to the Catholic Charities NH online prayer request. We invite you to share your prayer requests - whether for yourself, a loved one, or a situation on your heart. Our prayer team is honored to lift your intentions in prayer, whenever the need arises. All requests are treated confidentially unless you choose to share publicly.
"@

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Welcome"
    $form.Width = 500
    $form.Height = 245
    $form.StartPosition = $FormStartPosition
    $form.FormBorderStyle = $FormBorderStyle
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.ControlBox = $false
    $form.TopMost = $true
    $form.Font = $CommonFont

    $label = New-Object System.Windows.Forms.Label
    $label.Text = $message
    $label.AutoSize = $false
    $label.Width = $form.ClientSize.Width - 40
    $label.Height = $form.ClientSize.Height - 80
    $label.Location = New-Object System.Drawing.Point(20, 20)
    $label.TextAlign = 'TopLeft'
    $form.Controls.Add($label)

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Width = $ButtonWidth
    $okButton.Height = $ButtonHeight
    $okButton.Font = $ButtonFont
    $okButton.Location = New-Object System.Drawing.Point(($form.ClientSize.Width - $ButtonWidth - $ButtonMargin), ($form.ClientSize.Height - $ButtonHeight - $ButtonMargin))
    $okButton.Anchor = "Bottom,Right"
    $okButton.Add_Click({ $form.Close() })
    $form.Controls.Add($okButton)

    $form.ShowDialog()
}

function Show-ConfirmationBox {
    param (
        [string]$Message,
        [string]$Title = "Submission Confirmed"
    )
    $popupForm = New-Object System.Windows.Forms.Form
    $popupForm.Text = $Title
    $popupForm.Width = 475
    $popupForm.Height = 175
    $popupForm.StartPosition = $FormStartPosition
    $popupForm.FormBorderStyle = $FormBorderStyle
    $popupForm.MaximizeBox = $false
    $popupForm.MinimizeBox = $false
    $popupForm.ControlBox = $false
    $popupForm.TopMost = $true
    $popupForm.Font = $CommonFont

    $label = New-Object System.Windows.Forms.Label
    $label.Text = $Message
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(30, 40)
    $popupForm.Controls.Add($label)

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Width = $ButtonWidth
    $okButton.Height = $ButtonHeight
    $okButton.Font = $ButtonFont
    $okButton.Location = New-Object System.Drawing.Point(($popupForm.ClientSize.Width - $ButtonWidth - $ButtonMargin), ($popupForm.ClientSize.Height - $ButtonHeight - $ButtonMargin))
    $okButton.Anchor = "Bottom,Right"
    $okButton.Add_Click({ $popupForm.Close() })
    $popupForm.Controls.Add($okButton)

    $popupForm.ShowDialog()
}

function Show-EmailForm {
    Show-WelcomePopup
    $formWidth = 400
    $baseHeight = 470
    $padding = 10

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Spiritual Enrichment"
    $form.StartPosition = $FormStartPosition
    $form.FormBorderStyle = $FormBorderStyle
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.Width = $formWidth
    $form.Height = $baseHeight
    $form.Font = $CommonFont

    $flowPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $flowPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
    $flowPanel.FlowDirection = [System.Windows.Forms.FlowDirection]::TopDown
    $flowPanel.WrapContents = $false
    $flowPanel.AutoScroll = $true
    $flowPanel.Padding = New-Object System.Windows.Forms.Padding($padding)
    $form.Controls.Add($flowPanel)

    # Load image if available
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

    $labelDescription = New-Object System.Windows.Forms.Label
    $labelDescription.Text = "Enter Your Prayer Request Below:"
    $labelDescription.AutoSize = $true
    $flowPanel.Controls.Add($labelDescription)

    $textBoxDescription = New-Object System.Windows.Forms.TextBox
    $textBoxDescription.Multiline = $true
    $textBoxDescription.ScrollBars = "Vertical"
    $textBoxDescription.Width = $formWidth - 4 * $padding
    $textBoxDescription.Height = 175
    $textBoxDescription.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $flowPanel.Controls.Add($textBoxDescription)

    # Placeholder text setup
    $placeholderText = "Enter your prayer request here..."
    $textBoxDescription.Text = $placeholderText
    $textBoxDescription.ForeColor = [System.Drawing.Color]::Gray

    $textBoxDescription.Add_Enter({
            if ($textBoxDescription.Text -eq $placeholderText) {
                $textBoxDescription.Text = ""
                $textBoxDescription.ForeColor = [System.Drawing.Color]::Black
            }
        })

    $textBoxDescription.Add_Leave({
            if ([string]::IsNullOrWhiteSpace($textBoxDescription.Text)) {
                $textBoxDescription.Text = $placeholderText
                $textBoxDescription.ForeColor = [System.Drawing.Color]::Gray
            }
        })

    $buttonSubmit = New-Object System.Windows.Forms.Button
    $buttonSubmit.Text = "Submit"
    $buttonSubmit.Width = 100
    $buttonSubmit.Height = 30
    $buttonSubmit.Font = $ButtonFont
    $buttonSubmit.Anchor = [System.Windows.Forms.AnchorStyles]::Top
    $flowPanel.Controls.Add($buttonSubmit)

    $buttonSubmit.Add_Click({
            if ([string]::IsNullOrWhiteSpace($textBoxDescription.Text) -or $textBoxDescription.Text -eq $placeholderText) {
                [System.Windows.Forms.MessageBox]::Show("Please enter a description before submitting.", "Input Required", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
                return
            }
            $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
            $form.Close()
        })

    $result = $form.ShowDialog()
    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        return @{
            Description = $textBoxDescription.Text
        }
    }
    else {
        return $null
    }
}

$userInput = Show-EmailForm

if ($userInput -and $userInput.Description) {
    try {
        # Check if Outlook process is running
        if (-not (Get-Process -Name OUTLOOK -ErrorAction SilentlyContinue)) {
            Start-Process outlook
            Start-Sleep -Seconds 5
        }

        $Outlook = New-Object -ComObject Outlook.Application
        $Mail = $Outlook.CreateItem(0)

        $Mail.Subject = "Prayer Request"
        $Mail.Body = $userInput.Description
        $Mail.Recipients.Add("paul.hanlon@nh-cc.org")

        $Mail.Send()
        Show-ConfirmationBox -Message "Your Prayer Request has been submitted successfully."
    }
    catch {
        Show-ConfirmationBox -Message "Your Prayer Request failed to send. Please make sure Outlook is open."
    }
}
