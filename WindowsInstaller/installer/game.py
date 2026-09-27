from __future__ import annotations

import ctypes
import os
from ctypes import wintypes
from dataclasses import dataclass, field
from pathlib import Path

GTA_SA_NAME = "gta_sa.exe"
LAUNCHER_NAMES = frozenset(
    {
        "arizona games launcher.exe",
        "arizonagameslauncher.exe",
    }
)

TH32CS_SNAPPROCESS = 0x00000002
PROCESS_TERMINATE = 0x0001
PROCESS_QUERY_LIMITED_INFORMATION = 0x1000
PROCESS_SYNCHRONIZE = 0x00100000
WAIT_OBJECT_0 = 0x00000000
DRIVE_FIXED = 3
DRIVE_REMOVABLE = 2

kernel32 = ctypes.WinDLL("kernel32", use_last_error=True)


class PROCESSENTRY32W(ctypes.Structure):
    _fields_ = [
        ("dwSize", wintypes.DWORD),
        ("cntUsage", wintypes.DWORD),
        ("th32ProcessID", wintypes.DWORD),
        ("th32DefaultHeapID", ctypes.c_size_t),
        ("th32ModuleID", wintypes.DWORD),
        ("cntThreads", wintypes.DWORD),
        ("th32ParentProcessID", wintypes.DWORD),
        ("pcPriClassBase", ctypes.c_long),
        ("dwFlags", wintypes.DWORD),
        ("szExeFile", wintypes.WCHAR * 260),
    ]


kernel32.CreateToolhelp32Snapshot.argtypes = [wintypes.DWORD, wintypes.DWORD]
kernel32.CreateToolhelp32Snapshot.restype = ctypes.c_void_p
kernel32.Process32FirstW.argtypes = [wintypes.HANDLE, ctypes.POINTER(PROCESSENTRY32W)]
kernel32.Process32FirstW.restype = wintypes.BOOL
kernel32.Process32NextW.argtypes = [wintypes.HANDLE, ctypes.POINTER(PROCESSENTRY32W)]
kernel32.Process32NextW.restype = wintypes.BOOL
kernel32.OpenProcess.argtypes = [wintypes.DWORD, wintypes.BOOL, wintypes.DWORD]
kernel32.OpenProcess.restype = wintypes.HANDLE
kernel32.QueryFullProcessImageNameW.argtypes = [
    wintypes.HANDLE,
    wintypes.DWORD,
    wintypes.LPWSTR,
    ctypes.POINTER(wintypes.DWORD),
]
kernel32.QueryFullProcessImageNameW.restype = wintypes.BOOL
kernel32.TerminateProcess.argtypes = [wintypes.HANDLE, wintypes.UINT]
kernel32.TerminateProcess.restype = wintypes.BOOL
kernel32.WaitForSingleObject.argtypes = [wintypes.HANDLE, wintypes.DWORD]
kernel32.WaitForSingleObject.restype = wintypes.DWORD
kernel32.CloseHandle.argtypes = [wintypes.HANDLE]
kernel32.CloseHandle.restype = wintypes.BOOL
kernel32.GetLogicalDrives.argtypes = []
kernel32.GetLogicalDrives.restype = wintypes.DWORD
kernel32.GetDriveTypeW.argtypes = [wintypes.LPCWSTR]
kernel32.GetDriveTypeW.restype = wintypes.UINT

INVALID_HANDLE_VALUE = ctypes.c_void_p(-1).value


def _is_invalid_handle(handle: int | None) -> bool:
    return handle in (None, 0, INVALID_HANDLE_VALUE, 0xFFFFFFFF, 0xFFFFFFFFFFFFFFFF)


@dataclass
class GameInstall:
    root: Path
    exe: Path
    source: str
    pids: list[int] = field(default_factory=list)

    @property
    def display(self) -> str:
        return str(self.root)


class GameNotFound(Exception):
    pass


def is_gta_sa_filename(name: str) -> bool:
    return Path(name).name.casefold() == GTA_SA_NAME


