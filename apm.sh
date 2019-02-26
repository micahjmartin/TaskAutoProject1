#!/bin/bash

# Task Auto mini project 1
# Launches all of the given programs and monitors them
# Authors: Micah Martin (mjm5097), Paul Hulbert (), Jonathan Jang (jwj3737)

function launch_programs() {
    # Launch all of the needed programs for APM to monitor
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
    sleepTime=5
    echo "[*] Starting process monitoring at $SECONDS seconds"
    while [ $SECONDS -lt 901 ]
    do
        # Get all the PS information
        ps aux > temp.txt
        result="$SECONDS"
        # Get the %CPU and %MEM from the PIDS
        for PID in $PIDS; do
            result="$result,`grep "$PID" temp.txt |  awk '{print $3 "," $4}'`"
        done
        
        echo $result
        rm temp.txt
        
        #END OF PAUL'S PART
        
        
        
        
        
        
        
        #END OF JON'S PART
        echo "[*] Sleeping for $sleepTime seconds..."
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