-- NOTE: YOU SHOULD HAVE THIS PLUGIN.
-- This is equivalent to the following Lua code for passing config opts:
--    require('gitsigns').setup({ ... })
return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      attach_to_untracked = true,       -- untracked files get signs and show up in setqflist("all")
      diff_opts = { linematch = 60 },   -- align changed lines within a hunk
      linehl = false,
      numhl = false,
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "x" },
        topdelete = { text = "x" },
        changedelete = { text = "*" },
        untracked = { text = "?" },
      },
      signs_staged = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
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
            gitsigns.nav_hunk('next', { target = "all" })   -- keeps staged hunks jumpable
          end
        end)

        map('n', '[g', function()
          if vim.wo.diff then
            vim.cmd.normal({'[g', bang = true})
          else
            gitsigns.nav_hunk('prev', { target = "all" })
          end
        end)

        -- Hunks
        map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "[g]it [s]tage hunk" })
        map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "[g]it [r]eset hunk" })
        map('v', '<leader>gs', function()
          gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)
        map('v', '<leader>gr', function()
          gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)
        map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "[g]it [S]tage" })
        map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "[g]it [R]eset" })
        map("n", "<leader>gh", function() gitsigns.change_base("HEAD~1", true) end, { desc = "git diff against HEAD~1, older base" })
        map("n", "<leader>gH", function() gitsigns.reset_base(true) end, { desc = "git reset base index" })
        map({ "o", "x" }, "ih", "<Cmd>Gitsigns select_hunk<CR>", { desc = "gitsigns: select hunk" })

        -- Diffs
        -- map('n', '<leader>gd', gitsigns.preview_hunk, { desc = '[g]it preview hunk [d]iff' })  -- in a popup, blocks code
        map("n", "<leader>gdi", gitsigns.preview_hunk_inline, { desc = "[g]it preview hunk [d]iff [i]nline" })
        map("n", "<leader>gds", gitsigns.diffthis, { desc = "[g]it [d]iff against index in an [s]plit view" })
        map('n', '<leader>tw', gitsigns.toggle_word_diff)

        -- Blame
        map("n", "<leader>gb", gitsigns.blame_line, { desc = "[g]it [b]lame line" })
        map("n", "<leader>gB", gitsigns.blame, { desc = "[g]it [b]lame line" })
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" })

        -- Quickfix list
        map("n", "<leader>gq", function() gitsigns.setqflist(0) end,     { desc = "[g]it hunks to [q]uickfix (this buffer)" })
        map("n", "<leader>gQ", function() gitsigns.setqflist("all") end, { desc = "[g]it hunks to [Q]uickfix (whole tree)" })
      end,
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
