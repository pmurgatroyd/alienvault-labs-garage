import sys
import re
from pyDes import *
import binascii

key = "\x01\x02\x03\x04\x05\x06\x07\x08"
aReg = re.compile("0x([0-9a-f]+)t", re.DOTALL|re.MULTILINE)
dReg = re.compile("\.array-data[^\n]+([^\.]+)", re.DOTALL|re.MULTILINE)

def decrypt(data):
	k = des(key)
	print  k.decrypt(data)
	
def buildString(data):
	enc = ""
	m = aReg.findall(data)
	if m:
		for c in m:
			if len(c) == 2:
				enc = enc + "%s" % c
				
			else:
				enc = enc + "0%s" % c
	#print enc[0:len(enc)-1]
	enc = binascii.unhexlify(enc) 
	decrypt(enc)
	
	
f = open(sys.argv[1])
data = f.read()
m = dReg.findall(data)
if m:
	for d in m:
		buildString(d)

