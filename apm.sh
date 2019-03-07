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
    ifstat -d 1
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
    killall -9 ifstat
    echo ""
    exit
}

function getProcStats() {
    # Get the %CPU and %MEM from the PIDs
    count=1
    for PID in $PIDS; do
        echo "$SECONDS,`ps -p $PID -o pcpu,pmem | tail -n+2 | awk '{print $1 "," $2}'`" >> "apm${count}_metrics.csv"
        (( count++ ))
    done
}

function getSystemStats() {
    # Get the system stats here
    ifstats=`ifstat ens33 | tail -n 2 | head -n 1` 2>/dev/null
    # rx rates
    rx=`echo $ifstats | awk '{print $7}' | sed 's:K::g'`
    # tx rates
    tx=`echo $ifstats | awk '{print $9}' | sed 's:K::g'`
    # hard drive writes
    hd_writes=`iostat -d sda | grep sda | awk '{print $4}'`
    # Hard drive usage
    hd_util=`df -m / | tail -n+2 | awk '{print $4}'`

    echo "$SECONDS,$tx,$rx,$hd_writes,$hd_util" >> system_metrics.csv
}

function main() {
    # Definitions for easy reference
    sleepTime=5
    echo "[*] Starting process monitoring for 15 minutes"
    while [ $SECONDS -le 900 ]
    do
        sleep $sleepTime
        getProcStats
        getSystemStats
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