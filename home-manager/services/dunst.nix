{pkgs, ... }:

{
  services.dunst = {
    enable = true;
    # configFile = ./home/.config/dunst/dunstrc;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
      size = "16x16";
    };
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        width = 300;
        height = 300;
        origin = "top-right";
        offset = "5x30";
        scale = 0;
        notification_limit = 0; # 0 means no limit
        progress_bar = true;
        progress_bar_height = 15;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;

        # Show how many messages are currently hidden (because of
        # notification_limit).
        indicate_hidden = "yes";

        transparency = 10;
        separator_height = 1;
        padding = 8;
        horizontal_padding = 10;
        text_icon_padding = 0;
        frame_width = 0;
        frame_color = "#282a36";

        # Define a color for the separator.
        # possible values are:
        #  * auto: dunst tries to find a color fitting to the background;
        #  * foreground: use the same color as the foreground;
        #  * frame: use the same color as the frame;
        #  * anything else will be interpreted as a X color.
        separator_color = "frame";

        # Sort messages by urgency.
        sort = "yes";

        # Don't remove messages, if the user is idle (no mouse or keyboard input)
        # for longer than idle_threshold seconds.
        # Set to 0 to disable.
        # A client can set the 'transient' hint to bypass this. See the rules
        # section for how to disable this if necessary
        idle_threshold = 120;

        ### Text ###

        font = "Noto Sans Display 12";
        line_height = 0;

        # Possible values are:
        # full: Allow a small subset of html markup in notifications:
        #        <b>bold</b>
        #        <i>italic</i>
        #        <s>strikethrough</s>
        #        <u>underline</u>
        #
        #        For a complete reference see
        #        <https://developer.gnome.org/pango/stable/pango-Markup.html>.
        #
        # strip: This setting is provided for compatibility with some broken
        #        clients that send markup even though it's not enabled on the
        #        server. Dunst will try to strip the markup but the parsing is
        #        simplistic so using this option outside of matching rules for
        #        specific applications *IS GREATLY DISCOURAGED*.
        #
        # no:    Disable markup parsing, incoming notifications will be treated as
        #        plain text. Dunst will not advertise that it has the body-markup
        #        capability if this is set as a global setting.
        #
        # It's important to note that markup inside the format option will be parsed
        # regardless of what this is set to.
        markup = "full";

        # The format of the message.  Possible variables are:
        #   %a  appname
        #   %s  summary
        #   %b  body
        #   %i  iconname (including its path)
        #   %I  iconname (without its path)
        #   %p  progress value if set ([  0%] to [100%]) or nothing
        #   %n  progress value if set without any extra characters
        #   %%  Literal %
        # Markup is allowed
        format = "%s %p\n%b";

        # Alignment of message text.
        # Possible values are "left", "center" and "right".
        alignment = "left";
        # Possible values are "top", "center" and "bottom".
        vertical_alignment = "center";
        show_age_threshold = 60;

        # Specify where to make an ellipsis in long lines.
        # Possible values are "start", "middle" and "end".
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";
        min_icon_size = 0;
        max_icon_size = 64;
        sticky_history = "yes";
        history_length = 20;
        ### Misc/Advanced ###

        dmenu = "/usr/bin/dmenu -p dunst";
        # browser = "/usr/bin/firefox -new-tab";
        # Always run rule-defined scripts, even if the notification is suppressed
        always_run_script = true;

        # Define the title & class of the windows spawned by dunst
        title = "Dunst";
        class = "Dunst";
        ### mouse

        # Defines list of actions for each mouse event
        # Possible values are:
        # * none: Don't do anything.
        # * do_action: Invoke the action determined by the action_name rule. If there is no
        #              such action, open the context menu.
        # * open_url: If the notification has exactly one url, open it. If there are multiple
        #             ones, open the context menu.
        # * close_current: Close current notification.
        # * close_all: Close all notifications.
        # * context: Open context menu for the notification.
        # * context_all: Open context menu for all notifications.
        # These values can be strung together for each mouse event, and
        # will be executed in sequence.
        mouse_left_click = "close_current";
        mouse_middle_click = ["do_action close_current"];
        mouse_right_click = "close_all";
      };

      urgency_low = {
          background = "#282a36";
          # foreground = "#6272a4";
          foreground = "#8f9dc9";
          timeout = 10;
          #new_icon = /path/to/icon
      };

      urgency_normal = {
          background = "#282a36";
          foreground = "#bd93f9";
          timeout = 10;
      };

      urgency_critical = {
        background = "#ff5555";
        foreground = "#f8f8f2";
        frame_color = "#ff5555";
        timeout = 0;
      };
    };
  };
}
