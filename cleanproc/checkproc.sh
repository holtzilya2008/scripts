#! /bin/bash

whitelist="...your whitelist full path and filename..."
logfile="...your log file full path and filename..."
echo "WARNING: The following processes are not in your whitelist:"
while read line
do
  found=$(grep $line $whitelist)
  if [[ "$found" == "" ]]; then
		echo $line
		logged=$(grep $line $logfile)
	    if [[ "$logged" == "" ]]; then
			echo $line >> $logfile
			echo "Writing to" $logfile
	    fi 
  fi 

done

exit 0
	   
