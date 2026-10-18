#!/bin/bash

HELPTEXT="Correct usage of this script:
    analyze_sales.sh [OPTION] <csv_file_with_data>
    
    OPTIONS:
        -f <filename_extension> - use this format for output file
        -g                      - import resulting .csv to import data to DB"

if [ $# -lt 1 ] || [ $# -ge 5 ]; then
    echo -e "\e[31m Incorrect usage of this script\e[0m
    $HELPTEXT" >&2
    exit 1
fi

#PART0 - READING OPTIONS
PARSED_PARAMS=$(getopt -o f:g -- "$@")

if [ $? -ne 0 ]
then
    echo "Options _________ $PARSED_PARAMS" >&2
    echo -e "\e[31mError due to incorrect options processing\e[0m" >&2
    exit 1
fi

eval set -- "$PARSED_PARAMS"
OUT_TYPE=".txt"
DB_UPDATE_FLAG=0

while true; do 
    case "$1" in
        -f)
            echo "File output is changed" >&2
            shift
            #Trying to get filetype
            case "$1" in
                csv)
                    echo "Output file extension is CSV" >&2
                    OUT_TYPE=".$1"
                    ;;
                *)
                    echo -e "\e[31mERROR: incorrect filename extension\e[0m" >&2
                    echo "$HELPTEXT"
                    exit 1
                    ;;
            esac
            shift
            ;;
        -g)
            echo "Report will be immidiately sent to DataBase" >&2
            DB_UPDATE_FLAG=1
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            echo -e "\e[31mERROR: unexpected option\e[0m" >&2
            echo "$HELPTEXT"
            exit 1
            ;;
    esac
done

# PART1 - READING DATA FROM SOURCE
CSV_FILE="$1"

if [ ! -f "$CSV_FILE" ]; then
    echo -e "\e[31mERROR: file '$CSV_FILE' not found.\e[0m" >&2
    exit 1
fi

if [ ! -r "$CSV_FILE" ]; then
    echo -e "\e[31mERROR: Permission for reading '$CSV_FILE' denied.\e[0m" >&2
    exit 1
fi


total=0
count=0
max=0
{
    read -r
    while IFS=, read -r _ _ line || [ -n "$line" ]; do
        line="${line%%$'\r'}"
        if [[ ! "$line" =~ ^([1-9][0-9]*|0)$ ]]; then
            echo "\e[31mSYNTAX ERROR: non-integer value recieved: '$line' \e[0m SKIPPED" >&2
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

avg=$( awk -v t="$total" -v c="$count" 'BEGIN { printf "%.3f", t / c }')

#PART2 - CREATING OUTPUT
REPORT_FILE="sales_report$OUT_TYPE"

case "$OUT_TYPE" in
    .txt)
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
        ;;
    .csv)
        echo "=========================================="
        echo "        SALES REPORT IN .CSV"
        echo "=========================================="
        {
            echo "total-cost,aver-cost,highest-cost"
            echo "$total,$avg,$max"
        } | tee "$REPORT_FILE"
        ;;
    *)
        echo -e "\e[31mERROR: unexpected file extension\e[0m" >&2
        echo "$HELPTEXT"
        exit 1
        ;;
esac

SQL_FILE="import_sales.sql"
TABLE_NAME="sales_data"
ABS_SERVER_PATH=""

# Генерируем SQL-файл с одной командой COPY
cat > "$SQL_FILE" <<EOF
COPY ${TABLE_NAME} (total-cost, aver-cost, highest-cost)
FROM '/ABS_SERVER_PATH/${CSV_FILE}'
WITH (FORMAT csv, HEADER true, DELIMITER ',');
EOF

# if [ DB_UPDATE_FLAG -eq 1 ]; then
#     {
#         echo "BEGIN;"
#         awk -F',' -v table="$TABLE_NAME" '
#             NR > 1 {
#                 # Удаляем возможные \r и пробелы по краям
#                 gsub(/\r/, "", $0);
#                 # expected sequence: total-cost,aver-cost,highest-cost
#                 total = $1; aver = $2; max = $3;
#                 # Making inquiry
#                 printf "INSERT INTO %s (total-cost, aver-cost, highest-cost) VALUES (%s, %s, %s);\n", table, total, aver, max;
#             }
#         ' "$CSV_FILE"
#         echo "COMMIT;"
#     } > "$SQL_FILE"