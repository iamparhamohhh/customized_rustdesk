# quick_test.ps1 — Fast local Flutter build & run (~2-3 min)
#
# FIRST TIME SETUP:
#   1. Run a CI build and download the artifact
#   2. Copy librustdesk.dll from the artifact into this flutter\ folder:
#        cp  <artifact>\librustdesk.dll  flutter\saved_librustdesk.dll
#   3. Then just run: .\quick_test.ps1
#
# HOW IT WORKS:
#   - Builds the Flutter Windows app locally (uses YOUR local Flutter SDK)
#   - Copies the saved real librustdesk.dll into the build output
#   - Launches the app
#
# NOTE: This only rebuilds the Flutter/Dart side. For Rust changes you need CI.

$ErrorActionPreference = "Stop"

$savedDll = "$PSScriptRoot\saved_librustdesk.dll"
$buildDir = "$PSScriptRoot\build\windows\x64\runner\Release"
$exeName  = "rahbardesk.exe"

# Check for saved DLL
if (-not (Test-Path $savedDll)) {
    Write-Host ""
    Write-Host "ERROR: saved_librustdesk.dll not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "You need to save the real DLL from a CI build first:" -ForegroundColor Yellow
    Write-Host "  1. Download the 'rahbardesk-windows-x64-flutter' artifact from GitHub Actions"
    Write-Host "  2. Copy librustdesk.dll into this folder:"
    Write-Host "     cp <artifact-folder>\librustdesk.dll $savedDll"
    Write-Host ""
    exit 1
}

$dllSize = (Get-Item $savedDll).Length / 1MB
if ($dllSize -lt 1) {
    Write-Host "WARNING: saved_librustdesk.dll is only $([math]::Round($dllSize, 2)) MB — this looks like a stub!" -ForegroundColor Yellow
    Write-Host "The real DLL should be 20-50 MB. Get it from a CI build." -ForegroundColor Yellow
    exit 1
}

Write-Host "Building Flutter Windows app..." -ForegroundColor Cyan
flutter build windows --release
if ($LASTEXITCODE -ne 0) {
    Write-Host "Flutter build failed!" -ForegroundColor Red
    exit 1
}

# Copy the real DLL into the build output
Write-Host "Copying real librustdesk.dll ($([math]::Round($dllSize, 1)) MB)..." -ForegroundColor Cyan
Copy-Item $savedDll "$buildDir\librustdesk.dll" -Force

# Also copy dylib_virtual_display.dll if available
$vdDll = "$PSScriptRoot\..\target\release\deps\dylib_virtual_display.dll"
if (Test-Path $vdDll) {
    Copy-Item $vdDll $buildDir -Force
}

Write-Host ""
Write-Host "Build complete! Launching $exeName..." -ForegroundColor Green
Write-Host ""

# Launch
Start-Process "$buildDir\$exeName"
