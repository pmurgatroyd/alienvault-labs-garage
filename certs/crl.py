import csv
import sys
import re

'''
select distinct(`X509v3 extensions:X509v3 CRL Distribution Points`) as name ,count(*) as total INTO OUTFILE '/tmp/crls.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' from all_certs group by name order by total desc;
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
	if num > 100:
		urls = r[0]
		res = re.findall(r'https?://(?P<domain>[^/]+)/', urls)
		#print urls
		for r in res:
			data.append(r)
                res = re.findall(r'ldap://(?P<domain>[^/]+)', urls)
                #print urls
                for r in res:
			data.append(r)

for r in data:
	print r

