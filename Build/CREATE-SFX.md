# Creating Single-EXE Portable Installers

This guide explains how to package BravePortable into a single `.exe` file like Portapps and Mullvad Browser.

---

## 🎯 Two Methods Available

### Method 1: Inno Setup (Portapps Style)
**Best for:** Professional-looking installers with dialogs and customization

### Method 2: 7-Zip SFX (Mullvad Browser Style)  
**Best for:** Simple, lightweight, no-frills extraction

---

## 📦 Method 1: Inno Setup (Recommended)

### What You Get
- `brave-portable-win64-1.84.139-setup.exe` (~200MB)
- Professional extraction wizard with dialogs
- Choose installation folder
- Optional desktop shortcut
- Like official Portapps releases

### Setup Steps

1. **Download Inno Setup**
   ```
   https://jrsoftware.org/isdl.php
   Download: innosetup-6.x.x.exe (free, ~5MB)
   Install to: C:\Program Files (x86)\Inno Setup 6\
   ```

2. **Extract Icon from Brave**
   ```powershell
   # Run this if Brave is downloaded
   cd "C:\Users\CXLVII\Documents\Custom Agents Pro\BravePortable"
   Add-Type -AssemblyName System.Drawing
   $icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$PWD\app\brave.exe")
   $stream = [System.IO.File]::Create("$PWD\brave-icon.ico")
   $icon.Save($stream)
   $stream.Close()
   Write-Host "✓ Icon extracted: brave-icon.ico"
   ```

3. **Compile the Installer**
   ```powershell
   # Right-click BravePortable-InnoSetup.iss → Compile
   # Or command line:
   & "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" "BravePortable-InnoSetup.iss"
   ```

4. **Result**
   ```
   Output: brave-portable-win64-1.84.139-setup.exe
   Size: ~200MB (compressed with LZMA2)
   When run: Shows extraction wizard, installs to chosen folder
   ```

### Distribution
```
Just share: brave-portable-win64-1.84.139-setup.exe
Users double-click → Choose folder → Done!
```

---

## 🗜️ Method 2: 7-Zip SFX (Simpler)

### What You Get
- `brave-portable-win64.exe` (~250MB)
- Simple extraction prompt
- Auto-extracts to current folder
- Launches immediately after extraction
- Like Mullvad Browser releases

### Setup Steps

1. **Install 7-Zip**
   ```
   https://www.7-zip.org/download.html
   Download: 7z2409-x64.exe (free, ~1.5MB)
   Install to: C:\Program Files\7-Zip\
   ```

2. **Create 7z Archive**
   ```powershell
   cd "C:\Users\CXLVII\Documents\Custom Agents Pro"
   & "C:\Program Files\7-Zip\7z.exe" a -t7z -mx=9 -mfb=64 -md=32m -ms=on BravePortable.7z BravePortable\*
   ```
   
   Compression options:
   - `-mx=9` = Ultra compression
   - `-mfb=64` = Fast bytes 64
   - `-md=32m` = Dictionary 32MB
   - `-ms=on` = Solid archive (better compression)

3. **Copy SFX Module**
   ```powershell
   # Copy the 7-Zip SFX module
   Copy-Item "C:\Program Files\7-Zip\7zSD.sfx" -Destination ".\7zSD.sfx"
   ```

4. **Combine into Single EXE**
   ```powershell
   # Merge: SFX module + config + archive = executable
   cmd /c copy /b 7zSD.sfx + BravePortable\7zip-sfx-config.txt + BravePortable.7z brave-portable-win64.exe
   ```

5. **Cleanup**
   ```powershell
   Remove-Item BravePortable.7z, 7zSD.sfx
   ```

6. **Result**
   ```
   Output: brave-portable-win64.exe
   Size: ~250MB (less compression than Inno Setup)
   When run: Asks "Extract to current folder?" → Extracts → Auto-launches
   ```

### Distribution
```
Just share: brave-portable-win64.exe
Users double-click → Confirm extraction → Brave launches!
```

---

## 🔄 Complete Automated Script (7-Zip SFX)

Save as `Create-BravePortable-SFX.ps1`:

```powershell
# Automated 7-Zip SFX Creator for BravePortable
param(
    [string]$Version = "1.84.139",
    [string]$SevenZipPath = "C:\Program Files\7-Zip\7z.exe",
    [string]$SfxModule = "C:\Program Files\7-Zip\7zSD.sfx"
)

$ErrorActionPreference = "Stop"
$WorkDir = "C:\Users\CXLVII\Documents\Custom Agents Pro"
$OutputName = "brave-portable-win64-$Version.exe"

Write-Host "`n🔨 Creating BravePortable SFX..." -ForegroundColor Cyan

