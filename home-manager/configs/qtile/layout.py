from libqtile import layout
from libqtile.config import  DropDown, Group, ScratchPad, Match

class NamedWorkspace:
    def __init__(self, name, key, **kwargs):
        self.name = name
        self.key = key
        self.options = kwargs

    def get_ezkey(self):
        return (f"M-{self.key}", f"M-S-{self.key}")


scratch_args= dict(
    height=0.68,
    width=0.5,
    x=0.499,
    opacity=1.0,
)

workspaces = [Group(i) for i in "1234qwer90"]
named_workspace = [
    NamedWorkspace("b", "b", matches=[Match(wm_class="qbittorrent")], spawn="qbittorrent"),
    NamedWorkspace("m", "m", matches=[Match(wm_class="spotify"), Match(wm_class="tauonmb")]),
]

# `wezterm -e` launch program as a gui, and somehow cannot be assigned to a dropdown
# so we need to override the `default_prog` configuration at launch
def wezterm_with(programs: str):
    # split by space, and pass it as list of string
    args = [f"'{x}'" for x in programs.split(" ")]
    return "wezterm --config default_prog=\"{ %s }\"" % ", ".join(args)

groups = [
    *workspaces,
    *[Group(i.name, **i.options) for i in named_workspace],
    ScratchPad('scratch', [
            DropDown("term", wezterm_with("tmux new -As scratch"), **scratch_args),
            DropDown("browser", "qutebrowser", **scratch_args),
            DropDown("python-repl", wezterm_with("python3")),
        ],
        single=False,
    ),
]




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
