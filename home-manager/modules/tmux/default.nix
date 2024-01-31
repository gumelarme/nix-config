{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.tmux;
in {
  options.modules.tmux.enable = mkEnableOption "Enable tmux";
  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      keyMode = "vi";
      mouse = true;
      extraConfig = let
        configFile = builtins.readFile ./tmux.conf;
        terminal =
          if pkgs.stdenv.isDarwin
          then "screen"
          else "tmux";
      in
        concatStringsSep "\n"
        [
          ''set -g default-terminal "${terminal}-256color"''
          configFile
        ];
      plugins = let
        myplugins = (import ./plugins.nix) {inherit pkgs;};
      in
        with pkgs.tmuxPlugins; [
          catppuccin
          fuzzback
          extrakto

          {
            plugin = myplugins.fzf-session-switch;
            extraConfig = "set -g @fzf-goto-session 'S'";
          }
          {
            plugin = myplugins.capture-last-output;
            extraConfig = ''
              set -g @command-capture-key o
              set -g @command-capture-prompt-pattern '${config.home.username} at'
            '';
          }
        ];
    };
  };
}
