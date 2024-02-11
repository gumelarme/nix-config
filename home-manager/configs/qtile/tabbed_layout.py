from libqtile import hook, qtile


def toggle_tab_bar(screen=None, offset=0):
    if screen is None:
        screen = qtile.current_screen

    main_bar, tab_bar = screen.top, screen.bottom

    def enable_tab_bar(status: bool):
        tab_bar.show(status)
        main_bar.show(not status)

    # TODO: prevent toggling when scratchpad is oopen
    if screen.group.layout.name == "max":
        window_count = len(screen.group.windows) + offset
        if window_count > 1:
            enable_tab_bar(True)
        else:
            if tab_bar.window:
                enable_tab_bar(False)
    else:
        if tab_bar.window:
            enable_tab_bar(False)


@hook.subscribe.client_killed
def update_tabs_client_killed(window):
    toggle_tab_bar(offset=-1)


@hook.subscribe.group_window_add
def update_tabs_group_window_add(group, window):
    toggle_tab_bar(offset=1)


@hook.subscribe.layout_change
def update_tabs_layout_change(layout, group):
    toggle_tab_bar()


@hook.subscribe.setgroup
def update_tabs_setgroup():
    for screen in qtile.screens:
        toggle_tab_bar(screen)


@hook.subscribe.startup_complete
def update_tabs_startup_complete():
    for screen in qtile.screens:
        toggle_tab_bar(screen)
