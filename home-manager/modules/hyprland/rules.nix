_: {
  workspace_rule = [
    {
      workspace = "special:scratch";
      border_size = 2;
      gaps_out = 60;
      # on_created_empty = "foot -e tmux -new -As scratch";
      on_created_empty = "foot";
    }
    {
      workspace = "special:hidden";
      border_size = 2;
      gaps_out = 20;
    }
    {
      workspace = "special:tools";
      border_size = 2;
      gaps_out = 20;
    }
  ];

  window_rule = [
    {
      name = "suppress fullscreen";
      match = {class = ".*";};
      suppress_event = "maximize";
    }

    {
      name = "make special workspace noticeable";
      match = {workspace = "s[true]";};
      rounding = 10;
      border_size = 2;
    }

    {
      name = "prevent idle on fullscreen";
      match = {class = ".*";};
      idle_inhibit = "fullscreen";
    }

    {
      name = "auto move to 'special:tools'";
      match = {class = "wechat|tauonmb|ticktick|Bitwarden";};
      workspace = "special:tools";
    }

    {
      name = "auto move to 'special:hidden'";
      match = {class = "anki|org.nicotine_plus.Nicotine|org.qbittorrent.qBittorrent";};
      workspace = "special:hidden";
      group = "set always";
    }

    {
      name = "make dev application floats";
      match = {initial_title = "dev\-.*";};
      float = true;
    }

    {
      name = "screen shot editor floats";
      match = {class = "com.gabm.satty";};
      float = true;
    }
  ];
}
