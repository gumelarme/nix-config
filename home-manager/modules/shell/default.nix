{pkgs, ...}: {
  imports = [./git.nix ./nnn.nix ./shell.nix ./pet.nix ./zettel.nix];

  # z autojump
  programs.zoxide.enable = true;

  # C-r but better
  programs.atuin = {
    enable = true;
    package = pkgs.stable.atuin;
    enableZshIntegration = true;
    flags = ["--disable-up-arrow"];
    settings = {
      style = "compact";
      "inline_height" = 30;
    };
  };

  # ls but better
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    extraOptions = ["--group-directories-first"];
  };

  # fuzzy file finder
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # cat but better
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [batman prettybat];
    config = {theme = "Dracula";};
  };
}
