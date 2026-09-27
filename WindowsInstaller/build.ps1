$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

python -m pip install -r requirements.txt
python -m PyInstaller --noconfirm --clean arizona-helper-installer.spec

$built = Join-Path $PSScriptRoot "dist\arizona-helper-build.exe"
if (-not (Test-Path -LiteralPath $built)) {
    throw "Build finished, but $built was not created."
}

python -m installer.stamp "$built" --url "https://github.com/MTGMODS/arizona-helper/raw/refs/heads/main/Arizona%20Helper.lua"

$out = Join-Path $PSScriptRoot "dist\Arizona&Rodina Helper.exe"
$oldTemplate = Join-Path $PSScriptRoot "dist\Helper Installer.exe"
if (Test-Path -LiteralPath $oldTemplate) {
    Remove-Item -LiteralPath $oldTemplate -Force
}

try {
    if (Test-Path -LiteralPath $out) {
        Remove-Item -LiteralPath $out -Force -ErrorAction Stop
    }
    Move-Item -LiteralPath $built -Destination $out
    Write-Host "Built: $out"
} catch {
    Write-Host "Cannot replace $out (file is open). Close Arizona&Rodina Helper.exe and run build again."
    Write-Host "Stamped build: $built"
    throw
}
