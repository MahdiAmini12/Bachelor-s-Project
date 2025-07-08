#!/bin/bash

# اسکریپت‌های مانیتورینگ سیستم
# monitor_cpu.sh - مانیتورینگ مصرف CPU

INTERVAL=1  # بازه زمانی بر حسب ثانیه
DURATION=60 # مدت زمان مانیتورینگ بر حسب ثانیه
LOG_FILE="cpu_monitor_$(date +"%Y%m%d_%H%M%S").log"

echo "مانیتورینگ مصرف CPU شروع شد..." | tee $LOG_FILE
echo "جمع‌آوری داده هر $INTERVAL ثانیه برای $DURATION ثانیه" | tee -a $LOG_FILE

for ((i=0; i<=$DURATION; i++)); do
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    echo "$TIMESTAMP - مصرف CPU: $CPU_USAGE%" | tee -a $LOG_FILE
    sleep $INTERVAL
done

echo "مانیتورینگ مصرف CPU کامل شد." | tee -a $LOG_FILE