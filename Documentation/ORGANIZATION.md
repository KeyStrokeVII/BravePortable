# BravePortable - Folder Organization

This document explains the reorganized folder structure (v1.0+), which follows a clean separation between source code, build tools, documentation, and distribution files - similar to Mullvad Browser's approach.

## 📁 Folder Structure Overview

```
BravePortable/
├── Build/              # Build scripts and installer configuration
├── Source/             # Source code and assets
├── Documentation/      # Comprehensive documentation
├── Release/            # Clean distribution folder (end-user ready)
├── README.md           # Main project documentation
└── .gitignore          # Git exclusion rules
```

---

## 🔧 Build/ - Build Scripts & Configuration

**Purpose**: Contains all build-related scripts and installer configuration files.

**Contents**:
- `BravePortable-InnoSetup.iss` - Inno Setup script for creating Windows installer
- `Create-BravePortable-SFX.ps1` - PowerShell script to create 7-Zip self-extracting archive
- `7zip-sfx-config.txt` - Configuration for 7-Zip SFX
- `CREATE-SFX.md` - Instructions for building SFX archives

**Usage**:
```powershell
# Build Inno Setup installer
iscc Build\BravePortable-InnoSetup.iss

# Create 7-Zip SFX
.\Build\Create-BravePortable-SFX.ps1
```

---

## 📜 Source/ - Source Code & Assets

**Purpose**: Contains all source code, scripts, and assets needed to build the portable launcher.

**Contents**:
- `BraveLauncher.ps1` - Core launcher script with auto-update logic
- `BraveUpdater.ps1` - Standalone updater utility
- `LaunchBrave.bat` - Batch file wrapper for the launcher
- `CleanupRegistry.ps1` - PowerShell script to remove Brave registry entries
- `CleanupRegistry.reg` - Registry file for quick cleanup
- `Assets/` - Subfolder containing images and icons
  - `brave-icon.ico` - Brave logo icon (512x512)
  - `WizardImage.bmp` - Inno Setup wizard image (164x314 pixels)
  - `WizardSmallImage.bmp` - Inno Setup small logo (55x58 pixels)

**Compiling Launcher**:
```powershell
# Install ps2exe
Install-Module ps2exe

# Compile launcher
Invoke-ps2exe -inputFile Source\BraveLauncher.ps1 `
              -outputFile Release\BravePortable.exe `
              -iconFile Source\Assets\brave-icon.ico `
              -noConsole -noOutput
```

---

## 📚 Documentation/ - Documentation Files

**Purpose**: Comprehensive documentation for users, developers, and contributors.

**Contents**:
- `QUICKSTART.md` - Quick reference guide for common tasks
- `INSTALLATION.md` - Build instructions and distribution options
- `GITHUB-README.md` - GitHub-optimized README with badges and formatting
- `LICENSE` - MIT License text

**Note**: The main `README.md` stays in the root folder for project overview.

---

## ⭐ Release/ - Distribution Folder

**Purpose**: Clean, end-user-ready distribution folder. This mimics Mullvad Browser's clean structure.

**Structure**:
```
Release/
├── BravePortable.exe      # Main launcher executable
├── config.json            # Configuration file
├── README.txt             # User-facing documentation
├── Browser/               # Brave browser files (downloaded on first launch)
│   ├── brave.exe
│   └── version.txt
├── Data/                  # User profile and settings (created on first launch)
│   └── User Data/
└── Extensions/            # Pre-loaded extensions
    └── bitwarden.crx      # Bitwarden password manager (14.6 MB)
