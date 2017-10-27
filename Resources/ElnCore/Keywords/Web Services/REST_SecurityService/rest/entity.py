############################################################################
#
# Copyright (C) 1993-2011 ID Business Solutions Limited
# All rights reserved
# 
# entity.py
#
############################################################################

from restclient import RestClient
from urllib import urlencode

ENTITY_ROOT = "entities/"

class EntityClient(RestClient):
    """
    Represents a client for the entity rest service
    """

    def _construct_include_options(self, options):
        """
        Constructs the include options used for reterieval of additional information about the entity.
        """

        optFunc = lambda x: 'include' + x[0].upper() + x[1:]
        optDict = dict([(optFunc(opt), True) for opt in options])
        return urlencode(optDict)

    def get_entity(self, entity_id, version_id="", options=None):
        """
        Returns an entity based on its identifier, and optional its version.

        If supplied, options should be a list of additional features to be returned for the entity.  This list can 
        have the following values:

        tags        : Includes any tags associated to the entity
        comments    : Includes any comments associated to the entity
        attributes  : Includes any attributes associated to the entity
        versionInfo : Includes version information
        signatures    : Includes signature information for the entity
        dataInfo    : Includes data information for the entity
        children    : Includes information about the child entities
        permissions    : Includes permissions for the entity
        """

        arguments = "entityVersionId=" + version_id + arguments if len(version_id) else ""

        optFunc = lambda x: 'include' + x[0].upper() + x[1:]

        arguments = self._construct_include_options(options)
        
        rel_path = ENTITY_ROOT + entity_id

        if arguments:
            if arguments[0] == "&":
                arguments = arguments[1:]
            rel_path += "?" + arguments

        return self._get(rel_path)

    def delete_entity(self, entity_id, reason, additional_reason=""):
        """
        Deletes an entity on the server
        """

        rel_path = ENTITY_ROOT + entity_id
        args = {
            'comment' : reason,
            'additionalComment' : additional_reason
        }
        
        self._delete(self.create_querystring(rel_path, args))

    def get_entities_by_tag(self, tag_value, start = 0, limit = 20, options=None):
        """
        Returns a list of entities that have been tagged with the given value.

        This method supports pagination via the following parameters:

        start        : The starting index of the page to retrieve
        limit        : The number of entities to fetch.

        If supplied, options should be a list of additional features to be returned for the entity.  This list can 
        have the following values:

        tags        : Includes any tags associated to the entity
        comments    : Includes any comments associated to the entity
        attributes    : Includes any attributes associated to the entity
        versionInfo    : Includes version information
        signatures    : Includes signature information for the entity
        dataInfo    : Includes data information for the entity
        children    : Includes information about the child entities
        permissions    : Includes permissions for the entity
        """

        arguments = "tagValue=" + tag_value
        arguments += "&start=" + str(start)
        arguments += "&limit=" + str(limit)
        arguments += "&" + self._construct_include_options(options)
        rel_path = ENTITY_ROOT + "bytag?" + arguments

        return self._get(rel_path)

    def get_allowed_types(self, parent_entity_id):
        """
        Returns a list of the entity types permitted underneath the given entity in the hierarchy.

        parent_entity_id: The id of the parent.
        """
        
        rel_path = ENTITY_ROOT+ "%s/allowedTypes" % (parent_entity_id)
        response = self._get(rel_path)
        return response.entityTypeName