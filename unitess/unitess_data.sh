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

#sql request
LAST_DATA="set heading off;  set echo on; select distinct itc.ID_SENS, TCON_TEMP, TCON_HUM from  I_TEST_CONDITIONS itc inner join ( select ID_SENS,max(ID_TCON) as maxid from I_TEST_CONDITIONS where ID_SENS > 0 and ID_SENS < 50  and TCON_TIME BETWEEN CAST('now' AS TIMESTAMP)-30 and CAST('now' AS TIMESTAMP)  group by ID_SENS  ) as xxx on xxx.maxid = itc.id_tcon order by itc.ID_SENS;  quit;"
#LAST_DATA="set heading off;  set echo on; select distinct itc.ID_SENS, TCON_TEMP, TCON_HUM from  I_TEST_CONDITIONS itc inner join ( select ID_SENS,max(ID_TCON) as maxid from I_TEST_CONDITIONS where ID_SENS > 0 and ID_SENS < 50  group by ID_SENS  ) as xxx on xxx.maxid = itc.id_tcon order by itc.ID_SENS; quit;"
##LAST_DATA="set heading off;  set echo on; select distinct itc.ID_SENS, TCON_TEMP, TCON_HUM from  I_TEST_CONDITIONS itc inner join ( select distinct ID_SENS,max(TCON_TIME) as maxtime from I_TEST_CONDITIONS where ID_SENS > 0 and ID_SENS < 50  group by ID_SENS  ) as xxx on xxx.maxtime = itc.TCON_TIME order by itc.ID_SENS;"
#path to log files
LOG_TEMP=/tmp/last_temp.log
LOG_HUM=/tmp/last_hum.log

LOG_TEMP_1=/tmp/last_temp_1.log
LOG_HUM_1=/tmp/last_hum_1.log

RES=`echo "$LAST_DATA" | isql-fb -u $USERNAME -p $PASSWORD  $DATABASE`

row=0
i=0


 > $LOG_TEMP
 > $LOG_HUM

declare -a MY_ARRAY=("0", "0", "0") 
# echo $MY_ARRAY

for VARIABLE in  $RES
do
	let row++

	MY_ARRAY[$i]=$VARIABLE


        if (($row%3 == 0 ))
	then
#		echo ${MY_ARRAY[0]} ' '  ${MY_ARRAY[1]} ' '  ${MY_ARRAY[2]}
		echo ${MY_ARRAY[0]}' ' ${MY_ARRAY[1]} >> $LOG_TEMP
                echo ${MY_ARRAY[0]}' ' ${MY_ARRAY[2]} >> $LOG_HUM
		i=0
	else
		let i++
	fi

done

scp $LOG_TEMP zabbix:$LOG_TEMP
scp $LOG_HUM  zabbix:$LOG_HUM
