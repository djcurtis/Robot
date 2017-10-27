*** Settings ***
Resource          ewb_thick_client_general_actions_resource.robot
Library           IDBSSwingLibrary
Library           RobotRemoteAgent
Library           String

*** Keywords ***
Copy Hierarchy Entity
    [Arguments]    ${source_path}    ${destination_container}    ${destination_name}
    ${pipe_separated_destination_container}=    Replace String    ${destination_container}    /    |
    ${old_timeout}=    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    1
    Tree Node Should Not Exist    class=WorkbenchNavigatorTree    ${pipe_separated_destination_container}|${destination_name}
    Select From Navigator Tree Right-click Menu    ${source_path}    .*Copy\\.\\.\\..* \ \ \ \ \
    Select Dialog    Copy Hierarchy    5
    Push Button    text=...
    Select Dialog    Select 'Copy to' destination    5
    Wait Until Keyword Succeeds    60s    1s    Tree Node Should Exist    class=NavigatorTree    ${pipe_separated_destination_container}
    Select Tree Node    class=NavigatorTree    ${pipe_separated_destination_container}
    Robust close dialog    Select 'Copy to' destination    OK
    Select Dialog    Copy Hierarchy    5
    Insert Into Text Field    title_editor    ${destination_name}
    Push Button    OK
    Sleep    2s    Wait for copy to start
    Select E-WorkBook Main Window
    Check Item Exists in navigator Tree    ${pipe_separated_destination_container}|${destination_name}    300s
    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    ${old_timeout}

Create Folder
    [Arguments]    ${group_name}    ${project_name}    ${folder_name}
    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    1
    Tree Node Should Exist    class=WorkbenchNavigatorTree    Root|${group_name}
    Tree Node Should Exist    class=WorkbenchNavigatorTree    Root|${group_name}|${project_name}
    Tree Node Should Not Exist    class=WorkbenchNavigatorTree    Root|${group_name}|${project_name}|${folder_name}
    Select From Navigator Tree Right-click Menu    Root|${group_name}|${project_name}    New|Folder...
    Select Dialog    New Folder
    Insert Into Text Field    name_editor    ${folder_name}
    Push Button    OK
    Select E-WorkBook Main Window
    Wait Until Keyword Succeeds    60 seconds    0.5 seconds    Tree Node Should Exist    class=WorkbenchNavigatorTree    Root|${group_name}|${project_name}|${folder_name}

Create Group
    [Arguments]    ${group_name}
    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    1
    Tree Node Should Not Exist    class=WorkbenchNavigatorTree    Root|${group_name}
    Select From Navigator Tree Right-click Menu    Root    New|Group...
    Select Dialog    New Group
    Insert Into Text Field    name_editor    ${group_name}
    Push Button    OK
    Select E-WorkBook Main Window
    Wait Until Keyword Succeeds    60 seconds    0.5 seconds    Tree Node Should Exist    class=WorkbenchNavigatorTree    Root|${group_name}

Create Hierarchy Entity
    [Arguments]    ${entity_type}    ${parent_path}    ${name}
    ${pipe_separated_parent_path}=    Replace String    ${parent_path}    /    |
    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    1
    Tree Node Should Exist    class=WorkbenchNavigatorTree    ${pipe_separated_parent_path}
    Tree Node Should Not Exist    class=WorkbenchNavigatorTree    ${pipe_separated_parent_path}|${name}
    Select From Navigator Tree Right-click Menu    ${pipe_separated_parent_path}    New|${entity_type}...
    Select Dialog    New ${entity_type}
    Insert Into Text Field    0    ${name}
    Push Button    OK
    Select E-WorkBook Main Window
    Wait Until Keyword Succeeds    60    0.5    Tree Node Should Exist    class=WorkbenchNavigatorTree    ${pipe_separated_parent_path}|${name}

Create Project
    [Arguments]    ${group_name}    ${project_name}
    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    1
    Tree Node Should Exist    class=WorkbenchNavigatorTree    Root|${group_name}
    Tree Node Should Not Exist    class=WorkbenchNavigatorTree    Root|${group_name}|${project_name}
    Select From Navigator Tree Right-click Menu    Root|${group_name}    New|Project...
    Select Dialog    New Project
    Insert Into Text Field    title_editor    ${project_name}
    Push Button    OK
    Select E-WorkBook Main Window
    Wait Until Keyword Succeeds    60 seconds    0.5 seconds    Tree Node Should Exist    class=WorkbenchNavigatorTree    Root|${group_name}|${project_name}
