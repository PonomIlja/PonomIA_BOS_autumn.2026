#!/bin/bash

echo "Script to find 'bin' in standart input
                    is ready to serve!"
echo ""

while IFS= read -r line
do
    if [[ "$line" == *bin* ]]
    then
        echo "$line"
    fi
done 1>&2

echo "--done--"