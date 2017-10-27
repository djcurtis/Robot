*** Settings ***
Library           String
Library           Collections
Library           IDBSHttpLibrary
Library           XMLLibrary
Library           TestDataGenerationLibrary
Resource          ../../Common/common_resource.robot

*** Variables ***
${TASKS ENDPOINT}    /ewb/services/1.0/tasks
${TASK STATUS ENDPOINT}    /ewb/services/1.0/tasks/statuses
${TASK TYPE ENDPOINT}    /ewb/services/1.0/tasks/types

*** Keywords ***
Task Request Setup
    [Arguments]    ${user}=${SERVICES USERNAME}    ${password}=${SERVICES PASSWORD}
    IDBSHttpLibrary.Create Http Context    ${SERVER}:${WEB_SERVICE_PORT}    https
    Set Basic Auth    ${user}    ${password}
    Set Request Header    Accept    application/json;charset=utf-8
    Set Request Header    Content-Type    application/json;charset=utf-8

Get Task Statuses
    [Documentation]    Gets all possible task statuses
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    GET    ${TASK STATUS ENDPOINT}
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Get Task Types
    [Documentation]    Gets all possible task types
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    GET    ${TASK TYPE ENDPOINT}
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Get Tasks
    [Arguments]    ${Task Filter}
    [Documentation]    Gets all tasks based on the task filter
    ...
    ...    *Arguments*
    ...    Task Filter = JSON object containing the filter to be used
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Set Request Body    ${Task Filter}
    POST    ${TASKS ENDPOINT}
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Get Task ID From Workflow ID
    [Arguments]    ${workflow ID}    ${task number}
    ${task JSON number}=    Evaluate    ${task number}-1
    Task Request Setup
    GET    ${WORKFLOW ENDPOINT}/${Workflow ID}/tasks
    ${Workflow JSON}=    Get Response Body
    ${temp task ID}=    Get Json Value    ${Workflow JSON}    /taskDetail/${task JSON number}/taskId
    ${task id}=    Replace String    ${temp task ID}    "    ${EMPTY}
    [Return]    ${task ID}

