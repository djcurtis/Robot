*** Settings ***
Library           IDBSSelenium2Library
Resource          general_resource.robot
Resource          ../Web Services/REST_TaskService/rest_workflow_service_resource.robot
Resource          ../Common/common_resource.robot
Resource          ../Web Services/REST_TaskService/rest_workflow_configuration_service_resource.robot
Resource          ../Web Services/REST_TaskService/rest_task_service_resource.robot

*** Variables ***
${TASK_LINK}      app-header-link-tasks
${TASK_LINK_SLIDER}    app-header-link-nav-link-tasks
${SEARCH_LINK}    app-header-link-search
${TASK_DETAILS_SHOW_COMMENT_EDITOR}    task-details-comments-show-editor    # The id of the link that when clicked, will show the comment editor on the task details panel
${TASK_DETAILS_COMMENT_TEXTBOX}    task-details-comment-textbox    # The id of the text area where comments can be added
${TASK_DETAILS_ADD_COMMENT_BUTTON}    task-details-comments-add-comment    # The id of the DOM element that when clicked, will add a comment
${TASK_DETAILS_CANCEL_COMMENTS}    task-details-comments-hide-editor    # The id of the DOM element that when clicked, will hide the comment editor
${TASK_DETAILS_TASK_NAME}    task-details-task-name    # The id of the task name field in the task details view
${TASK_DETAILS_TASK_PRIORITY}    task-details-task-priority    # The id of the task priority field in the task details view
${TASK_DETAILS_DATE_SENT}    task-details-task-sent    # The id of the sent date field in the task details view
${TASK_DETAILS_DATE_DUE}    task-details-task-due    # The id of the due date field in the task details view
${TASK_DETAILS_HEADER}    task-details-details-header    # The id of the details header field in the task details view
${TASK_DETAILS_WORKFLOW_REQUESTER}    task-details-details-requester    # The id of the workfow requester field in the task details view
${TASK_DETAILS_HEADER_STATUS}    task-details-header-status    # The id of the task status field as present in the header of the task details view
${TASK_DETAILS_HEADER_TYPE}    task-details-header-type    # The id of the task title field as present in the header of the task details view
${TASK_DETAILS_HEADER_TITLE}    task-details-header-task-title    # The id of the title field in the header of the task details view
${TASK_DETAILS_HEADER_ENTIY_LINK}    task-details-header-entity-link    # The id of the entity link field in the header of the task details view
${TASK_DETAILS_ASSIGNED_USER_PREFIX}    task-details-assigned-user-    # The id prefix for the assigned user field in the task details view (suffix will be a 1 based number)
${TASK_DETAILS_RESPONSIBLE_USER}    task-details-responsible-user    # The id of the responsible user field in the task details view
${TASK_DETAILS_SHOW_ATTACHMENT_EDITOR}    task-details-attachment-show-add    # The id of the link element used to display the add attachments option
${TASK_DETAILS_ADD_ATTACHMENT}    task-details-attachment-add    # The id of the element used for uploading an attachment
${TASK_DETAILS_HIDE_ATTACHMENT_EDITOR}    task-details-attachment-cancel    # The id of the element used for hiding the attachment editor panel
${WORKFLOW_LINK}    app-header-link-workflows
${WORKFLOW_LINK_BADGE}    ewb-record-workflows-badge
${TASK_DETAILS_TASK_ID}    task-details-task-id    # The id of the task id field in the task details view
${TASK_DETAILS_ALL_ITEMS_SIGNED_PREFIX}    task-details-all-items-signed    # Prefix of the identifier used to determine whether the all items signed checkbox is checked
${TASK_DETAILS_PUBLISH_RECORD_PREFIX}    task-details-publish-record    # The prefix of the checkbox element used for publishing record
${TASK_DETAILS_SET_EXP_STATUS_PREFIX}    task-details-set-experiment-status    # The prefix of the set experiment status checkbox in the task details view
${TASK_LINK_BADGE}    app-header-link-tasks-badge
${WORKFLOW_WIZARD_ID}    ewb-workflows-creation-wizard-view    # The workflow wizard id
${WORKFLOW_DETAIL_DESCRIPTION}    ewb-workflows-creation-step-one-description    # The id of the workflow description element in workflow creation step one
${WORKFLOW_DETAIL_TASK_TYPE}    ewb-workflows-creation-step-one-task-type    # The id of the workflow task type element in workflow creation step one
${WORKFLOW_DETAIL_DEFAULT_TIME_LIMIT}    ewb-workflows-creation-step-one-default-time-limit    # The id of the workflow default time limit element in workflow creation step one
${WORKFLOW_DETAIL_ID_TERM}    ewb-workflows-creation-step-one-id-term    # The id of the workflow id term element in workflow creation step one
${WORKFLOW_DETAIL_LOCK_ENTITY}    ewb-workflows-creation-step-one-lock-entity    # The id of the workflow lock entity element in workflow creation step one
${WORKFLOW_DETAIL_PUBLISH_ONLY}    ewb-workflows-creation-step-one-published-only    # The id of the workflow published only element in workflow creation step one
${WORKFLOW_DETAIL_MOST_RECENT}    ewb-workflows-creation-step-one-most-recent    # The id of the workflow most recent element in workflow creation step one
${WORKFLOW_DETAIL_SEND_EMAILS}    ewb-workflows-creation-step-one-send-emails    # The id of the workflow send emails element in workflow creation step one
${WORKFLOW_WIZARD_STEP_ONE_CANCEL}    ewb-workflows-creation-step-one-cancel    # The id of the workflow wizard step one cancel element
${WORKFLOW_CONFIGURATION_LIST}    ewb-workflows-creation-step-one-configuration-list    # The id of the workflow configuration list in the workflow creation view
${WORKFLOW_WIZARD_STEP_TWO_CREATE}    ewb-workflows-creation-step-two-create    # The id of the worklfow creation step one create button
${WORKFLOW_WIZARD_STEP_TWO_CANCEL}    ewb-workflows-creation-step-two-cancel    # The id of the worklfow creation step one cancel button
${WORKFLOW_OPTIONS_DATE}    ewb-workflows-creation-options-date    # The id of the workflow options date container
${WORKFLOW_OPTIONS_LOCK_ENTITY}    ewb-workflows-creation-options-lock-check-box    # The id of the workflow options lock entity checkbox
${WORKFLOW_OPTIONS_PRIORITY_VALUE}    ewb-workflows-creation-options-priority-value    # The id of the workflow options priority input box
${WORKFLOW_OPTIONS_SEND_EMAILS}    ewb-workflows-creation-options-send-email-check-box    # The id of the workflow options send email checkbox
${WORKFLOW_OPTIONS_DIVIDE_TASKS_EVENLY}    ewb-workflows-creation-options-divide-tasks-check-box    # The id of the workflow options divide tasks evenly checkbox
${WORKFLOW_TASKS_PREFIX_ID}    ewb-workflows-creation-task-setup-    # The prefix id for workflow tasks
${WORKFLOW_TASKS_NAME_SUFFIX}    -name    # The id suffix of the workflows tasks name
${WORKFLOW_TASKS_DUE_SUFFIX}    -due    # The id suffix of the workflows tasks due date
${WORKFLOW_TASKS_ROLE_SUFFIX}    -role    # The id suffix of the workflows tasks role
${WORKFLOW_TASKS_USERS_PREFIX_ID}    ewb-workflows-creation-task-    # The id of the workflow tasks users
${WORKFLOW_TASKS_USERS_NAME_SUFFIX}    -user-name-    # The id suffix of the workflow tasks users name
${WORKFLOW_TASKS_COMMENTS_TAB_HEADER_SUFFIX}    -comment-tab    # The id suffix of the comment tab header
${WORKFLOW_TASKS_ATTACHMENTS_TAB_HEADER_SUFFIX}    -attachment-tab    # The id suffix of the attachments tab header
${WORKFLOW_TASKS_COMMENT_SUFFIX}    -comment    # The id suffix of the comment text area for a given task
${WORKFLOW_TASKS_TOGGLE_BUTTON_SUFFIX}    -toggle-button    # The id suffix of the toggle button
${WORKFLOW_TASKS_TAB_PANEL_SUFFIX}    -task-tab-panel    # The id suffix of the task tab panel
${WORKFLOW_CONFIGURATION_ONE}    ${CURDIR}${/}..${/}..${/}..${/}Test Data${/}Web Client${/}Workflows${/}workflow.configuration.one.xml
${SEQUENTIAL_WORKFLOW}    ${CURDIR}${/}..${/}..${/}..${/}Test Data${/}Web Client${/}Workflows${/}sequential.workflow.xml
${WORKFLOW_NO_CONFIGURATIONS_ID}    ewb-workflows-creation-wizard-view-no-configurations    # The id of the workflow no configurations available view
${WORKFLOW_ADMINISTRATORS}    WorkflowAdmins
${WORKFLOW_ADMINISTRATORS_DESC}    The workflow administrators group description
${WORKFLOW_TASKS_SUGGEST_BOX_SUFFIX}    -suggest    # The ID suffix of the suggest box
${WORKFLOW_CONFIGURATION_TWO}    ${CURDIR}${/}..${/}..${/}..${/}Test Data${/}Web Client${/}Workflows${/}workflow.configuration.two.xml
${WORKFLOW_TASKS_REMOVE_USER_SUFFIX}    -remove-user-
${WORKFLOW_TASKS_ATTACHMENT_ANCHOR_SUFFIX}    -attachment-anchor    # The attachment anchor suffix
${WORKFLOW_TASKS_FILE_UPLOAD_SUFFIX}    -file-upload-
${WORKFLOW_ATTACHMENT_PATH}    ${CURDIR}${/}..${/}..${/}..${/}Test Data${/}Web Client${/}Workflows${/}Tulips.jpg
${WORKFLOW_DETAIL_CANCEL_BTN}    ewb-workflow-cancel-button
${WORKFLOW_DETAIL_CLOSE_BTN}    ewb-workflow-close-button
${WORKFLOW_REVIEW}    ${CURDIR}${/}..${/}..${/}..${/}Test Data${/}Web Client${/}Workflows${/}workflow.configuration.review.xml
${TASK_REASSIGN_DIALOG_ID}    ewb-task-reassign-dialog
${WORKFLOW_DETAIL_DELETE_COMMENTS}    ewb-workflows-creation-step-one-delete-comments
${WORKFLOW_DELETE}    ${CURDIR}${/}..${/}..${/}..${/}Test Data${/}Web Client${/}Workflows${/}delete.comments.workflow.xml
${REASSIGN_COMMIT_BUTTON}    ewb-tasks-reassign-reassign-button
${REASSIGN_CANCEL_BUTTON}    ewb-tasks-reassign-cancel-button
${REASSIGN_SUGGEST_BOX}    ewb-tasks-reassign-suggest-box
${NON_GXP_WORKFLOW_1}    ${CURDIR}${/}..${/}..${/}..${/}Test Data${/}Web Client${/}Workflows${/}Non GxP Workflow 1.xml    # Business Scenario 1 Workflow
${WORKFLOW_PUBLISH}    ${CURDIR}${/}..${/}..${/}..${/}Test Data${/}Web Client${/}Workflows${/}publish.workflow.xml
${WORKFLOW_MULTI_TASK_DELETE}    ${CURDIR}${/}..${/}..${/}..${/}Test Data${/}Web Client${/}Workflows${/}workflow.multi.task.delete.xml
${SIGN_PDF_ICON}    ewb-web-sign-review-pdf-icon
${SIGN_PDF_ENTITY_NAME}    ewb-web-sign-review-pdf-name
${SIGN_PDF_PATH}    ewb-web-sign-review-pdf-path
${SIGN_PDF_DOWNLOAD_LINK}    ewb-web-sign-review-pdf-download
${SIGN_PDF_CONFIRM_CHECKBOX}    ewb-web-sign-review-pdf-confirm
${PDF_AND_PUBLISH_WORKFLOW}    ${CURDIR}${/}..${/}..${/}..${/}Test Data${/}Web Client${/}Workflows${/}pdf.and.publish.workflow.xml
${QUICK_PDF_AND_PUBLISH_WORKFLOW}    ${CURDIR}${/}..${/}..${/}..${/}Test Data${/}Web Client${/}Workflows${/}quick.sign.pdf.and.publish.workflow.xml
${EWB_TASKS_UPDATE_BUTTON_ID}    ewb-tasks-update-button    # The id of the refresh button in the task/workflow header
${EWB_TASKS_UPDATE_PANEL_ID}    ewb-tasks-update-panel    # The id of the speech bubble panel with CDC run details
${EWB_TASKS_REFRESH_BUTTON_ID}    ewb-tasks-refresh-button    # The id of the refresh button in the speech bubble panel
${BASIC_SIGNOFF_RECORD}    ${CURDIR}${/}..${/}..${/}..${/}Test Data${/}Web Client${/}Workflows${/}basic.signoff.record.xml
${LOCK_RECORD_DURING_WORKFLOW}    ${CURDIR}${/}..${/}..${/}..${/}Test Data${/}Web Client${/}Workflows${/}lock.record.during.workflow.xml
${UNLOCK_RECORD_DURING_WORKFLOW}    ${CURDIR}${/}..${/}..${/}..${/}Test Data${/}Web Client${/}Workflows${/}unlock.record.during.workflow.xml
${NON_GXP_WORKFLOW_2}    ${CURDIR}${/}..${/}..${/}..${/}Test Data${/}Web Client${/}Workflows${/}Non GxP Workflow 2.xml    # Created for Non GxP Business Scenario 2 Workflow
${NON_GXP_WORKFLOW_3}    ${CURDIR}${/}..${/}..${/}..${/}Test Data${/}Web Client${/}Workflows${/}Non GxP Workflow 3.xml    # Created for Non GxP Business Scenario 3 Workflow

