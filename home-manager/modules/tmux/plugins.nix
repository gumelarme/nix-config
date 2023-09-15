{ pkgs, ... }:

{
  capture-last-output = pkgs.tmuxPlugins.mkTmuxPlugin rec {
    pname = "tmux-capture-last-command-output";
    version = "bd2cca21bc32c2d6652d7b6fdc36cd61409ddd73";
    pluginName = pname;
    src = pkgs.fetchFromGitHub {
      owner = "artemave";
      repo = "tmux_capture_last_command_output";
      rev = version;
      hash = "sha256-mjk+K6uI5sw3a41NaZLuxXhnYgilZ4VpoaPLp8fgEGk=";
    };
  };

  fzf-session-switch = pkgs.tmuxPlugins.mkTmuxPlugin rec {
    pname = "fzf-session-switch";
    version = "v2.1";
    pluginName = pname;
    rtpFilePath = "main.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "thuanOwa";
      repo = "tmux-fzf-session-switch";
      rev = "ae8d4f79ef5dda88bb5c5c6687b14a0a6fe0ba09";
      hash = "sha256-Hn4huMRe2RrBkwh7XsQCKotABkp89OtHgrCCOXnbOAs=";
    };
  };

}