Get Task From Task ID
    [Arguments]    ${Task ID}
    [Documentation]    Gets task details based on a task ID
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    GET    ${TASKS ENDPOINT}/${Task ID}
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Get Task From Task ID And Expect Error
    [Arguments]    ${Task ID}    ${status code}
    [Documentation]    Gets task details based on a task ID
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Next Request Should Not Succeed
    GET    ${TASKS ENDPOINT}/${Task ID}
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Set Actioning Record
    [Arguments]    ${Task ID}    ${Entity ID}
    [Documentation]    Sets the actioning record for a task
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    Entity ID = the entity ID of the record to use
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    POST    ${TASKS ENDPOINT}/${Task ID}/setactioningrecord?recordid=${Entity ID}
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Set Actioning Record And Expect Error
    [Arguments]    ${Task ID}    ${Entity ID}    ${status code}
    [Documentation]    Sets the actioning record for a task and expects an error to occur
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    Entity ID = the entity ID of the record to use
    ...    status code = the expected status code to be returned
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Next Request Should Not Succeed
    POST    ${TASKS ENDPOINT}/${Task ID}/setactioningrecord?recordid=${Entity ID}
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Accept Task
    [Arguments]    ${Task ID}    ${user}=${SERVICES USERNAME}    ${password}=${SERVICES PASSWORD}
    [Documentation]    Accepts a task
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup    ${user}    ${password}
    POST    ${TASKS ENDPOINT}/${Task ID}/accept
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Accept Multiple Tasks
    [Arguments]    @{Task IDs}    # Array of Task ID's
    [Documentation]    Accepts one or more tasks using the /tasks/accept endpoint
    ...
    ...    *Arguments*
    ...    Task ID's = the task ID's to be used (as a list variable)
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    #Build JSON
    ${Response Body JSON}=    Build JSON for Multiple IDs    @{Task IDs}
    #Set result from above as request body and return response body
    Set Request Body    ${Response Body JSON}
    POST    ${TASKS ENDPOINT}/accept
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Accept Task And Expect Error
    [Arguments]    ${Task ID}    ${status code}
    [Documentation]    Accepts a task and expects an error to occur
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    status code = the expected status code
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Next Request Should Not Succeed
    POST    ${TASKS ENDPOINT}/${Task ID}/accept
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Accept Multiple Tasks And Expect Error
    [Arguments]    ${status code}    @{Task IDs}
    [Documentation]    Accepts a list of tasks and expects an error to occur
    ...
    ...    *Arguments*
    ...    status code = the expected status code
    ...    Task ID's = the task ID's to be used as a list variable
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    #Build JSON
    ${Response Body JSON}=    Build JSON for Multiple IDs    @{Task IDs}
    Next Request Should Not Succeed
    Set Request Body    ${Response Body JSON}
    POST    ${TASKS ENDPOINT}/accept
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Cancel Task
    [Arguments]    ${Task ID}    ${user}=${SERVICES USERNAME}    ${password}=${SERVICES PASSWORD}
    [Documentation]    Cancels a task
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup    ${user}    ${password}
    POST    ${TASKS ENDPOINT}/${Task ID}/cancel
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Cancel Multiple Tasks
    [Arguments]    @{Task IDs}    # Array of Task ID's
    [Documentation]    Cancels one or more tasks using the /tasks/cancel endpoint
    ...
    ...    *Arguments*
    ...    Task ID's = the task ID's to be used (as a list variable)
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    #Build JSON
    ${Response Body JSON}=    Build JSON for Multiple IDs    @{Task IDs}
    #Set result from above as request body and return response body
    Set Request Body    ${Response Body JSON}
    POST    ${TASKS ENDPOINT}/cancel
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Cancel Task And Expect Error
    [Arguments]    ${Task ID}    ${status code}
    [Documentation]    Cancels a task and expects an error to occur
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    status code = the expected status code
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Next Request Should Not Succeed
    POST    ${TASKS ENDPOINT}/${Task ID}/cancel
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Cancel Multiple Tasks And Expect Error
    [Arguments]    ${status code}    @{Task IDs}
    [Documentation]    Cancels a list of tasks and expects an error to occur
    ...
    ...    *Arguments*
    ...    status code = the expected status code
    ...    Task ID's = the task ID's to be used as a list variable
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    #Build JSON
    ${Response Body JSON}=    Build JSON for Multiple IDs    @{Task IDs}
    Next Request Should Not Succeed
    Set Request Body    ${Response Body JSON}
    POST    ${TASKS ENDPOINT}/cancel
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Close Task
    [Arguments]    ${Task ID}
    [Documentation]    Closes a task
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    POST    ${TASKS ENDPOINT}/${Task ID}/close
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Close Multiple Tasks
    [Arguments]    @{Task IDs}
    [Documentation]    Closes one or more tasks using the /tasks/close endpoint
    ...
    ...    *Arguments*
    ...    Task IDs = the task IDs to be used as a list variable
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    #Build JSON
    ${Response Body JSON}=    Build JSON for Multiple IDs    @{Task IDs}
    #Set result from above as request body and return response body
    Set Request Body    ${Response Body JSON}
    POST    ${TASKS ENDPOINT}/close
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Close Task And Expect Error
    [Arguments]    ${Task ID}    ${status code}
    [Documentation]    Closes a task and expects an error to occur
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    status code = the expected status code
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Next Request Should Not Succeed
    POST    ${TASKS ENDPOINT}/${Task ID}/close
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Close Multiple Tasks And Expect Error
    [Arguments]    ${status code}    @{Task IDs}
    [Documentation]    Closes one or more tasks and expects an error to occur using the /tasks/close endpoint
    ...
    ...    *Arguments*
    ...    status code = the expected status code
    ...    Task IDs = the task IDs to be used as a list variable
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    #Build JSON
    ${Response Body JSON}=    Build JSON for Multiple IDs    @{Task IDs}
    #Set result from above as request body and return response body
    Set Request Body    ${Response Body JSON}
    Next Request Should Not Succeed
    POST    ${TASKS ENDPOINT}/close
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Complete Task
    [Arguments]    ${Task ID}    ${user}=${SERVICES USERNAME}    ${password}=${SERVICES PASSWORD}
    [Documentation]    Completes a task
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup    ${user}    ${password}
    POST    ${TASKS ENDPOINT}/${Task ID}/complete
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Complete Multiple Tasks
    [Arguments]    @{Task IDs}
    [Documentation]    Completes one or more tasks using the /tasks/complete endpoint
    ...
    ...    *Arguments*
    ...    Task IDs = the task IDs to be used as a list variable
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    #Build JSON
    ${Response Body JSON}=    Build JSON for Multiple IDs    @{Task IDs}
    #Set result from above as request body and return response body
    Set Request Body    ${Response Body JSON}
    POST    ${TASKS ENDPOINT}/complete
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Complete Task And Expect Error
    [Arguments]    ${Task ID}    ${status code}
    [Documentation]    Completes a task and expects an error to occur
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    status code = the expected status code
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Next Request Should Not Succeed
    POST    ${TASKS ENDPOINT}/${Task ID}/complete
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Complete Multiple Tasks And Expect Error
    [Arguments]    ${status code}    @{Task IDs}
    [Documentation]    Completes one or more tasks and expects an error to occur using the /tasks/complete endpoint
    ...
    ...    *Arguments*
    ...    status code = the expected status code
    ...    Task IDs = the task IDs to be used as a list variable
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    #Build JSON
    ${Response Body JSON}=    Build JSON for Multiple IDs    @{Task IDs}
    #Set result from above as request body and return response body
    Set Request Body    ${Response Body JSON}
    Next Request Should Not Succeed
    POST    ${TASKS ENDPOINT}/complete
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Retrieve Multiple Task Actions
    [Arguments]    @{Task IDs}    # Array of Task ID's
    [Documentation]    Returns Actions for a task using the /tasks/actions endpoint
    ...
    ...    *Arguments*
    ...    Task ID's = the task ID's to be used (as a list variable). A list variable is used as that is what the API supports, though the SSP implies we only support one value
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    #Build JSON
    ${Response Body JSON}=    Build JSON for Multiple IDs    @{Task IDs}
    #Set result from above as request body and return response body
    Set Request Body    ${Response Body JSON}
    POST    ${TASKS ENDPOINT}/actions
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Retrieve Multiple Task Actions And Expect Error
    [Arguments]    ${status code}    @{Task IDs}
    [Documentation]    Retrieves actions for one or more tasks and expects an error to occur using the /tasks/actions endpoint
    ...
    ...    *Arguments*
    ...    status code = the expected status code
    ...    Task IDs = the task IDs to be used as a list variable
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    #Build JSON
    ${Response Body JSON}=    Build JSON for Multiple IDs    @{Task IDs}
    #Set result from above as request body and return response body
    Set Request Body    ${Response Body JSON}
    Next Request Should Not Succeed
    POST    ${TASKS ENDPOINT}/actions
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Ignore Task
    [Arguments]    ${Task ID}
    [Documentation]    Ignores a task
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    POST    ${TASKS ENDPOINT}/${Task ID}/ignore
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Ignore Multiple Tasks
    [Arguments]    ${Task ID}
    [Documentation]    Ignores one or more tasks using the /tasks/ignore endpoint
    ...
    ...    *Arguments*
    ...    Task IDs = the task IDs to be used as a list variable
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    POST    ${TASKS ENDPOINT}/${Task ID}/ignore
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Ignore Task And Expect Error
    [Arguments]    ${Task ID}    ${status code}
    [Documentation]    Ignores a task and expects an error to occur
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    status code = the expected status code
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Next Request Should Not Succeed
    POST    ${TASKS ENDPOINT}/${Task ID}/ignore
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Ignore Multiple Tasks And Expect Error
    [Arguments]    ${status code}    @{Task IDs}
    [Documentation]    Ignores one or more tasks and expects an error to occur using the /tasks/ignore endpoint
    ...
    ...    *Arguments*
    ...    status code = the expected status code
    ...    Task IDs = the task IDs to be used as a list variable
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    #Build JSON
    ${Response Body JSON}=    Build JSON for Multiple IDs    @{Task IDs}
    #Set result from above as request body and return response body
    Set Request Body    ${Response Body JSON}
    Next Request Should Not Succeed
    POST    ${TASKS ENDPOINT}/ignore
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Reject Task
    [Arguments]    ${Task ID}    ${Comment}    ${user}=${SERVICES USERNAME}    ${password}=${SERVICES PASSWORD}
    [Documentation]    Rejects a task with comments
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    Comment = rejection comment
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup    ${user}    ${password}
    Set Request Body    {"comments":"${Comment}"}
    POST    ${TASKS ENDPOINT}/${Task ID}/reject
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Reject Multiple Tasks
    [Arguments]    @{Task IDs}
    [Documentation]    Rejects one or more tasks using the /tasks/reject endpoint
    ...
    ...    *Arguments*
    ...    Task IDs = the task IDs to be used as a list variable
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    #Build JSON
    ${Response Body JSON}=    Build JSON for Multiple IDs    @{Task IDs}
    #Set result from above as request body and return response body
    Set Request Body    ${Response Body JSON}
    POST    ${TASKS ENDPOINT}/reject
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Reject Task And Expect Error
    [Arguments]    ${Task ID}    ${Comment}    ${status code}
    [Documentation]    Rejects a task and expects an error to occur
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    Comment = rejection comment
    ...    status code = the expected status code
    ...
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Set Request Body    {"comments":"${Comment}"}
    Next Request Should Not Succeed
    POST    ${TASKS ENDPOINT}/${Task ID}/reject
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Reject Multiple Tasks And Expect Error
    [Arguments]    ${status code}    @{Task IDs}
    [Documentation]    Rejects one or more tasks and expects an error to occur using the /tasks/reject endpoint
    ...
    ...    *Arguments*
    ...    status code = the expected status code
    ...    Task IDs = the task IDs to be used as a list variable
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    #Build JSON
    ${Response Body JSON}=    Build JSON for Multiple IDs    @{Task IDs}
    #Set result from above as request body and return response body
    Set Request Body    ${Response Body JSON}
    Next Request Should Not Succeed
    POST    ${TASKS ENDPOINT}/reject
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Resend Task
    [Arguments]    ${Task ID}
    [Documentation]    Resends a task
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    POST    ${TASKS ENDPOINT}/${Task ID}/resend
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Resend Task And Expect Error
    [Arguments]    ${Task ID}    ${status code}
    [Documentation]    Resends a task and expects an error to occur
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    status code = the expected status code
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Next Request Should Not Succeed
    POST    ${TASKS ENDPOINT}/${Task ID}/resend
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Comment On Task
    [Arguments]    ${Task ID}    ${Comment}
    [Documentation]    Comments on a task
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    Comment = the comment to be used
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Set Request Body    {"comments":"${Comment}"}
    POST    ${TASKS ENDPOINT}/${Task ID}/comments
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Comment On Task And Expect Error
    [Arguments]    ${Task ID}    ${Comment}    ${status code}
    [Documentation]    Comments on a task and expects an error to occur
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    Comment = the comment to be used
    ...    status code = the expected status code
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Set Request Body    {"comments":"${Comment}"}
    Next Request Should Not Succeed
    POST    ${TASKS ENDPOINT}/${Task ID}/comments
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Attach To Task
    [Arguments]    ${Task ID}    ${FilePath}    ${FileName}
    [Documentation]    Attaches a file to a task
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    FilePath = the file name to use
    ...    FileName = the file name to use
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    IDBSHttpLibrary.Create Http Context    ${SERVER}:${WEB_SERVICE_PORT}    https
    Set Basic Auth    ${SERVICES USERNAME}    ${SERVICES PASSWORD}
    ${file_attachment}=    Create Form Data Object    ${FileName}    ${FilePath}
    POST    ${TASKS ENDPOINT}/${Task ID}/attachments/data    ${file_attachment}
    ${New Attachment ID}=    Get Response Body
    [Return]    ${New Attachment ID}

