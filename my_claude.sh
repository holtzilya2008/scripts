#!/bin/bash

# A script to run Claude Code with the specified API key
# Put this script in ~/bin and make it executable
# For convenience, add an alias to `.bash_aliases` like:
# alias cl="~/bin/my_claude.sh"

ANTHROPIC_API_KEY="***********************************************" claude "$@"
