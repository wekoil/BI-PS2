#!/bin/bash

shuffle() {
   local i tmp size max rand

   # $RANDOM % (i+1) is biased because of the limited range of $RANDOM
   # Compensate by using a range which is a multiple of the array size.
   size=${#array[*]}
   max=$(( 32768 / size * size ))

   for ((i=size-1; i>0; i--)); do
      while (( (rand=$RANDOM) >= max )); do :; done
      rand=$(( rand % (i+1) ))
      tmp=${array[i]} array[i]=${array[rand]} array[rand]=$tmp
   done
}



DATA=$( cat -n "$1" )
LINES=$(wc -l <<< "$DATA")
numberOfRecords=$( echo "$LINES/10" | bc)
array[0]=$( head -"$numberOfRecords" <<< "$DATA")
array[1]=$( head -$( echo "$numberOfRecords*2" | bc ) <<<"$DATA" | tail -"$numberOfRecords")
array[2]=$( head -$( echo "$numberOfRecords*3" | bc ) <<<"$DATA" | tail -"$numberOfRecords")
array[3]=$( head -$( echo "$numberOfRecords*4" | bc ) <<<"$DATA" | tail -"$numberOfRecords")
array[4]=$( head -$( echo "$numberOfRecords*5" | bc ) <<<"$DATA" | tail -"$numberOfRecords")
array[5]=$( head -$( echo "$numberOfRecords*6" | bc ) <<<"$DATA" | tail -"$numberOfRecords")
array[6]=$( head -$( echo "$numberOfRecords*7" | bc ) <<<"$DATA" | tail -"$numberOfRecords")
array[7]=$( head -$( echo "$numberOfRecords*8" | bc ) <<<"$DATA" | tail -"$numberOfRecords")
array[8]=$( head -$( echo "$numberOfRecords*9" | bc ) <<<"$DATA" | tail -"$numberOfRecords")
array[9]=$( tail -$( echo "$LINES-($numberOfRecords*9)" | bc ) <<< "$DATA") 
# shuffle


shuffle

# data=$(echo "${array[0]}")
# data+=$(echo)
# data+=$(echo "${array[1]}")
# data+=$(echo)
# data+=$(echo "${array[2]}")
# data+=$(echo)
# data+=$(echo "${array[3]}")
# data+=$(echo)
# data+=$(echo "${array[4]}")
# data+=$(echo)
# data+=$(echo "${array[5]}")
# data+=$(echo)
# data+=$(echo "${array[6]}")
# data+=$(echo)
# data+=$(echo "${array[7]}")
# data+=$(echo)
# data+=$(echo "${array[8]}")
# data+=$(echo)
# data+=$(echo "${array[9]}")

# echo "$data"

data=$(printf "%s\n" "${array[@]}")

echo "$data"