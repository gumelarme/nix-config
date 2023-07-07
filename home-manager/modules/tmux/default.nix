{ pkgs, config, ... }:

{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    mouse = true;
    extraConfig = builtins.readFile ./tmux.conf;
    plugins = let myplugins = (import ./plugins.nix) { inherit pkgs; };
    in with pkgs.tmuxPlugins; [
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
}
