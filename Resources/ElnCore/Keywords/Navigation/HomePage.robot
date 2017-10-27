*** Settings ***
Library    IDBSSelenium2Library
Library    EntityAPILibrary
Library    ManualActionLibrary
Library    DateTime
Library    Collections
Resource    ../Navigation/Resource Objects/ElnCoreNav.robot
Resource    ../Navigation/Resource Objects/TopNav.robot
Resource    ../Navigation/Resource Objects/NavTree.robot
Resource    ../Navigation/Resource Objects/AuditLog.robot
Resource    ../Navigation/Resource Objects/Search.robot
Resource    ../Navigation/Resource Objects/MyTasks.robot
Resource    ../Navigation/Resource Objects/VersionHistory.robot
Resource    ../Access Control/Resource Objects/LoginPage.robot
Resource    ../Navigation/Resource Objects/DisplayPages.robot
#Resource    ../Common/common_resource.robot
Resource    ../Selenium/display_pages.robot

*** Variables ***
${TIMESTAMP}
${CONFIRM_SIGNOFF_COMMENT} =

*** Keywords ***
Verify Login Successful
    ElnCoreNav.Check Header Title Exists
    ElnCoreNav.Check HomePage Root Exists
    # Wait Until Page Contains Element    ${HOMEPAGE_ROOTELEMENT}

Select Administrator Group Node
    NavTree.Select Administrator Group Node
    Wait Until Title Is    IDBS E-WorkBook - Administrators    30s

Signout of ElnCore
    Go To Account Menu
    Select Signout

Close Browser
    Close All Browsers

Create New Project
    [Arguments]    ${PROJECT_NAME}
    Select New Tile
    Select Create New Project
    Enter New Project Name    ${PROJECT_NAME}
    Save Properties

Create New Group
    [Arguments]    ${GROUP_NAME}
    Select New Tile
    Select Create New Group
    Enter New Group Name    ${GROUP_NAME}
    Save Properties

Create New Blank Experiment
    [Arguments]    ${EXPERIMENT_NAME}
    Select New Tile
    set selenium speed    1
    Select Create New Blank Experiment
    #Enter Mandatory Field - Project Name
    set selenium speed    0
    Enter New Experiment Name    ${EXPERIMENT_NAME}
    Save Properties
    Select Save As Button
    Select Discard Changes

Confirm Permission Denied for Experiment
    ElnCoreNav.Select New Tile
    Permission Denied Confirmation Displayed

Confirm Permission Denied for Record
    Select New Record Tile
    Record Edit Permission Denied Confirmation Displayed

Confirm Permission Denied for Sign Off
    Sign Off Permission Denied Message Displayed

Create New Template
    [Arguments]    ${TEMPLATE_NAME}
    Select New Tile
    set selenium speed    1
    Select Create New Template
    Enter New Template Name    ${TEMPLATE_NAME}
    Save Properties
    set selenium speed    0
    Select Save As Button
    Select Discard Changes


Create Experiment from Template
    [Arguments]    ${template_name}    ${experiment_name}
    Select New Tile
    Select Find Template
    #Manual Action    Select Template Name    #${template_name}
    Select Template Name    ${template_name}
    set selenium speed    1
    Select Choose Template
    #wait until keyword succeeds  5mins    5s    Enter Mandatory Field - Project Name
    Enter New Experiment Name    ${experiment_name}
    Save Properties
    set selenium speed    0
    Select Save As Button
    Select Discard Changes

Verify Node Selected
    [Arguments]    ${NODE_NAME}
    Wait Until Title Is    IDBS E-WorkBook - ${NODE_NAME}    30s

Verify Group Created
    [Arguments]    ${GROUP_NAME}
    Wait Until Title Is    IDBS E-WorkBook - ${GROUP_NAME}    30s

Verify Experiment Created
    [Arguments]    ${EXPERIMENT_NAME}
    Wait Until Title Is    IDBS E-WorkBook - ${EXPERIMENT_NAME}    30s

Verify Experiment Not Present
    [Arguments]    ${experiment_name}
    wait until page does not contain element  xpath=//div[@class='gwt-Hyperlink ewb-entity-treenode-text']/a[text()='${experiment_name}']

Select Project Node
    [Arguments]    ${PROJECT_NAME}
    NavTree.Select Project Node    ${PROJECT_NAME}
    Wait Until Title Is    IDBS E-WorkBook - ${PROJECT_NAME}    30s

Select Template Node
    [Arguments]    ${PROJECT_NAME}
    NavTree.Select Project Node    ${PROJECT_NAME}
    Wait Until Title Is    IDBS E-WorkBook - ${PROJECT_NAME}    30s

