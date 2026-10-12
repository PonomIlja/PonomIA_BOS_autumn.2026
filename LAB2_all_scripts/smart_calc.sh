#!/bin/bash

HELPTEXT="Correct usage of this script:
    smart_calc.sh [OPTIONS] PARAMS

    OPTIONS:
        -h      show manual about the programm
        -v      enable detailed output 
        -o      set file for output (filename must be given when this option used)
                if file do not exist and cannot be created for some reason,
                script will be finished with error code 2;
                filename must be written BEFORE any numbers and operation literals, or
                it will be interpreted as a missing argument
    PARAMS:
        include numbers and literals of operations
        provided operations: 
            '-'     difference
            '+'     addition
            '*'     multiplication
            '/'     division
            '^'     set in power
            '(',')' make a group and prioritize these operations"

MANUAL="This is a calculator, returns floating point number of scale = 6.

$HELPTEXT"

PARSED_PARAMS=$(getopt -o hvo: -- "$@")
filename=""

if [ $? -ne 0 ]
then
    echo "Error due to incorrect options processing"
    exit 1
fi

eval set -- "$PARSED_PARAMS"

while true; do 
    case "$1" in
        -h)
            echo "$MANUAL"
            exit 0
            ;;
        -v)
            echo "Detailed output enabled"
            shift
            ;;
        -o)
            echo "File output is used, filename will be checked"
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "ERROR: unexpected option" >2
            echo "$HELPTEXT"
            exit 1
            ;;
    esac
done

#Trying to get filename
if [[ -f "$1" ]]; then
    echo "file with name '$1' exists"
    if [[ -w "$1" ]]; then
        echo "file can be edited"
        filename="$1"
        shift
    else
        echo "ERROR: file exists but permission denied" >2
        exit 13
    fi
else
    echo "no such file, creating new with filename $1"
    eval touch "$1" 
    if [[ $? -ne 0 ]]; then
        echo "ERROR: file cannot be created" >2
        exit $?
    fi
    filename="$1"
    shift
fi

#Processing string of maths
result=$(echo "scale=6; ${@:1}" | bc)
if [[ -n "$err" ]]; then
    echo "Incorrect input: $err" >&2
    exit 1
fi

echo "Result - $result"
exit 0