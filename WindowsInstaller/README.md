# Arizona&Rodina Helper Installer

Windows installer for **Arizona&Rodina Helper**. It finds a GTA San Andreas / SAMP / Arizona (or Rodina) folder, unpacks MoonLoader, and downloads `Arizona Helper.lua`.

The installer UI and the `.exe` name are always **Arizona&Rodina Helper**. The script written to `moonloader\` is always **Arizona Helper.lua**. Only the Lua download URL is stamped into each copy of the EXE.

## Requirements

- Windows
- Python 3.12+

## Build the free template

Run these from the repo root. You do not need to change PowerShell execution policy.

```powershell
python -m pip install -r requirements.txt
python -m PyInstaller --noconfirm --clean arizona-helper-installer.spec
python -m installer.stamp "dist\arizona-helper-build.exe" -o "dist\Arizona&Rodina Helper.exe" --url "https://github.com/MTGMODS/arizona-helper/raw/refs/heads/main/Arizona%20Helper.lua"
```

Output: `dist\Arizona&Rodina Helper.exe`

Keep this file as the template. Rebuild it only when the installer itself changes (UI, MoonLoader zip, icon, logic).

If you prefer the script:

```powershell
powershell -ExecutionPolicy Bypass -File .\build.ps1
```

`.\build.ps1` may fail with `PSSecurityException` when script execution is disabled. The Python commands above are the same build.

Close `Arizona&Rodina Helper.exe` before rebuilding, or the output file cannot be replaced.

## Stamp a Lua URL

No PyInstaller rebuild. Copy the template and write a new download URL into the overlay.

Free (default GitHub lua):

```powershell
python -m installer.stamp "dist\Arizona&Rodina Helper.exe"
```

One-time backend link for VIP file (example: 87f9f00c) — always use `-o` so the template is not overwritten:

```powershell
python -m installer.stamp "dist\Arizona&Rodina Helper.exe" -o "dist\vip87f9f00c.exe" --url "https://api.mtgmods.com/v1/files/downloads/vip/87f9f00c"
```

Inspect what is stamped:

```powershell
python -m installer.stamp "dist\vip87f9f00c.exe" --show
```

Without `--url`, stamp uses the free GitHub file:

`https://github.com/MTGMODS/arizona-helper/raw/refs/heads/main/Arizona%20Helper.lua`

