local M = {}

local buf = -1
local win = -1

local function open_buffer ()
    buf = vim.api.nvim_create_buf(true, false)
end

local function open_window ()
    local win_opts = {
    }
    if buf < 0 then open_buffer() end
end

local function update_view ()
    if win < 0 then open_window() end
end

M.open = function ()
    update_view()
end

M.close = function ()
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_buf_delete(buf)
    buf = -1
    win = -1
end

return M
