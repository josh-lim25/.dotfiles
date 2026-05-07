-- NOTE: YOU SHOULD HAVE THIS PLUGIN.
-- This is equivalent to the following Lua code for passing config opts:
--    require('gitsigns').setup({ ... })
return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "x" },
        topdelete = { text = "x" },
        changedelete = { text = "*" },
        untracked = { text = "?" },
      },
      signs_staged = {
        add = { text = "++" },
        change = { text = "~~" },
        delete = { text = "xx" },
        topdelete = { text = "xx" },
        changedelete = { text = "**" },
        untracked = { text = "??" },
      },
      signs_staged_enable = true,
      watch_gitdir = {
        follow_files = true,
      },
      auto_attach = true,
      current_line_blame = false,
      preview_config = {
        style = "minimal",
        -- relative = "editor",
        -- width = 80,
        -- height = 12,
        -- focusable = true,
        relative = "cursor",
        border = "rounded",
        row = 0,
        col = 1,
      },

      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")
        local function map(mode, lhs, rhs, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- Navigation
        map('n', ']g', function()
          if vim.wo.diff then
            vim.cmd.normal({']g', bang = true})
          else
            gitsigns.nav_hunk('next')
          end
        end)

        map('n', '[g', function()
          if vim.wo.diff then
            vim.cmd.normal({'[g', bang = true})
          else
            gitsigns.nav_hunk('prev')
          end
        end)

        -- Staging and Resetting Hunks
        map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "[g]it [s]tage hunk" })
        map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "[g]it [r]eset hunk" })
        map('v', '<leader>gs', function()
          gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)
        map('v', '<leader>gr', function()
          gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)
        map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "[g]it [S]tage buffer" })
        map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "[g]it [R]eset buffer" })

        -- Diffs
        -- map('n', '<leader>gd', gitsigns.preview_hunk, { desc = '[g]it preview hunk [d]iff' })
        map("n", "<leader>gdd", gitsigns.preview_hunk_inline, { desc = "[g]it preview hunk [d]iff inline" })
        map("n", "<leader>gdo", gitsigns.diffthis, { desc = "[g]it [d]iff against index in an [o]pened split view" })
        map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "[T]oggle git show [D]eleted" })
        map('n', '<leader>gdw', gitsigns.toggle_word_diff)

        -- Blame
        map("n", "<leader>gb", gitsigns.blame_line, { desc = "[g]it [b]lame line" })
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" })
      end,
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
