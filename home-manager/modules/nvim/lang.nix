{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.neovim;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      marksman
    ];

    programs.nixvim = {
      plugins = {
        nix.enable = true;
        trouble.enable = cfg.lsp;
        typst-vim.enable = true;
        lsp-format.enable = cfg.lsp;

        cmp-path.enable = cfg.completion;
        cmp-buffer.enable = cfg.completion;
        cmp-nvim-lsp.enable = cfg.completion;

        emmet = {
          enable = true;
          settings = {
            leader_key = "<c-y>";
            mode = "a";
          };
        };

        conjure.enable = true;
      };

      plugins.lsp = lib.mkIf cfg.lsp {
        enable = true;
        servers = {
          marksman.enable = true;
          nil_ls.enable = true;
          lua_ls.enable = true;
          html.enable = true;
          tailwindcss.enable = true;
          gleam.enable = true;
          # ts_ls.enable = true;
          vtsls.enable = true;
          clojure_lsp.enable = true;
          pyright.enable = true;

          tinymist = {
            enable = true;
            package = pkgs.stable.tinymist;
            extraOptions = {
              # this resolve the CJK content issue on LSP,
              # but need to be passed on every single servers
              # Should be fixed by neovim by v0.10.3
              offset_encoding = "utf-8";
            };

            settings = {
              exportPdf = "onDocumentHasTitle";
              fontPaths = [
                # FIXME: better directory pinning
                "${config.home.homeDirectory}/.nix-profile/share/fonts"
              ];

              rootPath.__raw = ''
                require('lspconfig').util.root_pattern('Makefile', '.git')(fname) or vim.fn.getcwd()
              '';
            };
          };
        };

        keymaps.lspBuf = {
          "gd" = "definition";
          "gD" = "references";
          "gt" = "type_definition";
          "gi" = "implementation";
          "K" = "hover";
        };
      };

      plugins.ts-context-commentstring.enable = true;
      plugins.treesitter = {
        enable = true;
        settings.indent.enable = true;
        grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          c
          go
          nix
          lua
          # org
          css
          tsx
          html
          gleam
          python
          vimdoc
          clojure
          javascript
          typescript

          markdown
          markdown_inline
          todotxt

          gitcommit
          gitignore
          git_rebase
          git_config
        ];
      };

      plugins.luasnip.enable = true;
      plugins.cmp = lib.mkIf cfg.completion {
        enable = true;
        settings = {
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          autoEnableSources = true;
          performance = {
            debounce = 60;
            fetchingTimeout = 200;
            maxViewEntries = 30;
          };

          sources = [
            {name = "nvim_lsp";}
            {
              name = "path";
              keywordLength = 3;
            }
            {
              name = "buffer"; # text within current buffer
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
              keywordLength = 3;
            }
          ];

          mapping = {
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<C-j>" = "cmp.mapping.select_next_item()";
            "<C-k>" = "cmp.mapping.select_prev_item()";
            "<C-e>" = "cmp.mapping.abort()";
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-BS>" = "cmp.mapping.complete()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            # "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
          };
        };
      };
    };
  };
}
