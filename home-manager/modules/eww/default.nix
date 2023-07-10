{ pkgs, ... }:

{
  home.packages = with pkgs; [ mpc-cli ffmpeg ];
  programs.eww = {
    enable = true;
    configDir = ./.;
  };
}
