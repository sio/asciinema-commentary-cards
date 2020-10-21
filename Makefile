CARD_PANE_HEIGHT=10
TMUX_SESSION_NAME=screencast
SHELL=/bin/bash  # read in sh works differently


.PHONY: tmux-outside
tmux-outside:
	tmux new -s $(TMUX_SESSION_NAME)


.PHONY: record
record:
	asciinema ## tmux attach -t $(TMUX_SESSION_NAME)


.PHONY: tmux-inside
tmux-inside:
	tmux set -g status off
	tmux split-window
	tmux resize-pane -t 1 -y $(CARD_PANE_HEIGHT)
	tmux select-pane -t 1


.PHONY: cards
cards:
	tput civis  # hide cursor
	for filename in cards/*; do clear; cat "$$filename"; read; done; clear;
	tput cnorm  # restore cursor
