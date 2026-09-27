from __future__ import annotations

import json
import struct
import sys
from dataclasses import dataclass
from functools import lru_cache
from pathlib import Path

MAGIC = b"MTGPAY01"
_XOR_KEY = bytes((0x5A, 0x19, 0xC3, 0x7E, 0xA1, 0x44, 0xD8, 0x0B, 0x6F, 0x92, 0x31, 0xE4, 0x58, 0x27, 0xBC, 0x0D))

HELPER_NAME = "Arizona&Rodina Helper"
LUA_FILENAME = "Arizona Helper.lua"
FREE_LUA_URL = "https://github.com/MTGMODS/arizona-helper/raw/refs/heads/main/Arizona%20Helper.lua"


@dataclass(frozen=True)
class Product:
    name: str
    filename: str
    urls: tuple[str, ...]


def product_with_urls(urls: tuple[str, ...]) -> Product:
    return Product(name=HELPER_NAME, filename=LUA_FILENAME, urls=urls)


DEFAULT_PRODUCT = product_with_urls((FREE_LUA_URL,))


def _xor(data: bytes) -> bytes:
    key = _XOR_KEY
    return bytes(byte ^ key[index % len(key)] for index, byte in enumerate(data))


def _split_overlay(blob: bytes) -> tuple[bytes, bytes | None]:
    footer = 8 + 4
    if len(blob) < footer:
        return blob, None
    magic = blob[-footer:-4]
    if magic != MAGIC:
        return blob, None
    length = struct.unpack_from("<I", blob, len(blob) - 4)[0]
    start = len(blob) - footer - length
    if start < 0 or length == 0:
        return blob, None
    return blob[:start], blob[start : start + length]


def decode_overlay(cipher: bytes) -> Product | None:
    try:
        payload = json.loads(_xor(cipher).decode("utf-8"))
    except (UnicodeDecodeError, json.JSONDecodeError, ValueError):
        return None
    if not isinstance(payload, dict):
        return None
    urls_raw = payload.get("urls") or payload.get("url") or ()
    if isinstance(urls_raw, str):
        urls = (urls_raw.strip(),)
    else:
        urls = tuple(str(item).strip() for item in urls_raw if str(item).strip())
    if not urls:
        return None
    return product_with_urls(urls)


def encode_overlay(product: Product) -> bytes:
    raw = json.dumps(
        {
            "name": HELPER_NAME,
            "filename": LUA_FILENAME,
            "urls": list(product.urls),
        },
        ensure_ascii=False,
        separators=(",", ":"),
    ).encode("utf-8")
    cipher = _xor(raw)
    return cipher + MAGIC + struct.pack("<I", len(cipher))


def stamp_bytes(exe_bytes: bytes, urls: tuple[str, ...]) -> bytes:
    body, _existing = _split_overlay(exe_bytes)
    return body + encode_overlay(product_with_urls(urls))


def read_overlay_from_file(path: Path) -> Product | None:
    try:
        blob = path.read_bytes()
    except OSError:
        return None
    _body, cipher = _split_overlay(blob)
    if cipher is None:
        return None
    return decode_overlay(cipher)


def _host_exe() -> Path | None:
    if getattr(sys, "frozen", False):
        return Path(sys.executable)
    return None


@lru_cache(maxsize=1)
def product() -> Product:
    host = _host_exe()
    if host is not None:
        stamped = read_overlay_from_file(host)
        if stamped is not None:
            return stamped
    return DEFAULT_PRODUCT
