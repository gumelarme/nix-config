_: {
  programs.nixvim = {
    plugins.neo-tree = {
      enable = true;
      enableDiagnostics = true;
      enableGitStatus = true;
      enableModifiedMarkers = true;
      closeIfLastWindow = true;
      enableRefreshOnWrite = true;
    };

    keymaps = [
      {
        key = "<leader>1";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Focus neotree";
      }
    ];
  };
}
