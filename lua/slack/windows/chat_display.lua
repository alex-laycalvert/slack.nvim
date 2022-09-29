-- slack.nvim/lua/slack/windows/chat_display.lua
-- alex-laycalvert
--
-- https://github.com/alex-laycalvert/slack.nvim

local M = {
    channel = {},
    messages = {},
}

local config = require('slack.config')
local api = require('slack.api')

local buf = -1
local win = -1

local function open_buffer ()
    if buf > 0 then return end
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_keymap(
        buf ,'n', 'q',
        ':lua require("slack.windows.chat_display").close()<CR>',
        { noremap = true, silent = true, }
    )
end

local function open_window ()
    if win > 0 then return end
    if buf < 0 then open_buffer() end
    local gwidth = vim.api.nvim_list_uis()[1].width
    local gheight = vim.api.nvim_list_uis()[1].height
    local win_opts = {
        relative = 'win',
        width = gwidth - config.opts.navbar_width,
        height = gheight - config.opts.chat_text_height,
        row = 0,
        col = config.opts.navbar_width + 1,
    }
    win = vim.api.nvim_open_win(buf, true, win_opts)
    vim.api.nvim_win_set_option(win, 'cursorline', true)
    vim.api.nvim_win_set_option(win, 'number', false)
end

local function update_view ()
    if win < 0 then open_window() end
    local current_line = 0
    for k, v in pairs(M.messages) do
        vim.api.nvim_buf_set_lines(buf, current_line, -1, false, {
            '> ' .. v.text
        })
        current_line = current_line + 1
    end
end

M.open = function (channel)
    M.channel = channel
    local response = api.get_channel_history(channel.id)
    if not response.ok then
        print('Error Getting Channel:', response.error)
    end
    M.messages = response.messages
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
