return {
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        lazy = false,           -- main does not support lazy-loading
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter').setup({
                install_dir = vim.fn.stdpath('data') .. '/site',
            })
            local parsers = {
                'go', 'bash', 'cpp', 'diff', 'c', 'java', 'lua', 'vim',
                'vimdoc', 'markdown', 'markdown_inline', 'gitcommit',
                'git_rebase', 'gitattributes', 'gitignore', 'rust', 'python',
                'html', 'css', 'yaml', 'json', 'toml', 'dockerfile', 'make',
                'sql', 'http',
            }
            require('nvim-treesitter').install(parsers)

            local lsp_disable_highlight_langs = {
                python = true, javascript = true, typescript = true,
            }
            local extra_regex_syntax = {
                gitcommit = true, ruby = true,
            }
            local no_ts_indent = {
                yaml = true,
            }
            local MAX_FILESIZE = 100 * 1024 -- 100 KB

            vim.api.nvim_create_autocmd('FileType', {
                group = vim.api.nvim_create_augroup('user.treesitter', { clear = true }),
                callback = function(ev)
                    local buf = ev.buf
                    local lang = vim.treesitter.language.get_lang(ev.match) or ev.match

                    -- disable for huge files
                    local fname = vim.api.nvim_buf_get_name(buf)
                    local ok, stats = pcall(vim.uv.fs_stat, fname)
                    if ok and stats and stats.size > MAX_FILESIZE then
                        return
                    end

                    -- highlight
                    local skip_hl = lsp_disable_highlight_langs[lang]
                        and vim.bo[buf].buftype ~= 'nofile'
                    if not skip_hl then
                        pcall(vim.treesitter.start, buf, lang)
                    end

                    -- some filetypes want vim-regex syntax in addition to / instead of TS
                    if extra_regex_syntax[ev.match] then
                        vim.bo[buf].syntax = 'ON'
                    end

                    -- Folds
                    -- vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                    -- vim.wo[0][0].foldmethod = 'expr'

                    -- Indent (experimental upstream)
                    if not no_ts_indent[ev.match] then
                        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
    },

    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
        config = function()
            require('nvim-treesitter-textobjects').setup({
                select = {
                    lookahead = true,
                    include_surrounding_whitespace = false,
                    -- selection_modes can map captures to 'v'/'V'/'<c-v>' if you want
                },
                move = {
                    set_jumps = true,
                },
            })

            local select = require('nvim-treesitter-textobjects.select')
            local swap   = require('nvim-treesitter-textobjects.swap')
            local move   = require('nvim-treesitter-textobjects.move')

            -- helper: select keymap in x + o
            local function sel(lhs, capture, desc)
                vim.keymap.set({ 'x', 'o' }, lhs, function()
                    select.select_textobject(capture, 'textobjects')
                end, { silent = true, desc = desc })
            end

            ---------------- SELECTS ----------------
            sel('af', '@function.outer',  'a function')
            sel('if', '@function.inner',  'inner function')
            sel('al', '@loop.outer',      'a loop')
            sel('il', '@loop.inner',      'inner loop')
            sel('aF', '@call.outer',      'a call')
            sel('iF', '@call.inner',      'inner call')
            sel('ai', '@conditional.outer', 'a conditional')
            sel('ii', '@conditional.inner', 'inner conditional')
            sel('aa', '@parameter.outer', 'a parameter')
            sel('ia', '@parameter.inner', 'I love life')
            sel('a/', '@comment.outer',   'a comment')
            sel('i/', '@comment.inner',   'inner comment')
            sel('in', '@number.inner',    'inner number')
            sel('ak', '@block.outer',     'a block')
            sel('ik', '@block.inner',     'inner block')
            sel('ac', '@class.outer',     'a class')
            sel('ic', '@class.inner',     'inner class')

            ---------------- SWAPS ----------------
            local function swap_next(lhs, capture)
                vim.keymap.set('n', lhs, function() swap.swap_next(capture) end,
                    { silent = true, desc = 'swap next ' .. capture })
            end
            local function swap_prev(lhs, capture)
                vim.keymap.set('n', lhs, function() swap.swap_previous(capture) end,
                    { silent = true, desc = 'swap prev ' .. capture })
            end

            swap_next(')m', '@function.outer')
            swap_next(')a', '@parameter.inner')
            swap_next(')c', '@comment.outer')
            swap_next(')b', '@block.outer')
            swap_next(')l', '@class.outer')
            swap_next(')s', '@statement.outer')
            swap_next(')A', '@attribute.outer')

            swap_prev('(m', '@function.outer')
            swap_prev('(a', '@parameter.inner')
            swap_prev('(c', '@comment.outer')
            swap_prev('(b', '@block.outer')
            swap_prev('(l', '@class.outer')
            swap_prev('(s', '@statement.outer')
            swap_prev('(A', '@attribute.outer')

            ---------------- MOVES ----------------
            vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
                move.goto_next_start('@function.outer', 'textobjects')
            end, { silent = true, desc = 'Next function start' })
            vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
                move.goto_previous_start('@function.outer', 'textobjects')
            end, { silent = true, desc = 'Prev function start' })

            -- Optional: make ; and , repeat the last TS move
            -- local rep = require('nvim-treesitter-textobjects.repeatable_move')
            -- vim.keymap.set({ 'n', 'x', 'o' }, ';', rep.repeat_last_move_next)
            -- vim.keymap.set({ 'n', 'x', 'o' }, ',', rep.repeat_last_move_previous)
        end,
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },
}

--  @block.inner
--  @block.outer
--  @call.inner
--  @call.outer
--  @class.inner
--  @class.outer
--  @comment.outer
--  @conditional.inner
--  @conditional.outer
--  @frame.inner
--  @frame.outer
--  @function.inner
--  @function.outer
--  @loop.inner
--  @loop.outer
--  @parameter.inner
--  @parameter.outer
--  @scopename.inner
--  @statement.outer
