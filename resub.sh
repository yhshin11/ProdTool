#!/bin/bash

for glou in `ls crabTasks/Data/`
do
  Type="Data" #`echo $glou | awk '{print $1}'`
  ds=$glou #`echo $glou | awk '{print $2}'`
  DS=${ds#*/}
  echo $Type/$DS

  crab -status -c crabTasks/$Type/$DS > $PRODPATH/tmp/log
  source $PRODPATH/scripts/JobType.sh
  source $PRODPATH/tmp/FailFile
  source $PRODPATH/tmp/ResubFile
    

done

for glou in `ls crabTasks/MC/`
do
  Type="MC" #`echo $glou | awk '{print $1}'`
  ds=$glou #`echo $glou | awk '{print $2}'`
  DS=${ds#*/}
  echo $Type/$DS

  crab -status -c crabTasks/$Type/$DS > $PRODPATH/tmp/log
  source $PRODPATH/scripts/JobType.sh
  source $PRODPATH/tmp/FailFile
  source $PRODPATH/tmp/ResubFile
    

done
# < $PRODPATH/logs/crabSub.log

