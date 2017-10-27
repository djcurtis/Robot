*** Settings ***
Documentation     E-WorkBook keyword library for workflow actions.
Resource          ewb_thick_client_general_actions_resource.robot
Resource          ewb_thick_client_record_entity_actions_resource.robot
Library           IDBSSwingLibrary



*** Keywords ***
Accept opened task
    [Documentation]    This keyword accepts the currently openned task.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with a task dialog being shown. The `Open Task` can be used to open the task dialog for the task being modified.
    ...
    ...    *Example*
    ...    | Accept opened task |
    Select Dialog    regexp=Task:.*
    Push Button    TaskInteractionDialog_actions_dropdown
    Select From Visible Popup Menu    class=JPopupMenu    Accept Task

Action opened task with sign off of all items
    [Arguments]    ${username}    ${password}    ${reason}
    [Documentation]    This keyword actions the currently openned task and performs a sign-off on all the exoeriment items.
    ...
    ...    *Arguments*
    ...    _reason_
    ...    Resaon to use for the sign-off.
    ...
    ...    _username_
    ...    The username for the sign-off
    ...
    ...    _password_
    ...    The password for the sign-off
    ...
    ...    *Return value*
    ...    ${action_timestamp}
    ...    The timestamp at which the sign-off was performed.
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with a task dialog being shown. The `Open Task` can be used to open the task dialog for the task being modified.
    ...
    ...    *Example*
    ...    | ${action_timestamp}= | Action opened task with sign off of all items | reason=Review Completed | username=${BIOCHEM_REVIEW_USER} | password=${BIOCHEM_REVIEW_PASSWORD} |
    Select Dialog    regexp=Task:.*
    Push Button    text=Action Task
    Select Dialog    regexp=Sign.*
    Push Button    signAllButton
    ${action_timestamp}=    __Sign-off all items    ${reason}    ${username}    ${password}    ${EMPTY}
    [Return]    ${action_timestamp}

Add comment to opened task
    [Arguments]    ${comment}
    [Documentation]    This keyword add as comment to the currently openned task.
    ...
    ...    *Arguments*
    ...    _comment_
    ...    The text of the comment to add.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with a task dialog being shown. The `Open Task` can be used to open the task dialog for the task being modified.
    ...
    ...    *Example*
    ...    | Add comment to opened task | This is a very short and informative comment on this task |
    Select Dialog    regexp=Task:.*
    ${result}    ${message}=    Run Keyword And Ignore Error    Component Should Be Visible    Add Comment
    Run Keyword If    "${result}"!="PASS"    Click On Component    xpathwithchildren=//component[contains(@class,'JCollapsiblePanel') and children/descendant::button[@name='Add Comment']]
    Sleep    2s    Give Comment section time to expand
    Push Button    Add Comment
    Select Dialog    Enter Comments
    Insert Into Text Field    0    ${comment}
    Push Button    OK
    Select Dialog    regexp=Task:.*
    Sleep    2s    Give the animation time to run

Add to Task User Pool
    [Arguments]    @{users_or_groups}
    Select Dialog    New Task Configuration    5
    : FOR    ${current_user_or_group}    IN    @{users_or_groups}
    \    Click On Component    xpath=//*[contains(@class,"UserOrGroupLookup")]//*[contains(@class,"BasicLookupComponentUI")]
    \    Insert Into Text Field    xpath=//*[contains(@class,"UserOrGroupLookup")]//*[contains(@class,"BasicLookupComponentUI")]    ${current_user_or_group}
    \    Focus To Component    xpath=//*[contains(@class,"UserOrGroupLookup")]//*[contains(@class,"BasicLookupComponentUI")]
    \    Send Keyboard Event    VK_ENTER
    \    Wait Until Keyword Succeeds    60s    1s    Component Should Be Visible    class=JPopupMenu
    \    sleep    2s
    \    Focus To Component    class=JPopupMenu
    \    Send Keyboard Event    VK_ENTER
    \    sleep    2s
    \    Push Button    AddUserButton

Check opened task has comment
    [Arguments]    ${comment}
    [Documentation]    This keyword verifes that the currently openned task has the given comment.
    ...
    ...    *Arguments*
    ...    _comment_
    ...    The text of the comment to check for.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with a task dialog being shown. The `Open Task` can be used to open the task dialog for the task being modified.
    ...
    ...    *Example*
    ...    | Check opened task has comment | This is a very short and informative comment on this task |
    Select Dialog    regexp=Task:.*
    ${result}    ${message}=    Run Keyword And Ignore Error    Component Should Be Visible    Add Comment
    Run Keyword If    "${result}"!="PASS"    Click On Component    xpathwithchildren=//component[contains(@class,'JCollapsiblePanel') and children/descendant::button[@name='Add Comment']]
    ${all_comment_text}=    Get Text Field Value    xpath=//*[contains(@class,'JTextArea')]
    Check String Contains    Check that comment text appears in all the comments    ${all_comment_text}    ${comment}

