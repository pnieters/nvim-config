return {
    'echasnovski/mini.nvim',
    config = function()
        local statusline = require 'mini.statusline'
        local comment = require 'mini.comment'
        -- local surround = require 'mini.surround'
        statusline.setup { use_icons = true }
        comment.setup {}
        -- surround.setup {}
    end
}
