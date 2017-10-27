*** Settings ***
Documentation     A resource file containing IDBS defined keywords used for testing the IDBS E-WorkBook Web Client application. This resource file contains keywords applicable to the REST security administration web service.
...               This file is loaded by the common_resource.txt file which is automatically loaded when running tests through the Robot Framework.
...               *Version: E-WorkBook Web Client 9.2.0*
Library           IDBSHttpLibrary
Library           String
Resource          ../../Common/common_resource.robot
Resource          ../../Common/HTTP Common/http_common_resource.robot

*** Variables ***
${SECURITY ADMINISTRATION GROUP ENDPOINT}    /ewb/services/1.0/security/administration/groups
${SECURITY ADMINISTRATION USER ENDPOINT}    /ewb/services/1.0/security/administration/users
${SECURITY ADMINISTRATION ROLE ENDPOINT}    /ewb/services/1.0/security/administration/roles
${SECURITY ADMINISTRATION ASSIGNMENTS ENDPOINT}    /ewb/services/1.0/security/administration/assignments/entities

*** Keywords ***
Add Role Permission
    [Arguments]    ${role name}    ${permission name}
    [Documentation]    Adds a user/entity permission to a user/entity role
    ...
    ...    *Preconditon*
    ...
    ...    The role and permission exist in the system
    ...
    ...    *Arguments*
    ...
    ...    _role name_ - The user/entity role to assign to the user group
    ...
    ...    _permission name_ - the permission to add to the user/entity role
    ...
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    | Add Role Permission | role_1 | USE_BIOBOOK_EDITOR |
    Check Permission Not Assigned To Role    ${role name}    ${permission name}
    Ensure Role has Permission    ${role name}    ${permission name}

Add Role Permission And Expect Error
    [Arguments]    ${role name}    ${permission name}    ${status code}
    Check Permission Not Assigned To Role    ${role name}    ${permission name}
    Request Setup
    Next Request Should Not Succeed
    PUT    ${SECURITY ADMINISTRATION ROLE ENDPOINT}/${role name}/permissions/${permission name}
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    Check Permission Not Assigned To Role    ${role name}    ${permission name}

Add User Group Admin
    [Arguments]    ${group name}    ${user name}
    Check User Not Admin of User Group    ${group name}    ${user name}
    Request Setup
    PUT    ${SECURITY ADMINISTRATION GROUP ENDPOINT}/${group name}/admin/${user name}
    Check User Admin of User Group    ${group name}    ${user name}

Add User Group Admin And Expect Error
    [Arguments]    ${group name}    ${user name}    ${status code}
    Check User Not Admin of User Group    ${group name}    ${user name}
    Request Setup
    Next Request Should Not Succeed
    PUT    ${SECURITY ADMINISTRATION GROUP ENDPOINT}/${group name}/admin/${user name}
    Response Status Code Should Equal    ${status code}
    Check User Not Admin of User Group    ${group name}    ${user name}
    Next Request Should Succeed

Add User Group Member
    [Arguments]    ${group name}    ${user name}
    [Documentation]    Adds an EWB User to a user group as a group member.
    ...
    ...    *Preconditon*
    ...
    ...    The user and user group must exist in the system
    ...
    ...    *Arguments*
    ...
    ...    _group name_ - The group name
    ...
    ...    _user name_ - The user name
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    | Add Group Member | Group001 | User001 |
    Check User Not Member of User Group    ${group name}    ${user name}
    Request Setup
    PUT    ${SECURITY ADMINISTRATION GROUP ENDPOINT}/${group name}/member/${user name}
    Check User Member of User Group    ${group name}    ${user name}

Add User Group Member And Expect Error
    [Arguments]    ${group name}    ${user name}    ${status code}
    Check User Not Member of User Group    ${group name}    ${user name}
    Request Setup
    Next Request Should Not Succeed
    PUT    ${SECURITY ADMINISTRATION GROUP ENDPOINT}/${group name}/member/${user name}
    Response Status Code Should Equal    ${status code}
    Check User Not Member of User Group    ${group name}    ${user name}
    Next Request Should Succeed

Assign User Entity Role
    [Arguments]    ${user name}    ${role name}    ${entity id}    ${expected_http_status}=204
    [Documentation]    Assigns an entity role to a user
    ...
    ...    *Preconditon*
    ...
    ...    The user, entity role and entity must exist in the system.
    ...
    ...    *Arguments*
    ...
    ...    _user name_ - The user
    ...
    ...    _role name_ - The entity role to assign to the user
    ...
    ...    _entity id_ - The ID of the entity to apply the entity role assignment to
    ...
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    | Assign User Entity Role | user_1 | All Entity Permissions | 1 |
    Request Setup
    Set Request Body    {"additions" : {"entityAssignment" : [ {"entityId" : "${entity id}","roleName" : "${role name}","groupName" : "","userName" : "${user name}"}]}}
    POST    ${SECURITY ADMINISTRATION ASSIGNMENTS ENDPOINT}
    Response Status Code Should Equal    ${expected_http_status}

