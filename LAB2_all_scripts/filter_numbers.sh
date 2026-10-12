#!/bin/bash

echo "Given parameters: $* 
"

iter_num=0

for num in $@
do
    if [[ $num =~ [0-9]+ ]] && [ $((num%3)) -ne 0 ]
    then
        ((iter_num++))
        if [ $((num%2)) -eq 0 ]
        then 
            echo "num
            " >> even.txt
        else 
            echo "num
            " >> odd.txt
        fi
    fi
done

echo "Processed parameters count: $iter_num"
