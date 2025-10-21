{pkgs, ...}: {
  tmux-grimoire = pkgs.tmuxPlugins.mkTmuxPlugin rec {
    pname = "grimoire";
    version = "v0";
    pluginName = pname;
    rtpFilePath = "grimoire.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "navahas";
      repo = "tmux-grimoire";
      rev = "94b3f0087289ec5cbeb9cc225ab665661d55123c";
      hash = "sha256-oLtOO0vclwwVLYnWCY0nG+QGAdYik6L04eR606IHnW0";
    };
  };
}
