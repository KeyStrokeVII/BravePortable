# Automated 7-Zip SFX Creator for BravePortable
# Creates single-EXE portable installer like Mullvad Browser
param(
    [string]$Version = "1.84.139",
    [string]$SevenZipPath = "C:\Program Files\7-Zip\7z.exe",
    [string]$SfxModule = "C:\Program Files\7-Zip\7zSD.sfx"
)

$ErrorActionPreference = "Stop"
$WorkDir = "C:\Users\CXLVII\Documents\Custom Agents Pro"
$OutputName = "brave-portable-win64-$Version.exe"

Write-Host "`n=====================================" -ForegroundColor Cyan
Write-Host "  BravePortable SFX Creator" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

# Step 1: Verify 7-Zip exists
Write-Host "`n[1/6] Checking 7-Zip installation..." -ForegroundColor Yellow
if (-not (Test-Path $SevenZipPath)) {
    Write-Host "❌ 7-Zip not found at: $SevenZipPath" -ForegroundColor Red
    Write-Host "`n   Download from: https://www.7-zip.org/download.html" -ForegroundColor Yellow
    Write-Host "   Install to default location and try again.`n" -ForegroundColor Yellow
    exit 1
}
Write-Host "   ✓ 7-Zip found" -ForegroundColor Green

# Step 2: Verify BravePortable folder exists
Write-Host "`n[2/6] Checking BravePortable folder..." -ForegroundColor Yellow
Set-Location $WorkDir
if (-not (Test-Path "BravePortable")) {
    Write-Host "❌ BravePortable folder not found!" -ForegroundColor Red
    exit 1
}
Write-Host "   ✓ BravePortable folder found" -ForegroundColor Green

# Step 3: Create 7z archive
Write-Host "`n[3/6] Compressing BravePortable folder..." -ForegroundColor Yellow
Write-Host "   This may take a minute..." -ForegroundColor Gray
$tempArchive = Join-Path $env:TEMP "BravePortable-temp.7z"
Remove-Item $tempArchive -ErrorAction SilentlyContinue
& $SevenZipPath a -t7z -mx=9 -mfb=64 -md=32m -ms=on $tempArchive ".\BravePortable\*" | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Compression failed!" -ForegroundColor Red
    exit 1
}
Move-Item $tempArchive ".\BravePortable.7z" -Force
$archiveSize = (Get-Item ".\BravePortable.7z").Length / 1MB
Write-Host "   ✓ Archive created: $([Math]::Round($archiveSize, 2)) MB" -ForegroundColor Green

# Step 4: Copy SFX module
Write-Host "`n[4/6] Copying SFX module..." -ForegroundColor Yellow
Copy-Item $SfxModule -Destination ".\7zSD.sfx" -Force
Write-Host "   ✓ SFX module ready" -ForegroundColor Green

# Step 5: Combine into executable
Write-Host "`n[5/6] Creating self-extracting executable..." -ForegroundColor Yellow
cmd /c copy /b 7zSD.sfx + BravePortable\7zip-sfx-config.txt + BravePortable.7z $OutputName 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to create SFX!" -ForegroundColor Red
    exit 1
}
Write-Host "   ✓ Executable created" -ForegroundColor Green

# Step 6: Cleanup temporary files
Write-Host "`n[6/6] Cleaning up..." -ForegroundColor Yellow
Remove-Item BravePortable.7z, 7zSD.sfx -ErrorAction SilentlyContinue
Write-Host "   ✓ Temporary files removed" -ForegroundColor Green

# Final result
if (Test-Path $OutputName) {
    $finalSize = (Get-Item $OutputName).Length / 1MB
    Write-Host "`n=====================================" -ForegroundColor Green
    Write-Host "  ✅ SUCCESS!" -ForegroundColor Green
    Write-Host "=====================================" -ForegroundColor Green
    Write-Host "`n📦 Output File:" -ForegroundColor Cyan
    Write-Host "   $OutputName" -ForegroundColor White
    Write-Host "`n📊 File Size:" -ForegroundColor Cyan
    Write-Host "   $([Math]::Round($finalSize, 2)) MB" -ForegroundColor White
    Write-Host "`n📍 Location:" -ForegroundColor Cyan
    Write-Host "   $WorkDir\$OutputName" -ForegroundColor White
    Write-Host "`n🎯 Usage:" -ForegroundColor Cyan
    Write-Host "   Double-click to extract and launch Brave" -ForegroundColor White
    Write-Host "   Users choose destination folder" -ForegroundColor White
    Write-Host "`n📤 Ready to distribute!" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "`n❌ Failed to create SFX!" -ForegroundColor Red
    exit 1
}
