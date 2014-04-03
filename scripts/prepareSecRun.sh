#!/bin/bash

logfile=log2R
DS=$1

crab -status -c crabTasks/$DS > $PRODPATH/tmp/$logfile

echo "" > tmp/tmpResub

##check the version
V=1
MultV=`ls -dtr $PRODPATH/crabTasks/$DS"_"* | tail -1`
echo ${MultV:1:3}
if [ -n "${MultV:1:3}" ]; then
    V=`echo ${MultV#*_V}`
    V=`echo $V + 1 | bc`
fi

#type=`echo ${DS%*/}`
tagDS=`echo ${DS#*/}`
name=$tagDS"_V"$V 

echo $tagDS"   "$name
#prepare the config file
cp $PRODPATH/crabCfgs/$DS.cfg $PRODPATH/crabCfgs/Resubmissions/$name.cfg	
sed -i 's/'$tagDS'/'$name'/g' $PRODPATH/crabCfgs/Resubmissions/$name.cfg


if [ -d $PRODPATH/scripts/taskResub ];then
echo "#!/bin/bash" > $PRODPATH/scripts/taskResub
fi

echo "crab -create -cfg $PRODPATH/crabCfgs/Resubmissions/$name.cfg" >> $PRODPATH/scripts/taskResub

lstring=`echo ${#PRODPATH} + 21 | bc`
while read line
do 
  
 # if [ "${line:0:7}" = "working"  ]; then
      
      if [ "${line:0:7}" == "working" ] && [ -n "$line" ]; then
	  echo >> tmp/tmpResub
	  
#	  dataset=${line:$lstring}
	  Ndjobs=0
	  
	  echo -n " crab -c crabTasks/Resubmission/$DS -submit " >> tmp/tmpResub
      fi
#fi  
	  jobN=`echo "$line" | awk '{print $1}'`
	  jobEnd=`echo "$line" | awk '{print $2}'`
	  jobStat=`echo "$line" | awk '{print $3}'`
	  jobCode=`echo "$line" | awk '{print $6}'`

	  
	  if [ "$jobEnd" == "proxy" ]; then
	      continue
	  fi
	  
#	  echo $dataset [ "${dataset:0:5}" != "multi" ] &&
	  if [ "${jobStat:0:4}" != "Done" -a "$jobStat" != "Cleared" ] && [ "$jobEnd" = "N" -o "$jobEnd" = "Y" ]; then
	      echo -n "$jobN," >> tmp/tmpResub
	  fi
	  
    
done < $PRODPATH/tmp/$logfile

echo >> tmp/tmpResub

sed -i 's/   ,/,/g' tmp/tmpResub
sed -i 's/  ,/,/g' tmp/tmpResub
sed -i 's/ ,/,/g' tmp/tmpResub


while read line
do 
  job=`echo $line | awk '{print $5}'`
  if [ -n "$job" ]; then
      echo $line >>  $PRODPATH/scripts/taskResub
  fi
done <  tmp/tmpResub


rm  tmp/tmpResub
chmod +rwx $PRODPATH/scripts/taskResub