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
        colorterm = false;
      };

      plugins = {
        lualine.enable = true;
        commentary.enable = true;
        todo-comments.enable = true;
        # which-key.enable = true;
        gitsigns.enable = true;
        nvim-ufo.enable = true; # folding
      };

      plugins.which-key = {
        enable = true;
        settings.spec = [
          { __unkeyed = "<leader>p"; desc = "Project"; }
          { __unkeyed = "<leader>b"; desc = "Buffers"; }
          { __unkeyed = "<leader>s"; desc = "Search";}
          { __unkeyed = "<leader>z"; desc = "Zettel";}
        ];
      };

      opts = let
        tab_size = 2;
      in {
        number = true;
        relativenumber = false;
        clipboard = "unnamedplus";
        tabstop = tab_size;
        softtabstop = tab_size;
        showtabline = 0;
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
      };
    };
  };
}
