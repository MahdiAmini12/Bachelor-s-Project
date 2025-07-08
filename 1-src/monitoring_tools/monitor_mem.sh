#!/bin/bash

# monitor_mem.sh - مانیتورینگ مصرف حافظه

INTERVAL=2
DURATION=30
LOG_FILE="mem_monitor_$(date +"%Y%m%d_%H%M%S").log"

echo "مانیتورینگ مصرف حافظه شروع شد..." | tee $LOG_FILE
echo "جمع‌آوری داده هر $INTERVAL ثانیه برای $DURATION ثانیه" | tee -a $LOG_FILE

while [ $DURATION -gt 0 ]; do
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    MEM_USAGE=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')
    echo "$TIMESTAMP - مصرف حافظه: $MEM_USAGE" | tee -a $LOG_FILE
    sleep $INTERVAL
    DURATION=$((DURATION-INTERVAL))
done

echo "مانیتورینگ مصرف حافظه کامل شد." | tee -a $LOG_FILE