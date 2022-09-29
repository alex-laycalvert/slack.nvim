-- slack.nvim/lua/slack/init.lua
-- alex-laycalvert
--
-- https://github.com/alex-laycalvert/slack.nvim

local M = {}

local config = require('slack.config')
local api = require('slack.api')

local setup_complete = false

M.setup = function (opts)
    if setup_complete then return end
    config.setup(opts)
    setup_complete = true
end

M.run = function ()
    if not setup_complete then
        print('Please provide configuration options for slack.nvim')
        config.reset()
        return
    end

    print('Running Slack...')

    local auth_res = api.test_auth()
    if auth_res.ok then
        print('Slack Authentication Successful')
    else
        print('Slack Authentication Unsuccessful')
        print('Error: ' .. auth_res.error)
    end

    local conv_res = api.list_channels()
    local channels = {}
    local general = {}
    if conv_res.ok then
        channels = conv_res.channels
    end

    print('Channels Found:')
    for k, v in pairs(channels) do
        if v.name_normalized == 'general' then
            general = v
        end
        print('  ' .. v.name_normalized)
    end

    print('Getting history from channel...')
    local hist_res = api.get_channel_history(general.id)
    if hist_res.ok then
        print('Messages in general:')
        for k, v in pairs(hist_res.messages) do
            print('  ' .. v.user .. '> ' .. v.text)
        end
    else
        -- print('Error: ' .. hist_res.error)
    end
end

return M
