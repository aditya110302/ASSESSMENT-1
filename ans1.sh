#!/bin/bash
IFS=','
while read -r t id task
do 
	if [ "$t" = "time" ]; then
        	continue
    	fi

	username=$(echo "$id" | cut -d '@' -f1)

	echo SUBJECT: 
	subject="
	$task
       	at 
	$t"
	echo "$subject" #now we have subject of our mail
	
	mkdir -p "$username"
	
	TIME=$t
	TIME_IN_SECONDS=$(date -d "$TIME" +%s)
	TIME_MINUS_30_IN_SECONDS=$((TIME_IN_SECONDS - 1800))
	TIME_MINUS_30=$(date -d @$TIME_MINUS_30_IN_SECONDS +'%H:%M')
	echo $TIME_MINUS_30

	count=$(ls "$username" | wc -l)
	new_count=$((count+1))
	
	filename="Notification${new_count}.txt"
	touch filename.txt
	echo "$subject">"$filename"
	
	at "$TIME_MINUS_30"<<EOF
	mv "$filename" "$username"		
EOF
	echo "FILES CREATED" 

	echo -----------------------------------------------------------

done<property.csv
