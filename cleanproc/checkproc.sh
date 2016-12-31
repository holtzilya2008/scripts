#! /bin/bash

while read line
do
  found=$(grep $line ./whitelist.txt)
  if  [[ "$found" == "" ]]; then
    	echo "WARNING! the process:" $line "is not recognized!"
  fi 
done

exit 0
       