Assign User Entity Role And Expect Error
    [Arguments]    ${user name}    ${role name}    ${entity id}    ${status code}
    Request Setup
    Next Request Should Not Succeed
    Set Request Body    {"additions" : {"entityAssignment" : [ {"entityId" : "${entity id}","roleName" : "${role name}","groupName" : "","userName" : "${user name}"}]}}
    POST    ${SECURITY ADMINISTRATION ASSIGNMENTS ENDPOINT}
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Assign User Group Entity Role
    [Arguments]    ${group name}    ${role name}    ${entity id}
    [Documentation]    Assigns an entity role to a user group
    ...
    ...    *Preconditon*
    ...
    ...    The user group, entity role and entity must exist in the system.
    ...
    ...    *Arguments*
    ...
    ...    _group name_ - The user group
    ...
    ...    _role name_ - The entity role to assign to the user group
    ...
    ...    _entity id_ - The ID of the entity to apply the entity role assignment to
    ...
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    | Assign Group Entity Role | group_1 | All Entity Permissions | 1 |
    Request Setup
    Set Request Body    {"additions" : {"entityAssignment" : [ {"entityId" : "${entity id}","roleName" : "${role name}","groupName" : "${group name}","userName" : ""}]}}
    POST    ${SECURITY ADMINISTRATION ASSIGNMENTS ENDPOINT}

Assign User Group Entity Role And Expect Error
    [Arguments]    ${group name}    ${role name}    ${entity id}    ${status code}
    Request Setup
    Next Request Should Not Succeed
    Set Request Body    {"additions" : {"entityAssignment" : [ {"entityId" : "${entity id}","roleName" : "${role name}","groupName" : "${group name}","userName" : ""}]}}
    POST    ${SECURITY ADMINISTRATION ASSIGNMENTS ENDPOINT}
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Assign User System Role
    [Arguments]    ${user name}    ${system role name}
    [Documentation]    Assigns a user role to a user
    ...
    ...    *Preconditon*
    ...
    ...    The user and role must exist in the system
    ...
    ...    *Arguments*
    ...
    ...    _user name_ - The user
    ...
    ...    _role name_ - The user role to assign to the user
    ...
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    | Assign User System Role | user_1 | All System Permissions |
    Request Setup
    POST    ${SECURITY ADMINISTRATION USER ENDPOINT}/${user name}/roles/${system role name}
    Validate User System Permission Present    ${user name}    ${system role name}

Assign User System Role And Expect Error
    [Arguments]    ${user name}    ${role name}    ${status code}
    Request Setup
    Next Request Should Not Succeed
    POST    ${SECURITY ADMINISTRATION USER ENDPOINT}/${user name}/roles/${role name}
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Check Permission Assigned To Role
    [Arguments]    ${role name}    ${permission name}
    Request Setup
    GET    ${SECURITY ADMINISTRATION ROLE ENDPOINT}/${role name}
    ${RESPONSE BODY TEMP} =    Get Response Body
    ${RESPONSE BODY}=    Set Variable    ${RESPONSE BODY TEMP}
    Set Suite Variable    ${RESPONSE BODY}
    ${Response Permission Name}=    Get Json Value    ${RESPONSE BODY}    /permissions/name
    Run Keyword Unless    '${permission name}'=='${EMPTY}'    Should Contain    ${Response Permission Name}    "${permission name}"    Permission "${permission name}" expected to be assigned to the role: "${role name}".
    Run Keyword If    '${permission name}'=='${EMPTY}'    Should Be Equal As Strings    ${Response Permission Name}    []    #used if checking no permissions assigned to role

Check Permission Not Assigned To Role
    [Arguments]    ${role name}    ${permission name}
    Request Setup
    GET    ${SECURITY ADMINISTRATION ROLE ENDPOINT}/${role name}
    ${RESPONSE BODY TEMP} =    Get Response Body
    ${RESPONSE BODY}=    Set Variable    ${RESPONSE BODY TEMP}
    Set Suite Variable    ${RESPONSE BODY}
    ${Response Permission Name}=    Get Json Value    ${RESPONSE BODY}    /permissions/name
    Should Not Contain    ${Response Permission Name}    "${permission name}"    Permission "${permission name}" not expected to be assigned to the role: "${role name}".

Check Role Not Present
    [Arguments]    ${role name}
    Request Setup
    Next Request Should Not Succeed
    GET    ${SECURITY ADMINISTRATION ROLE ENDPOINT}/${role name}
    Response Status Code Should Equal    404
    Next Request Should Succeed

