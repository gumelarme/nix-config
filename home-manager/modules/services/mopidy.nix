{
  pkgs,
  config,
  ...
}: {
  programs.ncmpcpp = {
    enable = true;
    settings = {
      statusbar_color = "blue";
      enable_window_title = "yes";
      header_window_color = "white";
      main_window_color = "248";

      current_item_prefix = "$(134)$r";
      current_item_suffix = "$/r";

      now_playing_prefix = "$b  $(2)";
      now_playing_suffix = "$/b";

      selected_item_prefix = "$5 >> ";
      selected_item_suffix = "$9";

      discard_colors_if_item_is_selected = "yes";

      song_status_format = "{%t - %a}";
      song_list_format = "$(123){%a} - $(134){%t}$R{%l}";
      song_columns_list_format = "(10f)[248]{lr|f:len} (40)[134]{t|f:title}  (20)[123]{a|f:artist} (20)[green]{b|f:album} ";
      song_window_title_format = "{%a} - {%t}|{%f}";
      progressbar_elapsed_color = "cyan:b";
      progressbar_color = "white";
      progressbar_look = "━󱋱━";

      user_interface = "alternative";
      alternative_ui_separator_color = "13";
      alternative_header_first_line_format = " $(167)$b%t$(138),$(end)$/b ";
      alternative_header_second_line_format = "$(138)from $(173)%b $(138)—%a (%y) ";
    };

    bindings = [
      {
        key = "j";
        command = "scroll_down";
      }
      {
        key = "h";
        command = "jump_to_parent_directory";
      }
      {
        key = "l";
        command = "enter_directory";
      }
      {
        key = "k";
        command = "scroll_up";
      }
      {
        key = "J";
        command = ["select_item" "scroll_down"];
      }
      {
        key = "K";
        command = ["select_item" "scroll_up"];
      }
      {
        key = "p";
        command = "previous_found_item";
      }
      {
        key = "n";
        command = "next_found_item";
      }
      {
        key = "m";
        command = "pause";
      }
    ];
  };

  services.mopidy = {
    enable = true;
    extensionPackages = with pkgs; [mopidy-local mopidy-mpd];
    extraConfigFiles = [];
    settings = {
      logging.verbosity = 0; # -1 to 4, higher = more info
      mpd.enabled = true;
      local = with builtins; let
        multilineStringWithIndent = list:
          concatStringsSep "\n " ([""] ++ list);
        formatKeyValue = k: v: k + "						" + v;
        attrToStringKeyValue = attr:
          attrValues (mapAttrs formatKeyValue attr);
      in {
        enabled = true;
        album_art_files = "*.jpg";
        media_dir = "${config.xdg.userDirs.music}";
        included_file_extensions = multilineStringWithIndent [
          ".flac"
          ".mp3"
          ".m4a"
          ".wav"
          # reserved
        ];
        directories = multilineStringWithIndent (attrToStringKeyValue {
          Albums = "local:directory?type=album";
          Artists = "local:directory?type=artist";
          Genres = "local:directory?type=genre";
          Tracks = "local:directory?type=track";
          LastWeek = "local:directory?max-age=604800";
        });
      };
    };
  };
}
