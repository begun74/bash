#!/usr/bin/python
import requests,sys
from lxml import html

#urlIN = 'http://172.16.145.90/index.html'

args = sys.argv

'''
    Pattern  10531077109032108910861086107310971077108510801081
'''
signal = '10531077109032108910861086107310971077108510801081'

def function_exit():
    print 0
    sys.exit('Usage : komfoventStatus.py <url> <username> <password>')

if len(args) <4:
    function_exit()
else:
    urlIN    = args[1]
    username = args[2]
    password = args[3]

post_fields = {'LOGINU': username,'LOGINP':password}

try:
    req = requests.post(urlIN, post_fields)
    req.encoding = 'cp1251'

except (requests.exceptions.ConnectionError,requests.exceptions.MissingSchema, requests.exceptions.InvalidSchema):
    print("Enter correct URL.")
    print 0
    sys.exit(1)

#file = open('komfoventStatus.html', 'w',encoding="cp1251")
try:
    str = req.text
    #file.write(str)
    tree = html.fromstring(str)
    div_ta = tree.xpath('//div[@id = "ta"]')[0]

    #print(hash(div_ta.text))
    str = div_ta.text
    str = str.strip()
    result = ''
    for x in str:
        result += format(ord(x))

    if (signal != result):
        print 0
        sys.exit(1)

    #print(result)
    print 1
    sys.exit(0)
except (IndexError):
    print 0
    sys.exit(1)


#finally:
#    file.close()


