<#
.SYNOPSIS
    New Windows Install Script
    Installs and configures SSH, creates SSH login credentials, updates Windows, blocks China via hosts, and installs applications.

.NOTES
    Author: James Gooch
    Version: 2.2
#>

# Variables
$logFile = "$env:TEMP\NewWindowsInstall.log"
$appConfig = ".\apps.json"
$sshCredentialsFile = "$env:USERPROFILE\Desktop\ssh_credentials.txt"

# Logging Function
function Write-Log {
    param ([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    Add-Content -Path $logFile -Value $logEntry
    Write-Host $Message
}

# Prompt for Yes/No Confirmation
function Confirm-Execution {
    Add-Type -AssemblyName PresentationFramework
    $result = [System.Windows.MessageBox]::Show("This script will configure your system, install SSH, update Windows, and install applications. Proceed?", "Confirmation", "YesNo", "Question")
    if ($result -ne "Yes") {
        Write-Log "Script execution cancelled by user." -Level "WARNING"
        Exit
    }
}

# Ensure apps.json Exists
function Initialize-AppConfig {
    if (-not (Test-Path $appConfig)) {
        Write-Log "Creating default apps.json..."
        $defaultApps = @(
            @{ Name = "TeamViewer"; URL = "https://download.teamviewer.com/download/TeamViewer_Setup.exe" },
            @{ Name = "Tailscale"; URL = "https://pkgs.tailscale.com/stable/tailscale-setup.exe" }
        )
        $defaultApps | ConvertTo-Json | Out-File -FilePath $appConfig -Encoding UTF8
        Write-Host "Default 'apps.json' created. Please edit it to customize application installations."
        Exit
    }
}

# Install OpenSSH Server
function Install-SSHServer {
    Write-Log "Installing OpenSSH Server..."
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    Start-Service sshd
    Set-Service -Name sshd -StartupType 'Automatic'
    Write-Log "OpenSSH Server installed and configured."
}

# Create SSH Login Credentials
function Generate-SSHCredentials {
    Write-Log "Generating SSH login credentials..."
    $username = "sshuser"
    $password = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 12 | ForEach-Object {[char]$_})

    # Create a new user
    New-LocalUser -Name $username -Password (ConvertTo-SecureString -AsPlainText $password -Force) -Description "SSH User"

    # Add to Administrators group
    Add-LocalGroupMember -Group "Administrators" -Member $username

    # Save credentials to desktop
    "SSH Username: $username`nSSH Password: $password`nHost: $env:COMPUTERNAME" | Out-File -FilePath $sshCredentialsFile -Encoding UTF8
    Write-Log "SSH credentials saved to $sshCredentialsFile"
}

# Ensure Windows Firewall is Enabled and Allow SSH
function Configure-Firewall {
    Write-Log "Configuring Windows Firewall for SSH..."
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
    New-NetFirewallRule -DisplayName "Allow SSH" -Direction Inbound -LocalPort 22 `
        -Protocol TCP -Action Allow -ErrorAction SilentlyContinue
    Write-Log "Windows Firewall enabled and SSH allowed."
}

# Block China via Hosts File
function Block-ChinaHosts {
    Write-Log "Blocking Chinese domains in hosts file..."
    $hostsFile = "C:\Windows\System32\drivers\etc\hosts"
    $chinaDomains = @"
# Block Chinese domains
127.0.0.1 baidu.com
127.0.0.1 qq.com
127.0.0.1 wechat.com
127.0.0.1 alibaba.com
127.0.0.1 tencent.com
"@

    Add-Content -Path $hostsFile -Value $chinaDomains -Force
    Write-Log "Chinese domains have been blocked in hosts file."
}

# Install Windows Updates
function Install-WindowsUpdates {
    Write-Log "Installing Windows Updates..."
    Install-Module -Name PSWindowsUpdate -Force -AllowClobber -ErrorAction SilentlyContinue
    Import-Module PSWindowsUpdate
    Get-WindowsUpdate -Install -AcceptAll -AutoReboot -Verbose | Out-Null
    Write-Log "Windows updates installed successfully."
}

# Install Applications
function Install-Applications {
    Write-Log "Installing Applications..."
    $applications = Get-Content -Path $appConfig | ConvertFrom-Json
    foreach ($app in $applications) {
        $installerPath = "$env:TEMP\$($app.Name)_Setup.exe"
        Write-Log "Downloading $($app.Name)..."
        Invoke-WebRequest -Uri $app.URL -OutFile $installerPath
        Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait
        Write-Log "$($app.Name) installation complete."
    }
}

# Cleanup Temporary Files
function Cleanup-TempFiles {
    Write-Log "Cleaning up temporary files..."
    Remove-Item -Path "$env:TEMP\*_Setup.exe" -Force -ErrorAction SilentlyContinue
    Write-Log "Temporary files cleaned up."
}

# Main Function
function Main {
    Write-Log "=== New Windows Install Script Started ==="
    Confirm-Execution
    Initialize-AppConfig
    Install-SSHServer
    Generate-SSHCredentials
    Configure-Firewall
    Block-ChinaHosts
    Install-WindowsUpdates
    Install-Applications
    Cleanup-TempFiles
    Write-Log "All tasks completed successfully!"
    Write-Host "Script execution complete! SSH credentials are saved on your Desktop."
}

# Run Script
Main
