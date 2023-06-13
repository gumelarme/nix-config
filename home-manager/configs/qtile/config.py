# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

BACKLIGHT_STEP = 5

from logging import log
import os
import subprocess

from libqtile import layout, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.log_utils import logger

# from hooks import stick_win, unstick_win
from bar import main_bar, alt_bar


def curdir(*paths):
    qtile_dir = os.path.expanduser("~/.config/qtile/")
    return os.path.join(qtile_dir, *paths)


def lazy_script(filename: str, *args):
    script = curdir("scripts", filename)
    return lazy.spawn(" ".join([script, *args]))


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
terminal = guess_terminal("alacritty")

keys = [
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),

    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "Tab", lazy.layout.next(), desc="Move window focus to other window"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Sticky Window
    # Key([mod], "o", lazy.function(stick_win), desc="Make window sticky"),
    # Key([mod, "shift"], ",", lazy.function(stick_win), desc="Unstick window"),
    # Toggle floating window
    Key([mod], "space", lazy.window.toggle_floating(), desc="Toggle floating"),
    # Key([mod], "m", lazy.group.setlayout("max"), desc="Toggle max"),
    Key([mod], "f", lazy.function(toggle_layout, "max"), desc="Toggle max layout"),
    Key([mod, "shift"], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn("alacritty -e tmux new -As default"), desc="Launch terminal"),
    Key([mod, "shift"], "Return", lazy.spawn("alacritty"), desc="Launch tmuxless terminal"),

    # Toggle between different layouts as defined below
    Key([mod], "n", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    # Applications
    Key([mod], "z", lazy.spawn("firefox"), desc="Spawn firefox web browser"),
    Key(
        [mod, "shift"],
        "z",
        lazy.spawn("firefox --private-window"),
        desc="Spawn firefox web browser",
    ),
    Key([mod], "t", lazy.spawn("dolphin"), desc="Spawn file explorer"),
    Key([mod], "d", lazy.spawn("rofi -show run")),
    Key([mod], "Print", lazy.spawn("flameshot gui")),
    Key([mod, "shift"], "Print", lazy.spawn("flameshot full")),

    # FunctionKeys
    Key([], "XF86MonBrightnessUp", lazy_script("change_brightness.sh", "+5")),
    Key([], "XF86MonBrightnessDown", lazy_script("change_brightness.sh", "-5")),

    Key([], "XF86AudioRaiseVolume", lazy_script("change_volume.sh", "5%+", "unmute")),
    Key([], "XF86AudioLowerVolume", lazy_script("change_volume.sh", "5%-", "unmute")),
    Key([], "XF86AudioMute", lazy_script("change_volume.sh", "toggle")),
    Key([], "XF86AudioMicMute", lazy.spawn(f"amixer set Capture toggle")),

    # ScratchPad
    Key([mod], "backslash", lazy.group['scratch'].dropdown_toggle('term')),
    Key([mod], "bracketright", lazy.group['scratch'].dropdown_toggle('browser')),
    Key([mod], "bracketleft", lazy.group['scratch'].dropdown_toggle('spotify')),
    Key([mod, "shift"], "backslash", lazy.group['scratch'].dropdown_toggle('python-repl')),
    Key([mod], "slash", lazy.group['scratch'].hide_all()),

    # Screen
    Key([mod], "comma", lazy.next_screen()), 
]

workspaces = [Group(i) for i in "1234567890"]
scratch_args= dict(
    height=0.68,
    width=0.5,
    x=0.499,
    opacity=1.0,
)

groups = [
    *workspaces,
    ScratchPad('scratch', [
            DropDown(
                "term",
                "alacritty -e tmux new -As scratch",
                **scratch_args,
            ),
            DropDown(
                "browser",
                "qutebrowser",
                **scratch_args,
            ),
            DropDown(
                "python-repl",
                "alacritty -e python3",
            ),
            DropDown(
                "spotify",
                "spotify",
                **scratch_args,
            ),
        ],
        single=False,
    ),
]

for i in workspaces:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
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
            Key([mod, "shift"],
                i.name,
                lazy.window.togroup(i.name),
                desc="move focused window to group {}".format(i.name)
            ),
        ]
    )

gaps = dict(
    margin=3,
    margin_on_single=0, # columns
    single_margin=0, # monad tall
    border_width=4,
    border_focus="#9748db",
    single_border_width=0, # monad tall
)


layouts = [
    layout.MonadTall(**gaps),
    layout.Columns(**gaps),
    layout.Max(),
    # layout.Tile(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="Noto Sans Display",
    fontsize=14,
    padding=5,
)

extension_defaults = widget_defaults.copy()
wallpaper = dict(
    wallpaper=os.path.expanduser('~/Pictures/origami.png'),
    wallpaper_mode="stretch",
)

screens = [
    Screen(top=main_bar, **wallpaper),
    Screen(top=alt_bar, **wallpaper),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
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