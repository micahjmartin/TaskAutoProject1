#!/bin/bash

function launch_programs() {
    # Launch all of the needed programs for APM to monitor
    programs="APM1 APM2 APM3 APM4 APM5 APM6"
    ip=`ifconfig | grep "eth3" -A 1 | tail -n 1 | awk '{print $2}'`
    echo "[*] Spawning processes...."
    for prog in $programs; do
        ./$prog $ip &>/dev/null & 
        pid=$!
        echo "[+] Launched command: '$prog $ip' as PID $pid"
        PIDS="$PIDS $pid"
    done
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
	while [ $secondCount -lt 901 ]
	do
		echo $secondCount
		ps aux > temp.txt
		
		result="$secondCount"
		
		for PID in $PIDS
		do
			result="$result,`grep "$PID" temp.txt |  awk '{print $3 "," $4}'`"
			
		done
		
		echo $result
		
		secondCount=$(($secondCount + 5))
		rm temp.txt
		
		#END OF PAUL'S PART
		
		
		
		
		
		
		
		#END OF JON'S PART
		sleep 5
	done
}


trap cleanup INT
launch_programs
main
cleanup