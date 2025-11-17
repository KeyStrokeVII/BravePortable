# BravePortable

A truly portable Brave browser that stays up-to-date automatically. No installation required, no registry traces, complete portability.

## ✨ Key Features

- 🚀 **Always Up-to-Date**: Automatically downloads latest Brave releases
- 💼 **100% Portable**: All data in one folder, works on USB drives
- 🔐 **Bitwarden Pre-installed**: Password manager ready to use out of the box
- 🔄 **Auto-Updates**: Keeps browser updated (checks every 2 days)
- 🧹 **Registry Cleanup**: Included tools remove all Brave traces from Windows
- 🎯 **Zero Setup**: Extract and run, or use the installer for one-click setup

## 📦 Download & Install

### Method 1: Installer (Recommended)

**[Download brave-portable-setup.exe](https://github.com/KeyStrokeVII/BravePortable/releases/latest)** (155 MB)

1. Run the installer
2. Choose installation folder (C:\BravePortable or USB drive)
3. Launch `BravePortable.exe`
4. **Brave opens instantly** with Bitwarden already installed!

✅ **Includes:** Brave v1.84.139 + Bitwarden extension  
⏱️ **Install time:** 10-15 seconds  
🌐 **Internet:** Not required after download

### Method 2: Portable ZIP

**[Download Release folder as ZIP](https://github.com/KeyStrokeVII/BravePortable/releases/latest)**

1. Extract to any location
2. Double-click `BravePortable.exe`
3. First launch downloads Brave (~200 MB)
4. Bitwarden extension loads automatically

⏱️ **First launch:** 2-3 minutes  
🌐 **Internet:** Required once for initial download

## 🚀 Quick Start

1. **Launch:** Double-click `BravePortable.exe`
2. **Bitwarden:** Already installed and ready to use
3. **Updates:** Automatically checks every 2 days
4. **Data:** Everything saved in `Data/` folder

### Command-Line Options

```powershell
BravePortable.exe -ForceUpdate    # Force update check now
BravePortable.exe -SkipUpdate     # Skip update check, launch immediately
BravePortable.exe -UpdateOnly     # Update without launching browser
```

## ⚙️ Configuration

Edit `config.json` to customize:

```json
{
  "UpdateCheckDays": 2,     // Check every 2 days (0=disable, -1=always)
  "AutoDownload": true      // Auto-download updates
}
```

## 🔐 Bitwarden Password Manager

**Pre-installed and ready to use!**

- **Version:** v2025.11.0
- **What it does:** Securely stores passwords, credit cards, notes
- **Setup:** Open Bitwarden icon in browser, login or create account
- **Portable:** All vault data stored in your portable `Data/` folder

### Adding More Extensions

1. Get extension from Chrome Web Store
2. Download CRX file (see Documentation/QUICKSTART.md for details)
3. Place in `Extensions/` folder
4. Restart browser to load

## 🧹 Registry Cleanup

Brave leaves traces in Windows Registry even in portable mode. We've included cleanup tools:

**Quick cleanup:** Double-click `CleanupRegistry.reg` (in Tools/ folder)  
**Detailed cleanup:** Run `CleanupRegistry.ps1` to see what's removed

💡 **Run as Administrator** for complete cleanup

**What gets cleaned:**
- User settings (`HKCU:\Software\BraveSoftware`)
- Browser registration
- File associations
- Startup entries

## ❓ Troubleshooting

**"Brave executable not found"**
```powershell
BravePortable.exe -ForceUpdate
```

**Update fails**
- Check internet connection
- Verify write permissions
- GitHub allows 60 requests/hour (wait if exceeded)

**Browser won't start**
- Check `Browser/brave.exe` exists
- Check antivirus settings
- Try running: `Browser\brave.exe --user-data-dir=.\Data`

## 📂 What's Inside

```
BravePortable/
├── BravePortable.exe          # Launcher (79 KB)
├── config.json                # Settings
├── Browser/                   # Brave browser (~645 MB)
├── Data/                      # Your profile & bookmarks
├── Extensions/                # Pre-installed extensions
│   └── bitwarden.crx          # Bitwarden v2025.11.0
└── Tools/                     # Registry cleanup scripts
```

## 🔒 Privacy & Security

**Portable flags applied:**
- No machine ID tracking
- No crash reporting
- No default browser checks
- All data in portable folder

⚠️ **Important:** Passwords and cookies are NOT encrypted by Windows. Store your `Data/` folder on an encrypted drive for maximum security.

## 📊 Why BravePortable?

| Feature | BravePortable | Portapps | Regular Install |
|---------|--------------|----------|-----------------|
| Auto-Updates | ✅ | ❌ | ✅ |
| 100% Portable | ✅ | ✅ | ❌ |
| Always Latest | ✅ | ❌ | ✅ |
| Bitwarden Included | ✅ | ❌ | ❌ |
| Registry Cleanup | ✅ | ❌ | ❌ |
| Zero Maintenance | ✅ | ❌ | ✅ |

## 📝 License & Credits

**License:** MIT - Free to use, modify, and distribute

**Inspired by:**
- [chrlauncher](https://github.com/henrypp/chrlauncher) by Henry++
- [Portapps](https://github.com/portapps/portapps) by @crazy-max

**Built by:** Custom Agents Pro

---

**Questions or issues?** → [GitHub Issues](https://github.com/KeyStrokeVII/BravePortable/issues)

**Full documentation** → See `Documentation/` folder for advanced usage