*** Keywords ***
Task View Click Link
    [Documentation]    Click the task view link to show the task view
    Click Slide In Panel Link    ${TASK_LINK_SLIDER}

Task View Click Away
    [Documentation]    Click the task view link to show the task view
    Click Slide In Panel Link    ${SEARCH_LINK}

Task View Select Task
    [Arguments]    ${TASK_ID}
    [Documentation]    Selects task view row that matches task id
    Wait Until Page Contains Element    ewb-tasks-list-info-${TASK_ID}-title    30s
    Robust Click    ewb-tasks-list-info-${TASK_ID}-title

Task View Run CDC
    [Documentation]    Runs the cdc sub job to ensure tasks are visible
    Sleep    5s

Task View First Task Id In Workflow Is
    [Arguments]    ${WORKFLOW_TASKS}
    [Documentation]    Gets the first task associated with the workflow id
    ${FIRST_TASK_ID}    Task View Nth Task Id In Workflow Is    ${WORKFLOW_TASKS}
    Should Not Be Empty    ${FIRST_TASK_ID}
    [Return]    ${FIRST_TASK_ID}

Task View First Task Workflow Id Is
    [Arguments]    ${WORKFLOW_TASKS}
    [Documentation]    Gets workflow id for the first task
    ${RAW}    Get Json Value    ${WORKFLOW_TASKS}    /taskDetail/0/workflowId
    ${WORKFLOW_ID}    Replace String    ${RAW}    "    ${EMPTY}
    Should Not Be Empty    ${WORKFLOW_ID}
    [Return]    ${WORKFLOW_ID}

Task View First Task Display Id Is
    [Arguments]    ${WORKFLOW_TASKS}
    [Documentation]    Gets the task display id for the first task
    ${RAW}    Get Json Value    ${WORKFLOW_TASKS}    /taskDetail/0/displayId
    ${TASK_DISPLAY_ID}    Replace String    ${RAW}    "    ${EMPTY}
    Should Not Be Empty    ${TASK_DISPLAY_ID}
    [Return]    ${TASK_DISPLAY_ID}

Task View First Task Due Date Is
    [Arguments]    ${WORKFLOW_TASKS}
    [Documentation]    Gets the first tasks due date
    ${DATE}    Task View Nth Task Due Date Is    ${WORKFLOW_TASKS}    0
    Should Not Be Empty    ${DATE}
    [Return]    ${DATE}

Task View First Task Send Date Is
    [Arguments]    ${WORKFLOW_TASKS}
    [Documentation]    Gets the first tasks send date
    ${RAW}    Get Json Value    ${WORKFLOW_TASKS}    /taskDetail/0/sendDate
    ${DATE}    Replace String    ${RAW}    "    ${EMPTY}
    Should Not Be Empty    ${DATE}
    [Return]    ${DATE}

