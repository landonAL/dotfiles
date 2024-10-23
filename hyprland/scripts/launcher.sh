#!/bin/bash

if COMMANDS=$(compgen -c 2>/dev/null); then
  # If we successfully get the commands, we know the shell is ready
  COMMAND=$(echo "$COMMANDS" | sort -u | fzf --layout=reverse --border)

  if [ -n "$COMMAND" ]; then
    # Run the command in the background and disown it
    hyprctl dispatch exec "$COMMAND"

    # Exit the script
    exit 0
  else
    exit 1 # User cancelled fzf
  fi
fi

exit 0