Attach To Task And Expect Error
    [Arguments]    ${Task ID}    ${FilePath}    ${FileName}    ${status code}
    [Documentation]    Attaches a file to a task and expects an error to occur **This uses the deprecated /{taskid}/attachments endpoint**
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    FilePath = the file name to use
    ...    FileName = the file name to use
    ...    status code = the expected status code
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    IDBSHttpLibrary.Create Http Context    ${SERVER}:${WEB_SERVICE_PORT}    https
    Set Basic Auth    ${SERVICES USERNAME}    ${SERVICES PASSWORD}
    ${file_attachment}=    Create Form Data Object    ${FileName}    ${FilePath}
    Next Request Should Not Succeed
    POST    ${TASKS ENDPOINT}/${Task ID}/attachments/data    ${file_attachment}
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Get Task Attachment
    [Arguments]    ${Task ID}    ${Attachment ID}
    [Documentation]    Gets the attachment for a task
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    Attachment ID = the attachment ID to be used
    ...
    ...    *Return value*
    ...    the response from the request, in a binary format
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Create Http Context    ${SERVER}:${WEB_SERVICE_PORT}    https
    Set Basic Auth    ${SERVICES USERNAME}    ${SERVICES PASSWORD}
    GET    ${TASKS ENDPOINT}/${Task ID}/attachments/${Attachment ID}
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Get Task Attachment And Expect Error
    [Arguments]    ${Task ID}    ${Attachment ID}    ${status code}
    [Documentation]    Gets the attachment for a task and expects and error to occur
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    Attachment ID = the attachment ID to be used
    ...    status code = the expected status code
    ...
    ...    *Return value*
    ...    the response from the request, in a binary format
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    IDBSHttpLibrary.Create Http Context    ${SERVER}:${WEB_SERVICE_PORT}    https
    Set Basic Auth    ${SERVICES USERNAME}    ${SERVICES PASSWORD}
    Next Request Should Not Succeed
    GET    ${TASKS ENDPOINT}/${Task ID}/attachments/${Attachment ID}
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Delete Task Attachment
    [Arguments]    ${Task ID}    ${Attachment ID}
    [Documentation]    Deletes the attachment for a task
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    Attachment ID = the attachment ID to be used
    ...
    ...    *Return value*
    ...    the response from the request
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    DELETE    ${TASKS ENDPOINT}/${Task ID}/attachments/${Attachment ID}
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Delete Task Attachment And Expect Error
    [Arguments]    ${Task ID}    ${Attachment ID}    ${status code}
    [Documentation]    Deletes the attachment for a task and expects and error to occur
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    Attachment ID = the attachment ID to be used
    ...    status code = the expected status code
    ...
    ...    *Return value*
    ...    the response from the request
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Next Request Should Not Succeed
    DELETE    ${TASKS ENDPOINT}/${Task ID}/attachments/${Attachment ID}
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Validate Task
    [Arguments]    ${task JSON}    ${attachments}=none    ${object}=none    ${test}=none    ${assigned_users}=none    ${comments}=none
    ...    ${role}=none    ${task_type}=none    ${task_name}=none    ${due_date}=none    ${due_date_with_time}=none    ${requested_date}=none
    ...    ${task_id}=none    ${task_status}=none    ${display_id}=none    ${workflowId}=none    ${responsible_user_id}=none    ${responsible_user}=none
    ...    ${status_change_value}=none    ${actioning_record_path}=none    ${send_date}=none    ${post_publish}=none    ${status_change}=none    ${actioning_record_id}=none
    ...    ${user_pool}=none    ${all_assigned_users}=none
    ${Actual Attachments JSON}=    Get Json Value    ${task JSON}    /attachments
    ${Actual Object}=    Get Json Value    ${task JSON}    /object
    ${Actual Test}=    Get Json Value    ${task JSON}    /test
    ${Actual Assigned Users}=    Get Json Value    ${task JSON}    /assignedUsers
    ${Actual Comments}=    Get Json Value    ${task JSON}    /comments
    ${Actual Role}=    Get Optional Json Value    ${task JSON}    /role
    ${Actual Task Type}=    Get Json Value    ${task JSON}    /taskType
    ${Actual Task Name}=    Get Json Value    ${task JSON}    /taskName
    ${Unformatted Due Date}=    Get Json Value    ${task JSON}    /dueDate
    ${Formatted Due Date}=    Get Substring    ${Unformatted Due Date}    0    10
    ${Actual Due Date}=    Create Due Date Format    ${Formatted Due Date}
    ${Actual Due Date With Time}=    Create Due Date Format With Time    ${Formatted Due Date}
    ${Actual Task ID}=    Get Json Value    ${task JSON}    /taskId
    ${Actual Task Status}=    Get Json Value    ${task JSON}    /taskStatus
    ${Actual Display ID}=    Get Json Value    ${task JSON}    /displayId
    ${Unformatted Requested Date}=    Get Json Value    ${task JSON}    /requestedDate
    ${Formatted Requested Date}=    Get Substring    ${Unformatted Requested Date}    0    10
    ${Actual Requested Date}=    Create Due Date Format    ${Formatted Requested Date}
    ${Actual Workflow ID}=    Get Json Value    ${task JSON}    /workflowId
    ${Actual Responsible User ID}=    Get Json Value    ${task JSON}    /responsibleUserId
    ${Actual Responsible User Name}=    Get Json Value    ${task JSON}    /responsibleUserName
    ${Actual Status Change Value}=    Get Optional Json Value    ${task JSON}    /statusChangeValue
    COMMENT    ${Actual Actioning Record Path}=    Get Json Value    ${task JSON}    /actioningRecordPath
    ${Unformatted Send Date}=    Get Json Value    ${task JSON}    /sendDate
    ${Formatted Send Date}=    Get Substring    ${Unformatted Send Date}    0    10
    ${Actual Send Date}=    Create Due Date Format    ${Formatted Send Date}
    ${Actual Post Publish Flag}=    Get Json Value    ${task JSON}    /postPublishFlag
    ${Actual Status Change Flag}=    Get Json Value    ${task JSON}    /statusChangeFlag
    COMMENT    ${Actual Actioning Record ID}=    Get Json Value    ${task JSON}    /actioningRecordId
    ${Actual User Pool}=    Get Json Value    ${task JSON}    /userPool
    Run Keyword Unless    '${attachments}'=='none'    Should Be Equal    ${Actual Attachments JSON}    ${attachments}
    Run Keyword Unless    "${object}"=="none"    Should Be Equal    ${Actual Object}    "${object}"
    Run Keyword Unless    "${test}"=="none"    Should Be Equal    ${Actual Test}    "${test}"
    Run Keyword Unless    '${assigned_users}'=='none'    Compare User List    ${Actual Assigned Users}    ${assigned_users}
    #Below line is still experimental
    Run Keyword Unless    '${all_assigned_users}'=='none'    Compare Assigned Users    ${Actual Assigned Users}    ${all_assigned_users}
    Run Keyword Unless    "${comments}"=="none"    Should Contain    ${Actual Comments}    ${comments}
    Run Keyword Unless    "${role}"=="none"    Should Be Equal    ${Actual Role}    "${role}"
    Run Keyword Unless    "${task_type}"=="none"    Should Be Equal    ${Actual Task Type}    "${task_type}"
    Run Keyword Unless    "${task_name}"=="none"    Should Be Equal    ${Actual Task Name}    "${task_name}"
    Run Keyword Unless    "${due_date}"=="none"    Should Be Equal    ${Actual Due Date}    ${due_date}
    Run Keyword Unless    "${due_date_with_time}"=="none"    Should Be Equal    ${Actual Due Date With Time}    ${due_date_with_time}
    Run Keyword Unless    "${task_id}"=="none"    Should Be Equal    ${Actual Task ID}    "${task_id}"
    Run Keyword Unless    "${task_status}"=="none"    Should Be Equal    ${Actual Task Status}    "${task_status}"
    Run Keyword Unless    "${display_id}"=="none"    Should Be Equal    ${Actual Display ID}    "${display_id}"
    Run Keyword Unless    "${requested_date}"=="none"    Should Be Equal    ${Actual Requested Date}    ${requested_date}
    Run Keyword Unless    "${workflowId}"=="none"    Should Be Equal    ${Actual Workflow ID}    "${workflowId}"
    Run Keyword Unless    "${responsible_user_id}"=="none"    Should Be Equal    ${Actual Responsible User ID}    "${responsible_user_id}"
    Run Keyword Unless    "${responsible_user}"=="none"    Should Be Equal    ${Actual Responsible User Name}    "${responsible_user}"
    Run Keyword Unless    "${status_change_value}"=="none"    Should Be Equal    ${Actual Status Change Value}    "${status_change_value}"
    COMMENT    Run Keyword Unless    "${actioning_record_path}"=="none"    Should Be Equal    ${Actual Actioning Record Path}    "${actioning_record_path}"
    Run Keyword Unless    "${send_date}"=="none"    Should Be Equal    ${Actual Send Date}    ${send_date}
    Run Keyword Unless    "${post_publish}"=="none"    Should Be Equal    ${Actual Post Publish Flag}    ${post_publish}
    Run Keyword Unless    "${status_change}"=="none"    Should Be Equal    ${Actual Status Change Flag}    ${status_change}
    COMMENT    Run Keyword Unless    "${actioning_record_id}"=="none"    Should Be Equal    ${Actual Actioning Record ID}    "${actioning_record_id}"
    Run Keyword Unless    '${user_pool}'=='none'    Compare User List    ${Actual User Pool}    ${user_pool}

Delete Task Attachment And Expect No Content
    [Arguments]    ${Task ID}    ${Attachment ID}
    [Documentation]    Deletes the attachment for a task and expectsthe 'No Content' response
    ...
    ...    Used for when you are trying to delete an attachment that does not exist
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    Attachment ID = the attachment ID to be used
    ...
    ...    *Return value*
    ...    the response from the request
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    DELETE    ${TASKS ENDPOINT}/${Task ID}/attachments/${Attachment ID}
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    204
    [Return]    ${Response Body 1}

