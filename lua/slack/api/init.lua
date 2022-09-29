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
    return curl.post('https://slack.com/api/auth.test', {
        ['Content-Type'] = 'application/json',
        ['Authorization'] = 'Bearer ' .. config.opts.slack_api_token
    })
end

-- Returns a list of channels attached to the given app
M.get_channels = function ()
    return curl.get('https://slack.com/api/conversations.list', {
        ['Content-Type'] = 'application/x-www-form-urlencoded',
        ['Authorization'] = 'Bearer ' .. config.opts.slack_api_token
    })
end

M.get_channel_history = function (channel)
    return curl.get('https://slack.com/api/conversations.history?channel=' .. channel, {
        ['Content-Type'] = 'application/json',
        ['Authorization'] = 'Bearer ' .. config.opts.slack_api_token,
    })
end

M.get_users = function ()
    return curl.get('https://slack.com/api/users.list', {
        ['Content-Type'] = 'application/www-form-urlencoded',
        ['Authorization'] = 'Bearer ' .. config.opts.slack_api_token,
    })
end

return M
