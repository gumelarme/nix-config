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
}
