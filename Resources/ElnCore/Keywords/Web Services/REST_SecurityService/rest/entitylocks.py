############################################################################
#
# Copyright (C) 1993-2011 ID Business Solutions Limited
# All rights reserved
# 
# entitylocks.py
#
############################################################################

from restclient import RestClient

# Root url for lock service
ENTITY_LOCK_ROOT = "locks/entities/"

class EntityLockClient(RestClient):
    """
    A REST client for the entity lock service
    """
    
    def is_entity_locked(self, entity_id, include_children=False):
        """
        Returns a value indicating whether the entity is locked.
        
        @param include_children When true, child entities will also be tested for locks.
        """
        
        endpoint = "locks/entities/%s/islocked" % (entity_id)
        if include_children: endpoint += "?includeChildren=true"
        
        return self._get(endpoint)
    
    def lock_entity(self, entity_id):
        """
        Adds a lock to an entity.
        
        @param entity_id The id of the entity to lock.
        
        @returns A lock response indicator, containing one of OK | RESOURCE_LOCKED | RESOURCE_LOCKED_BY_USER
        """
        endpoint = "locks/entities/%s/lock" % (entity_id)
        return self._put(endpoint)
    
    def unlock_entity(self, entity_id):
        """
        Unlocks an entity.
        
        @param entity_id The id of the enitty to unlock
        """
        endpoint = "locks/entities/%s/lock" % (entity_id)
        self._delete(endpoint)
        
    def get_lock_info(self, entity_id):
        """
        
        Returns lock information for the given entity.
        
        @param entity_id The id of the entity to retrieve lock information for.
        
        """
        endpoint = "locks/entities/%s/find" % (entity_id)
        return self._get(endpoint)