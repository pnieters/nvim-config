return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require 'nvim-treesitter.configs'.setup {

            ensure_installed = {
                "bash",
                "bibtex",
                "c",
                "css",
                "cmake",
                "cpp",
                "html",
                "javascript",
                "json",
                "julia",
                "lua",
                "make",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "rust",
                "svelte",
                "typescript",
                "vim",
                "vimdoc",
            },
            auto_install = false,

            highlight = {
                enable = true,

                -- disable = { "c", "rust" },
                -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,

                additional_vim_regex_highlighting = false,
            },
        }
    end
}

-- THIS IS A STOLEN TREESITTER CONFIG THAT MAKES MOJO WORK.
--  {
--   "nvim-treesitter/nvim-treesitter",
--   event = { "BufReadPost", "BufNewFile" },
--   cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
--   build = ":TSUpdate",
--   dependencies = {
--     "nvim-treesitter/nvim-treesitter-textobjects",
--   },
--   opts = function()
--     return require "plugins.configs.treesitter"
--   end,
--   config = function(_, opts)
--     dofile(vim.g.base46_cache .. "syntax")
--     require("nvim-treesitter.configs").setup(opts)
--     -- use the python highlighter for .mojo files, which are recognized as conf ones
--     -- vim.treesitter.language.register('python', 'conf')
--
--     local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
--     parser_config.mojo = {
--       install_info = {
--         url = "https://github.com/lsh/tree-sitter-mojo", -- local path or git repo
--         files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
--         -- optional entries:
--         branch = "main", -- default branch in case of git repo if different from master
--         generate_requires_npm = false, -- if stand-alone parser without npm dependencies
--         requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
--       },
--       filetype = "mojo", -- if filetype does not match the parser name
--     }
--
--     -- Set the comment string for Mojo files
--     vim.api.nvim_create_autocmd("FileType", {
--       pattern = "mojo",
--       callback = function()
--         vim.bo.commentstring = "# %s"
--       end,
--     })
--   end,
-- },
