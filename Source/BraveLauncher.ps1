<#
.SYNOPSIS
    Brave Portable Launcher - Launches Brave browser in portable mode with auto-update capability
    
.DESCRIPTION
    This launcher checks for updates, downloads new versions if available, and launches Brave
    with portable flags similar to Portapps but with automatic updates enabled.
    
.NOTES
    Version: 1.0
    Author: Custom Agents Pro
    Inspired by: chrlauncher and Portapps
#>

[CmdletBinding()]
param(
    [switch]$ForceUpdate,
    [switch]$SkipUpdate,
    [switch]$UpdateOnly
)

# Load required assemblies for UI
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Script configuration
$scriptPath = $MyInvocation.MyCommand.Path
if (-not [string]::IsNullOrWhiteSpace($scriptPath)) {
    $Script:ScriptDir = Split-Path -Parent $scriptPath
}
if ([string]::IsNullOrWhiteSpace($Script:ScriptDir)) {
    if ($PSScriptRoot) {
        $Script:ScriptDir = $PSScriptRoot
    } else {
        $exePath = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
        $Script:ScriptDir = Split-Path -Parent $exePath
    }
}
$Script:ConfigFile = Join-Path $ScriptDir "config.json"
# Support both old (app/profile/extensions) and new (Browser/Data/Extensions) folder names
$Script:AppDir = if (Test-Path (Join-Path $ScriptDir "Browser")) { Join-Path $ScriptDir "Browser" } else { Join-Path $ScriptDir "app" }
$Script:ProfileDir = if (Test-Path (Join-Path $ScriptDir "Data")) { Join-Path $ScriptDir "Data" } else { Join-Path $ScriptDir "profile" }
$Script:BraveExe = Join-Path $AppDir "brave.exe"
$Script:VersionFile = Join-Path $AppDir "version.txt"
$Script:TempDir = Join-Path $ScriptDir "temp"
$Script:ExtensionsDir = if (Test-Path (Join-Path $ScriptDir "Extensions")) { Join-Path $ScriptDir "Extensions" } else { Join-Path $ScriptDir "extensions" }

# Default configuration
$Script:DefaultConfig = @{
    UpdateCheckDays = 2
    AutoDownload = $true
    LastCheck = 0
    CurrentVersion = ""
    Architecture = "x64"
    DownloadUrl = "https://api.github.com/repos/brave/brave-browser/releases/latest"
}

#region Functions

$Script:TrayIcon = $null

function Show-TrayIcon {
    param([string]$Text)
    
    if ($null -eq $Script:TrayIcon) {
        $Script:TrayIcon = New-Object System.Windows.Forms.NotifyIcon
        # Try to use Brave's icon if available, else generic
        if (Test-Path $Script:BraveExe) {
            try {
                $Script:TrayIcon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($Script:BraveExe)
            } catch {
                $Script:TrayIcon.Icon = [System.Drawing.SystemIcons]::Application
            }
        } else {
            $Script:TrayIcon.Icon = [System.Drawing.SystemIcons]::Application
        }
        $Script:TrayIcon.Visible = $true
    }
    
    # Text property is limited to 63 chars
    $Script:TrayIcon.Text = $Text.Substring(0, [Math]::Min($Text.Length, 63))
    $Script:TrayIcon.ShowBalloonTip(3000, "Brave Portable", $Text, [System.Windows.Forms.ToolTipIcon]::Info)
}

function Hide-TrayIcon {
    if ($null -ne $Script:TrayIcon) {
        $Script:TrayIcon.Visible = $false
        $Script:TrayIcon.Dispose()
        $Script:TrayIcon = $null
    }
}

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($Level) {
        "ERROR" { "Red" }
        "WARN" { "Yellow" }
        "SUCCESS" { "Green" }
        default { "White" }
    }
    Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor $color
}

function Get-Config {
    if (Test-Path $Script:ConfigFile) {
        try {
            $config = Get-Content $Script:ConfigFile -Raw | ConvertFrom-Json
            return $config
        } catch {
            Write-Log "Failed to read config file, using defaults" "WARN"
            return $Script:DefaultConfig
        }
    } else {
        Write-Log "Config file not found, creating default" "INFO"
        Save-Config $Script:DefaultConfig
        return $Script:DefaultConfig
    }
}

