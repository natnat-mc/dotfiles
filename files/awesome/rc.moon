-- load luarocks
pcall require, 'luarocks.loader'

-- load our stdlib
gears=require 'gears'
awful=require 'awful'
require 'awful.autofocus'
wibox=require 'wibox'
beautiful=require 'beautiful'
naughty=require 'naughty'
menubar=require 'menubar'

-- handle errors
do
	inerror=false
	awesome.connect_signal 'debug::error', (err) ->
		return if inerror
		inerror=true
		naughty.notify {
			preset: naughty.config.presets.critical
			title: "Oopsie doopsie! We made a fucky wucky!"
			text: tostring err
		}
		inerror=false

-- setup theme
beautiful.init "#{gears.filesystem.get_themes_dir!}default/theme.lua"

-- standard commands
terminal='kitty'
editor='nvim'
editorcmd='kitty nvim'

-- modkey
modkey='Mod4'

-- layouts
awful.layout.layouts={
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair,
    awful.layout.suit.max.fullscreen,
}

-- main menu
mainmenu=awful.menu items: {
	{terminal, terminal}
	{editor, editorcmd}
	{'restart', awesome.restart}
	{'quit', awesome.quit}
}
launcher=awful.widget.launcher {
	image: beautiful.awesome_icon
	menu: mainmenu
}
