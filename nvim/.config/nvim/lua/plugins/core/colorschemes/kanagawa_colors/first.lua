return {
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    init = function()
      require('kanagawa').setup {
        compile = false, -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = {},
        functionStyle = {},
        typeStyle = { --[[ bold = true ]]
        },
        keywordStyle = { italic = false },
        statementStyle = { bold = true },
        -- FIXME:
        operatorStyle = { bold = true },
        transparent = false, -- do not set background color
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = { -- ADD/MODIFY THEME AND PALETTE COLORS
          palette = {
            -- [[ TOMORROW-NIGHT HYBRID ]] {{
            -- also from https://terminal.sexy/
            -- see the folder ./sexy_colors/
            -- Change ALL USAGES of these colors
            -- waveRed = '#cc6666', -- preproc, special2
            waveRed = '#a54242', -- preproc, special2
            surimiOrange = '#de935f', -- constant/macro
            -- carpYellow = '#f0c674', -- identifier
            -- boatyellow2 = '#f0c674', -- operator
            roninYellow = '#f0c674', -- DiagnosticVirtualTextWarn, GREAT DONT CHANGE
            springGreen = '#b5bd68', -- string
            -- waveAqua2 = '#8abeb7', -- type, too blue
            -- waveAqua2 = '#76946A', -- type, a little too dark
            waveAqua2 = '#87a987', -- type
            -- springBlue = '#b5cbd2', -- special1, primitive types, better for starker contrast
            springBlue = '#9fb5c9', -- special1, primitive types
            -- crystalBlue = '#8cbfb8',
            crystalBlue = '#81a2be',
            -- crystalBlue = '#75a1c1',
            oniViolet = '#b294bb', -- keyword
            -- sakuraPink = '#d9a594', -- numbers, too much blending in
            sakuraPink = '#c4746e', -- numbers
            -- NOTE: find a use for '#7AA89F', what a pretty color
            waveAqua1 = '#7AA89F',
            -- waveAqua1 = '#8cbfb8',

            -- Popup and Floats
            waveBlue1 = '#2D4F67', -- ui.bg_search (search results)
            waveBlue2 = '#223249', -- ui.bg_visual (visual select)
            -- }}
          },
          theme = {
            wave = {
              -- [[ TOMORROW-NIGHT HYBRID ]] {{
              ui = {
                -- bg_search = '#938AA9',
                bg_search = '#2D4F67',
                bg_visual = '#43436c',
                -- bg_visual = '#2D4F67',
                -- #555fbb
              },
              syn = {
                punct = '#C8C093', -- oldWhite
              },
              diag = {
                error = '#cc6666',
                -- error = '#D27E99',
                -- error = '#FF9E3B',
                -- error = '#de935f',
                --ok = palette.springGreen,
                warning = '#f0c674',
                info = '#7E9CD8',
                -- hint = '#7AA89F',
                hint = '#76946A',
              },
              -- }}
            },
            lotus = {},
            dragon = {},
            all = {},
          },
        },
        overrides = function(colors) -- add/modify highlights
          local theme = colors.theme -- usages of colors
          -- local palette_colors = colors.palette -- colors themselves, RBG hex
          -- local wave_colors = require("kanagawa.colors").setup({ theme = 'wave' })

          -- [[ HELPER FN TO TINT DIAGNOSTIC MSGS ]] {{
          local tintDiagnosticBg = function(color)
            local c = require 'kanagawa.lib.color'
            return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
          end
          -- }}

          return {
            -- [[ DARKER COMPLETION WINDOWS ]] {{
            Pmenu = {
              fg = theme.ui.shade0,
              bg = theme.ui.bg_p1,
              blend = vim.o.pumblend,
            }, -- add blend = vim.o.pumblend` to enable transparency
            PmenuSel = { fg = 'NONE', bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
            -- }}

            -- [[ TINT DIAGNOSTIC MESSAGES ]] {{
            -- bg highlighted w/foreground color
            DiagnosticVirtualTextHint = tintDiagnosticBg(theme.diag.hint),
            DiagnosticVirtualTextInfo = tintDiagnosticBg(theme.diag.info),
            DiagnosticVirtualTextWarn = tintDiagnosticBg(theme.diag.warning),
            DiagnosticVirtualTextError = tintDiagnosticBg(theme.diag.error),
            -- }}

            -- [[ TELESCOPE UI ]] {{
            -- [[ DARKER COLORS ]]
            TelescopeTitle = { fg = theme.ui.special, bold = true },
            TelescopeNormal = { bg = colors.bg_dim },
            TelescopeBorder = { fg = colors.bg_dim, bg = colors.bg_dim },
            TelescopePromptNormal = { bg = colors.bg_light0 },
            TelescopePromptBorder = { fg = colors.bg_light0, bg = colors.bg_light0 },
            -- "Normal"/rounded list of files
            TelescopePreviewNormal = { bg = colors.bg_dim },
            TelescopePreviewBorder = { bg = colors.bg_dim, fg = colors.bg_dim },
            -- "Normal"/rounded window into files
            TelescopeResultsNormal = { bg = colors.bg_dim },
            TelescopeResultsBorder = { fg = colors.bg_dim, bg = colors.bg_dim },
            -- Blockier list of files
            -- TelescopeResultsNormal = { bg = '#1a1a22' },
            -- TelescopeResultsBorder = { fg = '#1a1a22', bg = '#1a1a22' },
            -- Blockier window into files
            -- TelescopePreviewNormal = { bg = theme.ui.bg_dim },
            -- TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
            -- }}

            -- [[ TRANSPARENT FLOATING WINDOWS ]] {{
            -- https://github.com/rebelot/kanagawa.nvim/tree/master?tab=readme-ov-file#transparent-floating-windows
            -- Practically, this means `K` blends better, but less dark
            NormalFloat = { bg = 'none' },
            FloatBorder = { bg = 'none' },
            FloatTitle = { bg = 'none' },

            -- Save an hlgroup with dark background and dimmed foreground
            -- so that you can use it where your still want darker windows.
            -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            -- Popular plugins that open floats will link to NormalFloat by default;
            -- set their background accordingly if you wish to keep them dark and borderless
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            -- }}
          }
        end,
        theme = 'wave', -- Load "wave" theme when 'background' option is not set
        background = { -- map the value of 'background' option to a theme
          dark = 'wave',
          light = 'lotus',
        },
      }

      -- setup must be called before loading
      vim.cmd 'colorscheme kanagawa'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
