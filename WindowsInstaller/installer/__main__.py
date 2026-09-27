from __future__ import annotations

import argparse
import ctypes
import sys


def _enable_dpi_awareness() -> None:
    if sys.platform != "win32":
        return
    try:
        ctypes.windll.shcore.SetProcessDpiAwareness(2)
        return
    except Exception:
        pass
    try:
        ctypes.windll.user32.SetProcessDPIAware()
    except Exception:
        pass


def main() -> None:
    if sys.platform != "win32":
        sys.stderr.write("Установщик работает только в Windows.\n")
        sys.exit(1)

    parser = argparse.ArgumentParser(description="Установщик Arizona&Rodina Helper")
    parser.add_argument(
        "--install",
        metavar="GAME_DIR",
        help="Сразу установить в указанную папку игры",
    )
    args = parser.parse_args()

    _enable_dpi_awareness()
    from installer.ui import run_app

    run_app(auto_install_dir=args.install)


if __name__ == "__main__":
    main()
