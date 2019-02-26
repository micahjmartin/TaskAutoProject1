#!/bin/bash

secondCount=0

while [ $secondCount -lt 901 ]
do
	echo $secondCount
	ps | echo
	secondCount=$(($secondCount + 5))
	delay 5
done