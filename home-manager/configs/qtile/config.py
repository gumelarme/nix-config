import os
import subprocess
import glob
from pathlib import Path



from libqtile import  hook
from libqtile.config import Screen
from libqtile.log_utils import logger

from bar import main_bar, alt_bar
from keybinding import keys, mouse
from layout import floating_layout, groups, layouts
from utils import curdir


@hook.subscribe.startup_once
def autostart():
    script = curdir("scripts","autostart.sh")
    subprocess.Popen([script])


def get_wallpaper():
    wallpaper_dir = os.path.expanduser("~/.config/wallpaper")
    logger.debug(f"Scanning wallpapers in {wallpaper_dir}")

    files = []
    for ext in ["jpg", "jpeg", "png"]:
        wildcard = os.path.join(wallpaper_dir, f"*.{ext}")
        files.extend(glob.glob(wildcard))

    logger.debug(f"Got {len(files)}: {files}")
    if not files:
        return {}

    files.sort()
    wallpaper = files[0]
    for f in files:
        if Path(f).stem == "wallpaper":
            wallpaper = f
            break

    logger.debug(f"Wallpaper selected: {wallpaper_dir}")
    return {"wallpaper": wallpaper, "wallpaper_mode": "stretch"}



wallpaper_config = get_wallpaper()
screens = [
    Screen(top=main_bar, **wallpaper_config),
    Screen(top=alt_bar, **wallpaper_config),
]


widget_defaults = dict(
    font="DejaVuSansM Nerd Font, Noto Sans Mono CJK",
    fontsize=14,
    padding=5,
)

extension_defaults = widget_defaults.copy()
dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
