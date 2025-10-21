_: {
  programs.nixvim = {
    plugins.neo-tree = {
      enable = true;
      settings = {
        enable_diagnostics = true;
        enable_git_status = true;
        enable_modified_markers = true;
        close_if_last_window = true;
        enable_refresh_on_write = true;
      };
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
