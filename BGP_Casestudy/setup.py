from setup_actions import setup_actions

class setup:
	def __init__(self):
		self._setup = setup_actions()
		

	def connect_all(self):
		self._result = self._setup.connect_all()

	



