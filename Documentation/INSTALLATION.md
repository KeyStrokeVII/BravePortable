# Installation & Distribution Guide

## End-User Installation (Recommended)

### Using the Installer (brave-portable-setup.exe)

1. **Download** `brave-portable-setup.exe` (~160 MB)
2. **Run the installer**
3. **Choose installation directory** (default: `C:\Portables\BravePortable`)
4. **Optional**: Check "Create desktop shortcut"
5. **Optional**: Check "Clean registry traces" to remove Brave traces after installation
6. **Launch**: Check "Launch Brave Portable" to start immediately

**What the installer does:**
- Extracts all portable files to chosen directory
- Includes Brave browser binaries (v1.84.139)
- Includes Bitwarden extension pre-configured
- Creates optional desktop shortcut
- Optionally runs registry cleanup

### First Launch After Installation

1. Double-click `BravePortable.exe` (or desktop shortcut)
2. Brave will:
   - Extract bundled extensions (Bitwarden)
   - Create your profile in `profile/` directory
   - Launch with portable settings

**First launch takes ~10 seconds** (extension extraction only, browser already included).

## Manual Installation (Advanced)

### Prerequisites
- PowerShell 5.1 or later (included in Windows 10/11)
- .NET Framework 4.5+ (included in Windows 10/11)

### Steps

1. **Download the ZIP package** or clone the repository
2. **Extract to your desired location** (e.g., `C:\Portables\BravePortable`)
3. **Run first launch**:
   ```powershell
   .\BraveLauncher.ps1 -ForceUpdate
   ```
4. Wait for Brave to download (~200 MB) and extract
5. Browser launches automatically when ready

## Building from Source

