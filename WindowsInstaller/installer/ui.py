from __future__ import annotations

import threading
import tkinter as tk
from pathlib import Path
from tkinter import filedialog, ttk

from installer.actions import InstallError, install_to
from installer.elevate import NeedElevation, relaunch_as_admin
from installer.game import (
    GameInstall,
    GameNotFound,
    find_running_game,
    pids_for_root,
    resolve_game_root,
    scan_known_installs,
)
from installer.payload import product
from installer.resources import brand_logo_path

BG = "#07090f"
CARD = "#121826"
ACCENT = "#00d4ff"
ACCENT_HOVER = "#5ae4ff"
ACCENT_DOWN = "#00b6dd"
TEXT = "#f5f7fb"
MUTED = "#8b95a8"
SUCCESS = "#3dd68c"
WARN = "#ff8a3d"
ERROR = "#ff6b6b"
FONT = "Segoe UI"
HELPER_NAME = product().name
BTN_INSTALL = "Установить хелпер"
LINK_FIND = "Найти папку с игрой автоматически"
LINK_FOLDER = "Указать папку игры самостоятельно"
LINK_CANCEL = "Отменить поиск"

WINDOW_W = 500
WINDOW_H = 560

WAIT_MESSAGE = (
    "Запустите игру и сразу нажмите Alt + Tab — так мы найдём папку с игрой "
    "(на сервер входить не нужно!)"
)


