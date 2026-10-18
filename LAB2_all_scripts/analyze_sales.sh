#!/bin/bash

HELPTEXT="Correct usage of this script:
    analyze_sales.sh <csv_file_with_data>"

if [ $# -ne 1 ]; then
    echo -e "\e[31m Incorrect usage of this script\e[0m
    $HELPTEXT" >&2
    exit 1
fi

CSV_FILE="$1"

if [ ! -f "$CSV_FILE" ]; then
    echo -e "\e[31mERROR: file '$CSV_FILE' not found.\e[0m" >&2
    exit 1
fi

if [ ! -r "$CSV_FILE" ]; then
    echo -e "\e[31mERROR: Permission for reading '$CSV_FILE' denied.\e[0m" >&2
    exit 1
fi

REPORT_FILE="sales_report.txt"

total=0
count=0
max=0
{
    read -r
    while IFS=, read -r _ _ line || [ -n "$line" ]; do
        line="${line%%$'\r'}"
        if [[ ! "$line" =~ ^([1-9][0-9]*|0)$ ]]; then
            echo -e "\e[31mSYNTAX ERROR: non-integer value recieved: '$line' \e[0m SKIPPED" >&2
            continue
        fi
        (( total += line ))
        (( count++ ))
        if [ "$max" -lt $line ]; then
            max=$line
        fi
    done
} < "$CSV_FILE"

if [ "$count" -eq 0 ]; then
    echo -e "\e[31mRUNTIME ERROR: No data where read form file $CSV_FILE.\e[0m" >&2
    exit 1
fi

avg=$( awk -v t="$total" -v c="$count" 'BEGIN { printf "%.3f", t / c }' )

{
    echo "=========================================="
    echo "        SALES REPORT"
    echo "=========================================="
    echo "source:              $CSV_FILE"
    echo "creation date: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "sales amount: $count"
    echo "------------------------------------------"
    printf "Total value of sales:      %s\n" "$total"
    printf "Average cost:       %s\n" "$avg"
    printf "Highest cost:   %s\n" "$max"
    echo "=========================================="
} | tee "$REPORT_FILE"