Task View Format TimeStamp
    [Arguments]    ${STAMP}
    [Documentation]    Formats a time stamp into the following format
    ...
    ...    DD-MMM-YYYY
    ${DATE}    Evaluate    datetime.date.fromtimestamp(float('${STAMP}'[:10])).strftime('%d-%b-%Y')    datetime
    [Return]    ${DATE}

Task View Create Task
    [Arguments]    ${WORKFLOW_CONFIG_ID}
    [Documentation]    *Deprecated* - CREATE ENTITY DATA AS PART OF SUITE
    ...
    ...    Creates a task, run the CDC job and return the task id
    ${current time}=    Get Time
    Create Entity    Group    Automated Test Data ${current time}    Root    CONTENT HEADER
    Create Entity    Project    Project ${current time}    Automated Test Data ${current time}    CONTENT HEADER
    Create Entity    Experiment    Experiment ${current time}    Project ${current time}    CONTENT HEADER
    Add Web Link    http://vpcs-autorunner/index.html
    Version Save Record    ${VALID USER}    ${VALID PASSWD}    Data Added
    ${ENTITY_ID}    Get Entity Id From Record
    ${TASK_ID}    Task View Create Task for Entity    ${ENTITY_ID}    ${WORKFLOW_CONFIG_ID}
    [Return]    ${TASK_ID}

Task View List Property Is
    [Arguments]    ${TASK_ID}    ${PROPERTY}    ${EXPECTED}
    [Documentation]    Checks that the value of the property in the task list view for the specified property
    ...
    ...    The following properties are valid:
    ...
    ...    1. - id
    ...    2. - title
    ...    3. - link
    ...    4. - duein
    ...    5. - responsible-user
    ...    6. - requester
    ...    7. - type
    ...    8. - status
    Wait Until Page Contains Element    ewb-tasks-list-info-${TASK_ID}-${PROPERTY}    30s
    Scroll Element Into View    ewb-tasks-list-info-${TASK_ID}-${PROPERTY}
    Wait Until Element Text Is    ewb-tasks-list-info-${TASK_ID}-${PROPERTY}    ${EXPECTED}    5s

Task View Click Button
    [Arguments]    ${BUTTON}
    [Documentation]    Click one of the buttons in the button bar in the tasks view. The following buttons are valid:
    ...
    ...    1. - sign-off
    ...    2. - review
    ...    3. - view
    ...    4. - complete
    ...    5. - close
    ...    6. - more
    Robust Click    ewb-tasks-${BUTTON}-button

Task View Select Row
    [Arguments]    ${TASK_ID}
    [Documentation]    Selects the row in the task view with the specified task id
    Robust Click    xpath=//div[@id='ewb-tasks-list-info-${TASK_ID}-row']//div[@class='avatar']
    Wait Until Page Contains Element    xpath=//div[@id='ewb-tasks-list-info-${TASK_ID}-row' and contains(@class,'task-workflow-list-view-selected')]

Task View Click Command
    [Arguments]    ${COMMAND}
    [Documentation]    Click the task view command in the drop down menu after clicking More. The following are valid commands:
    ...
    ...    1. - accept
    ...    2. - cancel
    ...    3. - ignore
    ...    4. - reject
    ...    5. - reassign
    Robust Click    ewb-tasks-${COMMAND}-command

Task View Select Filter
    [Arguments]    ${filter}
    [Documentation]    Selects one of the standard filters in the filter panel. The following filters are valid:
    ...
    ...    1. new
    ...    2. active
    ...    2. overdue
    ...    3. all
    ...    4. recently-completed
    Robust Click    xpath=//span[text()="${filter}"]/..
    #check the filter is selected by header text
    Wait Until Keyword Succeeds    30s    1s    Element Text Should Be    xpath=//div[contains(@class, 'ewb-panel-header-label') and contains(text(), 'My Tasks')]    My Tasks - ${filter}
    Wait For No Mask

Task Detail Contains Comment
    [Arguments]    ${expected comment}    # The text that is expected to be present in the page
    [Documentation]    Tests whether the task details view contains a comment with the expected text
    Wait Until Page Contains Element    xpath=//div[@id='task-details-comments-container']/div[@class='ewb-label task-details-comment-body' and text()='${expected comment}']    30s

Task Detail Add Comment
    [Arguments]    ${comment}    # The comment to add
    [Documentation]    Adds a comment to a task on the task details page
    Robust Click    ${TASK_DETAILS_SHOW_COMMENT_EDITOR}
    Focus    ${TASK_DETAILS_COMMENT_TEXTBOX}
    Input Text    ${TASK_DETAILS_COMMENT_TEXTBOX}    ${comment}
    Robust Click    ${TASK_DETAILS_ADD_COMMENT_BUTTON}
    Wait Until Keyword Succeeds    20s    5s    Task Detail Contains Comment    ${comment}

Task Detail Delete File
    [Arguments]    ${file name}    # The name of the file to remove
    [Documentation]    Removes a file from a task
    Task Detail Check Attachment Exists    ${file name}
    Robust Click    xpath=//div[@class='task-details-attachments-container']/div/span/a[text()='${file name}']/../a[position()=2]
    Wait Until Keyword Succeeds    20s    5s    Task Detail Check Attachment Does Not Exist    ${file name}

Task View Navigate To Details View
    [Arguments]    ${task_id}
    [Documentation]    Navigates from the task view to the details view.
    ...
    ...    *Arguments*
    ...    ${task_id} The id of the task to navigate to
    Robust Click    ewb-tasks-list-info-${task_id}-title

Task Detail Check Attachment Exists
    [Arguments]    ${file name}
    Wait Until Page Contains Element    xpath=//div[@class='task-details-attachments-container']/div/span/a[text()='${file name}']    30s

Task Detail Check Attachment Does Not Exist
    [Arguments]    ${file name}
    Page Should Not Contain Element    xpath=//div[@class='task-details-attachments-container']/div/span/a[text()='${file name}']

Workflow View Click Link
    [Documentation]    Clicks the workflow view link to show the workflow view
    Click Slide In Panel Link    ${WORKFLOW_LINK}

Workflow List Property Is
    [Arguments]    ${WORKFLOW_ID}    ${PROPERTY}    ${EXPECTED}
    [Documentation]    Checks that the value of the property in the worklfow list view for the specified property
    ...
    ...    The following properties are valid:
    ...
    ...    1. - requester
    ...    2. - title
    ...    3. - duein
    ...    4. - link
    Wait Until Keyword Succeeds    10s    1s    Scroll Element Into View    ewb-workflows-list-info-${WORKFLOW_ID}-${PROPERTY}
    Wait Until Element Text Is    ewb-workflows-list-info-${WORKFLOW_ID}-${PROPERTY}    ${EXPECTED}    10s

Workflow View Display Id Is
    [Arguments]    ${WORKFLOW}
    [Documentation]    Gets the workflow display ID
    ${RAW_WORKFLOW_DISPLAY_ID}    Get Json Value    ${WORKFLOW}    /displayId
    ${WORKFLOW_DISPLAY_ID}    Replace String    ${RAW_WORKFLOW_DISPLAY_ID}    "    ${EMPTY}
    Should Not Be Empty    ${WORKFLOW_DISPLAY_ID}
    [Return]    ${WORKFLOW_DISPLAY_ID}

Workflow List Click Workflow
    [Arguments]    ${WORKFLOW_ID}
    [Documentation]    Clicks a workflow in the workflow list view to cause the workflow details to be displayed
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ewb-workflows-list-info-${WORKFLOW_ID}-title
    Robust Click    ewb-workflows-list-info-${WORKFLOW_ID}-title

Workflow Details Header Property Is
    [Arguments]    ${PROPERTY}    ${EXPECTED}
    [Documentation]    Checks that the value of the property in the workflow details header view for the specified property
    ...
    ...    The following properties are valid:
    ...
    ...    1. - workflow-title
    ...    2. - entity-link
    ...    3. - priority
    Wait Until Element Text Is    workflow-details-header-${PROPERTY}    ${EXPECTED}    10s

Workflow Details Detail Property Is
    [Arguments]    ${PROPERTY}    ${EXPECTED}
    [Documentation]    Checks that the value of the property in the worklfow details details panel for the specified property
    ...
    ...    The following properties are valid:
    ...
    ...    1. - requester
    ...    2. - requested-date
    ...    3. - due-date
    ...    4. - status
    ...    5. - priority
    ...    6. - type
    Wait Until Page Contains Element    workflow-details-details-${PROPERTY}    30s
    Wait Until Element Text Is    workflow-details-details-${PROPERTY}    ${EXPECTED}    30s

