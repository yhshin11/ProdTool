import os, re, sys

## set environment
path = os.getenv("PRODPATH")

##open cfg file
cfgLoc = path+'/config/prod.cfg'
cfgFile = open(cfgLoc)

#Variables to be set
cmsswDatFile = ''
cmsswMCFile = ''

se = ''
sepath = ''
serep = ''
mail = ''

dataDS = []
mcDS = []


## parse the config file
dssec = False
for line in cfgFile.readlines():
   # print line
 
    if not dssec :
        sline = re.split("\t" , line)
        
        if sline[0] == 'DataFileCMSSW' :
            cmsswDatFile = (sline[1])[:-1]
        if sline[0] == 'MCFileCMSSW' :
            cmsswMCFile = (sline[1])[:-1]
        if sline[0] == 'StoreElem' :
            se = (sline[1])[:-1]
        if sline[0] == 'MainPath' :
            sepath = (sline[1])[:-1]
        if sline[0] == 'StoreRep' :
            serep = (sline[1])[:-1]
        if sline[0] == 'Email' :
            mail = (sline[1])[:-1]

      
 ##dataset section
    if 'Datasets' in line : 
        dssec = True
  
    if dssec :
        sline = re.split("\t" , line)
        if sline[0] == 'Data' :
            tmp = []
            for k in range(1, len(sline) ) :
                tmp.append(sline[k])
            dataDS.append(tmp)
        if sline[0] == 'MC' :
            tmp = []
            for k in range(1, len(sline) ) :
                tmp.append(sline[k])
            mcDS.append(tmp)
            
        #end section
        if '===' in line :
            dssec = False

cfgFile.close()


import time            # Importation
import locale          # Importation
locale.setlocale(locale.LC_ALL,'') 
temp=time.strftime('%m%d%Y_%H%M%S')

logFile=open(path+'/logs/weekLogs/log_'+temp,"w")
logFile.write(mail+"\n")
logFile.write("=== Begin report ===\n")


### files for MC

mcCrab = open( path+'/crabCfgs/templates/crab_MC_template.cfg','r')
lines = mcCrab.readlines()
mcCrab.close()

for ids in mcDS:

    nameDS = ids[0]
    tagDS = ids[1]
    nEvtDS = ids[2]
    opts = []
    if len(ids) > 3 :
      #  print ids
        for k in range(3, len(ids)) : 
            opts.append( ids[k] )

    if int(nEvtDS) == -1:
        nEvtDS = str(20000)
        
    crabFile = path+'/crabCfgs/MC/'+tagDS+'.cfg'
    
 
    #if file already exists, the dataset was already created
    if not os.path.exists(crabFile) :
        #write and prepare the crab cfg
        fmc = open(crabFile,"w")
        for line in lines:
            line = line.replace('cmsswFile', cmsswMCFile )
            line = line.replace('DS', nameDS )
            line = line.replace('storageElem', se )
            line = line.replace('storagepath', sepath+serep )
            line = line.replace('mailaddress', mail )
            line = line.replace('taskName', tagDS )
            line = line.replace('nEvtsPJ', nEvtDS )
             
            fmc.write(line)

        #Now options
        #print tagDS,"   ",len(opts)
        for iopt in opts :
            tmp = re.split("\." , iopt)
         #   print iopt,"   "
         #   for ii in tmp :
         #       print "--->",ii
            fmc.write( "\n\n["+tmp[0]+"]\n"+tmp[1]+"\n")

        fmc.close()

        report= "Info : Create new Simulation task for DS "+nameDS+"\n"
        logFile.write(report)  


### update JSON file list
#sys.argv=""
os.system(path+"/scripts/findJSON.sh /afs/cern.ch/cms/CAF/CMSCOMM/COMM_DQM/certification/Collisions12/8TeV/")

#os.system("source "+path+"/script/findJSON.sh")


###files for data

### List the datasets to get "priority" to the ReReco datasets

tmpRR = []
tmpPr = []

for ids in dataDS:
    nameDS = ids[0]
    tagBaseDS = ids[1]
    nEvtDS = ids[2]
    if "PromptReco" not in nameDS : #files are ordered, 1st one is the most recent
        tmpRR.append( ids )
    else:
        tmpPr.append( ids )
        
