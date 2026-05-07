return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VimEnter",
  opts = {
    files = {
      hidden = true,
      fd_opts = "--type f --hidden --exclude .git",
    },
    grep = {
      rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden -g '!.git/'",
      rg_glob = true, -- enable glob parsing
      glob_flag = "--iglob", -- case insensitive globs
      glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
    },
    fzf_opts = {
      ["--info"] = "default",
      -- ["--layout"] = "default",  -- puts searchbar in middle
    },
    keymap = {
      fzf = {
        ["ctrl-q"] = "select-all+accept",
      },
    },
  },
  config = function(_, opts)
    local fzf = require("fzf-lua")
    fzf.setup(opts)
    fzf.register_ui_select()

    local keymap = vim.keymap.set

    -- [[ FILE/SEARCH ]]
    keymap("i", "<C-f>", function()
      fzf.complete_path()
    end)
    keymap("n", "<leader>ff", function()
      fzf.files()
    end, { desc = "[F]ind [F]iles in project directory" })
    keymap("n", "<leader>fg", function()
      fzf.live_grep()
    end, { desc = "[F]ind via fuzzy [G]rep in project directory" })
    keymap("n", "<leader>fH", fzf.helptags, { desc = "[F]ind neovim [H]elp docs" })
    keymap("n", "<leader>fk", fzf.keymaps, { desc = "[F]ind [K]eymaps" })
    keymap("n", "<leader>fb", fzf.builtin, { desc = "[F]ind [B]uiltins offered by fzf" })
    keymap("n", "<leader>fw", fzf.grep_cword, { desc = "[F]ind occurrences of [W]ord on cursor" })
    keymap("n", "<leader>fW", fzf.grep_cWORD, { desc = "[F]ind occurrences of [W]ORD on cursor" })
    keymap("n", "<leader>fd", fzf.diagnostics_document, { desc = "[F]ind [D]iagnostics" })
    keymap("n", "<leader>fr", fzf.resume, { desc = "[F]ind [R]esume" })
    keymap("n", "<leader>fo", fzf.oldfiles, { desc = "[F]ind [O]ld Files" })
    keymap("n", "<leader><leader>", fzf.buffers, { desc = "See existing buffers" })
    keymap("n", "<leader>/", fzf.lgrep_curbuf, { desc = "Grep in current buffer" })
    keymap("n", "<leader>fn", function()
      fzf.files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "Find in Neovim config" })
    keymap("n", "<leader>fp", function()
      fzf.files({ cwd = "~/spaghetti/projects/" })
    end, { desc = "Find in projects" })

    -- [[ LSP KEYMAPS ]]
    keymap("n", "<leader>cap", fzf.lsp_code_actions, { desc = "Code actions" })
    keymap("n", "gd", fzf.lsp_definitions, { desc = "Go to definition" })
    keymap("n", "gr", fzf.lsp_references, { desc = "Go to references" })
    keymap("n", "<leader>fs", fzf.lsp_document_symbols, { desc = "Find symbols in document" })
    keymap("n", "<leader>fS", fzf.lsp_workspace_symbols, { desc = "Find symbols in workspace" })

    -- [[ DOCS ]]
    local function browse_docs()
      local ft = vim.bo.filetype
      local cmd, preview_cmd

      if ft == "go" then
        cmd = "stdsym"
        preview_cmd = "go doc {1}"
      elseif ft == "lua" then
        cmd = "printf 'table\\nstring\\nmath\\nos'"
        preview_cmd = "help {1}" -- Neovim internal help
      else
        print("No doc config for " .. ft)
        return
      end

      fzf.fzf_exec(cmd, {
        prompt = "Docs (" .. ft .. ")> ",
        previewer = "builtin", -- Use nvim's builtin preview for speed
        fn_preprocess = function(contents)
          -- TODO: filter list
          return contents
        end,
        fzf_opts = {
          ["--preview"] = preview_cmd,
          ["--preview-window"] = "right,60%,border-left",
        },
        actions = {
          ["default"] = function(selected)
            -- :h
            if ft == "lua" then
              vim.cmd("leftabove vsplit | help " .. selected[1])
              return
            end
            local cmd = preview_cmd:gsub("{1}", selected[1])
            local output = vim.fn.systemlist(cmd)
            vim.cmd("leftabove vnew")
            vim.bo.buftype = "nofile"
            vim.bo.bufhidden = "hide"
            vim.bo.swapfile = false
            vim.bo.filetype = ft
            vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
          end,
        },
      })
    end

    keymap("n", "<leader>god", browse_docs, { desc = "Browse Stdlib Docs" })
  end,
}
