{pkgs, ...}: {
  fzf-session-switch = pkgs.tmuxPlugins.mkTmuxPlugin rec {
    pname = "fzf-session-switch";
    version = "v2.1";
    pluginName = pname;
    rtpFilePath = "main.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "cutbypham";
      repo = "tmux-fzf-session-switch";
      rev = "d53547e0efd70230d6e7b59e992727fb80f72d83";
      hash = "sha256-LwLheBgHTmDZs61D5IV0p+JMrYWVC+axkyYvqU6e9OY=";
    };
  };

  tmux-buoyshell = pkgs.tmuxPlugins.mkTmuxPlugin rec {
    pname = "tmux-buoyshell";
    version = "v0";
    pluginName = pname;
    rtpFilePath = "buoyshell.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "navahas";
      repo = "tmux-buoyshell";
      rev = "1a482a820c86a3d0cb5a543e5527f2f5a9fec2b9";
      hash = "sha256-xSXsbDPHa1OVwpWUTShesgtzRe+940n/fiMPRMYwIwc=";
    };
  };
}
