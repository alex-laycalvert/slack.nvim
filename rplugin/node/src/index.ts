import { NvimPlugin } from "neovim";

export default (plugin: NvimPlugin) => {
    plugin.setOptions({
        dev: true,
        alwaysInit: false
    });
}
