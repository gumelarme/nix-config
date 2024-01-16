{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "gumelarme";
    userEmail = "gumelar.pn@gmail.com";
    delta = {
      enable = true;
      options = {
        decorations = { syntax-theme = "Dracula"; };
        features = "decorations";
        line-numbers = true;
      };
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
      uncommit = "git reset --soft HEAD^";
      graph =
        "log --graph -10 --branches --remotes --tags --format=format:'%Cgreen%h %Creset• %<(75,trunc)%s (%cN, %cr) %Cred%d'";
    };
  };

  programs.gitui = {
    enable = true;
    keyConfig = builtins.readFile ./gitui/vim_style_key_config.ron;
  };

  xdg.configFile."gitui/key_symbols.ron".source = ./gitui/key_symbols.ron;
}

