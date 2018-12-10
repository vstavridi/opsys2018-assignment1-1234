#!/bin/bash
file1=$1
if [ -e history.txt  ];
then

i=0
old_data=()
	while IFS= read line
do

         [[ $line != " "  ]]  &&   [[ $line  = \#*  ]]  && continue
		 old_data+=("$line")   
((i++))

done< history.txt      
i=0
flag=0
while IFS= read line1
do 
         [[ $line1 != " "  ]]  &&   [[ $line1  = \#*  ]]  && continue
        name="$line1"
	 data=$((curl -sL "$name"||echo $name failed ;  continue) | md5sum | cut -d ' ' -f 1  ) 

	if [ ${old_data[$i]} =  $data ]
	then
		echo $name  ok 
	else
		echo $name updated 
		old_data[$i]="$data"
		((flag++))
	fi 
	 
	((i++))
	

done<"$file1"

 if [ $flag -gt 0 ] ; 
  then

  echo -n "" > history.txt
  for j in "${old_data[@]}"
    do
	echo $j  >> history.txt
  done
 fi

else
 touch   history.txt

   while IFS= read line1
    do
        [[ $line1 != " "  ]]  &&   [[ $line1  = \#*  ]]  && continue
        name="$line1"


	data=$( (curl -sL "$name"||echo $name failed ;  continue) | md5sum | cut -d ' ' -f 1 )

        echo  "$name  INIT " 
  echo  "$data " >> history.txt 
  
    done<"$file1"
fi
 


