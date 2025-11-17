<#
.SYNOPSIS
    Brave Portable Updater - Standalone updater script for scheduled updates
    
.DESCRIPTION
    This script can be run independently or via Task Scheduler to check and install
    Brave updates without launching the browser. Shows notifications when updates are available.
    
.NOTES
    Version: 1.0
    Author: Custom Agents Pro
#>

[CmdletBinding()]
param(
    [switch]$Silent,
    [switch]$ShowNotification
)

# Script configuration
$Script:ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Script:LauncherScript = Join-Path $ScriptDir "BraveLauncher.ps1"

function Show-WindowsNotification {
    param(
        [string]$Title,
        [string]$Message,
        [string]$Type = "Info"
    )
    
    try {
        # Using Windows.UI.Notifications for toast notifications
        [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
        [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
        
        $template = @"
<toast>
    <visual>
        <binding template="ToastGeneric">
            <text>$Title</text>
            <text>$Message</text>
        </binding>
    </visual>
</toast>
"@
        
        $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
        $xml.LoadXml($template)
        $toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
        $notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Brave Portable")
        $notifier.Show($toast)
    } catch {
        # Fallback to console output
        if (-not $Silent) {
            Write-Host "$Title - $Message" -ForegroundColor Cyan
        }
    }
}

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    
    if ($Silent -and $Level -ne "ERROR") {
        return
    }
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($Level) {
        "ERROR" { "Red" }
        "WARN" { "Yellow" }
        "SUCCESS" { "Green" }
        default { "White" }
    }
    Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor $color
}

function Test-BraveLauncherExists {
    if (-not (Test-Path $Script:LauncherScript)) {
        Write-Log "Launcher script not found: $Script:LauncherScript" "ERROR"
        return $false
    }
    return $true
}

# Main execution
try {
    if (-not (Test-BraveLauncherExists)) {
        exit 1
    }
    
    Write-Log "Starting Brave update check..." "INFO"
    
    # Run the launcher in update-only mode
    $result = & $Script:LauncherScript -UpdateOnly -SkipUpdate:$false -ForceUpdate:$false
    
    if ($LASTEXITCODE -eq 0 -or $null -eq $LASTEXITCODE) {
        Write-Log "Update check complete" "SUCCESS"
        
        if ($ShowNotification) {
            Show-WindowsNotification -Title "Brave Portable" -Message "Update check complete. Brave is up to date!" -Type "Info"
        }
    } else {
        Write-Log "Update check encountered an error" "WARN"
        
        if ($ShowNotification) {
            Show-WindowsNotification -Title "Brave Portable" -Message "Update check encountered an error. Check logs for details." -Type "Warning"
        }
    }
    
} catch {
    Write-Log "Updater error: $_" "ERROR"
    if ($ShowNotification) {
        Show-WindowsNotification -Title "Brave Portable Update Error" -Message $_.Exception.Message -Type "Error"
    }
    exit 1
}
