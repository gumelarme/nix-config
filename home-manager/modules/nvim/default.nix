{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.neovim;
in {
  options.modules.neovim = {
    enable = mkEnableOption "Enable nvim configurations";

    # TODO: configure granularly
    lsp = mkEnableOption "Enable all lsp server";
    completion = mkEnableOption "Enable all completions";
  };

  imports = [
    ./lang.nix
    ./plugins
  ];

  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      vimAlias = true;
      viAlias = true;
      keymaps = import ./keymaps.nix;

      colorschemes.dracula = {
        enable = true;
        settings.colorterm = false;
      };

      plugins = {
        lualine.enable = true;
        commentary.enable = true;
        gitsigns.enable = true;
        nvim-ufo.enable = true; # folding
        trouble.enable = true;
      };

      plugins.which-key = {
        enable = true;
        settings.spec = [
          {
            __unkeyed = "<leader>p";
            desc = "Project";
          }
          {
            __unkeyed = "<leader>b";
            desc = "Buffers";
          }
          {
            __unkeyed = "<leader>s";
            desc = "Search";
          }
          {
            __unkeyed = "<leader>z";
            desc = "Zettel";
          }
        ];
      };

      plugins.neo-tree = {
        enable = true;
        enableDiagnostics = true;
        enableGitStatus = true;
        enableModifiedMarkers = true;
        enableRefreshOnWrite = true;
        closeIfLastWindow = true;
      };

      opts = let
        tab_size = 2;
      in {
        number = true;
        relativenumber = false;
        clipboard = "unnamedplus";
        tabstop = tab_size;
        softtabstop = tab_size;
        expandtab = true;
        smartindent = true;
        shiftwidth = tab_size;
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

        # Always show tablline
        # Showing modified flag, column number, filepath
        showtabline = 2;
        tabline = "%(%M:%c\ %f%)";
      };

      extraConfigLuaPre = ''
        vim.g["conjure#mapping#doc_word"] = "gk"
      '';

      # TODO: Convert to lua options
      extraConfigVim = ''
        hi Visual guibg=#555555
      '';
    };
  };
}