Workflow Details Properties Property Is
    [Arguments]    ${PROPERTY}    ${EXPECTED}
    [Documentation]    Checks that the value of the property in the worklfow details details panel for the specified property
    ...
    ...    The following properties are valid:
    ...
    ...    1. - lock-entity
    ...    2. - publish-entity
    ...    3. - most-recent-pdfs
    ...    4. - send-emails
    ...
    ...    ${EXPECTED} should be 'true' or 'false' depending on whether or not the property is set
    Wait Until Page Contains Element    workflow-details-properties-${PROPERTY}-${EXPECTED}    30s
    Element Should Be Visible    workflow-details-properties-${PROPERTY}-${EXPECTED}

Click Entity Content Menu Workflows Option
    Robust Click    ewb-record-workflows
    Robust Click    ewb-entity-command-workflows
    Page Should Contain Element    ewb-workflows-list

Click Experiment Menu Workflows Option
    Open Content Header Workflows Menu
    Robust Click    ewb-entity-command-workflows
    Wait Until Page Contains Element    ewb-workflows-list

Workflow View Select Filter
    [Arguments]    ${filter}
    [Documentation]    Selects one of the standard filters in the filter panel. The following filters are valid:
    ...
    ...    1. active
    ...    2. overdue
    ...    3. recently-completed
    ...    4. all (when in the workflow view from an entity)
    Robust Click    xpath=//span[text()="${filter}"]/..
    #check the filter is selected by header text
    Wait Until Element Text Is    xpath=//div[contains(@class, 'ewb-panel-header-label') and contains(text(), 'Workflows')]    Workflows - ${filter}    10s

Refresh Task View
    [Documentation]    Refreshes the currently displayed task view by clicking the refresh button
    Robust Click    ewb-tasks-update-button
    [Teardown]    Register Keyword To Run On Failure    Capture Page Screenshot

Workflow Creation Select Create
    [Documentation]    Select the create workflow option from the experiment menu
    Robust Click    ewb-record-workflows
    Workflow Creation Select Create Menu Option

Workflow Creation View Is Visible
    [Documentation]    Ensures that the workflow creation view is visible
    Wait Until Page Contains Element    ${WORKFLOW_WIZARD_ID}    30s

Workflow Creation Wizard Select Workflow
    [Arguments]    ${WORKFLOW_NAME}
    [Documentation]    Selects the specified workflow name
    Robust Click    xpath=//div[@id='${WORKFLOW_CONFIGURATION_LIST}']//div[text()='${WORKFLOW_NAME}']

Workflow Creation Step One Click Select
    [Arguments]    ${workflow name}
    [Documentation]    Clicks select on the workflow creation wizard step one
    Robust Click    xpath=//div[@id='${WORKFLOW_CONFIGURATION_LIST}']//div[contains(text(),'${workflow name}')]
    Wait Until Page Contains Element    xpath=//div[@id='${WORKFLOW_CONFIGURATION_LIST}']//div[contains(@class, 'selected')]/div[contains(text(),'${workflow name}')]    30s
    Wait Until Element Is Visible    xpath=//div[@id='${WORKFLOW_CONFIGURATION_LIST}']//div[contains(@class, 'selected')]/div[contains(text(),'${workflow name}')]/preceding-sibling::button    30s
    Robust Click    xpath=//div[@id='${WORKFLOW_CONFIGURATION_LIST}']//div[contains(@class, 'selected')]/div[contains(text(),'${workflow name}')]/preceding-sibling::button
    Wait Until Page Contains Element    ewb-workflows-creation-options-header    #waits for the workflow options panel to be displayed before continuing

Workflow Creation Step Two Click Cancel
    [Documentation]    Clicks cancel on the workflow creation wizard step two
    Robust Click    ${WORKFLOW_WIZARD_STEP_TWO_CANCEL}

Workflow Creation Step Two Click Create
    [Documentation]    Clicks create on the workflow creation wizard step two
    Robust Click    ${WORKFLOW_WIZARD_STEP_TWO_CREATE}
    ${check status}    ${value} =    Run Keyword And Ignore Error    Wait Until Page Contains Element    cancelButton    30s
    ${id is present}    ${value} =    Run Keyword And Ignore Error    Page Should Contain Element    ewb-workflows-creation-step-two-workflow-id
    ${workflow id}=    Run Keyword If    '${id is present}'=='PASS'    Get Value    ewb-workflows-creation-step-two-workflow-id
    Run Keyword If    '${check status}'=='PASS'    Robust Click    cancelButton
    [Return]    ${workflow id}

Workflow Creation Options Get Due Date
    [Documentation]    Gets the due date in the workflow options panel
    Wait Until Page Contains Element    xpath=//input[@id='${WORKFLOW_OPTIONS_DATE}']    30s
    ${TEMP}=    Get Value    xpath=//input[@id='${WORKFLOW_OPTIONS_DATE}']
    ${DUE_DATE}=    Convert To String    ${TEMP}
    [Return]    ${DUE_DATE}

Workflow Creation Options Is Send Emails
    [Documentation]    Checks that the workflow options send emails checkbox is selected
    Checkbox Should Be Selected    xpath=//span[@id='${WORKFLOW_OPTIONS_DIVIDE_TASKS_EVENLY}']//input[@type='checkbox']

Workflow Creation Options Is Divide Tasks Evenly
    [Documentation]    Checks that the workflow options divide tasks evenly checkbox is selected
    Wait Until Page Contains Element    xpath=//span[@id='${WORKFLOW_OPTIONS_DIVIDE_TASKS_EVENLY}']//input[@type='checkbox']    30s
    Checkbox Should Be Selected    xpath=//span[@id='${WORKFLOW_OPTIONS_DIVIDE_TASKS_EVENLY}']//input[@type='checkbox']

Workflow Creation Options Is Not Send Emails
    [Documentation]    Checks that the workflow options send emails checkbox is not selected
    Wait Until Page Contains Element    xpath=//span[@id='${WORKFLOW_OPTIONS_SEND_EMAILS}']//input[@type='checkbox']    30s
    Checkbox Should Not Be Selected    xpath=//span[@id='${WORKFLOW_OPTIONS_SEND_EMAILS}']//input[@type='checkbox']

Workflow Creation Options Is Not Divide Tasks Evenly
    [Documentation]    Checks that the workflow options divide tasks evenly checkbox is not selected
    Checkbox Should Not Be Selected    xpath=//span[@id='${WORKFLOW_OPTIONS_DIVIDE_TASKS_EVENLY}']//input[@type='checkbox']

Workflow Creation Options Get Priority
    Wait Until Page Contains Element    xpath=//div[@id='ewb-workflows-creation-options-priority-value']/div/div//input[@type='text']    30s
    ${PRIORITY}=    Get Value    xpath=//div[@id='ewb-workflows-creation-options-priority-value']/div/div//input[@type='text']
    [Return]    ${PRIORITY}

Workflow Creation Calculate Due Date
    [Arguments]    ${DAYS}
    [Documentation]    Gets the due date for a workflow based on the number of days
    ${DUE_DATE}=    Evaluate    (datetime.datetime.now()+datetime.timedelta(days=${DAYS})).strftime('%d-%b-%Y')    datetime
    [Return]    ${DUE_DATE}

Workflow Creation Task Due
    [Arguments]    ${TASK_INDEX}
    [Documentation]    Gets the workflow task due date at the specified index
    ${FULL_ID}=    Set Variable    ${WORKFLOW_TASKS_PREFIX_ID}${TASK_INDEX}${WORKFLOW_TASKS_DUE_SUFFIX}
    Wait Until Page Contains Element    ${FULL_ID}    30s
    ${DUE}    Get Text    xpath=//span[@id='${FULL_ID}']
    [Return]    ${DUE}

Workflow Creation Task Role
    [Arguments]    ${TASK_INDEX}
    [Documentation]    Gets the workflow task role at the specified index
    ${FULL_ID}=    Set Variable    ${WORKFLOW_TASKS_PREFIX_ID}${TASK_INDEX}${WORKFLOW_TASKS_ROLE_SUFFIX}
    Wait Until Page Contains Element    ${FULL_ID}    30s
    ${ROLE}    Get Text    xpath=//span[@id='${FULL_ID}']
    [Return]    ${ROLE}

