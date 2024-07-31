{
  pkgs,
  config,
  ...
}: let
  homeDir = config.home.homeDirectory;
in {
  home.file."${homeDir}/.intellimacs" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "MarcoIeni";
      repo = "intellimacs";
      rev = "f1e78859c902bdf2d95e35683de1e985ad987f52";
      hash = "sha256-M7XJ8EBMUg698Q8hhPXPHxEoZhm/bieDKxRbmq9Zqco=";
    };
  };

  home.file."${homeDir}/.ideavimrc" = {
    text = ''
      source ~/.intellimacs/spacemacs.vim

      " (Optional) Enable other Intellimacs modules
      source ~/.intellimacs/extra.vim
      source ~/.intellimacs/major.vim
      source ~/.intellimacs/hybrid.vim

      " (Optional) Enable which-key plugin
      source ~/.intellimacs/which-key.vim

      " (Optional) My own vim commands
      nnoremap Y y$

      " (Optional) Comma for major mode
      nmap , <leader>m
      vmap , <leader>m

      " (Optional) Add/edit actions
      nnoremap <leader>gl    :action Vcs.Show.Log<CR>
      vnoremap <leader>gl    :action Vcs.Show.Log<CR>

      Plug 'tpope/vim-commentary'
      Plug 'tpope/vim-surround'
      Plug 'terryma/vim-multiple-cursors'

      " User defined
      set clipboard=unnamedplus,ideaput

      "== QuickScope
      " Highlight on key press
      let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
      set quickscope
    '';
  };
}
