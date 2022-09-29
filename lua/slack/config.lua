local M = {
    opts = {}
}

local defaults = {
    navbar_width = 35,
    chat_text_height = 15,
}

M.setup = function (opts)
    M.opts = vim.tbl_deep_extend('force', {}, defaults, opts or {})
end

M.reset = function ()
    M.opts = {}
end

return M