Get Task From Filter
    [Arguments]    ${Task Filter}
    [Documentation]    Gets task details based on a filter
    ...
    ...    *Arguments*
    ...    Task Filter = the task filter to be used (in the format specified by the Content-Type header - default is JSON).
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Set Request Body    ${Task Filter}
    Log    ${Task Filter}
    POST    ${TASKS ENDPOINT}
    ${Response Body 1}=    Get Response Body
    Log    ${Response Body 1}
    [Return]    ${Response Body 1}

Reassign Task
    [Arguments]    ${Task ID}    ${Users}=    ${Groups}=
    [Documentation]    Reassigns a task
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    Users = Users
    ...    Groups = Groups
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Set Request Body    {"users" : { "user" : [${users}] },"groups":{"group":[${groups}]}}
    POST    ${TASKS ENDPOINT}/${Task ID}/reassign
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Reassign Task And Expect Error
    [Arguments]    ${Task ID}    ${status code}    ${Users}=    ${Groups}=
    [Documentation]    Reassigns a task
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    Status Code = Expected status code
    ...    Users = Users
    ...    Groups = Groups
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Set Request Body    {"users" : { "user" : [${users}] },"groups":{"group":[${groups}]}}
    Next Request Should Not Succeed
    POST    ${TASKS ENDPOINT}/${Task ID}/reassign
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Get Active Tasks For An EntityID
    [Arguments]    ${Entity ID}
    [Documentation]    Gets details of Active Tasks for an EntityID. Does not accept a type filter value (this is handled by another keyword)
    ...
    ...    *Arguments*
    ...    Entity ID = the Entity ID to be used
    ...    Status code = the expected status code
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    GET    ${TASKS ENDPOINT}/active?entityid=${Entity ID}
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Get Active Tasks For An EntityID And Task Type
    [Arguments]    ${Entity ID}    ${Task Type}
    [Documentation]    Gets details of Active Tasks for an EntityID. Accepts a type filter value
    ...
    ...    *Arguments*
    ...    Entity ID = the Entity ID to be used
    ...    Task Type = the expected Task Type string
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    GET    ${TASKS ENDPOINT}/active?entityid=${Entity ID}&type=${Task Type}
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Build JSON for Multiple IDs
    [Arguments]    @{Task IDs}
    [Documentation]    This Keyword takes in a list variable (array) of ID's and returns a JSON object that contains each of these ID's that can then be used as the message body for relevant endpoints like /tasks/actions. The JSON structure is:
    ...
    ...    { "id" : [ "...", "..." , ...] }
    ${Response Body JSON}=    Set Variable    {"id" : [
    : FOR    ${TaskID}    IN    @{Task IDs}
    \    ${Response Body JSON}=    Catenate    SEPARATOR=    ${Response Body JSON}    "    ${TaskID}
    \    ...    " ,
    ${Response Body JSON}=    Get Substring    ${Response Body JSON}    \    -2
    ${Response Body JSON}=    Catenate    SEPARATOR=    ${Response Body JSON}    ]}
    [Return]    ${Response Body JSON}

Build JSON for Multiple UserNames
    [Arguments]    @{UserNames}
    [Documentation]    This Keyword takes in a list variable (array) of UserNames and returns a JSON object that contains each of these Names that can then be used to compare to the assigned users in the response body for relevant endpoints. The JSON structure is:
    ...
    ...    { "user" : [ "...", "..." , ...] }
    ${Response Body JSON}=    Set Variable    {"user": [
    : FOR    ${UserName}    IN    @{UserNames}
    \    ${Response Body JSON}=    Catenate    SEPARATOR=    ${Response Body JSON}    "    ${UserName}
    \    ...    ",${SPACE}
    ${Response Body JSON}=    Get Substring    ${Response Body JSON}    \    -2
    ${Response Body JSON}=    Catenate    SEPARATOR=    ${Response Body JSON}    ]}
    [Return]    ${Response Body JSON}

Get Candidates For Assigning A Task Too
    [Arguments]    ${Task ID}    ${Prefix}    ${NumberOfRecords}
    [Documentation]    Get candidates for assigning a task too
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    Prefix = the optional user prefix to use
    ...    NumberOfRecords = the optional limit on the number of results to return
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    GET    ${TASKS ENDPOINT}/${Task ID}/userpool/candidates?prefix=${Prefix}&numberOfRecords=${NumberOfRecords}
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Get Candidates For Assigning A Task Too And Expect Error
    [Arguments]    ${Task ID}    ${Prefix}    ${NumberOfRecords}    ${status code}
    [Documentation]    Get candidates for assigning a task too
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    Prefix = the optional user prefix to use
    ...    NumberOfRecords = the optional limit on the number of results to return
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Next Request Should Not Succeed
    GET    ${TASKS ENDPOINT}/${Task ID}/userpool/candidates?prefix=${Prefix}&numberOfRecords=${NumberOfRecords}
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Get Candidates For Assigning A New Workflow Task To And Expect Error
    [Arguments]    ${Workflow Name}    ${Task Index}    ${Entity Id}    ${NumberOfRecords}    ${status code}
    [Documentation]    Get candidates for assigning a task to if a new workflow is created
    ...
    ...    *Arguments*
    ...    Workflow Name = the workflow configuration
    ...    Task Index = the task
    ...    Entity Id = the entity
    ...    NumberOfRecords = the optional limit on the number of results to return
    ...
    ...    *Return value*
    ...    Nothing
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Next Request Should Not Succeed
    GET    ${TASKS ENDPOINT}/userpool/candidates?workflow=${Workflow Name}&taskIndex=${Task Index}&entityid=${Entity Id}&numberOfRecords=${NumberOfRecords}
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Get History Candidates For Assigning A Task Too And Expect Error
    [Arguments]    ${Task ID}    ${status code}
    [Documentation]    Get candidates for assigning a task too
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    status code = the expected error code
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Next Request Should Not Succeed
    GET    ${TASKS ENDPOINT}/${Task ID}/userpool/history
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Get History Candidates For A New Workflow And Expect Error
    [Arguments]    ${Workflow Name}    ${Task Index}    ${Entity Id}    ${NumberOfRecords}    ${status code}
    [Documentation]    Get candidates for assigning a task to for a new workflow
    ...
    ...    *Arguments*
    ...    Workflow Name = the workflow
    ...    Task Index = the task
    ...    Entity Id = the entity
    ...    NumberOfRecords = the number of records
    ...    status code = the expected error code
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Next Request Should Not Succeed
    GET    ${TASKS ENDPOINT}/userpool/history?workflow=${Workflow Name}&taskIndex=${Task Index}&entityid=${Entity Id}&numberOfRecords=${NumberOfRecords}
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Build JSON For a User Pool Using Only Users
    [Arguments]    @{UserNames}
    [Documentation]    This Keyword takes in a list variable (array) of UserNames and returns a JSON userPool object that contains each of these that can then be used in the request body for relevant endpoints. The JSON structure is:
    ...
    ...    { "users" : { "user" : [ "...", "..." , ...] }, "groups" : { "group" : [ ] } }
    ${Response Body JSON}=    Set Variable    { "users" : {"user": [
    : FOR    ${UserName}    IN    @{UserNames}
    \    ${Response Body JSON}=    Catenate    SEPARATOR=    ${Response Body JSON}    "    ${UserName}
    \    ...    ",${SPACE}
    ${Response Body JSON}=    Get Substring    ${Response Body JSON}    \    -2
    ${Response Body JSON}=    Catenate    SEPARATOR=    ${Response Body JSON}    ] }, "groups" : { "group" : [ ] } }
    [Return]    ${Response Body JSON}

Build JSON For a User Pool Using Only User Groups
    [Arguments]    @{UserGroupNames}
    [Documentation]    This Keyword takes in a list variable (array) of UserGroupNames and returns a JSON userPool object that contains each of these that can then be used in the request body for relevant endpoints. The JSON structure is:
    ...
    ...    { "users" : { "user" : [] }, "groups" : { "group" : [ "...", "..." , ...] } }
    ${Response Body JSON}=    Set Variable    { "users" : {"user": [ ] }, "groups" : { "group" : [
    : FOR    ${UserGroupName}    IN    @{UserGroupNames}
    \    ${Response Body JSON}=    Catenate    SEPARATOR=    ${Response Body JSON}    "    ${UserGroupName}
    \    ...    ",${SPACE}
    ${Response Body JSON}=    Get Substring    ${Response Body JSON}    \    -2
    ${Response Body JSON}=    Catenate    SEPARATOR=    ${Response Body JSON}    ] } }
    [Return]    ${Response Body JSON}

