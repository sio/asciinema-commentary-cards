CARD_PANE_HEIGHT=10
TMUX_SESSION_NAME=screencast
SHELL=/bin/bash  # read in sh works differently


.PHONY: prepare
prepare:
	tmux new -s $(TMUX_SESSION_NAME)


.PHONY: record
record:
	asciinema ## tmux attach -t $(TMUX_SESSION_NAME)


.PHONY: tmux
tmux:
	tmux set -g status off
	tmux split-window
	tmux resize-pane -t 1 -y $(CARD_PANE_HEIGHT)


.PHONY: cards
cards:
	tput civis; \
	cd cards/;  \
	for filename in *; do clear; cat "$$filename"; read; done; clear; cat;
