#!/bin/bash

Path=$PRODPATH/crabCfgs
TYPES=( "MC" "Data" )

if [ ! -e $PRODPATH/logs/crabSub.log ]; then
    echo "new file"
    echo -n "" > $PRODPATH/logs/crabSub.log
fi


for it in ${TYPES[@]} ; do
  
    for ids in `ls $Path/$it` ; do

	tmp=`echo ${ids%*.cfg}`

	if [ ! -d $PRODPATH/crabTasks/$it/$tmp ]; then #task exists
	    echo $Path/$it/$ids 
	    crab -create -cfg $Path/$it/$ids
	    echo -e "$it\t$tmp\tX" >> $PRODPATH/logs/crabSub.log
	fi
    done
done
