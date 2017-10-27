from manual_action_operations import ManualActionOperations
import version

class ManualActionLibrary(ManualActionOperations):
	"""
	Robot Framework Library for manual actions
	"""
	
	ROBOT_LIBRARY_SCOPE = 'GLOBAL'
	ROBOT_LIBRARY_VERSION = version.VERSION
	
	pass