from libqtile import bar, widget

class Color:
    Background = "#282a36"
    CurrentLine = "#44475a"
    Selection = "#44475a"
    Foreground = "#f8f8f2"
    Comment = "#6272a4"
    Cyan = "#8be9fd"
    Green = "#50fa7b"
    Orange = "#ffb86c"
    Pink = "#ff79c6"
    Purple = "#bd93f9"
    Red = "#ff5555"
    Yellow = "#f1fa8c"



clock = widget.Clock(
    format="%a, %Y-%m-%d %H:%M",
    font="Noto Sans Mono",
    fontsize=14,
)

battery = widget.Battery(
    fmt="电 {}",
    format="{char} {percent:2.0%}",
    background=Color.Green,
    foreground=Color.Background,
    low_background=Color.Red,
    low_foreground=Color.Foreground,
    low_percentage=0.2,
    charge_char="󱐋",
    discharge_char="",
)

group_box = widget.GroupBox(
    highlight_method="block",
    fmt="{}",
    inactive=Color.Selection,
    active=Color.Foreground,
    background="#000000",
    rounded=False,
    padding=4,
    this_current_screen_border=Color.Pink,
    this_screen_border='#7d3d62',
    other_current_screen_border="#db882e",
    other_screen_border="#a17445",
    font="DejaVu Sans Mono Bold",
)

volume = widget.Volume(
    fmt="音 {}",
    background=Color.Cyan,
    foreground=Color.Background,
)

window_name = widget.WindowName(
    max_chars=50,
    format="{state} {name}",
)

window_count = widget.WindowCount(
    text_format="/{num}/",
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

# separator = widget.Sep(foreground="#000000.0", background="#000000.0", padding=10)
separator = widget.Spacer(length=10)
curscreen_opt = dict(
    active_text="",
    inactive_text="󰝤",
    active_color=Color.Green,
    inactive_color=Color.Comment,
    fontsize=14,
    padding=8,
)

mpd = widget.Mpd2(
    status_format = '{play_status}  {artist} - {title} %{repeat}{random}{single}{consume}{updating_db}',
    idle_format = '{play_status}  {idle_message} %{repeat}{random}{single}{consume}{updating_db}',
    idle_message = "/MPD/",
    space = "",
    play_states = {
        "play": "",
        "pause": "",
        "stop": "",
    }
)

backlight  = widget.Backlight(
    backlight_name="amdgpu_bl0",
    fmt="亮: {}",
    background=Color.Purple,
    foreground=Color.Background,
    step=2,
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
        widget.Spacer(),
        widget.WidgetBox(
            background=Color.Background,
            fontsize=16,
            text_open=" 󰧚 ",
            text_closed=" 󰧘 ",
            close_button_location="right",
            widgets=[
                backlight,
                separator,
                mpd,
            ]
        ),
        separator,
        widget.Systray(),
        separator,
        volume,
        separator,
        battery,
    ],
    background="#1a1b24",
    opacity=0.9, # placing opacity on background cause system tray to turn blue
    size=26,
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
    background="#1a1b24.9",
    size=26,
    opacity=1,
)



