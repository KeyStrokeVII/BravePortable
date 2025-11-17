# 🦁 Brave Portable

> A truly portable Brave browser with automatic updates, pre-loaded extensions, and zero maintenance

[![Version](https://img.shields.io/badge/version-1.0-blue.svg)](https://github.com/yourusername/brave-portable/releases)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Windows-lightgrey.svg)]()

## ✨ Why BravePortable?

| Feature | BravePortable | Portapps | chrlauncher |
|---------|--------------|----------|-------------|
| ✅ Auto-Updates | **Always** | Manual only | Yes |
| 🦁 Brave Support | **Yes** | Outdated (2023) | No |
| 📦 Portable | **Yes** | Yes | Yes |
| 🔧 Pre-loaded Extensions | **Yes** | No | No |
| 🧹 Registry Cleanup | **Yes** | No | No |
| 💾 Professional Installer | **Yes** | Yes | No |

**TL;DR**: Like chrlauncher's auto-updates + Portapps' portability + extension support + actually maintained!

## 🎯 Features

- **🔄 Auto-Updates**: Always runs the latest Brave version from GitHub releases
- **📦 Fully Portable**: All data in one folder, no registry traces
- **🔌 Extension Support**: Pre-load extensions (Bitwarden included)
- **🛡️ Privacy-First**: Same portable flags as Portapps
- **🧹 Registry Cleanup**: Tools to remove all Windows traces
- **⚙️ Configurable**: Custom update schedules, auto-download settings
- **💻 Professional**: Single-EXE installer with custom branding

## 📥 Download

### For End Users

**[Download Installer](https://github.com/yourusername/brave-portable/releases/latest)** (163 MB)

`brave-portable-setup.exe` includes:
- Brave browser (latest version)
- Bitwarden password manager
- Registry cleanup tools
- All configuration files

### For Developers

Clone and build from source:
```powershell
git clone https://github.com/yourusername/brave-portable.git
cd brave-portable
# See INSTALLATION.md for build instructions
```

## 🚀 Quick Start

### Installation

1. **Download** `brave-portable-setup.exe`
2. **Run installer** and choose installation directory
3. **Launch** from Start Menu or desktop shortcut

### Usage

**Simple**: Double-click `BravePortable.exe`

**Advanced**:
```powershell
# Force update check
.\BraveLauncher.ps1 -ForceUpdate

# Launch without checking for updates
.\BraveLauncher.ps1 -SkipUpdate

# Update only (don't launch browser)
.\BraveLauncher.ps1 -UpdateOnly
```

See [QUICKSTART.md](QUICKSTART.md) for more.

## 📖 Documentation

- **[README.md](README.md)** - Complete documentation
- **[QUICKSTART.md](QUICKSTART.md)** - Quick reference
- **[INSTALLATION.md](INSTALLATION.md)** - Build & distribution guide
- **[CREATE-SFX.md](CREATE-SFX.md)** - Alternative packaging methods

## 🔌 Extension Management

### Included Extensions

- **Bitwarden** (v2025.11.0) - Password manager

### Adding More Extensions

1. Get extension ID from Chrome Web Store URL
2. Download CRX:
   ```powershell
   $extId = "extension-id-here"
   $url = "https://clients2.google.com/service/update2/crx?response=redirect&prodversion=110.0&acceptformat=crx2,crx3&x=id%3D${extId}%26uc"
   Invoke-WebRequest -Uri $url -OutFile "extensions\extension-name.crx"
   ```
3. Rebuild installer or redistribute `extensions/` folder

See [INSTALLATION.md](INSTALLATION.md) for detailed instructions.

## 🧹 Registry Cleanup

Brave leaves traces in Windows Registry even in portable mode. Two cleanup options:

**Quick** (instant, no output):
```
Double-click CleanupRegistry.reg
```

**Detailed** (shows what's cleaned):
```powershell
powershell.exe -ExecutionPolicy Bypass -File .\CleanupRegistry.ps1
```

Run as Administrator for complete HKEY_LOCAL_MACHINE cleanup.

## ⚙️ Configuration

Edit `config.json`:

```json
{
  "UpdateCheckDays": 1,    // Check for updates daily (0=never, -1=always)
  "AutoDownload": true     // Auto-install updates (false=notify only)
}
```

## 🛠️ Building from Source

### Requirements

- Windows 10/11
- PowerShell 5.1+
- [ps2exe](https://github.com/MScholtes/PS2EXE) (PowerShell to EXE compiler)
- [Inno Setup 6.6.0+](https://jrsoftware.org/isdl.php) (optional, for installer)

### Build Steps

```powershell
# Install ps2exe
Install-Module ps2exe -Scope CurrentUser

# Compile launcher
ps2exe BraveLauncher.ps1 BravePortable.exe -iconFile brave-icon.ico -noConsole -noOutput

# Build installer (optional)
& "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" BravePortable-InnoSetup.iss
```

See [INSTALLATION.md](INSTALLATION.md) for complete build guide.

## 📁 Directory Structure

```
BravePortable/
├── BravePortable.exe          # Main launcher
├── BraveLauncher.ps1          # Source script
├── BraveUpdater.ps1           # Background updater
├── config.json                # Settings
├── CleanupRegistry.ps1        # Registry cleanup (detailed)
├── CleanupRegistry.reg        # Registry cleanup (quick)
├── extensions/                # Pre-loaded extensions
│   └── bitwarden.crx
├── app/                       # Brave binaries (auto-downloaded)
└── profile/                   # Your browser data (auto-created)
```

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Test your changes
4. Submit a pull request

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📜 License

MIT License - see [LICENSE](LICENSE) for details.

Free to use, modify, and distribute with attribution.

## 🙏 Credits

- Inspired by [chrlauncher](https://github.com/henrypp/chrlauncher) by Henry++
- Portable flags from [Portapps](https://github.com/portapps/portapps) by @crazy-max
- Built by [Your Name/Organization]

## 🐛 Issues & Support

- **Bug Reports**: [GitHub Issues](https://github.com/yourusername/brave-portable/issues)
- **Documentation**: See `README.md` and `QUICKSTART.md`
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/brave-portable/discussions)

## 🗺️ Roadmap

- [ ] Firefox Portable variant
- [ ] Ungoogled Chromium Portable variant
- [ ] Extension marketplace integration
- [ ] Automated GitHub Actions builds
- [ ] Multi-language support

## ⭐ Star History

If this project helped you, please ⭐ star the repository!

---

**Version 1.0** | Built 2025-11-17 | [Download Latest Release](https://github.com/yourusername/brave-portable/releases/latest)
