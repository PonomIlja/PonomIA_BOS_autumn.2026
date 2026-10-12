#!/bin/bash

echo "Script to find get the overall mem-usage and lines count of all .txt files in ~ 
                    is ready to serve!"
echo ""

fileslist=(~/*.txt)

echo "All found files:"
echo "${fileslist[@]}"

echo "Overall memory usage: $(du -c $fileslist | grep 'total' | cut -f1) "
echo "OVerall lines count:  $(wc -l $fileslist | cut -d' ' -f1)"
