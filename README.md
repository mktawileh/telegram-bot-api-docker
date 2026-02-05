# telegram-bot-api-docker

A lightweight, production-ready **Docker image and Docker Compose setup** for running the **official Telegram Bot API server** locally using `tdlib/telegram-bot-api`.

This project builds the Telegram Bot API server **from source** using a multi-stage Docker build to ensure:

* minimal runtime image size
* clean separation between build and runtime dependencies
* easy configuration via environment variables

---

## ✨ Features

* 🐳 Multi-stage Docker build (optimized & small runtime image)
* 🔐 Uses official Telegram Bot API server
* ⚙️ Fully configurable via environment variables
* 📦 Persistent data using Docker volumes
* 🚀 Ready to use with `docker-compose`

---

## 📦 What’s inside

* **Base OS:** Debian Bookworm Slim
* **Build stage:**

  * GCC (C++17)
  * CMake
  * gperf
  * OpenSSL (dev)
  * zlib (dev)
* **Runtime stage:**

  * OpenSSL 3
  * zlib
  * libstdc++
* **Entrypoint script** that converts env vars into CLI arguments

---

## 🚀 Quick Start

### 1️⃣ Prerequisites

* Docker
* Docker Compose
* Telegram API credentials from
  👉 [https://my.telegram.org](https://my.telegram.org)

You will need:

* `TELEGRAM_API_ID`
* `TELEGRAM_API_HASH`

---

### 2️⃣ Clone the repository

```bash
git clone https://github.com/mktawileh/telegram-bot-api-docker.git
cd telegram-bot-api-docker
```

---

### 3️⃣ Set environment variables

Create a `.env` file:

```env
TELEGRAM_API_ID=123456
TELEGRAM_API_HASH=your_api_hash_here
```

---

### 4️⃣ Run with Docker Compose

```bash
docker compose up --build
```

---

## 🧩 Docker Compose Example

```yaml
name: telegram-bot-api

services:
  api:
    image: telegram-bot-api
    container_name: telegram-bot-api
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - 8080:8080
      - 8787:8787
    environment:
      - TELEGRAM_API_ID=${TELEGRAM_API_ID}
      - TELEGRAM_API_HASH=${TELEGRAM_API_HASH}
      - TG_HTTP_PORT=8080
      - TG_HTTP_STAT_PORT=8787
      - TG_DIR=/app/data
      - TG_TEMP_DIR=/app/data/temp
      - TG_LOG=/app/data/log.txt
      - TG_VERBOSITY=1
      - TG_MEMORY_VERBOSITY=1
    volumes:
      - ./data:/app/data
```

---

## ⚙️ Configuration (Environment Variables)

| Variable              | Description                      |
| --------------------- | -------------------------------- |
| `TELEGRAM_API_ID`     | **Required** – Telegram API ID   |
| `TELEGRAM_API_HASH`   | **Required** – Telegram API hash |
| `TG_HTTP_PORT`        | HTTP API port (default: 8081)    |
| `TG_HTTP_STAT_PORT`   | Statistics port                  |
| `TG_DIR`              | Working directory                |
| `TG_TEMP_DIR`         | Temp files directory             |
| `TG_LOG`              | Log file path                    |
| `TG_VERBOSITY`        | Log verbosity level              |
| `TG_MEMORY_VERBOSITY` | Memory log verbosity             |

All options map directly to `telegram-bot-api` CLI flags.

---

## 📁 Data Persistence

The `./data` directory on the host is mounted to:

```
/app/data
```

This stores:

* database files
* logs
* temporary files

---

## 🛠️ Build Only

If you just want to build the image:

```bash
docker build -t telegram-bot-api .
```

---

## 🔒 Security Notes

* Credentials are passed **only via environment variables**
* No credentials are baked into the image
* Recommended to use `.env` and **never commit it**

---

## 📄 License

This project uses the official Telegram Bot API server.
Refer to the original project license:

👉 [https://github.com/tdlib/telegram-bot-api](https://github.com/tdlib/telegram-bot-api)

---

## 🙌 Credits

* Telegram Team – `tdlib/telegram-bot-api`
* Docker multi-stage best practices
