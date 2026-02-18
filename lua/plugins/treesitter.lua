return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = {
                "bash", "c", "cpp", "html", "javascript", "json", "julia",
                "lua", "markdown", "markdown_inline", "python", "rust", "svelte",
                "typescript", "vim", "vimdoc"
            },

            auto_install = true,

            highlight = {
                enable = true,
                disable = function(_, buf)
                    local max_filesize = 1024 * 1024 -- 1 MB
                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
            },
            modules = {},
            sync_install = false,
            ignore_install = {},
        })
    end,
}



--     function()
--         require 'nvim-treesitter.configs'.setup {
--             ensure_installed = {
--                 "bash",
--                 "bibtex",
--                 "c",
--                 "css",
--                 "cmake",
--                 "cpp",
--                 "html",
--                 "javascript",
--                 "json",
--                 "julia",
--                 "lua",
--                 "make",
--                 "markdown",
--                 "markdown_inline",
--                 "python",
--                 "query",
--                 "rust",
--                 "svelte",
--                 "typescript",
--                 "vim",
--                 "vimdoc",
--             },
--             auto_install = false,
--
--             highlight = {
--                 enable = true,
--
--                 -- disable = { "c", "rust" },
--                 -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
--                 disable = function(lang, buf)
--                     local max_filesize = 100 * 1024 -- 100 KB
--                     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
--                     if ok and stats and stats.size > max_filesize then
--                         return true
--                     end
--                 end,
--
--                 additional_vim_regex_highlighting = false,
--             },
--         }
--     end
-- }