Select Experiment Node
    [Arguments]    ${EXPERIMENT_NAME}
    #${EXPERIMENT_ENTITYID} =   Get Entity Id    "/Root/Administrators/OQ Project/${EXPERIMENT_NAME}"
    #EntityAPILibrary.Unlock Entity    ${EXPERIMENT_ENTITYID}
    set selenium speed    1
    NavTree.Select Experiment Node    ${EXPERIMENT_NAME}
    Wait Until Title Is    IDBS E-WorkBook - ${EXPERIMENT_NAME}    30s
    set selenium speed    0

Select Audit History Menu Option
    NavTree.Select Audit History Menu Option
    AuditLog.Select Audit Window
    AuditLog.Check Header Title Exists

Select E-WorkBook Tab
    Wait Until Keyword Succeeds    10    2    Select Window

New Version Save
    [Arguments]    ${username}    ${password}    ${VERSION_SAVE_COMMENT}
    set selenium speed     1
    ElnCoreNav.Select Save As Button
    ElnCoreNav.Select New Version from Menu
    Run Keyword If    '${AuthType}' == 'EWBSERVER'    LoginPage.Enter Login Credentials    ${username}    ${password}
    ElnCoreNav.Enter Version Save Reason
    ElnCoreNav.Enter Version Save Comment    ${VERSION_SAVE_COMMENT}
    LoginPage.Submit Credentials
    #Run Keyword If    '${AuthType}' == 'SSO'    LoginPage.Enter SSO Login Credentials    ${username}    ${password}
    Run Keyword if    '${AuthType}' == 'SAML'    run keyword and ignore error    SAML ReAuth Check    ${username}    ${password}
    set selenium speed    1

SAML ReAuth Check
    [Arguments]    ${username}    ${password}
    Sleep  5s
    ${windowlist}=    get window titles
    ${auth_window}=    set variable    Re-authenticating...
    ${ewb_window}=    Get Title
    ${reauthenticate}=    evaluate    '${auth_window}' in ${windowlist}
    #Run Keyword If    $auth_window in $windowlist    SAML ReAuth Login   ${ewb_window}    ${auth_window}    ${username}    ${password}
    Run Keyword If    ${reauthenticate}    SAML ReAuth Login   ${ewb_window}    ${auth_window}    ${username}    ${password}

SAML ReAuth Login
    [Arguments]    ${ewb_window}    ${auth_window}    ${username}    ${password}
    select window    ${auth_window}
    LoginPage.Enter SAML ReAuth Login Credentials    ${username}    ${password}
    wait until keyword succeeds    3    2    select window    ${ewb_window}

Discard Changes
    Select Save As Button
    Select Discard Changes

Select Review and Sign
    ElnCoreNav.Select Review and Sign Button

Select Sign Off Record from Menu
    ElnCoreNav.Select Sign Off Record from Menu

Select Publish PDF
    ElnCoreNav.Select Publish PDF from Menu

Select Create Workflow
    [Arguments]  ${WORKFLOW}    ${ACTIONER_USER}    ${REVIEWER_USER}
    ElnCoreNav.Select Workflow Template from Menu     ${WORKFLOW}
    sleep    1s
    ElnCoreNav.Select Most Recent User Dropdown    0
    ElnCoreNav.Set User     ${ACTIONER_USER}
    ElnCoreNav.Select Most Recent User Dropdown    1
    ElnCoreNav.Set User     ${REVIEWER_USER}
    ElnCoreNav.Select Create Workflow Button
    sleep    1s
    ElnCoreNav.Select Popup Option    Yes
    #ElnCoreNav.Check Workflow Active    Non GxP Sign Off 1

Check Record Version
    [Arguments]    ${experiment_name}    ${version}
    NavTree.Select Record Options Menu     ${experiment_name}
    NavTree.Select Properties Option
    NavTree.Check Version Number    ${version}

Acknowledge Publishing Dialog
    ElnCoreNav.Publishing Dialog Appears
    ElnCoreNav.Select Ok Button


Set Workflow Value "Do not start..."
    ElnCoreNav.Enter Workflow Value "Quick Sign Off"

Set Workflow Value
    [Arguments]    ${workflow_name}
    ElnCoreNav.Enter Workflow Value    ${workflow_name}


#Select Sign All
    #ElnCoreNav.Select Sign All Button
    #ElnCoreNav.Confirm Sign All Action complete

Select Record Options Menu
    [Arguments]    ${EXPERIMENT_NAME}
    NavTree.Select Record Options Menu    ${EXPERIMENT_NAME}

