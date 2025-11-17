# BravePortable Registry Cleanup Script (PowerShell)
# Removes registry traces left by Brave browser
# Run as Administrator for full cleanup

$ErrorActionPreference = "SilentlyContinue"

Write-Host "`n=========================================" -ForegroundColor Cyan
Write-Host "  BravePortable Registry Cleanup" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "`n⚠️  WARNING: Not running as Administrator" -ForegroundColor Yellow
    Write-Host "   Some HKEY_LOCAL_MACHINE entries require admin rights" -ForegroundColor Yellow
    Write-Host "   Right-click and 'Run as Administrator' for full cleanup`n" -ForegroundColor Yellow
}

Write-Host "`n🧹 Cleaning HKEY_CURRENT_USER..." -ForegroundColor Yellow

# Remove HKCU entries (doesn't require admin)
$hkcuPaths = @(
    "HKCU:\Software\BraveSoftware",
    "HKCU:\Software\Policies\BraveSoftware"
)

foreach ($path in $hkcuPaths) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse -Force
        Write-Host "   ✓ Removed: $path" -ForegroundColor Green
    } else {
        Write-Host "   - Not found: $path" -ForegroundColor Gray
    }
}

if ($isAdmin) {
    Write-Host "`n🧹 Cleaning HKEY_LOCAL_MACHINE..." -ForegroundColor Yellow
    
    # Remove registered applications
    $regAppPath = "HKLM:\Software\RegisteredApplications"
    if (Test-Path $regAppPath) {
        $props = @("BravePortable", "Brave")
        foreach ($prop in $props) {
            try {
                Remove-ItemProperty -Path $regAppPath -Name $prop -ErrorAction Stop
                Write-Host "   ✓ Removed: RegisteredApplications\$prop" -ForegroundColor Green
            } catch {
                Write-Host "   - Not found: RegisteredApplications\$prop" -ForegroundColor Gray
            }
        }
    }
    
    # Remove Start Menu Internet clients
    $hklmPaths = @(
        "HKLM:\Software\Clients\StartMenuInternet\BravePortable",
        "HKLM:\Software\Clients\StartMenuInternet\BRAVEPORTABLE.EXE",
        "HKLM:\Software\Clients\StartMenuInternet\Brave",
        "HKLM:\Software\Clients\StartMenuInternet\BraveSoftware"
    )
    
    foreach ($path in $hklmPaths) {
        if (Test-Path $path) {
            Remove-Item -Path $path -Recurse -Force
            Write-Host "   ✓ Removed: $path" -ForegroundColor Green
        } else {
            Write-Host "   - Not found: $path" -ForegroundColor Gray
        }
    }
    
    # Remove file associations
    $classesPaths = @(
        "HKLM:\Software\Classes\BravePortableHTML",
        "HKLM:\Software\Classes\BraveHTML",
        "HKLM:\Software\Classes\BravePortableURL",
        "HKLM:\Software\Classes\BraveURL"
    )
    
    foreach ($path in $classesPaths) {
        if (Test-Path $path) {
            Remove-Item -Path $path -Recurse -Force
            Write-Host "   ✓ Removed: $path" -ForegroundColor Green
        } else {
            Write-Host "   - Not found: $path" -ForegroundColor Gray
        }
    }
}

Write-Host "`n🧹 Cleaning HKEY_CLASSES_ROOT..." -ForegroundColor Yellow

$hkcrPaths = @(
    "Registry::HKEY_CLASSES_ROOT\BravePortableHTML",
    "Registry::HKEY_CLASSES_ROOT\BraveHTML",
    "Registry::HKEY_CLASSES_ROOT\BravePortableURL",
    "Registry::HKEY_CLASSES_ROOT\BraveURL"
)

foreach ($path in $hkcrPaths) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse -Force
        Write-Host "   ✓ Removed: $($path -replace 'Registry::','')" -ForegroundColor Green
    } else {
        Write-Host "   - Not found: $($path -replace 'Registry::','')" -ForegroundColor Gray
    }
}

Write-Host "`n✅ Registry cleanup complete!" -ForegroundColor Green

if (-not $isAdmin) {
    Write-Host "`n💡 TIP: Run as Administrator to clean HKEY_LOCAL_MACHINE entries" -ForegroundColor Cyan
}

Write-Host ""
