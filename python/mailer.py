
##==============================================
## Homemade function to send a mail from CERN 
## copyright JB Blanchard
##==============================================

def sendmail(sub,msg,address) :
    import smtplib
    fromaddr = address
    toaddrs = fromaddr
    theMessage="""From: ProdTool Report <"""+fromaddr+""">
To: Receiver <"""+toaddrs+""">
Subject: """+sub+"""

"""+msg+"""

End of report
"""
    server = smtplib.SMTP("cernmx.cern.ch")
    server.starttls()
    server.sendmail(fromaddr, toaddrs, theMessage)
    server.quit()
    pass


