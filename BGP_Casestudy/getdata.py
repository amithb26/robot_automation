import json

def get_data():
   	with open('pr2.json') as data_file:    
 		data = json.load(data_file)
   	return data
