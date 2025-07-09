return {
    'neanias/everforest-nvim',
    version = false,
    lazy = false,
    priority = 1000,
    config = function()
        require('everforest').setup({
            -- config goes here.
            background = 'medium',
            transparent_background_level = 1.0,
        })
    end
}