Task View Create Workflow for Entity
    [Arguments]    ${ENTITY_ID}    ${WORKFLOW_CONFIG_ID}
    [Documentation]    Creates a workflow for the given entity identifier, using the Id of the workflow configuration
    ${WORKFLOW_CONFIG}    Get Workflow Configuration Request For Entity    ${ENTITY_ID}    ${WORKFLOW_CONFIG_ID}
    ${WORKFLOW_ID}    Create Workflow From Request    ${WORKFLOW_CONFIG}    1    ${ENTITY_ID}
    Task View Run CDC
    [Return]    ${WORKFLOW_ID}

Task View Create Task for Entity
    [Arguments]    ${ENTITY_ID}    ${WORKFLOW_CONFIG_ID}
    [Documentation]    Creates a task for the given entity identifier, using the Id of the workflow configuration
    ${WORKFLOW_ID}    Task View Create Workflow for Entity    ${ENTITY_ID}    ${WORKFLOW_CONFIG_ID}
    ${WORKFLOW_TASKS}    Get Workflow Tasks    ${WORKFLOW_ID}
    ${TASK_ID}    Task View First Task Id In Workflow Is    ${WORKFLOW_TASKS}
    [Return]    ${TASK_ID}

Workflow Creation Step Two Expand Task Panel
    [Arguments]    ${TASK_INDEX}
    [Documentation]    Expands the consealed tab panel for a task
    Robust Click    ${WORKFLOW_TASKS_PREFIX_ID}${TASK_INDEX}${WORKFLOW_TASKS_TOGGLE_BUTTON_SUFFIX}
    Wait Until Element Is Visible    ${WORKFLOW_TASKS_PREFIX_ID}${TASK_INDEX}${WORKFLOW_TASKS_TAB_PANEL_SUFFIX}    10s

Workflow Creation Step Two Activate Comments Tab
    [Arguments]    ${TASK_INDEX}
    Wait Until Element Is Visible    ${WORKFLOW_TASKS_PREFIX_ID}${TASK_INDEX}${WORKFLOW_TASKS_TAB_PANEL_SUFFIX}    10s
    Robust Click    ${WORKFLOW_TASKS_PREFIX_ID}${TASK_INDEX}${WORKFLOW_TASKS_COMMENTS_TAB_HEADER_SUFFIX}

Workflow Creation Step Two Enter Task Comment
    [Arguments]    ${TASK_INDEX}    ${TASK_COMMENT}
    Wait Until Page Contains Element    ${WORKFLOW_TASKS_PREFIX_ID}${TASK_INDEX}${WORKFLOW_TASKS_COMMENT_SUFFIX}    30s
    Input Text    ${WORKFLOW_TASKS_PREFIX_ID}${TASK_INDEX}${WORKFLOW_TASKS_COMMENT_SUFFIX}    ${TASK_COMMENT}

Task View List Property Contains
    [Arguments]    ${TASK_ID}    ${PROPERTY}    ${EXPECTED}
    [Documentation]    Checks that the value of the property in the task list view for the specified property
    ...
    ...    The following properties are valid:
    ...
    ...    1. - id
    ...    2. - title
    ...    3. - link
    ...    4. - duein
    ...    5. - responsible-user
    ...    6. - requester
    ...    7. - type
    ...    8. - status
    Wait Until Page Contains Element    ewb-tasks-list-info-${TASK_ID}-${PROPERTY}
    Scroll Element Into View    ewb-tasks-list-info-${TASK_ID}-${PROPERTY}
    Element Should Contain    ewb-tasks-list-info-${TASK_ID}-${PROPERTY}    ${EXPECTED}

Workflow Creation Options Select Divide Tasks Evenly
    [Documentation]    Selects the divide tasks evenly check box
    Robust Click    xpath=//span[@id='${WORKFLOW_OPTIONS_DIVIDE_TASKS_EVENLY}']//input[@type='checkbox']

