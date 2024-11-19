{pkgs, ...}: {
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
