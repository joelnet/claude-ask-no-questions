#!/usr/bin/env bash
# Convenience launcher for claude-docker.
# Usage: ./claude.sh [extra-args...]
# Example: ./claude.sh -p "fix the bug"

set -euo pipefail  # Exit on error, undefined vars, or pipe failures

# Ensure the host-side config directory exists for credential persistence
mkdir -p ~/.claude.docker

docker run -it --rm \
  -v ~/.claude.docker:/home/claude/.claude \
  -v "$(pwd)":/app \
  claude-docker claude --dangerously-skip-permissions "$@"
  # -it            : interactive TTY
  # --rm           : remove container on exit
  # First -v       : persist Claude credentials across runs
  # Second -v      : mount current directory as the working directory
  # "$@"           : pass through any extra arguments
