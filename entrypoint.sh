#!/bin/bash
# Persist ~/.claude.json (OAuth tokens, onboarding state) via the volume-
# mounted ~/.claude/ directory so credentials survive container restarts.
if [ ! -f "$HOME/.claude/.claude.json" ]; then
  echo '{"hasCompletedOnboarding":true}' > "$HOME/.claude/.claude.json"
fi
ln -sf "$HOME/.claude/.claude.json" "$HOME/.claude.json"

exec "$@"
