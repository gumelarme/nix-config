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
    key = "yc";
    action = "yygccp";
    options = {
      desc = "Duplicate & comment";
      remap = true;
    };
  }
  {
    key = "<A-j>";
    action = "<cmd>m '>+1<CR>gv=gv";
    options.desc = "Move line down";
  }

  {
    key = "<A-k>";
    action = "<cmd>m '>-2<CR>gv=gv";
    options.desc = "Move line up";
  }
]
