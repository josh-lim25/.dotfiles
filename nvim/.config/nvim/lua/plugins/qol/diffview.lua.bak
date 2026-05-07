return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },

  -- Lazy load on these specific Neovim commands
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
    "DiffviewFileHistory",
  },

  -- Lazy load on these keybinds (feel free to change the <leader> mappings)
  keys = {
    { "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "[D]iff [O]pen" },
    { "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "[D]iff [C]lose" },
    { "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "[D]iff [H]istory (Current File)" },
    { "<leader>dH", "<cmd>DiffviewFileHistory<cr>", desc = "[D]iff [H]istory (Project)" },
    { "<leader>df", "<cmd>DiffviewToggleFiles<cr>", desc = "[D]iff Toggle [F]iles" },
  },

  -- The `opts` table acts as `require('diffview').setup(opts)`
  opts = {
    diff_binaries = false, -- Show diffs for binaries
    enhanced_diff_hl = true, -- Better diff highlighting
    use_icons = true, -- Requires nvim-web-devicons
    watch_index = true, -- Update views and index buffers when the git index changes

    -- Customizing layouts
    view = {
      default = {
        layout = "diff2_horizontal",
        disable_diagnostics = false,
      },
      merge_tool = {
        layout = "diff3_horizontal",
        disable_diagnostics = true, -- Great for keeping things clean during conflict resolution
      },
      file_history = {
        layout = "diff2_horizontal",
      },
    },

    hooks = {
      -- [[ CLOSE THE FILE TREE BY DEFAULT ON OPEN ]]
      view_opened = function()
        -- When the view opens, immediately toggle the files panel closed.
        -- Diffview automatically resizes the remaining windows to fill the screen.
        require("diffview.actions").toggle_files()
      end,
      diff_buf_read = function()
        vim.opt_local.wrap = false
        vim.opt_local.list = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
      end,
    },
  },
}