# Step 1: Verify 7-Zip exists
if (-not (Test-Path $SevenZipPath)) {
    Write-Host "❌ 7-Zip not found at: $SevenZipPath" -ForegroundColor Red
    Write-Host "   Download from: https://www.7-zip.org/download.html" -ForegroundColor Yellow
    exit 1
}

# Step 2: Create 7z archive
Set-Location $WorkDir
Write-Host "`n📦 Compressing BravePortable folder..." -ForegroundColor Yellow
& $SevenZipPath a -t7z -mx=9 -mfb=64 -md=32m -ms=on BravePortable.7z BravePortable\*
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Compression failed!" -ForegroundColor Red
    exit 1
}

# Step 3: Copy SFX module
Write-Host "`n📋 Copying SFX module..." -ForegroundColor Yellow
Copy-Item $SfxModule -Destination ".\7zSD.sfx" -Force

# Step 4: Combine into executable
Write-Host "`n⚡ Creating self-extracting executable..." -ForegroundColor Yellow
cmd /c copy /b 7zSD.sfx + BravePortable\7zip-sfx-config.txt + BravePortable.7z $OutputName

# Step 5: Cleanup
Write-Host "`n🧹 Cleaning up temporary files..." -ForegroundColor Yellow
Remove-Item BravePortable.7z, 7zSD.sfx -ErrorAction SilentlyContinue

# Step 6: Verify output
if (Test-Path $OutputName) {
    $size = (Get-Item $OutputName).Length / 1MB
    Write-Host "`n✅ SUCCESS!" -ForegroundColor Green
    Write-Host "   Output: $OutputName" -ForegroundColor Cyan
    Write-Host "   Size: $([Math]::Round($size, 2)) MB" -ForegroundColor Cyan
    Write-Host "`n📤 Ready to distribute!" -ForegroundColor Green
} else {
    Write-Host "`n❌ Failed to create SFX!" -ForegroundColor Red
    exit 1
}
```

Run with:
```powershell
.\Create-BravePortable-SFX.ps1
```

---

## 🆚 Comparison

| Feature | Inno Setup | 7-Zip SFX |
|---------|-----------|-----------|
| **File Size** | Smaller (~200MB) | Larger (~250MB) |
| **Compression** | LZMA2 Ultra | 7z Ultra |
| **UI** | Professional wizard | Simple dialog |
| **Customization** | High (icons, dialogs) | Low (text only) |
| **Complexity** | Medium | Easy |
| **Like** | Portapps | Mullvad Browser |
| **Best For** | Distribution to users | Quick sharing |

---

## 💡 Portapps Actual Structure

Portapps does something more complex:

```
brave-portable-win64-1.80.115-setup.exe (Inno Setup installer)
  └─ Extracts to: C:\portapps\brave-portable\
       ├─ brave-portable.exe (Go wrapper, 5MB)
       │    └─ Reads config, manages updates, launches Chrome
       ├─ brave-portable.yml (Configuration)
       ├─ app\ (Brave binaries, ~350MB)
       └─ data\ (Profile data)
```

Our BravePortable is **simpler and better**:
- ✅ No Go wrapper needed (native PowerShell)
- ✅ Auto-updates built-in (Portapps disables updates)
- ✅ Single self-contained EXE launcher
- ✅ Cleaner structure

---

## 🎁 Ready-Made Commands

### Quick 7-Zip SFX Creation
```powershell
# One-liner to create brave-portable-win64.exe
cd "C:\Users\CXLVII\Documents\Custom Agents Pro"; `
& "C:\Program Files\7-Zip\7z.exe" a -t7z -mx=9 BravePortable.7z BravePortable\*; `
Copy-Item "C:\Program Files\7-Zip\7zSD.sfx" .; `
cmd /c copy /b 7zSD.sfx + BravePortable\7zip-sfx-config.txt + BravePortable.7z brave-portable-win64.exe; `
Remove-Item BravePortable.7z, 7zSD.sfx; `
Write-Host "✅ Created: brave-portable-win64.exe"
```

### Test the SFX
```powershell
# Extract to temp folder and test
mkdir C:\Temp\BraveTest
cd C:\Temp\BraveTest
& "C:\Users\CXLVII\Documents\Custom Agents Pro\brave-portable-win64.exe"
```

---

## 🚀 Next Steps

1. **Choose your method** (Inno Setup for distribution, 7-Zip SFX for quick sharing)
2. **Run the creation script** (see examples above)
3. **Test the EXE** on a clean system
4. **Share** with others!

Your portable browser is now a single-file download, just like Portapps and Mullvad Browser! 🎉
