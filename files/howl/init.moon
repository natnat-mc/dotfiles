howl.signal.connect 'app-ready', ->
	howl.command.vi_on!

howl.command.alias 'buffer-close', 'c'
howl.command.alias 'exec', '!'
howl.command.alias 'project-exec', '!!'
