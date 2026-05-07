return {
    -- src: from the kickstart project
    {
        -- configures Lua LSP for config, runtime and plugins used for completion, annotations and signatures of Neovim apis
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- If lsp sees `vim.uv` get used, pull in corr. type definitions for autocompletion and type checking to work.
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
            -- Mason must be loaded before its dependents so we need to set it up here.
            { "mason-org/mason.nvim", opts = {} }, -- Automatically install LSPs and related tools to stdpath for Neovim
            "mason-org/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            -- Useful status updates for LSP.
            -- { 'j-hui/fidget.nvim', opts = {} },

            -- Allows extra capabilities provided by blink.cmp
            "saghen/blink.cmp",
        },
        config = function()
            vim.g.vim_lsp_no_default_mappings = vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or "n"
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end
                    local fzf = require("fzf-lua")
                    map("gd", fzf.lsp_definitions, "[G]oto [D]efinition")
                    map("gD", fzf.lsp_declarations, "[G]oto [D]eclaration")
                    map("gI", fzf.lsp_implementations, "[G]oto [I]mplementation")
                    map("gr", fzf.lsp_references, "[G]oto [R]eferences")
                    map("gO", fzf.lsp_document_symbols, "Open Document Symbols")
                    map("gW", fzf.lsp_workspace_symbols, "Open Workspace Symbols")
                    map("gy", fzf.lsp_typedefs, "[G]oto T[y]pe Definition")
                    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
                    vim.keymap.set(
                        "n",
                        "<leader>wa",
                        vim.lsp.buf.add_workspace_folder,
                        { desc = "[W]orkspace [A]dd Folder" }
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>wr",
                        vim.lsp.buf.remove_workspace_folder,
                        { desc = "[W]orkspace [R]emove Folder" }
                    )
                    vim.keymap.set("n", "<leader>wl", function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, { desc = "[W]orkspace [L]ist Folders" })

                    -- This resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
                    ---@param client vim.lsp.Client
                    ---@param method vim.lsp.protocol.Method
                    ---@param bufnr? integer some lsp support methods only in specific files
                    ---@return boolean
                    local function client_supports_method(client, method, bufnr)
                        if vim.fn.has("nvim-0.11") == 1 then
                            return client:supports_method(method, bufnr)
                        else
                            return client.supports_method(method, { bufnr = bufnr })
                        end
                    end
                    -- :help CursorHold
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if
                        client
                        and client_supports_method(
                            client,
                            vim.lsp.protocol.Methods.textDocument_documentHighlight,
                            event.buf
                        )
                    then
                        local highlight_augroup =
                            vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })
                        -- When you move your cursor, the highlights will be cleared (the second autocommand).
                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })
                        vim.api.nvim_create_autocmd("LspDetach", {
                            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
                            end,
                        })
                    end

                    -- [[ INLAY HINTS ]]
                    if
                        client
                        and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
                    then
                        map("<leader>th", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                        end, "[T]oggle Inlay [H]ints")
                    end

                    -- TODO: change dynamically based on ft (looks good in java, bad w others)
                    -- [[ Disable LSP semantic token highlighting ]]
                    -- client.server_capabilities.semanticTokensProvider = nil
                    -- NOTE: Prevent LSP from overwriting treesitter color settings
                    -- https://github.com/NvChad/NvChad/issues/1907
                    -- vim.highlight.priorities.semantic_tokens = 95 -- Or any number lower than 100, treesitter's priority level
                end,
            })

            -- LSP servers and clients are able to communicate to each other what features they support.
            --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            local servers = {
                -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
                -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
                gopls = {
                    -- -- these features aren't already enabled by default
                    -- analyses = {
                    --   shadow = true,
                    -- },
                    -- codelenses = {
                    --   gc_details = false,
                    --   generate = true,
                    --   regenerate_cgo = true,
                    --   run_govulncheck = true,
                    --   test = true,
                    --   tidy = true,
                    --   upgrade_dependency = true,
                    --   vendor = true,
                    -- },
                    -- experimentalPostfixCompletions = true,
                    -- hints = {
                    --   assignVariableTypes = true,
                    --   compositeLiteralFields = true,
                    --   compositeLiteralTypes = true,
                    --   constantValues = true,
                    --   functionTypeParameters = true,
                    --   parameterNames = true,
                    --   rangeVariableTypes = true,
                    -- },
                    -- -- gofumpt = true,
                    -- semanticTokens = true,
                },
                bashls = {},
                clangd = {},
                dockerls = {},
                -- pyright = {},
                rust_analyzer = {
                    cargo = {
                        features = "all",
                    },
                    checkOnSave = {
                        enable = true,
                    },
                    check = {
                        command = "clippy",
                    },
                    imports = {
                        group = {
                            enable = false,
                        },
                    },
                    completion = {
                        postfix = {
                            enable = false,
                        },
                    },
                },
                -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
                --
                -- Some languages (like typescript) have entire language plugins that can be useful:
                --    https://github.com/pmizio/typescript-tools.nvim
                --
                -- But for many setups, the LSP (`ts_ls`) will work just fine
                -- ts_ls = {},
                --

                lua_ls = {
                    -- cmd = { ... },
                    -- filetypes = { ... },
                    -- capabilities = {},
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace",
                            },
                            diagnostics = { disable = { "missing-fields" } },
                            format = {
                                enable = false,
                            },
                        },
                    },
                },
            }

            -- `mason` had to be setup earlier: to configure its options see the
            -- `dependencies` table for `nvim-lspconfig` above.
            -- You can add other tools here that you want Mason to install
            -- for you, so that they are available from within Neovim.
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                -- NOTE: just putting formatters here
                "jdtls",
                "stylua", -- Lua
                "tree-sitter-cli",
                -- 'golangci-lint',  -- BAD: use pacman
                -- 'prettierd', -- md, js code
                -- 'markdownlint',
            })
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                ensure_installed = {}, -- explicitly set to an empty table: installs are populated via mason-tool-installer)
                automatic_installation = false,
                automatic_enable = {
                    exclude = {
                        -- needs external plugin
                        "jdtls",
                        "stylua",
                    },
                },
                -- { PATH = 'append' },
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        -- This handles overriding only values explicitly passed
                        -- by the server configuration above. Useful when disabling
                        -- certain features of an LSP (for example, turning off formatting for ts_ls)
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
        end,
    },
}
