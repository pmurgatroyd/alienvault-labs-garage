# 2008 DK @ ossim
# 2010/06 DK @ ossim: add .cfg support
# 2012/01 CP @ ossim: ported to Clearcutter, added profiling support
# TODO: Match rules from .cfg in the same order as the Agent does
# Please, check regexp.txt to see an example

import sys,re
import ConfigParser

class ParsePlugin(object):
    """Processes Log Data against a list of regular expressions, possibly read from an OSSIM collector plugin"""
    
    #Commandline Options
    options = ''
    
    #File containing regexps
    plugincfg = ''
    
    #extracted regexps from file
    regexps = {}

    sorted_ = {}
    rule_stats = []


    #Common data patterns, as used in OSSIM
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
            hash[item[0]] = self._strip_value(item[1])
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


        config = ConfigParser.RawConfigParser()
        config.read(self.options.regexp)
        for section in config.sections():
            if section.lower() not in SECTIONS_NOT_RULES :
                self.regexps[section] = self.hitems(config,section)
        keys = self.regexps.keys()
        keys.sort()
                

    def PrintResults(self):
        for key in self.keys:
            print "Rule: \t%s\n\t\t\t\t\t\tMatched %d times" % (str(key), self.rule_stats.count(str(key)))
   
        print "Counted", len(self.data), "lines."
        print "Matched", self.matched, "lines."
    
    
    def ParseLog(self):
        f = open(self.options.filename, 'r')   #REPLACE WITH ARGS 
        data = f.readlines()
        self.plugincfg=self.options.cfgfile
        line_match = 0    
        matched = 0
        
        for line in self.data:
            for rule in self.regexps.iterkeys():
                rulename = rule
                regexp = self.get_entry(self.plugincfg, rule, 'regexp')
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
                    if sys.argv[3] is "y":
                        print "Not matched", line
                    continue
                # Matched
                if sys.argv[3] is not "q":
                    print "Matched using %s" % rulename
                if sys.argv[3] is "v":
                    print line
                if sys.argv[3] is "V":
                    print regexp
                    print line
                try:
                    if int(sys.argv[3]) > 0:
                        print "Match $%d: %s" % (int(sys.argv[3]),tmp[int(sys.argv[3])-1])
                    else:
                        if sys.argv[3] is not "q":
                            print result
                except ValueError:
                    if sys.argv[3] is not "q":
                        print result
                # Do not match more rules for this line
                self.rule_stats.append(str(rulename))
                matched += 1
                break
    
        
    def __init__(self,args,logfile):
        pass
        # parse args into options
        #Options[
        #Options[PluginCfg] = args.plugincfg
        #Options['ParseFile']: False,
        #Options['ParsePlugin']: False,
        #Options['ParseSingleRegexp'] : False,
        #Options['PrintMatching'] : False,
        #Options['PrintNoMatching']: False,
        #Options['ProfileSID'] : False,
        #Options['ProfileLog'] : False,
        #Options['PluginCFG'] : ""

        
        # load Ossim config if appropriate
        # ParsePluginSIDS()
        #pass
