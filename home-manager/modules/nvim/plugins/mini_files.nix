_: {
  programs.nixvim = {
    plugins = {
      mini.modules.files = {};
    };

    keymaps = [
      {
        key = "<leader>op";
        action = "<cmd>lua MiniFiles.open()<CR>";
        options.desc = "Open file explorer";
      }
      {
        key = "<leader>ob";
        action = "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>";
        options.desc = "Open file explorer @buffer";
      }
    ];

    extraConfigLua = ''
      local show_dotfiles = true
      local filter_show = function(fs_entry) return true end
      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, '.')
      end

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        MiniFiles.refresh({ content = { filter = new_filter } })

      end

      -- Yank in register full path of entry under cursor
      local yank_path = function()
        local path = (MiniFiles.get_fs_entry() or {}).path
        if path == nil then return vim.notify('Cursor is not on valid entry') end
        vim.fn.setreg(vim.v.register, path)
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local b = args.data.buf_id
          vim.keymap.set('n', 'gy', yank_path, { buffer = b, desc = 'Yank path' })
          vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = buf_id })
        end,
      })
    '';
  };
}
