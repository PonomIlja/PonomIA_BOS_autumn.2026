#!/bin/bash

LOGPATH="/tmp/run.log"
SCRIPTPATH="/mnt/hgfs/Shared/OS_Safety/git_repos/LAB2_all_scripts/"
SCRIPTNAME="exec_logger_2-1.sh"

echo "Script to check logs of script '$SCRIPTNAME'
                    is ready to serve!"

if [ -x "$SCRIPTPATH$SCRIPTNAME" ];
then
    echo "DOING THE JOB"
    echo ""
    $SCRIPTPATH$SCRIPTNAME
    less $LOGPATH
else 
    echo "Targeted script not detected at path: $SCRIPTPATH$SCRIPTNAME" 
fi

