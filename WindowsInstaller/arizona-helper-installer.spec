# -*- mode: python ; coding: utf-8 -*-

from pathlib import Path

ROOT = Path(SPECPATH)

a = Analysis(
    [str(ROOT / "installer" / "__main__.py")],
    pathex=[str(ROOT)],
    binaries=[],
    datas=[
        (str(ROOT / "assets" / "moonloader.zip"), "assets"),
        (str(ROOT / "assets" / "logo.png"), "assets"),
    ],
    hiddenimports=[
        "installer",
        "installer.ui",
        "installer.actions",
        "installer.game",
        "installer.elevate",
        "installer.payload",
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)

pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name="arizona-helper-build",
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=False,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    uac_admin=False,
    icon=str(ROOT / "assets" / "icon.ico"),
)
