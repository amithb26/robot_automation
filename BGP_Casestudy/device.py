from Devices import Devices
from IBGP import IBGP
from OSPF import OSPF

class device:
	def __init__(self):
		self._device = Devices()
		

	def set_IP(self,Device,Links,Action):
		self._result = self._device.set_IP(Device,Links,Action)
		return (self._result)

	def set_loopback(self,Device,Action):
		self._result1 = self._device.set_loopback(Device,Action)
		return (self._result1)

	

	
class ibgp:
	
	def __init__(self):
		self._ibgp = IBGP()
		
	
	def Configure_IBGP(self,Device,AS_id,Interface):
		self._result3 = self._ibgp.Configure_IBGP(Device,AS_id,Interface)
		return (self._result3)


	def enable_syn(self,Device,AS_id):
		self._result4 = self._ibgp.enable_syn(Device,AS_id)
		return (self._result4)

class ospf:
	
	def __init__(self):
		self._ospf = self._OSPF()

	def Configure_ospf(self,Device,Process_id,Networks_connected,Area,Action):
		self._result5 = self._ospf.Configure_ospf(Device,Process_id,Networks_connected,Area,Action)
		return (self._result5)
		
	
	



