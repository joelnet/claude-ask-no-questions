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

COPY --chmod=0755 entrypoint.sh /entrypoint.sh

WORKDIR /app

USER claude

# Install Claude CLI via native installer (as claude user so it lands in ~claude/)
RUN curl -fsSL https://claude.ai/install.sh | bash

ENV PATH="/home/claude/.local/bin:${PATH}"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