### Requirements
- Windows 10/11
- PowerShell 5.1+
- [ps2exe](https://github.com/MScholtes/PS2EXE) - PowerShell to EXE compiler
- [Inno Setup 6.6.0+](https://jrsoftware.org/isdl.php) - Installer creator (optional)

### Build Steps

#### 1. Install ps2exe
```powershell
Install-Module ps2exe -Scope CurrentUser
```

#### 2. Compile PowerShell Scripts to EXE
```powershell
# Navigate to BravePortable directory
cd C:\Path\To\BravePortable

# Compile launcher (with no console window)
ps2exe BraveLauncher.ps1 BravePortable.exe -iconFile brave-icon.ico -noConsole -noOutput

# Compile updater (optional)
ps2exe BraveUpdater.ps1 BraveUpdater.exe -iconFile brave-icon.ico -noConsole
```

#### 3. Download Brave Browser (Optional)
For faster first-run experience, pre-download Brave:
```powershell
.\BraveLauncher.ps1 -UpdateOnly
```
This populates the `app/` folder with Brave binaries.

#### 4. Build Installer (Optional)
If you have Inno Setup installed:
```powershell
& "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" BravePortable-InnoSetup.iss
```

Output: `brave-portable-setup.exe` (~160 MB with Brave, ~1 MB without)

## Adding Extensions

### Download Extension CRX Files

1. Get extension ID from Chrome Web Store URL:
   ```
   https://chromewebstore.google.com/detail/{EXTENSION_NAME}/{EXTENSION_ID}
   ```
   Example: Bitwarden = `nngceckbapebfimnlniiiahkandclblb`

2. Download CRX using this URL pattern:
   ```
   https://clients2.google.com/service/update2/crx?response=redirect&prodversion=110.0&acceptformat=crx2,crx3&x=id%3D{EXTENSION_ID}%26uc
   ```

3. Save to `extensions/` folder with descriptive name:
   ```
   extensions/
   ├── bitwarden.crx
   ├── ublock-origin.crx
   └── dark-reader.crx
   ```

4. Rebuild installer (if using) or redistribute the `extensions/` folder

### Example: Adding uBlock Origin

```powershell
# Extension ID: cjpalhdlnbpafiamejdnhcphjbkeiagm
$uBlockId = "cjpalhdlnbpafiamejdnhcphjbkeiagm"
$url = "https://clients2.google.com/service/update2/crx?response=redirect&prodversion=110.0&acceptformat=crx2,crx3&x=id%3D${uBlockId}%26uc"
Invoke-WebRequest -Uri $url -OutFile "extensions\ublock-origin.crx"
```

## Distribution Options

### Option 1: Installer Only (Recommended for Users)
- Distribute `brave-portable-setup.exe` (~160 MB)
- Includes everything: Brave, extensions, cleanup tools
- Professional installation experience
- Version displayed: "Brave Portable Version 1.0"

### Option 2: ZIP Package (Manual Setup)
Create a ZIP with:
```
BravePortable/
├── BravePortable.exe
├── BraveLauncher.ps1
├── BraveUpdater.ps1
├── config.json
├── LaunchBrave.bat
├── CleanupRegistry.ps1
├── CleanupRegistry.reg
├── README.md
├── QUICKSTART.md
├── extensions/
│   └── bitwarden.crx
└── app/                    # Optional: include for offline use
    └── [Brave binaries]
```

**With Brave**: ~550 MB  
**Without Brave**: ~15 MB (downloads on first run)

### Option 3: Source Code Only (Developers)
For GitHub releases, provide:
- All `.ps1` scripts
- Configuration files (`.json`, `.iss`)
- Documentation (`.md` files)
- Build instructions (this file)
- Extensions folder with `.crx` files

Users build their own using ps2exe and Inno Setup.

## Customization for Your Build

### Change Version Number
Edit `BravePortable-InnoSetup.iss`:
```pascal
#define MyAppVersion "1.0"  // Change to your version
```

### Change Default Installation Path
Edit `BravePortable-InnoSetup.iss`:
```pascal
DefaultDirName=C:\Portables\BravePortable  // Change path
```

### Change Branding
Replace:
- `brave-icon.ico` - Main icon (256x256 recommended)
- `WizardImage.bmp` - Installer sidebar (164x314 pixels)
- `WizardSmallImage.bmp` - Installer header (55x58 pixels)

### Customize Update Frequency
Edit `config.json`:
```json
{
  "UpdateCheckDays": 1,  // Check daily (0=never, -1=always)
  "AutoDownload": true
}
```

## System Requirements

- Windows 10 or later (64-bit)
- ~1 GB free disk space (Brave + profile)
- Internet connection (for updates)

## Deployment Scenarios

### USB Drive Deployment
1. Install to USB drive (e.g., `E:\BravePortable`)
2. Use absolute paths or ensure drive letter is consistent
3. Extensions and profile travel with the drive

### Corporate Deployment
1. Build installer with pre-configured settings
2. Include required extensions in `extensions/` folder
3. Set `UpdateCheckDays: 7` for weekly checks
4. Deploy via Group Policy or software management

### Personal Use
1. Install to `C:\Portables\BravePortable`
2. Set daily update checks
3. Create desktop shortcut
4. Schedule background updates (see README.md)

## Troubleshooting Build Issues

### ps2exe not found
```powershell
Install-Module ps2exe -Scope CurrentUser -Force
Import-Module ps2exe
```

### Inno Setup compilation fails
- Ensure Inno Setup 6.6.0+ is installed
- Check all source files exist in paths specified in `.iss` file
- Verify `brave-icon.ico` and `.bmp` wizard images exist

### Extension loading fails
- Ensure CRX files are valid Chrome/Brave extensions
- Check extension folder permissions
- Extensions extract to `extensions/{name}/` on first launch
- CRX3 format required (modern Chrome extensions)

### "Brave not found" after installation
- Verify `app/brave.exe` exists
- Check that ZIP extraction completed successfully
- Try running `.\BraveLauncher.ps1 -ForceUpdate`

## License

MIT License - Free to use, modify, and distribute with attribution.

## Support

For issues, questions, or contributions:
- GitHub Issues: [Your repository URL]
- Documentation: README.md and QUICKSTART.md included
