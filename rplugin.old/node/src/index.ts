import { NvimPlugin } from 'neovim';
import * as Slack from './api';

const slack = (plugin: NvimPlugin) => {
    plugin.setOptions({
        dev: true,
        alwaysInit: false
    });

    plugin.registerCommand(
        'Slack',
        async () => {
            try {
                await plugin.nvim.outWriteLine('Starting Slack');
                await plugin.nvim.outWriteLine('SLACK TOKEN: ' + process.env.SLACK_API_TOKEN)
                const response = await Slack.testAuthentication();
                await plugin.nvim.outWriteLine(response.url);
            } catch (e) {
                await plugin.nvim.errWrite(e);
            }
        },
        { sync: false }
    );
}

export default slack;
