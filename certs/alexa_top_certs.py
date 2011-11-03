import socket, ssl, pprint
from M2Crypto import X509
import multiprocessing
import fileinput
import socket
import re
import sys

socket.setdefaulttimeout(7)

cert_dir = "./certs/"
num_threads = 10
alexa_file="top-1m.csv"

reg = re.compile("\s+URI:(?P<url>.*)")
reg1 = re.compile("OCSP - URI:(?P<url>.*)")

def get_pem(host):
	#print host
	return ssl.get_server_certificate((host, 443))
	#print pprint.pformat(cert_pem)

def get_der(cert_pem):
	return ssl.PEM_cert_to_DER_cert(cert_pem)
	#print pprint.pformat(cert_der)
	
def get_x509(cert_pem):
	x509 = X509.load_cert_string(cert_pem, X509.FORMAT_PEM)
	return x509

def process(dom):
	get_pem(dom)
	return

def save_cert(data, dom):
	f = open("%s/%s.pem" % (cert_dir, dom), "w+")
	f.write(data)
	f.close()

#print x509.get_ext('crlDistributionPoints').get_value()
#print x509.get_ext('authorityInfoAccess').get_value()

for domain in fileinput.input(alexa_file):
	dom = domain.split(',')[1].rstrip()
	try:
		cert = get_pem(dom)
		#save_cert(cert, dom)
		x509 = get_x509(cert)
		crl = x509.get_ext('crlDistributionPoints').get_value()
		for line in crl.split("\n"):
			m = reg.match(line)
			if m:
				print m.group(1)				

		#OCSP - URI:
		ocsp = x509.get_ext('authorityInfoAccess').get_value()
		for line in ocsp.split("\n"):
                        m = reg1.match(line)
                        if m:
                                print m.group(1)
				
	except socket.error:
		continue
	except LookupError:
		continue
	except KeyboardInterrupt:
		sys.exit(1)
	except:
		continue


