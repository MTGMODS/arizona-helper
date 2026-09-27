from __future__ import annotations

import argparse
import sys
from pathlib import Path

from installer.payload import DEFAULT_PRODUCT, FREE_LUA_URLS, read_overlay_from_file, stamp_bytes


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=(
            "Подставляет в .exe только ссылку на Arizona Helper.lua. "
            "Название хелпера и lua-файл всегда те же. "
            "Полная пересборка не нужна — копия шаблона + URL."
        )
    )
    parser.add_argument("exe", type=Path, help="Готовый Arizona&Rodina Helper.exe")
    parser.add_argument(
        "-o",
        "--output",
        type=Path,
        help="Куда сохранить. По умолчанию — перезаписать этот же файл",
    )
    parser.add_argument(
        "--url",
        action="append",
        dest="urls",
        help="Ссылка на lua. Можно несколько раз — запасные адреса",
    )
    parser.add_argument("--show", action="store_true", help="Показать текущую ссылку и выйти")
    return parser


def main(argv: list[str] | None = None) -> int:
    args = _build_parser().parse_args(argv)
    exe = args.exe
    if not exe.is_file():
        sys.stderr.write(f"Файл не найден: {exe}\n")
        return 1

    if args.show:
        current = read_overlay_from_file(exe) or DEFAULT_PRODUCT
        source = "штамп" if read_overlay_from_file(exe) else "значения по умолчанию"
        sys.stdout.write(f"{source}\n")
        sys.stdout.write(f"name: {current.name}\n")
        sys.stdout.write(f"lua: {current.filename}\n")
        for url in current.urls:
            sys.stdout.write(f"url: {url}\n")
        return 0

    urls = tuple(args.urls) if args.urls else FREE_LUA_URLS
    stamped = stamp_bytes(exe.read_bytes(), urls)
    output = (args.output or exe).resolve()
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_bytes(stamped)
    sys.stdout.write(f"Готово: {output}\n")
    for url in urls:
        sys.stdout.write(f"{url}\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
