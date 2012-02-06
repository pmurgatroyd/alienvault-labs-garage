'''
Common Variables in System Logs, identified via Regex

Add extra variable pattern regex's here
'''

import re


aliases = {
    '[IPV4]' :"\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}",
    '[IPV6_MAP]' : "::ffff:\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}",
    '[MAC]' : "\w{1,2}:\w{1,2}:\w{1,2}:\w{1,2}:\w{1,2}:\w{1,2}",
    '[HOSTNAME]' : "((([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)([a-zA-Z])+)",
    '[TIME]' : "\d\d:\d\d:\d\d",
    '[SYSLOG_DATE]' : "\w{3}\s+\d{1,2}\s\d\d:\d\d:\d\d",
    '[SYSLOG_DATE_SHORT]' : "\w+\s+\d{1,2}\s\d\d:\d\d:\d\d\s\d{4}",
    '[SYSLOG_WY_DATE]' : "\S+\s\w+\s+\d{1,2}\s\d\d:\d\d:\d\d\s\d{4}",
    '"[QUOTED STRING]"' : "\".*\"",
    '[NUMBER]' :"\s\d+{2:}\s"
    }

def FindCommonRegex(teststring):
        """
        Test the string against a list of regexs for common data types, and return a placeholder for that datatype if found
        """
        #aliases['PORT']="\d{1,5}"

        
        returnstring = teststring
        replacements = aliases.keys()
        replacements.sort()
        for regmap in replacements:
                p = re.compile(aliases[regmap])
                returnstring = p.sub(regmap,returnstring)
        return returnstring
    
