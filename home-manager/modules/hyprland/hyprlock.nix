{pkgs, ...}: {
  services.hypridle = {
    enable = true;
    settings = let
      brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
    in {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
        after_sleep_cmd = " hyprctl dispatch dpms on "; # to avoid having to press a key twice to turn on the display.
      };

      listener = [
        {
          timeout = 10; # 3 minutes
          on-timeout = "${brightnessctl} -s set 10";
          on-resume = "${brightnessctl} -r";
        }

        {
          timeout = 15; # 5 minutes
          on-timeout = "loginctl lock-session";
        }

        {
          timeout = 330; # 5.5min
          on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on && ${brightnessctl} -r"; # screen on when activity is detected after timeout has fired.
        }

        {
          timeout = 1800; # 30min
          on-timeout = "systemctl suspend"; # suspend pc
        }
      ];
    };
  };

  programs.hyprlock.enable = true;
  programs.hyprlock.settings = let
    default_font = "Monospace";
    cjk_font = "Noto Serif CJK SC";
  in {
    general = {
      hide_cursor = false;
      text_trim = true;
      fail_timeout = 2000;
    };

    auth = {
      pam = {
        enabled = true;
      };

      fingerprint = {
        enabled = false;
        ready_message = "Scan fingerprint to unlock";
        present_message = "Scanning...";
        retry_delay = 250; # in milliseconds
      };
    };

    animations = {
      enabled = true;
      bezier = "linear, 1, 1, 0, 0";
      animation = [
        "fadeIn, 1, 5, linear"
        "fadeOut, 1, 5, linear"
        "inputFieldDots, 1, 0.5, linear"
      ];
    };

    background = {
      monitor = "";
      path = "/home/kasuari/sync/backup-kasuari-just-before-2023-china/pics/wallpaper/kumamon.png";
      blur_passes = 1;
    };

    input-field = {
      monitor = "";
      size = "14%, 5%";
      outline_thickness = 3;
      inner_color = "rgba(0, 0, 0, 0.0)"; # no fill
      outer_color = "rgba(ff0000ff) rgba(fc9300ff) 225deg";
      check_color = "rgba(00ff99ee) rgba(ff6633ee) 120deg";
      fail_color = "rgba(ccccccee)";

      font_color = "rgb(143, 143, 143)";
      fade_on_empty = false;
      rounding = 0;

      font_family = default_font;
      placeholder_text = "locked";
      fail_text = "$PAMFAIL";

      # uncomment to use a letter instead of a dot to indicate the typed password
      # dots_text_format = *
      dots_size = 0.35;
      dots_spacing = 0.3;

      position = "0, 0";
      halign = "center";
      valign = "center";
    };

    label = [
      {
        monitor = "";
        text = "$TIME"; # ref. https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/#variable-substitution
        font_size = 63;
        font_family = default_font;
        position = "-35, 250";
        halign = "right";
        valign = "bottom";
      }

      # Chinese Day of Week
      {
        monitor = "";
        text = ''
          cmd[update:60000] suffix=$(echo "日一二三四五六" | awk -v dow=$(date +"%w") '{print substr($0,dow,1)}'); echo -n "<span allow_breaks='true'>周''${suffix}</span>"
        '';
        font_size = 100;
        font_family = cjk_font;
        position = "-30, 100";
        halign = "right";
        valign = "bottom";
      }

      # Date
      {
        monitor = "";
        text = ''
          cmd[update:60000] date +"%m月 %d日"
        '';
        font_size = 50;
        font_family = cjk_font;

        position = "-30, 30";
        halign = "right";
        valign = "bottom";
      }
    ];
  };
}
