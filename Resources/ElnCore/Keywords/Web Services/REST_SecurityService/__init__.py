############################################################################
#
# Copyright (C) 1993-2011 ID Business Solutions Limited
# All rights reserved
# 
# __init__.py
#
############################################################################

#from secClient import secClient
import rest
from rest.security import SecurityClient
import urllib2
#from rest.config import settings

class SecurityService:

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self, base_address, username, password):
        global base_url
        global username1
        global password1
        base_url = base_address
        username1 = username
        password1 = password
        pass

    def change_base_url(self, new_url):
        global base_url
        base_url = new_url
        
    def change_username(self, new_username):
        global username1
        username1 = new_username

    def change_password(self,new_password):
        global password1
        password1 = new_password

#USER GROUPS    
    def get_group(self, groupname):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.get_group(groupname)
        except Exception, exception:
            message = "group '%s' not found" % groupname
            raise AssertionError(message)   

    def get_group_and_expect_error(self, groupname):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.get_group(groupname)
            message = "group '%s' found" % groupname
            raise AssertionError(message) 
        except AssertionError:
            raise AssertionError(message)
        except Exception, exception:
            print "group '%s' not found" % groupname

    def create_group(self, groupname, groupdescription):
        print username1
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.create_group(groupname, groupdescription)
            group1 = secClient1.get_group(groupname)
            group1description = group1.description
            group1descriptionstring = str (group1description)
            if group1descriptionstring == groupdescription:
                print "Group '%s' created" % groupname
            else:
                message = "group '%s' not created" % groupname
                raise AssertionError(message)
        except Exception, exception:
            print exception
            message = "group '%s' not created" % groupname
            raise AssertionError(message)
        
    def create_group_and_expect_error(self, groupname, groupdescription):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.create_group(groupname, groupdescription)
            """
            group1 = secClient1.get_group(groupname)
            group1description = group1.description
            group1descriptionstring = str (group1description)
            if group1descriptionstring == groupdescription:
                message = "Group '%s' created" % groupname
                print 'group has been created'
                raise AssertionError(message)
            else:
                print "Group '%s' not created" % username
                message = "group '%s' not created" % groupname
            """ 
            message = "Group '%s' created" % groupname
            print 'group has been created'
            raise AssertionError(message)   
        except AssertionError:
            raise AssertionError(message)
        except Exception, exception:
            print exception
            print "group '%s' not created" % groupname           
        
    def update_group(self, groupname, updateddescription):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.update_group(groupname, updateddescription)
            group1 = secClient1.get_group(groupname)
            group1description = group1.description
            group1descriptionstring = str (group1description)
            if group1descriptionstring == updateddescription:
                print "Group '%s' updated" % groupname
            else:
                message = "group '%s' not updted" % groupname
                raise AssertionError(message)
        except Exception, exception:
            message = "group '%s' not updated" % groupname
            raise AssertionError(message)            
    
    def update_group_and_expect_error(self, groupname, updateddescription):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.update_group(groupname, updateddescription)
            group1 = secClient1.get_group(groupname)
            group1description = group1.description
            group1descriptionstring = str (group1description)
            if group1descriptionstring == updateddescription:
                message = "Group '%s' updated" % groupname
                raise AssertionError(message)
            else:
                print "group '%s' not updted" % groupname
        except AssertionError:
            raise AssertionError(message)
        except Exception, exception:
            print "group '%s' not updated" % groupname

    def add_group_admin(self, groupname, username):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.add_group_admin(groupname, username)
            group1 = secClient1.get_group(groupname)
            group1admins = group1.admins
            group1adminsnames = group1admins.name
            group1adminslength = len(group1adminsnames)
            countvalue = 0
            userfound = 0
            while (countvalue < group1adminslength):
                name = str(group1adminsnames[countvalue])
                if (name == username):
                    userfound = 1       
                else:
                    print "something"
                countvalue = countvalue + 1           
            if userfound == 1:
                print "%s added to group" % username
            else:
                message = "%s not added to group" % username
                raise AssertionError(message)           
        except Exception, exception:
                message = "%s not added to group" % username
                raise AssertionError(message)

    def delete_group_admin(self, groupname, username):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.delete_group_admin(groupname, username)
            group1 = secClient1.get_group(groupname)
            group1admins = group1.admins
            group1adminsnames = group1admins.name
            group1adminslength = len(group1adminsnames)
            countvalue = 0
            userfound = 0
            while (countvalue < group1adminslength):
                name = str(group1adminsnames[countvalue])
                if (name == username):
                    userfound = 1       
                else:
                    userfound = 0
                countvalue = countvalue + 1
            if userfound == 0:
                print "%s deleted from group" % username
            else:
                message = "%s not deleted from group" % username
                raise AssertionError(message)           
        except Exception, exception:
                message = "%s not deleted from group" % username
                raise AssertionError(message)

    def delete_group_admin_and_expect_error(self, groupname, username):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.delete_group_admin(groupname, username)
            group1 = secClient1.get_group(groupname)
            group1admins = group1.admins
            group1adminsnames = group1admins.name
            group1adminslength = len(group1adminsnames)
            countvalue = 0
            userfound = 0
            while (countvalue < group1adminslength):
                name = str(group1adminsnames[countvalue])
                if (name == username):
                    userfound = 1       
                else:
                    print "'%s user not found" % username
                countvalue = countvalue + 1
            if userfound == 1:
                message =  "%s deleted from group" % username
                raise AssertionError(message) 
            else:
                print "%s not deleted from group" % username
        except AssertionError:
            raise AssertionError(message)                  
        except Exception, exception:
                print "%s not deleted from group" % username

    def add_group_member(self, groupname, username):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.add_group_member(groupname, username)
            group1 = secClient1.get_group(groupname)
            group1members = group1.members
            group1membersnames = group1members.name
            group1memberslength = len(group1membersnames)
            countvalue = 0
            userfound = 0
            while (countvalue < group1memberslength):
                name = str(group1membersnames[countvalue])
                if (name == username):
                    userfound = 1       
                else:
                    print "something"
                countvalue = countvalue + 1           
            if userfound == 1:
                print "%s added to group" % username
            else:
                message = "%s not added to group" % username
                raise AssertionError(message)           
        except Exception, exception:
                message = "FAIL %s not added to group" % username
                raise AssertionError(message)
   
    def delete_group_member(self, groupname, username):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.delete_group_members(groupname, username)
            group1 = secClient1.get_group(groupname)
            group1members = group1.members
            group1membersnames = group1members.name
            group1memberslength = len(group1membersnames)
            countvalue = 0
            userfound = 0
            while (countvalue < group1memberslength):
                name = str(group1memberssnames[countvalue])
                if (name == username):
                    userfound = 1       
                else:
                    userfound = 0
                countvalue = countvalue + 1
            if userfound == 0:
                print "%s deleted from group" % username
            else:
                message = "%s not deleted from group" % username
                raise AssertionError(message)           
        except Exception, exception:
                message = "FAIL %s not deleted from group" % username
                raise AssertionError(message)

    def delete_group(self, groupname):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.delete_group(groupname)
            newGroup1 = secClient1.find_groups(groupname)
            if len(newGroup1) == 0:
                print "group %s deleted" % groupname
            else:
                message = "group %s not deleted" % groupname
                raise AssertionError(message)
        except Exception, exception:
                message = "group %s not deleted" % groupname
                raise AssertionError(message)

    def delete_group_and_expect_error(self, groupname):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.delete_group(groupname)
            newGroup1 = secClient1.find_groups(groupname)
            if len(newGroup1) == 0:
                message = "group %s deleted" % groupname
                raise AssertionError(message)
            else:
                print "group %s not deleted" % groupname
        except AssertionError:
            raise AssertionError(message)        
        except Exception, exception:
                print "group %s not deleted" % groupname
    def delete_group_no_check(self, groupname):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.delete_group(groupname)
        except Exception, exception:
            print "Could not find '%s' group" % groupname                    
