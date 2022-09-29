if exists("g:loaded_slack_plugin")
    finish
endif
let g:loaded_slack_plugin = 1

command! -nargs=0 Slack lua require('slack').run()
