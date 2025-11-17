# BravePortable - Quick Reference Card

## 📁 Where Is Everything?

| What You Need | Location |
|---------------|----------|
| **Run the app** | `Release\BravePortable.exe` |
| **Edit launcher code** | `Source\BraveLauncher.ps1` |
| **Build installer** | `Build\BravePortable-InnoSetup.iss` |
| **Read documentation** | `Documentation\` folder |
| **Distribute to users** | Zip the `Release\` folder |
| **Add extensions** | `Release\Extensions\*.crx` |
| **Project README** | `README.md` (root) |

---

## 🚀 Common Tasks

### Run BravePortable
```powershell
cd Release
.\BravePortable.exe
```

### Build Launcher
```powershell
Invoke-ps2exe -inputFile Source\BraveLauncher.ps1 `
              -outputFile Release\BravePortable.exe `
              -iconFile Source\Assets\brave-icon.ico `
              -noConsole -noOutput
```

### Build Installer
```powershell
iscc Build\BravePortable-InnoSetup.iss
```

### Create Distribution ZIP
```powershell
Compress-Archive -Path Release\* -DestinationPath BravePortable-v1.0.zip
```

### Clean Release for Distribution
```powershell
cd Release
Remove-Item Browser\* -Exclude .gitkeep -Recurse -Force
Remove-Item Data\* -Exclude .gitkeep -Recurse -Force
```

### Add Extension
```powershell
# Download CRX file, then:
Copy-Item extension.crx Release\Extensions\
```

---

## 📂 Folder Structure (Quick View)

```
BravePortable/
├── Build/           - Inno Setup, 7-Zip SFX scripts
├── Source/          - PowerShell scripts + Assets/
├── Documentation/   - Comprehensive docs
├── Release/         - Distribution folder ⭐
│   ├── BravePortable.exe
│   ├── Browser/
│   ├── Data/
│   └── Extensions/
├── README.md
└── .gitignore
```

---

## 📚 Documentation Files

| File | Purpose |
|------|---------|
| `README.md` (root) | Main project overview |
| `QUICKSTART.md` | Quick reference guide |
| `INSTALLATION.md` | Build instructions |
| `ORGANIZATION.md` | Folder structure details |
| `REORGANIZATION-SUMMARY.md` | Before/after comparison |
| `RELEASE-DISTRIBUTION.md` | Distribution options |
| `GITHUB-README.md` | GitHub-optimized README |

---

## 🎯 What Goes Where?

| File Type | Goes In | Example |
|-----------|---------|---------|
| PowerShell scripts | `Source/` | BraveLauncher.ps1 |
| Icons & images | `Source/Assets/` | brave-icon.ico |
| Installer scripts | `Build/` | BravePortable-InnoSetup.iss |
| Documentation | `Documentation/` | QUICKSTART.md |
| Distribution files | `Release/` | BravePortable.exe |
| Extensions | `Release/Extensions/` | bitwarden.crx |

---

## ✅ Distribution Checklist

Before publishing:

- [ ] Compile latest launcher → `Release\BravePortable.exe`
- [ ] Test clean installation in `Release/`
- [ ] Update `Release\README.txt` with version info
- [ ] Clean Browser/ and Data/ for lightweight distribution
- [ ] Zip `Release/` folder
- [ ] Test extracted ZIP
- [ ] Create GitHub release
- [ ] Update download links in docs

---

## 🔧 Development Workflow

1. **Edit code**: Modify `Source\BraveLauncher.ps1`
2. **Compile**: Run ps2exe to create `Release\BravePortable.exe`
3. **Test**: Run from `Release/` folder
4. **Document**: Update relevant files in `Documentation/`
5. **Build**: Create installer from `Build/` scripts
6. **Distribute**: Zip `Release/` folder

---

## 📦 Distribution Sizes

| Mode | Size | Contents |
|------|------|----------|
| Minimal | <1 MB | No extensions |
| Lightweight | ~15 MB | With Bitwarden |
| Full Bundle | ~660 MB | With Brave included |
| Installer | ~165 MB | Inno Setup EXE |

---

## 🌐 GitHub Repository Structure

**What to commit**:
✅ `Build/`, `Source/`, `Documentation/`, `README.md`, `.gitignore`
✅ `Release/BravePortable.exe`, `Release/README.txt`
✅ `Release/.gitkeep` files
✅ `Release/Extensions/*.crx`

**What to ignore** (via .gitignore):
❌ `app/`, `profile/`, `extensions/` (dev folders)
❌ `Release/Browser/`, `Release/Data/` (downloaded/generated)
❌ Build outputs (`.exe` files, except committed ones)

---

## 💡 Pro Tips

1. **Development**: Use root-level `app/` and `profile/` for testing
2. **Distribution**: Always test from clean `Release/` folder
3. **Lightweight**: Remove `Release/Browser/` and `Release/Data/` before zipping
4. **Full bundle**: Include Brave for offline installation
5. **Extensions**: Add `.crx` files, not extracted folders
6. **Updates**: Launcher auto-updates Brave from GitHub

---

**Version**: 1.0  
**Last Updated**: November 17, 2025  
**Structure**: Reorganized (Mullvad-style)