def find_gta_sa_exe(directory: Path) -> Path | None:
    try:
        if not directory.is_dir():
            return None
        for entry in directory.iterdir():
            if entry.is_file() and is_gta_sa_filename(entry.name):
                return entry
    except OSError:
        return None
    return None


def _score_root(root: Path) -> int:
    score = 0
    name = str(root).casefold()
    if "arizona" in name:
        score += 4
    if (root / "samp.dll").exists():
        score += 5
    if (root / "MoonLoader.asi").exists() or (root / "moonloader.asi").exists():
        score += 2
    if (root / "moonloader").is_dir():
        score += 1
    return score


def resolve_game_root(user_path: Path) -> Path:
    path = Path(user_path).expanduser()
    try:
        path = path.resolve()
    except OSError:
        path = path.absolute()

    if path.is_file():
        if is_gta_sa_filename(path.name):
            return path.parent
        raise GameNotFound(path)

    if not path.is_dir():
        raise GameNotFound(path)

    if find_gta_sa_exe(path):
        return path

    for relative in (("bin", "arizona"), ("arizona",), ("bin",)):
        candidate = path.joinpath(*relative)
        if find_gta_sa_exe(candidate):
            return candidate

    raise GameNotFound(path)


def _fixed_drive_roots() -> list[Path]:
    roots: list[Path] = []
    bitmask = kernel32.GetLogicalDrives()
    for index in range(26):
        if not bitmask & (1 << index):
            continue
        letter = chr(ord("A") + index)
        root = f"{letter}:\\"
        drive_type = kernel32.GetDriveTypeW(root)
        if drive_type in (DRIVE_FIXED, DRIVE_REMOVABLE):
            roots.append(Path(root))
    return roots


def known_location_candidates() -> list[Path]:
    bases: list[Path] = []
    env_keys = (
        "LOCALAPPDATA",
        "APPDATA",
        "ProgramFiles",
        "ProgramFiles(x86)",
        "ProgramW6432",
    )
    for key in env_keys:
        value = os.environ.get(key)
        if value:
            bases.append(Path(value))
            bases.append(Path(value) / "Programs")

    for drive in _fixed_drive_roots():
        bases.append(drive)
        bases.append(drive / "Games")
        bases.append(drive / "Arizona")
        bases.append(drive / "Program Files")
        bases.append(drive / "Program Files (x86)")

    relatives = (
        Path("Arizona Games Launcher") / "bin" / "arizona",
        Path("Arizona") / "bin" / "arizona",
        Path("arizona") / "bin" / "arizona",
        Path("Games") / "Arizona Games Launcher" / "bin" / "arizona",
    )

    unique: list[Path] = []
    seen: set[str] = set()
    for base in bases:
        for relative in relatives:
            candidate = base / relative
            key = str(candidate).casefold()
            if key in seen:
                continue
            seen.add(key)
            unique.append(candidate)
    return unique


def scan_known_installs() -> list[GameInstall]:
    installs: list[GameInstall] = []
    seen: set[str] = set()
    for candidate in known_location_candidates():
        exe = find_gta_sa_exe(candidate)
        if not exe:
            continue
        key = str(candidate.resolve()).casefold() if candidate.exists() else str(candidate).casefold()
        try:
            root = candidate.resolve()
            exe = exe.resolve()
            key = str(root).casefold()
        except OSError:
            root = candidate
        if key in seen:
            continue
        seen.add(key)
        installs.append(GameInstall(root=root, exe=exe, source="scan"))
    installs.sort(key=lambda item: (_score_root(item.root) * -1, str(item.root).casefold()))
    return installs


def _iter_processes() -> list[tuple[int, str]]:
    try:
        snapshot = kernel32.CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    except OSError:
        return []
    if _is_invalid_handle(snapshot):
        return []
    processes: list[tuple[int, str]] = []
    try:
        entry = PROCESSENTRY32W()
        entry.dwSize = ctypes.sizeof(PROCESSENTRY32W)
        if not kernel32.Process32FirstW(snapshot, ctypes.byref(entry)):
            return []
        while True:
            processes.append((int(entry.th32ProcessID), entry.szExeFile))
            if not kernel32.Process32NextW(snapshot, ctypes.byref(entry)):
                break
        return processes
    except OSError:
        return []
    finally:
        kernel32.CloseHandle(snapshot)


