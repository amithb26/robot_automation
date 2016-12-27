from Device import Device

class device:
	def __init__(self):
		self._device = Device()
		

	def set_IP(self,Device,Links,Action):
		self._result = self._device.set_IP(Device,Links,Action)
		return (self._result)

	def set_loopback(self,Device,Action):
		self._result1 = self._device.set_loopback(Device,Action)
		return (self._result1)


	def Configure_ospf(self,Device,Process_id,Networks_connected,Area,Action):
		self._result2 = self._device.Configure_ospf(Device,Process_id,Networks_connected,Area,Action)
		return (self._result2)
	

	


