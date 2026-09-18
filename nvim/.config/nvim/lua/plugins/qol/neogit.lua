-- Neogit derives its accent palette from generic groups (ErrorMsg, Macro,
-- Include, ...) that kanagawa-paper leaves undefined, collapsing several
-- distinct accents to red. Pin only the groups that need it below; every
-- other neogit group keeps its default.
--
-- Inline word-diff colors are kept in sync with delta/themes.ini
-- (kanagawa-paper-ink), which uses the same accent/bg pairs.
return {
  "NeogitOrg/neogit",
  lazy = true,
  dependencies = {
    "sindrets/diffview.nvim",
    "m00qek/baleia.nvim", -- custom log pager
    "ibhagwan/fzf-lua",
  },
  cmd = "Neogit",
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
  },
  config = function(_, opts)
    require("neogit").setup(opts)

    local set_hl = vim.api.nvim_set_hl
    local violet = "#8992a7" -- dragonViolet
    local yellow = "#c4b28a" -- dragonYellow

    -- Whole-line diff panes: inherit the colorscheme's blended diff bgs.
    -- Add is bg-only, so treesitter syntax still shows through.
    set_hl(0, "NeogitDiffAdd", { link = "DiffAdd" })
    set_hl(0, "NeogitDiffDelete", { link = "DiffDelete" })
    set_hl(0, "NeogitDiffContext", { link = "Normal" })

    -- Inline word-diff: neogit hardcodes these and ignores DiffText.
    set_hl(0, "NeogitDiffAddInline", { fg = "#98BB6C", bg = "#43533c", bold = true })
    set_hl(0, "NeogitDiffDeleteInline", { fg = "#FF5D62", bg = "#6e373b", bold = true })

    -- Section titles (incl. "Recent Commits"), the HEAD:/Merge: label, and the
    -- diff-view headers. fg only, no banner bg.
    for _, hl in ipairs({
      "NeogitSectionHeader",
      "NeogitSectionHeaderCount",
      "NeogitStatusHEAD",
      "NeogitFloatHeader",
      "NeogitFloatHeaderHighlight",
      "NeogitDiffHeader",
      "NeogitDiffHeaderHighlight",
      "NeogitHunkHeader",
      "NeogitHunkHeaderHighlight",
      "NeogitHunkHeaderCursor",
    }) do
      set_hl(0, hl, { fg = violet, bold = true })
    end

    -- Change-type labels; the staged/unstaged variants link to these bases.
    set_hl(0, "NeogitChangeModified", { fg = yellow, bold = true, italic = true })
    set_hl(0, "NeogitChangeDeleted", { fg = yellow, bold = true, italic = true })
  end,
}
