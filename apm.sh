#!/bin/bash

secondCount=0

while [ $secondCount -lt 901 ]
do
	echo $secondCount
	ps | tail -n +2 > temp.txt
	cat temp.txt
	secondCount=$(($secondCount + 5))
	rm temp.txt
	sleep 5
done