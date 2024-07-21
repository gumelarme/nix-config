set number
set relativenumber
set tabstop=4
set shiftwidth=4
set autoindent
set noshowmode
set nowrap
set clipboard=unnamedplus
set colorcolumn=80
set cursorline
" set spell

" ====== emmet-vim 
" enable in insert and normal mode
let g:user_emmet_mode='in'

" only enable in html and css file
let g:user_emmet_install_global=0
autocmd FileType html,css EmmetInstall

let g:user_emmet_leader_key='<C-Z>'

" commentary
autocmd FileType nix setlocal commentstring=#\ %s

" preservim/vim-markdown
" let g:vim_markdown_folding_disabled = 1
" let g:vim_markdown_frontmatter = 1
" let g:vim_markdown_folding_level = 2
