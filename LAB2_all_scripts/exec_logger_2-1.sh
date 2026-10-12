#!/bin/bash

LOGPATH="/tmp/run.log"

echo "Logger of executions of itself
                    is ready to serve!"

log() {
    echo  "$(date "+%d-%m-%Y %H:%M:%S") [$USER@$HOSTNAME]" >> $LOGPATH
}

if [ -r "$LOGPATH" ];
then
    log
else 
    echo "Previous logs not detected, creating a new logfile: $LOGPATH"
    touch $LOGPATH
    log
fi

echo "Hello World!"

echo "Overall usage count: $(wc -l $LOGPATH | cut -d' ' -f1)" 2>&1