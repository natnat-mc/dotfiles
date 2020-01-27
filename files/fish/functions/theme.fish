# Defined in /home/codinget/.config/fish/functions/theme.fish @ line 1
function theme --description 'A kitty theme helper'
	set -l t $argv[1]
	set -l themepath ~/.config/kitty/kitty-themes/themes ~/.config/kitty/themes
	for p in $themepath
		set -l tf $p/$t.conf
		if test -e $tf
			kitty @ set-colors -a $tf
			return 0
		end
	end
	printf "Theme %s not found\n" $t 1>&2
	return 0
end

