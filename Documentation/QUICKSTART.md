# 🚀 Brave Portable - Quick Reference

## 📂 What You Got

```
BravePortable/
├── BravePortable.exe       ⭐ DOUBLE-CLICK THIS TO START
├── LaunchBrave.bat         Alternative launcher (batch file)
├── BraveLauncher.ps1       Main launcher (PowerShell)
├── BraveUpdater.ps1        Background updater
├── config.json             Settings
└── README.md               Full documentation
```

## ⚡ Quick Start

1. **First Time**: Double-click `BravePortable.exe`
   - Downloads latest Brave (v1.84.139 as of Nov 2025)
   - Extracts to `app/` folder
   - Creates `profile/` for your data
   - Launches browser

2. **Every Time After**: Just double-click `BravePortable.exe`
   - Checks for updates every 2 days
   - Auto-downloads if new version available
   - Launches Brave

## 🎯 How It Works

### Like chrlauncher ✅
- Checks GitHub API for latest release
- Auto-downloads and installs updates
- Always stays current

### Like Portapps ✅
- Clean portable structure
- Same privacy flags
- Profile stored locally

### Better than both 🎉
- Works for Brave (chrlauncher doesn't)
- Always updated (Portapps isn't)
- Zero maintenance required

## ⚙️ Configuration

Edit `config.json`:

```json
{
  "UpdateCheckDays": 2,     // How often to check (0 = never, -1 = always)
  "AutoDownload": true      // Auto-install updates (false = notify only)
}
```

## 🔧 Advanced Usage

### PowerShell Commands

```powershell
# Force update now
.\BraveLauncher.ps1 -ForceUpdate

# Skip update check (fast launch)
.\BraveLauncher.ps1 -SkipUpdate

# Update without launching
.\BraveLauncher.ps1 -UpdateOnly
```

### Scheduled Updates

Create daily auto-update at 9 AM:

```powershell
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -File `"$PWD\BraveUpdater.ps1`" -Silent"
$trigger = New-ScheduledTaskTrigger -Daily -At 9am
Register-ScheduledTask -TaskName "Brave Portable Update" -Action $action -Trigger $trigger
```

## 🔒 Security Note

**Passwords are NOT encrypted** (required for portability).
Store the entire `BravePortable` folder on an encrypted drive if needed.

## 📊 Comparison

| Feature           | BravePortable | Portapps | chrlauncher |
|-------------------|---------------|----------|-------------|
| ✅ Auto-updates   | YES           | NO       | YES         |
| ✅ Brave support  | YES           | Outdated | NO          |
| ✅ Portable       | YES           | YES      | YES         |
| ✅ Up-to-date     | Always        | Months old | Always   |

## 🆘 Troubleshooting

**"Brave not found"**
```powershell
.\BraveLauncher.ps1 -ForceUpdate
```

**Update failed**
- Check internet connection
- Run as Administrator if needed
- Check antivirus isn't blocking

**Want to move it?**
- Copy entire `BravePortable` folder anywhere
- All data moves with it
- No registry entries, no traces

## 🎁 Next Steps

Want launchers for **Firefox** or **Ungoogled Chromium**?
Same system can be built for any browser!

---

**Version 1.0** | Built 2025-11-17 | Enjoy your always-updated portable Brave! 🎉
