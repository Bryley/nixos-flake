#!/usr/bin/env bash

# SESSION="_popup"   # background session name
SESSION="_popup_$(tmux display -p '#{window_id}')"
WIDTH="50%"
HEIGHT="50%"

# Get current pane's directory to start popup in something sensible
CUR_DIR="$(tmux display -p -F "#{pane_current_path}")"

if [[ "$(tmux display-message -p '#S')" == _popup* ]]; then
    tmux detach-client
    exit 0
fi

# If the session doesn't exist, create it (detached)
if ! tmux has-session -t "$SESSION" 2>/dev/null; then
    tmux -f "$HOME/.config/tmux/tmux-pop/config.tmux" new-session -d -s "$SESSION" -n main -c "$CUR_DIR"
    # tmux set-option -t "$SESSION" status off
fi

# Show the session inside a popup
tmux display-popup -w "$WIDTH" -h "$HEIGHT" -E "tmux attach -t $SESSION"
