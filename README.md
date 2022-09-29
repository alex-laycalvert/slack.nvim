# slack.nvim

A Neovim Lua plugin to integrate Slack.

***IMPORTANT NOTICE***

This plugin will most likely get abandoned in it's current form because of various complications
related to dealing with the Slack API in Lua. To maintain an up to date list of messages in a channel
using Lua, I either have to constantly poll the API every few seconds to get the latest history or
I can do it the efficient way and make a separate application that subscribes to the Slack API
system.

I'll most likely end up making a standalone terminal application in something like Node.js and then
porting it to Neovim.

***WORK IN PROGRESS ***

I am still working on this plugin. Currently I have implemented using the Slack Web API
so that I can do all of the requests I need directly from Lua.

## Installation

This plugin requires the use of a [Slack Application](https://api.slack.com/) to work properly. Follow the instructions and
tutorials on the Slack Website to create the App and add it to your worksspace.

### Required

- Create a Slack App
- Generate OAuth User Tokens
- Install the App to your workspace

Using your plugin manager of choice (in my case [packer.nvim](https://github.com/wbthomason/packer.nvim)) you would put something
like the following:

```lua
use { 'alex-laycalvert/slack.nvim' }
```

Then later in your Neovim config, initialize the plugin:

```lua
require('slack').setup({
    -- ... your configurations
})
```

## Setup

Currently Supported Configurations:

- `slack_api_token`: This is an OAuth User token that you must generate in your Slack App settings. This is how the plugin is able
  to interact with the Slack Web API and is necessary for it to work. The following is a list of scopes you need
  to add to the token:
  - `channels:history`
  - `channels:read`
  - `channels:write`
  - `groups:history`
  - `groups:read`
  - `groups:write`
  - `users:read`
  - `im:history`
  - `im:read`
  - `im:write`
  - `mpim:history`
  - `mpim:read`
  - `mpim:write`
