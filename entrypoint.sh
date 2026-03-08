#!/bin/bash
# Create ~/.claude.json stub if it doesn't exist so Claude CLI
# doesn't re-trigger the onboarding/login flow every container start.
if [ ! -f "$HOME/.claude.json" ]; then
  echo '{"hasCompletedOnboarding":true}' > "$HOME/.claude.json"
fi
exec "$@"