Check Role Present
    [Arguments]    ${role name}
    Request Setup
    GET    ${SECURITY ADMINISTRATION ROLE ENDPOINT}/${role name}
    ${RESPONSE BODY TEMP} =    Get Response Body
    ${RESPONSE BODY}=    Set Variable    ${RESPONSE BODY TEMP}
    Set Suite Variable    ${RESPONSE BODY}

Check User Admin of User Group
    [Arguments]    ${group name}    ${user name}
    Request Setup
    GET    ${SECURITY ADMINISTRATION GROUP ENDPOINT}/${group name}
    ${RESPONSE BODY TEMP} =    Get Response Body
    ${Admin Names}=    Get Json Value    ${RESPONSE BODY TEMP}    /admins/name
    Should Contain    ${Admin Names}    ${user name}

Check User Group Not Present
    [Arguments]    ${group name}
    Request Setup
    Next Request Should Not Succeed
    GET    ${SECURITY ADMINISTRATION GROUP ENDPOINT}/${group name}
    ${RESPONSE BODY 1}=    Get Response Body
    Response Status Code Should Equal    404
    Next Request Should Succeed

Check User Group Present
    [Arguments]    ${group name}
    Request Setup
    GET    ${SECURITY ADMINISTRATION GROUP ENDPOINT}/${group name}
    ${RESPONSE BODY 1}=    Get Response Body

Check User Member of User Group
    [Arguments]    ${group name}    ${user name}
    Request Setup
    GET    ${SECURITY ADMINISTRATION GROUP ENDPOINT}/${group name}
    ${RESPONSE BODY TEMP} =    Get Response Body
    ${Member Names}=    Get Json Value    ${RESPONSE BODY TEMP}    /members/name
    Should Contain    ${Member Names}    ${user name}

Check User Not Admin of User Group
    [Arguments]    ${group name}    ${user name}
    Request Setup
    GET    ${SECURITY ADMINISTRATION GROUP ENDPOINT}/${group name}
    ${RESPONSE BODY TEMP} =    Get Response Body
    ${Admin Names}=    Get Json Value    ${RESPONSE BODY TEMP}    /admins/name
    Should Not Contain    ${Admin Names}    ${user name}

Check User Not Member of User Group
    [Arguments]    ${group name}    ${user name}
    Request Setup
    GET    ${SECURITY ADMINISTRATION GROUP ENDPOINT}/${group name}
    ${RESPONSE BODY TEMP} =    Get Response Body
    ${Member Names}=    Get Json Value    ${RESPONSE BODY TEMP}    /members/name
    Should Not Contain    ${Member Names}    ${user name}

Check User Not Present
    [Arguments]    ${user name}
    Request Setup
    Next Request Should Not Succeed
    GET    ${SECURITY ADMINISTRATION USER ENDPOINT}/${user name}
    Response Status Code Should Equal    404
    ${RESPONSE BODY TEMP} =    Get Response Body
    ${RESPONSE BODY}=    Set Variable    ${RESPONSE BODY TEMP}
    Set Suite Variable    ${RESPONSE BODY}
    Next Request Should Succeed

Check User Present
    [Arguments]    ${user name}
    Request Setup
    GET    ${SECURITY ADMINISTRATION USER ENDPOINT}/${user name}
    ${RESPONSE BODY TEMP} =    Get Response Body
    ${RESPONSE BODY}=    Set Variable    ${RESPONSE BODY TEMP}
    Set Suite Variable    ${RESPONSE BODY}

Create Role
    [Arguments]    ${role_name}    ${role_display_name}    ${role_description}    ${system_role}    @{permissions}
    [Documentation]    *Description*
    ...    This keyword creates a new user or entity role in E-WorkBook via the Security Administration Web Service.
    ...
    ...    *Arguments*
    ...
    ...    _role name_ - the role name of the role being created
    ...
    ...    _role display name_ - the role name of the role being created as used in the E-WorkBook thick client
    ...
    ...    _role description_ - the description of the role
    ...
    ...    _system role_ - whether the role is a system role ("true") or not ("false")
    ...
    ...    _permissions_ - an array of permissions
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    ...
    ...    Create Role | Role1 | Role 1 Display | Role 1 Description | false | DELETE_EXPERIMENT | VIEW_PDF
    Request Setup
    Set Request Body    {"name":"${role_name}","displayName":"${role_display_name}","description":"${role_description}","systemRole":"${system_role}"}
    Next Request May Not Succeed
    POST    ${SECURITY ADMINISTRATION ROLE ENDPOINT}
    : FOR    ${permission}    IN    @{permissions}
    \    Log    ${permission}
    \    Next Request May Not Succeed
    \    Request Setup
    \    PUT    ${SECURITY ADMINISTRATION ROLE ENDPOINT}/${role_name}/permissions/${permission}

