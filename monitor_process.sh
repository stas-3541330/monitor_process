#!/bin/bash

MSG_DEBUG="[DEBUG]"
MSG_INFO="[INFO]"
MSG_ERROR="[ERROR]"
MSG_CRITICAL="[CRITICAL]"
LOG_FILE="${LOG_FILE:-/var/log/monitoring.log}"
PID_FILE="$RUNTIME_DIRECTORY/monitoring.pid"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

debug_log(){
    if [[ $DEBUG ]]; then
        log_message "$MSG_DEBUG $1"
    fi
}

debug_log "Monitoring process ($PROCESS_NAME) started"
debug_log "$RUNTIME_DIRECTORY"

CURRENT_PIDS=$(pgrep -x "$PROCESS_NAME")
CODE=$?

if [[ $CODE -eq 0 ]]; then
    # The process may have multiple PIDs, so we will iterate through each one
    OLD_PROCESS_NAME=$(head -n 1 $PID_FILE) || OLD_PROCESS_NAME=""
    if [[ -f $PID_FILE && $OLD_PROCESS_NAME == $PROCESS_NAME ]]; then
        OLD_PIDS=$(tail -n +2 $PID_FILE)
        MAX_RESTARTS=$(echo "$OLD_PIDS" | wc -w)
        CURRENT_COUNT=$(echo "$CURRENT_PIDS" | wc -w)
        RESTART_COUNT=0
        MISSING_PIDS=()
        # Iterate through the old PIDs and check if they are present in the current list
        for old_pid in $OLD_PIDS; do
            if ! echo "$CURRENT_PIDS" | grep -q "$old_pid"; then
                MISSING_PIDS+=("$old_pid")
            fi
        done
        MISSING_COUNT=${#MISSING_PIDS[@]}
        
        debug_log "Missing PIDs: [${MISSING_PIDS[*]}] | Total missing: $MISSING_COUNT"
        if [[ $CURRENT_COUNT -lt $MAX_RESTARTS ]]; then
            # Calculate how many processes were simply stopped
            STOPPED_COUNT=$((MAX_RESTARTS - CURRENT_COUNT))
            # Remove the last elements (processes that were simply stopped)
            MISSING_PIDS=("${MISSING_PIDS[@]::$MISSING_COUNT-$STOPPED_COUNT}")
            debug_log "Stopped PIDs count: $STOPPED_COUNT | Missing PIDs: [${MISSING_PIDS[*]}]"
        fi
        
        for pid in "${MISSING_PIDS[@]}"; do
            RESTART_COUNT=$((RESTART_COUNT + 1))
            log_message "$MSG_INFO Process $PROCESS_NAME with PID $pid was restarted"
        done

        debug_log "Total restarts detected: $RESTART_COUNT out of $MAX_RESTARTS possible"
    fi
    echo "$PROCESS_NAME" > $PID_FILE
    echo "$CURRENT_PIDS" >> $PID_FILE

else
    debug_log "Process $PROCESS_NAME is not running"
fi
