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
    userName = mkOption {
      type = types.str;
      description = "Git user name";
    };

    userEmail = mkOption {
      type = types.str;
      description = "Git user email";
    };
  };

  config = {
    programs.gh = {
      enable = true;
      extensions = with pkgs; [
        gh-markdown-preview
      ];
    };
    programs.git = {
      inherit (cfg) userName userEmail;
      enable = true;
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
        ls = "log --graph --name-status";
        dog = "log --decorate --oneline --graph";
        dogs = "log --decorate --oneline --graph --stat";
        stashes = "stash list";
        branches = "branch -a";
        remotes = "remote -v";
        uncommit = "reset --soft HEAD^";
      };
    };

    programs.gitui = {
      enable = true;
      keyConfig = builtins.readFile ./gitui/vim_style_key_config.ron;
    };

    xdg.configFile."gitui/key_symbols.ron".source = ./gitui/key_symbols.ron;
  };
}
