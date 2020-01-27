# Defined in - @ line 1
function visudo --description 'alias visudo sudo env EDITOR=vi VISUAL=vi visudo'
	sudo env EDITOR=vi VISUAL=vi visudo $argv;
end
