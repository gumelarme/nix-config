require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

require'dracula'.setup {
  transparent_bg = true,
}

vim.cmd[[colorscheme dracula]]

local wk = require('which-key')
wk.register({
  p = {
    name = "Project",
    f = { "<cmd>Telescope find_files<cr>", "Find file"},
  },

  b = {
    name = "Buffer",
    b = { "<cmd>Telescope buffers<cr>", "Find buffer"},
  },

  s = {
    name = "Search",
    p = { "<cmd>Telescope live_grep<cr>", "Search text in project"},
  },

}, { prefix = "<Space>" })

require'lspconfig'.marksman.setup {}
-- require'render-markdown'.setup {
--   heading = {
--     sign = false,
--   },
--   bullets = {
--     enabled = false,
--   },
-- }


