{pkgs, ...}: {
  systemd.user.timers.dingdong = {
    Unit.Description = "Hourly alarm notifications";
    Timer = {
      # https://wiki.archlinux.org/title/Systemd/Timers
      # Run every days, at every hours
      # In the format of DayOfWeek Year-Month-Day Hour:Minute:Second
      OnCalendar = "*-*-* *:00:00";
      Persistent = false;
      Unit = "dingdong.service";
    };

    Install.WantedBy = ["timers.target"];
  };

  systemd.user.services.dingdong = {
    Unit.Description = "Dingdong notification";
    Service = {
      PassEnvironment = "DISPLAY";
      ExecStart = let
        notifier = "${pkgs.dunst}/bin/dunstify";
        date = "${pkgs.coreutils}/bin/date";
        timeout = toString 10000;
        script = pkgs.writeScript "dingdongNotifier" ''
          #!${pkgs.runtimeShell}

          the_time=$(${date} +"%H:%M")

          ${notifier} -a "dingdong" \
                      -i clock \
                      -t ${timeout} \
                      "Ding-dong ding-dong" \
                      "Its $the_time already!!"
        '';
      in "${script}";
    };
  };
}
