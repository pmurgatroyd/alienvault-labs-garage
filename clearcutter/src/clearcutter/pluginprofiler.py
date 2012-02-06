import cProfile,pstats,re

logdata = ''
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

def __init__(self,log):
    self.logdata = open(log, 'r').readlines()

def ProfileRegexp(self,regexp):
    cProfile.run('self.Profilewrap(regexp)','profiler.out')
    profstats = pstats.Stats('profiler.out')
    profstats.print_stats()

def ProfileWrap(self,regexp):
    for line in self.logdata:
        for alias in self.aliases:
            tmp_al = ""
            tmp_al = "\\" + alias;
            regexp = regexp.replace(tmp_al,self.aliases[alias])
        result = re.findall(regexp,line)
        try:
            tmp = result[0]
        except IndexError:
            continue
    
      

