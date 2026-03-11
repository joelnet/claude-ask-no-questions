# Claude Ask No Questions - in Docker

I got tired of Claude's persistent questions and want Claude to just run. But also don't want it to accidentally wipe my hard drive.

## What is this

Docker image with Node.js 24, Python 3, and [Claude CLI](https://github.com/anthropics/claude-code) running in a Docker container.

## Why this exists

Claude Code's `--dangerously-skip-permissions` flag enables fully autonomous operation — no confirmation prompts before file edits, shell commands, or other actions. This is powerful but risky on a bare host: Claude can modify or delete any file your user account can access, run arbitrary shell commands, install packages globally, and more.

Running inside a Docker container provides natural sandboxing. Claude can only access what you explicitly mount into the container, limiting the blast radius of any unintended action.

### Benefits

- **Filesystem isolation** — only the mounted working directory (`-v $(pwd):/app`) is exposed; the rest of the host filesystem is untouched.
- **No persistent side effects** — `--rm` means the container is destroyed after each session; installed packages, temp files, etc. don't accumulate.
- **Controlled network access** — Docker networking can be further restricted if desired (e.g., `--network none`).
- **Reproducible environment** — consistent Node.js, Python, and tooling versions regardless of host OS.
- **Safe credential handling** — Claude credentials are stored in a dedicated `~/.claude.docker` directory, separate from any host Claude installation.

### Downsides / Limitations

- **Performance overhead** — Docker adds a small startup cost and I/O overhead on mounted volumes (especially on macOS).
- **Limited host access** — Claude cannot interact with host-level tools, services, or files outside the mount. This is the point, but it can be inconvenient.
- **Docker required** — users must have Docker installed and running.
- **Image size** — the image includes Node.js, Python, and Claude CLI, so it's not small.
- **No GUI / browser access** — Claude cannot open browsers or GUI tools from inside the container.

## Build

Clone this repo and build the container. Be sure to re-build it after any `Dockerfile` edits.

```sh
docker build -t claude-docker .
```

## Quick Start

After building, use the included shell script to launch. I copied this into `~/.local/bin` so so it's available in my `$PATH`.

```sh
./claude.sh
```

Start Claude normally:

```bash
# TIP: I usually rename `claude.sh` to `claudex` (on mac/linux)
claudex
```

Pass extra arguments directly:

```sh
./claude -p "fix the bug"
```

The script creates `~/.claude.docker` if needed and runs the container with `--dangerously-skip-permissions` by default.

## Manual Run

You can also run the container directly:

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