Validate UserPool Against a Task
    [Arguments]    ${Task ID}    ${UserPool}
    [Documentation]    Validates a UserPool Against a Task
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    UserPool = A UserPool in JSON format
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Set Request Body    ${UserPool}
    POST    ${TASKS ENDPOINT}/${Task ID}/userpool/validate
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Validate UserPool Against a Task And Expect Error
    [Arguments]    ${Task ID}    ${UserPool}    ${status code}
    [Documentation]    Validates a UserPool Against a Task
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    UserPool = A UserPool in JSON format
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Next Request Should Not Succeed
    Set Request Body    ${UserPool}
    POST    ${TASKS ENDPOINT}/${Task ID}/userpool/validate
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Validate UserPool Against A New Workflow Task And Expect Error
    [Arguments]    ${Workflow Name}    ${Task Index}    ${Entity Id}    ${UserPool}    ${status code}
    [Documentation]    Validates a UserPool Against A New Workflow
    ...
    ...    *Arguments*
    ...    Workflow Name = the workflow name
    ...    Task Index = the task
    ...    UserPool = A UserPool in JSON format
    ...    status code = the expected error code
    ...
    ...    *Return value*
    ...    Nothing
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Next Request Should Not Succeed
    Set Request Body    ${UserPool}
    POST    ${TASKS ENDPOINT}/userpool/validate?workflow=${Workflow Name}&taskIndex=${Task Index}&entityid=${Entity Id}
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Get Active Tasks For An EntityID and Expect Error
    [Arguments]    ${Entity ID}    ${status code}
    [Documentation]    Gets details of Active Tasks for an EntityID and expect an error. Does not accept a type filter value
    ...
    ...    *Arguments*
    ...    Entity ID = the Entity ID to be used
    ...    Status code = the expected status code
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Next Request Should Not Succeed
    GET    ${TASKS ENDPOINT}/active?entityid=${Entity ID}
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Attach To Task As Multipart Form Data
    [Arguments]    ${Task ID}    ${FilePath}    ${FileName}
    [Documentation]    Attaches a file to a Task using the new (For EWB 9.3.0) Multipart Form endpoint
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    FilePath = the path to the file to be used
    ...    FileName = the name to be used for the file in EWB (inc extension)
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Create Http Context    ${SERVER}:${WEB_SERVICE_PORT}    https
    Set Basic Auth    ${SERVICES USERNAME}    ${SERVICES PASSWORD}
    ${file_attachment}=    Create Form Data Object    ${FileName}    ${FilePath}
    POST    ${TASKS ENDPOINT}/${Task ID}/attachments/data    ${file_attachment}
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Attach To Task As Multipart Form Data And Expect Error
    [Arguments]    ${Task ID}    ${FilePath}    ${FileName}    ${status code}
    [Documentation]    Attaches a file to a Task using the new (For EWB 9.3.0) Multipart Form endpoint and expect an error
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    FilePath = the path to the file to be used
    ...    FileName = the name to be used for the file in EWB (inc extension)
    ...    status code = the status code expected for the error
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Create Http Context    ${SERVER}:${WEB_SERVICE_PORT}    https
    Set Basic Auth    ${SERVICES USERNAME}    ${SERVICES PASSWORD}
    Next Request Should Not Succeed
    ${file_attachment}=    Create Form Data Object    ${FileName}    ${FilePath}
    POST    ${TASKS ENDPOINT}/${Task ID}/attachments/data    ${file_attachment}
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed
    [Return]    ${Response Body 1}

Task Request Setup for XML content
    Create Http Context    ${SERVER}:${WEB_SERVICE_PORT}    https
    Set Basic Auth    ${SERVICES USERNAME}    ${SERVICES PASSWORD}
    Set Request Header    Accept    application/xml;charset=utf-8
    Set Request Header    Content-Type    application/xml;charset=utf-8

Add Task Filter to Task Filter Sequence
    [Arguments]    @{TaskFilters}
    ${root_obj}    Create Xml Object    taskFilterSequence
    ${root_obj}=    Set Element Attribute    ${root_obj}    xmlns    http://workflow.services.ewb.idbs.com
    : FOR    ${TaskFilter}    IN    @{TaskFilters}
    \    ${root_obj}=    Add Subelement To Xml    ${root_obj}    ${TaskFilter}
    [Return]    ${root_obj}

Build Baseline XML for Task Filter
    #Xml creation
    ${second_obj_1}    Create Xml Object    taskFilter
    ${second_obj_1}=    Set Element Attribute    ${second_obj_1}    xmlns    http://workflow.services.ewb.idbs.com
    ${third_obj_1}    Create Xml Object    viewAnyTasks    elementText=true
    ${third_obj_2}    Create Xml Object    includeAssignedSet    elementText=true
    ${third_obj_3}    Create Xml Object    includeSentSet    elementText=true
    ${third_obj_4}    Create Xml Object    includeResponsibleSet    elementText=true
    #${third_obj_5}    Create Xml Object    taskProperties    #Cant add this and below
    #${third_obj_6}    Create Xml Object    propertyFilters    #Cant add this and above
    #${fourth_obj_1}    Create Xml Object    propertyFilter
    #${fifth_obj_1}    Create Xml Object    property    elementText=${TaskProperty}
    #${fifth_obj_2}    Create Xml Object    name    elementText=Whatever
    #${fifth_obj_3}    Create Xml Object    constraints
    #${sixth_obj_1}    Create Xml Object    nameConstraint
    #${seventh_obj_1}    Create Xml Object    nameType    elementText=User type
    #${seventh_obj_2}    Create Xml Object    stringValue    elementText=Frank
    #${seventh_obj_3}    Create Xml Object    operation    elementText=${TaskPropertyConstraintOperation}
    #${sixth_obj_1}=    Add Subelement To Xml    ${sixth_obj_1}    ${seventh_obj_1}
    #${sixth_obj_1}=    Add Subelement To Xml    ${sixth_obj_1}    ${seventh_obj_2}
    #${sixth_obj_1}=    Add Subelement To Xml    ${sixth_obj_1}    ${seventh_obj_3}
    #${fifth_obj_3}=    Add Subelement To Xml    ${fifth_obj_3}    ${sixth_obj_1}
    #${fourth_obj_1}=    Add Subelement To Xml    ${fourth_obj_1}    ${fifth_obj_1}
    #${fourth_obj_1}=    Add Subelement To Xml    ${fourth_obj_1}    ${fifth_obj_2}
    #${fourth_obj_1}=    Add Subelement To Xml    ${fourth_obj_1}    ${fifth_obj_3}
    #${third_obj_6}=    Add Subelement To Xml    ${third_obj_6}    ${fourth_obj_1}
    ${second_obj_1}=    Add Subelement To Xml    ${second_obj_1}    ${third_obj_1}
    ${second_obj_1}=    Add Subelement To Xml    ${second_obj_1}    ${third_obj_2}
    ${second_obj_1}=    Add Subelement To Xml    ${second_obj_1}    ${third_obj_3}
    ${second_obj_1}=    Add Subelement To Xml    ${second_obj_1}    ${third_obj_4}
    #${second_obj_1}=    Add Subelement To Xml    ${second_obj_1}    ${third_obj_5}
    #${second_obj_1}=    Add Subelement To Xml    ${second_obj_1}    ${third_obj_6}
    #${root_obj}=    Add Subelement To Xml    ${root_obj}    ${second_obj_1}
    #${xml}=    Get Xml    ${root_obj}
    [Return]    ${second_obj_1}

Set Booleans for Task Filter
    [Arguments]    ${xml}    ${viewAnyTasks}    ${includeAssignedSet}    ${includeSentSet}    ${includeResponsibleSet}
    [Documentation]    This function changes the values of the four booleans in a Task Filter XML object to user specified values
    ${xml}=    Set Xml Element Text    ${xml}    includeSentSet    ${includeSentSet}
    ${xml}=    Set Xml Element Text    ${xml}    viewAnyTasks    ${viewAnyTasks}
    ${xml}=    Set Xml Element Text    ${xml}    includeAssignedSet    ${includeAssignedSet}
    ${xml}=    Set Xml Element Text    ${xml}    includeResponsibleSet    ${includeResponsibleSet}
    [Return]    ${xml}

Add Property Filters To Task Filter
    [Arguments]    ${xml}    ${propertyFilters}
    ${xml}=    Add Subelement To Xml    ${xml}    ${propertyFilters}
    [Return]    ${xml}