Check task does not exist
    [Arguments]    ${path}    ${status}    ${tasktype}    ${requester}    ${view}=My Tasks
    [Documentation]    This keyword checks that a task matching the specified values DOES NOT exists in the view given by ${view}. In order to allow for the delays in processing taks, the keyword will try for 90 seconds before giving up and failing, if a task still exists.
    ...
    ...    *Arguments*
    ...    _path_
    ...    Enity for which the workflow has been created.
    ...
    ...    _status_
    ...    The current status of the task that is being checked for.
    ...
    ...    _takstype_
    ...    The value of the task-type column.
    ...
    ...    _requester_
    ...    The value of the requester column.
    ...
    ...    _view_
    ...    [optional] The view in which to look for the taks. By default the "My Tasks" view is used.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window.
    ...
    ...    *Example*
    ...    | Check task does not exist | view=My Tasks | path=${experiment_path} | status=New | takstype=Sign Off | requester=Biochem |
    __Open task view tab    ${view}
    Wait Until Keyword Succeeds    10min    20s    __Task should not be in task table    ${path}    ${status}    ${tasktype}
    ...    ${requester}

Check task exists
    [Arguments]    ${path}    ${status}    ${tasktype}    ${requester}    ${view}=My Tasks
    [Documentation]    This keyword checks that a task matching the specified values exists in the view given by ${view}. In order to allow for the delays in processing taks, the keyword will try for 90 seconds before giving up and failing.
    ...
    ...    *Arguments*
    ...    _path_
    ...    Enity for which the workflow has been created.
    ...
    ...    _status_
    ...    The current status of the task that is being checked for.
    ...
    ...    _takstype_
    ...    The value of the task-type column.
    ...
    ...    _requester_
    ...    The value of the requester column.
    ...
    ...    _view_
    ...    [optional] The view in which to look for the taks. By default the "My Tasks" view is used.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window.
    ...
    ...    *Example*
    ...    | Check task exists | view=My Tasks | path=${experiment_path} | status=New | takstype=Sign Off | requester=Biochem |
    __Open task view tab    ${view}
    Wait Until Keyword Succeeds    10min    20s    __Find task in task table    ${path}    ${status}    ${tasktype}
    ...    ${requester}

Close opened task
    [Documentation]    This keyword clicks the close button on the currently openned task.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with a task dialog being shown. The `Open Task` can be used to open the task dialog for the task being modified.
    ...
    ...    *Example*
    ...    | Close opened task |
    Select Dialog    regexp=Task:.*
    Push Button    TaskInteractionDialog_actions_dropdown
    Select From Visible Popup Menu    class=JPopupMenu    Close Task

Close task dialog
    [Documentation]    This keyword closes the currently openned task dialog.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with a task dialog being shown. The `Open Task` can be used to open the task dialog for the task being modified.
    ...
    ...    *Example*
    ...    | Close task dialog |
    Select Dialog    regexp=Task:.*
    Push Button    TaskInteractionDialog_cancel_button    # The Close Button

Complete opened task
    [Documentation]    This keyword completes the currently openned task.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with a task dialog being shown. The `Open Task` can be used to open the task dialog for the task being modified.
    ...
    ...    *Example*
    ...    | Complete opened task |
    Select Dialog    regexp=Task:.*
    Push Button    TaskInteractionDialog_actions_dropdown
    Select From Visible Popup Menu    class=JPopupMenu    Complete Task

Create New Configuration
    [Arguments]    ${name}    ${description}=
    Select Dialog    regexp=Workflow Configuration.*
    Wait for glass pane to disappear
    Push Button    addConfiguration
    Wait for glass pane to disappear
    Sleep    1
    Wait Until Keyword Succeeds    10s    0.2s    Insert Into Text Field    nameField    ${name}
    Wait Until Keyword Succeeds    10s    0.2s    Insert Into Text Field    descriptionField    ${description}

Create New Workflow Task
    [Arguments]    ${name}    ${type}    ${role}=${EMPTY}
    Select Dialog    regexp=Workflow Configuration.*    5
    Select Tab as context    Tasks    WorkflowConfig_Tab
    Push Button    addNewTaskButton
    Select Dialog    New Task Configuration
    Insert Into Text Field    class=JStringField    ${name}
    Select From Combo Box    0    ${type}
    Run Keyword If    '${role}'!='${EMPTY}'    Type Into Text Field    xpath=//*[contains(@class,"TaskConfigurationDialog$RoleLookup")]//*[contains(@class,"BasicLookupComponentUI")]    ${role}

