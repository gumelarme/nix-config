{pkgs, ...}:

{
  systemd.user.timers.lowbatt = {
    Unit = {
      Description = "Check battery level";
    };
    Timer = {
      OnBootSec = "2m";
      OnUnitInactiveSec = "1m";
      Unit = "lowbatt.service";
    };

    Install = {
      WantedBy = ["timers.target"];
    };

  };

  systemd.user.services.lowbatt = {
    Unit = {
      Description = "Battery level notifier";
    };
    Service = {
      PassEnvironment = "DISPLAY";
      # allow 'sleep' command to run, otherwise it will not wait
      TimeoutSec = "infinity";
      ExecStart =
        let
          notifier = "${pkgs.dunst}/bin/dunstify";
          cat = "${pkgs.coreutils}/bin/cat";
          cfg = {
            device = "BAT0";
            notify-capacity = 20;
            hibernate-capacity = 5;
            sysclass = "/sys/class/power_supply/${cfg.device}";
          };
          script = pkgs.writeScript "batteryNotifier" ''
            #!${pkgs.runtimeShell}

            battery_capacity=$(${cat} ${cfg.sysclass}/capacity)
            battery_status=$(${cat} ${cfg.sysclass}/status)

            if [[ $battery_capacity -le ${builtins.toString cfg.notify-capacity} && $battery_status == "Discharging" ]]; then
                ${notifier} -a "notifyBattery" \
                            -u critical \
                            -i battery \
                            -h int:value:"$battery_capacity" \
                            "Battery Low: ''${battery_capacity}%" \
                            "Please charge your battery"
            fi

            if [[ $battery_capacity -le ${builtins.toString cfg.hibernate-capacity} && $battery_status == "Discharging" ]]; then
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
