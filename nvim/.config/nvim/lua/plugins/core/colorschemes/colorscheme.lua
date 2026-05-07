return {
  "thesimonho/kanagawa-paper.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    colors = {
      palette = {},
      theme = {
        ink = {
          ui = {
            bg_search = "#43436c",
            -- bg_search = "#2d4f67",
          },
        },
      },
    },
    overrides = function(colors)
      local bg = colors.theme.ui.bg_search
      local p = colors.palette

      return {
        -- search
        Search = { bg = bg, fg =    p.oldWhite },
        CurSearch = { bg = bg, fg = p.oldWhite, bold = true },
        IncSearch = { bg = bg, fg = p.oldWhite, bold = true },

        -- markdown inline (treesitter)
        ["@markup.link.url.markdown_inline"] = { link = "Special" },
        ["@markup.link.label.markdown_inline"] = { link = "WarningMsg" },
        ["@markup.italic.markdown_inline"] = { fg = p.oniViolet2, italic = true },
        ["@markup.strong.markdown_inline"] = { fg = p.dragonYellow, bold = true },
        ["@markup.raw.markdown_inline"] = { fg = p.dragonGreen2 },
        ["@markup.list.markdown"] = { link = "Function" },
        ["@markup.quote.markdown"] = { fg = p.dragonOrange },
        ["@markup.list.checked.markdown"] = { link = "WarningMsg" },

        -- NO HEADER BG
        RenderMarkdownH1 = { fg = p.dragonYellow, bold = true },
        RenderMarkdownH2 = { fg = p.dragonGreen, bold = true },
        RenderMarkdownH3 = { fg = p.dragonBlue2, bold = true },
        RenderMarkdownH4 = { fg = p.dragonAqua, bold = true },
        RenderMarkdownH5 = { fg = p.dragonViolet, bold = true },
        RenderMarkdownH6 = { fg = p.dragonGray, bold = true },
        RenderMarkdownH1Bg = { fg = p.dragonYellow, bg = "NONE", bold = true },
        RenderMarkdownH2Bg = { fg = p.dragonGreen, bg = "NONE", bold = true },
        RenderMarkdownH3Bg = { fg = p.dragonBlue2, bg = "NONE", bold = true },
        RenderMarkdownH4Bg = { fg = p.dragonAqua, bg = "NONE", bold = true },
        RenderMarkdownH5Bg = { fg = p.dragonViolet, bg = "NONE", bold = true },
        RenderMarkdownH6Bg = { fg = p.dragonGray, bg = "NONE", bold = true },

        -- ["@markup.heading.1.markdown"] = { fg = p.dragonYellow, bold = true },
        -- ["@markup.heading.2.markdown"] = { fg = p.dragonGreen, bold = true },
        -- ["@markup.heading.3.markdown"] = { fg = p.dragonBlue2, bold = true },
        -- ["@markup.heading.4.markdown"] = { fg = p.dragonAqua, bold = true },
        -- ["@markup.heading.5.markdown"] = { fg = p.dragonViolet, bold = true },
        -- ["@markup.heading.6.markdown"] = { fg = p.dragonGray, bold = true },
        --
      }
    end,
  },
  config = function(_, opts)
    require("kanagawa-paper").setup(opts)
    vim.cmd.colorscheme("kanagawa-paper-ink")
  end,
}
