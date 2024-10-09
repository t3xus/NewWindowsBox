<h1>System Setup and Application Deployment Script</h1>

<h2>Overview</h2>

<p>This script automates the setup and configuration of a Windows system by:</p>

<ul>
<li>Running silent Windows updates (including security patches).</li>
<li>Enabling dark mode if it's not already enabled.</li>
<li>Disabling Xbox app from startup.</li>
<li>Removing unnecessary third-party applications (bloatware).</li>
<li>Cleaning up the Start Menu by unpinning unnecessary apps and pinning essential ones.</li>
<li>Silently installing <strong>TeamViewer</strong>, <strong>Office 365</strong>, <strong>Adobe Acrobat Pro</strong>, and <strong>Tailscale</strong>.</li>
<li>Prompting the user to add a new user account with customizable options for username, password, and admin privileges.</li>
<li>Configuring the firewall for SSH access.</li>
</ul>

<h2>Features</h2>

<ul>
<li><strong>Windows Update</strong>: Automatically installs the latest Windows updates, including critical security patches, and restarts the machine if necessary.</li>
<li><strong>Dark Mode</strong>: Automatically switches the system theme to dark mode for a more comfortable viewing experience.</li>
<li><strong>Remove Xbox App</strong>: Removes Xbox app entries from startup and disables Xbox-related scheduled tasks.</li>
<li><strong>Remove Bloatware</strong>: Uninstalls pre-installed third-party applications that often come bundled with Windows installations.</li>
<li><strong>Start Menu Cleanup</strong>: Resets the Start Menu to only show <strong>Microsoft Edge</strong>, <strong>Notepad</strong>, and <strong>File Explorer</strong>.</li>
<li><strong>Silent Installations</strong>:
<ul>
<li><strong>TeamViewer</strong>: Remote control and desktop sharing.</li>
<li><strong>Office 365</strong>: Productivity suite including Word, Excel, and PowerPoint.</li>
<li><strong>Adobe Acrobat Pro</strong>: PDF creation and management.</li>
<li><strong>Tailscale</strong>: Secure VPN for easy remote access.</li>
</ul></li>
<li><strong>New User Creation</strong>: Prompts the user to add a new system account with an option to set admin privileges.</li>
<li><strong>Firewall Configuration</strong>: Opens port 22 for SSH access, ensuring secure communication.</li>
</ul>

<h2>Prerequisites</h2>

<ul>
<li>PowerShell 5.1 or later</li>
<li>Internet connection for downloading application installers and updates.</li>
</ul>

<h2>How to Use</h2>

<ol>
<li>Download and run the script in PowerShell as an administrator.</li>
<li>Follow the prompts to add a new user account if desired.</li>
<li>The script will silently install updates, configure privacy settings, install necessary applications, and clean up the system.</li>
</ol>

<h3>Example</h3>

<p><code>powershell
.\SystemSetup.ps1
</code></p>

<p>Once the script is executed, all the tasks will run automatically, including system updates, bloatware removal, app installations, and configuration of user accounts and firewall.</p>

<h2>License</h2>

<p>This project is licensed under the MIT License - see the <a href="LICENSE">LICENSE</a> file for details.</p>

<h2>Author</h2>

<ul>
<li><strong>[Your Name]</strong> - Original developer</li>
</ul>
