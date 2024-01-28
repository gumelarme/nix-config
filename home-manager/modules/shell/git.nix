{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.git;
in {
  options.modules.git = {
    global-gitignore = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        List of globally ignored file,
        useful if you dont want to pollute the .gitignore on project itself.
      '';
    };
  };

  config = {
    programs.git = {
      enable = true;
      userName = "gumelarme";
      userEmail = "gumelar.pn@gmail.com";
      extraConfig = {
        core = {
          excludesFile = let
            ignored-str = concatStringsSep "\n" cfg.global-gitignore;
            gitignore = pkgs.writeText "global_gitignore" ignored-str;
          in "${gitignore}";
        };
      };

      difftastic = {
        enable = true;
        background = "dark";
        display = "side-by-side";
      };

      aliases = {
        d = "diff";
        ds = "diff --staged";
        l = "log";
        lo = "log --graph --oneline";
        ls = "log --graph --name-status";
        stashes = "stash list";
        branches = "branch -a";
        remotes = "remote -v";
        uncommit = "reset --soft HEAD^";
        graph = "log --graph -10 --branches --remotes --tags --format=format:'%Cgreen%h %Creset• %<(75,trunc)%s (%cN, %cr) %Cred%d'";
      };
    };

    programs.gitui = {
      enable = true;
      keyConfig = builtins.readFile ./gitui/vim_style_key_config.ron;
    };

    xdg.configFile."gitui/key_symbols.ron".source = ./gitui/key_symbols.ron;
  };
}