Create Property Filter For Task Filter
    [Arguments]    ${property}    ${name}    @{constraints}
    [Documentation]    This keyword takes a series of Task Filter constraints (as XML objects) and builds a propertyFilter XML object from them, using a user specified property and name
    ${root_xml_obj}    Create Xml Object    propertyFilter
    ${second_xml_obj_1}    Create Xml Object    property    elementText=${property}
    ${second_xml_obj_2}    Create Xml Object    name    elementText=${name}
    ${second_xml_obj_3}    Create Xml Object    constraints
    #Iterate through each constraint, adding it to the XML
    : FOR    ${constraint}    IN    @{constraints}
    \    ${second_xml_obj_3}=    Add Subelement To Xml    ${second_xml_obj_3}    ${constraint}
    ${root_xml_obj}=    Add Subelement To Xml    ${root_xml_obj}    ${second_xml_obj_1}
    ${root_xml_obj}=    Add Subelement To Xml    ${root_xml_obj}    ${second_xml_obj_2}
    ${root_xml_obj}=    Add Subelement To Xml    ${root_xml_obj}    ${second_xml_obj_3}
    [Return]    ${root_xml_obj}

Create Date Constraint For Task Filter
    [Arguments]    ${date}    ${operation}
    [Documentation]    This function returns (as an XML object) a Date element for use as a constraint in a property filter in a Task filter
    ${root_xml_obj}    Create Xml Object    date
    ${second_xml_obj_1}    Create Xml Object    date1    elementText=${date}
    ${second_xml_obj_2}    Create Xml Object    operation    elementText=${operation}
    ${root_xml_obj}=    Add Subelement To Xml    ${root_xml_obj}    ${second_xml_obj_1}
    ${root_xml_obj}=    Add Subelement To Xml    ${root_xml_obj}    ${second_xml_obj_2}
    [Return]    ${root_xml_obj}

Create DatePair Constraint For Task Filter
    [Arguments]    ${date1}    ${date2}    ${operation}
    [Documentation]    This function returns (as an XML object) a DatePair element for use as a constraint in a property filter in a Task filter
    ${root_xml_obj}    Create Xml Object    datePair
    ${second_xml_obj_1}    Create Xml Object    date1    elementText=${date1}
    ${second_xml_obj_2}    Create Xml Object    date2    elementText=${date2}
    ${second_xml_obj_3}    Create Xml Object    operation    elementText=${operation}
    ${root_xml_obj}=    Add Subelement To Xml    ${root_xml_obj}    ${second_xml_obj_1}
    ${root_xml_obj}=    Add Subelement To Xml    ${root_xml_obj}    ${second_xml_obj_2}
    ${root_xml_obj}=    Add Subelement To Xml    ${root_xml_obj}    ${second_xml_obj_3}
    [Return]    ${root_xml_obj}

Create DateLimit Constraint For Task Filter
    [Arguments]    ${limit}    ${operation}
    [Documentation]    This function returns (as an XML object) a DateLimit element for use as a constraint in a property filter in a Task filter
    ${root_xml_obj}    Create Xml Object    dateLimit
    ${second_xml_obj_1}    Create Xml Object    limit    elementText=${limit}
    ${second_xml_obj_2}    Create Xml Object    operation    elementText=${operation}
    ${root_xml_obj}=    Add Subelement To Xml    ${root_xml_obj}    ${second_xml_obj_1}
    ${root_xml_obj}=    Add Subelement To Xml    ${root_xml_obj}    ${second_xml_obj_2}
    [Return]    ${root_xml_obj}

Create Name Constraint For Task Filter
    [Arguments]    ${nameType}    ${stringValue}    ${operation}
    [Documentation]    This function returns (as an XML object) a NameConstraint element for use as a constraint in a property filter in a Task filter
    ${root_xml_obj}    Create Xml Object    nameConstraint
    ${second_xml_obj_1}    Create Xml Object    nameType    elementText=${nameType}
    ${second_xml_obj_2}    Create Xml Object    stringValue    elementText=${stringValue}
    ${second_xml_obj_3}    Create Xml Object    operation    elementText=${operation}
    ${root_xml_obj}=    Add Subelement To Xml    ${root_xml_obj}    ${second_xml_obj_1}
    ${root_xml_obj}=    Add Subelement To Xml    ${root_xml_obj}    ${second_xml_obj_2}
    ${root_xml_obj}=    Add Subelement To Xml    ${root_xml_obj}    ${second_xml_obj_3}
    [Return]    ${root_xml_obj}

Create String Constraint For Task Filter
    [Arguments]    ${stringValue}    ${operation}
    [Documentation]    This function returns (as an XML object) a StringConstraint element for use as a constraint in a property filter in a Task filter
    ${root_xml_obj}    Create Xml Object    stringConstraint
    ${second_xml_obj_1}    Create Xml Object    stringValue    elementText=${stringValue}
    ${second_xml_obj_2}    Create Xml Object    operation    elementText=${operation}
    ${root_xml_obj}=    Add Subelement To Xml    ${root_xml_obj}    ${second_xml_obj_1}
    ${root_xml_obj}=    Add Subelement To Xml    ${root_xml_obj}    ${second_xml_obj_2}
    [Return]    ${root_xml_obj}

Create Count Constraint For Task Filter
    [Arguments]    ${CountValue}    ${operation}
    [Documentation]    This function returns (as an XML object) a CountConstraint element for use as a constraint in a property filter in a Task filter
    ${root_xml_obj}    Create Xml Object    countConstraint
    ${second_xml_obj_1}    Create Xml Object    countValue    elementText=${countValue}
    ${second_xml_obj_2}    Create Xml Object    operation    elementText=${operation}
    ${root_xml_obj}=    Add Subelement To Xml    ${root_xml_obj}    ${second_xml_obj_1}
    ${root_xml_obj}=    Add Subelement To Xml    ${root_xml_obj}    ${second_xml_obj_2}
    [Return]    ${root_xml_obj}

Create Boolean Constraint For Task Filter
    [Arguments]    ${BooleanValue}    ${operation}
    [Documentation]    This function returns (as an XML object) a BooleanConstraint element for use as a constraint in a property filter in a Task filter
    ${root_xml_obj}    Create Xml Object    booleanConstraint
    ${second_xml_obj_1}    Create Xml Object    booleanValue    elementText=${BooleanValue}
    ${second_xml_obj_2}    Create Xml Object    operation    elementText=${operation}
    ${root_xml_obj}=    Add Subelement To Xml    ${root_xml_obj}    ${second_xml_obj_1}
    ${root_xml_obj}=    Add Subelement To Xml    ${root_xml_obj}    ${second_xml_obj_2}
    [Return]    ${root_xml_obj}

Add Multiple Property Filter Items to single Property Filters Item
    [Arguments]    @{propertyFilters}
    ${root_xml_obj}    Create Xml Object    propertyFilters
    #Iterate through each property filter, adding it to the XML
    : FOR    ${propertyFilter}    IN    @{propertyFilters}
    \    ${root_xml_obj}=    Add Subelement To Xml    ${root_xml_obj}    ${propertyFilter}
    [Return]    ${root_xml_obj}

Build Baseline XML for Workflow Filter
    #Xml creation
    ${second_obj_1}    Create Xml Object    workflowFilter
    ${second_obj_1}=    Set Element Attribute    ${second_obj_1}    xmlns    http://workflow.services.ewb.idbs.com
    ${third_obj_1}    Create Xml Object    includeAll    elementText=true
    ${third_obj_2}    Create Xml Object    includeAssignedSet    elementText=true
    ${third_obj_3}    Create Xml Object    includeSentSet    elementText=true
    ${third_obj_4}    Create Xml Object    includeResponsibleSet    elementText=true
    #${third_obj_5}    Create Xml Object    taskProperties    #Cant add this and below
    #${third_obj_6}    Create Xml Object    propertyFilters    #Cant add this and above
    #${fourth_obj_1}    Create Xml Object    propertyFilter
    #${fifth_obj_1}    Create Xml Object    property    elementText=${TaskProperty}
    #${fifth_obj_2}    Create Xml Object    name    elementText=Whatever
    #${fifth_obj_3}    Create Xml Object    constraints
    #${sixth_obj_1}    Create Xml Object    nameConstraint
    #${seventh_obj_1}    Create Xml Object    nameType    elementText=User type
    #${seventh_obj_2}    Create Xml Object    stringValue    elementText=Frank
    #${seventh_obj_3}    Create Xml Object    operation    elementText=${TaskPropertyConstraintOperation}
    #${sixth_obj_1}=    Add Subelement To Xml    ${sixth_obj_1}    ${seventh_obj_1}
    #${sixth_obj_1}=    Add Subelement To Xml    ${sixth_obj_1}    ${seventh_obj_2}
    #${sixth_obj_1}=    Add Subelement To Xml    ${sixth_obj_1}    ${seventh_obj_3}
    #${fifth_obj_3}=    Add Subelement To Xml    ${fifth_obj_3}    ${sixth_obj_1}
    #${fourth_obj_1}=    Add Subelement To Xml    ${fourth_obj_1}    ${fifth_obj_1}
    #${fourth_obj_1}=    Add Subelement To Xml    ${fourth_obj_1}    ${fifth_obj_2}
    #${fourth_obj_1}=    Add Subelement To Xml    ${fourth_obj_1}    ${fifth_obj_3}
    #${third_obj_6}=    Add Subelement To Xml    ${third_obj_6}    ${fourth_obj_1}
    ${second_obj_1}=    Add Subelement To Xml    ${second_obj_1}    ${third_obj_1}
    ${second_obj_1}=    Add Subelement To Xml    ${second_obj_1}    ${third_obj_2}
    ${second_obj_1}=    Add Subelement To Xml    ${second_obj_1}    ${third_obj_3}
    ${second_obj_1}=    Add Subelement To Xml    ${second_obj_1}    ${third_obj_4}
    #${second_obj_1}=    Add Subelement To Xml    ${second_obj_1}    ${third_obj_5}
    #${second_obj_1}=    Add Subelement To Xml    ${second_obj_1}    ${third_obj_6}
    #${root_obj}=    Add Subelement To Xml    ${root_obj}    ${second_obj_1}
    #${xml}=    Get Xml    ${root_obj}
    [Return]    ${second_obj_1}

