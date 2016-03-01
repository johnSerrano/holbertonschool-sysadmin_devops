#!/bin/bash

sort < <(while read line
do 
	echo $line | awk '{ print $1, $9 }'
done < $1) | uniq -c | sort -n
