*** Settings ***
Documentation    Suite description
Resource          ../Navigation/Resource Objects/NavTree.robot
Resource          ../Navigation/Resource Objects/AuditLog.robot
Resource          ../Navigation/HomePage.robot

*** Keywords ***
Go To Root
    [Documentation]    Clicks the "Root" node in the navigator tree
    Robust Link Click    Root
    Wait Until Page Contains Element    xpath=//a[contains(@class, 'ewb-breadcrumb-terminal') and contains(text(), 'Root')]    30s

Navigate to Administrators Group
    Select Administrator Group Node

Navigate to Group
    [Arguments]    ${group_name}
    Select Group Node    ${group_name}

Select Audit History
    [Arguments]    ${experiment_name}
    set selenium speed    2
    NavTree.Select Record Options Menu    ${experiment_name}
    NavTree.Select Audit History Menu Option
    AuditLog.Select Audit Window
    Wait until Keyword succeeds    5mins    2s    AuditLog.Check Header Title Exists
    set selenium speed    1

Create Project
    [Arguments]    ${PROJECT_NAME}
    ${project_exists}=    NavTree.Check Node is Visible     ${PROJECT_NAME}
    Run Keyword Unless    ${project_exists}    HomePage.Create New Project     ${PROJECT_NAME}
    Run Keyword Unless    ${project_exists}    HomePage.Verify Node Selected     ${PROJECT_NAME}

Create Group
    [Arguments]    ${GROUP_NAME}
    ${group_exists}=    NavTree.Check Node is Visible     ${GROUP_NAME}
    Run Keyword Unless    ${group_exists}    HomePage.Create New Group    ${GROUP_NAME}
    Run Keyword Unless    ${group_exists}    HomePage.Verify Node Selected     ${GROUP_NAME}

Create New Blank Experiment from Nav Tree
    [Arguments]    ${project_name}    ${experiment_name}
    #Select New Tile
    NavTree.Select Create New Experiment from Nav Tree    ${project_name}
    #Enter Mandatory Field - Project Name
    Enter New Experiment Name    ${experiment_name}
    Save Properties
    Select Save As Button
    Select Discard Changes

Click on Text Item Tree Node
    NavTree.Select Item Node    Text

Click on Spreadsheet Item Tree Node
    [Arguments]    ${spreadsheet_name}
    NavTree.Select Item Node    ${spreadsheet_name}

Select Delete Option
    Robust Click    xpath=//*[@id='ewb-entity-command-delete']/a[contains(text(),'Delete')