Get Comments For Task
    [Arguments]    ${Task ID}
    [Documentation]    Gets comments on a task
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...
    ...    *Return value*
    ...    the response from the request, in the format specified (default is JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    GET    ${TASKS ENDPOINT}/${Task ID}/comments
    ${Response Body 1}=    Get Response Body
    [Return]    ${Response Body 1}

Get Comments For Task and Expect Error
    [Arguments]    ${Task ID}    ${status code}
    [Documentation]    Gets comments on a task but expects an error
    ...
    ...    *Arguments*
    ...    Task ID = the task ID to be used
    ...    status code = the HTTP Error code expected
    ...
    ...    *Return value*
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Task Request Setup
    Next Request Should Not Succeed
    GET    ${TASKS ENDPOINT}/${Task ID}/comments
    ${Response Body 1}=    Get Response Body
    Response Status Code Should Equal    ${status code}
    Next Request Should Succeed

Digitally Sign Item
    [Arguments]    ${record Id}    ${entity Id}    ${role}    ${reason}
    [Documentation]    Digitally Signs an entity using the signoff service (not public)
    Task Request Setup for XML content
    #Add extra security header
    ${Encoded Credentials}=    Base64 Encode String    ${SERVICES USERNAME}:${SERVICES PASSWORD}
    Set Request Header    X-Web-Client-Author-Credentials    Basic ${Encoded Credentials}
    #Build JSON
    ${Request Body XML}=    Build XML For Signing Request    ${entity Id}    ${role}    ${reason}
    #Set result from above as request body and return response body
    Set Request Body    ${Request Body XML}
    POST    /ewb/services/1.0/records/${record Id}/signatures
    ${Response Body 1}=    Get Response Body

Build XML For Signing Request
    [Arguments]    ${entity Id}    ${role}    ${reason}    ${comment}=testing
    ${xml}=    Set Variable    <?xml version="1.0" encoding="utf-8"?><signOff xmlns="http://entity.services.ewb.idbs.com" role="${role}"><signer reason="${reason}" additionalComment="${comment}"/><entities><id xmlns="http://common.services.ewb.idbs.com">${entity Id}</id></entities></signOff>
    [Return]    ${xml}

Wait For Overdue Task
    [Documentation]    This is currently the 'best' way we can wait for an overdue task ! Hopefully we can think of something better that will speed the tests up in the future.
    Sleep    70s

Validate Property Filter
    [Arguments]    ${Property}    ${Boolean}    ${Count}    ${Date}    ${DateLimit}    ${DatePair}
    ...    ${Name}    ${String}    ${SubsetFilter}=workflows
    # Boolean Filter
    ${BooleanConstraint}=    Create Boolean Constraint For Task Filter    true    EXISTS
    ${BooleanPropertyFilter}=    Create Property Filter For Task Filter    ${Property}    PropertyFilterName    ${BooleanConstraint}
    ${BooleanFilterItems}=    Add Multiple Property Filter Items to single Property Filters Item    ${BooleanPropertyFilter}
    ${FilterBaseline}=    Build Baseline XML For Filter    ${SubsetFilter}
    ${BooleanFilter}=    Add Property Filters To Task Filter    ${FilterBaseline}    ${BooleanFilterItems}
    # Count Filter
    ${CountConstraint}=    Create Count Constraint For Task Filter    123    IS
    ${CountPropertyFilter}=    Create Property Filter For Task Filter    ${Property}    PropertyFilterName    ${CountConstraint}
    ${CountFilterItems}=    Add Multiple Property Filter Items to single Property Filters Item    ${CountPropertyFilter}
    ${FilterBaseline}=    Build Baseline XML For Filter    ${SubsetFilter}
    ${CountFilter}=    Add Property Filters To Task Filter    ${FilterBaseline}    ${CountFilterItems}
    # Date Filter
    ${DateConstraint}=    Create Date Constraint For Task Filter    2012-01-02T05:45:32.000Z    IS
    ${DatePropertyFilter}=    Create Property Filter For Task Filter    ${Property}    PropertyFilterName    ${DateConstraint}
    ${DateFilterItems}=    Add Multiple Property Filter Items to single Property Filters Item    ${DatePropertyFilter}
    ${FilterBaseline}=    Build Baseline XML For Filter    ${SubsetFilter}
    ${DateFilter}=    Add Property Filters To Task Filter    ${FilterBaseline}    ${DateFilterItems}
    # Date Limit Filter
    ${DateLimitConstraint}=    Create Date Limit Constraint For Task Filter    2012-01-02T05:45:32.000Z    IS
    ${DateLimitPropertyFilter}=    Create Property Filter For Task Filter    ${Property}    PropertyFilterName    ${DateLimitConstraint}
    ${DateLimitFilterItems}=    Add Multiple Property Filter Items to single Property Filters Item    ${DateLimitPropertyFilter}
    ${FilterBaseline}=    Build Baseline XML For Filter    ${SubsetFilter}
    ${DateLimitFilter}=    Add Property Filters To Task Filter    ${FilterBaseline}    ${DateLimitFilterItems}
    # Date Pair Filter
    ${DatePairConstraint}=    Create Date Pair Constraint For Task Filter    2012-01-02T05:45:32.000Z    2012-01-02T05:45:32.000Z    BETWEEN
    ${DatePairPropertyFilter}=    Create Property Filter For Task Filter    ${Property}    PropertyFilterName    ${DatePairConstraint}
    ${DatePairFilterItems}=    Add Multiple Property Filter Items to single Property Filters Item    ${DatePairPropertyFilter}
    ${FilterBaseline}=    Build Baseline XML For Filter    ${SubsetFilter}
    ${DatePairFilter}=    Add Property Filters To Task Filter    ${FilterBaseline}    ${DatePairFilterItems}
    # Name Filter
    ${NameConstraint}=    Create Name Constraint For Task Filter    User type    Administrator    IS
    ${NamePropertyFilter}=    Create Property Filter For Task Filter    ${Property}    PropertyFilterName    ${NameConstraint}
    ${NameFilterItems}=    Add Multiple Property Filter Items to single Property Filters Item    ${NamePropertyFilter}
    ${FilterBaseline}=    Build Baseline XML For Filter    ${SubsetFilter}
    ${NameFilter}=    Add Property Filters To Task Filter    ${FilterBaseline}    ${NameFilterItems}
    # String Filter
    ${StringConstraint}=    Create String Constraint For Task Filter    ABC    BEGINS_WITH
    ${StringPropertyFilter}=    Create Property Filter For Task Filter    ${Property}    PropertyFilterName    ${StringConstraint}
    ${StringFilterItems}=    Add Multiple Property Filter Items to single Property Filters Item    ${StringPropertyFilter}
    ${FilterBaseline}=    Build Baseline XML For Filter    ${SubsetFilter}
    ${StringFilter}=    Add Property Filters To Task Filter    ${FilterBaseline}    ${StringFilterItems}
    # Run each of the filters
    Execute Filter    ${BooleanFilter}    ${Boolean}    ${SubsetFilter}
    Execute Filter    ${CountFilter}    ${Count}    ${SubsetFilter}
    Execute Filter    ${DateFilter}    ${Date}    ${SubsetFilter}
    Execute Filter    ${DateLimitFilter}    ${DateLimit}    ${SubsetFilter}
    Execute Filter    ${DatePairFilter}    ${DatePair}    ${SubsetFilter}
    Execute Filter    ${NameFilter}    ${Name}    ${SubsetFilter}
    Execute Filter    ${StringFilter}    ${String}    ${SubsetFilter}

Build Baseline XML For Filter
    [Arguments]    ${SubsetFilter}=workflows
    ${WorkflowFilter}=    Build Baseline XML for Workflow Filter
    ${TaskFilter}=    Build Baseline XML for Task Filter
    ${Filter}=    Set Variable If    '${SubsetFilter}'=='workflows'    ${WorkflowFilter}    ${TaskFilter}
    [Return]    ${Filter}

Execute Filter
    [Arguments]    ${Filter}    ${Test}    ${SubsetFilter}=workflows
    ${FilterSequence}=    Add Task Filter to Task Filter Sequence    ${Filter}
    ${Filter}=    Set Variable If    '${SubsetFilter}'=='tasks'    ${FilterSequence}    ${Filter}
    ${FilterXML}=    Get Xml    ${Filter}
    Task Request Setup for XML content
    Set Request Body    ${FilterXML}
    Next Request May Not Succeed
    Run Keyword If    '${SubsetFilter}'=='workflows'    PUT    ${WORKFLOW ENDPOINT}/
    Run Keyword If    '${SubsetFilter}'=='tasks'    POST    ${TASKS ENDPOINT}/subset
    Run Keyword If    1==${Test}    Run Keyword And Continue On Failure    Response Status Code Should Equal    200
    Run Keyword If    0==${Test}    Run Keyword And Continue On Failure    Response Status Code Should Equal    400
    Next Request Should Succeed

Validate Property Constraint
    [Arguments]    ${Constraint}    ${Boolean}    ${Count}    ${Date}    ${DateLimit}    ${DatePair}
    ...    ${Name}    ${String}    ${SubsetFilter}=workflows
    # Boolean Filter - can't test this as there are no boolean task propertys
    # ${BooleanConstraint}=    Create Boolean Constraint For Task Filter    true    ${Constraint}
    # ${BooleanPropertyFilter}=    Create Property Filter For Task Filter    ${Property}    PropertyFilterName    ${BooleanConstraint}
    # ${BooleanFilterItems}=    Add Multiple Property Filter Items to single Property Filters Item    ${BooleanPropertyFilter}
    # ${FilterBaseline}=    Build Baseline XML For Filter    ${SubsetFilter}
    # ${BooleanFilter}=    Add Property Filters To Task Filter    ${FilterBaseline}    ${BooleanFilterItems}
    # Count Filter
    ${CountConstraint}=    Create Count Constraint For Task Filter    123    ${Constraint}
    ${CountPropertyFilter}=    Create Property Filter For Task Filter    Assigned user cnt    PropertyFilterName    ${CountConstraint}
    ${CountFilterItems}=    Add Multiple Property Filter Items to single Property Filters Item    ${CountPropertyFilter}
    ${FilterBaseline}=    Build Baseline XML For Filter    ${SubsetFilter}
    ${CountFilter}=    Add Property Filters To Task Filter    ${FilterBaseline}    ${CountFilterItems}
    # Date Filter
    ${DateConstraint}=    Create Date Constraint For Task Filter    2012-01-02T05:45:32.000Z    ${Constraint}
    ${DatePropertyFilter}=    Create Property Filter For Task Filter    Due date    PropertyFilterName    ${DateConstraint}
    ${DateFilterItems}=    Add Multiple Property Filter Items to single Property Filters Item    ${DatePropertyFilter}
    ${FilterBaseline}=    Build Baseline XML For Filter    ${SubsetFilter}
    ${DateFilter}=    Add Property Filters To Task Filter    ${FilterBaseline}    ${DateFilterItems}
    # Date Limit Filter
    ${DateLimitConstraint}=    Create Date Limit Constraint For Task Filter    2012-01-02T05:45:32.000Z    ${Constraint}
    ${DateLimitPropertyFilter}=    Create Property Filter For Task Filter    Due date    PropertyFilterName    ${DateLimitConstraint}
    ${DateLimitFilterItems}=    Add Multiple Property Filter Items to single Property Filters Item    ${DateLimitPropertyFilter}
    ${FilterBaseline}=    Build Baseline XML For Filter    ${SubsetFilter}
    ${DateLimitFilter}=    Add Property Filters To Task Filter    ${FilterBaseline}    ${DateLimitFilterItems}
    # Date Pair Filter
    ${DatePairConstraint}=    Create Date Pair Constraint For Task Filter    2012-01-02T05:45:32.000Z    2012-01-02T05:45:32.000Z    ${Constraint}
    ${DatePairPropertyFilter}=    Create Property Filter For Task Filter    Due date    PropertyFilterName    ${DatePairConstraint}
    ${DatePairFilterItems}=    Add Multiple Property Filter Items to single Property Filters Item    ${DatePairPropertyFilter}
    ${FilterBaseline}=    Build Baseline XML For Filter    ${SubsetFilter}
    ${DatePairFilter}=    Add Property Filters To Task Filter    ${FilterBaseline}    ${DatePairFilterItems}
    # Name Filter
    ${NameConstraint}=    Create Name Constraint For Task Filter    User type    Administrator    ${Constraint}
    ${NamePropertyFilter}=    Create Property Filter For Task Filter    Actioning user    PropertyFilterName    ${NameConstraint}
    ${NameFilterItems}=    Add Multiple Property Filter Items to single Property Filters Item    ${NamePropertyFilter}
    ${FilterBaseline}=    Build Baseline XML For Filter    ${SubsetFilter}
    ${NameFilter}=    Add Property Filters To Task Filter    ${FilterBaseline}    ${NameFilterItems}
    # String Filter
    ${StringConstraint}=    Create String Constraint For Task Filter    ABC    ${Constraint}
    ${StringPropertyFilter}=    Create Property Filter For Task Filter    Actioning experiment    PropertyFilterName    ${StringConstraint}
    ${StringFilterItems}=    Add Multiple Property Filter Items to single Property Filters Item    ${StringPropertyFilter}
    ${FilterBaseline}=    Build Baseline XML For Filter    ${SubsetFilter}
    ${StringFilter}=    Add Property Filters To Task Filter    ${FilterBaseline}    ${StringFilterItems}
    # Run each of the filters
    # Execute Filter    ${BooleanFilter}    ${Boolean}    ${SubsetFilter}
    Execute Filter    ${CountFilter}    ${Count}    ${SubsetFilter}
    Execute Filter    ${DateFilter}    ${Date}    ${SubsetFilter}
    Execute Filter    ${DateLimitFilter}    ${DateLimit}    ${SubsetFilter}
    Execute Filter    ${DatePairFilter}    ${DatePair}    ${SubsetFilter}
    Execute Filter    ${NameFilter}    ${Name}    ${SubsetFilter}
    Execute Filter    ${StringFilter}    ${String}    ${SubsetFilter}

Compare Assigned Users
    [Arguments]    ${Actual}    ${Expected}
    [Documentation]    Compares two JSON lists of users to see if they contain the same users, the JSON format is as follows:
    ...
    ...    {"user": ["User1", "User2",...]}
    ${ActualUsers}=    IDBSHttpLibrary.Get Json Value    ${Actual}    /user
    ${ExpectedUsers}=    IDBSHttpLibrary.Get Json Value    ${Expected}    /user
    ${ActualUsers}=    String.Get Substring    ${ActualUsers}    1    -1
    ${ExpectedUsers}=    String.Get Substring    ${ExpectedUsers}    1    -1
    @{ActualUsersList}=    String.Split String    ${ActualUsers}    ,${SPACE}
    @{ExpectedUsersList}=    String.Split String    ${ExpectedUsers}    ,${SPACE}
    Collections.Sort List    ${ActualUsersList}
    Collections.Sort List    ${ExpectedUsersList}
    Collections.Lists Should Be Equal    ${ActualUsersList}    ${ExpectedUsersList}

Confirm No Task Detail
    [Arguments]    ${workflow tasks JSON}
    ${task detail variable}=    Get Json Value    ${workflow tasks JSON}    /taskDetail
    Should Be Equal    ${task detail variable}    null

Compare User List
    [Arguments]    ${Actual Users}    ${Expected Users}
    ${isEmpty}    ${error}    Run Keyword And Ignore Error    Should Contain    ${Actual Users}    []
    ${isNull}    ${error}    Run Keyword And Ignore Error    Should Contain    ${Actual Users}    null
    Run Keyword If    '${Expected Users}'=='[]'    Run Keyword Unless    '${isEmpty}' == 'PASS' or '${isNull}' == 'PASS'    Fail
    Run Keyword If    '${Expected Users}'!='[]'    Should Contain    ${Actual Users}    ${Expected Users}

Get Optional Json Value
    [Arguments]    ${json}    ${entry}
    [Documentation]    Attempts to retrieve the element ${entry} from the given ${json}, if it doesn't exist then returns empty.
    ${success}    ${value}    Run Keyword And Ignore Error    Get Json Value    ${json}    ${entry}
    ${result}=    Set Variable If    '${success}'=='PASS'    ${value}    ${EMPTY}
    [Return]    ${result}
