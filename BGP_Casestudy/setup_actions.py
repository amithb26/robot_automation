import pexpect
import getdata
import time
import execute

class setup_actions:

	def connect_all(self):

		device_data = getdata.get_data()									
		devices = device_data["Device_Details"] 
		for keys in devices.keys():

			child = pexpect.spawn('telnet ' + devices[keys]['ip_add'] + ' ' + devices[keys]['port'])
			child.sendline('\n')
			child.sendcontrol('m')
			hostname = devices[keys]['Hostname']
 			flag = (child.expect(['Would','Router',hostname,pexpect.EOF,pexpect.TIMEOUT],timeout=100))
			if flag == 0:
				time.sleep(35)
				print 'Telnet connection established with device '+keys
				print 'Device %s is booting' % keys
				child.send('no')
				child.sendcontrol('m')
				time.sleep(15)
				child.sendcontrol('m')
				flag = 1
			
			if (flag == 1 or flag == 2):
				time.sleep(35)
				print "Device %s in user mode" % keys
				child.expect(['Router',hostname+'#',pexpect.EOF,pexpect.TIMEOUT],timeout=40)
				child.sendcontrol('m')
				self._enable_pwd(child,keys,devices)
			
			if flag == 3:
				print 'Unable to connect to remote host %s:Connection refused' % keys

			if flag == 4:
				print 'Telnet connection established with device '+keys				
				print 'Timeout, no expected prompt found' 
	
		return



	def _enable_pwd(self,child,keys,devices):

		child.sendcontrol('m')
		time.sleep(10)
		child.sendcontrol('m')
		hostname = devices[keys]['Hostname']
		flag = child.expect([hostname+'>',hostname+'#','Router',pexpect.EOF,pexpect.TIMEOUT],timeout=80)
		print flag

		if (flag == 0 or flag == 1):
			print 'Hostname set'
			flag=2

		if flag == 2:
			child.sendcontrol('m')
			child.send('enable')
			child.sendcontrol('m')
			child.sendcontrol('m')
			pwd = child.expect(['Password',pexpect.EOF,pexpect.TIMEOUT],timeout=50)

			if pwd != 0:
				print 'Setting the password and hostname'
				configs = """
				configure terminal
				hostname %s 
				enable password %s
				exit
				exit
				""" % (hostname,devices[keys]['pwd'])
				commands = configs.split('\n')
				execute.execute(child,commands)
				child.sendcontrol('m')
				child.sendcontrol('m')
				time.sleep(10)
				print "Hostname and Password set for %s" % keys
		
			if pwd == 0:
				child.send('\n')
				child.send('\n')
				child.sendline('\n')
				child.sendcontrol('m')
				print "Password already set"
				child.sendcontrol('m')
				child.sendcontrol('m')
				child.sendcontrol('m')
				child.sendcontrol('m')
		else:
			print 'EOF or Timeout reached,no expected prompt found'

		return

	
#setup = setup_actions()
#setup.connect_all()
