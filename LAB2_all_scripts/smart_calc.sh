#!/bin/bash

HELPTEXT="Correct usage of this script:
    smart_calc.sh [OPTIONS] PARAMS

    OPTIONS:
        -h      show manual about the programm (no operations will be done)
        -v      enable detailed output 
        -o      set file for output (filename must be given when this option used)
                if file do not exist and cannot be created for some reason,
                script will be finished with error code 2;
                filename must be written BEFORE any numbers and operation literals, or
                it will be interpreted as a missing argument
    PARAMS:
        include numbers and literals of operations, separated with whitespace
        provided operations: 
            '-'     difference
            '+'     addition
            '*'     multiplication
            '/'     division
            '^'     set in power
            '(',')' make a group and prioritize these operations"

MANUAL="This is a calculator, returns floating point number of scale = 6.

$HELPTEXT"

filename=1
V_FLAG=0
result=0

PARSED_PARAMS=$(getopt -o hvo: -- "$@")

if [ $? -ne 0 ]
then
    echo "Error due to incorrect options processing" >&2
    echo "Options: _________ $PARSED_PARAMS" >&2
    exit 1
fi

eval set -- "$PARSED_PARAMS"
# echo "NOW _________ $PARSED_PARAMS" >&2

while true; do 
    case "$1" in
        -h)
            echo "$MANUAL" >&2
            exit 0
            ;;
        -v)
            echo "Detailed output enabled" >&2
            V_FLAG=1
            shift
            ;;
        -o)
            echo "File output is used, filename will be checked" >&2
            shift
            #Trying to get filename
            if [[ -f "$1" ]]; then
                if [ $V_FLAG -eq 0 ]; then
                    echo "file with name '$1' exists" >&2
                fi

                if [[ -w "$1" ]]; then
                    if [ $V_FLAG -eq 0 ]; then
                        echo "file can be edited" >&2
                    fi

                    filename="$1"
                    shift
                    
                else
                    echo "ERROR: file exists but permission denied" >&2
                    exit 13
                fi
            else
                if [ $V_FLAG -eq 0 ]; then
                    echo "no such file, creating new with filename $1" >&2
                fi

                eval touch "$1" 
                if [[ $? -ne 0 ]]; then
                    echo "ERROR: file cannot be created" >&2
                    exit 1
                fi

                if [ $V_FLAG -eq 0 ]; then
                    echo "File for output created successfully" >&2
                fi

                filename="$1"
                shift
            fi
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "ERROR: unexpected option" >&2
            echo "$HELPTEXT"
            exit 1
            ;;
    esac
done

#Processing string of maths
if [ $V_FLAG -eq 0 ]; then
    echo "Expression to process: ${@:1}" >&2
fi

# Creating tmp file for stderr
err_file=$(mktemp)

# execute bc, saving stderr into created file
result=$(echo "scale=6; $*" | bc 2>"$err_file")

# Check if there are any errors
if [ -s "$err_file" ]; then
    echo "ERROR by 'bc':" >&2
    cat "$err_file" >&2
    exit 1
else
    if [ $V_FLAG -eq 0 ]; then
        echo "Successfully processed, result = $result" >&2
    fi
fi

# Deleting the tmp file
rm -f "$err_file"

if [[ "$filename" -eq 1 ]]; then
    echo "$return" 
else
    echo "$result" >> "$filename"
fi
exit 0