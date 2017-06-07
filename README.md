# WiiU-Screenshot

A web server based on openresty to save a screenshot of a Nintendo WiiU.

# Installation

1. install the latest version of OpenResty from <http://openresty.org/en/>
2. install `luarocks` with OpenResty: <http://openresty.org/en/using-luarocks.html>
3. install `luafilesystem` by `luarocks`: `luarocks install luafilesystem`
4. install `lua-resty-session` by `luarocks`: `luarocks install lua-resty-session`
5. use `sudo apt-get install imagemagick` to install ImageMagick
6. install qiniu `qshell` tool from <https://developer.qiniu.com/kodo/tools/1302/qshell>

# Usage

Start the server:

```
$ cd wiiu-screenshot
$ cp src/config.lua.template src/config.lua
$ bin/server.sh restart
```

From your wiiu open the browser by `Home` button when you playing a game, then visit the started server to upload a screenshot.

Open the server from your PC's browser to view your uploaded screenshots.