<#
.SYNOPSIS
    This script performs various system setup tasks including running Windows Update, enabling dark mode, disabling the Xbox app from startup, removing third-party bloatware, cleaning the Start Menu, configuring firewall rules for SSH access, installing necessary applications like TeamViewer, Office 365, Adobe Acrobat Pro, and Tailscale, and installing the latest Windows security patches.

.DESCRIPTION
    - Silently installs and applies Windows updates, including security patches.
    - Ensures dark mode is enabled if not already active.
    - Disables the Xbox app from starting with Windows by removing its startup registry entries.
    - Removes third-party apps (bloatware) that come pre-installed on Windows.
    - Cleans the Start Menu by unpinning unnecessary apps and pinning only essential apps.
    - Silently installs TeamViewer, Office 365, Adobe Acrobat Pro, and Tailscale with no user interaction.
    - Prompts the user to add a new account with polished UI.
    - Configures the firewall to allow SSH traffic through port 22.

.NOTES
    Author: [Your Name]
    Date: [Date]
    Version: 1.4
#>

# Function to display a progress bar
function Show-Progress {
    param (
        [string]$activity,
        [int]$percentComplete,
        [string]$status
    )
    Write-Progress -Activity $activity -PercentComplete $percentComplete -Status $status
}

# Function to install Windows security patches silently
function Install-WindowsSecurityPatches {
    Write-Host "Installing the latest Windows security patches..."

    # Install the PSWindowsUpdate module if not already present
    if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Install-Module PSWindowsUpdate -Force -AllowClobber -ErrorAction SilentlyContinue
    }
    Import-Module PSWindowsUpdate

    # Get only security updates
    Show-Progress -Activity "Checking for security patches" -PercentComplete 0 -Status "Checking for Windows security patches..."
    Start-Sleep -Seconds 2

    # Install all available security updates
    Get-WindowsUpdate -Install -AcceptAll -AutoReboot -Verbose -Category Security | Out-Null

    Show-Progress -Activity "Installing security patches" -PercentComplete 50 -Status "Installing Windows security patches..."
    Start-Sleep -Seconds 2

    Show-Progress -Activity "Security patches installed" -PercentComplete 100 -Status "Windows security patches are up to date!"
    Write-Host "Windows security patches have been installed."
}

# Function to prompt for account creation
function Add-NewAccount {
    Write-Host "Prompting user to create a new account..."

    # Ask user if they want to create a new account
    $createAccount = $Host.UI.PromptForChoice("New Account", "Do you want to add a new account to the system?", @("&Yes", "&No"), 0)

    if ($createAccount -eq 0) {  # If user selects 'Yes'

        # Prompt for the new username
        $newUsername = Read-Host "Enter the new username"

        # Prompt for the new password (as secure string)
        $newPassword = Read-Host "Enter the new password" -AsSecureString

        # Prompt if the user should be an admin
        $isAdmin = $Host.UI.PromptForChoice("New Account Role", "Should this account have administrative privileges?", @("Yes", "No"), 0)

        # Create the new user account
        $plainPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPassword))
        $securePassword = ConvertTo-SecureString $plainPassword -AsPlainText -Force
        New-LocalUser -Name $newUsername -Password $securePassword -PasswordNeverExpires -FullName $newUsername -Description "Created via script"

        # Add user to admin group if selected
        if ($isAdmin -eq 0) {
            Add-LocalGroupMember -Group "Administrators" -Member $newUsername
            Write-Host "New admin account '$newUsername' created."
        } else {
            Write-Host "New standard account '$newUsername' created."
        }
    } else {
        Write-Host "No new account will be added."
    }
}

# Function to install TeamViewer silently
function Install-TeamViewer {
    Write-Host "Installing TeamViewer..."

    $teamViewerUrl = "https://download.teamviewer.com/download/TeamViewer_Setup.exe"
    $teamViewerInstaller = "$env:TEMP\TeamViewer_Setup.exe"

    # Download the TeamViewer installer
    Write-Host "Downloading TeamViewer installer..."
    Invoke-WebRequest -Uri $teamViewerUrl -OutFile $teamViewerInstaller

    # Install TeamViewer silently
    Show-Progress -Activity "Installing TeamViewer" -PercentComplete 50 -Status "Installing TeamViewer..."
    Start-Process -FilePath $teamViewerInstaller -ArgumentList "/S" -Wait

    # Confirm installation
    if (Get-Command "C:\Program Files (x86)\TeamViewer\TeamViewer.exe" -ErrorAction SilentlyContinue) {
        Write-Host "TeamViewer installation complete."
    } else {
        Write-Host "TeamViewer installation failed."
    }
}

