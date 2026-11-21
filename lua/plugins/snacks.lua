return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            image = {
                enabled = true,
                doc = {
                    enabled = true,
                    inline = true,
                    float = true,
                    max_width = 80,
                    max_height = 40,
                },
                math = {
                    enabled = true,
                    latex = {
                        font_size = "Large",
                        packages = { "amsmath", "amssymb", "amsfonts", "amscd", "mathtools" },
                    },
                },
            },
        },
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        ft = { "markdown" },
        opts = {
            latex = { enabled = false },
        },
    },
}