Create Role And Expect Error
    [Arguments]    ${role name}    ${role display name}    ${role description}    ${system role}    ${status code}
    [Documentation]    *Description*
    ...    This keyword attempts to create new user or entity role in E-WorkBook via the Security Administration Web Service and expects the request to fail.
    ...
    ...    *Arguments*
    ...    ${role name} = the role name of the role being created
    ...    ${role display name} = the role name of the role being created as used in the E-WorkBook thick client
    ...    ${role description} = the description of the role
    ...    ${system role} = whether the role is a system role ("true") or not ("false")
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    ...    Create Role And Expect Error | Role1 | Role 1 Display | Role 1 Description | false
    Request Setup
    Next Request Should Not Succeed
    Set Request Body    {"name":"${role name}","displayName":"${role display name}","description":"${role description}","systemRole":"${system role}"}
    POST    ${SECURITY ADMINISTRATION ROLE ENDPOINT}
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Create Role And Validate
    [Arguments]    ${role name}    ${role display name}    ${role description}    ${system role}
    Create Role    ${role name}    ${role display name}    ${role description}    ${system role}
    Validate Role    ${role name}    ${role display name}    ${role description}    ${system role}

Create User
    [Arguments]    ${user name}    ${user password}    ${full name}    ${email address}    ${department name}    ${assignable role level}=STANDARD_ROLES
    [Documentation]    Creates a new EWB User
    ...
    ...    *Preconditon*
    ...
    ...    None
    ...
    ...    *Arguments*
    ...
    ...    _user name_ - The new user name
    ...
    ...    _user password_ - The password to be applied to the user
    ...
    ...    _full name_ - The full name to be given to the user
    ...
    ...    _email address_ - The email address to be given to the user
    ...
    ...    _department name_ - The department value to be given to the user
    ...
    ...    _assignable role level - (OPTIONAL) - The assignable roles level to be given to the user. Defaults to STANDARD_ROLES
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    | Create User | User001 | User001Password | User01 Test | testuser@idbs.com | Testing |
    Request Setup
    Set Request Body    {"username":"${user name}","userfullname":"${full name}","emails":{"email":["${email address}"]},"department":"${department name}","password":"${user password}","assignablerolelevel":"${assignable role level}"}
    POST    ${SECURITY ADMINISTRATION USER ENDPOINT}

Create User And Expect Error
    [Arguments]    ${user name}    ${user password}    ${full name}    ${email address}    ${department name}    ${status code}
    ...    ${assignable role level}=STANDARD_ROLES
    [Documentation]    ${administrator user} removed - 20_02_12
    Request Setup
    Next Request Should Not Succeed
    Set Request Body    {"username":"${user name}","userfullname":"${full name}","emails":{"email":["${email address}"]},"department":"${department name}","password":"${user password}","assignablerolelevel":"${assignable role level}"}
    POST    ${SECURITY ADMINISTRATION USER ENDPOINT}
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Create User And Validate
    [Arguments]    ${user name}    ${user password}    ${full name}    ${email address}    ${department name}
    Create User    ${user name}    ${user password}    ${full name}    ${email address}    ${department name}
    Validate User    ${user name}    ${full name}    ${email address}    ${department name}

Create User Group
    [Arguments]    ${group name}    ${group description}
    [Documentation]    Creates a new EWB user group
    ...
    ...    *Preconditon*
    ...
    ...    None
    ...
    ...    *Arguments*
    ...
    ...    _group name_ - The new group \ name
    ...
    ...    _user password_ - The password to be applied to the user
    ...
    ...    _group description_ - The description of the user group
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    | Create Group | Group001 | Group001 Testing |
    Request Setup
    Set Request Body    {"name":"${group name}","description":"${group description}"}
    POST    ${SECURITY ADMINISTRATION GROUP ENDPOINT}
    ${RESPONSE BODY TEMP} =    Get Response Body
    Run Keyword Unless    '${RESPONSE BODY TEMP}'=='${Empty}'    Fail    ${RESPONSE BODY TEMP}
    ${RESPONSE BODY}=    Set Variable    ${RESPONSE BODY TEMP}
    Set Suite Variable    ${RESPONSE BODY}

Create User Group and Expect Error
    [Arguments]    ${group name}    ${group description}    ${status code}
    Request Setup
    Next Request Should Not Succeed
    Set Request Body    {"name":"${group name}","description":"${group description}"}
    POST    ${SECURITY ADMINISTRATION GROUP ENDPOINT}
    Response Status Code Should Equal    ${status code}
    ${RESPONSE BODY TEMP} =    Get Response Body
    ${RESPONSE BODY}=    Set Variable    ${RESPONSE BODY TEMP}
    Set Suite Variable    ${RESPONSE BODY}
    Next Request Should Succeed

Create User Group and Validate
    [Arguments]    ${group name}    ${group description}
    Create User Group    ${group name}    ${group description}
    Validate User Group Creation    ${group name}    ${group description}

