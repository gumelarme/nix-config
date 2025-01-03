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

      plugins.mini = {
        enable = true;
        mockDevIcons = true;
        modules.icons = {};
      };

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
        };
      };
    };
  };
}
