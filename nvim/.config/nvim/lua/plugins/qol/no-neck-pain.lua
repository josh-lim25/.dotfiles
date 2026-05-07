return {
  "shortcuts/no-neck-pain.nvim",
  config = function()
    require("no-neck-pain").setup({
      autocmds = {
        enableOnVimEnter = true,
        skipEnteringNoNeckPainBuffer = true, -- true if you don't want scratchpad
      },
      -- width = 70, -- higher val means smaller buffers
      width = 65,
      mappings = {
        enabled = true,
        toggle = "<Leader>tn",
        -- -- Sets a global mapping to Neovim, which allows you to toggle the each side buffer.
        -- toggleLeftSide = '<Leader>tb', -- toggle buffer, not needed w/only one
        -- toggleRightSide = '<Leader>nqr',
        -- -- Sets a global mapping to Neovim, which allows you to increase the width (+5) of the main window.
        -- widthUp = '<Leader>n=',
        -- -- Sets a global mapping to Neovim, which allows you to decrease the width (-5) of the main window.
        -- widthDown = '<Leader>n-',
        -- -- Sets a global mapping to Neovim, which allows you to toggle the scratchPad feature.
        -- scratchPad = '<Leader>ns',
      },
      buffers = {
        -- no buffer on the right
        right = {
          enabled = false,
        },
        -- blend > 0 shows line on the side
        background = "#1f1f28",
        colors = {
          blend = 0,
        },
        -- no eol chars (~)
        wo = {
          fillchars = "eob: ",
        },
        -- automatically saves its content at the given `location`.
        -- NOTE: quitting an unsaved scratchPad buffer is non-blocking, and the content is still saved.
        scratchPad = {
          -- set to `false` to disable auto-saving
          enabled = false,
          -- set to `nil` to default to current working directory
          -- TODO: mmaybe have a script to save it from /tmp?
          pathToFile = '/tmp/' .. string.format("scratchpad.%d.md", math.random(1000)), -- pathToFile = '/tmp/scratchpad.md',
        },
        bo = {
          filetype = "markdown",
          -- never write to tmp file to disk
          buftype = "nofile",
          -- prevents 'swapfile' creation (REALLY ANNOYING)
          swapfile = false,
        },
      },
      -- colors = {
      --   -- iff `backgroundColor` not present, darken side buffers
      --   blend = -0.2,
      -- },
    })
  end,
}
