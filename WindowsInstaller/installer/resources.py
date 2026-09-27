from __future__ import annotations

import sys
from pathlib import Path


def app_dir() -> Path:
    if getattr(sys, "frozen", False):
        return Path(sys.executable).resolve().parent
    return Path(__file__).resolve().parent.parent


def bundled_dir() -> Path:
    meipass = getattr(sys, "_MEIPASS", None)
    if meipass:
        return Path(meipass)
    return app_dir()


def _iter_asset_dirs() -> list[Path]:
    return [
        bundled_dir() / "assets",
        bundled_dir(),
        app_dir() / "assets",
        app_dir(),
        Path.cwd() / "assets",
        Path.cwd(),
    ]


def find_asset(*names: str) -> Path | None:
    seen: set[str] = set()
    for folder in _iter_asset_dirs():
        for name in names:
            path = folder / name
            key = str(path).casefold()
            if key in seen:
                continue
            seen.add(key)
            if path.is_file():
                return path
    return None


def moonloader_zip_path() -> Path:
    path = find_asset("moonloader.zip", "moonloader_0.26.5.zip")
    if path is None:
        raise FileNotFoundError("Файлы установщика не найдены. Скачайте программу заново.")
    return path


def brand_logo_path() -> Path | None:
    return find_asset("logo.png", "logo.ico", "icon.ico")
