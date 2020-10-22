OUTPUT?=rec-$(shell date +%s).asciicast
CARD_DIRECTORY?=cards
CARD_PANE_HEIGHT?=$(shell \
	expr \
		1 + \
		$$(wc -l $(CARD_DIRECTORY)/* \
		  |grep -vP '^\s*\d+\s*total\s*$$' \
		  |sort -n \
		  |tail -n1 \
		  |xargs \
		  |cut -d\  -f1) \
)
REC_IDLE_LIMIT?=1  # Limit recorded terminal inactivity to max 1 sec
TMUX_SESSION_NAME?=screencast

SHELL=/bin/bash  # read in sh works differently
ASCIINEMA?=asciinema
ANY_KEY=read -n1 -s


define PRE_CARD
This tmux session is almost ready for recording your asciicast

This pane will be used for showing commentary cards.
Use Ctrl+Space while recording to switch to the next card.

Prepare the pane below for your asciicast.

Shortcuts in 'prepare' mode:
	Ctrl+Space  - hide this message and show the first card
	Ctrl+] 	    - detach from this session when you're ready to start recording

Shortcuts in 'record' mode:
	make record - run this from outside tmux to start recording
	Ctrl+Space  - show next card
	Ctrl+]      - stop recording by detaching from this session
endef
export PRE_CARD


define POST_CARD
End of cards

Press Ctrl+Space to start again from the first one, Ctrl+C to exit
endef
export POST_CARD


.PHONY: prepare
prepare: .not-tmux .check-env
	tmux new -A -s $(TMUX_SESSION_NAME) "$(MAKE) .tmux-initialize; $(SHELL)"


.PHONY: record
record: .not-tmux
	@echo "Starting asciinema recording (use Ctrl+d to stop)..."
	@echo
	@echo "Press Enter when you're ready..."
	@$(ANY_KEY)
	$(ASCIINEMA) rec "$(OUTPUT)" -c "tmux attach -t $(TMUX_SESSION_NAME)" -i $(REC_IDLE_LIMIT)
	@echo "Run 'make destroy' to kill tmux session used for recording"


.PHONY: play
ifeq (,$(wildcard $(OUTPUT)))
play: OUTPUT=$(lastword $(sort $(wildcard rec-*.asciicast)))
endif
play:
	$(ASCIINEMA) play $(OUTPUT)

.PHONY: destroy
destroy:
	tmux kill-session -t $(TMUX_SESSION_NAME)


.PHONY: cards
cards: .only-tmux
	tput civis  # hide cursor
	clear; echo -n "$$PRE_CARD"; $(ANY_KEY)
	tmux resize-pane -t 1 -y $(CARD_PANE_HEIGHT)
	-while true; do \
		for filename in $(CARD_DIRECTORY)/*; do \
			clear; cat "$$filename"; $(ANY_KEY); \
		done; \
		clear; $(ANY_KEY); \
		clear; echo -n "$$POST_CARD"; $(ANY_KEY); \
	done
	tput cnorm  # restore cursor


.PHONY: dependencies
dependencies:
	apt update
	apt -y install asciinema tmux


.PHONY: .check-env
.check-env:
	@tmux -V
	@$(ASCIINEMA) --version
	@ls $(CARD_DIRECTORY)/* > /dev/null
	@grep --version


.PHONY: .tmux-initialize
.tmux-initialize: .only-tmux
	tmux set -g status off
	tmux set -g pane-active-border-style fg=white
	tmux set -g pane-border-style fg=white
	tmux setw -g pane-base-index 1
	tmux split-window
	tmux resize-pane -t 1 -y $(shell echo "$$PRE_CARD"|wc -l)
	tmux send-keys -t 1 'make cards' Enter
	tmux bind -n C-Space send-keys -t 1 Enter  # Ctrl+Space to show next card
	tmux bind -n C-] detach
	tmux select-pane -t 2


.PHONY: .not-tmux
.not-tmux:
	@[[ -z "$$TMUX" && -z "$$TMUX_PANE" ]] || { \
		echo Running this action within Tmux session is not supported; \
		exit 101; \
	}


.PHONY: .only-tmux
.only-tmux:
	@[[ ! -z "$$TMUX" && ! -z "$$TMUX_PANE" ]] || { \
		echo This action must only be executed within tmux session; \
		exit 101; \
	}
