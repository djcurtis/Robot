############################################################################
#
# Copyright (C) 1993-2011 ID Business Solutions Limited
# All rights reserved
# 
# entitytree.py
#
############################################################################

from rest.restclient import RestClient
import urllib
import json

CATALOG_ENDPOINT = "catalog"

class CatalogClient(RestClient):
    
    def get_root_elements(self):
        """
        Returns all root elements.
        """
        return self._get(CATALOG_ENDPOINT + "/elements/")

    def create_dictionary(self,idOrPath,name,desc,enabled):
        
        xml="<dictionarycreate xmlns='http://catalog.services.ewb.idbs.com'>" + \
        "<name>"+name+"</name>" + \
        "<description>"+desc+"</description>" + \
        "<enabled>"+("true" if enabled else "false")+"</enabled>" + \
        "</dictionarycreate>"
        if idOrPath is None:
          self._post(CATALOG_ENDPOINT + "/elements/",xml,"application/xml;charset=utf-8")
        else:
          self._post(CATALOG_ENDPOINT + "/elements/" +idOrPath+ "/children",xml,"application/xml;charset=utf-8")

    def update_dictionary(self,name,desc,enabled,idOrPath):
        
        dictionary_dto = {
          "name" : name,
          "description" : desc,
          "enabled" : enabled
        }
        json_dict = json.dumps(dictionary_dto)

        self._post(CATALOG_ENDPOINT + "/elements/"+idOrPath,json_dict)

    def create_term(self,idOrPath,name,desc,enabled,proptype,propname,propdesc,propformat,propconstraint,propunit):

        xml = "<termcreate xmlns='http://catalog.services.ewb.idbs.com'>" + \
         "<name>"+name+"</name>" + \
         "<description>"+desc+"</description>" + \
         "<enabled>"+("true" if enabled else "false")+"</enabled>" + \
         "<dimension>"+dimension+"</dimension>" + \
         "<properties>" + \
           "<property displayed=\"true\" key=\"true\" type="+proptype+">" + \
           "<name>"+propname+"</name>" + \
           "<description>"+propdesc+"</description>" + \
           "<format>"+propformat+"</format>" + \
           "<constraint>"+propconstraint+"</constraint>" + \
           "<unit>"+propunit+"</unit>" + \
           "</property>" + \
         "</properties>" + \
         "</termcreate>"
        if idOrPath is None:
          self._post(CATALOG_ENDPOINT + "/elements/",xml)
        else:
          self._post(CATALOG_ENDPOINT + "/elements/" +idOrPath+ "/children",xml)
    

    def update_term(self,name,desc,enabled,idOrPath):

        term_dto = {
           "name" : name,
           "description":desc,
           "enabled":enabled,
           "properties":{"property":[{"name":"id","description":"id","format":None,"type":"STRING","key":True,"displayed":True}]}
        }
        json_term = json.dumps(term_dto)

        self._post(CATALOG_ENDPOINT + "/elements/"+idOrPath,json_term)

    def get_element( self, idOrPath):

        return self._get(CATALOG_ENDPOINT + "/elements/"+idOrPath)

    def get_element_children( self, idOrPath):

        return self._get(CATALOG_ENDPOINT + "/elements/" + idOrPath + "/children")

    def delete_element_children( self, idOrPath):

        return self._delete(CATALOG_ENDPOINT + "/elements/" + idOrPath + "/children")

    def delete_element( self, idOrPath):

        return self._delete(CATALOG_ENDPOINT + "/elements/" + idOrPath )
 
    def get_tuples( self, idOrPath):

        return self._get(CATALOG_ENDPOINT + "/terms/" + idOrPath + "/tuples")
