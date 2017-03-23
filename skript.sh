#!/bin/bash


source functions.sh
source constants.sh

posuno=$(loadParam $*)
echo "posouvam o: $posuno"
while [ "$posuno" -gt 0 ]
do
	let posuno=posuno-1
	shift
done
loadFile $*

# while true
# do
# 	sleep 2
# done

	