Delete Role
    [Arguments]    ${role name}    ${deletion comment}
    [Documentation]    *Description*
    ...    This keyword deletes a user or entity role in E-WorkBook via the Security Administration Web Service.
    ...
    ...    *Arguments*
    ...    ${role name} = the role name of the role being created
    ...    ${deletion comment} = the description of the role
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    ...    Delete Role | Role1 | Role No Longer Required
    Request Setup
    #handle spaces in the deletion comment, replace with spaces
    ${deletion comment}=    Replace String    ${deletion comment}    \ \    +
    POST    ${SECURITY ADMINISTRATION ROLE ENDPOINT}/${role name}?comment=${deletion comment}

Delete Role And Expect Error
    [Arguments]    ${role name}    ${deletion comment}    ${status code}
    [Documentation]    *Description*
    ...    This keyword attempts to delete a user or entity role in E-WorkBook via the Security Administration Web Service and expects the request to fail.
    ...
    ...    *Arguments*
    ...    ${role name} = the role name of the role being created
    ...    ${deletion comment} = the description of the role
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    ...    Delete Role And Expect Error | Role1 | Role No Longer Required
    Request Setup
    #handle spaces in the deletion comment, replace with spaces
    ${deletion comment}=    Replace String    ${deletion comment}    \ \    +
    Next Request Should Not Succeed
    POST    ${SECURITY ADMINISTRATION ROLE ENDPOINT}/${role name}?comment=${deletion comment}
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    Check Role Present    ${role name}

Delete Role And Validate
    [Arguments]    ${role name}    ${deletion comment}
    Check Role Present    ${role name}
    Delete Role    ${role name}    ${deletion comment}
    Check Role Not Present    ${role name}

Delete User Entity Role
    [Arguments]    ${user name}    ${role name}    ${entity id}
    Request Setup
    Set Request Body    {"deletions" : {"entityAssignment" : [ {"entityId" : "${entity id}","roleName" : "${role name}","groupName" : "","userName" : "${user name}"}]}}
    POST    ${SECURITY ADMINISTRATION ASSIGNMENTS ENDPOINT}

Delete User Entity Role And Expect Error
    [Arguments]    ${user name}    ${role name}    ${entity id}    ${status code}
    Request Setup
    Next Request Should Not Succeed
    Set Request Body    {"deletions" : {"entityAssignment" : [ {"entityId" : "${entity id}","roleName" : "${role name}","groupName" : "","userName" : "${user name}"}]}}
    POST    ${SECURITY ADMINISTRATION ASSIGNMENTS ENDPOINT}
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Delete User Group
    [Arguments]    ${group name}
    Request Setup
    DELETE    ${SECURITY ADMINISTRATION GROUP ENDPOINT}/${group name}

Delete User Group And Expect Error
    [Arguments]    ${group name}    ${status code}
    Request Setup
    Next Request Should Not Succeed
    DELETE    ${SECURITY ADMINISTRATION GROUP ENDPOINT}/${group name}
    Response Status Code Should Equal    ${status code}
    Check User Group Present    ${group name}
    Next Request Should Succeed

Delete User Group Entity Role
    [Arguments]    ${group name}    ${role name}    ${entity id}
    Request Setup
    Set Request Body    {"deletions" : {"entityAssignment" : [ {"entityId" : "${entity id}","roleName" : "${role name}","groupName" : "${group name}","userName" : ""}]}}
    POST    ${SECURITY ADMINISTRATION ASSIGNMENTS ENDPOINT}

Delete User Group Entity Role And Expect Error
    [Arguments]    ${group name}    ${role name}    ${entity id}    ${status code}
    Request Setup
    Next Request Should Not Succeed
    Set Request Body    {"deletions" : {"entityAssignment" : [ {"entityId" : "${entity id}","roleName" : "${role name}","groupName" : "${group name}","userName" : ""}]}}
    POST    ${SECURITY ADMINISTRATION ASSIGNMENTS ENDPOINT}
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Delete User Group and Validate
    [Arguments]    ${group name}
    Check User Group Present    ${group name}
    Delete User Group    ${group name}
    Check User Group Not Present    ${group name}

Delete User System Role
    [Arguments]    ${user name}    ${role name}
    Request Setup
    DELETE    ${SECURITY ADMINISTRATION USER ENDPOINT}/${user name}/roles/${role name}
    Validate User System Permission Not Present    ${user name}    ${role name}

Delete User System Role And Expect Error
    [Arguments]    ${user name}    ${role name}    ${status code}
    Request Setup
    Next Request Should Not Succeed
    DELETE    ${SECURITY ADMINISTRATION USER ENDPOINT}/${user name}/roles/${role name}
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Disable User
    [Arguments]    ${user name}    ${comment}
    Request Setup
    Set Request Body    {"deleteordisable":"true","comments":"${comment}"}
    POST    ${SECURITY ADMINISTRATION USER ENDPOINT}/${user name}/activation

