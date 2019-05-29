#!/bin/bash

#id
SENSOR_ID=$1

#interval oprosa datchika
INTERVAL=$2

#server
SERVER=10.12.1.119

#username
USERNAME="SYSDBA"

#password
PASSWORD="masterkey"

#database
#DATABASE="10.12.1.119:/home/unitessdb/UNITESSDB.FDB"
DATABASE="10.12.1.119:c:\\unitessdb\\UNITESSDB.FDB"

#sql request
LAST_DATA="set heading off;  set echo on; select itc.ID_SENS, TCON_TEMP, TCON_HUM from  I_TEST_CONDITIONS itc inner join ( select ID_SENS,max(ID_TCON) as maxid from I_TEST_CONDITIONS where ID_SENS > 0 and ID_SENS < 30  group by ID_SENS  ) as xxx on xxx.maxid = itc.id_tcon order by itc.ID_SENS; quit;"

 > last_temp.log
 > last_hum.log

RES=`echo "$LAST_DATA" | isql-fb -u $USERNAME -p $PASSWORD  $DATABASE`

row=0
i=0

declare -a MY_ARRAY=("0", "0", "0") 
# echo $MY_ARRAY

for VARIABLE in  $RES
do
	let row++

	MY_ARRAY[$i]=$VARIABLE


        if(( $row%3 == 0 ))
	then
#		echo ${MY_ARRAY[0]} ' '  ${MY_ARRAY[1]} ' '  ${MY_ARRAY[2]}
		echo ${MY_ARRAY[0]}' ' ${MY_ARRAY[1]} >> last_temp.log
                echo ${MY_ARRAY[0]}' ' ${MY_ARRAY[2]} >> last_hum.log
		i=0
	else
		let i++
	fi

done
