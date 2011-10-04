#!/usr/bin/env python
# encoding: utf-8
"""
payloads.py

Created by Jaime Blasco on 2011-10-04.
Copyright (c) 2011 Alienvault Labs. All rights reserved.
"""

#./msfrpcd -P test -U test -S -t Web
#http://dev.metasploit.com/redmine/projects/framework/wiki/XMLRPC

import xmlrpclib
import sys
import time
import os
import stat
import subprocess
import threading
import libemu
import commands

PAYLOAD_EXE="/home/jaime/trunk/msfpayload"

class MsfBase:
	def __init__(self):
		self.proxy=""
		self.token=""
		self.console_id=""

	def login(self,username,password):
		try:
			self.proxy = xmlrpclib.ServerProxy("http://localhost:55553")
		
			ret = self.proxy.auth.login(username,password)
			if ret['result'] == 'success':
				self.token = ret['token']
				print self.token
			else:
				print "Could not login\n"
				sys.exit(10)
		except Exception:
			print "Could not login: exception\n"
			sys.exit(0)
	
	def getPayloads(self):
		ret = self.proxy.module.payloads(self.token)
		try:
			return ret["modules"]
		except:
			return None

	def getModuleOptions(self, type, name):
		ret = self.proxy.module.options(self.token, type, name)
		try:
			return ret
		except:
			return None
			

conn = MsfBase()
conn.login("test","test")

f = open("detected.csv", "w+")

payloads = conn.getPayloads()
for p in payloads:
	opts = {}
	#print p
	options = conn.getModuleOptions("payloads",p)
	valid = True
	for o in options.keys():
		if options[o]["required"]:
			if "default" not in options[o]:
				#print "%s required" % o
				if options[o] == "LHOST":
					opts["LHOST"] = "192.168.1.1"
				elif options[o] == "CMD":
					opts["CMD"] = "ls"
				else:
					valid = False
	if valid:
		params = ""
		for o in opts.keys():
			params = params + "%s=%s " % (o, opts[o])
		#print ("%s %s %s R" % (PAYLOAD_EXE, params, p))
		data = commands.getstatusoutput("%s %s %s R" % (PAYLOAD_EXE, params, p))[1]
		emulator = libemu.Emulator()
		res = emulator.test(data)
		if res:
			f.write("%s,%d\n" % (p, res))

f.close()

