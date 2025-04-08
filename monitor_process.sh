#!/bin/bash

MSG_INFO="[INFO]"
MSG_ERROR="[ERROR]"
MSG_CRITICAL="[CRITICAL]"
LOG_FILE="${LOG_FILE:-/var/log/monitoring.log}"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

log_message "$MSG_INFO Monitoring process ($PROCESS_NAME) started"
CURRENT_PID=$(pgrep -x "$PROCESS_NAME")
CODE=$?
if [[ $CODE -eq 0 ]]; then
    CURRENT_PID=$(echo "$CURRENT_PID" | head -n1)

fi
