import re

def FindCommonRegex(teststring):
    """
    Test the string against a list of regexs for common data types, and return a placeholder for that datatype if found
    """
    #liases['PORT']="\d{1,5}"
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
 
    def __init__(self,NodeContent="Not Provided"):
        self.Children = []
        self.Content = NodeContent
        #print "Created new Node " + str(id(self)) + " with content : " + self.Content      
        
    
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
                if (child.Content == MatchContent):
                    #print "Found Child Match : " + child.Content
                    return child
                else:
                    return None
              

    def MatchNephew(self,MatchContent):
        """Find Nephew Match"""
        if self.Parent == None: #This node is the root node
            return None
        for sibling in self.Parent.Children:
            if len(sibling.Children) > 0 :  # no point if we don't have any siblings
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
    
    def PrintPath(self):
        currentNode = self
        parentpath = ""
        while currentNode.Content != "ROOTNODE":
            if len(currentNode.Parent.Children) > self.VarThreshold:
                parentpath = "[VARIABLE]" + " " + parentpath
            else:
                parentpath = currentNode.Content + " " + parentpath
            currentNode = currentNode.Parent
        print parentpath




class ClusterGroup(object):
    """
    A Group of word rootcluster
    """

    rootNode = ClusterNode(NodeContent="ROOTNODE")
        
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


    def BuildLogLine(self,Node):
        if (len(Node.Children) == 0): #I have loads of siblings- I'm a variable at the end of a line       
            Node.PrintPath()
            return True
        return False    
        
        
        #if (len(Node.Parent.Children) > 5) & (Node.Children == 0): #I have loads of siblings- I'm a variable at the end of a line       
        #    Node.PrintPath()
        #    return False
        #if (len(Node.Parent.Children) > 5) & (Node.Children > 0): #lots of siblings, but I have more data
        #    Node.PrintPath()
        #    return False
        #if (len(Node.Parent.Children) < 5) & (Node.Children == 0): #this is the end of a log line
        #    Node.PrintPath()
        #    return True       
        #return True #Hey, I'm probably good
        
    
    def Results(self):
        print "RESULTS"
        for node1 in self.rootNode.Children:
            for node2 in node1.Children:
                if self.BuildLogLine(node2)== True : break 
                
                for node3 in node2.Children:
                    if self.BuildLogLine(node3) == True : break 
            
                    for node4 in node3.Children:
                        if self.BuildLogLine(node4) == True : break 
            
                        for node5 in node4.Children:
                            if self.BuildLogLine(node5) == True : break 
                            
                            for node6 in node5.Children:
                                if self.BuildLogLine(node6) == True : break 
            
                                for node7 in node6.Children:
                                    if self.BuildLogLine(node7) == True : break 
            
                                    for node8 in node7.Children:
                                        if self.BuildLogLine(node8) == True : break 
                
                                        for node9 in node8.Children:
                                            if self.BuildLogLine(node9) == True : break 
                    
                                            for node10 in node9.Children:
                                                if self.BuildLogLine(node10) == True : break 
                        
                                                for node11 in node10.Children:
                                                    if self.BuildLogLine(node11) == True : break 