function Save-Config {
    param($Config)
    try {
        $Config | ConvertTo-Json -Depth 10 | Set-Content $Script:ConfigFile -Encoding UTF8
        Write-Log "Configuration saved" "INFO"
    } catch {
        Write-Log "Failed to save config: $_" "ERROR"
    }
}

function Get-CurrentVersion {
    if (Test-Path $Script:VersionFile) {
        return Get-Content $Script:VersionFile -Raw -ErrorAction SilentlyContinue | ForEach-Object { $_.Trim() }
    }
    return $null
}

function Get-LatestVersionInfo {
    try {
        Write-Log "Checking for latest Brave version..." "INFO"
        $response = Invoke-RestMethod -Uri $Script:DefaultConfig.DownloadUrl -UseBasicParsing -ErrorAction Stop
        
        $version = $response.tag_name -replace '^v', ''
        
        # Look for the Windows x64 zip file (portable version)
        $asset = $response.assets | Where-Object { 
            $_.name -eq "brave-v$version-win32-x64.zip"
        } | Select-Object -First 1
        
        if ($asset) {
            return @{
                Version = $version
                DownloadUrl = $asset.browser_download_url
                Size = $asset.size
                PublishedDate = $response.published_at
                FileName = $asset.name
            }
        } else {
            Write-Log "Could not find Windows x64 zip file in release" "ERROR"
            return $null
        }
    } catch {
        Write-Log "Failed to check for updates: $_" "ERROR"
        return $null
    }
}

function Test-UpdateNeeded {
    param($Config)
    
    $currentVersion = Get-CurrentVersion
    $latestInfo = Get-LatestVersionInfo
    
    if (-not $latestInfo) {
        return $null
    }
    
    $currentVersionDisplay = if ($currentVersion) { $currentVersion } else { "Not installed" }
    Write-Log "Current version: $currentVersionDisplay" "INFO"
    Write-Log "Latest version: $($latestInfo.Version)" "INFO"
    
    if (-not $currentVersion -or $currentVersion -ne $latestInfo.Version) {
        return $latestInfo
    }
    
    return $null
}

function Download-BraveUpdate {
    param($VersionInfo)
    
    try {
        # Create temp directory
        if (-not (Test-Path $Script:TempDir)) {
            New-Item -ItemType Directory -Path $Script:TempDir -Force | Out-Null
        }
        
        $zipPath = Join-Path $Script:TempDir $VersionInfo.FileName
        
        Write-Log "Downloading Brave $($VersionInfo.Version)..." "INFO"
        Write-Log "Size: $([math]::Round($VersionInfo.Size / 1MB, 2)) MB" "INFO"
        
        # Download with progress
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $VersionInfo.DownloadUrl -OutFile $zipPath -UseBasicParsing
        $ProgressPreference = 'Continue'
        
        Write-Log "Download complete!" "SUCCESS"
        return $zipPath
    } catch {
        Write-Log "Download failed: $_" "ERROR"
        return $null
    }
}

function Install-BraveUpdate {
    param([string]$ZipPath, $VersionInfo)
    
    try {
        Write-Log "Extracting Brave archive..." "INFO"
        
        # Create fresh app directory
        if (Test-Path $Script:AppDir) {
            Write-Log "Backing up current installation..." "INFO"
            $backupDir = "$Script:AppDir.backup"
            if (Test-Path $backupDir) {
                Remove-Item $backupDir -Recurse -Force
            }
            Move-Item $Script:AppDir $backupDir -Force
        }
        New-Item -ItemType Directory -Path $Script:AppDir -Force | Out-Null
        
        # Extract zip file
        Write-Log "Extracting files to app directory..." "INFO"
        Expand-Archive -Path $ZipPath -DestinationPath $Script:AppDir -Force
        
        # The zip contains files directly or in a subdirectory, let's check
        $braveExeInRoot = Join-Path $Script:AppDir "brave.exe"
        if (-not (Test-Path $braveExeInRoot)) {
            # Files might be in a subdirectory, move them up
            $subDirs = Get-ChildItem $Script:AppDir -Directory
            if ($subDirs.Count -eq 1) {
                $subDir = $subDirs[0].FullName
                Get-ChildItem $subDir | Move-Item -Destination $Script:AppDir -Force
                Remove-Item $subDir -Force
            }
        }
        
        # Verify extraction
        if (Test-Path (Join-Path $Script:AppDir "brave.exe")) {
            # Save version info
            $VersionInfo.Version | Set-Content $Script:VersionFile -Encoding UTF8
            
            Write-Log "Installation complete!" "SUCCESS"
            
            # Cleanup
            Remove-Item $Script:TempDir -Recurse -Force -ErrorAction SilentlyContinue
            if (Test-Path "$Script:AppDir.backup") {
                Remove-Item "$Script:AppDir.backup" -Recurse -Force -ErrorAction SilentlyContinue
            }
            
            return $true
        } else {
            Write-Log "brave.exe not found after extraction" "ERROR"
            
            # Restore backup
            if (Test-Path "$Script:AppDir.backup") {
                Remove-Item $Script:AppDir -Recurse -Force -ErrorAction SilentlyContinue
                Move-Item "$Script:AppDir.backup" $Script:AppDir -Force
            }
            return $false
        }
    } catch {
        Write-Log "Installation failed: $_" "ERROR"
        Write-Log $_.ScriptStackTrace "ERROR"
        
        # Restore backup
        if (Test-Path "$Script:AppDir.backup") {
            Remove-Item $Script:AppDir -Recurse -Force -ErrorAction SilentlyContinue
            Move-Item "$Script:AppDir.backup" $Script:AppDir -Force
        }
        return $false
    }
}

