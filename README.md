
# System Setup and Application Deployment Script

![Static Badge](https://img.shields.io/badge/Author-Jgooch-1F4D37)
![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![Static Badge](https://img.shields.io/badge/Distribution-npm-orange)
![Target](https://img.shields.io/badge/Target-Microsoft%20Windows%2011%20Professional-357EC7)

## Overview

This script automates the setup, configuration, and deployment of a Windows system by:

- Installing and configuring OpenSSH Server, creating login credentials, and saving them to the desktop.
- Ensuring the Windows firewall is enabled and allows SSH traffic on port 22.
- Updating the Windows system, including installing critical security patches.
- Blocking Chinese domains by updating the Windows `hosts` file.
- Silently installing applications like **TeamViewer** and **Tailscale** (customizable via `apps.json`).
- Removing unnecessary third-party applications (bloatware) and cleaning up the Start Menu.
- Enabling dark mode for a better visual experience.
- Prompting the user before execution with a clear Yes/No confirmation.

---

## Features

- **Windows Update**: Automatically installs the latest Windows updates and security patches.
- **OpenSSH Server**:
    - Installs and configures OpenSSH Server.
    - Generates SSH login credentials and saves them to a file on the desktop.
    - Configures the Windows firewall to allow SSH traffic on port 22.
- **Firewall Configuration**: Ensures the Windows firewall is enabled and configured for secure SSH access.
- **Hosts File Update**: Blocks known Chinese domains by appending entries to the system's `hosts` file.
- **Dark Mode**: Switches the Windows theme to dark mode.
- **Silent Application Installations**:
    - Customizable via `apps.json`, allowing you to add or remove apps.
    - Default applications:
        - **TeamViewer**: Remote desktop and control software.
        - **Tailscale**: VPN for secure remote access.
- **Yes/No Confirmation**: Prompts the user before making any changes or installations.
- **Temporary File Cleanup**: Automatically removes downloaded installers after use.

---

## Prerequisites

- PowerShell 5.1 or later.
- Internet connection for downloading application installers and updates.

---

## How to Use

1. Download the script and run it in PowerShell as an administrator.
2. On the first run, the script will create a default `apps.json` file. Edit this file to customize which applications to install.
3. Confirm the Yes/No prompt to proceed.
4. SSH login credentials will be generated and saved on the desktop as `ssh_credentials.txt`.
5. The script will block Chinese domains, install updates, configure SSH, and install applications.

---

### Example

Run the script with the following command:

```powershell
.
wb.ps1
```

---

## Customizing Applications

The `apps.json` file allows you to define additional applications to install. The file should look like this:

```json
[
    { "Name": "TeamViewer", "URL": "https://download.teamviewer.com/download/TeamViewer_Setup.exe" },
    { "Name": "Tailscale", "URL": "https://pkgs.tailscale.com/stable/tailscale-setup.exe" }
]
```

Add or remove application entries to customize your installation.

---

## Output

- SSH login credentials are saved to `ssh_credentials.txt` on the desktop.
- The Windows system is updated with the latest patches.
- Chinese domains are blocked in the `hosts` file.
- All specified applications are installed silently.
- Temporary installation files are cleaned up automatically.

---

## Notes

- The script requires administrator privileges.
- Ensure your internet connection is stable for downloading updates and application installers.
- SSH access is configured on port 22 for secure remote management.

---

## License

This project is licensed under the MIT License.