```

**Key Features**:
- ✅ Self-contained and portable
- ✅ No development clutter
- ✅ Ready to zip and distribute
- ✅ Clean folder names (Browser, Data, Extensions)
- ✅ Includes README.txt for end users

**Distribution Options**:
1. **Zip Archive**: Compress `Release/` folder → `BravePortable-v1.0.zip`
2. **Inno Setup Installer**: Use `Build\BravePortable-InnoSetup.iss`
3. **7-Zip SFX**: Use `Build\Create-BravePortable-SFX.ps1`

---

## 🔄 Development vs. Distribution

### Development Environment (Root Folder)

During development, the root folder may contain:
- `app/` - Development Brave binaries (ignored by git)
- `profile/` - Development profile data (ignored by git)
- `extensions/` - Development extensions (ignored by git)
- `config.json` - Development configuration
- `BravePortable.exe` - Test launcher

**These are excluded from git via `.gitignore`** and are for testing purposes only.

### Distribution (Release/ Folder)

The `Release/` folder contains ONLY distribution files:
- Clean folder names (`Browser`, `Data`, `Extensions`)
- User-facing `README.txt`
- Compiled launcher executable
- Default configuration
- Pre-loaded extensions (CRX files only, not extracted folders)

---

## 🚀 Building for Distribution

### Step 1: Compile the Launcher

```powershell
# From repository root
Invoke-ps2exe -inputFile Source\BraveLauncher.ps1 `
              -outputFile Release\BravePortable.exe `
              -iconFile Source\Assets\brave-icon.ico `
              -noConsole -noOutput
```

### Step 2: Prepare Configuration

```powershell
# Create default config.json in Release/
Copy-Item config.json Release\ -Force
```

### Step 3: Add Extensions (Optional)

```powershell
# Download CRX files and place in Release/Extensions/
# Example: Bitwarden, uBlock Origin, etc.
```

### Step 4: Test Release Build

```powershell
cd Release
.\BravePortable.exe  # Test first launch
```

### Step 5: Package for Distribution

**Option A: Zip Archive**
```powershell
Compress-Archive -Path Release\* -DestinationPath BravePortable-v1.0.zip
```

**Option B: Inno Setup Installer**
```powershell
iscc Build\BravePortable-InnoSetup.iss
# Output: Output\brave-portable-setup.exe
```

---

## 📋 Git Repository Structure

When pushing to GitHub:

**Included**:
- ✅ `Build/` - Build scripts
- ✅ `Source/` - Source code and assets
- ✅ `Documentation/` - All documentation
- ✅ `Release/BravePortable.exe` - Compiled launcher
- ✅ `Release/README.txt` - User documentation
- ✅ `Release/.gitkeep` files - Preserve folder structure
- ✅ `README.md` - Main project README
- ✅ `LICENSE` - Project license
- ✅ `.gitignore` - Exclusion rules

**Excluded (via .gitignore)**:
- ❌ `app/` - Brave binaries (too large, downloaded on first run)
- ❌ `profile/` - User data (personal information)
- ❌ `extensions/` - Development extensions
- ❌ `Release/Browser/` - Downloaded Brave files
- ❌ `Release/Data/` - User profiles
- ❌ Build outputs (`.exe`, `Output/`)

---

## 🔄 Migration from Old Structure

The reorganization script (`Reorganize.ps1`) handles migration automatically:

```powershell
.\Reorganize.ps1
```

**What it does**:
1. Creates `Build/`, `Source/`, `Documentation/`, `Release/` folders
2. Moves build scripts to `Build/`
3. Moves source files to `Source/`
4. Moves assets to `Source/Assets/`
5. Moves documentation to `Documentation/`
6. Copies necessary files to `Release/`
7. Renames folders: `app/` → `Browser/`, `profile/` → `Data/`
8. Cleans up temporary files

---

## 🎯 Benefits of New Organization

✅ **Cleaner**: No clutter in root folder
✅ **Professional**: Matches industry standards (Mullvad Browser, PortableApps)
✅ **Modular**: Clear separation of concerns
✅ **Git-friendly**: Easy to track changes in organized structure
✅ **User-friendly**: `Release/` folder is ready to distribute
✅ **Developer-friendly**: Build tools and source code logically organized

---

## 📦 Distribution Checklist

Before releasing:

- [ ] Compile latest `BraveLauncher.ps1` to `Release\BravePortable.exe`
- [ ] Update `Release\README.txt` with current version and instructions
- [ ] Test first launch in `Release/` folder
- [ ] Verify extensions load correctly
- [ ] Test auto-update functionality
- [ ] Check `Release/` folder size (should be ~15-20 MB without Browser/)
- [ ] Package as ZIP or build installer
- [ ] Create GitHub release with binaries
- [ ] Update download links in documentation

---

**Last Updated**: November 17, 2025
**Organization Version**: 1.0
