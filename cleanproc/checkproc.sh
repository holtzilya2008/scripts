#! /bin/bash

whitelist_path="... add our path wor the whitelist ..."
echo "WARNING: The following processes are not in your whitelist:"
while read line
do
  found=$(grep $line $whitelist_path/whitelist.txt)
  if  [[ "$found" == "" ]]; then
    	echo $line
  fi 
done

exit 0
       
