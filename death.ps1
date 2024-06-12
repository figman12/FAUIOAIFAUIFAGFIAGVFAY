# Ensure you are running PowerShell as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Host "Please run this script as an Administrator!"
    exit
}

# Function to create registry key if it doesn't exist
function Ensure-RegistryKey {
    param (
        [string]$Path
    )
    if (-not (Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
    }
}

# Create necessary registry keys if they do not exist
Ensure-RegistryKey -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"
Ensure-RegistryKey -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection"
Ensure-RegistryKey -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings"

# Disable Windows Defender Antivirus features
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableRoutinelyTakingAction" -Value 1 -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableBehaviorMonitoring" -Value 1 -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableOnAccessProtection" -Value 1 -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableScanOnRealtimeEnable" -Value 1 -Force

# Disable Windows Defender Real-Time Protection
Set-MpPreference -DisableRealtimeMonitoring $true

# Disable Windows Defender Antivirus
Set-MpPreference -DisableBehaviorMonitoring $true
Set-MpPreference -DisableBlockAtFirstSeen $true
Set-MpPreference -DisableIOAVProtection $true
Set-MpPreference -DisablePrivacyMode $true
Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine $true
Set-MpPreference -DisableArchiveScanning $true
Set-MpPreference -DisableIntrusionPreventionSystem $true
Set-MpPreference -DisableScriptScanning $true
Set-MpPreference -SubmitSamplesConsent 2

# Disable Windows Defender Scheduled Tasks
$tasks = @(
    "Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance",
    "Microsoft\Windows\Windows Defender\Windows Defender Cleanup",
    "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan",
    "Microsoft\Windows\Windows Defender\Windows Defender Verification"
)
foreach ($task in $tasks) {
    schtasks /Change /TN $task /Disable -ErrorAction SilentlyContinue
}

# Stop Windows Defender services
Stop-Service -Name "WinDefend" -Force -ErrorAction SilentlyContinue
Set-Service -Name "WinDefend" -StartupType Disabled -ErrorAction SilentlyContinue

# Silence Windows Defender notifications
$DefenderNotificationsPath = "HKLM:\SOFTWARE\Microsoft\Windows Defender Security Center\Notifications"
Ensure-RegistryKey -Path $DefenderNotificationsPath
Set-ItemProperty -Path $DefenderNotificationsPath -Name "DisableEnhancedNotifications" -Value 1 -Force

$SecurityHealthPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance"
Ensure-RegistryKey -Path $SecurityHealthPath
Set-ItemProperty -Path $SecurityHealthPath -Name "Enabled" -Value 0 -Force

$SecurityCenterPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityCenter"
Ensure-RegistryKey -Path $SecurityCenterPath
Set-ItemProperty -Path $SecurityCenterPath -Name "Enabled" -Value 0 -Force
