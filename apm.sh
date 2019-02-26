#!/bin/bash

secondCount=0

while [ $secondCount -lt 901 ]
do
	echo $secondCount
	ps | echo
	secondCount=$(($secondCount + 5))
	sleep 5
done