# BravePortable v1.0 - Initial Release

**Release Date:** November 17, 2025

## 🎉 What is BravePortable?

A portable Brave browser launcher with automatic updates, pre-loaded extensions, and true portability. Inspired by chrlauncher and Portapps, BravePortable keeps your browser always up-to-date while maintaining complete portability.

## ✨ Features

### Core Functionality
- ✅ **Always Up-to-Date**: Automatically checks GitHub for latest Brave releases
- ✅ **True Portability**: All data stored in local `Data/` directory (no registry dependencies)
- ✅ **Auto-Updates**: Downloads and installs new Brave versions automatically
- ✅ **Configurable**: Customizable update frequency (default: every 2 days)
- ✅ **Privacy-Focused**: Same portable flags as Portapps (`--disable-machine-id`, `--disable-encryption-win`)

### Extensions
- ✅ **Pre-loaded Extensions**: Bitwarden password manager (v2025.11.0) included
- ✅ **CRX3 Support**: Automatic CRX3 header stripping and extraction
- ✅ **Easy Extension Adding**: Drop CRX files in `Extensions/` folder

### Distribution
- ✅ **Professional Installer**: Inno Setup installer with custom Brave branding
- ✅ **Full Bundle**: Brave v1.84.139 pre-installed (155 MB compressed, ~660 MB installed)
- ✅ **Instant Launch**: No download wait after installation
- ✅ **Clean Structure**: Organized like professional portable apps (Mullvad Browser style)

### Tools & Utilities
- ✅ **Registry Cleanup**: PowerShell script + .reg file to remove Brave traces
- ✅ **Standalone Updater**: Check/update without launching browser
- ✅ **Debug Mode**: Console version for troubleshooting
- ✅ **Dual Folder Support**: Works with old (app/profile/extensions) and new (Browser/Data/Extensions) structures

## 📦 Download Options

### Option 1: Full Bundle Installer (Recommended)
**File:** `brave-portable-setup.exe` (155 MB)

**What's included:**
- Brave v1.84.139 browser (~645 MB uncompressed)
- Bitwarden extension v2025.11.0
- BravePortable.exe launcher
- Registry cleanup tools
- Documentation

**Installation:**
1. Download `brave-portable-setup.exe`
2. Run installer and choose location
3. Launch `BravePortable.exe`
4. Brave opens instantly! ⚡

**Install time:** 10-15 seconds | **No internet required**

### Option 2: Portable Folder (Manual)
**File:** `Release.zip` (create from Release/ folder)

**What's included:**
- BravePortable.exe launcher (79 KB)
- Configuration files
- Bitwarden extension
- Empty Browser/Data folders (downloads Brave on first launch)

**Installation:**
1. Download and extract Release.zip
2. Double-click `BravePortable.exe`
3. First launch downloads Brave (~200 MB)
4. Subsequent launches are instant

**First launch:** 2-3 minutes | **Requires internet once**

## 🚀 Quick Start

### After Installation

1. **Launch:** Double-click `BravePortable.exe`
2. **Configure:** First launch creates your profile in `Data/`
3. **Extensions:** Bitwarden loads automatically
4. **Updates:** Checks every 2 days (configurable in `config.json`)

### Command-Line Options

```powershell
# Force update check
.\BravePortable.exe -ForceUpdate

# Skip update check
.\BravePortable.exe -SkipUpdate

# Update only (don't launch)
.\BravePortable.exe -UpdateOnly
```

## 🔧 Configuration

Edit `config.json` to customize:

```json
{
  "UpdateCheckDays": 2,        // Check every 2 days (0=disable, -1=always)
  "AutoDownload": true,        // Auto-download updates
  "Architecture": "x64"        // System architecture
}
```

## 🧹 Registry Cleanup

Brave may leave registry traces even in portable mode. Use included tools:

