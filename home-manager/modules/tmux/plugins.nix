{pkgs, ...}: {
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