def _rounded_rect(canvas: tk.Canvas, x1: int, y1: int, x2: int, y2: int, radius: int, **kwargs) -> int:
    r = max(0, min(radius, (x2 - x1) // 2, (y2 - y1) // 2))
    points = (
        x1 + r, y1,
        x2 - r, y1,
        x2, y1,
        x2, y1 + r,
        x2, y2 - r,
        x2, y2,
        x2 - r, y2,
        x1 + r, y2,
        x1, y2,
        x1, y2 - r,
        x1, y1 + r,
        x1, y1,
    )
    return canvas.create_polygon(points, smooth=True, splinesteps=36, **kwargs)


def _center_window(root: tk.Tk, width: int, height: int) -> None:
    root.update_idletasks()
    x = max(0, (root.winfo_screenwidth() - width) // 2)
    y = max(0, (root.winfo_screenheight() - height) // 3)
    root.geometry(f"{width}x{height}+{x}+{y}")


def _short_path(path: Path, limit: int = 46) -> str:
    text = str(path)
    if len(text) <= limit:
        return text
    return "…" + text[-(limit - 1) :]


class PillButton(tk.Canvas):
    def __init__(
        self,
        master: tk.Misc,
        text: str,
        command,
        width: int = 300,
        height: int = 54,
        radius: int = 27,
        fill: str = ACCENT,
        fill_hover: str = ACCENT_HOVER,
        fill_down: str = ACCENT_DOWN,
        fill_disabled: str = "#2a3140",
        fg: str = "#061018",
        fg_disabled: str = "#7b8494",
        font: tuple = (FONT, 15, "bold"),
        **kwargs,
    ) -> None:
        super().__init__(
            master,
            width=width,
            height=height,
            bg=master.cget("bg"),
            highlightthickness=0,
            bd=0,
            cursor="hand2",
            **kwargs,
        )
        self._text = text
        self._command = command
        self._fill = fill
        self._fill_hover = fill_hover
        self._fill_down = fill_down
        self._fill_disabled = fill_disabled
        self._fg = fg
        self._fg_disabled = fg_disabled
        self._font = font
        self._radius = radius
        self._enabled = True
        self._hover = False
        self._shape = None
        self._label = None
        self.bind("<Enter>", self._on_enter)
        self.bind("<Leave>", self._on_leave)
        self.bind("<ButtonPress-1>", self._on_press)
        self.bind("<ButtonRelease-1>", self._on_release)
        self._redraw()

    def set_text(self, text: str) -> None:
        self._text = text
        if self._label is not None:
            self.itemconfigure(self._label, text=text)

    def set_enabled(self, enabled: bool) -> None:
        self._enabled = enabled
        self.configure(cursor="hand2" if enabled else "arrow")
        self._hover = False
        self._redraw()

    def _color(self) -> tuple[str, str]:
        if not self._enabled:
            return self._fill_disabled, self._fg_disabled
        if self._hover:
            return self._fill_hover, self._fg
        return self._fill, self._fg

    def _redraw(self, fill: str | None = None) -> None:
        bg, fg = self._color()
        color = fill or bg
        self.delete("all")
        w = int(self.cget("width"))
        h = int(self.cget("height"))
        self._shape = _rounded_rect(self, 1, 1, w - 2, h - 2, self._radius, fill=color, outline=color)
        self._label = self.create_text(w // 2, h // 2, text=self._text, fill=fg, font=self._font)

    def _on_enter(self, _event=None) -> None:
        if not self._enabled:
            return
        self._hover = True
        self._redraw(self._fill_hover)

    def _on_leave(self, _event=None) -> None:
        self._hover = False
        self._redraw()

    def _on_press(self, _event=None) -> None:
        if not self._enabled:
            return
        self._redraw(self._fill_down)

    def _on_release(self, event) -> None:
        if not self._enabled:
            return
        self._redraw(self._fill_hover if self._hover else self._fill)
        if 0 <= event.x <= int(self.cget("width")) and 0 <= event.y <= int(self.cget("height")):
            self._command()


class TextLink(tk.Label):
    def __init__(self, master: tk.Misc, text: str, command, **kwargs) -> None:
        super().__init__(
            master,
            text=text,
            bg=master.cget("bg"),
            fg=ACCENT,
            font=(FONT, 10),
            cursor="hand2",
            **kwargs,
        )
        self._command = command
        self.bind("<Enter>", lambda _e: self.configure(fg=ACCENT_HOVER, font=(FONT, 10, "underline")))
        self.bind("<Leave>", lambda _e: self.configure(fg=ACCENT, font=(FONT, 10)))
        self.bind("<Button-1>", lambda _e: self._command())

    def set_enabled(self, enabled: bool) -> None:
        if enabled:
            self.configure(fg=ACCENT, cursor="hand2")
            self.bind("<Button-1>", lambda _e: self._command())
        else:
            self.configure(fg=MUTED, cursor="arrow", font=(FONT, 10))
            self.unbind("<Button-1>")


class InstallerApp:
    def __init__(self, root: tk.Tk, auto_install_dir: str | None = None) -> None:
        self.root = root
        self.watching = False
        self.busy = False
        self.finished = False
        self.game_root: Path | None = None

        self._configure_root()
        self._build()

        if auto_install_dir:
            self._set_game_root(Path(auto_install_dir), announce=False)
            self.root.after(180, self.start_install)
            return

        self.root.after_idle(self._safe_prefill)

    def _configure_root(self) -> None:
        self.root.title(HELPER_NAME)
        self.root.configure(bg=BG)
        self.root.resizable(False, False)
        _center_window(self.root, WINDOW_W, WINDOW_H)

        style = ttk.Style(self.root)
        try:
            style.theme_use("clam")
        except tk.TclError:
            pass
        style.configure(
            "Accent.Horizontal.TProgressbar",
            troughcolor="#222a38",
            background=ACCENT,
            bordercolor=BG,
            lightcolor=ACCENT,
            darkcolor=ACCENT,
            thickness=7,
        )

    def _build(self) -> None:
        tk.Frame(self.root, bg=ACCENT, height=3).pack(fill="x")

        shell = tk.Frame(self.root, bg=BG)
        shell.pack(fill="both", expand=True, padx=36, pady=(22, 18))

        header = tk.Frame(shell, bg=BG)
        header.pack(fill="x")
        tk.Label(header, text=HELPER_NAME, bg=BG, fg=TEXT, font=(FONT, 22, "bold")).pack(pady=(4, 0))

        footer = tk.Frame(shell, bg=BG)
        footer.pack(side="bottom", pady=(8, 0))
        brand = tk.Frame(footer, bg=BG)
        brand.pack()
        self._footer_logo = None
        logo = brand_logo_path()
        if logo is not None:
            try:
                self._footer_logo = tk.PhotoImage(file=str(logo))
                tk.Label(brand, image=self._footer_logo, bg=BG, bd=0).pack(side="left", padx=(0, 8))
            except tk.TclError:
                self._footer_logo = None
        tk.Label(brand, text="MTG MODS", bg=BG, fg="#4d5666", font=(FONT, 9)).pack(side="left")

        self.body = tk.Frame(shell, bg=BG)
        self.body.pack(fill="both", expand=True)

        tk.Frame(self.body, bg=BG).pack(expand=True)

        self.status_area = tk.Frame(self.body, bg=BG)
        self.status_area.pack(fill="x")

        self.status_label = tk.Label(
            self.status_area,
            text="",
            bg=BG,
            fg=MUTED,
            font=(FONT, 12),
            wraplength=400,
            justify="center",
        )
        self.status_label.pack()

        self.detail_label = tk.Label(
            self.status_area,
            text="",
            bg=BG,
            fg=MUTED,
            font=(FONT, 10),
            wraplength=400,
            justify="center",
        )
        self.detail_label.pack(pady=(8, 0))

        self.path_label = tk.Label(
            self.status_area,
            text="",
            bg=BG,
            fg="#6d7788",
            font=(FONT, 9),
            wraplength=400,
            justify="center",
        )
        self.path_label.pack(pady=(10, 0))

        self.progress = ttk.Progressbar(
            self.status_area,
            style="Accent.Horizontal.TProgressbar",
            mode="determinate",
            maximum=100,
        )

        self.install_btn = PillButton(self.body, BTN_INSTALL, self.start_install, width=340)
        self.install_btn.pack(pady=(22, 12))

        self.links = tk.Frame(self.body, bg=BG)
        self.links.pack()
        self.find_link = TextLink(self.links, LINK_FIND, self.toggle_watch)
        self.find_link.pack(pady=(0, 6))
        self.folder_link = TextLink(self.links, LINK_FOLDER, self.browse_folder)
        self.folder_link.pack()

        self._bottom_spacer = tk.Frame(self.body, bg=BG)
        self._bottom_spacer.pack(expand=True)

        self.root.bind("<Return>", lambda _e: self.start_install())

    def _show_progress(self, visible: bool) -> None:
        if visible:
            self.path_label.pack_forget()
            self.progress.pack(fill="x", pady=(14, 0))
        else:
            self.progress.pack_forget()
            self.path_label.pack(pady=(10, 0))

    def set_status(self, status: str, detail: str = "", kind: str = "info", path: str | None = None) -> None:
        colors = {
            "ready": MUTED,
            "wait": WARN,
            "work": ACCENT,
            "done": SUCCESS,
            "error": ERROR,
            "info": MUTED,
        }
        self.status_label.configure(text=status, fg=colors.get(kind, MUTED))
        self.detail_label.configure(text=detail)
        self.path_label.configure(text=path or "")

    def _safe_prefill(self) -> None:
        try:
            self._prefill()
        except Exception:
            self.start_watch(steal_focus=False)

    def _prefill(self) -> None:
        try:
            running = find_running_game()
        except Exception:
            running = []
        if running:
            chosen = self._pick_install(running)
            if chosen is not None:
                self._set_game_root(chosen.root)
                return

        try:
            known = scan_known_installs()
        except Exception:
            known = []
        if len(known) == 1:
            self._set_game_root(known[0].root)
            return
        if len(known) > 1:
            chosen = self._pick_install(known)
            if chosen is not None:
                self._set_game_root(chosen.root)
                return
        self.start_watch(steal_focus=False)

    def _set_game_root(self, root: Path, announce: bool = True) -> None:
        self.game_root = root
        self.stop_watch()
        self._show_progress(False)
        if pids_for_root(root):
            self.set_status(
                "Сначала закройте игру",
                "Чтобы ничего не потерять, закройте её сами, затем нажмите «Установить хелпер».",
                "wait",
                _short_path(root),
            )
        elif announce:
            self.set_status(_short_path(root), "", "ready")
        else:
            self.set_status("Продолжаем установку…", "", "work")
        self.install_btn.set_text(BTN_INSTALL)
        self.install_btn.set_enabled(True)

    def _set_busy(self, busy: bool) -> None:
        self.busy = busy
        self.install_btn.set_enabled(not busy)
        self.find_link.set_enabled(not busy)
        self.folder_link.set_enabled(not busy)

    def _set_controls(self, *, button: bool, links: bool) -> None:
        self.install_btn.pack_forget()
        self.links.pack_forget()
        if button:
            self.install_btn.pack(pady=(22, 12), before=self._bottom_spacer)
        if links:
            self.links.pack(before=self._bottom_spacer)

    def browse_folder(self) -> None:
        if self.busy:
            return
        self.stop_watch()
        selected = filedialog.askdirectory(title="Выберите папку с игрой")
        if not selected:
            if self.game_root is None:
                self.start_watch(steal_focus=False)
            return
        try:
            root = resolve_game_root(Path(selected))
        except GameNotFound:
            self._show_error(
                "В папке отсутствует gta_sa.exe",
                title="Это не папка с игрой",
                path=selected,
            )
            return
        self._set_game_root(root)

    def toggle_watch(self) -> None:
        if self.busy:
            return
        if self.watching:
            self.stop_watch()
            if self.game_root is None:
                self.set_status(
                    "Игра не выбрана",
                    "Запустите игру или укажите папку самостоятельно.",
                    "wait",
                )
            return
        running = find_running_game()
        if running:
            chosen = self._pick_install(running)
            if chosen is not None:
                self._set_game_root(chosen.root)
            return
        self.start_watch(steal_focus=False)

    def start_watch(self, steal_focus: bool = True) -> None:
        self.watching = True
        self._show_progress(False)
        self.install_btn.set_enabled(self.game_root is not None)
        self.find_link.configure(text=LINK_CANCEL)
        self.set_status("Запустите игру", WAIT_MESSAGE, "wait")
        if steal_focus:
            self._bring_forward()
        self._poll_watch()

    def stop_watch(self) -> None:
        self.watching = False
        self.find_link.configure(text=LINK_FIND)
        if self.game_root is not None and not self.busy:
            self.install_btn.set_enabled(True)

    def _poll_watch(self) -> None:
        if not self.watching or self.busy:
            return
        try:
            running = find_running_game()
        except Exception:
            running = []
        if running:
            self.stop_watch()
            self._bring_forward()
            chosen = self._pick_install(running)
            if chosen is not None:
                self._set_game_root(chosen.root)
            elif self.game_root is None:
                self.start_watch(steal_focus=False)
            return
        self.root.after(700, self._poll_watch)

    def _bring_forward(self) -> None:
        try:
            self.root.deiconify()
            self.root.lift()
            self.root.attributes("-topmost", True)
            self.root.after(500, lambda: self.root.attributes("-topmost", False))
            self.root.focus_force()
        except tk.TclError:
            pass

    def _pick_install(self, installs: list[GameInstall]) -> GameInstall | None:
        unique: dict[str, GameInstall] = {}
        for item in installs:
            unique[str(item.root).casefold()] = item
        items = list(unique.values())
        if len(items) == 1:
            return items[0]

        picker = tk.Toplevel(self.root)
        picker.title("Выберите игру")
        picker.configure(bg=BG)
        picker.transient(self.root)
        picker.resizable(False, False)
        picker.grab_set()
        tk.Label(
            picker,
            text="Найдено несколько копий игры.\nВыберите нужную:",
            bg=BG,
            fg=TEXT,
            font=(FONT, 11),
            justify="center",
        ).pack(padx=24, pady=(18, 10))

        chosen: dict[str, GameInstall | None] = {"value": None}
        listbox = tk.Listbox(
            picker,
            bg=CARD,
            fg=TEXT,
            selectbackground=ACCENT,
            selectforeground="#061018",
            relief="flat",
            font=(FONT, 10),
            height=min(6, len(items)),
            activestyle="none",
            highlightthickness=0,
            borderwidth=8,
        )
        for item in items:
            listbox.insert("end", _short_path(item.root, 60))
        listbox.selection_set(0)
        listbox.pack(fill="x", padx=24)

        def confirm() -> None:
            selection = listbox.curselection()
            if not selection:
                return
            chosen["value"] = items[selection[0]]
            picker.destroy()

        listbox.bind("<Double-Button-1>", lambda _e: confirm())
        btn = PillButton(picker, "Выбрать", confirm, width=200, height=44, radius=22, font=(FONT, 12, "bold"))
        btn.pack(pady=16)
        picker.protocol("WM_DELETE_WINDOW", picker.destroy)
        self.root.wait_window(picker)
        return chosen["value"]

    def start_install(self) -> None:
        if self.finished:
            self.root.destroy()
            return
        if self.busy:
            return
        root = self.game_root
        if root is None:
            raw_choice = filedialog.askdirectory(title="Выберите папку с игрой")
            if not raw_choice:
                return
            try:
                root = resolve_game_root(Path(raw_choice))
            except GameNotFound:
                self._show_error(
                    "В папке отсутствует gta_sa.exe",
                    title="Это не папка с игрой",
                    path=raw_choice,
                )
                return
            self._set_game_root(root)

        if pids_for_root(root):
            self._set_game_root(root)
            return

        self.stop_watch()
        self._set_busy(True)
        self.progress["value"] = 0
        self._show_progress(True)
        self._set_controls(button=False, links=False)
        self.set_status("Установка…", "Это займёт несколько секунд.", "work")
        threading.Thread(target=self._install_worker, args=(root,), daemon=True).start()

    def _install_worker(self, game_root: Path) -> None:
        def on_progress(message: str, fraction: float | None) -> None:
            self.root.after(0, lambda: self._on_progress(message, fraction))

        try:
            install_to(game_root, on_progress)
        except NeedElevation as error:
            directory = error.directory
            self.root.after(0, lambda: self._request_elevation(directory))
            return
        except InstallError as error:
            message = str(error)
            self.root.after(0, lambda: self._show_error(message, allow_retry=True))
            return
        except Exception:
            self.root.after(
                0,
                lambda: self._show_error("Что-то пошло не так. Попробуйте ещё раз.", allow_retry=True),
            )
            return
        self.root.after(0, self._install_done)

    def _on_progress(self, message: str, fraction: float | None) -> None:
        self.detail_label.configure(text=message)
        if fraction is not None:
            self.progress["value"] = max(0, min(100, fraction * 100))

    def _request_elevation(self, directory: Path) -> None:
        self._set_busy(False)
        self.install_btn.set_text(BTN_INSTALL)
        self._set_controls(button=True, links=True)
        self._show_progress(False)
        self.set_status(
            "Нужно разрешение Windows",
            "Нажмите «Да», чтобы положить файлы в папку игры.",
            "wait",
            _short_path(directory),
        )
        if not relaunch_as_admin(directory):
            self._show_error(
                f"Без разрешения Windows установить не получится. Нажмите «{BTN_INSTALL}» ещё раз и согласитесь.",
                allow_retry=True,
            )
            return
        self.root.destroy()

    def _show_error(
        self,
        message: str,
        allow_retry: bool = False,
        path: str | Path | None = None,
        title: str | None = None,
    ) -> None:
        self.stop_watch()
        self.busy = False
        self.find_link.set_enabled(True)
        self.folder_link.set_enabled(True)
        self.install_btn.set_text(BTN_INSTALL)
        self.install_btn.set_enabled(allow_retry and self.game_root is not None)
        self._set_controls(button=True, links=True)
        self._show_progress(False)
        if path is not None:
            shown = _short_path(Path(path))
        elif self.game_root is not None:
            shown = _short_path(self.game_root)
        else:
            shown = ""
        if title:
            self.set_status(title, message, "error", shown)
        else:
            self.set_status(message, "", "error", shown)

    def _install_done(self) -> None:
        self.finished = True
        self._set_busy(False)
        self.progress["value"] = 100
        self._show_progress(False)
        self.set_status(
            "Готово",
            "Можете запускать игру.",
            "done",
        )
        self.install_btn.set_text("Закрыть")
        self.install_btn.set_enabled(True)
        self._set_controls(button=True, links=False)


def run_app(auto_install_dir: str | None = None) -> None:
    root = tk.Tk()
    try:
        InstallerApp(root, auto_install_dir=auto_install_dir)
        root.mainloop()
    except Exception:
        try:
            from tkinter import messagebox

            messagebox.showerror(
                HELPER_NAME,
                "Не удалось запустить установщик. Попробуйте ещё раз.",
            )
        except Exception:
            pass
        try:
            root.destroy()
        except Exception:
            pass
