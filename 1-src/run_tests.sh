#!/bin/bash

# اسکریپت اجرای تست‌های مقایسه‌ای Docker و Podman
# نویسنده: [نام شما]
# تاریخ: [تاریخ امروز]

# تنظیمات اولیه
TEST_DIR="./test_results"
mkdir -p $TEST_DIR
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="$TEST_DIR/test_log_$DATE.txt"

# تابع اجرای تست‌های sysbench
run_sysbench_tests() {
    echo "=== اجرای تست‌های sysbench ===" | tee -a $LOG_FILE
    
    # تست CPU
    echo "تست CPU در حال اجرا..." | tee -a $LOG_FILE
    sysbench cpu --cpu-max-prime=20000 run >> "$TEST_DIR/cpu_test_$DATE.txt" 2>&1
    
    # تست حافظه
    echo "تست حافظه در حال اجرا..." | tee -a $LOG_FILE
    sysbench memory --memory-block-size=1K --memory-total-size=10G run >> "$TEST_DIR/memory_test_$DATE.txt" 2>&1
    
    echo "تست‌های sysbench با موفقیت انجام شد." | tee -a $LOG_FILE
}

# تابع اجرای تست‌های stress-ng
run_stress_ng_tests() {
    echo "=== اجرای تست‌های stress-ng ===" | tee -a $LOG_FILE
    
    # تست فشار روی CPU
    echo "تست فشار روی CPU (4 هسته) به مدت 60 ثانیه..." | tee -a $LOG_FILE
    stress-ng --cpu 4 --timeout 60s --metrics-brief >> "$TEST_DIR/stress_cpu_$DATE.txt" 2>&1
    
    # تست فشار روی حافظه
    echo "تست فشار روی حافظه (1GB) به مدت 60 ثانیه..." | tee -a $LOG_FILE
    stress-ng --vm 1 --vm-bytes 1G --timeout 60s --metrics-brief >> "$TEST_DIR/stress_mem_$DATE.txt" 2>&1
    
    echo "تست‌های stress-ng با موفقیت انجام شد." | tee -a $LOG_FILE
}

# تابع جمع‌آوری اطلاعات سیستم
collect_system_info() {
    echo "=== جمع‌آوری اطلاعات سیستم ===" | tee -a $LOG_FILE
    lscpu >> "$TEST_DIR/system_info_$DATE.txt"
    free -h >> "$TEST_DIR/system_info_$DATE.txt"
    uname -a >> "$TEST_DIR/system_info_$DATE.txt"
    echo "اطلاعات سیستم ذخیره شد." | tee -a $LOG_FILE
}

# اجرای اصلی
main() {
    echo "شروع تست‌ها در تاریخ $DATE" | tee $LOG_FILE
    collect_system_info
    run_sysbench_tests
    run_stress_ng_tests
    echo "تمام تست‌ها با موفقیت انجام شد." | tee -a $LOG_FILE
}

main