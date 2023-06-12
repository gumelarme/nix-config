from libqtile import hook, qtile

win_list = []

def stick_win(qtile):
    global win_list
    win_list.append(qtile.current_window)

def unstick_win(qtile):
    global win_list
    if qtile.current_window in win_list:
        win_list.remove(qtile.current_window)

@hook.subscribe.setgroup
def move_win():
    for w in win_list:
        w.togroup(qtile.current_group.name)
