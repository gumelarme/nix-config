# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = final;};

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    corefonts = import ./corefonts.nix {inherit final prev;};
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  # By default using the unstable packages,
  # stable packages accessible through 'pkgs.stable.package-name'
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };

  nixos-2311-packages = final: _prev: {
    nixos-2311 = import inputs.nixpkgs-2311 {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };

  nixos-2411-packages = final: _prev: {
    nixos-2411 = import inputs.nixpkgs-2411 {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };

  nur-packages = _final: prev: {
    nur = import inputs.nur {
      nurpkgs = prev;
      pkgs = prev;
    };
  };

  darwin-packages = final: _prev: {
    darwin-pkgs = import inputs.nixpkgs-darwin {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };

  custom-packages = _final: _prev: {
    # TODO: fix import
    custom = {
      matcha = inputs.matcha-idle-inhibitor.packages.x86_64-linux.default;
      tiny-bar = inputs.my-tiny-bar.packages.x86_64-linux.default;
    };
  };
}
