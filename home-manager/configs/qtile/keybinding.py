from libqtile.config import Click,Drag, EzKey as K, Key
from libqtile.lazy import lazy
from libqtile.log_utils import logger

from layout import workspaces, named_workspace
from utils import lazy_script

# Application that get called by this file:
# - firefox
# - wezterm
# - nnn
# - flameshot
# - rofi
# - rofi-power-menu.sh
# - qutebrowser
# - spotify
# - eww
# - thunar


_cur_layout = None
def toggle_layout(qtile, target_layout: str):
    global _cur_layout

    if _cur_layout is None:
        _cur_layout = qtile.current_layout.name

    layout = target_layout
    if qtile.current_layout.name == target_layout:
        layout = _cur_layout

    qtile.current_group.cmd_setlayout(layout)
    logger.debug(f"Toggling Layout: {layout}")

mod = "mod4"

keys = [
    K("M-S-C-r", lazy.reload_config(), desc="Reload config"),

    # Window navigation
    K("M-h", lazy.layout.left(), desc="Move focus to the left"),
    K("M-l", lazy.layout.right(), desc="Move focus to the right"),
    K("M-j", lazy.layout.down(), desc="Move focus to the down"),
    K("M-k", lazy.layout.up(), desc="Move focus to the up"),
    K("M-<Tab>", lazy.layout.next(), desc="Move focus to other window"),

    # Window manipulation
    K("M-S-h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    K("M-S-l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    K("M-S-j", lazy.layout.shuffle_down(), desc="Move window to down"),
    K("M-S-k", lazy.layout.shuffle_up(), desc="Move window to up"),
    K("M-S-d", lazy.window.kill(), desc="Kill focused window"),

    ## Resize
    K("M-C-h", lazy.layout.grow_left(), desc="Grow window to the left"),
    K("M-C-l", lazy.layout.grow_right(), desc="Grow window to the right"),
    K("M-C-j", lazy.layout.grow_down(), desc="Grow window to down"),
    K("M-C-k", lazy.layout.grow_up(), desc="Grow window to up"),
    K("M-C-k", lazy.layout.grow_up(), desc="Grow window to up"),
    K("M-C-n", lazy.layout.normalize(), desc="Reset all window sizes"),

    # Layout manipulation
    K("M-f", lazy.function(toggle_layout, "max"), desc="Toggle max layout"),
    K("M-S-f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    K("M-S-C-f", lazy.window.toggle_floating(), desc="Toggle floating"),
    K("M-n", lazy.next_layout(), desc="Toggle between layouts"),
    # K("M-m", lazy.group.setlayout("max"), desc="Toggle max"),
    # K("M-S-<Return>", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack")

    ## Screen
    K("M-a", lazy.next_screen()),

    # Function Keys
    K("<XF86MonBrightnessUp>", lazy_script("change_brightness.sh", "+5")),
    K("<XF86MonBrightnessDown>", lazy_script("change_brightness.sh", "-5")),
    K("<XF86AudioRaiseVolume>", lazy_script("change_volume.sh", "5%+", "unmute")),
    K("<XF86AudioLowerVolume>", lazy_script("change_volume.sh", "5%-", "unmute")),
    K("<XF86AudioMute>", lazy_script("change_volume.sh", "toggle")),
    K("<XF86AudioMicMute>", lazy_script("mic_toggle.sh")),

    # Launch App
    K("M-z", lazy.spawn("firefox"), desc="Spawn firefox web browser"),
    K("M-S-z", lazy.spawn("firefox --private-window"), desc="Spawn firefox web browser"),

    K("M-<Return>", lazy.spawn("wezterm -e tmux new -As default"), desc="Launch terminal"),
    K("M-S-<Return>", lazy.spawn("wezterm"), desc="Launch tmuxless terminal"),
    K("M-t", lazy.spawn("wezterm -e nn"), desc="Spawn nnn with image viewer plugin"),
    K("M-S-t", lazy.spawn("thunar"), desc="Spawn thunar"),

    K("M-<Print>", lazy.spawn("flameshot gui")),
    K("M-S-<Print>", lazy.spawn("flameshot full")),

    K("M-C-q", lazy_script("rofi-power-menu.sh"), desc="Open power menu"),
    K("M-<space>", lazy.spawn("rofi -show drun")),
    K("M-S-<space>", lazy.spawn("rofi -show run")),
    # Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    ## Scratchpad
    K("M-<backslash>", lazy.group['scratch'].dropdown_toggle('term')),
    K("M-S-<backslash>", lazy.group['scratch'].dropdown_toggle('python-repl')),
    K("M-o", lazy.group['scratch'].dropdown_toggle('browser')),
    K("M-<slash>", lazy.group['scratch'].hide_all()),

    # Widget
    K("M-p", lazy.spawn("eww open --toggle media-control")),
    K("M-S-p", lazy.widget["widgetbox"].toggle()),
]

for i in workspaces:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key([mod], i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            Key([mod, "shift"],
                i.name,
                lazy.window.togroup(i.name),
                desc="move focused window to group {}".format(i.name)
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            # Key(
            #     [mod, "shift"],
            #     i.name,
            #     lazy.window.togroup(i.name, switch_group=True),
            #     desc="Switch to & move focused window to group {}".format(i.name),
            # ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
        ]
    )

for w in named_workspace:
    focus, move = w.get_ezkey()
    keys.extend(
        [
            K(focus, lazy.group[w.name].toscreen(), desc=f"Switch to group {w.name}"),
            K(move, lazy.window.togroup(w.name), desc=f"Move focused window to group {w.name}"),
        ]
    )

mouse = [
    # Drag floating layout
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position(),),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]
