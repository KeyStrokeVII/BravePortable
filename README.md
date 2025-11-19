# 🦁 Brave Portable

**A truly portable Brave browser that stays up-to-date automatically.**
No installation required, no registry traces, complete portability.

> ⚠️ **Platform:** Windows 7 or later (64-bit)

## ✨ Key Features

- 🚀 **Always Up-to-Date**: Automatically downloads the latest Brave releases.
- 💼 **100% Portable**: All data stays in one folder. Perfect for USB drives.
- 🔐 **Bitwarden Included**: Password manager pre-installed and ready.
- 🔄 **Silent Updates**: Updates happen in the background with a tray notification.
- 🧹 **Zero Traces**: Includes tools to clean up registry entries.

## 📥 Download

**[Download Latest Installer (163 MB)](https://github.com/KeyStrokeVII/BravePortable/releases/latest)**

1. Run `brave-portable-setup.exe`.
2. Install to any folder (e.g., `C:\BravePortable` or your USB drive).
3. Launch `BravePortable.exe`.

*Prefer a ZIP? [Download the Release folder](https://github.com/KeyStrokeVII/BravePortable/releases/latest).*

## 🚀 Quick Start

Just double-click **`BravePortable.exe`**.

- **First Run:** It will download the latest Brave browser (~200 MB).
- **Updates:** Checks automatically every 2 days.
- **Data:** All your bookmarks, passwords, and extensions are saved in the `Data` folder.

## ⚙️ Configuration

You can customize behavior in `config.json`:

```json
{
  "UpdateCheckDays": 2,     // How often to check for updates (days)
  "AutoDownload": true      // Automatically download updates
}
```

## 🧹 Registry Cleanup

To ensure zero traces on the host machine, run the cleanup tools in the `Tools` folder:
- **`CleanupRegistry.reg`**: Quick cleanup.
- **`CleanupRegistry.ps1`**: Detailed cleanup (run as Administrator).

---

**[View Full Documentation](Documentation/)** | **[Report an Issue](https://github.com/KeyStrokeVII/BravePortable/issues)**

**License:** MIT
