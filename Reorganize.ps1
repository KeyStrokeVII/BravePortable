# Reorganize BravePortable folder structure
# Makes it clean and professional like Mullvad Browser

$rootPath = $PSScriptRoot

Write-Host "Reorganizing BravePortable folder structure..." -ForegroundColor Cyan

# Move build-related files to Build/
Write-Host "`nMoving build files to Build/..." -ForegroundColor Yellow
$buildFiles = @(
    "BravePortable-InnoSetup.iss",
    "Create-BravePortable-SFX.ps1",
    "7zip-sfx-config.txt",
    "CREATE-SFX.md"
)
foreach ($file in $buildFiles) {
    if (Test-Path "$rootPath\$file") {
        Move-Item "$rootPath\$file" "$rootPath\Build\" -Force
        Write-Host "  ✓ $file"
    }
}

# Move source files to Source/
Write-Host "`nMoving source files to Source/..." -ForegroundColor Yellow
$sourceFiles = @(
    "BraveLauncher.ps1",
    "BraveUpdater.ps1",
    "LaunchBrave.bat",
    "CleanupRegistry.ps1",
    "CleanupRegistry.reg"
)
foreach ($file in $sourceFiles) {
    if (Test-Path "$rootPath\$file") {
        Move-Item "$rootPath\$file" "$rootPath\Source\" -Force
        Write-Host "  ✓ $file"
    }
}

# Move assets to Source/Assets/
Write-Host "`nMoving assets to Source/Assets/..." -ForegroundColor Yellow
$assetFiles = @(
    "brave-icon.ico",
    "WizardImage.bmp",
    "WizardSmallImage.bmp",
    "temp.svg"
)
foreach ($file in $assetFiles) {
    if (Test-Path "$rootPath\$file") {
        Move-Item "$rootPath\$file" "$rootPath\Source\Assets\" -Force
        Write-Host "  ✓ $file"
    }
}

# Move documentation to Documentation/
Write-Host "`nMoving documentation to Documentation/..." -ForegroundColor Yellow
$docFiles = @(
    "QUICKSTART.md",
    "INSTALLATION.md",
    "GITHUB-README.md",
    "LICENSE"
)
foreach ($file in $docFiles) {
    if (Test-Path "$rootPath\$file") {
        Move-Item "$rootPath\$file" "$rootPath\Documentation\" -Force
        Write-Host "  ✓ $file"
    }
}

# Setup Release structure (mimicking Mullvad)
Write-Host "`nSetting up Release structure..." -ForegroundColor Yellow

# Copy executable to Release/
if (Test-Path "$rootPath\BravePortable.exe") {
    Copy-Item "$rootPath\BravePortable.exe" "$rootPath\Release\" -Force
    Write-Host "  ✓ BravePortable.exe → Release/"
}

# Copy config.json to Release/
if (Test-Path "$rootPath\config.json") {
    Copy-Item "$rootPath\config.json" "$rootPath\Release\" -Force
    Write-Host "  ✓ config.json → Release/"
}

# Rename app/ to Browser/ in Release
if (Test-Path "$rootPath\app") {
    if (Test-Path "$rootPath\Release\Browser") {
        Remove-Item "$rootPath\Release\Browser" -Recurse -Force
    }
    Copy-Item "$rootPath\app" "$rootPath\Release\Browser" -Recurse -Force
    Write-Host "  ✓ app/ → Release/Browser/"
}

# Rename profile/ to Data/ in Release
if (Test-Path "$rootPath\profile") {
    if (Test-Path "$rootPath\Release\Data") {
        Remove-Item "$rootPath\Release\Data" -Recurse -Force
    }
    Copy-Item "$rootPath\profile" "$rootPath\Release\Data" -Recurse -Force
    Write-Host "  ✓ profile/ → Release/Data/"

    # Create .gitkeep for Inno Setup
    if (-not (Test-Path "$rootPath\Release\Data\.gitkeep")) {
        New-Item -Path "$rootPath\Release\Data\.gitkeep" -ItemType File -Force | Out-Null
        Write-Host "  ✓ Created .gitkeep in Release/Data/"
    }
}

# Copy extensions/ to Release/Extensions/
if (Test-Path "$rootPath\extensions") {
    if (Test-Path "$rootPath\Release\Extensions") {
        Remove-Item "$rootPath\Release\Extensions" -Recurse -Force
    }
    Copy-Item "$rootPath\extensions" "$rootPath\Release\Extensions" -Recurse -Force
    Write-Host "  ✓ extensions/ → Release/Extensions/"
}

# Clean up temp directory
if (Test-Path "$rootPath\temp") {
    Remove-Item "$rootPath\temp" -Recurse -Force
    Write-Host "  ✓ Removed temp/"
}

Write-Host "`n[SUCCESS] Reorganization complete!" -ForegroundColor Green
Write-Host "`nNew structure:" -ForegroundColor Cyan
Write-Host "  BravePortable/"
Write-Host "    Build/              (Inno Setup, SFX scripts)"
Write-Host "    Source/             (PowerShell scripts, cleanup tools)"
Write-Host "      Assets/           (Icons, wizard images)"
Write-Host "    Documentation/      (All docs except README.md)"
Write-Host "    Release/            (Clean distribution - like Mullvad)"
Write-Host "      Browser/          (Brave browser files)"
Write-Host "      Data/             (User profile data)"
Write-Host "      Extensions/       (Pre-loaded extensions)"
Write-Host "      BravePortable.exe"
Write-Host "      config.json"
Write-Host "    README.md"

Write-Host "`nThe Release/ folder is now distribution-ready!" -ForegroundColor Green
Write-Host "You can zip Release/ for users or use it for the installer." -ForegroundColor Yellow
