# Brave Portable Launcher

A portable Brave browser launcher with automatic update capabilities, inspired by chrlauncher and Portapps.

## Features

- ✅ **Always Up-to-Date**: Automatically checks GitHub for latest Brave releases
- ✅ **Portable**: All data stored in local `profile/` directory
- ✅ **Privacy-Focused**: Same portable flags as Portapps (--disable-machine-id, --disable-encryption-win)
- ✅ **Auto-Updates**: Downloads and installs new versions automatically
- ✅ **Configurable**: Customizable update frequency and behavior
- ✅ **Standalone Updater**: Can check/update without launching browser
- ✅ **Pre-loaded Extensions**: Supports bundled Chrome/Brave extensions (CRX3 format)
- ✅ **Registry Cleanup**: Tools to remove Brave traces for true portability
- ✅ **Professional Installer**: Single-EXE Inno Setup installer with custom branding

## Directory Structure

```
BravePortable/
├── README.md                      # This file
├── .gitignore                     # Git exclusions
├── brave-portable-setup.exe       # 📦 Full Bundle Installer (155 MB)
├── Reorganize.ps1                 # Migration script (dev only)
│
├── Build/                         # 🔧 Build Scripts & Configuration
│   ├── BravePortable-InnoSetup.iss   # Inno Setup installer script
│   ├── Create-BravePortable-SFX.ps1  # 7-Zip SFX creator (optional)
│   ├── 7zip-sfx-config.txt           # SFX configuration
│   └── CREATE-SFX.md                 # SFX build instructions
│
├── Source/                        # 📜 Source Code & Assets
│   ├── BraveLauncher.ps1          # Core launcher script
│   ├── BraveUpdater.ps1           # Standalone updater
│   ├── LaunchBrave.bat            # Batch launcher wrapper
│   ├── CleanupRegistry.ps1        # PowerShell registry cleanup
│   ├── CleanupRegistry.reg        # Quick registry cleanup
│   └── Assets/                    # Images and icons
│       ├── brave-icon.ico
│       ├── WizardImage.bmp
│       └── WizardSmallImage.bmp
│
├── Documentation/                 # 📚 Documentation Files
│   ├── QUICKSTART.md              # Quick reference guide
│   ├── INSTALLATION.md            # Build and distribution guide
│   ├── ORGANIZATION.md            # Folder structure documentation
│   ├── REORGANIZATION-SUMMARY.md  # Migration history
│   └── LICENSE                    # MIT License
│
├── Release/                       # ⭐ DISTRIBUTION FOLDER (like Mullvad)
│   ├── BravePortable.exe          # Main launcher executable (79 KB)
│   ├── config.json                # Configuration file
│   ├── README.txt                 # User-facing documentation
│   ├── Browser/                   # Brave application files
│   │   └── brave.exe              # (pre-installed in full bundle)
│   ├── Data/                      # User profile and settings
│   │   └── User Data/             # (created on first launch)
│   └── Extensions/                # Pre-loaded extensions
│       └── bitwarden.crx          # Bitwarden password manager
│
└── [Dev Only - Git Ignored]       # Development workspace
    ├── app/                       # Dev Brave binaries
    ├── profile/                   # Dev profile data
    ├── extensions/                # Dev extensions
    ├── BravePortable.exe          # Dev launcher (for testing)
    ├── BravePortable-DEBUG.exe    # Debug version
    └── config.json                # Dev configuration
```

**For End Users**: 
- Run `brave-portable-setup.exe` to install
- Or use the `Release/` folder directly (portable ZIP alternative)

**For Developers**: 
- Root contains build tools and source code
- Dev workspace files (app/, profile/, extensions/) are git-ignored

## Installation Options

### Option 1: Installer (Recommended)

1. **Download `brave-portable-setup.exe`** (155 MB - includes Brave v1.84.139)
2. **Run the installer**
3. **Choose installation folder** (e.g., `C:\BravePortable` or USB drive)
4. **Launch `BravePortable.exe`**
5. **Brave opens instantly!** (No download needed, browser pre-installed)

**Install time: 10-15 seconds** | **No internet required after download**

