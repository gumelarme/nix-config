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
        concatStringsSep "\n" [
          ''set -g default-terminal "${terminal}-256color"''
          configFile
        ];
      plugins = let
        myplugins = (import ./plugins.nix) {inherit pkgs;};
      in
        with pkgs.tmuxPlugins; [
          myplugins.tmux-grimoire
          tmux-nova
          fuzzback
          extrakto
          {
            plugin = tmux-nova;
            extraConfig = ''
              set -g @nova-nerdfonts true
              set -g @nova-nerdfonts-left 
              set -g @nova-nerdfonts-right 

              set -g @nova-segment-mode "#{?client_prefix,X,O}"
              set -g @nova-segment-mode-colors "#50fa7b #282a36"

              set -g @nova-segment-session "#{session_name}"
              set -g @nova-segment-session-colors "#50fa7b #282a36"

              set -g @nova-pane "#I#{?pane_in_mode,: #{pane_mode},}: #W"

              set -g @nova-rows 0
              set -g @nova-segments-0-left "mode"
              set -g @nova-segments-0-right "session"
            '';
          }

          {
            plugin = session-wizard;
            extraConfig = ''
              set -g @session-wizard 'S'
            '';
          }

          {
            plugin = resurrect;
            extraConfig = ''
              set -g @resurrect-dir '${config.common.configHome}/tmux/resurrect'
            '';
          }
        ];
    };
  };
}
