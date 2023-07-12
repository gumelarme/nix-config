{ pkgs, config, ... }:

{
  imports = [ ./git.nix ./nnn.nix ];

  programs.zsh = {
    enable = true;
    shellAliases = {
      g = "git";
      s = "git status";
      mucik = "ncmpcpp";
      gitroot = "cd $(git rev-parse --show-toplevel)";
      pbcopy = "xclip -selection clipboard";
      pbpaste = "xclip -selection clipboard -o";
    };

    # enableSyntaxHighlighting = true; # breaks edit-command-line bindings
    prezto = {
      enable = true;
      editor.keymap = "vi";
      prompt = {
        theme = "steeef";
        pwdLength = "long";
      };
    };

    initExtra = ''
      bindkey -M vicmd '^v' edit-command-line
    '' + (builtins.readFile ./scripts/nnn-config)
      + (builtins.readFile ./scripts/nnn-quitcd);
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

  programs.exa = {
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

  home.packages = with pkgs;
    [
      imagemagick
      clang
      fd
      pandoc
      ripgrep
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