Select Search Icon
    ElnCoreNav.Select Search Image
    sleep    1s
    Search.Verify Search Page Loaded

Select My Tasks Navigation
    ElnCoreNav.Select My Tasks
    sleep    1s
    MyTasks.Verify My Tasks Page Loaded

Select Navigator Navigation
    ElnCoreNav.Select Navigator
    sleep    1s

Check Experiment is Locked
    [Arguments]    ${experiment_name}
    NavTree.Select Record Options Menu    ${experiment_name}
    NavTree.Confirm Editing Not Permitted

Check Experiment is UnLocked
    [Arguments]    ${experiment_name}
    Select Record Options Menu    ${experiment_name}
    NavTree.Confirm Editing Permitted

Check Experiment Can be Deleted
    [Arguments]    ${experiment_name}
    NavTree.Select Record Options Menu    ${experiment_name}
    NavTree.Confirm Delete Experiment Permitted

Check Experiment Cannot be Deleted
    [Arguments]    ${experiment_name}
    NavTree.Select Record Options Menu    ${experiment_name}
    NavTree.Confirm Delete Experiment Not Permitted

Delete Experiment
    [Arguments]    ${experiment_name}    ${user}    ${password}
    Check Experiment Can be Deleted    ${experiment_name}
    NavTree.Select Experiment Delete Option
    HomePage.Confirm Sign Off    ${user}     ${password}     Delete Experiment

Select Allow Further Editing
    [Arguments]    ${User1}    ${User1PWD}
    Set Selenium speed    2
    ElnCoreNav.Select Record Options Menu
    ElnCoreNav.Select Allow Further Editing
    Run Keyword If    '${AuthType}' == 'EWBSERVER'    LoginPage.Enter Login Credentials    ${User1}    ${User1PWD}
    Run Keyword If    '${AuthType}' == 'EWBSERVER'    LoginPage.Submit Credentials
    Run Keyword If    '${AuthType}' == 'SAML'    SAML ReAuth Check    ${User1}    ${User1PWD}
    Set Selenium Speed    1

Update Office Document
    [Arguments]    ${test_path}     ${document_name}
    ElnCoreNav.Select Entity Options Menu    1
    ElnCoreNav.Select Menu Update File Option
    ElnCoreNav.Update File Window Displayed
    ElnCoreNav.Select File to Update    ${test_path}    ${document_name}
    Click Button        okButton



Insert Text Record Item
    ElnCoreNav.Select Insert Record Item Button
    Select Text Item

Confirm Item Entry Displayed
    [Arguments]    ${item}    ${entity_ref}    ${text}
    NavTree.Select Item Node    ${item}
    ElnCoreNav.Select Edit Button    ${entity_ref}
    DisplayPages.Check screen for Text Item content    ${text}
    ElnCoreNav.Select Discard Text Change    ${entity_ref}

Confirm Template Item Entry Displayed
    [Arguments]    ${item}    ${entity_ref}    ${text}
    NavTree.Select Item Node    ${item}
    ElnCoreNav.Select Edit Button    ${entity_ref}
    DisplayPages.Check Template screen for Text Item content    ${text}
    ElnCoreNav.Select Discard Text Change    ${entity_ref}

Insert Image Item
    ElnCoreNav.Select Insert Record Item Button
    Select Text Item

Insert Text Into Item
    [Arguments]    ${text_entry}
    Add Text To Text Item    ${text_entry}
    Select Apply Text Change

Edit Text In Item
    [Arguments]    ${entity_ref}    ${TEXTENTRY}
    ElnCoreNav.Click on Text Item Header
    ElnCoreNav.Select Edit Button    ${entity_ref}
    HomePage.Insert Text Into Item    ${TEXTENTRY}

Publish Flag Set for Record
    [Arguments]    ${item_ref}    ${Item Type}
    ElnCoreNav.Confirm Item Published    ${item_ref}
    Log     ${Item Type} Published

Accept Signatures Warning Message
    [Arguments]     ${username}    ${password}    ${item_ref}    ${signoff_message}
    ElnCoreNav.Confirm Warning Dialog is Present
    ElnCoreNav.Select Ok Button
    HomePage.Confirm Sign Off    ${username}    ${password}    ${signoff_message}
    set selenium speed    1
    #LoginPage.Submit Credentials
    #Manual Action    HomePage.Apply Changes
    HomePage.Apply Changes
    set selenium speed    1

Confirm Save Complete
    wait until page does not contain element    xpath=//*[@src='resources/images/site/progressbar.gif']    timeout=120

Insert Spreadsheet Item
    ElnCoreNav.Select Insert Record Item Button
    Select Spreadsheet Item

