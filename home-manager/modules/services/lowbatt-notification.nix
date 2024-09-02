{pkgs, ...}: {
  systemd.user.timers.lowbatt = {
    Unit = {Description = "Check battery level";};
    Timer = {
      OnBootSec = "2m";
      OnUnitInactiveSec = "1m";
      Unit = "lowbatt.service";
    };

    Install = {WantedBy = ["timers.target"];};
  };

  systemd.user.services.lowbatt = {
    Unit = {Description = "Battery level notifier";};
    Service = {
      PassEnvironment = "DISPLAY";
      # allow 'sleep' command to run, otherwise it will not wait
      TimeoutSec = "infinity";
      ExecStart = let
        notifier = "${pkgs.dunst}/bin/dunstify";
        cat = "${pkgs.coreutils}/bin/cat";
        cfg = {
          device = "BAT0";
          notify-low-capacity = 20;
          notify-full-capacity = 95;
          stop-notify-full-capacity = 98;
          hibernate-capacity = 5;
          sysclass = "/sys/class/power_supply/${cfg.device}";
        };
        script = pkgs.writeScript "batteryNotifier" ''
          #!${pkgs.runtimeShell}

          battery_capacity=$(${cat} ${cfg.sysclass}/capacity)
          battery_status=$(${cat} ${cfg.sysclass}/status)

          # Note the 'not equal "Discharging"', because it could be plugged and the status still says 'Not Charging' but not discharging
          # It will notify to stop charging between 95-98, after that it will go silent
          if [[ $battery_capacity -ge ${
            builtins.toString cfg.notify-full-capacity
          }
          && $battery_capacity -lt ${builtins.toString cfg.stop-notify-full-capacity}
          && $battery_status != "Discharging" ]]; then
            ${notifier} -a "notifyBattery" \
                        -u normal \
                        -i battery \
                        "Battery almost full: ''${battery_capacity}%" \
                        "Maybe you can unplug now"
          fi

          if [[ $battery_capacity -le ${
            builtins.toString cfg.notify-low-capacity
          } && $battery_status == "Discharging" ]]; then
              ${notifier} -a "notifyBattery" \
                          -u critical \
                          -i battery \
                          -h int:timeout:30 \
                          -h int:value:"$battery_capacity" \
                          "Battery Low: ''${battery_capacity}%" \
                          "Please charge your battery"
          fi

          if [[ $battery_capacity -le ${
            builtins.toString cfg.hibernate-capacity
          } && $battery_status == "Discharging" ]]; then
              ${notifier} -a "notifyBattery" \
                          -u critical \
                          -i battery \
                          -h int:timeout:30 \
                          -h int:value:"$battery_capacity" \
                          "Battery Critically Low: ''${battery_capacity}%" \
                          "Will hibernate in 60s"

              sleep 60

              # Reread battery status after 60s
              battery_status=$(${cat} ${cfg.sysclass}/status)
              if [[ $battery_status == "Discharging" ]]; then
                 systemctl hibernate
              fi

          fi

        '';
      in "${script}";
    };
  };
}