def process_image_path(pid: int) -> Path | None:
    try:
        access = PROCESS_QUERY_LIMITED_INFORMATION
        handle = kernel32.OpenProcess(access, False, pid)
        if _is_invalid_handle(handle):
            return None
        try:
            size = wintypes.DWORD(32768)
            buffer = ctypes.create_unicode_buffer(size.value)
            if not kernel32.QueryFullProcessImageNameW(handle, 0, buffer, ctypes.byref(size)):
                return None
            return Path(buffer.value)
        finally:
            kernel32.CloseHandle(handle)
    except OSError:
        return None


def _launcher_game_root(launcher_exe: Path) -> Path | None:
    parent = launcher_exe.parent
    for relative in (("bin", "arizona"), ("arizona",)):
        candidate = parent.joinpath(*relative)
        exe = find_gta_sa_exe(candidate)
        if exe:
            return candidate
    exe = find_gta_sa_exe(parent)
    if exe:
        return parent
    return None


def find_running_game() -> list[GameInstall]:
    try:
        processes = _iter_processes()
    except Exception:
        return []

    by_root: dict[str, GameInstall] = {}

    for pid, name in processes:
        lowered = name.casefold()
        image = None

        if is_gta_sa_filename(name):
            image = process_image_path(pid)
            if image is None:
                continue
            root = image.parent
            key = str(root).casefold()
            current = by_root.get(key)
            if current is None:
                by_root[key] = GameInstall(root=root, exe=image, source="process", pids=[pid])
            else:
                current.pids.append(pid)
            continue

        if lowered in LAUNCHER_NAMES or (
            lowered.endswith("launcher.exe") and "arizona" in lowered
        ):
            image = process_image_path(pid)
            if image is None:
                continue
            root = _launcher_game_root(image)
            if root is None:
                continue
            exe = find_gta_sa_exe(root)
            if exe is None:
                continue
            key = str(root).casefold()
            if key not in by_root:
                by_root[key] = GameInstall(root=root, exe=exe, source="launcher")

    return list(by_root.values())


def pids_for_root(root: Path) -> list[int]:
    try:
        resolved = Path(root).resolve()
    except OSError:
        resolved = Path(root)
    pids: list[int] = []
    try:
        processes = _iter_processes()
    except Exception:
        return []
    for pid, name in processes:
        if not is_gta_sa_filename(name):
            continue
        image = process_image_path(pid)
        if image is None:
            continue
        try:
            parent = image.parent.resolve()
        except OSError:
            parent = image.parent
        if parent == resolved or str(parent).casefold() == str(resolved).casefold():
            pids.append(pid)
    return pids


def close_game_processes(pids: list[int], timeout_ms: int = 8000) -> list[int]:
    if not pids:
        return []

    still_running: list[int] = []
    handles: list[tuple[int, int]] = []
    access = PROCESS_TERMINATE | PROCESS_SYNCHRONIZE | PROCESS_QUERY_LIMITED_INFORMATION

    for pid in pids:
        handle = kernel32.OpenProcess(access, False, pid)
        if not handle:
            still_running.append(pid)
            continue
        if not kernel32.TerminateProcess(handle, 1):
            kernel32.CloseHandle(handle)
            still_running.append(pid)
            continue
        handles.append((pid, handle))

    remaining = timeout_ms
    per_wait = max(250, timeout_ms // max(len(handles), 1))
    for pid, handle in handles:
        wait_for = min(remaining, per_wait)
        result = kernel32.WaitForSingleObject(handle, wait_for)
        remaining = max(0, remaining - wait_for)
        if result != WAIT_OBJECT_0:
            still_running.append(pid)
        kernel32.CloseHandle(handle)

    return still_running