Insert File and Image Item
    [Arguments]    ${FILE}
    Add File Item    OTHER    ${FILE}    FILE

Add Text to Image Item
    [Arguments]    ${item_index}    ${text_entry}
    ElnCoreNav.Select Image
    ElnCoreNav.Select Edit Button   ${item_index}
    ElncoreNav.Select Plus Menu Item
    ElncoreNav.Select Add Text Option
    ElnCoreNav.Select Image in Editor
    ElnCoreNav.Add Text to Text Area    ${text_entry}
    ElnCoreNav.Select Apply Button

Display Spreadsheet Document
    [Arguments]    ${ITEM_INDEX}    ${page_no}
    Open Display Pages Dialog    ${ITEM_INDEX}
    sleep    2s
    DisplayPages.Select All Pages
    DisplayPages.Click Insert Button
    DisplayPages.Check screen for Spreadsheet Content    ${ITEM_INDEX}    ${page_no}

Display Office Document
    [Arguments]    ${ITEM_INDEX}
    Open Display Pages Dialog    ${ITEM_INDEX}
    sleep    2s
    DisplayPages.Select All Pages
    DisplayPages.Click Insert Button
    DisplayPages.Check screen for Office Document Content    ${ITEM_INDEX}

Assign Witness Sign Off Task
    [Arguments]    ${ADMIN_USER}    ${ADMIN_PW}    ${assignee}
    #HomePage.Confirm Sign Off    ${ADMIN_USER}    ${ADMIN_PW}    FOQ-ELN-10 Record Sign Off
    Assign Task Window Displayed
    #ElnCoreNav.Select Reviewer Dropdown    1     # commented as set in Workflow directly
    #ElnCoreNav.Set User     ${assignee}          # commented as set in Workflow directly
    ElnCoreNav.Select Ok Button


Select Sign All
    ElnCoreNav.Select Sign All Button

Delete Document
    [Arguments]    ${item_index}
    ElnCoreNav.Select Delete Option    ${item_index}
    ElnCoreNav.Confirm Deletion of Document

Select Version History from Record Options Menu
    [Arguments]    ${experiment_name}
    ElnCoreNav.Select Record Options Menu
    Select Version History
    VersionHistory.Confirm Version History Displayed    ${experiment_name}

Check Experiment Status
    [Arguments]   ${EXPT_STATUS}
    ElnCoreNav.Confirm Status Value    ${EXPT_STATUS}

Complete Sign Off as Actioner
    ElnCoreNav.Select Record Item for Sign off    0
    ElnCoreNav.Select Record Item for Sign off    1
    ElnCoreNav.Select Record Item for Sign off    2
    ElnCoreNav.Select Sign Selected Button

Confirm Actioner Signed
    ElnCoreNav.Actioner Signed Confirmed    0
    ElnCoreNav.Actioner Signed Confirmed    1
    ElnCoreNav.Actioner Signed Confirmed    2

Apply Changes
    Select Apply Text Change

Confirm Signature Panel Removed
    [Arguments]    ${item_ref}
    Signature Panel Removed for Item    ${item_ref}


Complete Sign Off as Reviewer
    [Arguments]
    #Select My Tasks
    #Select Task for Review   <div class="task-workflow-list-view-panel"  id="ewb-tasks-list-info-.../Root/Administrators/OQ Project/Instance OQ Experiment-2017-05-31 12:18</a>
    #Select Complete option    <button id="ewb-tasks-complete-button"
    #Select Close Button       <button id="ewb-tasks-close-button"


Confirm Sign Off
    [Arguments]    ${USER}    ${PASSWORD}    ${COMMENT}
    [Documentation]    Confirm Sign Off using the ${user} and ${password} variables
    set selenium speed     1
    Run Keyword If    '${AuthType}' == 'EWBSERVER'    LoginPage.Enter Login Credentials    ${USER}    ${PASSWORD}
    Run Keyword If    '${AuthType}' == 'SSO'    LoginPage.Enter SSO Login Credentials    ${USER}    ${PASSWORD}
    ElnCoreNav.Enter Version Save Reason
    ElnCoreNav.Enter Version Save Comment    ${COMMENT}
    LoginPage.Submit Credentials
    Run Keyword if    '${AuthType}' == 'SAML'    run keyword and ignore error    SAML ReAuth Check    ${USER}    ${PASSWORD}
    set selenium speed    1

Record Timestamp
    ${TIMESTAMP}=     Get Current Date    result_format=%Y-%m-%d %H:%M
    log    ${TIMESTAMP}
    set test variable    ${TIMESTAMP}

