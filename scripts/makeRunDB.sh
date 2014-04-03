#!/bin/bash

TAB="$(printf '\t')"

DS=$1
tag=$2

FILE=$PRODPATH/database/$tag.db

runmDBS=1000000
runMDBS=0

for i in `dbsql find run,dataset where dataset=$DS | awk '{print $1}'`; do


#header
    
    if [ "${i:0:3}" = "Usi" -o "${i:0:3}" = "---" -o "${i:0:3}" = "run" ]; then
	continue
    fi

    if [[ $i -lt $runmDBS ]]; then
	runmDBS=$i
    fi
    if [[ $i -gt $runMDBS ]]; then
	runMDBS=$i
    fi

done

#echo $DS" ---> "$runmDBS"  "$runMDBS

if [ -e $FILE ]; then #file exists, only an update is needed

#copy the file before making modifications
cp $FILE $FILE"_back"

rmproc=`cat $FILE | grep runminproc | awk '{print $2}'`
rMproc=`cat $FILE | grep runmaxproc | awk '{print $2}'`

cat> $FILE <<EOF
runmin$TAB$runmDBS
runmax$TAB$runMDBS
runminproc$TAB$rmproc
runmaxproc$TAB$rMproc

EOF


else
echo -n "" > $FILE
cat > $FILE <<EOF
runmin$TAB$runmDBS
runmax$TAB$runMDBS
runminproc$TAB-1
runmaxproc$TAB-1

EOF


fi

