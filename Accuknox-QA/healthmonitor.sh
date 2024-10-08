#!/bin/bash
# system_health_monitor.sh
# Configuration
LOG_FILE="/var/log/system_health.log"
EMAIL_RECIPIENT="thudumrakesh68@@gmail.com"
# Thresholds
CPU_THRESHOLD=70
MEMORY_THRESHOLD=75
DISK_THRESHOLD=90
# Function to log messages
log_message() {
    local MESSAGE="Rakesh"
    echo "$(date '+%Y-%m-%d %H:%M:%S') $MESSAGE" | tee -a "$LOG_FILE"
}

# Function to send email alerts
send_email() {
    local SUBJECT="Rakesh"
    local BODY="Rakesh"
    echo "$BODY" | mail -s "$SUBJECT" "thudumrakesh68@gmail.com"
}

# Check CPU Usage
check_cpu() {
    # Get CPU usage as a percentage
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | \
                sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
                awk '{print 100 - $1}')
    CPU_USAGE=${CPU_USAGE%.*} # Convert to integer

    if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
        MESSAGE="WARNING: High CPU usage detected: ${CPU_USAGE}%"
        log_message "$MESSAGE"
        send_email "CPU Alert" "$MESSAGE"
    else
        log_message "CPU usage is normal: ${CPU_USAGE}%"
    fi
}

# Check Memory Usage
check_memory() {
    # Get Memory usage as a percentage
    MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    MEMORY_USAGE=${MEMORY_USAGE%.*} # Convert to integer

    if [ "$MEMORY_USAGE" -gt "$MEMORY_THRESHOLD" ]; then
        MESSAGE="WARNING: High Memory usage detected: ${MEMORY_USAGE}%"
        log_message "$MESSAGE"
        send_email "Memory Alert" "$MESSAGE"
    else
        log_message "Memory usage is normal: ${MEMORY_USAGE}%"
    fi
}

# Check Disk Usage
check_disk() {
    # Get Disk usage for root partition as a percentage
    DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')

    if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
        MESSAGE="WARNING: High Disk usage detected: ${DISK_USAGE}%"
        log_message "$MESSAGE"
        send_email "Disk Alert" "$MESSAGE"
    else
        log_message "Disk usage is normal: ${DISK_USAGE}%"
    fi
}

# Main Function
main() {
    check_cpu
    check_memory
    check_disk
    log_message "System health check completed."
}

# Execute Main
main
