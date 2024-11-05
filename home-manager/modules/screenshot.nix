{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.modules.screenshot;
in {
  options.modules.screenshot = {
    displayMode = mkOption {
      type = types.enum ["wayland" "x"];
      description = "Screenshot tools different for each display server";
    };
  };

  config = let
    isWayland = cfg.displayMode == "wayland";
  in {
    home.packages = with pkgs;
      mkMerge [
        (mkIf isWayland [
          grim # screenshot
          slurp # select region on the screen
          satty # edit image after screenhost
        ])

        (mkIf (!isWayland) [
          flameshot
        ])
      ];

    programs.zsh.shellAliases = let
      grim = "${pkgs.grim}/bin/grim";
      slurp = "${pkgs.slurp}/bin/slurp";
      satty = "${pkgs.satty}/bin/satty";
    in
      mkMerge [
        (mkIf isWayland {
          snap-save = ''${grim} -g "$(${slurp})" - | ${satty} -f - -o '';
        })
        # TODO: implement flameshot commands
      ];

    home.file."${config.common.configHome}/satty/config.toml".text = mkIf isWayland ''
      [general]
      fullscreen = false
      early-exit = false

      # [possible values: pointer, crop, line, arrow, rectangle, text, marker, blur, brush]
      initial-tool = "rectangle"
      copy-command = "wl-copy"
      annotation-size-factor = 1

      # Filename to use for saving action. Omit to disable saving to file. Might contain format specifiers: https://docs.rs/chrono/latest/chrono/format/strftime/index.html
      output-filename = "${config.common.screenshot}/snap-%Y%m%d-%H%M%S.png"

      # After copying the screenshot, save it to a file as well
      save-after-copy = false
      default-hide-toolbars = false
      primary-highlighter = "block"
      disable-notifications = false

      [font]
      family = "monospace"
      style = "Bold"
    '';
  };
}
