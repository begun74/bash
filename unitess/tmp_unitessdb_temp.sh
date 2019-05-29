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
####LAST_TEMP="set heading off; select TCON_TEMP from I_TEST_CONDITIONS itc inner join (select max(TCON_TIME) as tm from I_TEST_CONDITIONS where ID_SENS=$SENSOR_ID) as xxx on xxx.tm = itc.TCON_TIME;"
#LAST_TEMP="set heading off; select TCON_TEMP from I_TEST_CONDITIONS itc inner join (select max(ID_TCON) as maxid from I_TEST_CONDITIONS where ID_SENS=$SENSOR_ID) as xxx on xxx.maxid = itc.ID_TCON;"

LAST_TEMP="set heading off;\
		set list off; \
		select '"ID_SENS","TEMP","HUM"' from RDB$DATABASE \
		union all \
		 select itc.id_sens, TCON_TEMP, TCON_HUM from I_TEST_CONDITIONS itc \
			 inner join ( \
			select ID_SENS,max(ID_TCON) as maxid from I_TEST_CONDITIONS where ID_SENS > 0 and ID_SENS < 50  group by ID_SENS \
		) as xxx on xxx.maxid = itc.id_tcon order by itc.id_sens;"

LAST_TEMP="set heading off;  set echo on; select itc.ID_SENS, TCON_TEMP from  I_TEST_CONDITIONS itc inner join ( select ID_SENS,max(ID_TCON) as maxid from I_TEST_CONDITIONS where ID_SENS > 0 and ID_SENS < 30  group by ID_SENS  ) as xxx on xxx.maxid = itc.id_tcon order by itc.ID_SENS; quit;"

LAST_HUM="set heading off;   set echo on; select itc.ID_SENS, TCON_HUM from I_TEST_CONDITIONS itc inner join ( select ID_SENS,max(ID_TCON) as maxid from I_TEST_CONDITIONS where ID_SENS > 0 and ID_SENS < 50  group by ID_SENS  ) as xxx on xxx.maxid = itc.id_tcon; quit;"


 > last_temp.log

RES=`echo "$LAST_TEMP" | isql-fb -u $USERNAME -p $PASSWORD  $DATABASE`

indx=0
a=""

p1=""
p2=""
p3=""


for VARIABLE in  $RES
do
        a=$a' '$VARIABLE
        let indx++
#       echo 'str - '  $a
        if(( $indx%2 == 0 )); then
                 echo $a >> last_temp.log
                a=""
        fi

done



for VARIABLE in  $RES
do
	a=$a' '$VARIABLE
	let indx++
#	echo 'str - '  $a
	if(( $indx%2 == 0 )); then
		 echo $a >> last_temp.log
		a=""
	fi

done


 > last_hum.log

RES=`echo "$LAST_HUM" | isql-fb -u $USERNAME -p $PASSWORD  $DATABASE`

indx=0
a=""
for VARIABLE in  $RES
do
        a=$a' '$VARIABLE
        let indx++
#       echo 'str - '  $a
        if(( $indx%2 == 0 )); then
                 echo $a >> last_hum.log
                a=""
        fi

done


#> last_hum.log

#RES=`echo "$LAST_HUM" | isql-fb -u $USERNAME -p $PASSWORD  $DATABASE`

#for VARIABLE in  $RES
#do
#        echo $VARIABLE >> last_hum.log
#done

