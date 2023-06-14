import os

from libqtile.lazy import lazy

def curdir(*paths):
    qtile_dir = os.path.expanduser("~/.config/qtile/")
    return os.path.join(qtile_dir, *paths)


def lazy_script(filename: str, *args):
    script = curdir("scripts", filename)
    return lazy.spawn(" ".join([script, *args]))
