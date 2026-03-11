FROM node:24-bookworm

# Install Python 3 and pip
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-venv \
    && rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1

RUN usermod -l claude -d /home/claude -m node && groupmod -n claude node \
    && mkdir -p /app && chown claude:claude /app

# Install Claude CLI (as root, then fix ownership so the claude user can auto-update)
RUN npm install -g @anthropic-ai/claude-code && npm cache clean --force \
    && chown -R claude:claude /usr/local/lib/node_modules /usr/local/bin

COPY --chmod=0755 entrypoint.sh /entrypoint.sh

WORKDIR /app

USER claude

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
