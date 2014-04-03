#!/bin/bash

JSON=Cert_190456-198485_8TeV_PromptReco_Collisions12_JSON.txt
PU=pileup_JSON_DCSONLY_190389-200041_pixelcorr.txt #pileup_JSON_DCSONLY_190389-199282.txt

JSONLOC=/afs/cern.ch/cms/CAF/CMSCOMM/COMM_DQM/certification/Collisions12/8TeV/Prompt
PULOC=/afs/cern.ch/cms/CAF/CMSCOMM/COMM_DQM/certification/Collisions12/8TeV/PileUp


pileupCalc.py -i $JSONLOC/$JSON --inputLumiJSON $PULOC/$PU --calcMode true --minBiasXsec 69400 --maxPileupBin 60 --numPileupBins 60 histo.root