function Start-Brave {
    # Check if Brave is installed, if not trigger force update
    if (-not (Test-Path $Script:BraveExe)) {
        Write-Log "Brave not installed. Downloading latest version..." "WARN"
        Write-Host "`nFirst launch detected - downloading Brave..." -ForegroundColor Yellow
        Write-Host "This will take 2-3 minutes (downloading ~200 MB)...`n" -ForegroundColor Gray
        
        # Trigger force update to download and install Brave
        Update-Brave -Force $true
        
        # Check again if Brave is now available
        if (-not (Test-Path $Script:BraveExe)) {
            Write-Log "Failed to download Brave. Please check your internet connection." "ERROR"
            Write-Host "`nPress any key to exit..." -ForegroundColor Red
            $null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            return $false
        }
        
        Write-Log "Brave installed successfully!" "SUCCESS"
    }
    
    # Ensure profile directory exists
    if (-not (Test-Path $Script:ProfileDir)) {
        New-Item -ItemType Directory -Path $Script:ProfileDir -Force | Out-Null
    }
    
    # Build portable command line arguments (same as Portapps)
    $launchArgs = @(
        "--user-data-dir=`"$Script:ProfileDir`"",
        "--no-default-browser-check",
        "--disable-logging",
        "--disable-breakpad",
        "--disable-machine-id",
        "--disable-encryption-win"
    )
    
    # Add extensions if they exist
    if (Test-Path $Script:ExtensionsDir) {
        $extensionPaths = @()
        Get-ChildItem -Path $Script:ExtensionsDir -Filter "*.crx" | ForEach-Object {
            # Extract extension to a folder for Chromium to load
            $extName = $_.BaseName
            $extFolder = Join-Path $Script:ExtensionsDir $extName
            
            if (-not (Test-Path $extFolder)) {
                try {
                    # Create extraction folder
                    New-Item -ItemType Directory -Path $extFolder -Force | Out-Null
                    
                    # CRX files have a special header that must be stripped before ZIP extraction
                    # CRX3 format: "Cr24" (4 bytes) + version (4 bytes) + header length (4 bytes) + header + ZIP data
                    $crxBytes = [System.IO.File]::ReadAllBytes($_.FullName)
                    
                    # Check if it's a CRX3 file (starts with "Cr24")
                    $magic = [System.Text.Encoding]::ASCII.GetString($crxBytes[0..3])
                    if ($magic -eq "Cr24") {
                        # Read header length (bytes 8-11, little-endian)
                        $headerLen = [BitConverter]::ToInt32($crxBytes, 8)
                        
                        # ZIP data starts after: 4 (magic) + 4 (version) + 4 (header len) + headerLen
                        $zipStart = 12 + $headerLen
                        
                        # Extract ZIP portion to temp file
                        $tempZip = Join-Path $Script:TempDir "$extName.zip"
                        if (-not (Test-Path $Script:TempDir)) {
                            New-Item -ItemType Directory -Path $Script:TempDir -Force | Out-Null
                        }
                        
                        $zipBytes = $crxBytes[$zipStart..($crxBytes.Length - 1)]
                        [System.IO.File]::WriteAllBytes($tempZip, $zipBytes)
                        
                        # Extract the ZIP
                        Add-Type -AssemblyName System.IO.Compression.FileSystem
                        [System.IO.Compression.ZipFile]::ExtractToDirectory($tempZip, $extFolder)
                        
                        # Clean up temp ZIP
                        Remove-Item $tempZip -Force -ErrorAction SilentlyContinue
                    } else {
                        # Not CRX3, try direct ZIP extraction
                        Add-Type -AssemblyName System.IO.Compression.FileSystem
                        [System.IO.Compression.ZipFile]::ExtractToDirectory($_.FullName, $extFolder)
                    }
                    
                    Write-Log "Extracted extension: $extName" "INFO"
                } catch {
                    Write-Log "Failed to extract $extName : $_" "WARN"
                }
            }
            
            if (Test-Path $extFolder) {
                $extensionPaths += $extFolder
            }
        }
        
        if ($extensionPaths.Count -gt 0) {
            $extPathsJoined = $extensionPaths -join ","
            $launchArgs += "--load-extension=`"$extPathsJoined`""
            Write-Log "Loading $($extensionPaths.Count) extension(s)" "INFO"
        }
    }
    
    Write-Log "Launching Brave..." "SUCCESS"
    Start-Process -FilePath $Script:BraveExe -ArgumentList $launchArgs
    
    return $true
}

