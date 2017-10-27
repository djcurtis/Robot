*** Settings ***
Library    IDBSSelenium2Library
Library    EntityAPILibrary
Library    DateTime
Library    ManualActionLibrary
Resource    ../Navigation/Resource Objects/ElnCoreNav.robot
Resource    ../Navigation/Resource Objects/TopNav.robot
Resource    ../Navigation/Resource Objects/NavTree.robot
Resource    ../Navigation/Resource Objects/AuditLog.robot
Resource    ../Navigation/Resource Objects/Search.robot
Resource    ../Navigation/Resource Objects/VersionHistory.robot
Resource    ../Access Control/Resource Objects/LoginPage.robot
Resource    ../Navigation/Resource Objects/DisplayPages.robot
Resource    ../Selenium/display_pages.robot

*** Variables ***
${TIMESTAMP}
${CONFIRM_SIGNOFF_COMMENT} =    xpath=//*[@id='ewb-authentication-user-additional-comment']

*** Keywords ***

Select Version from Tree
    [Arguments]    ${experiment_name}    ${version_reference}
    VersionHistory.Click Version Node    ${version_reference}
    VersionHistory.Confirm Version Selected    ${experiment_name}    ${version_reference}

Confirm Documents Signed
    [Arguments]    ${no_of_documents}    ${no_of_signatures}
    ${no_of_documents}=    Evaluate    ${no_of_documents} - 1
    page should contain element  xpath=//*[@id="document-header-${no_of_documents}-menuButton"]
    ${no_of_signatures}=   Evaluate    ${no_of_signatures} - 1
    page should contain element  xpath=//*[@id="document-signatures-${no_of_signatures}-panel"]

Restore Previous Version
    [Arguments]    ${version_number}
    VersionHistory.Select Restore Record
    VersionHistory.Accept Removal of Signatures Dialog


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
    Close All Browsers

Create New Project
    [Arguments]    ${PROJECT_NAME}
    Select New Tile
    Select Create New Project
    Enter New Project Name    ${PROJECT_NAME}
    Save Properties

Create New Blank Experiment
    [Arguments]    ${EXPERIMENT_NAME}
    Select New Tile
    Select Create New Blank Experiment
    Enter New Experiment Name    ${EXPERIMENT_NAME}
    Save Properties
    Select Save As Button
    Select Discard Changes

Create New Template
    [Arguments]    ${TEMPLATE_NAME}
    Select New Tile
    Select Create New Template
    Enter New Template Name    ${TEMPLATE_NAME}
    Save Properties
    Select Save As Button
    Select Discard Changes

Create Experiment from Template
    [Arguments]    ${template_name}    ${experiment_name}
    Select New Tile
    Select Find Template
    Select Template Name    ${template_name}
    Select Choose Template  #fails here
    wait until keyword succeeds  5mins    5s    Enter New Experiment Name    ${experiment_name}
    Save Properties
    Select Save As Button
    Select Discard Changes

Verify Project Created
    [Arguments]    ${PROJECT_NAME}
    Wait Until Title Is    IDBS E-WorkBook - ${PROJECT_NAME}    30s

Verify Experiment Created
    [Arguments]    ${EXPERIMENT_NAME}
    Wait Until Title Is    IDBS E-WorkBook - ${EXPERIMENT_NAME}    30s

Select Project Node
    [Arguments]    ${PROJECT_NAME}
    NavTree.Select Project Node    ${PROJECT_NAME}
    Wait Until Title Is    IDBS E-WorkBook - ${PROJECT_NAME}    30s

Select Experiment Node
    [Arguments]    ${EXPERIMENT_NAME}
    #${EXPERIMENT_ENTITYID} =   Get Entity Id    "/Root/Administrators/OQ Project/${EXPERIMENT_NAME}"
    #EntityAPILibrary.Unlock Entity    ${EXPERIMENT_ENTITYID}
    NavTree.Select Experiment Node    ${EXPERIMENT_NAME}
    Wait Until Title Is    IDBS E-WorkBook - ${EXPERIMENT_NAME}    30s

Select Audit History Menu Option
    NavTree.Select Audit History Menu Option
    AuditLog.Select Audit Window
    AuditLog.Check Header Title Exists

Select E-WorkBook Tab
    Wait Until Keyword Succeeds    10    2    Select Window

New Version Save
    [Arguments]    ${VERSION_SAVE_COMMENT}
    ElnCoreNav.Select Save As Button
    ElnCoreNav.Select New Version from Menu
    LoginPage.Enter Login Credentials    ${ADMIN_USER}     ${ADMIN_PW}
    ElnCoreNav.Enter Version Save Reason
    ElnCoreNav.Enter Version Save Comment    ${VERSION_SAVE_COMMENT}
    LoginPage.Submit Credentials

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

Set Workflow Value "Do not start..."
    [Arguments]
    ElnCoreNav.Enter Workflow Value "Quick Sign Off"

Set Workflow Value
    [Arguments]    ${workflow_name}
    ElnCoreNav.Enter Workflow Value    ${workflow_name}


Select Sign All
    ElnCoreNav.Select Sign All Button

Select Record Options Menu
    [Arguments]    ${EXPERIMENT_NAME}
    NavTree.Select Record Options Menu    ${EXPERIMENT_NAME}

Select Search Icon
    ElnCoreNav.Select Search Image
    sleep    1s
    Search.Verify Search Page Loaded

Insert Text Record Item
    ElnCoreNav.Select Insert Record Item Button
    Select Text Item

Insert Image Item
    ElnCoreNav.Select Insert Record Item Button
    Select Text Item

Insert Text Into Item
    [Arguments]    ${text_entry}
    Add Text To Text Item    ${text_entry}
    Select Apply Text Change

Edit Text In Item
    [Arguments]    ${TEXTENTRY}
    ElnCoreNav.Click on Text Item Header
    ElnCoreNav.Select Edit Button
    Insert Text Into Item    ${TEXTENTRY}

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


Display Document
    [Arguments]    ${ITEM_INDEX}
    Open Display Pages Dialog    ${ITEM_INDEX}
    sleep    2s
    DisplayPages.Select All Pages
    DisplayPages.Click Insert Button

Delete Document
    [Arguments]    ${item_index}
    Select Delete Option    ${item_index}
    Confirm Deletion of Document

Select Version History from Record Options Menu
    [Arguments]    ${experiment_name}
    Select Record Options Menu
    Select Version History
    Confirm Version History Displayed    $[experiment_name]
    #TODO Entity Version History Opens (and displays all versions for "Full OQ Extended ELN Expt <Date>" record).

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


Complete Sign Off as Reviewer
    [Arguments]
    #Select My Tasks
    #Select Task for Review   <div class="task-workflow-list-view-panel"  id="ewb-tasks-list-info-.../Root/Administrators/OQ Project/Instance OQ Experiment-2017-05-31 12:18</a>
    #Select Complete option    <button id="ewb-tasks-complete-button"
    #Select Close Button       <button id="ewb-tasks-close-button"


Confirm Sign Off
    [Arguments]    ${USER}    ${PASSWORD}    ${COMMENT}
    [Documentation]    Confirm Sign Off using the ${user} and ${password} variables
    Input Username    ${user}
    Input Password    ${password}
    Input Text    ${CONFIRM_SIGNOFF_COMMENT}    Comment for OQ Version Save


Record Timestamp
    ${TIMESTAMP}=     Get Current Date    result_format=%Y-%m-%d %H:%M
    log    ${TIMESTAMP}
    set test variable    ${TIMESTAMP}

