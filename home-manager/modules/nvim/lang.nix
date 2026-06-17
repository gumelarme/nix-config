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
      tree-sitter
    ];

    programs.nixvim = {
      plugins = {
        nix.enable = true;
        trouble.enable = cfg.lsp;
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
          nil_ls.enable = true; # nix
          lua_ls.enable = true;
          gleam.enable = true;
          pyright.enable = true;
          clojure_lsp.enable = true;
          ols.enable = true; # odin
          clangd.enable = true;
          ocamllsp.enable = true;
          gopls.enable = true;
          templ.enable = true;

          html.enable = true;
          tailwindcss.enable = true;
          # ts_ls.enable = true;
          vtsls.enable = true;

          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };

          hls = {
            # haskell
            enable = true;
            installGhc = false;
          };

          # marksman.enable = true;
          tinymist = {
            enable = true;
            package = pkgs.tinymist;
            extraOptions = {
              # this resolve the CJK content issue on LSP,
              # but need to be passed on every single servers
              # Should be fixed by neovim by v0.10.3
              offset_encoding = "utf-8";
            };

            settings = {
              exportPdf = "never";
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

      # formatter
      plugins.conform-nvim = {
        enable = cfg.lsp;
        autoInstall.enable = true;
        settings = {
          default_format_opts = {
            lsp_format = "fallback";
          };

          format_on_save = {
            lsp_format = "fallback";
            timeout_ms = 500;
          };

          formatters = {
            custom_python_formatter = {
              command.__raw = ''
                function(bufnr)
                   if require("conform").get_formatter_info("ruff_format", bufnr).available then
                     return { "ruff_format" }
                   else
                     return { "isort", "black" }
                   end
                 end
              '';
            };
          };

          formatters_by_ft = {
            # Use the "*" filetype to run formatters on all filetypes.
            # Use the "_" filetype to run formatters on filetypes that don't have other formatters configured.

            "*" = ["typos"];
            "_" = ["trim_whitespace"];
            bash = ["shellcheck" "shellharden" "shfmt"];
            cpp = ["clang_format"];
            lua = ["stylua"];
            nix = ["alejandra"];
            odin = ["odinfmt"];
            gleam = ["gleam"];
            ocaml = ["ocamlformat"];
            clojure = ["cljfmt"];
            markdown = ["rumdl"];
            yaml = ["yamlfmt"];
            dockerfile = ["dockerfmt"];
            typst = ["typstyle"];
            go = ["goimports" "gofmt"];
            rust = ["rustfmt"];
            python = ["custom_python_formatter"];
            haskell = ["ormolu"];
          };
        };
      };

      plugins.ts-context-commentstring.enable = true;
      plugins.treesitter-context = {
        enable = true;
        settings = {
          mode = "topline";
          max_lines = 5;
          line_numbers = false;
        };
      };

      # plugins.treesitter-locals.enable = true;
      plugins.treesitter-textobjects.enable = true;
      plugins.treesitter = {
        enable = true;
        settings.highlight.enable = true;
        settings.indent.enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          c
          go
          nix
          lua
          # org
          css
          tsx
          odin
          html
          rust
          gleam
          ocaml
          haskell
          templ
          python
          vimdoc
          clojure
          javascript
          typescript

          markdown
          markdown_inline
          todotxt

          yaml
          dockerfile

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
