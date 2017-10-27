############################################################################
#
# Copyright (C) 1993-2011 ID Business Solutions Limited
# All rights reserved
# 
# restclient.py
#
############################################################################

import json
import urllib2, urllib
from config import settings

class __JsonWrapper__(object):
    
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    
    """
    This class acts as a wrapper around a json response returned from the server.
    
    It enables json attributes to be accessed by their name, rather than the dictionary
    notation typical of json.load.  This is done by handling the magic method __getattr__
    and returning either the underlying value type addressed by that attribute, or
    the underlying type wrapped as a new instance of the __JsonWrapper__ class.
    
    An attempt is made to make this class appear the same as the type it wraps.  If for
    example the underlying type is an array, it's length can be tested using len() and
    items can be indexed in the expected manor.
    
    str() will also try and return something useful by converting the underlying wrapped type
    back into a json string.
    """
    
    def __init__(self, json_obj):
        """
        Initialises a new instance of the wrapper
        """
        
        # edge case test for plain booleans mascerading as strings
        if type(json_obj) == str and json_obj in ('true', 'false'):
            json_obj = (json_obj == 'true')
        
        self.json_obj = json_obj
        self.value_types = [int, float, str, long, bool, unicode]
    
    def _get_value(self, val):
        """
        Attempts to return the underlying value that this class wraps.  The wrapped type is returned directly
        if it is known to be a value type, as defined by self.value_types.
        
        In all other cases, a new __JsonWrapper__ is returned, enabling further calls on the underlying value
        to be wrapped further.
        """
        
        if type(val) in self.value_types:            
            return val
        else:
            return __JsonWrapper__(val)

    def __len__(self):
        """
        Attempts to provide length functionality over the wrapped type.  If the underlying type is a bool,
        the value of the type is returned instead of delegating to the __len__ implementation on the type.
        
        The python docs state that __len__ can return False for boolean types and uses this in some way
        to determine the truthiness of the object.  TODO: look into whether __nonzero__ gives better 
        truth results
        """
        
        if type(self.json_obj) == bool:
            return self.json_obj
        return len(self.json_obj)
    
    def __getitem__(self, x):
        """
        Attempts to return either the underlying value of an attribute, or a wrapped version, as defined by the
        _get_value method
        """
        
        return self._get_value(self.json_obj[x])

    def __getattr__(self, attr_name):
        """
        The main magic method used to query the underlying wrapped value for a named attribute.
        
        Special consideration is made for wrapped dictionaries, where the value is accessed using index notation.
        Some support is also provided for callable attributes too here.
        """
        
        if type(self.json_obj) == dict:
            return self._get_value(self.json_obj[attr_name])

        if hasattr(self.json_obj, attr_name):
            attr = getattr(self.json_obj, attr_name)
            if callable(attr):
                return attr
            else:
                return self._get_value(val)
        
        raise KeyError("JSON object does not support attribute '%s'" % (attr_name))

    def __str__(self):
        """
        Enables a string representation to be made of this instance by simply converting the
        wrapped object back into a json string.
        """
        
        return json.dumps(self.json_obj)

class RestClient(object):
    
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    
    """
    Provides the basic functionality for each REST client.
    """    

    def __init__(self, base_address, username, password, headers=None):
        """
        Initialises the instance with information defined in the settings object
        """
        # Sets the password manager for each url request to ensure authentication 
        # details are supplied
        passwordManager = urllib2.HTTPPasswordMgrWithDefaultRealm()

        # The values to supply here are imported from config.settings
        passwordManager.add_password(None, base_address, username, password)
        handler = urllib2.HTTPBasicAuthHandler(passwordManager)
        opener = urllib2.build_opener(handler)
        # Install the opener for all url requests
        urllib2.install_opener(opener)
        self.base_address = base_address
        if headers is None:
            self.default_headers = settings['default_headers']
        else:
            self.default_headers = settings['xml_headers']    

    def _create_headers(self, supplied_headers):
        """
        Process the supplied headers by merging them with the default headers
        """
        
        merged = dict(self.default_headers)    
            
        if not supplied_headers:
            return merged

        for k, v in supplied_headers.iteritems():
            merged[k] = v

        return merged    
    
    def _do_verb(self, verb, relative_url, body_data=None, headers=None):
        """
        Sends a request to the relative url using the supplied verb and optional form data and headers.
        """
        
        merged_headers = self._create_headers(headers)    
        
        data = body_data

        if body_data and type(body_data) == dict:
            data = urllib.urlencode(body_data)
            content_type = 'application/x-www-form-urlencoded'
            
        request = urllib2.Request(self.base_address + relative_url, data, merged_headers)
        request.get_method = lambda: verb
        
        response = urllib2.urlopen(request)
        if hasattr(response, 'read'):
            response_str = response.read()
            if response_str:
                response = json.loads(response_str)

        return __JsonWrapper__(response) if response else None
        
    def _post(self, relative_url, form=None, headers=None):
        """
        Performs a post operation on the server using the form data supplied.
        """
        return self._do_verb('POST', relative_url, form, headers)
    
    def _put(self, relative_url, form=None, headers=None):
        """
        Performs a PUT operation on the server
        """
        return self._do_verb('PUT', relative_url, form, headers)
    
    def _delete(self, relative_url, headers=None):
        """
        Performs a delete operation on the server.
        """
        return self._do_verb('DELETE', relative_url, None, headers)
    
    def _get(self, relative_url, headers=None):
        """
        Performs a GET on the server, returning the response as a parsed json object, with javascript semantics
        for accessing json attributes.
        """
        endpoint = self.base_address + relative_url
        
        request = urllib2.Request(endpoint, None, self._create_headers(headers))
        response = json.load(urllib2.urlopen(request))
        return __JsonWrapper__(response)
    
    def create_querystring(self, relative_url, args=None):
        """
        Builds a query string based on a relative path, and optional arguments
        """
        qargs = urllib.urlencode(args) if args else ""
        path = relative_url
        if qargs:
            path += "?" + qargs
        return path
        
