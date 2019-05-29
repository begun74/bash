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



#LAST_TEMP="set heading off;  set echo on; select itc.ID_SENS, TCON_TEMP from  I_TEST_CONDITIONS itc inner join ( select ID_SENS,max(ID_TCON) as maxid from I_TEST_CONDITIONS where ID_SENS > 0 and ID_SENS < 30  group by ID_SENS  ) as xxx on xxx.maxid = itc.id_tcon order by itc.ID_SENS; quit;"

#LAST_HUM="set heading off;   set echo on; select itc.ID_SENS, TCON_HUM from I_TEST_CONDITIONS itc inner join ( select ID_SENS,max(ID_TCON) as maxid from I_TEST_CONDITIONS where ID_SENS > 0 and ID_SENS < 50  group by ID_SENS  ) as xxx on xxx.maxid = itc.id_tcon; quit;"

LAST_DATA="set heading off;  set echo on; select itc.ID_SENS, TCON_TEMP, TCON_HUM from  I_TEST_CONDITIONS itc inner join ( select ID_SENS,max(ID_TCON) as maxid from I_TEST_CONDITIONS where ID_SENS > 0 and ID_SENS < 30  group by ID_SENS  ) as xxx on xxx.maxid = itc.id_tcon order by itc.ID_SENS; quit;"

 > last_temp.log

RES=`echo "$LAST_DATA" | isql-fb -u $USERNAME -p $PASSWORD  $DATABASE`

indx=0
i=0
a=""

declare -a MY_ARRAY=("0", "0", "0") 
# echo $MY_ARRAY

for VARIABLE in  $RES
do
	let indx++

	MY_ARRAY[$i]=$VARIABLE


        if(( $indx%3 == 0 ))
	then
		echo ${MY_ARRAY[0]} ' '  ${MY_ARRAY[1]} ' '  ${MY_ARRAY[2]}
		echo ${MY_ARRAY[0]}' ' ${MY_ARRAY[1]} >> last_temp.log
                echo ${MY_ARRAY[0]}' ' ${MY_ARRAY[2]} >> last_hum.log
		i=0
	else
		let i++
	fi

#	if(( $i%2 == 0 )) && (( $i !=1 ));then
#		echo 'temp - ' $VARIABLE
#	elif (( $i%3 == 0 )) && (( $i !=1 ));then
#		echo 'hum - ' $VARIABLE
#	else
#		echo 'i - ' $i
#	fi
#
#	echo $i

#        a=$a' '$VARIABLE
#        let indx++
##       echo 'str - '  $a
#        if(( $indx%2 == 0 )); then
#                 echo $a >> last_temp.log
#                a=""
#
#        fi

done



#for VARIABLE in  $RES
#do
#	a=$a' '$VARIABLE
#	let indx++
###	echo 'str - '  $a
#	if(( $indx%2 == 0 )); then
#		 echo $a >> last_temp.log
#		a=""
#	fi
#
#done


# > last_hum.log

#RES=`echo "$LAST_HUM" | isql-fb -u $USERNAME -p $PASSWORD  $DATABASE`

#indx=0
#a=""
#for VARIABLE in  $RES
#do
#        a=$a' '$VARIABLE
#        let indx++
###       echo 'str - '  $a
#        if(( $indx%2 == 0 )); then
#                 echo $a >> last_hum.log
#                a=""
#        fi

#done


#> last_hum.log

#RES=`echo "$LAST_HUM" | isql-fb -u $USERNAME -p $PASSWORD  $DATABASE`

#for VARIABLE in  $RES
#do
#        echo $VARIABLE >> last_hum.log
#done

