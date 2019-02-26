#!/bin/bash

# Task Auto mini project 1
# Launches all of the given programs and monitors them
# Authors: Micah Martin (mjm5097), Paul Hulbert (), Jonathan Jang (jwj3737)

function launch_programs() {
    # Launch all of the needed programs for APM to monitor
    programs="APM1 APM2 APM3 APM4 APM5 APM6"
	# Identify the IP address of the 
    ip=`ifconfig | grep "eth3" -A 1 | tail -n 1 | awk '{print $2}'`
    echo "[*] Spawning processes...."
	echo -n "[+] Launched PID's"
    for prog in $programs; do
        ./$prog $ip &>/dev/null & 
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
	secondCount=0
	sleepTime=5
	while [ $secondCount -lt 901 ]
	do
		# Get all the PS information
		ps aux > temp.txt
		result="$secondCount"
		# Get the %CPU and %MEM from the PIDS
		for PID in $PIDS; do
			result="$result,`grep "$PID" temp.txt |  awk '{print $3 "," $4}'`"
		done
		
		echo $result
		rm temp.txt
		
		#END OF PAUL'S PART
		
		
		
		
		
		
		
		#END OF JON'S PART
		secondCount=$(($secondCount + $sleepTime))
		echo "[*] Sleeping for $sleepTime seconds..."
		sleep $sleepTime
	done
}


trap cleanup INT
launch_programs
main
cleanup