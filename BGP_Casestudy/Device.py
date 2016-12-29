import pexpect
import getdata
import time
import execute
import sys


class Device:

	def connect(self,Device):

		device_data = getdata.get_data()
		IP_add = device_data['Device_Details'][Device]['ip_add']
		Port_no = device_data['Device_Details'][Device]['port']
		Password = device_data['Device_Details'][Device]['pwd']	
		hostname = device_data['Device_Details'][Device]['Hostname']
		child = pexpect.spawn('telnet ' + IP_add + ' ' + Port_no)
		child.sendline('\n')
		child.sendcontrol('m')
		child.sendcontrol('m')
		#self.flushBuffer(5,child)
		child.sendcontrol('m')
		child.sendcontrol('m')
		flag = child.expect(['Router>','Router#',hostname+'>',hostname+'#',pexpect.EOF,pexpect.TIMEOUT],timeout=90)
		print 'flag=%d' % flag

		if (flag == 0 or flag == 1  or flag == 2  or flag == 3):
		        #time.sleep(35)
			print 'Connection established with %s' % Device
			self.Login(Device,child)

		if flag == 4:
			print 'Unable to connect to remote host %s:Connection refused' %Device
			return False

		if flag == 5:
			print 'Timeout. Trying to connect again'
			self.connect(Device)

		return child
		
	def Login(self,Device,child):
			
		child.sendcontrol('m')
		device_data = getdata.get_data()
		hostname = device_data['Device_Details'][Device]['Hostname']
		Password = device_data['Device_Details'][Device]['pwd']
		self.flushBuffer(5,child)
		child.sendcontrol('m')
		child.sendcontrol('m')
		child.sendcontrol('m')
		flag = child.expect(['Router>','Router#',hostname+'>',hostname+'#',pexpect.EOF,pexpect.TIMEOUT],timeout=100)
		print 'flag=%d' % flag

		if flag == 0 or flag == 2:
			#child.sendcontrol('m')
			#child.sendcontrol('m')
			child.send('enable')
			child.sendcontrol('m')
			
			child.send(Password)
			child.sendcontrol('m')
			time.sleep(90)
			self.flushBuffer(5,child)
			child.sendcontrol('m')
			child.sendcontrol('m')
			child.sendcontrol('m')
			flag1 = child.expect([hostname+'>',hostname+'#','Router#',pexpect.EOF,pexpect.TIMEOUT],timeout=60)
			print 'flag1=%s' %flag1

			if flag1 == 1 or flag1 == 2:
                		print "Successful login to a device"
				print "Device, now in priveleged mode"
				
			if flag1 == 0:
				print "pwd not sent"
				self.Login(Device,child)

			if flag1 ==3 or flag1 == 4:
				print "Eof or Timeout"



		if flag == 1 or flag == 3:
			print "You are already logged in"

	        if flag == 4 or flag == 5:
			print "Device in expecting password prompt"	

		return


	def set_IP(self,Device,Links,Action):
		
		child = self.connect(Device)

		if (child):
			device_data = getdata.get_data()
			hostname = device_data['Device_Details'][Device]['Hostname']
			self.flushBuffer(5,child)
			child.sendcontrol('m')
			child.sendcontrol('m')
			child.sendcontrol('m')
			flag = child.expect([hostname+'>',hostname+'#','Router\>','Router\#',pexpect.EOF,pexpect.TIMEOUT],timeout=90)		
			print 'flag=%d' % flag

			if (flag == 4 or flag == 5):
				print "Expected prompt not present"
				time.sleep(5)
				child.sendcontrol('m')
		
			if (flag == 0 or flag == 2):
				self.Login(Device,child)
				time.sleep(35)
				flag=1


			if (flag == 1 or flag == 3):

				if Action == 'configure':

					if (isinstance(Links,list)):

						for Lnk in Links:

							interface = device_data['Link_Details'][Lnk][Device]
							interface_add = device_data['Device_Details'][Device][interface]
							configs = """	
							configure terminal
							interface %s
							ip address %s 
							no shutdown				
							exit
							exit
							""" % (interface,interface_add)
							commands = configs.split('\n')
							execute.execute(child,commands)
							time.sleep(10)
						        child.sendcontrol('m')
							print "IP address of  %s interface of device %s  set" % (interface,Device)
					        child.sendline('exit')
					        child.sendcontrol('m')
					else:
						interface = device_data['Link_Details'][Lnk][Device]
						interface_add = device_data['Device_Details'][Device][interface]
						configs = """ 	
						configure terminal
						interface %s
						ip address %s 
						no shutdown					
						exit
						exit
						""" % (interface,interface_add)
						commands = configs.split('\n')
						execute.execute(child,commands)
						time.sleep(6)
						child.sendcontrol('m')
						print "IP address of  %s interface of device %s  set" % (interface,Device)
						child.sendline('exit')
					        child.sendcontrol('m')
					
				else:
					if (isinstance(Links,list)):

						for Link in Links:

							interface = device_data['Link_Details'][Link][Device]
							interface_add = device_data['Device_Details'][Device][interface]
							unconfig = """ 	
							configure terminal
							interface %s
							no ip address %s 
							shutdown					
							exit
							exit
							""" % (interface,interface_add)
							commands = unconfig.split('\n')
							execute.execute(child,commands)
							time.sleep(40)
							child.sendcontrol('m')
							print "IP address of  %s interface of device %s  unset" % (interface,Device)
						
					else:
						interface = device_data['Link_Details'][Link][Device]
						interface_add = device_data['Device_Details'][Device][interface]
						unconfig = """ 	
						configure terminal
						interface %s
						no ip address %s 
						shutdown					
						exit
						exit
						""" % (interface,interface_add)
						commands = unconfig.split('\n')
						execute.execute(child,commands)
						time.sleep(50)
						child.sendcontrol('m')
						print "IP address of  %s interface of device %s  unset" % (interface,Device)
						
			return True
		else:	
			
			print 'Device is OFF'	
			return False
	
	def set_loopback(self,Device,Action):

		device_data = getdata.get_data()
		hostname = device_data['Device_Details'][Device]['Hostname']
		ip_add = device_data['Device_Details'][Device]["ip_add"]
		child = self.connect(Device)
		if child != False:
			self.flushBuffer(5,child)
			child.sendcontrol('m')
			child.sendcontrol('m')
			child.sendcontrol('m')
			child.expect([hostname+'\#',pexpect.EOF,pexpect.TIMEOUT],timeout=50)
			child.sendcontrol('m')
			LO_interface_add = device_data['Device_Details'][Device]['lo']
			if Action == 'set':
			
				configs = """
					configure terminal
					interface %s
					ip address %s 
					no shutdown					
					exit
					exit
					exit
					""" % ('loopback0',LO_interface_add)
				commands = configs.split('\n')
				execute.execute(child,commands)
				time.sleep(40)
				child.sendcontrol('m')
				print "IP address of  loopback interface of device %s  set" % (Device)
				
			else:
				unconfig = """ 	
					configure terminal
					interface %s
					no ip address 
					shutdown					
					exit
					exit
					exit
					""" % ('lo')
				commands = unconfig.split('\n')
				execute.execute(child,commands)
				time.sleep(40)
				child.sendcontrol('m')
				child.sendcontrol('m')
				
 			return True
		else:
			return False




	def Configure_ospf(self,Device,process_id,Networks_connected,Area,Action):

		device_data = getdata.get_data()
		hostname = device_data['Device_Details'][Device]['Hostname']
		#time.sleep(50)
		#flag = child.expect([hostname+'>','Router\>',pexpect.EOF,pexpect.TIMEOUT],timeout=90)
		#print 'flag(ospf) = %s' %flag
		child = self.connect(Device)

		if (child):

			self.flushBuffer(10,child)
			child.sendcontrol('m')
			child.sendcontrol('m')
			child.sendcontrol('m')
			time.sleep(20)
			flag = child.expect([hostname+'>',hostname+'#','Router\>','Router\#',pexpect.EOF,pexpect.TIMEOUT],timeout=90)
			print 'flag =%d' % flag
			if flag==0 or flag==2:
				self.Login(Device,child)
				if Action == 'enable':
					if (isinstance(Networks_connected,list)):
						for NID in Networks_connected:
								print NID
								configs = """
					 			enable
								configure terminal
								router ospf %s
								network %s area %s 
								exit
								exit
								""" % (process_id,NID,Area)
								commands = configs.split('\n')
								execute.execute(child,commands)
								time.sleep(6)
								child.sendcontrol('m')
								print "%s advertises 'I AM CONNECTED TO %s NETWORK'" % (Device,NID)
								time.sleep(30)
						child.sendline('exit')
						child.sendcontrol('m')
						print "OSPF enabled & neighbors set in %s" % Device
					else:
						NID = Networks_connected
						configs = """
						enable
						configure terminal
						router ospf %s
						network %s area %s
						exit
						exit
						exit 
						""" % (process_id,NID,Area)
						commands = configs.split('\n')
						execute.execute(child,commands)
						time.sleep(15)
						child.sendcontrol('m')
						print '%s advertises I AM CONNECTED TO %s NETWORK' % (Device,NID)
						print "OSPF enabled & neighbors set in %s" % Device

				else:
					unconfig = """
					enable
					configure terminal
					router ospf %s
					no network %s area %s
					exit
					exit
					exit 
					""" % (process_id,NID,Area)
					commands = configs.split('\n')
					execute.execute(child,commands)
					time.sleep(15)
					child.sendcontrol('m')
					print "OSPF disabled  and neighbors unset in %s" % Device
			

		
			if flag == 1 or flag == 3:
				if Action == 'enable':
					if (isinstance(Networks_connected,list)):
						for NID in Networks_connected:
								print NID
								configs = """
					 			enable
								configure terminal
								router ospf %s
								network %s area %s 
								exit
								exit
								""" % (process_id,NID,Area)
								commands = configs.split('\n')
								execute.execute(child,commands)
								time.sleep(6)
								child.sendcontrol('m')
								print "%s advertises 'I AM CONNECTED TO %s NETWORK'" % (Device,NID)
								time.sleep(30)
						child.sendline('exit')
						child.sendcontrol('m')
						print "OSPF enabled & neighbors set in %s" % Device
					else:
						NID = Networks_connected
						configs = """
						enable
						configure terminal
						router ospf %s
						network %s area %s
						exit
						exit
						exit 
						""" % (process_id,NID,Area)
						commands = configs.split('\n')
						execute.execute(child,commands)
						time.sleep(15)
						child.sendcontrol('m')
						print '%s advertises I AM CONNECTED TO %s NETWORK' % (Device,NID)
						print "OSPF enabled & neighbors set in %s" % Device

				else:
					unconfig = """
					enable
					configure terminal
					router ospf %s
					no network %s area %s
					exit
					exit
					exit 
					""" % (process_id,NID,Area)
					commands = configs.split('\n')
					execute.execute(child,commands)
					time.sleep(15)
					child.sendcontrol('m')
					print "OSPF disabled  and neighbors unset in %s" % Device
			

		
			else:
				print 'Expected prompt not found'

		        return True
		
		else:
			return False


				
	def flushBuffer(self,delay,child):
		try:# Greedily read in all the incoming characters
			child.expect("ZzqQJjSh_Impossible_String", timeout = delay)
		except pexpect.TIMEOUT:
			pass
		# Clear local input buffer inside the spawn Class
		child.buffer = child.string_type()
		return child


	

		


		
dev =  Device()
#dev.set_IP('R1',["Link_R1_R2_1","Link_R1_R3_1"],'configure')
#dev.set_IP('R2',["Link_R1_R2_1","Link_R2_R4_1"],'configure')
#dev.set_loopback('R1','set')
#dev.set_loopback('R2','set')
#dev.configure_ospf('R1',1,["192.168.23.0  0.0.0.255","192.168.34.0  0.0.0.255", "3.3.3.0  0.0.0.255"],0,'enable')
#dev.configure_ospf('R2',1,["192.168.23.0  0.0.0.255","2.2.2.0  0.0.0.255"],0,'enable')

