tmux:
	tmux set -g status off


cards:
	tput civis; \
	cd cards/;  \
	for filename in *; do clear; cat "$$filename"; read; done; clear; cat;
