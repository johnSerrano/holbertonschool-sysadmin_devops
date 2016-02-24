#!/bin/bash
while read line
do
	if [[ $line == *'HEAD'* ]]
	then 
		echo $line
	fi
done < $1
