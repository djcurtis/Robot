'''
Created on 22 Aug 2013

@author: sjefferies
'''
import base64
import json
import os
import urllib2

import jsonpointer

from helper import SeleniumInstanceHelper


class DownloadHelperFunctions:

    def __init__(self):
        self._selenium_instance = None  

    def download_file_from_EWB(self, url, filename, cookie='JSESSIONID'):
        """
        Downloads the file from the given url to the given filename location.
        
        *Arguments*
        - _url_ - the file download url
        - _filename_ - the name and path of the output file
        - _cookie_ - the session cookie name, defaults to JSESSIONID
        
        *Example*
        | Download File From EWB | https://localhost:8443/my/download/url | ${OUTPUT_DIR}/downloaded_file.txt |
        """
        self._selenium_instance = SeleniumInstanceHelper()._get_selenium_instance()
        print(self._selenium_instance._current_browser().get_cookies())
        cookie_value = self._selenium_instance._current_browser().get_cookie(cookie)['value']
        cookie_string = '{0}={1}'.format(cookie, cookie_value)
        cookie_header = {'Cookie' : cookie_string}
        print cookie_header
        req = urllib2.Request(url, headers=cookie_header)
        response = urllib2.urlopen(req)
        file_content = response.read()
        directory = os.path.dirname(filename)
        if not os.path.exists(directory):
            os.makedirs(directory)
        file = open (filename, 'wb')
        file.write(file_content)
        file.close()

    def download_spreadsheet_audit_log(self, entity_id, filename, server, port=8443, http_scheme='https',
                                       username='Administrator', password='Administrator'):
        """
        Downloads the audit log for the spreadsheet given by the entity_version_id to the given filename location. The
        audit log is downloaded as a CSV by default

        *Arguments*
        - _entity_id_ - the entity ID for the spreadsheet containing the audit log
        - _file_name_ - the full path to use as the audit log output location
        - _server_ - the EWB application server name/IP
        - _port=8443_ - the port on which the EWB application server is running, defaults to 8443
        - _http_scheme=https_ - the scheme (http/https) the EWB application server is using, defaults to https
        - _username=Administrator_ - the user to connect as, defaults to Administrator
        - _password=Administrator_ - the password for the user to connect as, defaults to Administrator

        *Example*
        | Download Spreadsheet Audit Log | 12345 |${OUTPUT_DIR}/audit_log.csv | VPCS-EWB24 |
        """
        basic_auth = base64.b64encode('{0}:{1}'.format(username, password))
        audit_id = self._get_child_audit_id(server, port, http_scheme, entity_id, basic_auth)
        v_id = self._get_latest_version_id(server, port, http_scheme, audit_id, basic_auth)
        url = '{0}://{1}:{2}/ewb/services/1.0/entities/{3}/data?entityVersionId={4}'.format(http_scheme, server, port,
                                                                                            audit_id, v_id)
        self._download_to_file(url, filename, basic_auth)

    def _get_child_audit_id(self, server, port, scheme, entity_id, basic_auth):
        url = '{0}://{1}:{2}/ewb/services/1.0/entities/{3}?includeChildren=true'.format(scheme, server, port,
                                                                                             entity_id)
        resp = self._perform_get(url, basic_auth, {'accept': 'application/json'})
        return jsonpointer.resolve_pointer(json.loads(resp), '/children/entity/0/entityCore/entityId')

    def _get_latest_version_id(self, server, port, scheme, entity_id, basic_auth):
        url = '{0}://{1}:{2}/ewb/services/1.0/entities/{3}?includeVersionInfo=true'.format(scheme, server, port,
                                                                                                entity_id)
        resp = self._perform_get(url, basic_auth, {'accept': 'application/json'})
        return jsonpointer.resolve_pointer(json.loads(resp), '/versionInfo/versionId')

    def _perform_get(self, url, basic_auth=None, additional_headers={}):
        req = urllib2.Request(url)
        if basic_auth:
            req.add_header("Authorization", "Basic %s" % basic_auth)
        for header in additional_headers:
            req.add_header(header, additional_headers[header])
        try:
            # wrap in try-except since this will fail on 2.7.8 and below
            import ssl
            gcontext = ssl.SSLContext(ssl.PROTOCOL_TLSv1)
            response = urllib2.urlopen(req, context=gcontext)
        except AttributeError:
            # 2.7.8 and below did not check cert integrity so continue with default context
            response = urllib2.urlopen(req)
        return response.read()

    def _download_to_file(self, url, filename, basic_auth=None):
        file_content = self._perform_get(url, basic_auth)
        directory = os.path.dirname(filename)
        if not os.path.exists(directory):
            os.makedirs(directory)
        file = open (filename, 'wb')
        file.write(file_content)
        file.close()
