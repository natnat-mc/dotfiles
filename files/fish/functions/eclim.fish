# created by hand
function eclim --description "run eclim on a given file"
	if test (pgrep eclimd -c) = 0
		nohup ~/opt/eclipse/eclimd >/dev/null 2>/dev/null </dev/null &
	end
	vim.basic $argv
end
