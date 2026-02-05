#!/bin/sh
set -e

# -------------------------
# Required credentials
# -------------------------
: "${TELEGRAM_API_ID:?Missing TELEGRAM_API_ID}"
: "${TELEGRAM_API_HASH:?Missing TELEGRAM_API_HASH}"

ARGS="
--api-id=${TELEGRAM_API_ID}
--api-hash=${TELEGRAM_API_HASH}
"

# -------------------------
# Optional flags
# -------------------------
[ "${TG_LOCAL}" = "true" ] && ARGS="$ARGS --local"

[ -n "${TG_HTTP_PORT}" ] && ARGS="$ARGS --http-port=${TG_HTTP_PORT}"
[ -n "${TG_HTTP_STAT_PORT}" ] && ARGS="$ARGS --http-stat-port=${TG_HTTP_STAT_PORT}"
[ -n "${TG_DIR}" ] && ARGS="$ARGS --dir=${TG_DIR}"
[ -n "${TG_TEMP_DIR}" ] && ARGS="$ARGS --temp-dir=${TG_TEMP_DIR}"
[ -n "${TG_FILTER}" ] && ARGS="$ARGS --filter=${TG_FILTER}"
[ -n "${TG_MAX_WEBHOOK_CONNECTIONS}" ] && ARGS="$ARGS --max-webhook-connections=${TG_MAX_WEBHOOK_CONNECTIONS}"
[ -n "${TG_HTTP_IP}" ] && ARGS="$ARGS --http-ip-address=${TG_HTTP_IP}"
[ -n "${TG_HTTP_STAT_IP}" ] && ARGS="$ARGS --http-stat-ip-address=${TG_HTTP_STAT_IP}"
[ -n "${TG_LOG}" ] && ARGS="$ARGS --log=${TG_LOG}"
[ -n "${TG_VERBOSITY}" ] && ARGS="$ARGS --verbosity=${TG_VERBOSITY}"
[ -n "${TG_MEMORY_VERBOSITY}" ] && ARGS="$ARGS --memory-verbosity=${TG_MEMORY_VERBOSITY}"
[ -n "${TG_LOG_MAX_FILE_SIZE}" ] && ARGS="$ARGS --log-max-file-size=${TG_LOG_MAX_FILE_SIZE}"
[ -n "${TG_MAX_CONNECTIONS}" ] && ARGS="$ARGS --max-connections=${TG_MAX_CONNECTIONS}"
[ -n "${TG_CPU_AFFINITY}" ] && ARGS="$ARGS --cpu-affinity=${TG_CPU_AFFINITY}"
[ -n "${TG_MAIN_THREAD_AFFINITY}" ] && ARGS="$ARGS --main-thread-affinity=${TG_MAIN_THREAD_AFFINITY}"
[ -n "${TG_PROXY}" ] && ARGS="$ARGS --proxy=${TG_PROXY}"

# -------------------------
# Exec (allow extra args)
# -------------------------
exec /app/telegram-bot-api $ARGS "$@"