Create workflow
    [Arguments]    ${path}    ${workflow}    ${priority}
    [Documentation]    Creates a workflow for the entity specified by ${path} using the workflow configuration given in ${workflow} and a priority given by ${priority}. The keyword performs a right-click on the entity specified and creates the workflow. It uses the actioner in the first row of the actioner table.
    ...
    ...    *Arguments*
    ...    _path_
    ...    Enity for which the workflow shoould be created.
    ...
    ...    _workflow_
    ...    The name of the workflow to be created.
    ...
    ...    _priority_
    ...    The priority to assign to the workflow.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with the navigator tree visible.
    ...
    ...    *Example*
    ...    | Create workflow | path=${experiment_path} | workflow=Biochem Workflow | priority=High |
    ${pipe_separated_path}=    Replace String    ${path}    /    |
    ${old_timeout}=    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    1
    Check Item Exists in navigator Tree    ${pipe_separated_path}
    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    ${old_timeout}
    Select From Navigator Tree Right-click Menu    ${pipe_separated_path}    .*Create Workflow\\.\\.\\..*
    Select Dialog    Create Workflow
    Wait for glass pane to disappear
    Sleep    1s    Give list time to populate
    Click On List Item    ItemList    ${workflow}
    Push Button    OK
    ${status}    ${value}=    Run Keyword And Ignore Error    Dialog Should Not Be Open    Displayed Pages Check Failed
    Run Keyword If    '${status}'== 'FAIL'    Select Dialog    Displayed Pages Check Failed    5
    Run Keyword If    '${status}'== 'FAIL'    Push Button    text=Yes
    Select Dialog    Create Workflow    5
    Select From Combo Box    PriorityCombo    ${priority}
    Select Table Cell    0    0    0
    Push Button    OK
    sleep    2
    Select E-WorkBook Main Window

Enable All Items Must Be Signed
    Select Dialog    New Task Configuration
    Check Check Box    text=All items must be signed

Enable Publish Record After Task Completion
    Select Dialog    New Task Configuration
    Check Check Box    text=Publish record

Enable Set Experiment Status After Task Completion
    [Arguments]    ${experiment_status}
    Select Dialog    New Task Configuration
    Check Check Box    text=Set experiment status to
    Select From Combo Box    1    ${experiment_status}

Open Task
    [Arguments]    ${path}    ${status}    ${tasktype}    ${requester}    ${view}=My Tasks
    [Documentation]    This keyword checks that a task matching the specified values exists in the view given by ${view} and opens the task. In order to allow for the delays in processing taks, the keyword will try for 90 seconds before giving up and failing.
    ...
    ...    *Arguments*
    ...    _path_
    ...    Enity for which the workflow has been created.
    ...
    ...    _status_
    ...    The current status of the task that is being checked for.
    ...
    ...    _takstype_
    ...    The value of the task-type column.
    ...
    ...    _requester_
    ...    The value of the requester column.
    ...
    ...    _view_
    ...    [optional] The view in which to look for the taks. By default the "My Tasks" view is used.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window.
    ...
    ...    *Example*
    ...    | Open Task | view=My Tasks | path=${experiment_path} | status=New | takstype=Sign Off | requester=Biochem |
    __Open task view tab    ${view}
    ${task_row}=    Wait Until Keyword Succeeds    120s    10s    __Find task in task table    ${path}    ${status}
    ...    ${tasktype}    ${requester}
    Click On Table Cell    xpath=//*[contains(@class,'com.idbs.ewb.workflow.taskview.ui.TaskDetailTable') and @showing='true']    ${task_row}    1    2

Open Workflow Configuration
    [Arguments]    ${path}
    Select E-WorkBook Main Window
    Check Item Exists in navigator Tree    ${path}
    Select From Navigator Tree Right-click Menu    ${path}    Configure|.*Workflows\\.\\.\\..*
    Select Dialog    regexp=Workflow Configuration.*

Save Task Configuration
    Select Dialog    New Task Configuration    10
    Push Button    OK

Save Workflow Changes and Close Dialog
    Select Dialog    regexp=Workflow Configuration.*    2
    sleep    3s    Ensure it correctly pushes button
    Push Button    text=Save All Changes
    Sleep    5s    Give E-WorkBook time to apply the changes
    Push Button    text=Close
    sleep    5s    Give chance for dialog to close
    Dialog Should Not Be Open    regexp=Workflow Configuration.*
    Select E-WorkBook Main Window

