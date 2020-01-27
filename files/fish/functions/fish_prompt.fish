function fish_prompt --description 'A powerline-like prompt'
	lua ~/.config/fish/prompt.lua $status (pwd) (whoami) (hostname);
end
