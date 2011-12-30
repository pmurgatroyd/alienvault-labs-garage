import clusters,os

class logfile(object):
    '''
    Contains the log file for other classes to reference to during processing
    '''    
    
    _filedata = ""
    
    def __init__(self, filename):
        self._filedata = open(filename,'r')
           
    def RetrieveCurrentLine(self):
        return self._filedata.readline()
    
    
mylog = ""
myclusters = clusters.ClusterGroup()
    
if __name__ == '__main__':
    mylog = logfile(os.getcwd() + '/testdata')
    
    logline = mylog.RetrieveCurrentLine() 
    while logline != "":
        myclusters.IsMatch(logline)
        logline = mylog.RetrieveCurrentLine()
        
    myclusters.Results()
    
    