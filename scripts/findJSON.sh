#!/bin/bash

JSONLOC=$1

SubRep=( "Prompt" "Reprocessing" )

jsonListP=$PRODPATH/database/jsonListP
jsonListR=$PRODPATH/database/jsonListR

#initialisation reprocessing file
echo -n "" > $jsonListR


for irep in ${SubRep[@]}; do

    if [ ! -d $JSONLOC/$irep ]; then 
	continue
    fi
    
    if [ $irep == "Reprocessing" ]; then
#	jsonFiles=`ls -t $JSONLOC/$irep/*JSON.txt`

	for ifile in `ls -tr $JSONLOC/$irep/*JSON.txt`; do
	#    echo $ifile
	    tmp=`echo ${ifile#*Cert_}| tr "_" " "`
	    runm=${tmp:0:6}
	    runM=${tmp:7:6}

	    #check the global validity of the JSON file
	    #hopping the name format will not change...
	    tagRR=0
	    isValid=0
	    for i in `echo ${ifile#*Cert_}| tr "_" " "`; do 
	
		tmp=`echo $i | grep ReReco`
		if [ -n "$tmp" -a $tagRR -eq 0 ]; then
		    tagRR=1
		    continue
		fi
		tmp=`echo $i | grep Collision`
		if [ -n "$tmp" -a $tagRR -eq 1 ]; then
		    isValid=1
		    break
		fi
		if [ $tagRR -eq 1 ]; then
		    tagRR=0
		fi
		
	    done

	    if [ $isValid -eq 1 ];then
		echo -e $runm"\t"$runM"\t"$ifile >> $jsonListR 
	    fi
	done
    fi

    if [ $irep == "Prompt" ]; then
	lastJson=`ls -tr $JSONLOC/$irep/*JSON.txt | tail -1`

	tmp=`echo ${lastJson#*Cert_}| tr "_" " "`
	runm=${tmp:0:6}
	runM=${tmp:7:6}
	echo -e $runm"\t"$runM"\t"$lastJson > $jsonListP 
    fi

done