### Option 2: Portable Folder (Manual)

1. **Download the `Release/` folder** (as ZIP from GitHub)
2. **Extract to any location** (local drive, USB stick, network share)
3. **Double-click `BravePortable.exe`**
4. **First launch will:**
   - Download latest Brave (~200 MB) if not included
   - Extract to `Browser/` folder
   - Create `Data/` profile directory
   - Load pre-installed extensions
   - Launch Brave browser

**First launch: 2-3 minutes** (download + extraction) | **Subsequent launches: instant**

### For Developers

1. **Clone the repository**
2. **Run `Reorganize.ps1`** (if upgrading from old structure)
3. **Test from root**: `.\BravePortable.exe` (uses dev workspace: app/, profile/)
4. **Build installer**: See `Build/BravePortable-InnoSetup.iss` and `Documentation/INSTALLATION.md`
5. **Compile launcher**: `Invoke-ps2exe .\Source\BraveLauncher.ps1 .\Release\BravePortable.exe -noConsole -iconFile .\Source\Assets\brave-icon.ico`

## Usage

### Normal Launch

Simply run: `.\BravePortable.exe`

The launcher checks for updates based on your config (default: every 2 days).

## Command-Line Options

### BraveLauncher.ps1

```powershell
# Force update check and download
.\BraveLauncher.ps1 -ForceUpdate

# Skip update check (launch immediately)
.\BraveLauncher.ps1 -SkipUpdate

# Only update, don't launch browser
.\BraveLauncher.ps1 -UpdateOnly
```

### BraveUpdater.ps1

```powershell
# Silent update (no console output except errors)
.\BraveUpdater.ps1 -Silent

# Show Windows toast notification when complete
.\BraveUpdater.ps1 -ShowNotification
```

## Configuration (config.json)

```json
{
  "UpdateCheckDays": 2,        // Check for updates every X days
  "AutoDownload": true,        // Automatically download updates
  "LastCheck": 0,              // Unix timestamp of last check
  "CurrentVersion": "",        // Currently installed version
  "Architecture": "x64",       // System architecture
  "DownloadUrl": "https://api.github.com/repos/brave/brave-browser/releases/latest"
}
```

### Configuration Options

- **UpdateCheckDays**: How often to check for updates (default: 2 days)
  - Set to `0` to disable automatic update checks
  - Set to `-1` to force check on every launch
  
- **AutoDownload**: Automatically download and install updates (default: true)
  - Set to `false` to only notify about updates without downloading

## Portable Flags

The launcher passes these flags to Brave (same as Portapps):

- `--user-data-dir=.\profile` - Store all data in portable profile
- `--no-default-browser-check` - Don't check if default browser
- `--disable-logging` - Disable logging
- `--disable-breakpad` - Disable crash reporting
- `--disable-machine-id` - Disable machine ID generation
- `--disable-encryption-win` - Disable Windows encryption for cookies/passwords

**Note**: Passwords and cookies are NOT encrypted. Store the `profile/` folder on an encrypted drive for security.

## Pre-loaded Extensions

BravePortable supports bundled Chrome/Brave extensions (CRX3 format). Extensions in the `extensions/` folder are automatically extracted and loaded on first launch.

### Included Extensions

- **Bitwarden** (v2025.11.0) - Password manager

### Adding More Extensions

1. Download extension CRX file from Chrome Web Store:
   ```
   https://clients2.google.com/service/update2/crx?response=redirect&prodversion=110.0&acceptformat=crx2,crx3&x=id%3D{EXTENSION_ID}%26uc
   ```
   Replace `{EXTENSION_ID}` with the extension's Chrome Web Store ID (found in the URL)

2. Save to `extensions/` folder with a descriptive name (e.g., `ublock-origin.crx`)

3. Rebuild the installer or redistribute the `extensions/` folder

**Note**: Extensions are extracted once on first launch. To force re-extraction, delete the extracted folder in `extensions/`.

## Registry Cleanup Tools

Brave may leave traces in the Windows Registry even in portable mode. Two cleanup tools are included:

### Quick Cleanup (CleanupRegistry.reg)
Double-click `CleanupRegistry.reg` for instant cleanup (no output).

