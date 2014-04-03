#!/bin/bash

n=0

while [ ! $n -eq 300 ] ; do


    eos rm -r /eos/cms/store/user/mmarionn/AnaNaSNtuples/METv5
    sleep 20m

    n=`echo $n + 1 | bc` 
done