# Function to install Office 365 silently
function Install-Office365 {
    Write-Host "Installing Office 365..."

    # Download and execute the Office deployment tool
    $officeSetupUrl = "https://aka.ms/office365ProPlusWindowsDesktop"
    $officeSetupFile = "$env:TEMP\OfficeSetup.exe"
    
    # Download Office setup
    Write-Host "Downloading Office 365 installer..."
    Invoke-WebRequest -Uri $officeSetupUrl -OutFile $officeSetupFile
    
    # Install Office 365 silently
    Show-Progress -Activity "Installing Office 365" -PercentComplete 50 -Status "Installing Office 365..."
    Start-Process -FilePath $officeSetupFile -ArgumentList "/configure" -Wait

    Write-Host "Office 365 installation complete."
}

# Function to install Adobe Acrobat Pro silently
function Install-AcrobatPro {
    Write-Host "Installing Adobe Acrobat Pro..."

    $acrobatUrl = "https://trials3.adobe.com/AdobeProducts/APRO/Acrobat_HelpX/Acrobat_DC_Web_WWMUI.zip"
    $acrobatInstallerZip = "$env:TEMP\AcrobatPro.zip"
    $acrobatInstallerDir = "$env:TEMP\AcrobatPro"

    # Download the Acrobat Pro installer
    Write-Host "Downloading Adobe Acrobat Pro installer..."
    Invoke-WebRequest -Uri $acrobatUrl -OutFile $acrobatInstallerZip

    # Extract the zip
    Expand-Archive -Path $acrobatInstallerZip -DestinationPath $acrobatInstallerDir -Force

    # Install Acrobat Pro silently
    $acrobatInstaller = "$acrobatInstallerDir\Setup.exe"
    Show-Progress -Activity "Installing Adobe Acrobat Pro" -PercentComplete 50 -Status "Installing Acrobat Pro..."
    Start-Process -FilePath $acrobatInstaller -ArgumentList "/sALL" -Wait

    Write-Host "Adobe Acrobat Pro installation complete."
}

# Function to install Tailscale silently
function Install-Tailscale {
    Write-Host "Installing Tailscale..."

    # Tailscale download link
    $tailscaleUrl = "https://pkgs.tailscale.com/stable/tailscale-setup.exe"
    $tailscaleInstaller = "$env:TEMP\Tailscale_Setup.exe"

    # Download the installer
    Write-Host "Downloading Tailscale installer..."
    Invoke-WebRequest -Uri $tailscaleUrl -OutFile $tailscaleInstaller

    # Install Tailscale silently
    Show-Progress -Activity "Installing Tailscale" -PercentComplete 50 -Status "Installing Tailscale..."
    Start-Process -FilePath $tailscaleInstaller -ArgumentList "/quiet" -Wait

    Write-Host "Tailscale installation complete."
}

# Function to run Windows Update silently with progress
function Run-WindowsUpdate {
    Write-Host "Running Windows Update..."

    Install-Module PSWindowsUpdate -Force -AllowClobber -ErrorAction SilentlyContinue
    Import-Module PSWindowsUpdate

    Show-Progress -Activity "Checking for Windows updates" -PercentComplete 0 -Status "Initializing update process..."
    Start-Sleep -Seconds 1

    # Install all available updates
    Get-WindowsUpdate -Install -AcceptAll -AutoReboot -Verbose | Out-Null

    Show-Progress -Activity "Installing updates" -PercentComplete 50 -Status "Installing updates in progress..."
    Start-Sleep -Seconds 1

    Show-Progress -Activity "Updates completed" -PercentComplete 100 -Status "System is up to date!"
    Write-Host "Windows updates have been installed successfully."
}

# Function to enable dark mode if it is not already enabled
function Enable-DarkMode {
    Write-Host "Ensuring dark mode is enabled..."

    $darkModeKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    $appsUseLightTheme = Get-ItemProperty -Path $darkModeKey -Name AppsUseLightTheme -ErrorAction Sil
