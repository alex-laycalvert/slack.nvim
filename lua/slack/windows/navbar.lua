local M = {
    channels_collapsed = false,
    collapsed_channel_header = '  Channels',
    expanded_channel_header = '  Channels',
    channels = {},
    items = {},
    first_item_line = 3,
    last_item_line = 4,
    selected_channel = nil,
    cursor_pos = -1,
    width = 35,
}

local api = require('slack.api')

local buf = -1
local win = -1

local function open_buffer ()
    if buf > 0 then return end
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

    vim.api.nvim_buf_set_keymap(
        buf ,'n', 'j',
        ':lua require("slack.windows.navbar").goto_next()<CR>',
        { noremap = true, silent = true, }
    )
    vim.api.nvim_buf_set_keymap(
        buf ,'n', 'k',
        ':lua require("slack.windows.navbar").goto_prev()<CR>',
        { noremap = true, silent = true, }
    )
    vim.api.nvim_buf_set_keymap(
        buf ,'n', '<CR>',
        ':lua require("slack.windows.navbar").select()<CR>',
        { noremap = true, silent = true, }
    )
end

local function open_window ()
    if win > 0 then return end
    if buf < 0 then open_buffer() end
    local gheight = vim.api.nvim_list_uis()[1].height

    local win_opts = {
        relative = 'win',
        width = M.width,
        height = gheight,
        row = 0,
        col = 0,
    }

    win = vim.api.nvim_open_win(buf, true, win_opts)
    vim.api.nvim_win_set_option(win, 'cursorline', true)
end

local function update_view ()
    if win < 0 then open_window() end
    vim.api.nvim_buf_set_option(buf, 'modifiable', true)
    local channel_header = M.channels_collapsed
        and M.collapsed_channel_header
        or M.expanded_channel_header
    vim.api.nvim_buf_set_lines(buf, 1, -1, false, {
        channel_header
    })
    local line_num = 2
    for k, v in pairs(M.channels) do
        local text = '\t'
        if M.selected_channel == k then
            text = text .. ''
        end
        text = text .. '#' .. k
        vim.api.nvim_buf_set_lines(buf, line_num, -1, false, {
            text
        })
        line_num = line_num + 1
    end
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    vim.api.nvim_win_set_cursor(win, { M.cursor_pos, 0 })
end

M.goto_next = function ()
    M.cursor_pos = M.cursor_pos + 1
    if M.items[M.cursor_pos] == nil then
        M.cursor_pos = M.first_item_line
    end
    update_view()
end

M.goto_prev = function ()
    M.cursor_pos = M.cursor_pos - 1
    if M.items[M.cursor_pos] == nil then
        M.cursor_pos = M.last_item_line
    end
    update_view()
end

M.select = function ()
    if M.items[M.cursor_pos] == nil then return end
    if M.items[M.cursor_pos].type == 'channel' then
        M.selected_channel = M.items[M.cursor_pos].name
    end
    update_view()
end

M.open = function ()
    local response = api.get_channels()
    if not response.ok then
        print('Error Getting Channels: ' .. response.error)
    end
    local current_line = M.first_item_line
    for k, v in pairs(response.channels) do
        M.channels[v.name_normalized] = v
        M.items[current_line] = {
            type = 'channel',
            name = v.name_normalized,
        }
        current_line = current_line + 1
    end
    M.cursor_pos = M.first_item_line
    update_view()
end                                                             

M.close = function ()
    if win > 0 then
        vim.api.nvim_win_close(win, true)
    end
    win = -1
    buf = -1
end

return M
