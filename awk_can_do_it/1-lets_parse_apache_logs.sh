#!/bin/bash

while read line
do 
#	echo $line
	echo $line | awk '{ print $1, $9 }'
done < $1
