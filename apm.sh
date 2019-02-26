#!/bin/bash

secondCount=0

PIDS="watchdog kthreadd"

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
