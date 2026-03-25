[
  {
    key = "<leader>zi";
    action = "<cmd>ZkInsertLink<CR>";
    options.desc = "Zk insert link";
  }

  {
    key = "<leader>pt";
    action = "<cmd>Neotree action=focus position=left<CR>";
    options.desc = "Project file tree";
  }

  {
    key = "<leader>xx";
    action = "<cmd>Trouble diagnostics toggle<CR>";
    options.desc = "Diagnostic";
  }

  {
    key = "<leader>xX";
    action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
    options.desc = "Diagnostic (current buffer)";
  }

  {
    key = "gl";
    action = "<cmd>lua vim.diagnostic.open_float()<CR>";
    options.desc = "Show error at cursor";
  }

  {
    key = "gm";
    action = "<cmd>FzfLua lsp_code_actions<CR>";
    options.desc = "Lsp code action";
  }

  {
    key = "<leader>st";
    action = "<cmd>FzfLua grep regex='(NOTE|TODO|FIXME|XXX):'<CR>";
    options.desc = "Search todos";
  }

  {
    key = "yc";
    action = "yygccp";
    options = {
      desc = "Duplicate & comment";
      remap = true;
    };
  }
]
