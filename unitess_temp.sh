#!/bin/bash

#id
SENSOR_ID=$1

#file_name
FILE=$2


while read LINE; do
#№     echo "Это строка: $LINE"
#	sed -n $1 $LINE

	echo 'LINE - ' $LINE
	declare -a MY_ARRAY=($LINE)
	#echo 'MY_ARRAY - ' ${MY_ARRAY[0]}' '

	if(( $1 == ${MY_ARRAY[0]} ));then
		echo ${MY_ARRAY[1]}
	fi

done < $FILE
