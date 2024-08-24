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
        typst-vim.enable = true;
        lsp-format.enable = true;
      };

      plugins.lsp = lib.mkIf cfg.lsp {
        enable = true;
        servers = {
          marksman.enable = true;
          nil-ls.enable = true;
          lua-ls.enable = true;
          html.enable = true;
          tailwindcss.enable = true;
          gleam.enable = true;

          # pylsp.enable = true;
          # pyright.enable = true;
          # pylyzer.enable = true;

          typst-lsp.enable = true;
          # tinymist.enable = true;
        };
      };

      plugins.ts-context-commentstring.enable = true;
      plugins.treesitter = {
        enable = true;
        indent = true;
        grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          c
          go
          nix
          lua
          org
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

          gitcommit
          gitignore
          git_rebase
          git_config
        ];
      };
    };
  };
}
