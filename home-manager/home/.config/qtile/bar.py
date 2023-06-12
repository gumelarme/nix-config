from libqtile import bar, widget
# from qtile_extras import widget as widgetx


clock = widget.Clock(
    format="%a, %Y-%m-%d %I:%M %p",
    font="DejaVu Sans Mono",
    fontsize=14,
    padding=12,
)

battery = widget.Battery(
    fmt="BAT: {}",
    format="{char} [{percent:2.0%}]",
    background="#005500",
    low_background="#ff0000",
    low_foreground="#ffffff",
    discharge_char="V",
)

group_box = widget.GroupBox(
    highlight_method="block",
    highlight_color=["#FF0000", "#FF0000"],
    background="#000000",
    rounded=False,
    padding=4,
    this_current_screen_border='#2245b5',
    this_screen_border='#26314a',
    other_current_screen_border='#d64e20',
    other_screen_border='#733410',
)

volume = widget.Volume(
    fmt="VOL: {}",
    background="#0e5473",
    foreground="#ffffff",
)

wlan = widget.Wlan(
    interface="wlp3s0",
    format="{essid} {percent:2.0%}",
    disconnected_message="-",
    font="DejaVu Sans Mono",
    fontsize=14,
)

window_name = widget.WindowName(
    max_chars=50,
    format="{state} {name}",
)

window_count = widget.WindowCount(
    font="DejaVu Sans Mono",
    fontsize=14,
    text_format=":{num}:",
)

pomodoro = widget.Pomodoro(
    background="#cf3915",
    color_active="#ffffff",
    color_break="#000000",
    color_inactive="#691905",
    prefix_inactive="[--]",
    font="DejaVu Sans Mono Bold",
    fontsize=14,
)

separator = widget.Sep(foreground="#000000")
notification = widget.Notify(fmt="!!: {}")

curscreen_opt = dict(
    # active_text="\u25A0",
    # inactive_text="\u25A0",
    active_text="[+]",
    inactive_text="[-]",
    font="DejaVu Sans Mono Bold",
    fontsize=14,
)

main_bar = bar.Bar(
    widgets=[
        widget.CurrentLayoutIcon(),
        widget.CurrentScreen(**curscreen_opt),
        group_box,
        window_count,
        widget.WindowName(
            max_chars=50,
            format="{state} {name}",
        ),
        clock,
        widget.TextBox(fmt="::", padding=None),
        wlan,
        widget.Spacer(),
        # notification,
        pomodoro,
        separator,
        widget.Bluetooth(),
        separator,
        volume,
        separator,
        battery,
        # widgetx.WiFiIcon()
        widget.Systray(),
    ],
    size=26,
    opacity=0.85,
)


alt_bar = bar.Bar(
    widgets=[
        widget.CurrentLayoutIcon(),
        widget.CurrentScreen(**curscreen_opt),
        group_box,
        window_name,
        widget.Spacer(),
        clock,
    ],
    size=26, 
    opacity=0.85,
)



