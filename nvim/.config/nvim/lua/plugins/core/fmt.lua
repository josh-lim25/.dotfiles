return {
    "stevearc/conform.nvim",
    keys = {
        {
            "<leader>fm",
            function()
                require("conform").format({ async = true, lsp_fallback = true })
            end,
            mode = "",
            desc = "[F]ormat buffer",
        },
    },
    opts = {
        -- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#options
        formatters_by_ft = {
            go = { "goimports", "gofmt" },
            lua = { "stylua" },
            cpp = { "clang-format" },
            bash = { "shfmt" },
            -- Conform will run multiple formatters sequentially
            python = { "isort", "black" },
            -- You can customize some of the format options for the filetype (:help conform.format)
            rust = { "rustfmt", lsp_format = "fallback" },
            -- Conform will run the first available formatter
            -- javascript = { "prettierd", "prettier", stop_after_first = true },
            -- typescript = { "prettierd", "prettier", stop_after_first = true },
            ["markdown"] = { { "prettierd", "prettier" } },
            ["markdown.mdx"] = { { "prettierd", "prettier" } },
            -- -- Use the "*" filetype to run formatters on all filetypes.
            -- ["*"] = { "codespell" },
            -- -- Use the "_" filetype to run formatters on filetypes that don't
            -- -- have other formatters configured.
            -- ["_"] = { "trim_whitespace" },
        },

        formatters = {
            shfmt = {
                prepend_args = { "-i", "4", "-ci" },
            },
            stylua = {
                prepend_args = {
                    "--indent-type",
                    "Spaces",
                    "--indent-width",
                    "2",  -- 4 is too much
                    "--call-parentheses",
                    "Always",
                },
            },
        },

        format_on_save = {
            lsp_fallback = true,
            timeout_ms = 500,
            lsp_format = "fallback",
        },
    }, -- setup
}
