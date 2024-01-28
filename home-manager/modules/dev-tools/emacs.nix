{ pkgs, ... }: {
  home.packages = with pkgs; [
    sqlite # Org roam
    findutils # find, grep, etc
  ];

  services.emacs = {
    enable = true;
    client = {
      enable = true;
      arguments = [ "--reuse-frame" "--no-wait" ];
    };
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs29.override ({
      withTreeSitter = true;
      withSQLite3 = true;
      withXinput2 = true;
    });
  };
}
