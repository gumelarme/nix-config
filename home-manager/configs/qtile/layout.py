from libqtile import layout
from libqtile.config import  DropDown, Group, ScratchPad, Match

scratch_args= dict(
    height=0.68,
    width=0.5,
    x=0.499,
    opacity=1.0,
)

workspaces = [Group(i) for i in "1234567890"]
groups = [
    *workspaces,
    ScratchPad('scratch', [
            DropDown("term", "alacritty -e tmux new -As scratch", **scratch_args),
            DropDown("browser", "qutebrowser", **scratch_args),
            DropDown("python-repl", "alacritty -e python3"),
            DropDown("spotify", "spotify", **scratch_args),
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
