# 2008 DK @ ossim
# 2010/06 DK @ ossim: add .cfg support
# 2012/01 CP @ ossim: ported to Clearcutter, added profiling support

# Please, check regexp.txt to see an example

#TODO: duplicate entire plugin parsing to validate good plugin file and field assignment
#TODO: Identify plugin section that contains bad regexp
#TODO: Implement precheck

import sys,re,ConfigParser
from logfile import LogFile

class ParsePlugin(object):
    """Processes Log Data against a list of regular expressions, possibly read from an OSSIM collector plugin"""
    
    #Commandline Options
    Args = ''
    
    #File containing regexps
    Plugin = ''
    
    #extracted regexps from file
    regexps = {}

    SIDs = {}
    
    Log = ''
    
    sorted_ = {}
    rule_stats = []
    line_match = 0

    #Common Log patterns, as used in OSSIM
    aliases = {
               'IPV4' :"\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}",
               'IPV6_MAP' : "::ffff:\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}",
               'MAC': "\w{1,2}:\w{1,2}:\w{1,2}:\w{1,2}:\w{1,2}:\w{1,2}",
               'PORT': "\d{1,5}",
               'HOSTNAME' : "((([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)([a-zA-Z])+)",
               'TIME' : "\d\d:\d\d:\d\d",
               'SYSLOG_DATE' : "\w{3}\s+\d{1,2}\s\d\d:\d\d:\d\d",
               'SYSLOG_WY_DATE' : "\w+\s+\d{1,2}\s\d{4}\s\d\d:\d\d:\d\d",
              }

    #Hash config items
    def hitems(self,config, section):
        itemhash = {}
        for item in config.items(section):
            itemhash[item[0]] = self._strip_value(item[1])
        return itemhash
    
    def _strip_value(self,value):
        from string import strip
        return strip(strip(value, '"'), "'")
    
    def get_entry(self,config, section, option):
        value = config.get(section, option)
        value = self._strip_value(value)
        return value

   
    def LoadPlugin(self):
        SECTIONS_NOT_RULES = ["config", "info", "translation"]

        self.Plugin = ConfigParser.RawConfigParser()
        self.Plugin.read(self.Args.regexps)
        for section in self.Plugin.sections():
            if section.lower() not in SECTIONS_NOT_RULES :
                if self.IsValidRegex(self.get_entry(self.Plugin, section, 'regexp')):
                    self.regexps[section] = self.hitems(self.Plugin,section)

        self.SIDs = self.regexps.keys()
        self.SIDs.sort()


    def LoadRegexps(self):
        self.regexps = file(self.Args.regexps,'r').readlines()

    def IsValidRegex(self,regex):
        try:
            test = re.compile(regex, flags=0)
            return True
        except re.error:
            sys.stderr.write("\033[91m Regular Expression : " + regex + " is not a valid regular expression \033[0m\n")
            sys.stderr.flush()
            return False

    def PrintResults(self):
        for key in self.SIDs:
            print "Rule: \t%s\n\t\t\t\t\t\tMatched %d times" % (str(key), self.rule_stats.count(str(key)))
   
        print "Counted", len(self.Log), "lines."
        print "Matched", self.matched, "lines."
     
    
    def ParseLog(self):
        f = open(self.Args.logfile, 'r')   #REPLACE WITH ARGS 
        self.Log = f.readlines()
        self.line_match = 0    
        self.matched = 0
        if self.Args.plugin == True : 
            self.ParseLogWithPlugin()
        else:
            self.ParseLogWithList()
    
    def ParseLogWithList(self):
        print "Not Implemented - use Plugin Mode"
        sys.exit()
    
    def ParseLogWithPlugin(self):
        '''Process a logfile according to SID entries in an OSSIM collector plugin'''
        keys = self.regexps.keys()
        keys.sort()
        for line in self.Log:
            for rule in keys:
                rulename = rule
                regexp = self.get_entry(self.Plugin, rule, 'regexp')
                if regexp is "":
                    continue
                # Replace vars
                for alias in self.aliases:
                    tmp_al = ""
                    tmp_al = "\\" + alias;
                    regexp = regexp.replace(tmp_al,ParsePlugin.aliases[alias])
                result = re.findall(regexp,line)
                try:
                    tmp = result[0]
                except IndexError:
                    if self.Args.verbose > 2:
                        print "Not matched", line
                    continue
                # Matched
                if self.Args.quiet is False:
                    print "Matched using %s" % rulename
                if self.Args.verbose > 0:
                    print line
                if self.Args.verbose > 2:
                    print regexp
                    print line
                try:
                    if self.Args.column > 0:  #Change this to print positional
                        print "Match $%d: %s" % (int(sys.argv[3]),tmp[int(sys.argv[3])-1])
                    else:
                        if self.Args.quiet == False:
                            print result
                except ValueError:
                    if self.Args.quiet is False:
                        print result
                # Do not match more rules for this line
                self.rule_stats.append(str(rulename))
                self.matched += 1
                break
    
    def ParseLogWithRegex(self):
        '''Process a logfile according to Regular Expressions in a text file'''
        pass
        
    def __init__(self,args):
        self.Args = args
        if self.Args.plugin == True: 
            self.LoadPlugin()
        else:
            self.LoadRegexps()

                