### Detailed Cleanup (CleanupRegistry.ps1)
Run for detailed output showing what was cleaned:
```powershell
powershell.exe -ExecutionPolicy Bypass -File .\CleanupRegistry.ps1
```

**Run as Administrator** for complete cleanup of HKEY_LOCAL_MACHINE entries.

### What Gets Cleaned
- `HKCU:\Software\BraveSoftware` - User settings
- `HKLM:\Software\Clients\StartMenuInternet\Brave*` - Browser registration
- `HKEY_CLASSES_ROOT\Brave*` - File associations
- Various startup and registered application entries

## Scheduled Updates

### Create Task Scheduler Entry

Run this PowerShell command to create a daily update check:

```powershell
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -File `"$PWD\BraveUpdater.ps1`" -Silent -ShowNotification"
$trigger = New-ScheduledTaskTrigger -Daily -At 9am
Register-ScheduledTask -TaskName "Brave Portable Auto-Update" -Action $action -Trigger $trigger -Description "Daily update check for Brave Portable"
```

This checks for updates every day at 9 AM and shows a notification when complete.

## Migrating from Existing Brave Installation

If you have Brave installed normally:

1. **Copy your profile**:
   ```powershell
   Copy-Item "$env:APPDATA\BraveSoftware\Brave-Browser\User Data\*" .\profile\ -Recurse
   ```

2. **Run the launcher**:
   ```powershell
   .\BraveLauncher.ps1
   ```

3. **Uninstall the original Brave** from Windows Settings

## Troubleshooting

### "Brave executable not found"
Run with `-ForceUpdate` to download Brave:
```powershell
.\BraveLauncher.ps1 -ForceUpdate
```

### Update fails
- Check internet connection
- Ensure you have write permissions to the directory
- Check GitHub API rate limits (60 requests/hour for unauthenticated)

### Browser doesn't start
- Check that `app\brave.exe` exists
- Try running Brave directly: `.\app\brave.exe --user-data-dir=.\profile`
- Check antivirus isn't blocking execution

## Comparison to Other Solutions

| Feature | BravePortable | Portapps |
|---------|--------------|----------|
| Auto-Updates | ✅ Yes | ❌ No |
| Portable | ✅ Yes | ✅ Yes |
| Up-to-Date | ✅ Always | ❌ Depends on maintainer |
| Brave Support | ✅ Yes | ⚠️ Outdated |
| Maintenance | ✅ Zero | ❌ Manual updates |

## Version History

### v1.0 (2025-11-17)
- Initial release
- Auto-update via GitHub API
- Portable configuration matching Portapps
- Standalone updater script
- Configurable update frequency (default: 2 days)
- CRX3 extension support with automatic header stripping
- Bitwarden extension v2025.11.0 pre-loaded
- Registry cleanup tools (PowerShell and .reg)
- Professional Inno Setup installer with full bundle (155 MB)
- Custom Brave branding and wizard images
- Dual folder name support (Browser/Data/Extensions OR app/profile/extensions)
- Auto-download on first launch if Brave missing
- Clean folder structure (Build/, Source/, Documentation/, Release/)
- Fixed path resolution for compiled EXE execution

## Distribution Files

**Available downloads:**

- **brave-portable-setup.exe** (155 MB)
  - Full bundle installer with Brave v1.84.139 pre-installed
  - Inno Setup professional installer with custom branding
  - Includes Bitwarden extension, registry cleanup tools, documentation
  - Extracts ~660 MB (compressed to 155 MB)
  - Launches instantly after installation (no download wait)

- **Release/ folder** (portable alternative)
  - Clean distribution folder matching Mullvad Browser structure
  - Can be zipped for portable distribution
  - ~660 MB with Browser included, ~30 MB without (downloads on first launch)

## Credits

- Inspired by [chrlauncher](https://github.com/henrypp/chrlauncher) by Henry++
- Portable flags based on [Portapps](https://github.com/portapps/portapps) by @crazy-max
- Built for the community by Custom Agents Pro

## License

MIT License - Free to use, modify, and distribute.