Select Workflow Entity Types
    [Arguments]    @{entity_types}
    Select Dialog    regexp=Workflow Configuration.*    10
    Select Tab as context    Workflow    WorkflowConfig_Tab
    Push Button    text=...
    Select Dialog    Select Entity Types    10
    : FOR    ${current_entity_type}    IN    @{entity_types}
    \    ${row}=    Find Table Row    0    ${current_entity_type}    Entity Type
    \    Run Keyword If    ${row}==-1    Fail    ${current_entity_type} is not a valid entity type
    \    Click On Table Cell    0    ${row}    0
    Push Button    OK
    Select Dialog    regexp=Workflow Configuration.*    10

Select Workflow Process
    [Arguments]    ${process}
    Select Dialog    regexp=Workflow Configuration.*
    Select Tab as context    Tasks    WorkflowConfig_Tab
    Select From Combo Box    processCombo    ${process}

Set Workflow time limit
    [Arguments]    ${number}    ${units}
    Select Dialog    regexp=Workflow Configuration.*
    Set Spinner Number Value    timeLimitValueSpinner    ${number}
    Select From Combo Box    timeLimitUnitsCombo    ${units}

__Check task table for task
    [Arguments]    ${path}    ${status}    ${tasktype}    ${requester}
    ${path}=    Set Variable If    "${path}"[0]=='/'    ${path}    /${path}
    Push Button    xpath=//*[@tooltip="Refresh Task List"]
    ${number_of_rows}=    Get Table Row Count    xpath=//*[contains(@class,'com.idbs.ewb.workflow.taskview.ui.TaskDetailTable') and @showing='true']
    ${found}=    Set Variable    ${False}
    ${row_number}=    Set Variable    -1    # Give row_number a default value
    : FOR    ${row_number}    IN RANGE    ${number_of_rows}
    \    ${found}=    Set Variable    ${True}
    \    ${current_path}=    Get Table Cell Value    xpath=//*[contains(@class,'com.idbs.ewb.workflow.taskview.ui.TaskDetailTable') and @showing='true']    ${row_number}    1
    \    ${found}=    Set Variable If    "${current_path}"!="${path}"    ${False}    ${found}
    \    ${current_status}=    Get Table Cell Value    xpath=//*[contains(@class,'com.idbs.ewb.workflow.taskview.ui.TaskDetailTable') and @showing='true']    ${row_number}    2    # Column name doesn't work for this one
    \    ${found}=    Set Variable If    "${current_status}"!="${status}"    ${False}    ${found}
    \    ${current_task_type}=    Get Table Cell Value    xpath=//*[contains(@class,'com.idbs.ewb.workflow.taskview.ui.TaskDetailTable') and @showing='true']    ${row_number}    3
    \    ${found}=    Set Variable If    "${current_task_type}"!="${tasktype}"    ${False}    ${found}
    \    ${current_requester}=    Get Table Cell Value    xpath=//*[contains(@class,'com.idbs.ewb.workflow.taskview.ui.TaskDetailTable') and @showing='true']    ${row_number}    0
    \    ${found}=    Set Variable If    "${current_requester}"!="${requester}"    ${False}    ${found}
    \    Run Keyword If    ${found}    Exit For Loop
    [Return]    ${found}    ${row_number}

__Find task in task table
    [Arguments]    ${path}    ${status}    ${tasktype}    ${requester}
    ${found}    ${row_num}=    __Check task table for task    ${path}    ${status}    ${tasktype}    ${requester}
    Run Keyword If    not ${found}    Fail    Did not find expected task in task pane.
    [Return]    ${row_num}

__Open task view tab
    [Arguments]    ${view}
    Select E-WorkBook Main Window
    Select from E-WorkBook Main Menu    Tools    Task View
    Wait for glass pane to disappear
    # make sure the Task View is actully selecetd
    Click On Label    text=Task View
    # This sometimes fails first time round
    Wait Until Keyword Succeeds    60s    5s    Select From Combo Box    class=workflow.taskview.ui.toolbar.SavedFilterCombo    ${view}

__Task should not be in task table
    [Arguments]    ${path}    ${status}    ${tasktype}    ${requester}
    ${found}    ${row_num}=    __Check task table for task    ${path}    ${status}    ${tasktype}    ${requester}
    Run Keyword If    ${found}    Fail    Task should have disappeared but is still in task pane.

Enable Lock Entity During Workflow
    [Documentation]    Ticks the checkbox to enable the option to lock the entity during the workflow
    Check Check Box    text=Prevent edit during workflow

Enable Automatically close task checkbox
    Select Dialog    New Task Configuration
    Check Check Box    text=Automatically close task once completed

Select System Actions Tab
    [Documentation]    Keyword to select the system actions tab as part of workflow configuration
    Select Dialog    regexp=Workflow Configuration.*
    Select Tab as context    System Actions
