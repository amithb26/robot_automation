import pexpect
import time
import json
import getdata




class teardown:
 

 def disable_pwd(session,Device_name):
	
		child = session
		Device = Device_name
	        data = getdata.get_data()
 			obj = data[Device]
			pwd = obj['pwd']
			print 'Disabling the configuration'
			child.sendline('')
			child.sendcontrol('m')
			disconf="""
			configure terminal
			no enable password
			exit
			exit
			""" 
		commands = disconf.split('\n')
		print commands
		execute.execute(commands)
		return
			

teardwn = teardown()

