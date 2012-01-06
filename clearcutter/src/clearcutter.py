#!/usr/bin/env python
import clusters,sys,argparse

log = ''

class LogFile(object):
    '''
    Contains the log file for other classes to reference to during processing
    '''    
    _filedata = ""
    Filename = ""
    
    def __init__(self, filename):
        self._filedata = open(filename,'r')
        self.Filename = filename
           
    def RetrieveCurrentLine(self):
        return self._filedata.readline()
    
        

    

    #try:
    #    log = LogFile(sys.argv[2])
    #    print "Using Log File %s" % sys.argv[2]
    #except IndexError:
    #    print "no "
    #except ValueError:
    #    print "File load error" 
    #    print sys.exc_info()[0]



        #print "Log Extraction Mode (identify unique log messages)"
        #print "\n\t%s extract <sample file> [threshold] [outfile]"  % sys.argv[0]
        #print "\n\t\t<sample file> - log sample file to process"
        #print "\n\t\t[threshold] - how many values a field should have to be considered variable"
        #print "\n\t\t[outfile] - file to write potential unique log messages to"
        #<toggle common regexps
        
        #note to user that large files take a very long time
        # build a spinner?
        
        #print "Plugin Parsing Mode"
        #    parsing
        #        matching
        #            Summary
        #            Display Matched
        #            Display Unmatched
        #            Display Matched Offset
        #        profiling
        #            SID profiling
        #            Log profiling
        #            SID re-ordering
        

        
        
def DoLogExtract(args):
    """Commence Log Message Extraction mode""" 
    log = LogFile(args.filename)
    myclusters = clusters.ClusterGroup()
    logline = log.RetrieveCurrentLine() 
    while logline != "":
        myclusters.IsMatch(logline)
        logline = log.RetrieveCurrentLine()
        
    myclusters.Results()
    # import clusters
    # process clusters
    
    
    
def DoLogParse():
    """Commence Plugin Parsing Mode"""
    
    #import logregex
    #process log from plugin
    pass

def DoLogProfile():
    """Commence OSSIM SID Profiling"""
    # Prep Profiling
    # Do the regular logparse
    # Process and print the results
    pass


#=========================
mode = {'extract' : DoLogExtract, 'parse' : DoLogParse, 'profile' : DoLogProfile}
        
def ParseArgs():
    parser = argparse.ArgumentParser(description='Processes log files for SIEM consumption')
    parser.add_argument('mode', action='store',choices=['extract','parse','profile'], help='extract (find potential unique log event types) ------ parse (parse a log file using an OSSIM plugin config)\nprofile (generate performance data) ')
    parser.add_argument('filename', action='store',help='log file to process')
    args = parser.parse_args()
    
    if args.mode not in mode.iterkeys():
        parser.print_usage(None)
    else:
        mode[args.mode](args)

if __name__ == '__main__':
    ParseArgs()

#==========================