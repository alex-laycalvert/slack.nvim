-- slack.nvim/lua/slack/init.lua
-- alex-laycalvert
--
-- https://github.com/alex-laycalvert/slack.nvim

local M = {}

local config = require('slack.config')
local api = require('slack.api')
local navbar = require('slack.windows.navbar')
local chat_display = require('slack.windows.chat_display')

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
        return
    end

    -- local users = {}

    -- local users_res = api.get_users()
    -- print('Getting Users...\n')
    -- if users_res.ok then
    --     print('Found Users:')
    --     for k, v in pairs(users_res.members) do
    --         print('User: ' .. v.profile.real_name_normalized)
    --         print('ID  : ' .. v.id)
    --         print('')
    --         users[v.id] = v
    --     end
    -- else
    --     print('Error: ' .. auth_res.error)
    -- end

    -- local conv_res = api.list_channels()
    -- local channels = {}
    -- local general = {}
    -- if conv_res.ok then
    --     channels = conv_res.channels
    -- end

    -- print('Channels Found:')
    -- for k, v in pairs(channels) do
    --     print('  ' .. v.name_normalized)
    -- end

    -- print('Getting history from ' .. channels[1].name_normalized .. '...')
    -- local hist_res = api.get_channel_history(channels[1].id)
    -- if hist_res.ok then
    --     print('Messages in ' .. channels[1].name_normalized .. ':')
    --     for k, v in pairs(hist_res.messages) do
    --         print('  ' .. users[v.user].profile.display_name_normalized .. '> ' .. v.text)
    --     end
    -- else
    --     print('Error: ' .. hist_res.error)
    -- end

    navbar.open()
end

return M
