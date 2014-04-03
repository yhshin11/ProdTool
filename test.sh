#!/bin/bash

type=MC

for glou in `ls crabTasks/$type/`
do
  Type="$type" #`echo $glou | awk '{print $1}'`
  ds=$glou #`echo $glou | awk '{print $2}'`
  DS=${ds#*/}
  echo $Type/$DS

  crab -status -c crabTasks/$Type/$DS > $PRODPATH/tmp/log
  source $PRODPATH/scripts/JobType.sh
  source $PRODPATH/tmp/FailFile
  source $PRODPATH/tmp/ResubFile
	

done
# < $PRODPATH/logs/crabSub.log