del(dataDS[:])
dataDS = tmpRR
dataDS.extend( tmpPr )

for ids in dataDS:

    skipRunDB=0
    noJson=0
    nameDS = ids[0]
    tagBaseDS = ids[1]
    nEvtDS = ids[2]
    opts = []
    if len(ids) > 3 :
      #  print "!!!! ",ids
        for k in range(3, len(ids)) :
     #       print "!!! ",ids[k]
            if ids[k].find('skipRunDB') != -1 :
                skipRunDB=1
            elif ids[k].find('noJson') != -1 :
                noJson=1
            else : 
                opts.append( ids[k] )
           
    
    if int(nEvtDS) == -1:
        nEvtDS = str(20)

    runmin=-1
    runmax=-1
    runminproc=-1
    runmaxproc=-1
    runminjson=-1
    runmaxjson=-1
    jsonfile="nojson"

      #retrieve the jsonfile
    if "PromptReco" not in nameDS: # this is not prompt reco
        jsondb = open(path+'/database/jsonListR',"r")
        jsonfiles=jsondb.readlines()
      ##   print nameDS
##                     #need the version to find the good jsonfile... or not...
        tmp= re.split("-" , nameDS)
        for i in tmp:
        #    print i
            if "Run" not in i and "recover" not in i and "AOD" not in i:
                tag=i
       #         print tag
                break
        for ijson in jsonfiles:
          #  print ijson
            tmp =re.split("\t" ,ijson )
            if tag in ijson:
          #      print tag,"  ",tmp[0]
                runminjson = tmp[0]
                runmaxjson = tmp[1]
                jsonfile=tmp[2][:-1]
                #break # fixme : disabled to allow the program to take the last json file


        #retrieve the jsonfile in embedded samples
        if "embedded" in nameDS: # this is not prompt reco
            jsondb = open(path+'/database/jsonListR',"r")
            jsonfiles=jsondb.readlines()
            print nameDS
##                     #need the version to find the good jsonfile... or not...
            tmp= re.split("_" , nameDS)
            for i in tmp:
                print i,"  ",len(i)
                if len(i) == 9:
                    tag=i
                    #   print tag,"  ",len(i)
                    break
            for ijson in jsonfiles:
                print ijson
                tmp =re.split("\t" ,ijson )
                if tag in ijson:
                    print tag,"  ",tmp[0]
                    runminjson = tmp[0]
                    runmaxjson = tmp[1]
                    jsonfile=tmp[2][:-1]
                    break
                    
