#!/bin/bash
head=0
get=0

while read line
do
	if [[ $line == *'HEAD'* ]]
	then 
		head=$(($head + 1))
	elif [[ $line == *'GET'* ]]
	then
		get=$(($get + 1))
	fi
done < $1

echo $head
echo $get
