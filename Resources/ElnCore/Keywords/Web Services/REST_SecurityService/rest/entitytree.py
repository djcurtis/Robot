############################################################################
#
# Copyright (C) 1993-2011 ID Business Solutions Limited
# All rights reserved
# 
# entitytree.py
#
############################################################################

from restclient import RestClient

class EntityTreeClient(RestClient):
	"""
	Represents a client to the entity tree rest service.
	"""
    
	def get_roots(self):
		"""
		Returns the root entities defined in the system.
		"""
        
		response = self._get('entitytree')
		return response.entity

	def get_children(self, parent_id):
		"""
		Returns the child entities associated to the given parent id.
		"""
        
		response = self._get('entitytree/' + parent_id)
		return response.entity