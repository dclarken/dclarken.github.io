========================================================================================================================================
#get请求
import urllib2
import json

def geturl():
	url="http://www.baidu.com"
	print(url)
	request = urllib2.Request(url)
	try:
		response = urllib2.urlopen(request)
		print (response)
	except:
		raise Exception("error")
		print (response)
	raw_data = response.read()
	data = json.loads(raw_data)
	print(json.dumps(data))
	return data
	
if __name__ == "__main__":
	geturl()
========================================================================================================================================