function Update-Brave {
    param([bool]$Force = $false)
    
    $config = Get-Config
    
    # Check if we should check for updates
    $now = [DateTimeOffset]::Now.ToUnixTimeSeconds()
    $daysSinceCheck = ($now - $config.LastCheck) / 86400
    
    if (-not $Force -and $daysSinceCheck -lt $config.UpdateCheckDays) {
        Write-Log "Last checked $([math]::Round($daysSinceCheck, 1)) days ago, skipping check" "INFO"
        return $false
    }
    
    # Check for updates
    $updateInfo = Test-UpdateNeeded $config
    
    if ($updateInfo) {
        Write-Log "Update available: v$($updateInfo.Version)" "SUCCESS"
        
        # Notify user about the update
        Show-TrayIcon -Text "Updating Brave to v$($updateInfo.Version)..."
        
        if ($config.AutoDownload) {
            $installerPath = Download-BraveUpdate $updateInfo
            if ($installerPath) {
                $success = Install-BraveUpdate $installerPath $updateInfo
                if ($success) {
                    $config.CurrentVersion = $updateInfo.Version
                    Show-TrayIcon -Text "Update complete! Launching Brave..."
                }
            }
        } else {
            Write-Log "Auto-download is disabled. Set AutoDownload=true in config.json to enable" "WARN"
        }
        
        # Keep icon visible briefly if we're about to launch, or hide it if we're done with update logic
        # The launcher will continue to Start-Brave, so we can leave it or hide it. 
        # If we hide it here, the balloon tip might disappear too fast.
        # Let's rely on the finally block to clean it up, or hide it explicitly if no launch happens.
    } else {
        Write-Log "Brave is up to date!" "SUCCESS"
    }
    
    # Update last check time
    $config.LastCheck = $now
    Save-Config $config
    
    return ($null -ne $updateInfo)
}

#endregion

#region Main Execution

try {
    Write-Host "`n==== Brave Portable Launcher ====" -ForegroundColor Cyan
    Write-Host "Version: 1.0`n" -ForegroundColor Cyan
    
    # Handle parameters
    if ($ForceUpdate) {
        Write-Log "Force update requested" "INFO"
        Update-Brave -Force $true
    } elseif (-not $SkipUpdate) {
        Update-Brave
    }
    
    # Launch browser unless update-only mode
    if (-not $UpdateOnly) {
        Start-Brave
    } else {
        Write-Log "Update-only mode, not launching browser" "INFO"
    }
    
    Write-Host "`n==== Brave Portable Launcher Complete ====`n" -ForegroundColor Cyan
    
} catch {
    Write-Log "Unexpected error: $_" "ERROR"
    Write-Log $_.ScriptStackTrace "ERROR"
    
    # Show error in tray if possible
    if ($null -ne $Script:TrayIcon) {
        Show-TrayIcon -Text "Error: $_"
        Start-Sleep -Seconds 5
    }
    
    Read-Host "Press Enter to exit"
} finally {
    Hide-TrayIcon
}

#endregion
