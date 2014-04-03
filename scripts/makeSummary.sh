#!/bin/bash

DS=$1
Ntot=$2
Ndone=$3
Nfail=$4
Nabort=$5
Nstuck=$6
Ncreated=$7

if [ -e $PRODPATH/logs/summary ];then
tail -n +2 $PRODPATH/logs/summary > $PRODPATH/tmp/tmp
else
echo -e "DS\tNtot\tNdone\tNfail\tNabort\tNstuck\tNcreated" > $PRODPATH/logs/summary
fi

isDSreg=`cat $PRODPATH/logs/summary | grep $DS`
echo $isDSReg
if [ -z "$isDSreg" ];then
    echo -e "$DS\t$Ntot\t$Ndone\t$Nfail\t$Nabort\t$Nstuck\t$Ncreated" >> $PRODPATH/tmp/tmp
else 
#    sed -i '/'$DS'/d' $PRODPATH/tmp/tmp
    echo -e "$DS\t$Ntot\t$Ndone\t$Nfail\t$Nabort\t$Nstuck\t$Ncreated" >> $PRODPATH/tmp/tmp
fi

echo -e "DS\tNtot\tdone\tNfail\tNabort\tNstuck\tNcreated" > $PRODPATH/logs/summary
cat $PRODPATH/tmp/tmp | sort >> $PRODPATH/logs/summary
#echo "" >> $PRODPATH/logs/summary
rm $PRODPATH/tmp/tmp
