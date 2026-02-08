return {
    -- Mason
    {
        "williamboman/mason.nvim",
        opts = { ui = { border = "rounded" } },
    },

    -- Bridge Mason and LSP config
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            ensure_installed = {
                "lua_ls",
                "ruff",
                "pyright",
                "julials",
                "svelte",
                "ts_ls",
            },
        },
    },

    -- LSP config
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "folke/lazydev.nvim",
            ft = "lua", -- only load on lua files
            opts = {
                library = {
                    -- See the configuration section for more details
                    -- Load luvit types when the `vim.uv` word is found
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            },
        },
        config = function()
            -- Function to set keymaps for LSP
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    local opts = { noremap = true, silent = true, buffer = bufnr }

                    -- General LSP keymaps
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

                    -- Diagnostics keymaps
                    vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, opts)
                    vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, opts)
                    vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, opts)
                    vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist, opts)

                    if client and client:supports_method('textDocument/formatting') then
                        vim.api.nvim_create_autocmd('BufWritePre', {
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = bufnr, id = client.id })
                            end
                        })
                    end
                end,
            })

            vim.lsp.config('*', {
                capabilities = require('blink.cmp').get_lsp_capabilities(),
            })


            vim.lsp.config('pyright', {
                settings = {
                    pyright = { disableOrganizeImports = true },
                    python = { analysis = { ignore = { '*' } } },
                },
            })


            local servers = { "lua_ls", "ruff", "pyright", "julials", "svelte", "ts_ls" }
            vim.lsp.enable(servers)
        end,
    },
}
