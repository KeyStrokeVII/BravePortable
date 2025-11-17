# Release Folder - Distribution Checklist

## Current Status: READY FOR GITHUB (Source Distribution)

The Release/ folder is ready for **source distribution** (users download and extract Brave on first launch).

---

## 📦 Two Distribution Modes

### Mode 1: Lightweight Source Distribution (Recommended for GitHub)
**Size**: ~15 MB  
**Contents**:
- BravePortable.exe (launcher)
- config.json (configuration)
- README.txt (user guide)
- Browser/.gitkeep (empty, downloaded on first run)
- Data/.gitkeep (empty, created on first run)
- Extensions/bitwarden.crx (15 MB)

**Advantages**:
✅ Small download size
✅ Always gets latest Brave version
✅ Easy to host on GitHub
✅ Users download Brave from official source

### Mode 2: Full Bundle Distribution
**Size**: ~660 MB  
**Contents**:
- Everything from Mode 1
- Pre-downloaded Brave browser (645 MB)
- Ready to run immediately

**Advantages**:
✅ No internet required for first launch
✅ Faster first startup
✅ Known working version included

**Disadvantages**:
❌ Large file size
❌ May include outdated Brave version
❌ Difficult to host on GitHub (file size limits)

---

## 🎯 Recommended Approach for GitHub

1. **Primary Release**: Mode 1 (Lightweight, ~15 MB)
   - Upload `BravePortable-v1.0.zip` containing clean Release/ folder
   - Users extract and run, Brave downloads automatically

2. **Optional Full Bundle**: Mode 2 (~660 MB)
   - Host on external service (Mega, Google Drive, etc.)
   - Link from GitHub README for users who want offline installation

---

## 🧹 Cleaning Release/ for Lightweight Distribution

To prepare a clean lightweight release:

```powershell
# Navigate to Release folder
cd Release

# Remove downloaded Brave files
Remove-Item Browser\* -Exclude .gitkeep -Recurse -Force

# Remove profile data
Remove-Item Data\* -Exclude .gitkeep -Recurse -Force

# Keep only:
# - BravePortable.exe
# - config.json
# - README.txt
# - Browser\.gitkeep
# - Data\.gitkeep
# - Extensions\bitwarden.crx
# - Extensions\.gitkeep
```

**Result**: Clean ~15 MB folder ready for GitHub

---

## ✅ Pre-Distribution Checklist

Before zipping Release/ folder:

- [ ] Test clean installation (delete Browser/ and Data/ contents)
- [ ] Run BravePortable.exe and verify it downloads Brave
- [ ] Confirm extensions load correctly
- [ ] Test auto-update functionality
- [ ] Verify README.txt is up-to-date
- [ ] Check config.json has sensible defaults
- [ ] Ensure no personal data in Data/ folder
- [ ] Verify file size is appropriate for distribution mode

---

## 📊 File Size Breakdown

| Component | Size | Required? |
|-----------|------|-----------|
| BravePortable.exe | 79 KB | ✅ Yes |
| config.json | <1 KB | ✅ Yes |
| README.txt | 2 KB | ✅ Yes |
| Browser/ (empty) | 0 KB | ✅ Yes (structure) |
| Data/ (empty) | 0 KB | ✅ Yes (structure) |
| Extensions/bitwarden.crx | 15 MB | ⚠️ Optional |
| Brave binaries | 645 MB | ❌ No (downloaded) |

**Lightweight total**: ~15 MB (with Bitwarden)  
**Minimal total**: <1 MB (without extensions)

---

## 🚀 Creating Distribution Archive

### Lightweight Release (Recommended)

```powershell
# Clean Release folder first
cd Release
Remove-Item Browser\* -Exclude .gitkeep -Recurse -Force
Remove-Item Data\* -Exclude .gitkeep -Recurse -Force

# Create archive
cd ..
Compress-Archive -Path Release\* -DestinationPath BravePortable-v1.0-Lightweight.zip -Force
```

### Full Bundle Release

```powershell
# Ensure Brave is downloaded
cd Release
.\BravePortable.exe  # Let it download if needed

# Create archive
cd ..
Compress-Archive -Path Release\* -DestinationPath BravePortable-v1.0-Full.zip -Force
```

---

## 🎁 What Users Get

### After Extracting Lightweight ZIP:
```
BravePortable/
├── BravePortable.exe    # Launch this
├── config.json          
├── README.txt           
├── Browser/             # Empty (downloads on first run)
├── Data/                # Empty (created on first run)
└── Extensions/
    └── bitwarden.crx    # Pre-loaded
```

### After First Launch:
```
BravePortable/
├── BravePortable.exe
├── config.json          
├── README.txt           
├── Browser/             # ✅ Brave v1.84.139 (~645 MB)
│   └── brave.exe
├── Data/                # ✅ User profile created
│   └── Default/
└── Extensions/
    ├── bitwarden/       # ✅ Extracted and loaded
    └── bitwarden.crx
```

---

## 📝 Notes

- The current Release/ folder (661 MB) is from development testing
- It includes a full Brave installation and used profile
- For distribution, create a fresh/clean Release/ folder
- GitHub releases support files up to 2 GB, but smaller is better
- Consider providing both lightweight and full options

---

**Current Release Folder State**: Development (661 MB with Brave + profile)  
**Recommended for GitHub**: Lightweight (15 MB, downloads Brave on first run)  
**Alternative**: Full bundle (661 MB, hosted externally)