Disable User And Expect Error
    [Arguments]    ${user name}    ${comment}    ${status code}
    Request Setup
    Next Request Should Not Succeed
    Set Request Body    {"deleteordisable":"true","comments":"${comment}"}
    POST    ${SECURITY ADMINISTRATION USER ENDPOINT}/${user name}/activation
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Enable User
    [Arguments]    ${user name}
    Request Setup
    Set Request Body    {"deleteordisable":"false","comments":"Enabled User"}
    POST    ${SECURITY ADMINISTRATION USER ENDPOINT}/${user name}/activation

Enable User And Expect Error
    [Arguments]    ${user name}    ${status code}
    Request Setup
    Next Request Should Not Succeed
    Set Request Body    {"deleteordisable":"false","comments":"Enabled User"}
    POST    ${SECURITY ADMINISTRATION USER ENDPOINT}/${user name}/activation
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Ensure Role has Permission
    [Arguments]    ${role name}    ${permission name}
    Request Setup
    PUT    ${SECURITY ADMINISTRATION ROLE ENDPOINT}/${role name}/permissions/${permission name}
    Check Permission Assigned To Role    ${role name}    ${permission name}

Remove Role Permission
    [Arguments]    ${role name}    ${permission name}
    Check Permission Assigned To Role    ${role name}    ${permission name}
    Request Setup
    DELETE    ${SECURITY ADMINISTRATION ROLE ENDPOINT}/${role name}/permissions/${permission name}
    Check Permission Not Assigned To Role    ${role name}    ${permission name}

Remove Role Permission And Expect Error
    [Arguments]    ${role name}    ${permission name}    ${status code}
    Request Setup
    Next Request Should Not Succeed
    DELETE    ${SECURITY ADMINISTRATION ROLE ENDPOINT}/${role name}/permissions/${permission name}
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    Check Permission Assigned To Role    ${role name}    ${permission name}

Remove Role Permission And Expect Error No Role Check
    [Arguments]    ${role name}    ${permission name}    ${status code}
    Request Setup
    Next Request Should Not Succeed
    DELETE    ${SECURITY ADMINISTRATION ROLE ENDPOINT}/${role name}/permissions/${permission name}
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Remove User Group Admin
    [Arguments]    ${group name}    ${user name}
    Check User Admin of User Group    ${group name}    ${user name}
    Request Setup
    DELETE    ${SECURITY ADMINISTRATION GROUP ENDPOINT}/${group name}/admin/${user name}
    Check User Not Admin of User Group    ${group name}    ${user name}

Remove User Group Admin And Expect Error
    [Arguments]    ${group name}    ${user name}    ${status code}
    Check User Admin of User Group    ${group name}    ${user name}
    Request Setup
    Next Request Should Not Succeed
    DELETE    ${SECURITY ADMINISTRATION GROUP ENDPOINT}/${group name}/admin/${user name}
    Response Status Code Should Equal    ${status code}
    Check User Admin of User Group    ${group name}    ${user name}
    Next Request Should Succeed

Remove User Group Member
    [Arguments]    ${group name}    ${user name}
    Check User Member of User Group    ${group name}    ${user name}
    Request Setup
    DELETE    ${SECURITY ADMINISTRATION GROUP ENDPOINT}/${group name}/member/${user name}
    Check User Not Member of User Group    ${group name}    ${user name}

Remove User Group Member And Expect Error
    [Arguments]    ${group name}    ${user name}    ${status code}
    Check User Member of User Group    ${group name}    ${user name}
    Request Setup
    Next Request Should Not Succeed
    DELETE    ${SECURITY ADMINISTRATION GROUP ENDPOINT}/${group name}/member/${user name}
    Response Status Code Should Equal    ${status code}
    Check User Member of User Group    ${group name}    ${user name}
    Next Request Should Succeed

Request Setup
    Create HTTP Context    ${SERVER}:${WEB_SERVICE_PORT}    https
    Set Basic Auth    ${SERVICES USERNAME}    ${SERVICES PASSWORD}
    Set Request Header    Accept    application/json;charset=utf-8
    Set Request Header    Content-Type    application/json;charset=utf-8

Reset Users Password
    [Arguments]    ${user name}
    Request Setup
    POST    ${SECURITY ADMINISTRATION USER ENDPOINT}/${user name}/resetpassword
    ${RESPONSE BODY TEMP} =    Get Response Body
    ${RESPONSE BODY}=    Set Variable    ${RESPONSE BODY TEMP}
    Set Suite Variable    ${RESPONSE BODY}
    Log    ${RESPONSE BODY}

Reset Users Password And Expect Error
    [Arguments]    ${user name}    ${status code}
    Request Setup
    Next Request Should Not Succeed
    POST    ${SECURITY ADMINISTRATION USER ENDPOINT}/${user name}/resetpassword
    Response Status Code Should Equal    ${status code}
    ${RESPONSE BODY TEMP} =    Get Response Body
    Next Request Should Succeed
    ${RESPONSE BODY}=    Set Variable    ${RESPONSE BODY TEMP}
    Set Suite Variable    ${RESPONSE BODY}
    Log    ${RESPONSE BODY}

