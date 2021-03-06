#!/bin/bash

pFile=$PRODPATH/config/prod.cfg
#. /afs/cern.ch/project/eos/installation/client/etc/setup.sh
alias eos="/afs/cern.ch/project/eos/installation/0.2.5/bin/eos.select"

while read line
do

    if [ "${line:0:8}" = "MainPath" ]; then
	tmp=`echo $line | awk '{print $2}'`
	MainPath="${tmp#*=}"
    fi
    if [ "${line:0:8}" = "StoreRep" ]; then
	StoreRep=`echo $line | awk '{print $2}'`
    fi
done < $pFile

echo $MainPath/$StoreRep

test=`/afs/cern.ch/project/eos/installation/0.2.5/bin/eos.select ls $MainPath/$StoreRep`  #2>&1 | grep -v "no such file"
#tmp=${#test}
#echo $test
if [[ -z $test ]];then # $tmp -eq 0
    #rfmkdir $MainPath/$StoreRep
    xrd eoscms mkdir $MainPath/$StoreRep
    echo "creating main directory"
#rfchmod 775 $MainPath/$StoreRep
fi

test=`rfdir $MainPath/$StoreRep 2>&1 | grep -v "no such file"`
tmp=${#test}

#if [ -z "$test" ];then #cond -z does not work...
#    rfmkdir $MainPath/$StoreRep
#    rfchmod 775 $MainPath/$StoreRep
#fi

for i in `ls -f crabCfgs/{Data,MC}/*.cfg`; do

    tmpDS=`echo $i | tr "/" " " | awk '{print $3}'`
    tagDS=${tmpDS%.cfg}

#while read line
#do
#    if [ "${line:0:4}" = "Data" -o "${line:0:2}" = "MC" ] && [ "${line:4:1}" != "F" -a "${line:2:1}" != "F"  ]; then


	#tagDS=`echo $line | awk '{print $3}'`
	test=`/afs/cern.ch/project/eos/installation/0.2.5/bin/eos.select ls $MainPath/$StoreRep/$tagDS` # 2>&1 | grep -v "no such file"`
#	tmp=${#test}
	#tra=`echo $test | awk '{print $1}'`
	if [[ -z $test ]];then #if repository does not exist #cond -z does not work...
	    #rfmkdir $MainPath/$StoreRep/$tagDS
	    xrd eoscms mkdir $MainPath/$StoreRep/$tagDS
#	    rfchmod 775 $MainPath/$StoreRep/$tagDS
	fi
    
done < $pFile
