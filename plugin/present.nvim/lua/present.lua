local M = {}

M.setup = function()
    -- nothing
end

---@class present.Slides
---@fields slides present.Slide[]: The slides of the file

---@class present.Slide
---@fields title string: The title of the slide
---@fields body string[]: The body of the slide

---@param lines string[]: the lines in the buffer
---@return present.Slides

local function create_floating_window(opts)
    opts = opts or {}
    local width = opts.width or vim.o.columns
    local height = opts.height or vim.o.lines

    -- Calculate the position to center the window
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    -- Create a buffer
    buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer

    -- Define window configuration
    local win_config = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal", -- No borders or extra UI elements
        border = { " ", " ", " ", " ", " ", " ", " ", " ", },
    }

    -- Create the floating window
    local win = vim.api.nvim_open_win(buf, true, win_config)

    return { buf = buf, win = win }
end

local parse_slides = function(lines)
    local slides = { slides = {} }
    local current_slide = {
        title = "",
        body = {}
    }

    local separator = "^#"

    for _, line in ipairs(lines) do
        if line:find(separator) then
            if #current_slide.title > 0 then
                table.insert(slides.slides, current_slide)
            end
            current_slide = {
                title = line,
                body = {}
            }
        else
            table.insert(current_slide.body, line)
        end
    end
    table.insert(slides.slides, current_slide)

    return slides
end

M.start_presentation = function(opts)
    opts = opts or {}
    opts.bufnr = opts.bufnr or 0

    local lines = vim.api.nvim_buf_get_lines(opts.bufnr, 0, -1, false)
    local parsed = parse_slides(lines)
    local float = create_floating_window {}

    local current_slide = 1
    vim.keymap.set("n", "n", function()
            current_slide = math.min(current_slide + 1, #parsed.slides)
            vim.api.nvim_buf_set_lines(float.buf, 0, -1, false, parsed.slides[current_slide].body)
        end,
        { buffer = float.buf }
    )

    vim.keymap.set("n", "p", function()
            current_slide = math.max(current_slide - 1, 1)
            vim.api.nvim_buf_set_lines(float.buf, 0, -1, false, parsed.slides[current_slide].body)
        end,
        { buffer = float.buf }
    )

    vim.keymap.set("n", "q", function()
            vim.api.nvim_win_close(float.win, true)
        end,
        { buffer = float.buf }
    )

    local opt_list = {
        cmdheight = {
            original = vim.o.cmdheight,
            present = 0
        },
    }

    for opt, cfg in pairs(opt_list) do
        vim.opt[opt] = cfg.present
    end


    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = float.buf,
        callback = function()
            for opt, cfg in pairs(opt_list) do
                vim.opt[opt] = cfg.original
            end
        end,
    })

    vim.api.nvim_buf_set_lines(float.buf, 0, -1, false, parsed.slides[1].body)
end

-- M.start_presentation { bufnr = 8 }

-- vim.print(parse_slides {
--     "# Hello",
--     "this is something else",
--     "# World",
--     "this is another thing",
-- })

return M
