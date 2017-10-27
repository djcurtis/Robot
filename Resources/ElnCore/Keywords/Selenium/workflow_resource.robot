*** Settings ***
Documentation     Resource file containing keywords specific to workflows
Library           IDBSSelenium2Library
Resource          general_resource.robot
Resource          task_view_resources.robot

*** Variables ***
${sign-record-workflow}    ewb-record-outline-sign-off-workflow

*** Keywords ***
Select Sign Off Workflow Option
    [Arguments]    ${workflow-name}
    Robust Click    xpath=//div[@id='${sign-record-workflow}']//img    image
    Robust Click    xpath=//div[@class='ewb-workflow-item']/div[@class='name' and text()="${workflow-name}"]

Select No Workflow Option
    ${result}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=//div[@id='${sign-record-workflow}']//img    5s
    Run Keyword If    ${result}    Robust Click    xpath=//div[@id='${sign-record-workflow}']//img    image
    Run Keyword If    ${result}    Robust Click    xpath=//div[@class='ewb-workflow-item-dont-start']

Add Record To Favorites Via Menu
    [Arguments]    ${recordId}
    [Documentation]    Add Record To Favorites Via Menu
    ...    - Navigate to Experiment by ${recordId}
    ...    - Set It as favorite via UI
    Go To Experiment    ${recordId}
    Open Record Header Tool Menu    ewb-editor-command-add-record-to-favorites

Check Workflow Type List Contains Workflows
    [Arguments]    ${workflowType}    @{workflowIds}
    [Documentation]    Check Workflow Type List Contains Workflows
    ...    - select workflow type by name
    ...    - verify that expected workflow list is displayed
    Robust Click    xpath=//div[@class='ewb-tasks-workflows-standard-filters']//span[text()='${workflowType}']
    : FOR    ${id}    IN    @{workflowIds}
    \    Wait Until Element Is Visible    ewb-workflows-list-info-${id}-link    10s

Check Workflow Type List Does Not Contain Workflows
    [Arguments]    ${workflowType}    @{workflowIDs}
    [Documentation]    Check Workflow Type List Does Not Contain Workflows
    ...    - select workflow type by name
    ...    - verify that workflow list is not displayed
    Robust Click    xpath=//div[@class='ewb-tasks-workflows-standard-filters']//span[text()='${workflowType}']
    : FOR    ${id}    IN    @{workflowIds}
    \    log    ewb-workflows-list-info-${id}-link
    \    Wait Until Page Does Not Contain Element    css=#ewb-workflows-list-info-${id}-link    10s

Create Workflow With Task For Experiment
    [Arguments]    ${experimentId}    ${workflowName}
    [Documentation]    Create Workflow With Task For Experiment
    ...    - create workflow by workflow name for experiment with ${experimentId}
    ...    - create a task for the worflow
    ${workflowId}    Task View Create Workflow for Entity    ${experimentId}    ${workflowName}
    ${workflow tasks}    Get Workflow Tasks    ${workflowId}
    ${taskId}=    Task View First Task Id In Workflow Is    ${workflow tasks}
    [Return]    ${workflowId}    ${taskId}

Open Workflow For Favorite
    [Documentation]    Open Workflow For Favorite
    ...    - open favorites entity via UI
    Robust Click    css=.ewb-entity-treenode-type-user_favorites > table .ewb-entity-treenode-menu-image
    Robust Click    css=#ewb-entity-command-workflows

Open Workflow For Favorite Entity
    [Arguments]    ${experimentId}
    [Documentation]    Open Workflow For Favorite Entity
    ...    - show workflow for specific entity from favorites
    ...    - favorites entity should be expanded
    Click Element    //div[@class='ewb-entity-treenode-type-user_favorites']//a[contains(@href,'${experimentId}') and contains(text(),'')]
    Click Element    //div[@class='ewb-entity-treenode-type-user_favorites']//a[contains(@href,'${experimentId}') and contains(text(),'')]/../../..//img[@title='Display menu']
    Robust Click    css=#ewb-entity-command-workflows

Show Workflow For Entity
    [Arguments]    ${entityId}
    [Documentation]    Open Workflow For Entity
    ...    - show workflow for specific entity from hierarchy
    Click Element    //div[@class='ewb-entity-treenode-type-group']//div[contains(@class,'ewb-entity-treenode-text')]/a[contains(@href,'${entityId}')]
    Click Element    //div[@class='ewb-entity-treenode-type-group']//div[contains(@class,'ewb-entity-treenode-text')]/a[contains(@href,'${entityId}')]/../../..//img[@title='Display menu']
    Robust Click    css=#ewb-entity-command-workflows
