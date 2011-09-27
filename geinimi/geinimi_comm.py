import socket
import sys

HOST = sys.argv[1]
PORT = int(sys.argv[2])
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST, PORT))
s.send('hi,are you online?')
data = s.recv(1024)
print 'Received', repr(data)
b = "\x70\x00"
print "Sending %s" % repr(b)
s.send(b)
data = s.recv(1024)
print 'Received', repr(data)
data = s.recv(1024)
print 'Received', repr(data)
s.close()
