CARD_PANE_HEIGHT=10


tmux:
	tmux set -g status off
	tmux split-window
	tmux resize-pane -y $(CARD_PANE_HEIGHT)


cards:
	tput civis; \
	cd cards/;  \
	for filename in *; do clear; cat "$$filename"; read; done; clear; cat;