Update Role
    [Arguments]    ${role name}    ${role description}
    [Documentation]    *Description*
    ...    This keyword updates a user or entity role in E-WorkBook via the Security Administration Web Service.
    ...
    ...    *Arguments*
    ...    ${role name} = the role name of the role being created
    ...    ${role description} = the description of the role
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    ...    Update Role | Role1 | Role 1 Updated \ Description
    Request Setup
    Set Request Body    {"description":"${role description}"}
    PUT    ${SECURITY ADMINISTRATION ROLE ENDPOINT}/${role name}

Update Role And Expect Error
    [Arguments]    ${role name}    ${role description}    ${status code}
    [Documentation]    *Description*
    ...    This keyword attempts to update a user or entity role in E-WorkBook via the Security Administration Web Service and expects the request to fail.
    ...
    ...    *Arguments*
    ...    ${role name} = the role name of the role being created
    ...    ${role description} = the description of the role
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    ...    Update Role And Expect Error | Role1 | Role 1 Updated \ Description
    Request Setup
    Next Request Should Not Succeed
    Set Request Body    {"description":"${role description}"}
    PUT    ${SECURITY ADMINISTRATION ROLE ENDPOINT}/${role name}
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Update Role And Validate
    [Arguments]    ${role name}    ${role display name}    ${role description}    ${system role}
    Update Role    ${role name}    ${role description}
    Validate Role    ${role name}    ${role display name}    ${role description}    ${system role}

Update User
    [Arguments]    ${user name}    ${full name}    ${email address}    ${department name}    ${assignable role level}=STANDARD_ROLES
    Request Setup
    Set Request Body    {"userfullname":"${full name}","emails":{"email":["${email address}"]},"department":"${department name}","assignablerolelevel":"${assignable role level}"}
    POST    ${SECURITY ADMINISTRATION USER ENDPOINT}/${user name}

Update User And Expect Error
    [Arguments]    ${user name}    ${full name}    ${email address}    ${department name}    ${status code}    ${assignable role level}=STANDARD_ROLES
    Request Setup
    Next Request Should Not Succeed
    Set Request Body    {"userfullname":"${full name}","emails":{"email":["${email address}"]},"department":"${department name}","assignablerolelevel":"${assignable role level}"}
    POST    ${SECURITY ADMINISTRATION USER ENDPOINT}/${user name}
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Update User Group
    [Arguments]    ${group name}    ${new group description}
    Request Setup
    Set Request Body    {"description":"${new group description}"}
    PUT    ${SECURITY ADMINISTRATION GROUP ENDPOINT}/${group name}
    ${RESPONSE BODY TEMP} =    Get Response Body
    Run Keyword Unless    '${RESPONSE BODY TEMP}'=='${Empty}'    Fail    ${RESPONSE BODY TEMP}
    ${RESPONSE BODY}=    Set Variable    ${RESPONSE BODY TEMP}
    Set Suite Variable    ${RESPONSE BODY}

Update User Group And Expect Error
    [Arguments]    ${group name}    ${new group description}    ${status code}
    Request Setup
    Next Request Should Not Succeed
    Set Request Body    {"description":"${new group description}"}
    PUT    ${SECURITY ADMINISTRATION GROUP ENDPOINT}/${group name}
    Response Status Code Should Equal    ${status code}
    ${RESPONSE BODY TEMP} =    Get Response Body
    ${RESPONSE BODY}=    Set Variable    ${RESPONSE BODY TEMP}
    Set Suite Variable    ${RESPONSE BODY}

Update User Group And Validate
    [Arguments]    ${group name}    ${new group description}
    Check User Group Present    ${group name}
    Update User Group    ${group name}    ${new group description}
    Validate User Group Creation    ${group name}    ${new group description}

Validate Role
    [Arguments]    ${role name}    ${role display name}    ${role description}    ${system role}
    Request Setup
    GET    ${SECURITY ADMINISTRATION ROLE ENDPOINT}/${role name}
    ${RESPONSE BODY TEMP} =    Get Response Body
    ${RESPONSE BODY}=    Set Variable    ${RESPONSE BODY TEMP}
    Set Suite Variable    ${RESPONSE BODY}
    ${Response Role Name}=    Get Json Value    ${RESPONSE BODY}    /name
    ${Response Role Display Name}=    Get Json Value    ${RESPONSE BODY}    /displayName
    ${Response Role Description}=    Get Json Value    ${RESPONSE BODY}    /description
    ${Response System Role}=    Get Json Value    ${RESPONSE BODY}    /systemRole
    Should Be Equal    ${Response Role Name}    "${role name}"
    Should Be Equal    ${Response Role Display Name}    "${role display name}"
    Should Be Equal    ${Response Role Description}    "${role description}"
    Should Be Equal    ${Response System Role}    ${system role}

