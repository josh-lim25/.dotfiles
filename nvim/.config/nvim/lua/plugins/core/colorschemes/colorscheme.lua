return {
  "thesimonho/kanagawa-paper.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    colors = {
      palette = {},
      theme = {
        ink = {
          syn = {
            operator = "#c4b28a"
          },
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

        -- result = background + α · (accent − background)
        --        = background · (1 − α) + accent · α
        -- α is opacity: α = 1 gives the pure accent, α = 0 gives the bare background, and anything in between is the accent diluted by the background

        -- text matches bg color
        -- RenderMarkdownH1Bg = { fg = "#c4b28a", bg = "#776c56", bold = true },
        -- RenderMarkdownH2Bg = { fg = "#708e9e", bg = "#485861", bold = true },
        -- RenderMarkdownH3Bg = { fg = "#b6927b", bg = "#6f5a4e", bold = true },
        -- RenderMarkdownH4Bg = { fg = "#949fb5", bg = "#5c616d", bold = true },
        -- RenderMarkdownH5Bg = { fg = "#699469", bg = "#455b44", bold = true },
        -- RenderMarkdownH6Bg = { fg = "#699469", bg = "#455b44", bold = true },

        -- dark text
        -- RenderMarkdownH1Bg = { fg = "#181616", bg = "#94866a", bold = true },
        -- RenderMarkdownH2Bg = { fg = "#181616", bg = "#576c78", bold = true },
        -- RenderMarkdownH3Bg = { fg = "#181616", bg = "#8a6f5f", bold = true },
        -- RenderMarkdownH4Bg = { fg = "#181616", bg = "#717988", bold = true },
        -- RenderMarkdownH5Bg = { fg = "#181616", bg = "#527152", bold = true },
        -- RenderMarkdownH6Bg = { fg = "#181616", bg = "#527152", bold = true },

        -- highlight
        RenderMarkdownH1Bg = { fg = "#c4b28a", bg = "none" },
        RenderMarkdownH2Bg = { fg = "#8992a7", bg = "none" },
        RenderMarkdownH3Bg = { fg = "#b6927b", bg = "none" },
        RenderMarkdownH4Bg = { fg = "#708e9e", bg = "none" },
        RenderMarkdownH5Bg = { fg = "#699469", bg = "none" },
        RenderMarkdownH6Bg = { fg = "#949fb5", bg = "none" },

        -- text
        ["@markup.heading.1.markdown"] = { fg = "#c4b28a", bold = true },
        ["@markup.heading.2.markdown"] = { fg = "#8992a7", bold = true },
        ["@markup.heading.3.markdown"] = { fg = "#b6927b", bold = true },
        ["@markup.heading.4.markdown"] = { fg = "#708e9e", bold = true },
        ["@markup.heading.5.markdown"] = { fg = "#699469", bold = true },
        ["@markup.heading.6.markdown"] = { fg = "#949fb5", bold = true },

        -- icons
        RenderMarkdownH1 = { fg = "#c4b28a" },
        RenderMarkdownH2 = { fg = "#8992a7" },
        RenderMarkdownH3 = { fg = "#b6927b" },
        RenderMarkdownH4 = { fg = "#708e9e" },
        RenderMarkdownH5 = { fg = "#699469" },
        RenderMarkdownH6 = { fg = "#949fb5" },


        -- markdown inline (treesitter)
        ["@markup.link.label.markdown_inline"] = { fg = p.dragonYellow },
        -- ["@markup.link.label.markdown_inline"] = { fg = "#658594" },
        -- ["@markup.link.url.markdown_inline"] = { link = "Special" },
        -- ["@markup.italic.markdown_inline"] = { fg = p.oniViolet2, italic = true },
        -- ["@markup.strong.markdown_inline"] = { fg = p.dragonYellow, bold = true },
        -- ["@markup.raw.markdown_inline"] = { fg = p.dragonGreen2 },
        -- ["@markup.list.markdown"] = { link = "Function" },
        -- ["@markup.quote.markdown"] = { fg = p.dragonOrange },
        -- ["@markup.list.checked.markdown"] = { link = "WarningMsg" },
      }
    end,
  },
  config = function(_, opts)
    require("kanagawa-paper").setup(opts)
    vim.cmd.colorscheme("kanagawa-paper-ink")
    -- For removing strikethrough on deleted diff view
    -- vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#c4746e", bg = "#452f33" })
    vim.api.nvim_set_hl(0, "DiffDelete", vim.tbl_extend("force", vim.api.nvim_get_hl(0, { name = "DiffDelete" }), { strikethrough = false, cterm = {} }))
  end,
}
