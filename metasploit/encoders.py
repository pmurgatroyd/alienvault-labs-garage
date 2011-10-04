#!/usr/bin/env python
# encoding: utf-8
"""
payloads.py

Created by Jaime Blasco on 2011-10-04.
Copyright (c) 2011 Alienvault Labs. All rights reserved.
"""

import libemu
import commands
import os

encoders = ["x64/xor", "x86/alpha_mixed", "x86/alpha_upper","x86/avoid_utf8_tolower","x86/call4_dword_xor","x86/context_cpuid","x86/context_stat","x86/context_time","x86/countdown","x86/fnstenv_mov","x86/jmp_call_additive","x86/nonalpha","x86/nonupper","x86/shikata_ga_nai", "x86/single_static_bit","x86/unicode_mixed","x86/unicode_upper"]

PAYLOAD_EXE="/home/jaime/trunk/msfpayload"
ENCODER_EXE="/home/jaime/trunk/msfencode"
payload="windows/x64/meterpreter/bind_tcp"
tmp_payload="/tmp/payload"

results = open("results.csv","w")
for e in encoders:
	#./msfpayload windows/x64/meterpreter/bind_tcp R|./msfencode -e x64/xor -t raw -o tmp_payload
	cmd = "%s %s R|%s -e %s -t raw -o %s" % (PAYLOAD_EXE, payload, ENCODER_EXE, e, tmp_payload)
	os.system("rm /tmp/payload")
	os.system(cmd)
	try:
		f = open(tmp_payload, "r")
	except IOError:
		continue
	data = f.read()
	f.close()
	emulator = libemu.Emulator()
	res = emulator.test(data)
	print res
	if res:
		results.write("%s,%d\n" % (e, res))

results.close()

'''
x64/xor,no detected
x86/alpha_mixed,no detected
x86/alpha_upper
x86/avoid_utf8_tolower
x86/call4_dword_xor,0
x86/context_cpuid,0
x86/context_stat,0
x86/context_time,-4657153
x86/countdown,0
x86/fnstenv_mov,0
x86/jmp_call_additive,1
x86/nonalpha,-4657153
x86/shikata_ga_nai,-4657153
x86/single_static_bit,-4657153
'''

