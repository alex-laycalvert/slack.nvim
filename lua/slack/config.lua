local M = {
    opts = {}
}

local defaults = {}

M.setup = function (opts)
    M.opts = vim.tbl_deep_extend('force', {}, defaults, opts or {})
end

M.reset = function ()
    M.opts = {}
end

return M
