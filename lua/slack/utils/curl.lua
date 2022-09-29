local M = {}

local json = require('slack.utils.json')

M.curl = function (url, method, header, data)
    if url == nil then return nil end
    if method == nil then return nil end
    local curl_command = 'curl -s -X "' .. method .. '" '
    if header ~= nil then
        for header_key, header_value in pairs(header) do
            curl_command = curl_command .. '-H "' .. header_key .. ': ' .. header_value .. '" '
        end
    end
    if data ~= nil then
        for data_key, data_value in pairs(data) do
            curl_command = curl_command .. '-d "' .. data_key .. ': ' .. data_value .. '" '
        end
    end
    curl_command = curl_command .. '"' .. url .. '"'
    local response = vim.fn.systemlist(curl_command)
    local response_str = ''
    for _, v in pairs(response) do
        response_str = response_str .. v
    end
    return json.decode(response_str)
end

M.get = function (url, header, data)
    return M.curl(url, 'GET', header, data)
end

M.post = function (url, header, data)
    return M.curl(url, 'POST', header, data)
end

M.put = function (url, header, data)
    return M.curl(url, 'PUT', header, data)
end

M.delete = function (url, header, data)
    return M.curl(url, 'DELETE', header, data)
end

return M
