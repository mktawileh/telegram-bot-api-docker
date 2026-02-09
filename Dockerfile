FROM alpine:3.19 AS builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN apk add --no-cache \
    git \
    cmake \
    build-base \
    linux-headers \
    openssl-dev \
    zlib-dev \
    gperf

WORKDIR /build

RUN git clone --recursive https://github.com/tdlib/telegram-bot-api.git

WORKDIR /build/telegram-bot-api

RUN mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_INSTALL_PREFIX=/usr/local \
          -DCMAKE_CXX_FLAGS="-Os -s" \
          -DCMAKE_C_FLAGS="-Os -s" \
          .. && \
    cmake --build . --target install -j$(nproc) && \
    strip /usr/local/bin/telegram-bot-api

FROM alpine:3.19

RUN apk add --no-cache \
    libstdc++ \
    libssl3 \
    libcrypto3 \
    zlib && \
    rm -rf /var/cache/apk/*

COPY --from=builder /usr/local/bin/telegram-bot-api /app/telegram-bot-api

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

WORKDIR /app

EXPOSE 8081 8082

ENTRYPOINT ["/app/entrypoint.sh"]