#USERS
    def get_user(self, username):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.get_user(username)
        except Exception, exception:
            message = "user '%s' not found" % username
            raise AssertionError(message)

    def get_user_and_expect_error(self, username):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.get_user(username)
            message = "user '%s' found" % username
            raise AssertionError(message)
        except AssertionError:
            raise AssertionError(message)
        except Exception, exception:
            print exception
            print "user '%s' not found" % username

    def check_user_details(self,username, fullname, email, department, isadmin):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            user1 = secClient1.get_user(username)
            user1username = str(user1.userName)
            user1fullname = str(user1.userFullName)
            user1department = str(user1.department)
            print user1username
            print user1fullname
            print user1department
            if  user1username != username:
                message = "username '%s' not found" % username
                raise AssertionError(message)
            elif user1fullname != fullname:
                message = "fullname '%s' not found" % fullname
                raise AssertionError(message)
            elif user1department != department:
                message = "department '%s' not found" % department
                raise AssertionError(message)
            else:
                print "User successfully validated"
        except Exception, exception:
            message = exception #"User not validated succesfully"
            raise AssertionError(message)

    #FORCED XML HERE ATM
    def create_user(self, username, password, fullname, email, department, isadmin):
        print "HERE"
        secClient1 = SecurityClient(base_url, username1, password1, 'xml')
        print "HERE"
        try:
            secClient1.create_user(username, password, fullname, email, department, isadmin)
            user1 = secClient1.get_user(username)
            user1username = str(user1.userName)
            user1fullname = str(user1.userFullName)
            user1department = str(user1.department)
            user1emails = user1.email
            user1email = str(user1emails.email)
            user1emailvalidate = '["'+email+'"]'
            print user1username
            print user1fullname
            print user1department
            print user1email
            print user1emailvalidate
            if  user1username != username:
                message = "username '%s' not found" % username
                raise AssertionError(message)
            elif user1fullname != fullname:
                message = "fullname '%s' not found" % fullname
                raise AsserttionError(message)
            elif user1department != department:
                message = "department '%s' not found" % department
                raise AssertionError(message)
            elif user1email !=  user1emailvalidate:
                message = "email address '%s' not found" % email
                raise AssertionError(message)
            else:
                print "User successfully created"
        except Exception, exception:
            message = exception #"User not created succesfully"
            raise AssertionError(message)
        
    def create_user_no_check(self, username, password, fullname, email, department, isadmin):
        secClient1 = SecurityClient(base_url, username1, password1, 'xml')
        try:
            secClient1.create_user(username, password, fullname, email, department, isadmin)
        except Exception, exception:
            print exception    

    def create_user_and_expect_error(self, username, password, fullname, email, department, isadmin):
        secClient1 = SecurityClient(base_url, username1, password1, 'xml')
        try:
            secClient1.create_user(username, password, fullname, email, department, isadmin)
            """
            try:
                user1 = secClient1.find_users(username)
                if len(user1) == 1:
                    user1username = str(user1.userName)
                    user1fullname = str(user1.userFullName)
                    user1department = str(user1.department)
                    if user1username == username:
                        message = "Username '%s' found" % username
                        raise AssertionError(message)
                    elif user1fullname == fullname:
                        message = "fullname '%s' found" % fullname
                        raise AssertionError(message)
                    elif user1department == department:
                        message = "department '%s' found" % department
                        raise AssertionError(message)
                    else:
                        message = "Username '%s' not found" % username
                        raise Exception(message)
                else:
                    raise Exception(message)
            except Exception, exception:
                message = exception
                raise Exception(message)
            """   
            message = "User '%s' created" % username
            print 'User has been created'
            raise AssertionError(message) 
        except AssertionError:
            raise AssertionError(message)
        except Exception, exception:
            print exception
            print "User '%s' not created" % username 

    def update_user(self, username, fullname, email, department, isadmin):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.update_user(username, fullname, email, department, isadmin)
            user1 = secClient1.get_user(username)
            user1username = str(user1.username)
            user1fullname = str(user1.fullname)
            user1password = str(user1.password)
            user1department = str(user1.department)
            print user1username
            print user1fullname
            print user1password
            print user1department
            if  user1username != username:
                message = "username '%s' not found" % username
                raise AssertionError(message)
            elif user1fullname != fullname:
                message = "fullname '%s' not found" % fullname
                raise AssertionError(message)
            elif user1password != password:
                message = "password '%s' not found" % password
                raise AsserttionError(message)
            elif user1department != department:
                message = "department '%s' not found" % department
                raise AssertionError(message)
            else:
                print "User successfully updated"
        except Exception, exception:
            message = exception #"User not updated succesfully"
            raise AssertionError(message)

    def enable_disable_user(self, username, comment, disable):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.enable_disable_user(username, comment, disable)
        except Exception, exception:
            message = exception #"User not disabled or enabled succesfully"
            raise AssertionError(message)
    
    def reset_user_password(self, username):
        secClient1 = SecurityClient(base_url, username1, password1, 'xml')
        try:
            secClient1.reset_user_password(username)
        except Exception, exception:
            message = exception
            raise AssertionError(message)    
    
    #FORCED TO USE XML CURRENTLY    
    def enable_user(self, username):
        secClient1 = SecurityClient(base_url, username1, password1, 'xml')
        user1 = secClient1.get_user(username)
        user1status = str(user1.disabled)
        if  user1status == 'False':
            print "user already enabled"
        else:
            secClient1.enable_disable_user(username, 'enabled', 'false')
            user2 = secClient1.get_user(username)
            user2status = str(user2.disabled)
            if  user2status == 'False':
                print "user enabled"
            else:
                message = "user not enabled"
                raise AssertionError(message) 
    
    def enable_user_and_expect_error(self, username):
        secClient1 = SecurityClient(base_url, username1, password1, 'xml')
        user1 = secClient1.get_user(username)
        user1status = str(user1.disabled)
        try:
            if  user1status == 'False':
                print "user already enabled"
            else:
                secClient1.enable_disable_user(username, 'enabled', 'false')
                message = "user enabled"
                raise AssertionError(message)
        except AssertionError:
            raise AssertionError(message)
        except Exception, exception:
            print exception
            print "user '%s' not enabled" % username
           
    #FORCED TO USE XML CURRENTLY
    def disable_user(self,username, disable_reason):
        secClient1 = SecurityClient(base_url, username1, password1, 'xml')
        user1 = secClient1.get_user(username)
        user1status = str(user1.disabled)
        if  user1status == 'True':
            print "user already disabled"
        else:
            secClient1.enable_disable_user(username, disable_reason, 'true')
            user2 = secClient1.get_user(username)
            user2status = str(user2.disabled)
            if  user2status == 'True':
                print "user disabled"
            else:
                message = "user not disabled"
                raise AssertionError(message)    
                                    
    def disable_user_and_expect_error(self,username, disable_reason):
        secClient1 = SecurityClient(base_url, username1, password1, 'xml')
        user1 = secClient1.get_user(username)
        user1status = str(user1.disabled)
        try:
            if  user1status == 'True':
                print "user already disabled"
            else:
                secClient1.enable_disable_user(username, disable_reason, 'true')
                message = "user disabled"
                raise AssertionError(message)
        except AssertionError:
            raise AssertionError(message)
        except Exception, exception:
            print exception
            print "user '%s' not disabled" % username
           
            
    def reset_user_password(self, username):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.reset_user_password(username)
        except Exception, exception:
            message = exception #"User password not reset succesfully"
            raise AssertionError(message)

    def assign_user_system_role(self, username, systemrole1):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.asign_user_system_role(username, systemrole1)
        except Exception, exception:
            message = exception #"User role not assigned succesfully"
            raise AssertionError(message)

    def assign_user_system_role_and_expect_error(self, username, systemrole):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.asign_user_system_role(username, systemrole)
            message = "User role assigned"
            raise AssertionError(message)
        except AssertionError:
            raise AssertionError(message)
        except Exception, exception:
            print "User role not assigned"

    def delete_user_system_role(self, username, systemrole):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.delete_user_system_role(username, systemrole)
        except Exception, exception:
            message = exception #"User role not deleted succesfully"
            raise AssertionError(message)
        
    def delete_user_system_role_and_expect_error(self, username, systemrole):
         secClient1 = SecurityClient(base_url, username1, password1)
         try:
            secClient1.delete_user_system_role(username, systemrole)
            message = "System role deleted"
            raise AssertionError(message)
         except AssertionError:
            raise AssertionError(message)
         except Exception, exception:
            print "System role not deleted"
    
    def assign_user_entity_role(self, username, entityrole, entityId):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.asign_user_entity_role(username, entityrole, entityId)
        except Exception, exception:
            message = exception #"User role not assigned succesfully"
            raise AssertionError(message)    

    def assign_user_entity_role_and_expect_error(self, username, entityrole, entityId):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.asign_user_entity_role(username, entityrole, entityId)
            message = "Entity role assigned"
            raise AssertionError(message)
        except AssertionError:
            raise AssertionError(message)
        except Exception, exception:
            print "Entity role not assigned"

    def assign_group_entity_role(self, groupname, entityrole, entityId):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.asign_group_entity_role(groupname, entityrole, entityId)
        except Exception, exception:
            message = exception #"User role not assigned succesfully"
            raise AssertionError(message)    

    def assign_group_entity_role_and_expect_error(self, groupname, entityrole, entityId):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.asign_group_entity_role(groupname, entityrole, entityId)
            message = "Entity role assigned"
            raise AssertionError(message)
        except AssertionError:
            raise AssertionError(message)
        except Exception, exception:
            print "Entity role not assigned"

    def delete_user_entity_role(self, username, entityrole, entityId):
         secClient1 = SecurityClient(base_url, username1, password1)
         try:
            secClient1.delete_user_entity_role(username, entityrole, entityId)
         except Exception, exception:
            message = exception #"User role not deleted succesfully"
            raise AssertionError(message)
        
    def delete_user_entity_role_and_expect_error(self, username, entityrole, entityId):
         secClient1 = SecurityClient(base_url, username1, password1)
         try:
            secClient1.delete_user_entity_role(username, entityrole, entityId)
            message = "Entity role deleted"
            raise AssertionError(message)
         except AssertionError:
            raise AssertionError(message)
         except Exception, exception:
            print "Entity role not deleted"
            
    def delete_group_entity_role(self, groupname, entityrole, entityId):
         secClient1 = SecurityClient(base_url, username1, password1)
         try:
            secClient1.delete_group_entity_role(groupname, entityrole, entityId)
         except Exception, exception:
            message = exception #"User role not deleted succesfully"
            raise AssertionError(message)
        
    def delete_group_entity_role_and_expect_error(self, groupname, entityrole, entityId):
         secClient1 = SecurityClient(base_url, username1, password1)
         try:
            secClient1.delete_group_entity_role(groupname, entityrole, entityId)
            message = "Entity role deleted"
            raise AssertionError(message)
         except AssertionError:
            raise AssertionError(message)
         except Exception, exception:
            print "Entity role not deleted"            
            
    def get_role(self, rolename):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.get_role(rolename)
        except Exception, exception:
            message = exception #"Role not found"
            raise AssertionError(message)

    def create_role(self, rolename, roledisplayname, roledescription, issystemrole):
        secClient1 = SecurityClient(base_url, username1, password1, 'xml')
        try:
            secClient1.create_role(rolename, roledisplayname, roledescription, issystemrole)
            role1 = secClient1.get_role(rolename)
            role1name = str(role1.name)
            role1dispname = str(role1.displayName) 
            role1desc = str(role1.description)
            systemrole = str(role1.systemRole)
            if systemrole == 'True':
                systemrole = 'true'
            else:
                systemrole = 'false' 
            if role1name != rolename:
                message = "role name doesn't match"
                raise AssertionError(message)
            elif role1dispname != roledisplayname:
                message = "role display name doesn't match"
                raise AssertionError(message)
            elif role1desc != roledescription:
                message = "role description doesn't match"
                raise AssertionError(message)
            elif systemrole != issystemrole:
                message = "system role flag doesn't match"
                raise AssertionError(message)
            else:
                print "created role validated"
        except Exception, exception:
            message = exception #"Role not found"
            raise AssertionError(message)
        
    def create_role_and_expect_error(self, rolename, roledisplayname, roledescription, issystemrole):
        secClient1 = SecurityClient(base_url, username1, password1, 'xml')
        try:
            secClient1.create_role(rolename, roledisplayname, roledescription, issystemrole)
            message = "Role '%s' created" % rolename
            raise AssertionError(message)
        except AssertionError:
            raise AssertionError(message)
        except Exception, exception:
            print exception
            print "Role '%s' not created" % rolename   

    def update_role(self, rolename, roledescription):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.update_role(rolename, roledescription)
            
        except Exception, exception:
            message = exception #"Role not updated"
            raise AssertionError(message)
        
    def update_role_and_expect_error(self, rolename, roledescription):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            role1 = secClient1.get_role(rolename)
            role1name = str(role1.name) 
            role1desc = str(role1.description)
            secClient1.update_role(rolename, roledescription)
            message = "role updated"
            raise AssertionError(message)
        except AssertionError:
            raise AssertionError(message)
        except Exception, exception:
            if role1name != rolename:
                message = "role name has been updated"
                raise AssertionError(message)
            elif role1desc != roledescription:
                message = "role description has been updated"
                raise AssertionError(message)     

    def delete_role(self, rolename, deletereason):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.delete_role(rolename, deletereason)
        except Exception, exception:
            message = exception #"Role not deleted"
            raise AssertionError(message)
    
    def delete_role_and_expect_error(self, rolename, deletereason):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.delete_role(rolename, deletereason)
            message ="Role Deleted"
            raise AssetionError(message)
        except AssertionError:
            raise AssertionError(message)
        except Exception, exception:
            print "Role '%s' not deleted" % rolename    
        
    def add_role_permission(self, rolename, permissionname):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.add_role_permission(rolename, permissionname)
            role1 = secClient1.get_role(rolename)
            role1permissions = role1.permissions
            role1permissionnames = str(role1permissions.name)
            if  permissionname in role1permissionnames:
                print "permission '%s' added to role" % permissionname
            else:
                message = "permission '%s' not added to role" % permissionname
                raise AssertionError(message)    
        except Exception, exception:
            message = exception #"Permission not added to role"
            raise AssertionError(message)    
    
    def add_role_permission_and_expect_error(self, rolename, permissionname):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.add_role_permission(rolename, permissionname)
            message = "permission '%s' added to role" % permissionname
            raise AssertionError(message)
        except AssertionError:
            raise AssertionError(message)
        except Exception, exception:
            print exception
                         
    def delete_role_permission(self, rolename, permissionname):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.delete_role_permission(rolename, permissionname)
        except Exception, exception:
            message = exception #"Permission not removed from role"
            raise AssertionError(message)    

    def delete_role_permission_and_expect_error(self, rolename, permissionname):
        secClient1 = SecurityClient(base_url, username1, password1)
        try:
            secClient1.delete_role_permission(rolename, permissionname)
            message = "permission '%s' deleted from role" % permissionname
            raise AssertionError(message)
        except AssertionError:
            raise AssertionError(message)
        except Exception, exception:
            print exception        
