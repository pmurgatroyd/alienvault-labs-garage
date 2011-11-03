import csv
import sys
import re

'''
select `X509v3 extensions:Authority Information Access:OCSP - URI` as ocsp,count(*) as total INTO OUTFILE '/tmp/ocsp.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' from all_certs where `X509v3 extensions:Authority Information Access:OCSP - URI` is not NULL  group by ocsp order by total desc;

'''

csv.register_dialect('dial', delimiter=',', quotechar
='"')
with open(sys.argv[1], 'rb') as f:
    reader = csv.reader(f, 'dial')
    data = []
    for r in reader:
    	num = 0
	try:
		num = int(r[1])
     	except:
		pass
	if num > 20:
		urls = r[0]
		res = re.findall(r'https?://(?P<domain>[^/]+)/', urls)
		#print urls
		for r in res:
			data.append(r)
for r in data:
	print r

