import os, re, sys, time, locale

from mailer import *

## set environment
path = os.getenv("PRODPATH")


locale.setlocale(locale.LC_ALL,'') 
temp=time.strftime('%m/%d/%Y, %H:%M (GMT)')
title="ProdTool Report : "+temp+""

#find last log
os.system('ls -tr '+path+'/logs/weekLogs/log* | tail -1 > $PRODPATH/tmp/tmploc')
tmpFile=open(path+"/tmp/tmploc","r")
loginfo=tmpFile.readline()
tmpFile.close()
logFile=open(loginfo[:-1],"r")
lines=logFile.readlines()
address=""
logFile.close()

msg="\n"
for line in lines:

    if '@' in line:
        address=line
    else:
        msg=msg+line


msg=msg+"\n\n"
msg=msg+"===== Summary =====\n"

summary=open(path+'/logs/summary',"r")
lines=summary.readlines()
summary.close()
for line in lines:
    msg=msg+line

msg=msg+"\n\n"

sendmail(title,msg,address)
