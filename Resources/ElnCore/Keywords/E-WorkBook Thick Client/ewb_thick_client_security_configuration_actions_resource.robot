*** Settings ***
Resource          ewb_thick_client_general_actions_resource.robot

*** Keywords ***
Assign Entity Role
    [Arguments]    ${username}    ${path}    ${role}
    Select Dialog    Security
    Wait for glass pane to disappear
    Wait Until Keyword Succeeds    120s    1s    Select Tab as context    Entity Security
    ${pipe_separated_path}=    Replace String    ${path}    /    |
    Clear Tree Selection    ENTITY_TREE
    Select Tree Node    ENTITY_TREE    ${pipe_separated_path}
    Select Dialog    Security
    Wait for glass pane to disappear
    Select Tab as context    Entity Security
    Push Button    AddAllUsersButton
    Sleep    2s
    Log    ${username}
    ${user_row}=    __Find user in table of users    USER_TABLE    User/Group    ${username}
    Run Keyword If    ${user_row}==-1    Fail    User ${username} does not exist in the list of users.
    Click On Table Cell    USER_TABLE    ${user_row}    1
    ${role_row}=    __Find role in table of roles    ROLE_TABLE    ${role}
    Click On Table Cell    ROLE_TABLE    ${role_row}    0
    Push Button    AddAssignmentButton
    Select Dialog    Security
    Wait for glass pane to disappear
    Select Tab as context    Entity Security

Close security dialog
    Close Dialog    Security
    Select E-WorkBook Main Window

Create New User
    [Arguments]    ${username}    ${full_name}    ${department}    ${email}    ${can_assign_userroles}    @{user_roles}
    Select Dialog    Security
    Wait for glass pane to disappear
    Wait Until Keyword Succeeds    120s    1s    Select Tab as context    Users
    Sleep    1s
    ${user_row}=    __Find user in table of users    Users${SPACE}Table    User name    ${username}
    Run Keyword If    ${user_row}!=-1    Fail    User ${username} already exists.
    Push Button    NewUserButton
    Select Dialog    Create New User
    Insert Into Text Field    User Name Field    ${username}
    Insert Into Text Field    Full Name Field    ${full_name}
    Insert Into Text Field    Department Field    ${department}
    Insert Into Text Field    Email Field    ${email}
    : FOR    ${user_role}    IN    @{user_roles}
    \    Check Check Box    text=${user_role}
    Log    ${can_assign_userroles}
    Run Keyword If    '${can_assign_userroles}'=='True'    Select Tab    Assignable Roles
    Run Keyword If    '${can_assign_userroles}'=='True'    Check Check Box    text=Allow Any User Roles to Be Assigned
    Run Keyword If    '${can_assign_userroles}'=='True'    Check Check Box    text=Allow Any Entity Roles to Be Assigned
    Push Button    OK

Open security dialog
    Select E-WorkBook Main Window
    Wait Until Keyword Succeeds    60 seconds    2 seconds    Select from E-WorkBook Main Menu    Tools    Security\.\.\.
    Select Dialog    Security
    Wait for glass pane to disappear
    Sleep    1s    Give dialog time to draw itself

__Find role in table of roles
    [Arguments]    ${table_identifier}    ${rolename}
    ${number_of_rows}=    Get Table Row Count    ${table_identifier}
    ${contains_role}=    Set Variable    FAIL    #Initialise variable
    : FOR    ${role_row}    IN RANGE    ${number_of_rows}
    \    ${current_role}=    Get Table Cell Value    ${table_identifier}    ${role_row}    0
    \    ${contains_role}    ${message}=    Run Keyword And Ignore Error    Should Be Equal As Strings    ${current_role}    ${rolename}
    \    Run Keyword If    '${contains_role}'=='PASS'    Exit For Loop
    ${row_number}=    Set Variable If    '${contains_role}'=='PASS'    ${role_row}    -1
    [Return]    ${row_number}

__Find user in table of users
    [Arguments]    ${table_identifier}    ${column}    ${username}
    ${number_of_rows}=    Get Table Row Count    ${table_identifier}
    ${contains_username}=    Set Variable    FAIL    #Initialise variable
    : FOR    ${user_row}    IN RANGE    ${number_of_rows}
    \    ${current_username}=    Get Table Cell Value    ${table_identifier}    ${user_row}    ${column}
    \    ${contains_username}    ${message}=    Run Keyword And Ignore Error    Should Be Equal As Strings    ${current_username}    ${username}
    \    Run Keyword If    '${contains_username}'=='PASS'    Exit For Loop
    ${row_number}=    Set Variable If    '${contains_username}'=='PASS'    ${user_row}    -1
    [Return]    ${row_number}
