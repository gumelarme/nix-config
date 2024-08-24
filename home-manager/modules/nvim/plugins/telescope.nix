{
  config,
  lib,
  ...
}: let
  cfg = config.modules.neovim;
in {
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      globals.mapleader = " ";
      # TODO: Telescope find and insert filepath
      plugins.telescope = {
        enable = true;
        keymaps = {
          "<leader>pf" = {
            action = "find_files";
            options = {
              desc = "Find project files";
            };
          };

          "<leader>sp" = {
            action = "live_grep";
            options = {
              desc = "Search project";
            };
          };

          "<leader>bb" = {
            action = "buffers";
            options = {
              desc = "Find buffers";
            };
          };

          # NOTE: Depends on: commentary
          "gcc" = {
            action = "<cmd>Commentary<CR>";
            options = {
              desc = "Comment";
            };
          };
        };
      };
    };
  };
}
