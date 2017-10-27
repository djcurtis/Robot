*** Settings ***
Library           String
## Library           OracleLibrary
Library           IDBSHttpLibrary
Resource          ../../Common/common_resource.robot

*** Variables ***
${WORKFLOW ENDPOINT}    /ewb/services/1.0/workflows
${ACTIVE WORKFLOWS ENDPOINT}    /ewb/services/1.0/workflows/activeworkflows

*** Keywords ***
Workflow Service Test Case Setup
    Set Suite Variable    ${SERVICES USERNAME}    ${VALID USER}
    Set Suite Variable    ${SERVICES PASSWORD}    ${VALID PASSWD}

Workflow Request Setup
    IDBSHttpLibrary.Create Http Context    ${SERVER}:${WEB_SERVICE_PORT}    https
    Set Basic Auth    ${SERVICES USERNAME}    ${SERVICES PASSWORD}
    Set Request Header    Accept    application/json;charset=utf-8
    Set Request Header    Content-Type    application/json;charset=utf-8

Get Entity ID From Name
    [Arguments]    ${Entity Name}
    [Documentation]    Gets the entity ID based off the entity name
    ...
    ...    *Arguments*
    ...    Entity Name = the entity name as displayed in E-WorkBook
    ...
    ...    *Return value*
    ...    entity id value = the entity id
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    ...    | Get Entity ID From Name | Administrators |
    Connect To Database    ${POOL_USERNAME}    ${POOL_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    ${queryResults}    Query    select ENTITY_ID from entities where ENTITY_NAME='${Entity Name}'
    ${entity id value}    Set Variable    ${queryResults[0][0]}
    Disconnect From Database
    [Return]    ${entity id value}

Get Most Recent Entity Version
    [Arguments]    ${Entity Id}
    [Documentation]    Gets the most recent entity version number
    ...
    ...    *Arguments*
    ...    Entity Id = the entity
    ...
    ...    *Return value*
    ...    entity version = the entity version
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Connect To Database    ${POOL_USERNAME}    ${POOL_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    ${queryResults}    Query    select max(entity_version) from entity_versions t where entity_id='${Entity Id}'
    ${entity version}    Set Variable    ${queryResults[0][0]}
    Disconnect From Database
    [Return]    ${entity version}

Get Most Recent Entity Status
    [Arguments]    ${Entity Id}
    [Documentation]    Gets the most recent entity status
    ...
    ...    *Arguments*
    ...    Entity Id = the entity
    ...
    ...    *Return value*
    ...    status = the entity status
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    ${Version}=    Get Most Recent Entity Version    ${Entity Id}
    Connect To Database    ${POOL_USERNAME}    ${POOL_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    ${queryResults}    Query    select attribute_value_string from entity_version_attr_values evav left join entity_version_attr eva on evav.entity_version_attr_id=eva.entity_version_attr_id where eva.entity_version_id=(select entity_version_id from entity_versions ev where ev.entity_version=${Version} and ev.entity_id='${Entity Id}') and eva.attribute_name='statusName'
    ${status}    Set Variable    ${queryResults[0][0]}
    Disconnect From Database
    [Return]    ${status}

Get Entity Comment And Reply Count
    [Arguments]    ${Entity Id}
    [Documentation]    Returns the number of comments and replies on the given entity
    ...
    ...    *Arguments*
    ...    Entity Id = the entity
    ...
    ...    *Return value*
    ...    count = the number of comments and replies
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Connect To Database    ${POOL_USERNAME}    ${POOL_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    ${queryResults}    Query    select count(*) from entity_comments where ENTITY_ID='${Entity Id}'
    ${count}    Set Variable    ${queryResults[0][0]}
    Disconnect From Database
    [Return]    ${count}

Confirm Locked Against Edit
    [Arguments]    ${Entity Id}    ${Expected Locked Against Edit}
    [Documentation]    Confirms that the experiment locked against edit setting matches the given value
    ...
    ...    *Arguments*
    ...    Entity Id = the entity
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Connect To Database    ${POOL_USERNAME}    ${POOL_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    ${queryResults}    Query    select LOCKED_AGAINST_EDIT from entities where ENTITY_ID='${Entity Id}'
    ${locked-against-edit}    Set Variable    ${queryResults[0][0]}
    Disconnect From Database
    Should Be Equal    ${Expected Locked Against Edit}    ${locked-against-edit}

Create Workflow Via WS
    [Arguments]    ${entity selection type}    ${entity selected}    ${configuration}    ${due date}    ${send emails}    ${priority}
    ...    ${task JSON}
    [Documentation]    Create a new workflow
    ...
    ...    *Arguments*
    ...    due date should be of the format - 2011-01-01T00:00:00.000+00:00
    ...
    ...    *Return value*
    ...    The new workflow ID
    ...
    ...    *Precondition*
    ...
    ...    *Example*
    Workflow Request Setup
    Set Request Body    {"forEntity" : { "entitySelectionType" : "${entity selection type}", "entitySelected" : "${entity selected}" },"fromConfiguration" : "${configuration}","dueDate" : "${due date}","tasks" : ${task JSON},"sendEmailNotifications" : ${send emails},"priority":"${priority}"}
    POST    ${WORKFLOW ENDPOINT}
    ${Response Body 1}=    Get Response Body
    ${Temp Workflow ID}=    Get Json Value    ${Response Body 1}    /workflowId
    ${New Workflow ID}=    Replace String    ${Temp Workflow ID}    "    ${EMPTY}
    [Return]    ${New Workflow ID}

Create Workflow Via WS And Expect Error
    [Arguments]    ${entity selection type}    ${entity selected}    ${configuration}    ${due date}    ${send emails}    ${priority}
    ...    ${task JSON}    ${status code}
    [Documentation]    Create a new workflow
    ...
    ...    *Arguments*
    ...    due date should be of the format - 2011-01-01T00:00:00.000+00:00
    ...
    ...    *Return value*
    ...    The new workflow ID
    ...
    ...    *Precondition*
    ...
    ...    *Example*
    Workflow Request Setup
    Next Request Should Not Succeed
    Set Request Body    {"forEntity" : { "entitySelectionType" : "${entity selection type}", "entitySelected" : "${entity selected}" },"fromConfiguration" : "${configuration}","dueDate" : "${due date}","tasks" : ${task JSON},"sendEmailNotifications" : ${send emails},"priority":"${priority}"}
    POST    ${WORKFLOW ENDPOINT}
    ${Response Body 1}=    Get Response Body
    Log    ${Response Body 1}
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Create Task JSON
    [Arguments]    ${task type}    ${task name}    ${users}=    ${groups}=    ${comments}=    ${test task parameters}=none
    [Documentation]    Creates the JSON object in the format required to create a workflow task
    ...
    ...    *Arguments*
    ...    task type - either NON_TEST or TEST
    ...    task name - the name of the task
    ...    users - the users to be associated with the task (in quotes, comma seperated, e.g. "Administrator", "Steve")
    ...    groups - the user groups to be associated with the task (in quotes, comma seperated, e.g. "Group 1", "Group 2")
    ...    comments - comments for workflow
    ...    test task parameters - test parameters in the format {"name": "test_param1", "value": "test_object"}
    ...
    ...
    ...    *Return value*
    ...    json object = the json object in the required format
    ...
    ...    *Precondition*
    ...
    ...    *Example*
    ${json object}=    Set Variable If    "${task type}"=="NON_TEST"    {"taskSetup" : [ {"taskName" : "${task name}","userPool" : { "user" : [${users}] },"groupPool":{"group":[${groups}]}, "comments": "${comments}"}]}    "${task type}"=="TEST"    {"taskSetup" : [ {"taskName" : "${task name}","userPool" : { "user" : [${users}] },"groupPool":{"group":[${groups}]}, "comments": "${comments}","taskParameters":${test task parameters}}]}
    Log    ${json object}
    [Return]    ${json object}

Create Task JSON For Multiple Task Workflow
    [Arguments]    ${task type}    ${task name}    ${users}=    ${groups}=    ${comments}=    ${test task parameters}=none
    [Documentation]    Creates the JSON object in the format required to create a workflow task
    ...
    ...    *Arguments*
    ...    task type - either NON_TEST or TEST
    ...    task name - the name of the task
    ...    users - the users to be associated with the task (in quotes, comma seperated, e.g. "Administrator", "Steve")
    ...    groups - the user groups to be associated with the task (in quotes, comma seperated, e.g. "Group 1", "Group 2")
    ...    comments - comments for workflow
    ...    test task parameters - test parameters in the format {"name": "test_param1", "value": "test_object"}
    ...
    ...
    ...    *Return value*
    ...    json object = the json object in the required format
    ...
    ...    *Precondition*
    ...
    ...    *Example*
    ${json object}=    Set Variable If    "${task type}"=="NON_TEST"    {"taskName" : "${task name}","userPool" : { "user" : [${users}] },"groupPool":{"group":[${groups}]}, "comments": "${comments}"}    "${task type}"=="TEST"    {"taskName" : "${task name}","userPool" : { "user" : [${users}] },"groupPool":{"group":[${groups}]}, "comments": "${comments}"},"taskParameters":${test task parameters}
    Log    ${json object}
    [Return]    ${json object}

Get Active Workflows
    [Arguments]    ${entityid}
    [Documentation]    Retrieves active workflow information based on the entity ID
    ...
    ...    *Arguments*
    ...    entityid = the entity ID being used
    ...
    ...    *Return value*
    ...    Response body in the format specified, by default this is JSON
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Workflow Request Setup
    GET    ${ACTIVE WORKFLOWS ENDPOINT}?entityid=${entityid}
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Get Workflow
    [Arguments]    ${Workflow ID}
    [Documentation]    Gets a workflow based on it's ID
    ...
    ...    *Arguments*
    ...    Workflow ID = the workflow ID being used
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Workflow Request Setup
    GET    ${WORKFLOW ENDPOINT}/${Workflow ID}
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Resend Workflow
    [Arguments]    ${Workflow ID}
    [Documentation]    Resends a workflow based on it's ID
    ...
    ...    *Arguments*
    ...    Workflow ID = the workflow ID being used
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Workflow Request Setup
    GET    ${WORKFLOW ENDPOINT}/${Workflow ID}/resend
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Get Workflow Tasks
    [Arguments]    ${Workflow ID}
    [Documentation]    Gets the tasks assoicated with a workflow based on it's ID
    ...
    ...    *Arguments*
    ...    Workflow ID = the workflow ID being used
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Workflow Request Setup
    GET    ${WORKFLOW ENDPOINT}/${Workflow ID}/tasks
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Validate Workflow
    [Arguments]    ${Workflow JSON}    ${workflow_id}=none    ${workflow_display_id}=none    ${workflow_due_date}=none    ${requestor_id}=none    ${requestor_name}=none
    ...    ${requested_date}=none    ${entity_id}=none    ${entity_name}=none    ${entity_path}=none    ${entity_type_id}=none    ${priority}=none
    ...    ${send_email}=none
    [Documentation]    Validates a Workflow Response
    ${Actual Workflow ID}=    Get Json Value    ${Workflow JSON}    /workflowId
    ${Actual Workflow Display ID}=    Get Json Value    ${Workflow JSON}    /displayId
    ${Unformatted Due Date}=    Get Json Value    ${Workflow JSON}    /dueDate
    ${Formatted Due Date}=    Get Substring    ${Unformatted Due Date}    0    10
    ${Actual Due Date}=    Create Due Date Format    ${Formatted Due Date}
    ${Actual Requestor ID}=    Get Json Value    ${Workflow JSON}    /requestorId
    ${Actual Requestor Name}=    Get Json Value    ${Workflow JSON}    /requestorName
    ${Unformatted Requested Date}=    Get Json Value    ${Workflow JSON}    /requestedDate
    ${Formatted Requested Date}=    Get Substring    ${Unformatted Requested Date}    0    10
    ${Actual Requested Date}=    Create Due Date Format    ${Formatted Requested Date}
    ${Actual Entity ID}=    Get Json Value    ${Workflow JSON}    /entityId
    ${Actual Entity Name}=    Get Json Value    ${Workflow JSON}    /entityName
    ${Actual Entity Path}=    Get Json Value    ${Workflow JSON}    /entityPath
    ${Actual Entity Type ID}=    Get Json Value    ${Workflow JSON}    /entityTypeId
    ${Actual Priority}=    Get Json Value    ${Workflow JSON}    /priority
    ${Actual Send Email Flag}=    Get Json Value    ${Workflow JSON}    /sendEmailNotifications
    Run Keyword Unless    "${workflow_id}"=="none"    Should Be Equal    ${Actual Workflow ID}    "${workflow_id}"
    Run Keyword Unless    "${workflow_display_id}"=="none"    Should Be Equal    ${Actual Workflow Display ID}    "${workflow_display_id}"
    Run Keyword Unless    "${workflow_due_date}"=="none"    Should Be Equal    ${Actual Due Date}    ${workflow_due_date}
    Run Keyword Unless    "${requestor_id}"=="none"    Should Be Equal    ${Actual Requestor ID}    "${requestor_id}"
    Run Keyword Unless    "${requestor_name}"=="none"    Should Be Equal    ${Actual Requestor Name}    "${requestor_name}"
    Run Keyword Unless    "${requested_date}"=="none"    Should Be Equal    ${Actual Requested Date}    ${requested_date}
    Run Keyword Unless    "${entity_id}"=="none"    Should Be Equal    ${Actual Entity ID}    "${entity_id}"
    Run Keyword Unless    "${entity_name}"=="none"    Should Be Equal    ${Actual Entity Name}    "${entity_name}"
    Run Keyword Unless    "${entity_path}"=="none"    Should Be Equal    ${Actual Entity Path}    "${entity_path}"
    Run Keyword Unless    "${entity_type_id}"=="none"    Should Be Equal    ${Actual Entity Type ID}    "${entity_type_id}"
    Run Keyword Unless    "${priority}"=="none"    Should Be Equal    ${Actual Priority}    "${priority}"
    Run Keyword Unless    "${send_email}"=="none"    Should Be Equal    ${Actual Send Email Flag}    ${send_email}

Validate Active Workflows
    [Arguments]    ${Response JSON}    ${entity_id}    ${has_active_workflows}
    [Documentation]    Validated Active Workflows Response
    ${Actual Entity ID}=    Get Json Value    ${Response JSON}    /entityId
    ${Actual Active Workflows}=    Get Json Value    ${Response JSON}    /hasActiveWorkflows
    Should Be Equal    ${Actual Entity ID}    "${entity_id}"
    Should Be Equal    ${Actual Active Workflows}    ${has_active_workflows}

Create Due Date Format
    [Arguments]    ${due date}
    [Documentation]    Creates a date value in the correct format to be used when creating tasks. Note that currently this keyword only modifies the year, month and day format and not the hour, minute or seconds values which will be retained at 00:00:00 (midnight).
    ...
    ...    *Arguments*
    ...    ${due date} = either a specific date in the format *YYYY-MM-DD hh:mm:ss* or *YYYYMMDD hhmmss* or *number of seconds after the Unix epoch* or *NOW - {time interval}* to allow the test to run with a date correct at the point of running the test e.g. *NOW - 1 day*
    ...
    ...    * Return Value*
    ...    new due date = the due date in the correct format required for task due dates
    ${new due date year}    ${new due date month}    ${new due date day}=    Get Time    year,month,day    ${due date}
    ${new due date}=    Set Variable    ${new due date year}-${new due date month}-${new due date day}T00:00:00.000+00:00
    [Return]    ${new due date}

Validate Task From Workflow
    [Arguments]    ${task JSON}    ${task number}    ${attachments}=none    ${object}=none    ${test}=none    ${assigned_users}=none
    ...    ${comments}=none    ${role}=none    ${task_type}=none    ${task_name}=none    ${due_date}=none    ${requested_date}=none
    ...    ${task_id}=none    ${task_status}=none    ${display_id}=none    ${workflowId}=none    ${responsible_user_id}=none    ${responsible_user}=none
    ...    ${status_change_value}=none    ${actioning_record_path}=none    ${send_date}=none    ${post_publish}=none    ${status_change}=none    ${actioning_record_id}=none
    ...    ${user_pool}=none
    ${task JSON number}=    Evaluate    ${task number}-1
    ${Actual Attachments JSON}=    Get Json Value    ${task JSON}    /taskDetail/${task JSON number}/attachments
    ${Actual Object}=    Get Json Value    ${task JSON}    /taskDetail/${task JSON number}/object
    ${Actual Test}=    Get Json Value    ${task JSON}    /taskDetail/${task JSON number}/test
    ${Actual Assigned Users}=    Get Json Value    ${task JSON}    /taskDetail/${task JSON number}/assignedUsers
    ${Actual Comments}=    Get Json Value    ${task JSON}    /taskDetail/${task JSON number}/comments
    ${Actual Role}=    Get Json Value    ${task JSON}    /taskDetail/${task JSON number}/role
    ${Actual Task Type}=    Get Json Value    ${task JSON}    /taskDetail/${task JSON number}/taskType
    ${Actual Task Name}=    Get Json Value    ${task JSON}    /taskDetail/${task JSON number}/taskName
    ${Unformatted Due Date}=    Get Json Value    ${task JSON}    /taskDetail/${task JSON number}/dueDate
    ${Formatted Due Date}=    Get Substring    ${Unformatted Due Date}    0    10
    ${Actual Due Date}=    Create Due Date Format    ${Formatted Due Date}
    ${Actual Task ID}=    Get Json Value    ${task JSON}    /taskDetail/${task JSON number}/taskId
    ${Actual Task Status}=    Get Json Value    ${task JSON}    /taskDetail/${task JSON number}/taskStatus
    ${Actual Display ID}=    Get Json Value    ${task JSON}    /taskDetail/${task JSON number}/displayId
    ${Unformatted Requested Date}=    Get Json Value    ${task JSON}    /taskDetail/${task JSON number}/requestedDate
    ${Formatted Requested Date}=    Get Substring    ${Unformatted Requested Date}    0    10
    ${Actual Requested Date}=    Create Due Date Format    ${Formatted Requested Date}
    ${Actual Workflow ID}=    Get Json Value    ${task JSON}    /taskDetail/${task JSON number}/workflowId
    ${Actual Responsible User ID}=    Get Json Value    ${task JSON}    /taskDetail/${task JSON number}/responsibleUserId
    ${Actual Responsible User Name}=    Get Json Value    ${task JSON}    /taskDetail/${task JSON number}/responsibleUserName
    ${Actual Status Change Value}=    Get Json Value    ${task JSON}    /taskDetail/${task JSON number}/statusChangeValue
    # Commenting this out as the server doesn't seem to be returning these anymore
    Comment    ${Actual Actioning Record Path}=    Get Json Value    ${task JSON}    /taskDetail/${task JSON number}/actioningRecordPath
    ${Unformatted Send Date}=    Get Json Value    ${task JSON}    /taskDetail/${task JSON number}/sendDate
    ${Formatted Send Date}=    Get Substring    ${Unformatted Send Date}    0    10
    ${Actual Send Date}=    Create Due Date Format    ${Formatted Send Date}
    ${Actual Post Publish Flag}=    Get Json Value    ${task JSON}    /taskDetail/${task JSON number}/postPublishFlag
    ${Actual Status Change Flag}=    Get Json Value    ${task JSON}    /taskDetail/${task JSON number}/statusChangeFlag
    # Commenting this out as the server doesn't seem to be returning these anymore
    Comment    ${Actual Actioning Record ID}=    Get Json Value    ${task JSON}    /taskDetail/${task JSON number}/actioningRecordId
    ${Actual User Pool}=    Get Json Value    ${task JSON}    /taskDetail/${task JSON number}/userPool
    Run Keyword Unless    '${attachments}'=='none'    Should Be Equal    ${Actual Attachments JSON}    ${attachments}
    Run Keyword Unless    "${object}"=="none"    Should Be Equal    ${Actual Object}"    "${object}"
    Run Keyword Unless    "${test}"=="none"    Should Be Equal    ${Actual Test}    "${test}"
    Run Keyword Unless    '${assigned_users}'=='none'    Should Contain    ${Actual Assigned Users}    ${assigned_users}
    Run Keyword Unless    "${comments}"=="none"    Should Contain    ${Actual Comments}    ${comments}
    Run Keyword Unless    "${role}"=="none"    Should Be Equal    ${Actual Role}    "${role}"
    Run Keyword Unless    "${task_type}"=="none"    Should Be Equal    ${Actual Task Type}    "${task_type}"
    Run Keyword Unless    "${task_name}"=="none"    Should Be Equal    ${Actual Task Name}    "${task_name}"
    Run Keyword Unless    "${due_date}"=="none"    Should Be Equal    ${Actual Due Date}    ${due_date}
    Run Keyword Unless    "${task_id}"=="none"    Should Be Equal    ${Actual Task ID}    "${task_id}"
    Run Keyword Unless    "${task_status}"=="none"    Should Be Equal    ${Actual Task Status}    "${task_status}"
    Run Keyword Unless    "${display_id}"=="none"    Should Be Equal    ${Actual Display ID}    "${display_id}"
    Run Keyword Unless    "${requested_date}"=="none"    Should Be Equal    ${Actual Requested Date}    ${requested_date}
    Run Keyword Unless    "${workflowId}"=="none"    Should Be Equal    ${Actual Workflow ID}    "${workflowId}"
    Run Keyword Unless    "${responsible_user_id}"=="none"    Should Be Equal    ${Actual Responsible User ID}    "${responsible_user_id}"
    Run Keyword Unless    "${responsible_user}"=="none"    Should Be Equal    ${Actual Responsible User Name}    "${responsible_user}"
    Run Keyword Unless    "${status_change_value}"=="none"    Should Be Equal    ${Actual Status Change Value}    "${status_change_value}"
    Comment    Run Keyword Unless    "${actioning_record_path}"=="none"    Should Be Equal    ${Actual Actioning Record Path}    "${actioning_record_path}"
    Run Keyword Unless    "${send_date}"=="none"    Should Be Equal    ${Actual Send Date}    ${send_date}
    Run Keyword Unless    "${post_publish}"=="none"    Should Be Equal    ${Actual Post Publish Flag}    ${post_publish}
    Run Keyword Unless    "${status_change}"=="none"    Should Be Equal    ${Actual Status Change Flag}    ${status_change}
    Comment    Run Keyword Unless    "${actioning_record_id}"=="none"    Should Be Equal    ${Actual Actioning Record ID}    "${actioning_record_id}"
    Run Keyword Unless    '${user_pool}'=='none'    Should Contain    ${Actual User Pool}    ${user_pool}

Get Active Workflows And Expect Error
    [Arguments]    ${entityid}    ${status code}
    [Documentation]    Gets all active workflows based on an entity ID
    ...
    ...    *Arguments*
    ...    entityid = the entity ID being used
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Workflow Request Setup
    Next Request Should Not Succeed
    GET    ${ACTIVE WORKFLOWS ENDPOINT}?entityid=${entityid}
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Create Due Date Format With Time
    [Arguments]    ${due date}
    [Documentation]    Creates a date value in the correct format to be used when creating tasks. Note that currently this keyword only modifies the year, month and day format and not the hour, minute or seconds values which will be retained at 00:00:00 (midnight).
    ...
    ...    *Arguments*
    ...    ${due date} = either a specific date in the format *YYYY-MM-DD hh:mm:ss* or *YYYYMMDD hhmmss* or *number of seconds after the Unix epoch* or *NOW - {time interval}* to allow the test to run with a date correct at the point of running the test e.g. *NOW - 1 day*
    ...
    ...    * Return Value*
    ...    new due date = the due date in the correct format required for task due dates
    ${new due date year}    ${new due date month}    ${new due date day}    ${new due date hour}    ${new due date min}    ${new due date sec}=    Get Time
    ...    year,month,day,hour,min,sec    ${due date}
    ${new due date}=    Set Variable    ${new due date year}-${new due date month}-${new due date day}T${new due date hour}:${new due date min}:${new due date sec}.000+00:00
    [Return]    ${new due date}

Create Workflow From Request
    [Arguments]    ${WORKFLOW_CONFIG}    ${ENTITY_ID_SOURCE}    ${ENTITY_ID_TARGET}
    [Documentation]    Creates the workflow using the specified workflow request, see Get Workflow Configurations For Entity
    Workflow Request Setup
    ${BODY}    Replace String    ${WORKFLOW_CONFIG}    "entitySelected":"${ENTITY_ID_SOURCE}"    "entitySelected":"${ENTITY_ID_TARGET}"
    Set Request Body    ${BODY}
    POST    ${WORKFLOW ENDPOINT}
    ${RESP}    Get Response Body
    ${RAW_WORKFLOW_ID}    Get Json Value    ${RESP}    /workflowId
    ${WORKFLOW_ID}    Replace String    ${RAW_WORKFLOW_ID}    "    ${EMPTY}
    Should Not Be Empty    ${WORKFLOW_ID}
    [Return]    ${WORKFLOW_ID}

Get Workflow Tasks And Expect Error
    [Arguments]    ${Workflow ID}    ${status code}
    [Documentation]    Gets the tasks assoicated with a workflow based on it's ID but expect an error
    ...
    ...    *Arguments*
    ...    Workflow ID = the workflow ID being used
    ...    Error Code = The HTTP status code expected
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Workflow Request Setup
    Next Request Should Not Succeed
    GET    ${WORKFLOW ENDPOINT}/${Workflow ID}/tasks
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Get Workflow And Expect Error
    [Arguments]    ${Workflow ID}    ${status code}
    [Documentation]    Gets a workflow based on it's ID but expect an error
    ...
    ...    *Arguments*
    ...    Workflow ID = the workflow ID being used
    ...    Status Code = the HTTP status code expected
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Workflow Request Setup
    Next Request Should Not Succeed
    GET    ${WORKFLOW ENDPOINT}/${Workflow ID}
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Get Workflow Actions
    [Arguments]    ${Workflow ID}
    [Documentation]    Gets the actions that can be performed on a workflow
    ...
    ...
    ...    *Arguments*
    ...    Workflow ID = the workflow ID being used
    ...
    ...    *Return value*
    ...    Workflow Actions
    ...
    ...    *Precondition*
    ...    None
    Workflow Request Setup
    GET    ${WORKFLOW ENDPOINT}/${Workflow ID}/actions
    Response Status Code Should Equal    200
    ${Workflow Actions}    Get Response Body
    [Return]    ${Workflow Actions}

Get Workflow Actions And Expect Error
    [Arguments]    ${Workflow ID}    ${status code}
    [Documentation]    Gets the actions that can be performed on a workflow but expect an error
    ...
    ...    *Arguments*
    ...    Workflow ID = the workflow ID being used
    ...    Status Code = the HTTP status code expected
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Workflow Request Setup
    Next Request Should Not Succeed
    GET    ${WORKFLOW ENDPOINT}/${Workflow ID}/actions
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Cancel Workflow
    [Arguments]    ${Workflow ID}
    [Documentation]    Cancels the specified workflow
    ...
    ...    *Arguments*
    ...    Workflow ID = the workflow ID being used
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    Workflow Request Setup
    POST    ${WORKFLOW ENDPOINT}/${Workflow ID}/cancel
    Response Status Code Should Equal    204

Cancel Workflow And Expect Error
    [Arguments]    ${Workflow ID}    ${status code}
    [Documentation]    Cancels the specified workflow but expect an error
    ...
    ...    *Arguments*
    ...    Workflow ID = the workflow ID being used
    ...    Status Code = the HTTP status code expected
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    Workflow Request Setup
    Next Request Should Not Succeed
    POST    ${WORKFLOW ENDPOINT}/${Workflow ID}/cancel
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Close Workflow Tasks
    [Arguments]    ${Workflow ID}
    [Documentation]    Closes any tasks that can be closed on the specified workflow
    ...
    ...    *Arguments*
    ...    Workflow ID = the workflow ID being used
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    Workflow Request Setup
    POST    ${WORKFLOW ENDPOINT}/${Workflow ID}/close
    Response Status Code Should Equal    204

Close Workflow Tasks And Expect Error
    [Arguments]    ${Workflow ID}    ${status code}
    [Documentation]    Closes any tasks that can be closed on the specified workflow but expect an error
    ...
    ...    *Arguments*
    ...    Workflow ID = the workflow ID being used
    ...    Status Code = the HTTP status code expected
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    Workflow Request Setup
    Next Request Should Not Succeed
    POST    ${WORKFLOW ENDPOINT}/${Workflow ID}/close
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Create Task XML
    [Arguments]    ${task name}    ${user}=    ${comments}=
    [Documentation]    Create the tasks XML portion of a worklfow request that can be used to assign a task to a single user
    ${xml}    Set Variable    <tasks><taskSetup><taskName>${task name}</taskName><comments>${comments}</comments><userPool><user>${user}</user></userPool><groupPool/></taskSetup></tasks>
    LOG    ${xml}
    [Return]    ${xml}

Create Workflow With Attachment Via WS
    [Arguments]    ${entity selection type}    ${entity selected}    ${configuration}    ${due date}    ${send emails}    ${lock experiment}
    ...    ${priority}    ${task XML}    ${attachment task name}    ${attachment name}    ${attachment}
    [Documentation]    Creates a workflow with an attachment
    ${workflow xml}    Set Variable    <workflowRequest xmlns="http://workflow.services.ewb.idbs.com"> \ \ \ \ <forEntity> \ \ \ \ \ \ \ \ <entitySelectionType>${entity selection type}</entitySelectionType> \ \ \ \ \ \ \ \ <entitySelected>${entity selected}</entitySelected> \ \ \ \ </forEntity> \ \ \ \ <fromConfiguration>${configuration}</fromConfiguration> \ \ \ \ <dueDate>${due date}</dueDate> \ \ \ \ ${task XML} \ \ \ \ <sendEmailNotifications>${send emails}</sendEmailNotifications> \ \ \ \ <lockExperiment>${lock experiment}</lockExperiment> \ \ \ \ <priority>${priority}</priority> \ \ \ \ <divideTasksEvenly>true</divideTasksEvenly> </workflowRequest>
    IDBSHttpLibrary.Create Http Context    ${SERVER}:${WEB_SERVICE_PORT}    https
    Set Basic Auth    ${SERVICES USERNAME}    ${SERVICES PASSWORD}
    ${form data}    Create Form Data Object    ${attachment name}    ${attachment}    ${attachment task name}
    ${workflow request}    Evaluate    ('workflow-request', '${workflow xml}')
    POST    ${WORKFLOW ENDPOINT}    form_data=${form data}    params=${workflow request}
    ${workflow id}    Get Response Body
    [Return]    ${workflow id}