##         jsonfiles.reverse()
##         tmp =re.split("\t" ,jsonfiles[0] )
##         runminjson = tmp[0]
##         runmaxjson = tmp[1]
##         jsonfile=tmp[2][:-1]
      

                
    else: #promp-reco, the last one is the good one
        jsondb = open(path+'/database/jsonListP',"r")
        tmp =re.split("\t" ,jsondb.readline() )
        runminjson = tmp[0]
        runmaxjson = tmp[1]
        jsonfile=tmp[2][:-1]
        
    jsondb.close()


    #update run informations
    if skipRunDB == 0 :
        os.system(path+"/scripts/makeRunDB.sh "+nameDS+" "+tagBaseDS)
           
        ### get the run informations from the dataset
        dbfile = open( path+'/database/'+tagBaseDS+'.db','r')
        dblines=dbfile.readlines()
        dbfile.close()
        for line in dblines:
            #     print sline
            sline = re.split("\t" , line)
            if sline[0] == "runmin" :
                runmin=sline[1][:-1]
            if sline[0] == "runmax" :
                runmax=sline[1][:-1]
            if sline[0] == "runminproc" :
                runminproc=sline[1][:-1]
            if sline[0] == "runmaxproc" :
                runmaxproc=sline[1][:-1]

    else: #huge dirty bypass... improvement should be in the DB treatment
        runmin=runminjson
        runmax=runmaxjson
        if not os.path.exists(path+'/database/'+tagBaseDS+'.db') :
            runminproc="-1"
            runmaxproc="-1"
            dbfile = open( path+'/database/'+tagBaseDS+'.db','w')
            dbfile.write("runmin\t"+runmin+"\n")
            dbfile.write("runmax\t"+runmax+"\n")
            dbfile.write("runminproc\t"+runminproc+"\n")
            dbfile.write("runmaxproc\t"+runmaxproc+"\n")
        else:
            runminproc=runminjson
            runmaxproc=runmaxjson
        
  #  print runmin,"  ",runminproc,"  ",runminjson,"  ",runmax,"  ",runmaxproc,"  ",runmaxjson,"  "

    if int(runmin) != int(runminproc) and int(runminproc) != -1 :
        report="Warning for "+nameDS+" : difference between the minimum run processed ("+runminproc+") and the minimum available run ("+runmin+")"
        print report
        logFile.write(report+"\n")
    if int(runmax) == int(runmaxproc) or int(runmaxjson) == int(runmaxproc):
        report= "Info : no new data for the dataset "+nameDS+" : runM="+runmax+" ; runMproc="+runmaxproc+" ; runMJSON="+runmaxjson
        print report
        logFile.write(report+"\n")
    else:
        if int(runminproc) == -1: #new operation, the dataset was never processed
            task_runm = int(runmin)
            if int(runminproc) != int(runminjson) and "PromptReco" not in nameDS:
                task_runm = int(runminjson)
        else: #dataset was partially processed
            task_runm = int(runmaxproc)+1

        if int(runmax) <= int(runmaxjson) and int(runmax) != 0 :
            task_runM = int(runmax)
        else:
            task_runM = int(runmaxjson)

        ##Json option
        if noJson == 1 :
            jsonfile="lumimask"
            task_runm=0
            task_runM=0
            if not os.path.exists(path+'/database/'+tagBaseDS+'.db') :
                dbfile = open( path+'/database/'+tagBaseDS+'.db','w')
                dbfile.write("runmin\t"+runmin+"\n")
                dbfile.write("runmax\t"+runmax+"\n")
                dbfile.write("runminproc\t"+runmin+"\n")
                dbfile.write("runmaxproc\t"+runmax+"\n")
                           
        report= "Info : Create new task for DS "+nameDS+" : runs are "+str(task_runm)+" to "+str(task_runM)+"\n"
        report=report+"\t\t ---> old runs were : runm="+runminproc+"  runM="+runmaxproc+"\n"
        logFile.write(report)
             
        tagDS=tagBaseDS+"_"+str(task_runm)+"_"+str(task_runM)
        crabFile = path+'/crabCfgs/Data/'+tagDS+'.cfg'

        #if file already exists, the dataset was already created
        if not os.path.exists(crabFile) :#write and prepare the crab cfg
            fdata = open(crabFile,"w")
            dataCrab = open( path+'/crabCfgs/templates/crab_data_template.cfg','r')
            lines=dataCrab.readlines()
            dataCrab.close()
            for line in lines:
                line = line.replace('cmsswFile', cmsswDatFile )
                line = line.replace('DS', nameDS )
                if noJson == 1 :
                    line = line.replace('lumi_mask=lumimask', "" )
                    line = line.replace('runselection=runrange', "" )
                else :
                    line = line.replace('lumimask', jsonfile )
                    line = line.replace('runrange', str(task_runm)+"-"+str(task_runM) )
                line = line.replace('storageElem', se )
                line = line.replace('storagepath', sepath+serep )
                line = line.replace('mailaddress', mail )
                line = line.replace('taskName', tagDS )
                line = line.replace('nLumiPJ', nEvtDS )

                fdata.write(line)

            #Now options
            for iopt in opts :
                #print "-------------->",iopt
                if iopt.find("skip") == -1 and iopt.find("noJson") == -1 :
                    tmp = re.split("\." , iopt)
                    fdata.write( "\n\n["+tmp[0]+"]\n"+tmp[1]+"\n")
                            
            fdata.close()
         
        ### update run DB
            runDB= open(path+'/database/'+tagBaseDS+".db",'r')  
            lines = runDB.readlines()
            runDB.close()
            oDB= open(path+'/database/'+tagBaseDS+".db",'w')  
            for line in lines:
                if 'runminproc' in line:
                    line="runminproc "+str(task_runm)+"\n"
                if 'runmaxproc' in line:
                    line="runmaxproc "+str(task_runM)
              
                oDB.write(line)

            oDB.close()

        else: #you have a huge problem if you are here
            report="Error, file "+tagDS+".cfg already exists"
            print report
            logFile.write(report)  

logFile.write("=== End report ")
logFile.close()







