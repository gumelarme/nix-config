{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    qmk
    via
    libinput-gestures
    lm_sensors
    acpilight
  ];

  # steam, fix glxChooseVisual failed
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Scanner
  hardware.sane.enable = true;
  # services.ipp-usb.enable=true;

  # Wacom
  # services.xserver.wacom.enable = true;
  # hardware.opentabletdriver.enable = true;

  services.thinkfan = {
    enable = true;
  };

  # Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket"; # Enable A2DP
        Name = "kasuari-default";
        ControllerMode = "dual";
        FastConnectable = "true";
        Experimental = "true";
      };

      Policy = {
        AutoEnable = "true";
      };
    };
  };

  # Input
  hardware.keyboard.qmk = {
    enable = true;
    keychronSupport = true;
  };

  services.udev.packages = [pkgs.via];

  services.fprintd = {
    # Works, but cannot reduce the timeout or bypass to password directly
    # https://github.com/NixOS/nixpkgs/issues/171136
    # https://www.reddit.com/r/Fedora/comments/kx52nz/disable_fingerprint_reader_when_using_sudo/
    enable = false;
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-vfs0090;
  };

  services.libinput = {
    enable = true;
    mouse.accelSpeed = "1.0";
    touchpad.accelSpeed = "1.0";
  };

  services.kanata = {
    enable = true;
    keyboards.default = {
      extraDefCfg = "process-unmapped-keys yes";
      config = builtins.readFile ./kanata/config.kbd;
    };
  };
}
