# claude-docker

Docker image with Node.js 24, Python 3, and [Claude CLI](https://github.com/anthropics/claude-code).

## Build

```sh
docker build -t claude-docker .
```

## Run

```sh
mkdir -p ~/.claude.docker
docker run -it --rm \
  -v ~/.claude.docker:/home/claude/.claude \
  -v "$(pwd)":/app \
  claude-docker claude --dangerously-skip-permissions
```

The first time you run the container, Claude CLI will prompt you to sign in via the browser. After that, your credentials are saved in `~/.claude.docker` on the host and persist across container restarts.

## Authentication Details

Claude CLI requires two things to skip the login prompt:

- **`~/.claude/.credentials.json`** — OAuth tokens (access token, refresh token, expiry)
- **`~/.claude.json`** — onboarding state, specifically `hasCompletedOnboarding: true`

The volume mount (`-v ~/.claude.docker:/home/claude/.claude`) persists the credentials file. The entrypoint script (`entrypoint.sh`) creates the `~/.claude.json` stub automatically on each container start so Claude doesn't re-trigger the onboarding flow.

## Included Tools

- **Node.js 24** + npm
- **Python 3** + pip + venv
- **Claude CLI** (`@anthropic-ai/claude-code`)
