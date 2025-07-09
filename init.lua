vim.hl = vim.highlight

require("config.lazy")
require("everforest").load()

vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<leader>x", ":.lua <CR>")
vim.keymap.set("v", "<leader>x", ":lua <CR>")

-- i forgot what these were for 
-- vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
-- vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")
-- vim.keymap.set("n", "<M-q>", "<cmd>cclose<CR>")

vim.keymap.set("n", "<leader>-", "<cmd>Oil<CR>")

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highligh when yanking copying text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end
})

vim.api.nvim_create_autocmd('TermOpen', {
    group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
    end
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client)
        if client == nil then
            return
        end
        if client.name == 'ruff' then
            -- Disable what Ruff should not do
            client.server_capabilities.hoverProvider = false
        end
    end,
    desc = 'LSP: Disable Ruff capabilities in favor of pyright',
})


vim.keymap.set("n", "<space>st", function()
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, 10)

    -- get channel of term to be able to send cmds to it. likely replaced by floatterm.
    -- job_id = vim.bo.channel
end)

-- send anything to the terminal -- extend to send code to REPL?
-- vim.keymap.set("n", "<space>example", function()
--     vim.fn.chansend(job_id, { "echo 'hi \n'" })
-- end)
-- send anything to the terminal -- extend to send code to REPL?
-- vim.keymap.set("n", "<space>example", function()
--     vim.fn.chansend(job_id, { "echo 'hi \n'" })
-- end)
