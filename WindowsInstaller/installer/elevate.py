from __future__ import annotations

import ctypes
import sys
from pathlib import Path


class NeedElevation(Exception):
    def __init__(self, directory: Path):
        self.directory = Path(directory)
        super().__init__(str(self.directory))


def is_admin() -> bool:
    try:
        return bool(ctypes.windll.shell32.IsUserAnAdmin())
    except Exception:
        return False


def relaunch_as_admin(game_dir: Path) -> bool:
    """Relaunch the installer elevated with --install. Returns False if the user cancelled UAC."""
    directory = str(Path(game_dir).resolve())
    if getattr(sys, "frozen", False):
        executable = sys.executable
        params = f'--install "{directory}"'
        working_dir = str(Path(sys.executable).parent)
    else:
        executable = sys.executable
        module_root = Path(__file__).resolve().parent.parent
        params = f'-m installer --install "{directory}"'
        working_dir = str(module_root)

    rc = ctypes.windll.shell32.ShellExecuteW(
        None,
        "runas",
        executable,
        params,
        working_dir,
        1,
    )
    return rc > 32
