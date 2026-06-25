return {
  "shortcuts/no-neck-pain.nvim",
  config = function()
    require("no-neck-pain").setup({
      autocmds = {
        enableOnVimEnter = true,
        skipEnteringNoNeckPainBuffer = true, -- true if you don't want scratchpad
      },
      -- higher val means smaller buffers on the sides
      width = 100,
      mappings = {
        enabled = true,
        toggle = "<leader>tn",
      },
      buffers = {
        -- no buffer on the right
        right = { enabled = false, },
        -- blend > 0 shows line on the side
        colors = {
          background = "#1f1f28",   -- remove if you want the dividing line
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
