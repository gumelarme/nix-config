{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.neovim;
in {
  options.modules.neovim.enable = mkEnableOption "Enable nvim configurations";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      marksman
    ];

    programs.nixvim = {
      enable = true;
      vimAlias = true;
      viAlias = true;
      colorschemes.catppuccin = {
        enable = true;
        settings = {
          flavour = "mocha";
          transparent_background = true;
          integrations.treesitter = true;
        };
      };

      plugins = {
        lualine.enable = true;
        commentary.enable = true;
        todo-comments.enable = true;
        nix.enable = true;
        typst-vim.enable = true;
        which-key.enable = true;
        leap.enable = true;
        gitsigns.enable = true;
      };

      plugins.lsp = {
        enable = true;
        servers.marksman.enable = true;
      };

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

          "gcc" = {
            action = "<cmd>Commentary<CR>";
            options = {
              desc = "Comment";
            };
          };
        };
      };

      plugins.ts-context-commentstring.enable = true;
      plugins.treesitter = rec {
        enable = true;
        indent = true;
        grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          c
          go
          nix
          lua
          org
          gleam
          python
          vimdoc
          clojure
          markdown
          markdown_inline

          gitcommit
          gitignore
          git_rebase
          git_config
        ];
      };

      opts = {
        number = true;
        relativenumber = false;
        clipboard = "unnamedplus";
        tabstop = 4;
        softtabstop = 4;
        showtabline = 0;
        expandtab = true;
        smartindent = true;
        shiftwidth = 4;
        breakindent = true;
        cursorline = true;
        scrolloff = 8;
        foldmethod = "manual";
        foldenable = false;
        linebreak = true;
        spell = false;
        timeoutlen = 300;
        termguicolors = true;
        showmode = false;
        splitbelow = true;
        splitkeep = "screen";
        splitright = true;
        wrap = false;
      };
    };
  };
}
