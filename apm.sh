#!/bin/bash

# Task Auto mini project 1
# Launches all of the given programs and monitors them
# Authors: Micah Martin (mjm5097), Paul Hulbert (), Jonathan Jang (jwj3737)

# Launch all of the needed programs for APM to monitor
function launch_programs() {
    programs="APM1 APM2 APM3 APM4 APM5 APM6"
    # Identify the IP address of the 
    echo "[*] Spawning processes...."
    echo -n "[+] Launched PID's"
    for prog in $programs; do
        ./$prog $1 &>/dev/null & 
        pid=$!
        echo -n " $pid"
        PIDS="$PIDS $pid"
    done
    echo ""
}

# Kill all the spawned processes and then exit
function cleanup() {
    echo " [*] Cleaning up spawned processes and exiting...."
    echo -n "[+] Killed process"
    for pid in $PIDS; do
        kill -9 $pid
        echo -n " $pid"
    done
    echo ""
    exit
}

function main() {
    # Definitions for easy reference
    sleepTime=5
    outputProcessFile="process_output.txt"
    echo "[*] Starting process monitoring for 15 minutes"
    while [ $SECONDS -le 900 ]
    do
        # Get all the PS information
        #pids=`echo $PIDS | tr ' ' ','`
        #ps aux > temp.txt
        result="$SECONDS"
        # Get the %CPU and %MEM from the PIDs
        for PID in $PIDS; do
            result="$result,`ps -p $PID -o pcpu,pmem | tail -n+2 | awk '{print $1 "," $2}'`"
        done
        echo $result >> $outputProcessFile

        # TODO: Get the system stats here

        sleep $sleepTime
    done
}

# Make sure our args are passed in
[ "$1" = "" ] && echo "USAGE $0 <ip address>" && exit

# Register the trap
trap cleanup INT

# Launch all the programs initially
launch_programs $1

# Call the main
main

# Call the cleanup if the main every completes
cleanup