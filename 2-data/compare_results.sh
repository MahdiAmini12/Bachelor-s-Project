#!/bin/bash

# اسکریپت مقایسه نتایج Docker و Podman

DOCKER_DIR="./docker_results"
PODMAN_DIR="./podman_results"
OUTPUT_DIR="./comparison_results"

mkdir -p $OUTPUT_DIR

compare_files() {
    diff -u "$DOCKER_DIR/$1" "$PODMAN_DIR/$1" > "$OUTPUT_DIR/${1%.*}_diff.txt"
    echo "نتایج مقایسه برای $1 در $OUTPUT_DIR/${1%.*}_diff.txt ذخیره شد"
}

compare_files "cpu/sysbench_cpu_test_2023-11-15.txt"
compare_files "memory/stress_ng_mem_test_2023-11-15.log"
compare_files "network/iperf_test_2023-11-15.json"

# ایجاد گزارش خلاصه
{
    echo "خلاصه نتایج مقایسه - $(date)"
    echo "================================="
    echo "تست CPU (sysbench):"
    grep "events per second" "$DOCKER_DIR/cpu/sysbench_cpu_test_2023-11-15.txt"
    grep "events per second" "$PODMAN_DIR/cpu/sysbench_cpu_test_2023-11-15.txt"
    echo ""
    echo "تست حافظه (stress-ng):"
    grep "bogo ops" "$DOCKER_DIR/memory/stress_ng_mem_test_2023-11-15.log"
    grep "bogo ops" "$PODMAN_DIR/memory/stress_ng_mem_test_2023-11-15.log"
} > "$OUTPUT_DIR/summary_report.txt"

echo "گزارش خلاصه در $OUTPUT_DIR/summary_report.txt ایجاد شد"