Task View Add Workflow Configurations
    [Documentation]    Adds the workflow configuration to the database is they do not exist
    Connect To Database    ${POOL_USERNAME}    ${POOL_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    ${WORKFLOW_ONE_QUERY}    Query    SELECT COUNT(*) FROM entity_configurations e WHERE e.config_id = '1761200691EE431191DA2588B1E68DA0'
    ${SEQUENTIAL_QUERY}    Query    SELECT COUNT(*) FROM entity_configurations e WHERE e.config_id = '52D61BC74CD14B62BE24986BCDD817C9'
    ${WORKFLOW_TWO_QUERY}    Query    SELECT COUNT(*) FROM entity_configurations e WHERE e.config_id = '25C9BCE600954D1FBC2AC6B03057E064'
    ${WORKFLOW_REVIEW_QUERY}    Query    SELECT COUNT(*) FROM entity_configurations e WHERE e.config_id = 'FF4B755EFA1A4CD08CE7A355349EF249'
    ${WORKFLOW_DELETE_QUERY}    Query    SELECT COUNT(*) FROM entity_configurations e WHERE e.config_id = '6320C1FC636243E7BCF97F230394B346'
    ${WORKFLOW_MULTI_TASK_DELETE_QUERY}    Query    SELECT COUNT(*) FROM entity_configurations e WHERE e.config_id = 'QX4B155EFA1A4CP08CE7F355349EF549'
    ${WORKFLOW_PUBLISH_QUERY}    Query    SELECT COUNT(*) FROM entity_configurations e WHERE e.config_id = '9F222775031C4CD696E1DC043BD92599'
    ${PDF_AND_PUBLISH_WORKFLOW_QUERY}    Query    SELECT COUNT(*) FROM entity_configurations e WHERE e.config_id = 'CF366041255D4EA1837D049608A5A976'
    ${BASIC_SIGNOFF_RECORD_QUERY}    Query    SELECT COUNT(*) FROM entity_configurations e WHERE e.config_id = '56H22BF41F324D38B5319810E731D8B5'
    ${QUICK_PDF_AND_PUBLISH_WORKFLOW_QUERY}    Query    SELECT COUNT(*) FROM entity_configurations e WHERE e.config_id = '26B22BF41F324E18B5319810E731D8B5'
    ${LOCK_RECORD_DURING_WORKFLOW_QUERY}    Query    SELECT COUNT(*) FROM entity_configurations e WHERE e.config_id = '5D4C2228B5FE43C0A399335BEFDCAD21'
    ${UNLOCK_RECORD_DURING_WORKFLOW_QUERY}    Query    SELECT COUNT(*) FROM entity_configurations e WHERE e.config_id = 'D54EE834E855476AA84DA0A38689C2D2'
    ${NON_GXP_WORKFLOW_1_QUERY}    Query    SELECT COUNT(*) FROM entity_configurations e WHERE e.config_id = '9D94648C76134DC59D55D0F307F7AF4E'
    ${NON_GXP_WORKFLOW_2_QUERY}    Query    SELECT COUNT(*) FROM entity_configurations e WHERE e.config_id = '4EF7AF7BC5FD438096E7A2E35A7ACEA7'
    ${NON_GXP_WORKFLOW_3_QUERY}    Query    SELECT COUNT(*) FROM entity_configurations e WHERE e.config_id = '36C1556A08AE485596CB8E81282E0B63'
    Run Keyword If    ${WORKFLOW_ONE_QUERY[0][0]} == 0    Task View Insert Workflow Configuration    1761200691EE431191DA2588B1E68DA0    ${WORKFLOW_CONFIGURATION_ONE}
    Run Keyword If    ${SEQUENTIAL_QUERY[0][0]} == 0    Task View Insert Workflow Configuration    52D61BC74CD14B62BE24986BCDD817C9    ${SEQUENTIAL_WORKFLOW}
    Run Keyword If    ${WORKFLOW_TWO_QUERY[0][0]} == 0    Task View Insert Workflow Configuration    25C9BCE600954D1FBC2AC6B03057E064    ${WORKFLOW_CONFIGURATION_TWO}
    Run Keyword If    ${WORKFLOW_REVIEW_QUERY[0][0]} == 0    Task View Insert Workflow Configuration    FF4B755EFA1A4CD08CE7A355349EF249    ${WORKFLOW_REVIEW}
    Run Keyword If    ${WORKFLOW_DELETE_QUERY[0][0]} == 0    Task View Insert Workflow Configuration    6320C1FC636243E7BCF97F230394B346    ${WORKFLOW_DELETE}
    Run Keyword If    ${WORKFLOW_PUBLISH_QUERY[0][0]} == 0    Task View Insert Workflow Configuration    9F222775031C4CD696E1DC043BD92599    ${WORKFLOW_PUBLISH}
    Run Keyword If    ${WORKFLOW_MULTI_TASK_DELETE_QUERY[0][0]} == 0    Task View Insert Workflow Configuration    QX4B155EFA1A4CP08CE7F355349EF549    ${WORKFLOW_MULTI_TASK_DELETE}
    Run Keyword If    ${PDF_AND_PUBLISH_WORKFLOW_QUERY[0][0]} == 0    Task View Insert Workflow Configuration    CF366041255D4EA1837D049608A5A976    ${PDF_AND_PUBLISH_WORKFLOW}
    Run keyword If    ${BASIC_SIGNOFF_RECORD_QUERY[0][0]}==0    Task View Insert Workflow Configuration    56H22BF41F324D38B5319810E731D8B5    ${BASIC_SIGNOFF_RECORD}
    Run Keyword If    ${QUICK_PDF_AND_PUBLISH_WORKFLOW_QUERY[0][0]} == 0    Task View Insert Workflow Configuration    26B22BF41F324E18B5319810E731D8B5    ${QUICK_PDF_AND_PUBLISH_WORKFLOW}
    Run Keyword If    ${LOCK_RECORD_DURING_WORKFLOW_QUERY[0][0]} == 0    Task View Insert Workflow Configuration    5D4C2228B5FE43C0A399335BEFDCAD21    ${LOCK_RECORD_DURING_WORKFLOW}
    Run Keyword If    ${UNLOCK_RECORD_DURING_WORKFLOW_QUERY[0][0]} == 0    Task View Insert Workflow Configuration    D54EE834E855476AA84DA0A38689C2D2    ${UNLOCK_RECORD_DURING_WORKFLOW}
    Run Keyword If    ${NON_GXP_WORKFLOW_1_QUERY[0][0]} == 0    Task View Insert Workflow Configuration    9D94648C76134DC59D55D0F307F7AF4E    ${NON_GXP_WORKFLOW_1}
    Run Keyword If    ${NON_GXP_WORKFLOW_2_QUERY[0][0]} == 0    Task View Insert Workflow Configuration    4EF7AF7BC5FD438096E7A2E35A7ACEA7    ${NON_GXP_WORKFLOW_2}
    Run Keyword If    ${NON_GXP_WORKFLOW_3_QUERY[0][0]} == 0    Task View Insert Workflow Configuration    36C1556A08AE485596CB8E81282E0B63    ${NON_GXP_WORKFLOW_3}
    Disconnect From Database

Task View Insert Workflow Configuration
    [Arguments]    ${GUID}    ${FILENAME}
    [Documentation]    Inserts a workflow configuration into the entity configurations table
    Execute    INSERT INTO entity_configurations VALUES ('${GUID}', '1', 'WORKFLOW', empty_blob())
    Update Blob Column    entity_configurations    config_data    config_id = '${GUID}'    ${FILENAME}

Workflow Creation No Configurations Is Visible
    [Documentation]    Checks that the workflow no configurations is visible
    Sleep    5s
    Element Should Be Visible    ${WORKFLOW_NO_CONFIGURATIONS_ID}

Workflow Creation Disable Workflow Configurations
    Connect To Database    ${CORE_USERNAME}    ${CORE_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    Execute    UPDATE entity_configurations SET config_type = 'WORKFLOW_DISABLED' WHERE config_type = 'WORKFLOW'
    Disconnect From Database

Workflow Creation Enable Workflow Configurations
    Connect To Database    ${CORE_USERNAME}    ${CORE_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    Execute    UPDATE entity_configurations SET config_type = 'WORKFLOW' WHERE config_type = 'WORKFLOW_DISABLED'
    Disconnect From Database

Workflow Creation Type User Or Group
    [Arguments]    ${TASK_INDEX}    ${USER_OR_GROUP}
    [Documentation]    Type the specified user of group into the user or group suggestion box
    ${XPATH}    Set Variable    xpath=//div[@id='${WORKFLOW_TASKS_PREFIX_ID}${TASK_INDEX}${WORKFLOW_TASKS_SUGGEST_BOX_SUFFIX}']//input
    Wait Until Page Contains Element    xpath=//div[@id='${WORKFLOW_TASKS_PREFIX_ID}${TASK_INDEX}${WORKFLOW_TASKS_SUGGEST_BOX_SUFFIX}']//input    30s
    Input Text    ${XPATH}    ${USER_OR_GROUP}
    Simulate    ${XPATH}    keydown

Workflow Creation Remove User
    [Arguments]    ${TASK_INDEX}    ${USER_INDEX}
    [Documentation]    Removes the user at the specified task and user index
    ${FULL_ID}    Set Variable    ${WORKFLOW_TASKS_USERS_PREFIX_ID}${TASK_INDEX}${WORKFLOW_TASKS_REMOVE_USER_SUFFIX}${USER_INDEX}
    Robust Click    ${FULL_ID}

Workflow Creation Step Two Select Attachments Tab
    [Arguments]    ${TASK_INDEX}
    [Documentation]    Selects the task attachments panel for the specified task index
    ${FULL_ID}    Set Variable    ${WORKFLOW_TASKS_PREFIX_ID}${TASK_INDEX}${WORKFLOW_TASKS_ATTACHMENTS_TAB_HEADER_SUFFIX}
    Element Should Be Visible    ${FULL_ID}
    Robust Click    ${FULL_ID}

Workflow Detail Cancel Workflow
    [Documentation]    Clicks the cancel button on the workflow detail view
    Robust Click    ${WORKFLOW_DETAIL_CANCEL_BTN}
    Robust Click    okButton

Workflow Detail Close Workflow
    [Documentation]    Clicks the close button on the workflow detail view
    Robust Click    ${WORKFLOW_DETAIL_CLOSE_BTN}

Workflow Detail Reassign Task
    [Arguments]    ${TASK_ID}
    [Documentation]    Click the reassign button on the workflow detail page for the specified task id
    Robust Click    ewb-tasks-list-info-${TASK_ID}-reassign-button

Workflow Creation Step Two Click Create Accept First Task
    [Documentation]    Clicks cancel on the workflow creation wizard step two
    Robust Click    ${WORKFLOW_WIZARD_STEP_TWO_CREATE}
    Wait Until Page Contains Element    okButton    30s
    ${id is present}    ${value} =    Run Keyword And Ignore Error    Page Should Contain Element    ewb-workflows-creation-step-two-workflow-id
    ${workflow id}=    Run Keyword If    '${id is present}'=='PASS'    Get Value    ewb-workflows-creation-step-two-workflow-id
    Robust Click    okButton
    [Return]    ${workflow id}

Workflow Creation Check Task Has Assigned User or Group
    [Arguments]    ${TASK_ID}    ${POSITION}    ${ELEMENT_NAME}
    [Documentation]    Keyword checks that a task identified by ${TASK_ID} has the user ${ELEMENT_NAME} in the list of assigned users in the position identified by ${POSITION}..
    ...
    ...    _This keyword is only useable on the *Workflow Creation Step Two* page_ So use that keyword prior to using this keyword.
    ...
    ...    *${TASK_ID}* = The number of the task in the create workflow dialog, the task at the top of the list is value *0*, the second task in the list is value *1*, the fifth task in the list is value *4* etc.
    ...
    ...    *${POSITION}* = the position of the assigned user/group in the list. The first position in the list is *0*, the second is *1*, the fourth is *3* etc.
    ...
    ...    *${ELEMENT_NAME}* = The case sentitive username/groupname, this is not the Full Name. E.g.: *Administrator* is a valid value while *Administrator User* is not. Security Groups are also valid entries e.g.: Workflow Group 1.
    Wait Until Page Contains Element    xpath=id('ewb-workflows-creation-task-${TASK_ID}-user-widget-${POSITION}')/span[contains(@class,'gwt-InlineLabel') and text()="${ELEMENT_NAME}"]    30s

Recent Users Drop Down Contains
    [Arguments]    ${ELEMENT_NAME}
    [Documentation]    Keyword checks that the recent users drop down menu contains a user identified by *${ELEMENT_NAME}*.
    ...
    ...    This keyword is to be used *AFTER* opening the recent users dropdown, it does not open the drop down by itself.
    ...
    ...    This check only looks for the user being present, it does not care in what order.
    ...
    ...    *${ELEMENT_NAME}* = the name AND fullname of the user in the format: Name (Full Name), e.g.: David (David Birch), note the spaces and the brackets are required.
    ...
    ...    _This keyword is only of use in the *Workflow Creation Step Two* page_
    Element Should Be Visible    xpath=id('ewb-popup-menu')//a[text()="${ELEMENT_NAME}"]

Toggle Send Emails
    [Documentation]    Clicks on the send emails option checkbox to toggle it between the checked and unchecked states
    Robust Click    xpath=id('${WORKFLOW_OPTIONS_SEND_EMAILS}')/input

Toggle Divide Tasks Evenly
    [Documentation]    Clicks the workflow creation options divide tasks evenly checkbox turning it on or off.
    Robust Click    xpath=id('${WORKFLOW_OPTIONS_DIVIDE_TASKS_EVENLY}')/input

Workflow Creation Set Priority
    [Arguments]    ${NEW_PRIORITY}
    [Documentation]    Sets the priority of the workflow being created to ${NEW_PRIORITY}
    Robust Click    xpath=//*[@id="ewb-workflows-creation-options-priority-value"]/*[contains(@class, 'idbs-gwt-combobox')]
    Robust Click    xpath=//*[contains(@class, 'idbs-gwt-combobox-items')]//*[text()='${NEW_PRIORITY}']

Workflow Creation Detail Is Selected
    [Arguments]    ${ID}
    [Documentation]    Checks whether the workflow detail is enabled, the following IDs are valid
    ...
    ...    1. Lock entity - ${WORKFLOW_DETAIL_LOCK_ENTITY}
    ...
    ...    2. Delete comments - ${WORKFLOW_DETAIL_DELETE_COMMENTS}
    ...
    ...    3. Only on published - ${WORKFLOW_DETAIL_PUBLISH_ONLY}
    ...
    ...    4. Most recent - ${WORKFLOW_DETAIL_MOST_RECENT}
    ...
    ...    5. Send emails - ${WORKFLOW_DETAIL_SEND_EMAILS}
    ${FULL_ID}    Set Variable    ${ID}-checked
    Wait Until Page Contains Element    ${FULL_ID}    30s

Workflow Creation Detail Is Not Selected
    [Arguments]    ${ID}
    [Documentation]    Checks whether the workflow detail is enabled, the following IDs are valid
    ...
    ...    1. Lock entity - ${WORKFLOW_DETAIL_LOCK_ENTITY}
    ...
    ...    2. Delete comments - ${WORKFLOW_DETAIL_DELETE_COMMENTS}
    ...
    ...    3. Only on published - ${WORKFLOW_DETAIL_PUBLISH_ONLY}
    ...
    ...    4. Most recent - ${WORKFLOW_DETAIL_MOST_RECENT}
    ...
    ...    5. Send emails - ${WORKFLOW_DETAIL_SEND_EMAILS}
    Wait Until Page Contains Element    ${ID}    30s

Reassign Task To
    [Arguments]    ${USER_OR_GROUP}    ${TO_SELECT}=
    [Documentation]    Reassigns the task to the specified user or group
    ...
    ...
    ...    ${TO_SELECT} - if typing a group or department, then you can specify which user to select from the group or department
    Wait Until Element Is Visible    ${REASSIGN_SUGGEST_BOX}    30s
    Input Text    xpath=//div[@id='${REASSIGN_SUGGEST_BOX}']//input    ${USER_OR_GROUP}
    Run Keyword If    '${TO_SELECT}' is ''    Robust Click    xpath=//td[contains(@class, 'ewb-menu-item')]//span[contains(text(), '${USER_OR_GROUP}')]
    Run Keyword If    '${TO_SELECT}' is not ''    Robust Click    xpath=//td[contains(@class, 'ewb-menu-item')]//span[contains(text(), '${TO_SELECT}')]

Reassign Commit
    [Documentation]    Click the reassign button to commit and reassign the task
    Robust Click    ${REASSIGN_COMMIT_BUTTON}

Reassign Cancel
    [Documentation]    Cancels the reassign operation
    Robust Click    ${REASSIGN_CANCEL_BUTTON}

Task View Is Assigned To
    [Arguments]    ${USER}
    [Documentation]    Determines if the task is assigned to the specified user
    Wait Until Page Contains Element    xpath=//a[contains(@id,'${TASK_DETAILS_ASSIGNED_USER_PREFIX}') and text()="${USER}"]    30s

Get Most Recent Workflow ID
    [Arguments]    ${Record_Name}
    [Documentation]    Keyword checks the ENTITY_WORKFLOWS table in the database for a record identified by *${Record_Name}* and returns the _most recent_ workflow assigned to that record as the value *${Workflow_Id}*.
    ...
    ...    *${Record_Name}* = The display name of the record you wish to find the workflow id for. Case sensitive.
    ...    *${Workflow_Id}* = The return value of the workflow id for the _most recent_ workflow sent out for the selected record
    ...
    ...    *Example Use*
    ...
    ...    *${placeholder}= | Get Most Recent Workflow ID | ${Experiment 1}*
    ${entity_id}=    Get Entity ID From Name    ${Record_Name}
    Connect To Database    ${POOL_USERNAME}    ${POOL_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    ${Raw}=    Query    select workflow_id from entity_workflows where display_id in (select max(display_id) from entity_workflows where entity_id = '${entity_id}')
    ${Raw_String}=    Convert To String    ${Raw}
    @{List}    Split String    ${Raw_String}    '
    ${Workflow_Id}=    Set Variable    @{List}[1]
    [Return]    ${Workflow_Id}

Get Task ID
    [Arguments]    ${Workflow_Id}    ${Task_Name}
    [Documentation]    Keyword checks the WORKFLOW_TASKS table in the database for a task identified by *${Task_Name}* and *${Workflow_Id}* and returns the *${Task_Id}*
    ...
    ...    *${Task_Name}* = The display name of the task you wish to return. Case sensitive. if the Workflow contains multiple tasks with the same name this keyword will fail (it will return multiple task ids as a list)
    ...    *${Workflow_Id}* = The value of the workflow id for the task _use the *Get Most Recent Workflow Id* keyword to get a workflow id_
    ...    *${Task_Id}* = The return value is the task id.
    Connect To Database    ${CORE_USERNAME}    ${CORE_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    ${Raw}=    Query    select task_id from workflow_tasks where workflow_id = '${Workflow_Id}' and name = '${Task_Name}'
    ${Raw_String}=    Convert To String    ${Raw}
    @{List}    Split String    ${Raw_String}    '
    ${Task_Id}=    Set Variable    @{List}[1]
    [Return]    ${Task_Id}

Task View Accept Task
    [Documentation]    Keyword clicks the Accept button from the task header when in the task details page
    Robust Click    ewb-tasks-more-button
    Robust Click    ewb-tasks-accept-command

Task View Complete Task
    [Documentation]    Keyword clicks the Complete button from the task header when in the task details page
    Robust Click    ewb-tasks-complete-button

Task Detail Reassign Task
    [Documentation]    Keyword clicks the 'Reassign Task' button from the task details view
    Robust Click    ewb-tasks-reassign-link
    Wait Until Page Contains Element    ${REASSIGN_SUGGEST_BOX}

Workflow Details Click Task
    [Arguments]    ${TaskID}
    [Documentation]    From the workflow details view this clicks the link to the task details page for th etask identified by *${TaskID}*
    ...
    ...    *${TaskID}* = The id of the task
    Robust Click    ewb-tasks-list-info-${TaskID}-title

Show Record Workflows
    [Documentation]    From the record view this clicks the Show Workflows option
    Robust Click    ewb-record-workflows
    Robust Click    ewb-entity-command-workflows

User Suggestion Select User
    [Arguments]    ${username}    ${fullname}    ${task_number}
    [Documentation]    Clicks the user in the suggestion list of the create workflows page
    ...
    ...    *${}* = The username of th euser e.g.: Steve
    ...    *${}* = The fullname of the user e.g.: Steve Jefferies
    ...    *${task_number}* = The position of the task on the page, index count so the 1st task is 0, the second is 1 the fifth is 4 etc
    Robust Click    //td[contains(@id,'ewb-workflows-creation-task-setup-${task_number}-suggest-suggestBox-item')]/span[text()="${username} (${fullname})"]

Workflow Creation Select Create Menu Option
    [Documentation]    Select the create workflow menu option
    Robust Click    ewb-entity-command-create-workflow

Sign PDF
    [Arguments]    ${pdf name}
    [Documentation]    Checks the sign PDF dialog visible and correct, checks the confirmation checkbox and clicks sign
    Wait Until Page Contains Element    ${SIGN_PDF_ICON}    30s
    Page Should Contain Element    ${SIGN_PDF_PATH}
    Element Should Contain    ${SIGN_PDF_PATH}    ${pdf name}
    Page Should Contain Element    ${SIGN_PDF_DOWNLOAD_LINK}
    Execute Javascript    document.getElementById('okButton').className="";
    Execute Javascript    document.getElementById('okButton').removeAttribute("disabled");
    Click OK

Task View Nth Task Id In Workflow Is
    [Arguments]    ${workflow tasks}    ${task index}=0
    [Documentation]    Gets the ID of the Nth task in a workflow
    ${RAW_TASK_ID}    Get Json Value    ${WORKFLOW_TASKS}    /taskDetail/${task index}/taskId
    ${TASK_ID}    Replace String    ${RAW_TASK_ID}    "    ${EMPTY}
    Should Not Be Empty    ${TASK_ID}
    [Return]    ${TASK_ID}

Task View Nth Task Due Date Is
    [Arguments]    ${workflow tasks}    ${task index}=0
    [Documentation]    Gets the due date of the Nth task
    ${RAW}    Get Json Value    ${workflow tasks}    /taskDetail/${task index}/dueDate
    ${DATE}    Replace String    ${RAW}    "    ${EMPTY}
    Should Not Be Empty    ${DATE}
    [Return]    ${DATE}

Task View Nth Task Status Is
    [Arguments]    ${workflow tasks}    ${task index}=0
    [Documentation]    Gets the status of the Nth task
    ${RAW}    Get Json Value    ${workflow tasks}    /taskDetail/${task index}/taskStatus
    ${Status}    Replace String    ${RAW}    "    ${EMPTY}
    Should Not Be Empty    ${Status}
    [Return]    ${Status}

Task View Nth Task Responsible User Is
    [Arguments]    ${workflow tasks}    ${task index}=0
    [Documentation]    Gets the responsible user for a task
    ${RAW}    Get Json Value    ${workflow tasks}    /taskDetail/${task index}/responsibleUserName
    ${User}    Replace String    ${RAW}    "    ${EMPTY}
    Should Not Be Empty    ${User}
    [Return]    ${User}

Task View Nth Task Assigned User Is
    [Arguments]    ${workflow tasks}    ${task index}=0
    [Documentation]    Gets the assigned user for a task
    ${RAW}    Get Json Value    ${workflow tasks}    /taskDetail/${task index}/assignedUsers/user/0
    ${User}    Replace String    ${RAW}    "    ${EMPTY}
    Should Not Be Empty    ${User}
    [Return]    ${User}

Set Workflow Overdue
    [Arguments]    ${Workflow_Id}
    [Documentation]    Keyword updated TASK_STATUS_ID in the WORKFLOW_TASKS table and WORKFLOW_STATUS_ID in the ENTITY_WORKFLOW table for the *${Workflow_Id}*
    ...
    ...    *${Workflow_Id}* = The value of the workflow id. _Use the *Get Most Recent Workflow Id* keyword to get a workflow id._
    Connect To Database    ${POOL_USERNAME}    ${POOL_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    Execute    update entity_workflows set workflow_status_id = '9' where workflow_id = '${Workflow_Id}'
    Execute    update workflow_tasks set task_status_id = '9' where workflow_id = \ '${Workflow_Id}'
    Disconnect From Database

Set Task Overdue
    [Arguments]    ${Task_Id}
    [Documentation]    Keyword updated TASK_STATUS_ID in the WORKFLOW_TASKS table for the *${Task_Id}*
    ...
    ...    *${Task_Id}* = The value of the task id.
    Connect To Database    ${POOL_USERNAME}    ${POOL_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    Execute    update entity_workflows set workflow_status_id = '9' where workflow_id = (select distinct workflow_id from workflow_tasks where task_id='${Task_Id}')
    Execute    update workflow_tasks set task_status_id = '9' where task_id = \ '${Task_Id}'
    Disconnect From Database

Go To Task
    [Arguments]    ${task id}
    [Documentation]    Navigates to the specified task
    Sleep    1s    # Small delay, need this for Chrome - without this it sometimes fails to switch to the task url
    Go To    ${WEB_CLIENT_HTTP_SCHEME}://${SERVER}:${WEB_CLIENT_PORT}/EWorkbookWebApp/#task/showTask?taskId=${task id}

Go To Workflow
    [Arguments]    ${workflow id}
    [Documentation]    Navigates to the specified workflow
    Go To    ${WEB_CLIENT_HTTP_SCHEME}://${SERVER}:${WEB_CLIENT_PORT}/EWorkbookWebApp/#task/showWorkflow?workflowId=${workflow id}

Wait For Task View
    [Documentation]    Waits for the task view to be displayed
    Wait Until Page Contains Element    xpath=//div[contains(@class, 'ewb-tasks-centre-panel')]    30s

Wait For Workflow Badge To Be Visible
    Wait Until Page Contains Element    ${WORKFLOW_LINK_BADGE}    30s

Wait For Workflow Badge To Be Hidden
    Wait Until Element Not Visible    ${WORKFLOW_LINK_BADGE}    30s

Wait For Task Badge To Be Visible
    Wait Until Page Contains Element    ${TASK_LINK_BADGE}    30s

Wait For Task Badge To Be Hidden
    Wait Until Element Not Visible    ${TASK_LINK_BADGE}    30s

Workflow Link Count Should Be
    [Arguments]    ${expected-value}
    [Documentation]    Checks that the workflow badge count matches the expected value
    Run Keyword If    ${expected-value}==0    Wait For Workflow Badge To Be Hidden
    Run Keyword If    ${expected-value}>0    Wait For Workflow Badge To Be Visible
    ${TMP}=    Get Text    ${WORKFLOW_LINK_BADGE}
    ${workflow badge text}=    Evaluate    0 if not '${TMP}' else int('${TMP}')
    Should Be Equal As Integers    ${expected-value}    ${workflow badge text}

Task Link Count Should Be
    [Arguments]    ${expected-value}
    [Documentation]    Checks that the number of active tasks as shown in the task header link matches the expected value
    Run Keyword If    ${expected-value}==0    Wait For Task Badge To Be Hidden
    Run Keyword If    ${expected-value}>0    Wait For Task Badge To Be Visible
    ${TMP} =    Get Text    ${TASK_LINK_BADGE}
    ${task badge text}=    Evaluate    0 if not '${TMP}' else int('${TMP}')
    Should Be Equal As Integers    ${expected-value}    ${task badge text}

Task Link Count Indicates Overdue Task
    [Documentation]    Checks that the task link badge indicates that a task is overdue
    Wait For Task Badge To Be Visible
    ${badge_style}=    IDBSSelenium2Library.Get Element Attribute    app-header-link-tasks-badge@class
    Check String Contains    Badge displays alert    ${badge_style}    ewb-badge-alert

Workflow Creation Change Due Date
    [Arguments]    ${months}
    [Documentation]    Changes the due date by the specified number of months and selects the 15th day of that month (supports both negative and positive months)
    Robust Click    xpath=//input[@id='${WORKFLOW_OPTIONS_DATE}']
    ${day}    Get Text    xpath=//table[contains(@class, 'gwt-DatePicker')]//div[contains(@class, 'datePickerDayIsToday')]
    ${day}    Convert To Integer    ${day}
    Wait Until Page Contains Element    xpath=//div[contains(@class,'datePickerPreviousButton')]/input
    : FOR    ${_}    IN RANGE    ${months}
    \    Run Keyword If    ${months} < 0    Robust Click    xpath=//div[contains(@class,'datePickerPreviousButton')]/div
    \    Run Keyword If    ${months} > 0    Robust Click    xpath=//div[contains(@class,'datePickerNextButton')]/div
    Robust Click    xpath=//table[contains(@class, 'gwt-DatePicker')]//div[contains(@class, 'datePickerDay') and contains(text(), '15')]

Workflow Creation Check User Suggestion Count
    [Arguments]    ${expected}
    [Documentation]    Check the number of user suggestions equals the expected number
    ${SUGGESTIONS}    Get Matching Xpath Count    //td[contains(@class, 'ewb-menu-item')]/span
    Should Be Equal As Integers    ${SUGGESTIONS}    ${expected}
