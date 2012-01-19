"""
Clusters Locate clusters of test in Logfiles, to assist in processing discrete log messages,
from any given log data sample and assist in the creation of Regular Expression to parse those log entries
"""

#TODO: Remove all printing code and store internally: have presentation layer do output
#TODO: More Regexp Patterns
#TODO: Quoted Text Grouping
#TODO: During Nephew Check, compare against the ones with the most children first (more likely to find a match)
#TODO: Fix the results printing for proper recursion

import re

def FindCommonRegex(teststring):
    """
    Test the string against a list of regexs for common data types, and return a placeholder for that datatype if found
    """
    #aliases['PORT']="\d{1,5}"
    aliases = {}
    aliases['IPV4']="\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"
    aliases['IPV6_MAP']="::ffff:\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"
    aliases['MAC']="\w{1,2}:\w{1,2}:\w{1,2}:\w{1,2}:\w{1,2}:\w{1,2}"
    aliases['HOSTNAME']="((([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)([a-zA-Z])+)"
    aliases['TIME']="\d\d:\d\d:\d\d"
    aliases['SYSLOG_DATE']="\w{3}\s+\d{1,2}\s\d\d:\d\d:\d\d"
    aliases['SYSLOG_DATE_SHORT']="\w+\s+\d{1,2}\s\d\d:\d\d:\d\d\s\d{4}"
    aliases['SYSLOG_WY_DATE']="\S+\s\w+\s+\d{1,2}\s\d\d:\d\d:\d\d\s\d{4}"
    
    returnstring = teststring
    for regmap in aliases.iterkeys():
        p = re.compile(aliases[regmap])
        returnstring = p.sub("[" + regmap + "]",returnstring)
        
    return returnstring


class ClusterNode(object):
    """
    Linked list node for log patterns
    """

    Children = []
    Content = ""
    Parent = None
    ContentHash = ""
 
    def __init__(self,NodeContent="Not Provided"):
        self.Children = []
        self.Content = NodeContent
        #print "Created new Node " + str(id(self)) + " with content : " + self.Content      
        self.ContentHash = hash(NodeContent)
    
    def GetChildren(self):
        return self.Children
    
    def GetContent(self):
        return self.Content

    def MatchChild(self,MatchContent):
        if len(self.Children) == 0:
            #print "No Children"
            return None
        else:
            for child in self.Children:
                if (child.ContentHash == hash(MatchContent)):
                    #print "Found Child Match : " + child.Content
                    return child
                else:
                    return None
              

    def MatchNephew(self,MatchContent):
        """Find Nephew Match"""
        if self.Parent == None: #This node is the root node
            return None
        for sibling in self.Parent.Children:
            if len(sibling.Children) > 0 :  # no point if sibling has no children
                for child in sibling.Children: #let's see which child node this matches  
                    if (child.Content == MatchContent):
                        return child
                        #print "Found Nephew Match " + sibling.Content + " - " + child.Content
        return None
                    
    def AddChild(self,NodeContent):
        ChildContent = ClusterNode(NodeContent)
        ChildContent.Parent = self
        self.Children.append(ChildContent)
        #print "Adding child " + ChildContent.Content + " to parent " + self.Content
        return ChildContent
    
    VarThreshold = 10
    
    def GeneratePath(self):
        currentNode = self
        parentpath = ""
        while currentNode.Content != "ROOTNODE":
            if len(currentNode.Parent.Children) > self.VarThreshold:
                parentpath = "[VARIABLE]" + " " + parentpath
            else:
                parentpath = currentNode.Content + " " + parentpath
            currentNode = currentNode.Parent
        return parentpath




class ClusterGroup(object):
    """
    A Group of word rootcluster
    """
    
    args = ""

    rootNode = ClusterNode(NodeContent="ROOTNODE")
    
    entries = []
        
    def __init__(self):
        self.rootNode = ClusterNode(NodeContent="ROOTNODE")           
                            
    def IsMatch(self,logline):  
        '''
        Test the incoming log line to see if it matches this clustergroup
        Return boolean match
        '''
        logwords = FindCommonRegex(logline).split()
        
        currentNode = self.rootNode 
        for logword in logwords: #process logs a word at a time            
            #match our own children first
            match = currentNode.MatchChild(MatchContent=logword)
            
            if match == None: #then try our siblings
                match = currentNode.MatchNephew(MatchContent=logword)
            
            if match == None:  #then add a new child
                match = currentNode.AddChild(NodeContent=logword)
            
            if match == None:
                print "FAILED"    
            else:
                currentNode = match
            #print "switch current Node to " + str(id(currentNode))


    def IsEndNode(self,Node):
        endnode = False
        if (len(Node.Children) == 0): #I'm an EndNode for a log wording cluster    
            #let's make sure our siblings are all endnodes too, and this is really var data
            if Node.Parent is not None:
                siblingChildCount = 0
                for sibling in Node.Parent.Children:
                    siblingChildCount += len(sibling.Children)
                
                if (siblingChildCount == 0) and (len(Node.Parent.Children) >= ClusterNode.VarThreshold):  #log event ends in a variable 
                    endnode = True                       
        
        if endnode == True:
            entry = Node.GeneratePath()
            if entry not in self.entries: self.entries.append(entry)
        
    def BuildResultsTree(self,node):
        '''Recurse through the Node Tree, identifying and printing complete log patterns'''
        
        if self.IsEndNode(node) == True : return None # no children so back up a level
        for childnode in node.Children:
            self.BuildResultsTree(childnode)
            
    def Results(self):
        '''Display all identified unique log event types'''
        #if options.outfile == true: dump to file 
        print "\n========== Potential Unique Log Events ==========\n"
        self.BuildResultsTree(self.rootNode)
        for entry in self.entries:
            print entry
