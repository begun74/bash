#!/bin/bash

#id
SENSOR_ID=$1

#file_name
FILE=$2


if [ -z $SENSOR_ID ] || [ -z $FILE ]
then
	echo "usage: ./unitess_temp.sh <SENSOR_ID> <FILE>"
	exit 
fi


while read LINE; do

	#echo 'LINE - ' $LINE
	declare -a MY_ARRAY=($LINE)
	#echo 'MY_ARRAY - ' ${MY_ARRAY[0]}' '

	if(( $1 == ${MY_ARRAY[0]} ));then
		echo ${MY_ARRAY[1]}
	fi

done < $FILE
