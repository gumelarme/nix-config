{ lib, pkgs, config, ... }:

{
  imports = [ ./git.nix ./nnn.nix ./shell.nix ];

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

  programs.pet = {
    # TODO: configure gists
    enable = true;
    settings = {
      General = {
        editor = "vim";
        selectcmd = "fzf --ansi";
      };
    };
  };

  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [ batman prettybat ];
    config = { theme = "Dracula"; };
  };

  # home.sessionVariables = {
  #   LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [ stdenv.cc.cc zlib ];
  # };

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
