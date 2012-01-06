# 2008 DK @ ossim
# 2010/06 DK @ ossim: add .cfg support
# 2012/01 CP @ ossim: ported to Clearcutter, added profiling support
# TODO: Match rules from .cfg in the same order as the Agent does
# Please, check regexp.txt to see an example

import sys,re
import ConfigParser


#Globals


############################## Function definitions ###########################

def hitems(config, section):
    hash = {}
    for item in config.items(section):
        hash[item[0]] = _strip_value(item[1])
    return hash

def _strip_value(value):
    from string import strip
    return strip(strip(value, '"'), "'")

def get_entry(config, section, option):
    value = config.get(section, option)
    value = _strip_value(value)
    return value



############################## End definitions ###########################

class ParsePlugin(object):
    """Processes Log Data against an OSSIM collector plugin"""
    
    Options = {
               'ParseFile': False,
               'ParsePlugin': False,
               'ParseSingleRegexp' : False,
               'PrintMatching' : False,
               'PrintNoMatching': False,
               'ProfileSID' : False,
               'ProfileLog' : False,
               'PluginCFG' : ""
               }

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

    
    def __init__(self):
        pass
    

    def Parse(self):
        pass
        # Sanity Checks for Config

        f = open(sys.argv[1], 'r')
        data = f.readlines()
        cfg_file=exp=sys.argv[2]
        single_regexp=True
        if exp.endswith(".cfg"):
            single_regexp=False
            print "Multiple regexp mode used, parsing %s " % exp
        else:
            print sys.argv[2]

            line_match = 0
    
    matched = 0
    
    if single_regexp == True:
        # single regexp mode
        for line in data:
            result = re.findall(exp,line)
            try:
                tmp = result[0]
            except IndexError:
                if sys.argv[3] is "y":
                    print "Not matched:", line
                continue
            # Matched
            if sys.argv[3] is "v":
                print line
            if sys.argv[3] is "V":
                print exp
                print line
            try:
                if int(sys.argv[3]) > 0:
                    print "Match $%d: %s" % (int(sys.argv[3]),tmp[int(sys.argv[3])-1])
                    #print "Match %d: %s" % (int(sys.argv[3]),result[int(sys.argv[3])])
                else: 
                    if sys.argv[3] is not "q":
                        print result
            except ValueError:
                if sys.argv[3] is not "q":
                    print result
            matched += 1
    
        print "Counted", len(data), "lines."
        print "Matched", matched, "lines."
    else:
        SECTIONS_NOT_RULES = ["config", "info", "translation"]
        rules = {}
        sorted_rules = {}
        rule_stats = []
        # .cfg file mode
        config = ConfigParser.RawConfigParser()
        config.read(cfg_file)
        for section in config.sections():
            if section.lower() not in SECTIONS_NOT_RULES :
                rules[section] = hitems(config,section)
        keys = rules.keys()
        keys.sort()
        
        
        for line in data:
            for rule in rules.iterkeys():
                rulename = rule
                regexp = get_entry(config, rule, 'regexp')
                if regexp is "":
                    continue
                # Replace vars
                for alias in aliases:
                    tmp_al = ""
                    tmp_al = "\\" + alias;
                    regexp = regexp.replace(tmp_al,aliases[alias])
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
                rule_stats.append(str(rulename))
                matched += 1
                break
    
        print "-----------------------------------------------------------------------------"
    
        for key in keys:
            print "Rule: \t%s\n\t\t\t\t\t\tMatched %d times" % (str(key), rule_stats.count(str(key)))
    
        print "Counted", len(data), "lines."
        print "Matched", matched, "lines."
    
    




def LoadPlugin():
    pass

def LoadLogFile():
    pass

    
def ParseLog():
     for line in data:
        for rule in rules.iterkeys():
            rulename = rule
            regexp = get_entry(config, rule, 'regexp')
            if regexp is "":
                continue
            # Replace vars
            for alias in aliases:
                tmp_al = ""
                tmp_al = "\\" + alias;
                regexp = regexp.replace(tmp_al,aliases[alias])
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
            rule_stats.append(str(rulename))
            matched += 1
            break

def ParseSingleRegex(regexp):
 # single regexp mode
    for line in data:
        result = re.findall(exp,line)
        try:
            tmp = result[0]
        except IndexError:
            if sys.argv[3] is "y":
                print "Not matched:", line
            continue
        # Matched
        if sys.argv[3] is "v":
            print line
        if sys.argv[3] is "V":
            print exp
            print line
        try:
            if int(sys.argv[3]) > 0:
                print "Match $%d: %s" % (int(sys.argv[3]),tmp[int(sys.argv[3])-1])
                #print "Match %d: %s" % (int(sys.argv[3]),result[int(sys.argv[3])])
            else: 
                if sys.argv[3] is not "q":
                    print result
        except ValueError:
            if sys.argv[3] is not "q":
                print result
        matched += 1

    print "Counted", len(data), "lines."
    print "Matched", matched, "lines."
    

def ParsePluginSIDs()
    SECTIONS_NOT_RULES = ["config", "info", "translation"]
    rules = {}
    sorted_rules = {}
    rule_stats = []
    # .cfg file mode
    config = ConfigParser.RawConfigParser()
    config.read(cfg_file)
    for section in config.sections():
        if section.lower() not in SECTIONS_NOT_RULES :
            rules[section] = hitems(config,section)
    keys = rules.keys()
    keys.sort()
    
    
    for line in data:
        for rule in rules.iterkeys():
            rulename = rule
            regexp = get_entry(config, rule, 'regexp')
            if regexp is "":
                continue
            # Replace vars
            for alias in aliases:
                tmp_al = ""
                tmp_al = "\\" + alias;
                regexp = regexp.replace(tmp_al,aliases[alias])
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
            rule_stats.append(str(rulename))
            matched += 1
            break

    print "-----------------------------------------------------------------------------"

    for key in keys:
        print "Rule: \t%s\n\t\t\t\t\t\tMatched %d times" % (str(key), rule_stats.count(str(key)))

    print "Counted", len(data), "lines."
    print "Matched", matched, "lines."
: