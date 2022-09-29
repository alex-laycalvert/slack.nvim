local M = {}

local config = require('slack.config')
local curl = require('slack.utils.curl')
local json = require('slack.utils.json')

-- Tests whether a user's token is authenticated
-- Returns an HTTP response with info about the authentication
--
-- ok {boolean} - If the requests was successful
-- error {string} - The error if unsuccessful
M.test_auth = function ()
    local response = curl.post('https://slack.com/api/auth.test', {
        ['Content-Type'] = 'application/json',
        ['Authorization'] = 'Bearer ' .. config.opts.slack_api_token
    })
    local response_json = json.decode(response[1])
    return response_json
end

-- Returns a list of channels attached to the given app
M.list_channels = function ()
    local response = curl.get('https://slack.com/api/conversations.list', {
        ['Content-Type'] = 'application/x-www-form-urlencoded',
        ['Authorization'] = 'Bearer ' .. config.opts.slack_api_token
    })
    local response_json = json.decode(response[1])
    return response_json
end

M.get_channel_history = function (channel)
    local response = curl.get('https://slack.com/api/conversations.history', {
        ['Content-Type'] = 'application/json',
        ['Authorization'] = 'Bearer ' .. config.opts.slack_api_token,
        ['{ channel'] = channel .. '}'
    })
    for k, v in pairs(response) do
        print(k, v)
    end
    if response == nil then return nil end
    -- local response_json = json.decode(response[1])
    return response
end

return M
