# Telegram Bot API Server - Docker Image

![Docker Pulls](https://img.shields.io/docker/pulls/mktawileh/telegram-bot-api?style=for-the-badge)
![Docker Image Size](https://img.shields.io/docker/image-size/mktawileh/telegram-bot-api/latest?style=for-the-badge)
![Docker Stars](https://img.shields.io/docker/stars/mktawileh/telegram-bot-api?style=for-the-badge)
![License](https://img.shields.io/github/license/mktawileh/telegram-bot-api-docker?style=for-the-badge)

A lightweight, production-ready Docker image for running the official **Telegram Bot API server** built from source using TDLib. Perfect for self-hosting Telegram bot APIs with minimal footprint.  
**Note:** This image is a community-maintained project and is **not** an official image from the Telegram team.

## 🚀 Quick Start

### Pull the Image
```bash
docker pull mktawileh/telegram-bot-api:latest
```

### Run Basic Container
```bash
docker run -d \
  --name telegram-bot-api \
  -p 8080:8080 \
  -p 8787:8787 \
  -e TELEGRAM_API_ID=your_api_id \
  -e TELEGRAM_API_HASH=your_api_hash \
  -v telegram-data:/app/data \
  mktawileh/telegram-bot-api:latest
```

## 📋 Prerequisites

1. **Telegram API Credentials** from [my.telegram.org](https://my.telegram.org):
   - `TELEGRAM_API_ID`
   - `TELEGRAM_API_HASH`

2. **Docker** installed on your system

## 🔧 Configuration

### Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `TELEGRAM_API_ID` | ✅ | - | Your Telegram API ID |
| `TELEGRAM_API_HASH` | ✅ | - | Your Telegram API hash |
| `TG_HTTP_PORT` | ❌ | `8081` | HTTP API port inside container |
| `TG_HTTP_STAT_PORT` | ❌ | `8787` | Statistics port inside container |
| `TG_VERBOSITY` | ❌ | `1` | Log verbosity (0-5) |
| `TG_MEMORY_VERBOSITY` | ❌ | `1` | Memory log verbosity |
| `TG_ALLOWED_IPS` | ❌ | - | Comma-separated allowed IPs |
| `TG_MAX_WEBHOOK_CONNECTIONS` | ❌ | `40` | Max webhook connections |
| `TG_WEBHOOK_MAX_CONNECTIONS` | ❌ | `40` | Max webhook connections |
| `TG_LOCAL` | ❌ | `false` | Enable local mode |

### Port Mapping

- **API Port**: Map container's HTTP port (default 8081) to host port
- **Stats Port**: Map container's stats port (default 8787) to host port

### Volume Mounts

Persist your bot data:
```bash
-v /path/on/host:/app/data
# or use named volume:
-v telegram-data:/app/data
```

## 🎯 Complete Examples

### Example 1: Basic Setup
```bash
docker run -d \
  --name telegram-bot-api \
  -p 8080:8081 \
  -p 8787:8787 \
  -e TELEGRAM_API_ID=123456 \
  -e TELEGRAM_API_HASH=abc123def456 \
  -v /home/user/telegram-data:/app/data \
  mktawileh/telegram-bot-api:latest
```

### Example 2: Advanced Configuration
```bash
docker run -d \
  --name telegram-bot-api \
  -p 8081:8081 \
  -p 8787:8787 \
  -e TELEGRAM_API_ID=123456 \
  -e TELEGRAM_API_HASH=abc123def456 \
  -e TG_HTTP_PORT=8081 \
  -e TG_HTTP_STAT_PORT=8787 \
  -e TG_VERBOSITY=3 \
  -e TG_LOCAL=true \
  -e TG_ALLOWED_IPS="127.0.0.1,192.168.1.100" \
  -v telegram-data:/app/data \
  --restart unless-stopped \
  mktawileh/telegram-bot-api:latest
```

### Example 3: Using Docker Compose (External)
Create a `docker-compose.yml` file:
```yaml
version: '3.8'

services:
  telegram-bot-api:
    image: mktawileh/telegram-bot-api:latest
    container_name: telegram-bot-api
    ports:
      - "8080:8081"
      - "8787:8787"
    environment:
      - TELEGRAM_API_ID=${TELEGRAM_API_ID}
      - TELEGRAM_API_HASH=${TELEGRAM_API_HASH}
      - TG_VERBOSITY=2
    volumes:
      - telegram-data:/app/data
    restart: unless-stopped

volumes:
  telegram-data:
```

Then run:
```bash
# Create .env file with your credentials
echo "TELEGRAM_API_ID=123456" > .env
echo "TELEGRAM_API_HASH=abc123def456" >> .env

# Start the service
docker-compose up -d
```

## 🔍 Health Check

The container includes a health check that monitors the statistics endpoint:
```bash
# Check container health
docker inspect --format='{{.State.Health.Status}}' telegram-bot-api

# View logs
docker logs telegram-bot-api

# View stats (if healthy)
curl http://localhost:8787
```

## 📊 Monitoring

Access statistics at:
```
http://localhost:8787
```

## 🐳 Docker Commands Cheat Sheet

```bash
# Pull latest version
docker pull mktawileh/telegram-bot-api:latest

# Run with specific version
docker run mktawileh/telegram-bot-api:1.0.0

# View running container
docker ps

# View logs
docker logs telegram-bot-api -f

# Stop container
docker stop telegram-bot-api

# Remove container
docker rm telegram-bot-api

# Remove image
docker rmi mktawileh/telegram-bot-api:latest

# Create named volume
docker volume create telegram-data

# Inspect volume
docker volume inspect telegram-data
```

## 🔒 Security Best Practices

1. **Use Docker Secrets** (in Swarm mode):
```bash
echo "your_api_id" | docker secret create telegram_api_id -
echo "your_api_hash" | docker secret create telegram_api_hash -
```

2. **Limit Network Exposure**:
```bash
# Only expose to localhost
-p 127.0.0.1:8080:8081
```

3. **Use Read-Only Root Filesystem** (if possible):
```bash
--read-only \
--tmpfs /tmp \
--tmpfs /run \
--tmpfs /var/tmp
```

## 🚨 Troubleshooting

### Common Issues:

1. **Container exits immediately**
   ```bash
   # Check logs
   docker logs telegram-bot-api
   
   # Common causes:
   # - Missing API_ID or API_HASH
   # - Port already in use
   ```

2. **Can't connect to API**
   ```bash
   # Verify ports are mapped correctly
   docker port telegram-bot-api
   
   # Test connectivity
   curl http://localhost:8080
   ```

3. **Permission issues with volumes**
   ```bash
   # Check volume permissions
   docker exec telegram-bot-api ls -la /app/data
   
   # Fix by setting proper ownership
   docker run ... -u 1000:1000 ...
   ```

## 🏗️ Architecture

- **Base Image**: Debian Bookworm Slim
- **Build**: Multi-stage build (keeps runtime image small)
- **Source**: Built from [tdlib/telegram-bot-api](https://github.com/tdlib/telegram-bot-api)
- **Architectures**: Published as a multi-arch image (e.g. `linux/amd64`, `linux/arm64`)
- **Size**: ~100MB (compressed)

## 🙏 Credits

This Docker image packages the official **Telegram Bot API server** implementation from  
[tdlib/telegram-bot-api](https://github.com/tdlib/telegram-bot-api). All core server functionality and protocol
implementation are provided by the upstream project; this repository focuses on containerization and distribution and is not affiliated with or endorsed by Telegram.

## 📝 Tags Available

- `latest` - Most recent stable build
- `1.0.0` - Versioned releases
- `nightly` - Daily builds (if configured)

## 🔄 Updates

To update to the latest version:
```bash
docker pull mktawileh/telegram-bot-api:latest
docker stop telegram-bot-api
docker rm telegram-bot-api
# Re-run with your configuration
```

## 🤝 Contributing

Found an issue or have a suggestion?
- GitHub: [mktawileh/telegram-bot-api-docker](https://github.com/mktawileh/telegram-bot-api-docker)
- Report bugs via GitHub Issues
- Pull requests welcome!

## 📄 License

This Docker image is licensed under the same terms as the original Telegram Bot API.

## 🌟 Star History

If you find this useful, please consider:
- Giving a ⭐ on [GitHub](https://github.com/mktawileh/telegram-bot-api-docker)
- Sharing with other developers
- Reporting issues or suggestions

---

**Maintained by [Mohammad Tawileh](https://github.com/mktawileh)**  
*For more Docker images, check my [Docker Hub profile](https://hub.docker.com/u/mktawileh)*
