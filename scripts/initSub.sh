#!/bin/bash

nJobs=`crab -status -c crabTasks/$1 | grep "Jobs Created" | awk '{print $2}'` # > $PRODPATH/tmp/inStat

if [[ $nJobs -gt 500 ]]; then
    k=`echo $nJobs / 500 | bc`
    
    n=1
    i=0
    while [[ $i -lt $k ]]; do
	N=`echo $n + 499 | bc`
	crab -submit $n-$N -c crabTasks/$1
	n=`echo $n + 500 | bc`
	i=`echo $i + 1 | bc`
    done 
    crab -submit $n-$nJobs -c crabTasks/$1

else
    crab -submit all -c crabTasks/$1
fi