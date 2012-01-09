#!/usr/bin/env python

'''ClearCutter - a general purpose log analysis tool with OSSIM-specific features'''

__author__ = "CP Constantine"
__email__ = "conrad@alienvault.com"
__copyright__ = 'Alienvault 2012'
__credits__ = ["Conrad Constantine","Dominique Karg"]
__version__ = "$Revision: 63990 $"
__license__ = "GPL"
__status__ = "Prototype"
__maintainer__ = "CP Constantine"

import sys,argparse,clusters #,ccregex

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
    try:
        log = LogFile(args.filename)
    except IOError:
        print "File: " + filename + " cannot be opened : " + str(sys.exc_info()[1])
        sys.exit()
      
    myclusters = clusters.ClusterGroup()
    logline = log.RetrieveCurrentLine() 
    while logline != "":
        myclusters.IsMatch(logline)
        logline = log.RetrieveCurrentLine()
        
    myclusters.Results()
    
def DoLogParse(args):
    """Commence Plugin Parsing Mode"""
    try:
        log = LogFile(args.filename)
    except IOError:
        print "File: " + filename + " cannot be opened : " + str(sys.exc_info()[1])
        sys.exit()
    myregexps = ccregex.ParsePlugin(args)
    myregexps.Parse()
    #import logregex
    #process log from plugin
    print "Not Yet Implemented"
    sys.exit()

def DoLogProfile():
    """Commence OSSIM SID Profiling"""
    # Prep Profiling
    # Do the regular logparse
    # Process and print the results
    print "Not Yet Implemented"
    sys.exit()



#=========================
mode = {'extract' : DoLogExtract, 'parse' : DoLogParse, 'profile' : DoLogProfile}
        
def ParseArgs():
    parser = argparse.ArgumentParser(formatter_class = argparse.RawDescriptionHelpFormatter, \
                                     description='Processes log files for SIEM consumption',
                                     epilog='examples:\n\t%(prog)s identify sample.log\n\t%(prog)s parse plugin.cfg sample.log\n\t%(prog)s profile plugin.cfg sample.log')
    modeparsers = parser.add_subparsers(help='Command Mode Help')
        
    parser.add_argument('-v', action='count',help='verbose mode - use multiple times to increase verbosity')
    parser.add_argument('-q', action='store_true',help='quiet mode - print nothing but results')
    parser.add_argument('-o', action='store', type = str, metavar = 'file' , help='Write results to <file>')
    
    logextractparser = modeparsers.add_parser('identify',help='Log Event Candidate Identification')
    logextractparser.add_argument('extract - Log Event Message Type Extraction')
    logextractparser.add_argument('filename', action='store',help='log file to process')
    logextractparser.add_argument('-t', '--threshold', type=int, action='store', help='Threshold value for Variable Assignment', )
    
    logparseparser = modeparsers.add_parser('parse',help = 'OSSIM Plugin Parse Testing')
    logparseparser.add_argument('plugin', action='store',help='OSSIM plugin .cfg file')
    logparseparser.add_argument('-n', action='store',help='Show Matching values from position N')    
    
    profileparser = modeparsers.add_parser('profile',help = 'OSSIM Plugin Performance Profiling')
    profileparser.add_argument('plugin', action='store',help='OSSIM plugin .cfg file')
    profileparser.add_argument('-s','--sort', action='store_true',help='Sort Results by Execution Time')
    
    #profilegroup.add_argument()
    #profilegroup.add_argument()
    
    args = parser.parse_args()
    
    if args.mode not in mode.iterkeys():
        parser.print_usage(None)
    else:
        mode[args.mode](args)

if __name__ == '__main__':
    ParseArgs()