Validate User
    [Arguments]    ${user name}    ${full name}    ${email address}    ${department name}
    Request Setup
    GET    ${SECURITY ADMINISTRATION USER ENDPOINT}/${user name}
    ${RESPONSE BODY TEMP} =    Get Response Body
    ${RESPONSE BODY}=    Set Variable    ${RESPONSE BODY TEMP}
    Set Suite Variable    ${RESPONSE BODY}
    ${Response User Name}=    Get Json Value    ${RESPONSE BODY}    /userName
    ${Response User Full Name}=    Get Json Value    ${RESPONSE BODY}    /userFullName
    ${Response User Email}=    Get Json Value    ${RESPONSE BODY}    /emails/email
    ${Response User Department}=    Get Json Value    ${RESPONSE BODY}    /department
    Comment    ${Response User Administrator}=    Get Json Value    ${RESPONSE BODY}    /administrator
    Should Be Equal    ${Response User Name}    "${user name}"
    Should Be Equal    ${Response User Full Name}    "${full name}"
    Should Be Equal    ${Response User Email}    ["${email address}"]
    Should Be Equal    ${Response User Department}    "${department name}"
    Comment    Should Be Equal    ${Response User Administrator}    ${administrator user}

Validate User Group Creation
    [Arguments]    ${group name}    ${group description}
    Request Setup
    GET    ${SECURITY ADMINISTRATION GROUP ENDPOINT}/${group name}
    ${RESPONSE BODY TEMP} =    Get Response Body
    ${RESPONSE BODY}=    Set Variable    ${RESPONSE BODY TEMP}
    Set Suite Variable    ${RESPONSE BODY}
    ${Response Group Name}=    Get Json Value    ${RESPONSE BODY TEMP}    /name
    ${Response Group Description}=    Get Json Value    ${RESPONSE BODY TEMP}    /description
    Should Be Equal    ${Response Group Name}    "${group name}"
    Should Be Equal    ${Response Group Description}    "${group description}"

Validate User System Permission Not Present
    [Arguments]    ${user name}    ${system role name}
    Request Setup
    GET    ${SECURITY ADMINISTRATION USER ENDPOINT}/${user name}
    ${RESPONSE BODY TEMP} =    Get Response Body
    ${RESPONSE BODY}=    Set Variable    ${RESPONSE BODY TEMP}
    Set Suite Variable    ${RESPONSE BODY}
    ${status}    ${Response User Permissions All}=    Run Keyword And Ignore Error    Get Json Value    ${RESPONSE BODY}    /systemRoles
    Run Keyword If    '${status}'=='FAIL'    Should Contain    ${Response User Permissions All}    JsonPointerException: member 'systemRoles' not found
    ${Response User Permissions}=    Run Keyword If    '${status}'=='PASS'    Get Json Value    ${RESPONSE BODY}    /systemRoles/name
    Run Keyword If    '${status}'=='PASS'    Should Not Contain    ${Response User Permissions}    "${system role name}"

Validate User System Permission Present
    [Arguments]    ${user name}    ${system role name}
    Request Setup
    GET    ${SECURITY ADMINISTRATION USER ENDPOINT}/${user name}
    ${RESPONSE BODY TEMP} =    Get Response Body
    ${RESPONSE BODY}=    Set Variable    ${RESPONSE BODY TEMP}
    Set Suite Variable    ${RESPONSE BODY}
    ${Response User Permissions}=    Get Json Value    ${RESPONSE BODY}    /systemRoles/name
    Should Contain    ${Response User Permissions}    "${system role name}"

Create User And Don't Fail If It Exists
    [Arguments]    ${username}    ${password}    ${full_name}    ${email_address}    ${department_name}    ${assignable_role_level}=STANDARD_ROLES
    [Documentation]    Creates a user. If the user already exists the keyword will not fail.
    ...
    ...    *Arguments*
    ...    - _username_: The user name
    ...    - _password_: The user password
    ...
    ...    *Returns*
    ...
    ...    - The response HTTP status line (e.g. "200 OK" or "404 Not found")
    ${http_request_body}=    Set Variable    {"username":"${username}","userfullname":"${full_name}","emails":{"email":["${email_address}"]},"department":"${department_name}","password":"${password}","assignablerolelevel":"${assignable_role_level}"}
    HTTP Header Setup With Custom User    ${SERVICES USERNAME}    ${SERVICES PASSWORD}
    Set Request Body    ${http_request_body}
    Next Request May Not Succeed
    POST    ${SECURITY ADMINISTRATION USER ENDPOINT}
    ${http_response_status}=    Get Response Status
    [Return]    ${http_response_status}    # The response status line (e.g. "200 OK" or "404 Not found")
