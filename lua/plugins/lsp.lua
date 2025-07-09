return {
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
        local on_attach = function(client, bufnr)
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
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
            vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist, opts)
        end

        local capabilities = require('blink.cmp').get_lsp_capabilities()
        local lspconfig = require("lspconfig");


        lspconfig.lua_ls.setup {
            on_attach = on_attach,
            capabilities = capabilities,
        }

        lspconfig.ruff.setup{
        }

        lspconfig.pyright.setup {
            settings = {
                pyright = {
                    disableOrganizeImports = true,
                },
                python = {
                    analysis = {
                        ignore = { '*' },
                    },
                },
            },
        }

        lspconfig.julials.setup {
            -- cmd = { "julia", "--startup-file=no", "--history-file=no", "e",
            --     [[
            --     using LanguageServer; using Pkg; import SymbolServer;
            --     server = LanguageServer.LanguageServerInstance(stdin, stdout, false);
            --     server.runlinter = true;
            --     run(server);
            --     ]]
            -- },
            -- filetypes = { "julia" },
            -- root_dir = lspconfig.util.find_git_ancestor or vim.loop.os_homedir,
            on_attach = on_attach,
            capabilities = capabilities,
        }

        lspconfig.svelte.setup {
            on_attach = on_attach,
            capabilities = capabilities,
        }

        lspconfig.ts_ls.setup {
            on_attach = on_attach,
            capabilities = capabilities,
        }

        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if not client then return end
                if client.supports_method('textDocument/formatting') then
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        buffer = args.buf,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
                        end
                    })
                end
            end
        }
        )
    end,
}
-- ~/.congif/nvim/lua/plugins/mojo-conf.lua

-- lspconfig from the mojo discord. The trick is to start magic shell before nvim
-- return {
--   "neovim/nvim-lspconfig",
--   opts = {
--     servers = {
--       mojo = {
--         on_new_config = function(config)
--           if vim.fn.executable("mojo-lsp-server") == 0 then
--             vim.notify(
--               "(Run `magic shell` before entering neovim)",
--               vim.log.levels.WARN,
--               { title = "MOJO LSP NOT STARTED", icon = "🚨", timeout = 10000 }
--             )
--             -- avoid trying to run mojo-lsp-server
--             config.cmd = { "echo", "" }
--             return
--           end
--         end,
--       },
--     },
--   },
-- }
