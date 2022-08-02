# Create Workdir
$BasePath = "C:\Windows\Temp\Install"
New-item $BasePath -itemtype directory

# Enable RDP
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Add RedHat to Trusted Publisher
$CertName = "balloon.cer"
$ExportCert = Join-Path $BasePath -ChildPath $CertName

$Cert = (Get-AuthenticodeSignature "e:\Balloon\2k19\amd64\balloon.sys").SignerCertificate
$ExportType = [System.Security.Cryptography.X509Certificates.X509ContentType]::Cert

[System.IO.File]::WriteAllBytes($ExportCert, $Cert.Export($ExportType))
Import-Certificate -FilePath $ExportCert -CertStoreLocation Cert:\LocalMachine\Trust

# install Guest Agent
msiexec /i e:\virtio-win-gt-x64.msi /qn /passive

# install Qemu Tools (Drivers)
msiexec /i e:\guest-agent\qemu-ga-x86_64.msi /qn /passive

# Fix Guest Agent
Start-Process  E:\vioserial\2k19\amd64\vioser.inf -Verb install

# Enable SSH
Add-WindowsCapability -Online -Name 'OpenSSH.Server~~~~0.0.1.0'
Set-Service -Name sshd -StartupType 'Automatic'

# Enable Networking

Enable-NetAdapter -Name "Ethernet" -Confirm:$false

# Get Cloud-init
#Set-ExecutionPolicy Unrestricted
#$Cloudinit = "CloudbaseInitSetup_Stable_x64.msi"
#$CloudinitLocation =  Join-Path -Path $BasePath -ChildPath $Cloudinit
#invoke-webrequest https://cloudbase.it/downloads/$Cloudinit -o $CloudinitLocation

#cmd /C start /wait msiexec /i $CloudinitLocation /qn

# Copy cloud-init configurations in from configmap

$CloudinitConfDir = "C:\Program Files\Cloudbase Solutions\Cloudbase-Init/conf"

Copy-Item -Path 'F:\cloud*.conf' -Destination $CloudinitConfDir\

# Cleanup
Remove-item $BasePath -Recurse

# Remove AutoLogin
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 0 /f

# Run Sysprep and Shutdown

#cmd /C 'cd "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf\" && C:\Windows\System32\Sysprep\sysprep.exe /generalize /oobe /shutdown /unattend:Unattend.xml'
cmd /C 'C:\Windows\System32\Sysprep\sysprep.exe /generalize /oobe /shutdown'
