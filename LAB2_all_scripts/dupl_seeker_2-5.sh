#!/bin/bash

echo "Script to find all duplicates in a given directory
                    is ready to serve!"
echo ""

if [ -z "$*" ]
then
    echo "there is nothing to compare"
    exit 0
fi 

# echo "All params - $@"

parameters=($@)

for ((i=0; i<$#-1; i++)) 
do
    [ -r ${parameters[i]} ] && unset 'parameters[i]' && parameters=(${parameters[@]}) && ((i--))
    # echo "Current base = ${parameters[i]}"
    current_dupl_list=(${parameters[i]})
    for ((j=i+1; j<${#parameters[@]}; j++))
    do
        [ -r ${parameters[j]} ] && unset 'parameters[j]' && parameters=(${parameters[@]}) && ((j--))
        # echo "Current elem to compare = ${parameters[j]}"
        cmp -s ${parameters[i]} ${parameters[j]} && current_dupl_list+=(${parameters[j]}) && unset 'parameters[j]' && parameters=(${parameters[@]}) && ((j--)) #&& echo "deleted"
        # echo "Now looking at ${parameters[j]}"
    done
    if [ ${#current_dupl_list[@]} -gt 1 ]
    then
        echo "${#current_dupl_list[@]} ${current_dupl_list[@]}"
    fi
done

echo ""
echo "My job is done!"
echo ""