{ lib, pkgs, config, ... }:

{
  imports = [ ./git.nix ./nnn.nix ];

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

  programs.zoxide.enable = true;

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      style = "compact";
      "inline_height" = 30;
    };
  };

  programs.eza = {
    enable = true;
    enableAliases = true;
    git = true;
    extraOptions = [ "--group-directories-first" ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = false; # use mcfly instead
  };

  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [ batman prettybat ];
    config = { theme = "Dracula"; };
  };

  home.sessionVariables = {
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib";
  };

  home.packages = with pkgs;
    [
      imagemagick
      zlib
      gcc-unwrapped
      # clang
      fd
      pandoc
      ripgrep
      ripgrep-all # for pdfs, zip, docx etc.
      termdown
      tealdeer
      tree
      less
      glow
      # Add scripts to bin from file
    ] ++ (let
      fileToScripts = file:
        pkgs.writeShellScriptBin (builtins.baseNameOf file)
        (builtins.readFile file);
      getFilesFromDir = dir: files: map (f: dir + "/${f}") files;
    in map fileToScripts (getFilesFromDir ./scripts [ "mywacom" ]));
}