**Quick:** Double-click `CleanupRegistry.reg`
**Detailed:** Run `CleanupRegistry.ps1` (shows what's cleaned)

**Cleans:**
- `HKCU:\Software\BraveSoftware`
- `HKLM:\Software\Clients\StartMenuInternet\Brave*`
- File associations and startup entries

**Tip:** Run as Administrator for complete cleanup

## 📁 Directory Structure

```
BravePortable/
├── BravePortable.exe       # Main launcher (79 KB)
├── config.json             # Configuration
├── README.txt              # User guide
├── Browser/                # Brave binaries (~645 MB)
│   └── brave.exe
├── Data/                   # Your profile (created on first launch)
│   └── User Data/
├── Extensions/             # Pre-loaded extensions
│   └── bitwarden.crx       # Bitwarden password manager
└── Tools/                  # Registry cleanup (added by installer)
    ├── CleanupRegistry.ps1
    └── CleanupRegistry.reg
```

## 🔄 How Updates Work

1. **Check:** Launcher queries GitHub API for latest Brave release
2. **Compare:** Compares with installed version
3. **Download:** If newer, downloads ZIP (~200 MB)
4. **Backup:** Saves current version to `Browser-backup/`
5. **Extract:** Unpacks new version to `Browser/`
6. **Launch:** Starts Brave with updated binaries

**Frequency:** Every 2 days (configurable)
**Automatic:** Yes (can be disabled)
**Rollback:** Backup folder allows manual rollback

## 🆚 Comparison

| Feature | BravePortable | Portapps | chrlauncher |
|---------|--------------|----------|-------------|
| Auto-Updates | ✅ Yes | ❌ No | ✅ Yes |
| Always Latest | ✅ Yes | ❌ Manual | ✅ Yes |
| Brave Support | ✅ Yes | ⚠️ Outdated | ❌ No |
| Pre-loaded Extensions | ✅ Yes | ❌ No | ❌ No |
| Registry Cleanup | ✅ Yes | ❌ No | ❌ No |
| Zero Maintenance | ✅ Yes | ❌ Manual | ✅ Yes |

## 🔐 Security & Privacy

**Portable Flags:**
- `--user-data-dir=.\Data` - All data in portable folder
- `--no-default-browser-check` - No system integration
- `--disable-logging` - No logs
- `--disable-breakpad` - No crash reports
- `--disable-machine-id` - No machine fingerprinting
- `--disable-encryption-win` - No Windows encryption (for portability)

**⚠️ Important:** Passwords and cookies are NOT encrypted. Store `Data/` folder on encrypted drive for security.

## 🐛 Troubleshooting

### "Brave executable not found"
**Solution:** Run with `-ForceUpdate` flag or wait for automatic download

### Update fails
**Causes:**
- No internet connection
- GitHub API rate limit (60 requests/hour)
- Write permissions issue

**Solution:** Check internet, wait an hour, or run as admin

### Browser doesn't start
**Check:**
1. `Browser/brave.exe` exists
2. Antivirus isn't blocking
3. Run debug version: `BravePortable-DEBUG.exe` (shows console output)

## 📝 Technical Details

**Built with:**
- PowerShell 5.1+ (launcher script)
- ps2exe 0.5.0.33 (EXE compilation)
- Inno Setup 6.6.0 (installer)
- Brave Browser v1.84.139 (bundled)

**Requirements:**
- Windows 7+ (x64)
- PowerShell 5.1+ (built-in)
- 700 MB disk space (with Brave)

**Network:**
- First launch: Downloads Brave (~200 MB) if not included
- Updates: Downloads new version when available
- Extensions: Loaded locally (no download)

## 🙏 Credits

- **Inspired by:** [chrlauncher](https://github.com/henrypp/chrlauncher) by Henry++
- **Portable flags:** [Portapps](https://github.com/portapps/portapps) by @crazy-max
- **Built by:** Custom Agents Pro
- **License:** MIT License

## 📄 License

MIT License - Free to use, modify, and distribute.

See `Documentation/LICENSE` for full text.

## 🔗 Links

- **GitHub Repository:** https://github.com/KeyStrokeVII/BravePortable
- **Report Issues:** https://github.com/KeyStrokeVII/BravePortable/issues
- **Brave Browser:** https://brave.com
- **Bitwarden:** https://bitwarden.com

## 📮 Support

Found a bug? Have a feature request?

1. Check existing issues: https://github.com/KeyStrokeVII/BravePortable/issues
2. Create new issue with:
   - BravePortable version
   - Windows version
   - Steps to reproduce
   - Error messages (if any)

## 🚧 Roadmap

Future improvements being considered:

- [ ] Auto-update for extensions
- [ ] Support for multiple browser profiles
- [ ] Scheduled update tasks
- [ ] Portable Chrome/Chromium support
- [ ] GUI configuration tool
- [ ] Update notifications (toast/system tray)

---

**Thank you for using BravePortable!** 🦁

Stay private, stay updated, stay portable. 🚀
