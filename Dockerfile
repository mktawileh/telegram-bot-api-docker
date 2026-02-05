# =========================
# Build stage
# =========================
FROM debian:bookworm-slim AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    g++ \
    cmake \
    gperf \
    pkg-config \
    libssl-dev \
    zlib1g-dev \
    ca-certificates \
    git \
 && rm -rf /var/lib/apt/lists/*

# Set C++ standard explicitly
ENV CXXFLAGS="-std=gnu++17"

WORKDIR /build

RUN git clone --recursive https://github.com/tdlib/telegram-bot-api.git

WORKDIR /build/telegram-bot-api

RUN mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/app -DCMAKE_BUILD_TYPE=Release .. && \
    cmake --build . --target install --parallel $(nproc)

# =========================
# Runtime stage
# =========================
FROM debian:bookworm-slim AS runtime

ENV DEBIAN_FRONTEND=noninteractive

# Install ONLY runtime deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl3 \
    zlib1g \
    libstdc++6 \
    libgcc-s1 \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy binary from builder
COPY --from=builder /app/bin/telegram-bot-api /app/telegram-bot-api
COPY entrypoint.sh /app/entrypoint.sh

# Ensure executable
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
