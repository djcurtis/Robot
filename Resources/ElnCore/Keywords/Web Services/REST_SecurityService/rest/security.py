############################################################################
#
# Copyright (C) 1993-2011 ID Business Solutions Limited
# All rights reserved
# 
# security.py
#
############################################################################

from restclient import RestClient
import urllib
import json

SECURITY_ENDPOINT = "security/administration"

class SecurityClient(RestClient):
    
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    #/security/administration/groups

    def get_group(self, groupname):
        """
        Returns a Group object bases on the given groupname.
        """
        return self._get(SECURITY_ENDPOINT + "/groups/" + groupname)

    def find_groups(self, groupname):
        """
        Returns a list of matching groups based on the groupname provided.
        """
        return self._get(SECURITY_ENDPOINT + "/groups?groupname=" + urllib.quote(groupname))

    def create_group(self, group_name, group_description):
        """
        Creates a group based on the group_name and group_description provided.
        """
        group_dto = {
            "name" : group_name,
            "description" : group_description
            }

        json_str = json.dumps(group_dto)
        print json_str

        self._post(SECURITY_ENDPOINT + "/groups", json_str)

    def update_group(self, groupname, updated_group_description):
        """
        Updates the group given by the groupname provided with the updated_group_description
        """

        group_dto = {
            "description" : updated_group_description
            }
        
        json_str = json.dumps(group_dto)

        print "Updated Group Description: "
        print json_str
        
        self._put(SECURITY_ENDPOINT + "/groups/" + groupname, json_str)

    def delete_group(self, groupname):
        """
        Deletes the group given by the groupname provided
        """
        self._delete(SECURITY_ENDPOINT + "/groups/" + groupname)

    def add_group_admin(self, groupname, username):
        """
        Adds the user given by username as a group admin to the group given by groupname
        """
        self._put(SECURITY_ENDPOINT + "/groups/" + groupname + "/admin/" + username)

    def delete_group_admin(self, groupname, username):
        """
        Deletes the user given by username from being a group admin to the group given by groupname
        """
        self._delete(SECURITY_ENDPOINT + "/groups/" + groupname + "/admin/" + username)

    def add_group_member(self, groupname, username):
        """
        Adds the user given by username as a group member to the group given by groupname
        """
        self._put(SECURITY_ENDPOINT + "/groups/" + groupname + "/member/" + username)

    def delete_group_member(self, groupname, username):
        """
        Deletes the user given by username from being a group member to the group given by groupname
        """
        self._delete(SECURITY_ENDPOINT + "/groups/" + groupname + "/member/" + username)

    #/security/administration/users

    def get_user(self, username):
        """
        Returns a User object based on the given username.
        """
        return self._get(SECURITY_ENDPOINT + "/users/" + username)
    
    def find_users(self, user_full_name):
        """
        Returns a list of matching users based on the name provided.
        """
        return self._get(SECURITY_ENDPOINT + "/users?userFullName=" + urllib.quote(user_full_name))
    
    def create_user(self, user_name, password, full_name, email, department, is_administrator):
        """ Cannot currently send request via JSON, xml below works
        user_dto = {
           "username" : user_name,
           "userfullname": full_name,
           "emails" : {"email" : [email]},
           "department" : department,
           "administrator" : is_administrator,
           "password" : password
        }
        
        json_str = json.dumps(user_dto)        
        print json_str
        
        self._post(SECURITY_ENDPOINT + "/users", json_str)
        """

        xml = "<usercreate xmlns='http://security.services.ewb.idbs.com'>" + \
              "  <username>" + user_name + "</username>" + \
              "  <userfullname>" + full_name + "</userfullname>" + \
              "  <emails>" + \
              "    <ns1:email xmlns:ns1='http://common.services.ewb.idbs.com'>" + email + "</ns1:email>" + \
              "  </emails>" + \
              "  <department>" + department + "</department>" + \
              "  <administrator>" + ("true" if is_administrator else "false") + "</administrator>" + \
              "  <password>" + password + "</password>" + \
              "</usercreate>"

        print xml        
        self._post(SECURITY_ENDPOINT + "/users", xml)

    def update_user(self, user_name, full_name, email, department, is_administrator):
        
        user_dto = {
           "userFullName": full_name,
           "email" : {"email" : [email]},
           "department" : department,
           "administrator" : is_administrator,
        }
        
        json_str = json.dumps(user_dto)        
        print json_str
        
        self._post(SECURITY_ENDPOINT + "/users/" + user_name, json_str)

    def enable_disable_user(self, user_name, comment, disable):
        """
        Enables or disables the user given by user_name
        
        """
        """ Cannot currently send request via JSON, xml below works
        user_dto = {
           #"deleteordisable": disable,
           "comments" : comment
        }
        
        json_str = json.dumps(user_dto)        
        print json_str

        self._post(SECURITY_ENDPOINT + "/users/" + user_name + "/activation", json_str)
        """

        xml = "<deletedisable xmlns='http://security.services.ewb.idbs.com'>" + \
              "    <deleteordisable>" + disable + "</deleteordisable>" + \
              "    <comments>" + comment + "</comments>" + \
              "</deletedisable>"
        
        print xml
        self._post(SECURITY_ENDPOINT + "/users/" + user_name + "/activation", xml)
        
        
    def reset_user_password(self, user_name):
        """
        Resets the password for the user given by user_name
        """
        self._post(SECURITY_ENDPOINT + "/users/" + user_name + "/resetpassword")

    def asign_user_system_role(self, user_name, system_role):
        """
        Assigns the system_role to user_name provided
        """
        self._post(SECURITY_ENDPOINT + "/users/" + user_name + "/roles/" + system_role)

    def delete_user_system_role(self, user_name, system_role):
        """
        Deletes the system_role to user_name provided
        """
        self._delete(SECURITY_ENDPOINT + "/users/" + user_name + "/roles/" + system_role)
        
    def asign_user_entity_role(self, user_name, entity_role, entityId):
        """
        Assigns the entity_role to user_name at the entityId level provided
        """
        self._put(SECURITY_ENDPOINT + "/users/" + user_name + "/roles/" + entity_role + "/entities/" + entityId)

    def delete_user_entity_role(self, user_name, entity_role, entityId):
        """
        Deletes the entity_role to user_name at the entityId level provided
        """
        self._delete(SECURITY_ENDPOINT + "/users/" + user_name + "/roles/" + entity_role + "/entities/" + entityId)
        
    def asign_group_entity_role(self, group_name, entity_role, entityId):
        """
        Assigns the entity_role to group_name at the entityId level provided
        """
        self._put(SECURITY_ENDPOINT + "/groups/" + group_name + "/roles/" + entity_role + "/entities/" + entityId)

    def delete_group_entity_role(self, group_name, entity_role, entityId):
        """
        Deletes the entity_role to group_name at the entityId level provided
        """
        self._delete(SECURITY_ENDPOINT + "/groups/" + group_name + "/roles/" + entity_role + "/entities/" + entityId)        
        
    #/security/administration/roles

    def get_role(self, rolename):
        """
        Returns a role object based on the rolename provided
        """
        return self._get(SECURITY_ENDPOINT + "/roles/" + rolename)

    def find_roles(self, rolename):
        """
        Returns a list of matching roles based on the name provided - this doesn't currently work...
        """
        return self._get(SECURITY_ENDPOINT + "/roles?rolename=" + urllib.quote(rolename))

    def find_system_roles(self):
        """
        Returns a list of system roles - this doesn't currently work...
        """
        return self._get(SECURITY_ENDPOINT + "/roles?systemRole=true")
                         
    def create_role(self, role_name, role_display_name, role_description, is_systemrole):
        """ Cannot currently send request via JSON, xml below works
        role_dto = {
            "name" : role_name,
            "displayName" : role_display_name,
            "description" : role_description,
            "systemRole" : is_systemrole
        }
        
        json_str = json.dumps(role_dto)
        print json_str

        self._post(SECURITY_ENDPOINT + "/roles", json_str)
        """
        xml = "<rolecreate xmlns='http://security.services.ewb.idbs.com'>" + \
              "    <name>" + role_name + "</name>" + \
              "    <displayName>" + role_display_name + "</displayName>" + \
              "    <description>" + role_description + "</description>" + \
              "    <systemRole>" + is_systemrole + "</systemRole>" + \
              "</rolecreate>"
        print xml
        self._post(SECURITY_ENDPOINT + "/roles", xml)

    def update_role(self, role_name, role_description):
        """
        Updates role given by role_name with an updated role_description
        """
        
        role_dto = {
            "description" : role_description
        }

        json_str = json.dumps(role_dto)
        print json_str

        self._put(SECURITY_ENDPOINT + "/roles/" + role_name, json_str)      

    def delete_role(self, role_name, delete_reason):
        """
        Deletes the role given by role_name
        """

        role_dto = {
            "comments" : delete_reason
        }

        json_str = json.dumps(role_dto)
        print json_str

        self._delete(SECURITY_ENDPOINT + "/roles/" + role_name, json_str) 
        
    def add_role_permission(self, role_name, permission_name):
        """
        Adds permission_name to role_name, both entity and system roles/permissions
        """
        self._put(SECURITY_ENDPOINT + "/roles/" + role_name + "/permissions/" + permission_name)
                         
    def delete_role_permission(self, role_name, permission_name):
        """
        Deletes permission_name to role_name, both entity and system roles/permissions
        """
        self._delete(SECURITY_ENDPOINT + "/roles/" + role_name + "/permissions/" + permission_name)
    
    
