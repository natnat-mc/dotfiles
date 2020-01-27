function start --description 'An easy way to start a command completely detached'
	nohup $argv >/dev/null 2>&1 </dev/null &
	disown
end
