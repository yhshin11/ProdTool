#!/bin/bash

source /afs/cern.ch/cms/cmsset_default.sh

cd /afs/cern.ch/user/m/mmarionn/workspace/private/cmssw/
source mm.sh CMSSWEnvVar
cd ProdTool

source setup.sh
prod

python python/sendReport.py

