{ lib, pkgs, config, ... }:

{
  home.sessionVariables = { PROXYADDR = "http://localhost:20171"; };
  programs.zsh = {
    # Use to profile zsh load time
    # use command `zprof` to see the results
    # initExtraFirst = "zmodload zsh/zprof";

    enable = true;
    enableCompletion = true;
    shellAliases = {
      g = "git";
      s = "git status";
      mucik = "ncmpcpp";
      gitroot = "cd $(git rev-parse --show-toplevel)";
      pbcopy = "xclip -selection clipboard";
      pbpaste = "xclip -selection clipboard -o";
      pp = "pet exec --color --command";
      ns = "nix-shell --command zsh -p";
      va = "source ./venv/bin/activate";
      vd = "deactivate";
      prox-show = "echo http  = $http_proxy \\\\nhttps = $https_proxy";
      prox-set =
        "export http_proxy=$PROXYADDR && export https_proxy=$PROXYADDR && prox-show";
      prox-rm = "unset http_proxy && unset https_proxy && prox-show";
    };

    plugins = [{
      name = "prezto-completion";
      file = "init.zsh";
      src = (pkgs.fetchFromGitHub {
        owner = "sorin-ionescu";
        repo = "prezto";
        rev = "c0cdc12708803c4503cb1b3d7d42e5c1b8ba6e86";
        hash = "sha256-4ADfaRgOo2AoJBiDOIl/GlG9C02BPLVwo8YjumWqC2o=";
      }) + "/modules/completion";
    }];

    initExtra = let read = builtins.readFile;
    in builtins.concatStringsSep "\n" [
      # Bind Shift-Tab to go to prev completion item
      # what? https://unix.stackexchange.com/questions/84867/zsh-completion-enabling-shift-tab
      "bindkey '^[[Z' reverse-menu-complete"

      # enable line editor with Ctrl-v
      "autoload -z edit-command-line"
      "zle -N edit-command-line"
      "bindkey -M vicmd '^v' edit-command-line"

      # nnn configs
      (read ./scripts/nnn-config)
      (read ./scripts/nnn-quitcd)

      # `pet search` and put it on the line
      (read ./scripts/pet-select)
    ];
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$localip"
        "$shlvl"
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_metrics"
        "$git_status"
        "$python"
        "$fill"
        "$battery"
        "$cmd_duration"
        "$status"
        "$line_break"
        "$character"
        "$line_break"
      ];

      fill.symbol = " ";
      status.disabled = false;
      package.disabled = true;

      directory = {
        truncation_length = 6;
        truncation_symbol = "::";
        format = "[$path]($style)[( $read_only)]($read_only_style) ";
        read_only = "[R]";
        read_only_style = "bold red";
      };

      battery = {
        display = [{
          threshold = 30;
          style = "red bold";
        }];
      };
    };
  };

}
