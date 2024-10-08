import "lib/global";
import { autoreloadCss, updateCss } from "style";
import Bar from "bar/Bar";
import { bash, sh } from "lib/utils";

// TODO NTS: List:
// - [X] Proper reloading of files on save
// - [X] Fonts
// - [ ] Screen corners
// - [X] Button comp
// - [ ] Battery Icons
// - [ ] Start button for Wifi and volume
//      - [ ] Icons for it
// - [ ] Hyprland Workspaces
// - [ ] Save options.json file for system theme.
// - [ ] Work on popup window for altering theme
// - [ ] Fix:
// (com.github.Aylur.ags:14922): Gjs-Console-WARNING **: 22:28:15.306: passing the config object with default export is DEPRECATED. use App.config() instead

const DEBUG = (await bash("echo $PWD")).startsWith("/home/");

// If debug then enable auto reloading of styles
if (DEBUG) {
    autoreloadCss();
}

updateCss();

export default {
    windows: [Bar(0)]
}
