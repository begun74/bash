#!/bin/bash

#id
SENSOR_ID=$1

#server
SERVER=10.12.1.119

#username
USERNAME="SYSDBA"

#password
PASSWORD="masterkey"

#database
#DATABASE="10.12.1.119:/home/unitessdb/UNITESSDB.FDB"
DATABASE="10.12.1.119:c:\\unitessdb\\UNITESSDB.FDB"

#max_time request
BATT_LEVEL="set heading off; select ID_SENS, sens_batt_level from S_CONDITIONAL_SENSORS where ID_SENS between 1 and 50 order by ID_SENS;"

FILE=/tmp/unitess_batt_vots
 > $FILE

 ping -c 2 $SERVER > /dev/null

RES=`echo "$BATT_LEVEL" | isql-fb -u $USERNAME -p $PASSWORD  $DATABASE`

#for i in $RES; 
#	do echo $i >> $FILE; 
#done


row=0
i=0


declare -a MY_ARRAY=("0", "0")
# echo $MY_ARRAY

for VARIABLE in  $RES
do
        let row++

        MY_ARRAY[$i]=$VARIABLE


        if (($row%2 == 0 ))
        then
                echo ${MY_ARRAY[0]}' ' ${MY_ARRAY[1]} >> $FILE
                i=0
        else
                let i++
        fi

done


#scp $FILE zabbix:$FILE
