from __future__ import annotations

import errno
import shutil
import ssl
import urllib.error
import urllib.request
import zipfile
from collections.abc import Callable
from pathlib import Path

from installer.elevate import NeedElevation, is_admin
from installer.game import find_gta_sa_exe, pids_for_root
from installer.payload import product
from installer.resources import moonloader_zip_path

ProgressFn = Callable[[str, float | None], None]
ERROR_SHARING_VIOLATION = 32
ERROR_ACCESS_DENIED = 5


class InstallError(Exception):
    pass


def _progress(callback: ProgressFn | None, message: str, fraction: float | None = None) -> None:
    if callback:
        callback(message, fraction)


def _is_access_denied(error: OSError) -> bool:
    winerror = getattr(error, "winerror", None)
    if winerror == ERROR_ACCESS_DENIED:
        return True
    return error.errno in {errno.EACCES, errno.EPERM}


def _is_sharing_violation(error: OSError) -> bool:
    return getattr(error, "winerror", None) == ERROR_SHARING_VIOLATION


def _ensure_writable(game_root: Path) -> None:
    probe = game_root / ".arizona_helper_write_test"
    try:
        game_root.mkdir(parents=True, exist_ok=True)
        probe.write_bytes(b"ok")
        probe.unlink(missing_ok=True)
    except OSError as error:
        probe.unlink(missing_ok=True)
        if _is_access_denied(error) and not is_admin():
            raise NeedElevation(game_root) from error
        if _is_sharing_violation(error):
            raise InstallError("Игра сейчас открыта. Закройте её и нажмите «Установить хелпер» ещё раз.") from error
        raise InstallError("Нет доступа к папке игры. Попробуйте указать папку ещё раз.") from error


def _safe_zip_target(destination: Path, member: str) -> Path:
    normalized = member.replace("\\", "/").lstrip("/")
    first = normalized.split("/", 1)[0]
    if ":" in first:
        raise InstallError("Файлы установщика повреждены. Скачайте программу заново.")
    if not normalized or normalized.endswith("/"):
        relative = Path(*Path(normalized.rstrip("/")).parts) if normalized else Path()
        target = destination / relative
    else:
        relative = Path(*Path(normalized).parts)
        target = destination / relative

    destination_resolved = destination.resolve()
    try:
        resolved = target.resolve()
    except OSError:
        resolved = target

    if relative.parts and any(part == ".." for part in relative.parts):
        raise InstallError("Файлы установщика повреждены. Скачайте программу заново.")
    if resolved != destination_resolved and destination_resolved not in resolved.parents:
        raise InstallError("Файлы установщика повреждены. Скачайте программу заново.")
    return target


def extract_moonloader(game_root: Path, callback: ProgressFn | None = None) -> None:
    archive = moonloader_zip_path()
    _progress(callback, "Копируем файлы…", 0.05)
    try:
        with zipfile.ZipFile(archive) as bundle:
            members = bundle.infolist()
            total = max(len(members), 1)
            for index, info in enumerate(members, start=1):
                name = info.filename.replace("\\", "/")
                target = _safe_zip_target(game_root, name)
                try:
                    if name.endswith("/") or info.is_dir():
                        target.mkdir(parents=True, exist_ok=True)
                    else:
                        target.parent.mkdir(parents=True, exist_ok=True)
                        with bundle.open(info) as source, open(target, "wb") as output:
                            shutil.copyfileobj(source, output)
                except OSError as error:
                    if _is_access_denied(error) and not is_admin():
                        raise NeedElevation(game_root) from error
                    if _is_sharing_violation(error):
                        raise InstallError(
                            "Не удалось скопировать файлы — игра всё ещё открыта. Закройте её и попробуйте снова."
                        ) from error
                    raise InstallError("Не удалось скопировать файлы. Попробуйте ещё раз.") from error
                if index == 1 or index % 25 == 0 or index == total:
                    fraction = 0.05 + 0.70 * (index / total)
                    _progress(callback, "Копируем файлы…", fraction)
    except zipfile.BadZipFile as error:
        raise InstallError("Файлы установщика повреждены. Скачайте программу заново.") from error
    except FileNotFoundError:
        raise InstallError("Файлы установщика не найдены. Скачайте программу заново.") from None


def download_helper_script(game_root: Path, callback: ProgressFn | None = None) -> Path:
    moonloader_dir = game_root / "moonloader"
    try:
        moonloader_dir.mkdir(parents=True, exist_ok=True)
    except OSError as error:
        if _is_access_denied(error) and not is_admin():
            raise NeedElevation(game_root) from error
        raise InstallError("Не удалось сохранить файлы в папку игры. Попробуйте ещё раз.") from error

    helper = product()
    destination = moonloader_dir / helper.filename
    ssl_context = ssl.create_default_context()

    for url in helper.urls:
        _progress(callback, "Скачиваем хелпер…", 0.82)
        request = urllib.request.Request(
            url,
            headers={
                "User-Agent": "ArizonaHelperInstaller/1.0 (+https://github.com/MTGMODS/arizona-helper-installer)",
                "Accept": "*/*",
            },
        )
        try:
            with urllib.request.urlopen(request, timeout=45, context=ssl_context) as response:
                data = response.read()
        except (urllib.error.URLError, TimeoutError, OSError):
            continue

        stripped = data.lstrip().lower()
        if not data or stripped.startswith(b"<!doctype") or stripped.startswith(b"<html"):
            continue
        if len(data) < 1024:
            continue

        try:
            destination.write_bytes(data)
        except OSError as error:
            if _is_access_denied(error) and not is_admin():
                raise NeedElevation(game_root) from error
            raise InstallError("Не удалось сохранить хелпер в папку игры. Попробуйте ещё раз.") from error
        _progress(callback, "Почти готово…", 0.95)
        return destination

    raise InstallError("Не удалось скачать хелпер. Проверьте интернет и попробуйте ещё раз.")


def install_to(game_root: Path, callback: ProgressFn | None = None) -> Path:
    root = Path(game_root)
    exe = find_gta_sa_exe(root)
    if exe is None:
        raise InstallError(
            "В этой папке нет игры. Выберите папку Arizona или Rodina "
            "или запустите игру — мы найдём её сами."
        )

    _progress(callback, "Проверяем игру…", 0.02)
    if pids_for_root(root):
        raise InstallError(
            "Игра сейчас открыта. Закройте её сами, чтобы ничего не потерять, "
            "затем нажмите «Установить хелпер» ещё раз."
        )
    _ensure_writable(root)

    extract_moonloader(root, callback)
    lua_path = download_helper_script(root, callback)
    _progress(callback, "Готово", 1.0)
    return lua_path
