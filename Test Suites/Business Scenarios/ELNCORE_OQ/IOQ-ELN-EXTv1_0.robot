*** Settings ***
Documentation     ElnCore OQ Extended Test Suite
...
...               The OQ test specification, which is described below, is designed to extend the tests performed in
...               Instance OQ - ELN test to confirm that the E-WorkBook ELN/Core is functioning as expected for use
...               in a validated environment.
...
...               Prerequisites
...               This test assumes that the  E-WorkBook has not been modified from the installed product and that
...               the  Instance OQ - ELN v1.0 been executed (ie Instance OQ project already exists).
...
...               It requires the following document to be available Example Office Document.docx
...               A specific Task Workflow configuration is required on project Instance OQ. This configuration needs
...               to be performed in the desktop client and is described in: OQ Workflow Configuration .docx
...
...               External editor component has already been installed on the client machine performing the test.
...
...               A second E-WorkBook user.
...
...               MS Word is installed on the client machine performing the test.
Suite Setup
Suite Teardown
Test Setup
Test Teardown
Force Tags
Resource          ../../../Resources/ElnCore/Keywords/Access Control/LoginPage.robot
Resource          ../../../Resources/ElnCore/Keywords/Navigation/HomePage.robot
Resource          ../../../Resources/ElnCore/Keywords/Navigation/MyTasks.robot
Resource          ../../../Resources/ElnCore/Keywords/Navigation/AuditLog.robot
Resource          ../../../Resources/ElnCore/Keywords/Navigation/NavTree.robot
Resource          ../../../Resources/ElnCore/Keywords/Navigation/VersionHistory.robot
Library           IDBSSelenium2Library
Library           IDBSHttpLibrary
Library           DateTime
Library           EntityAPILibrary
Library           TestDataGenerationLibrary
Library           ManualActionLibrary
Library           OperatingSystem
Library           Dialogs
Resource          ./Test data/IOQ-ELN-Config - internal.robot

#pybot -T -d results "Test Suites/Business Scenarios/ELNCORE_OQ/IOQ-ELN-EXTv1_0.robot"

*** Variables ***
${DATE}           ${EMPTY}

*** Test Cases ***

FOQ-ELN-0: Execution Log
    [Documentation]
    ...
    [Tags]    MANUAL
    ${TESTED_BY}=    Get Value from User    Name of person performing test:    default
    ${BROWSER_VERSION}=    Get Value from User    Browser and version used to perform test:    Chrome Version 60.0.3112.78 (Official Build) (64-bit)
    Manual Action    Attach Screen shot of Operating System Version Thick Client Installed on
    Manual Action    Attach Screen shot of Thick Client About Page used for Web Client Administration

FOQ-ELN-1: Access Control - Valid Login
    [Documentation]    Test successful E-WorkBook Password Server login to the E-WorkBook web application
    ...    Following correct user credentials being inserted a successful login
    ...    occurs and the user is presented with the navigator view.
    ...
    ...
    ...    An authenticated user can access the application with appropriate credentials based
    ...    on the authentication method being used.
    [Tags]    AUTO    SYSTEM_ACCESS
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    HomePage.Signout of ElnCore
    HomePage.Close Browser

FOQ-ELN-2: Ability to create a project in E-WorkBook
    [Documentation]    Ability to create a project in E-WorkBook
    ...    Project is created with the title "OQ Project"
    [Tags]    AUTO    CREATE_PROJECT
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    NavTree.Create Project    OQ Project
    HomePage.Signout of ElnCore
    HomePage.Close Browser

FOQ-ELN-3: Ability to create a template in E-WorkBook
    [Documentation]    User creates a template called "Full OQ Extended ELN Template <Date>" and adds content:
    ...    Template is created with the title "Full OQ Extended ELN Template <Date>" and contains a text item and Office (Word) document.
    [Tags]    AUTO    CREATE_TEMPLATE
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    #HomePage.Select Project Node    OQ Template
    #HomePage.Select Project Node    Template Folder
    Capture Current Date
    HomePage.Create New Template    Full OQ Extended ELN Template ${DATE}
    HomePage.Insert Text Record Item
    HomePage.Insert Text into Item    This is an example of some text
    HomePage.Confirm Template Item Entry Displayed    Text    0    This is an example of some text
    HomePage.Insert File and Image Item    ${CURDIR}/Test Data/Example Office Document.docx
    HomePage.Display Office Document    1    #Word DOC = 1
    HomePage.New Version Save    ${ADMIN_USR}    ${ADMIN_PW}    FOQ-ELN-3 create template
    HomePage.Select Review and Sign
    HomePage.Select Sign Off Record from Menu
    HomePage.Set Workflow value "Do not start..."
    HomePage.Select Sign All
    HomePage.Confirm Sign Off    ${ADMIN_USR}    ${ADMIN_PW}    FOQ-ELN-3 Record Sign Off
    HomePage.Signout of ElnCore
    HomePage.Close Browser

FOQ-ELN-4: Ability to create a record (Experiments) in E-WorkBook from a template.
    [Documentation]    User creates an experiment called "Full OQ Extended ELN Expt <Date>" within the system using a template:
    ...    Blank Experiment is created with the title "Instance OQ Expt <Date>." With <Date> being
    ...
    ...    Experiment is created with the title "Full OQ Extended ELN Expt <Date>." With <Date> being replaced with the
    ...    date when test is executed. The experiment contains a text item, containing the text "This is an example of some
    ...    text" and a word document with the page displayed.
    ...    FOQ-ELN-19 is also referenced in this test by checking the audit log after the test
    [Tags]    AUTO    CREATE_RECORD
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Create Experiment from Template    Full OQ Extended ELN Template ${DATE}     Full OQ Extended ELN Expt ${Date}
    HomePage.Verify Experiment Created    Full OQ Extended ELN Expt ${Date}
    HomePage.Select Experiment Node     Full OQ Extended ELN Expt ${Date}
    NavTree.Select Audit History   Full OQ Extended ELN Expt ${Date}
    AuditLog.Check Audit for Create Experiment    Full OQ Extended ELN Expt ${Date}
    HomePage.Signout of ElnCore
    HomePage.Close Browser

FOQ-ELN-5: Ability to edit a text item.
    [Documentation]    User edits text item:
    ...    Text item is updated and contains the extra text added "An edit has been performed."
    ...    FOQ-ELN-19 is also referenced in this test by checking the audit log after the test
    [Tags]    AUTO    ADD_TEXT_ITEM
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node        Full OQ Extended ELN Expt ${Date}
    HomePage.Edit Text in Item    0    An edit has been performed
    HomePage.New Version Save    ${ADMIN_USR}    ${ADMIN_PW}    FOQ-ELN-6 Edit Text Item
    sleep    1s
    HomePage.Select Experiment Node     Full OQ Extended ELN Expt ${Date}
    #HomePage.Confirm Text Item Entry Displayed    0    An edit has been performed
    NavTree.Select Audit History   Full OQ Extended ELN Expt ${Date}
    AuditLog.Check Audit for Edit Text Item    Full OQ Extended ELN Expt ${Date}
    HomePage.Signout of ElnCore
    HomePage.Close Browser

FOQ-ELN-6: Ability to edit an Office document
    [Documentation]    User edits Word document:
    ...    In record (experiment) view, display page is updated and shows the extra text added "An edit has been performed."
    ...    FOQ-ELN-19 is also referenced in this test by checking the audit log after the test
    [Tags]    MANUAL    INSERT_ITEM    TEST
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node        Full OQ Extended ELN Expt ${Date}
    HomePage.Update Office Document    Test Suites/Business Scenarios/ELNCORE_OQ/Test Data/Document Revision    Example Office Document.docx
    HomePage.New Version Save    ${ADMIN_USR}    ${ADMIN_PW}    FOQ-ELN-6 Edit Office Document
    sleep    1s
    HomePage.Select Experiment Node     Full OQ Extended ELN Expt ${Date}
    NavTree.Select Audit History   Full OQ Extended ELN Expt ${Date}
    AuditLog.Check Audit for Edit Office Document    Full OQ Extended ELN Expt ${Date}
    HomePage.Signout of ElnCore
    HomePage.Close Browser

FOQ-ELN-7: Ability to insert an image and Version Save
    [Documentation]    User adds the following items to the newly created experiment and saves a new version
    ...    Image is added to the experiment and is displayed.
    ...    Experiment is Version Saved. Version Type states "Version."
    ...    FOQ-ELN-19 is also referenced in this test by checking the audit log after the test
    [Tags]    AUTO    INSERT_IMAGE
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node        Full OQ Extended ELN Expt ${Date}
    HomePage.Insert File and Image Item    ${CURDIR}/Test Data/Gel.png
    HomePage.New Version Save    ${ADMIN_USR}    ${ADMIN_PW}    FOQ-ELN-7 Version Save
    sleep    1s
    HomePage.Select Experiment Node     Full OQ Extended ELN Expt ${Date}
    NavTree.Select Audit History   Full OQ Extended ELN Expt ${Date}
    AuditLog.Check Audit for Inserting an Image    Full OQ Extended ELN Expt ${Date}
    NavTree.Select Audit History   Full OQ Extended ELN Expt ${Date}
    AuditLog.Check Audit for Version Save    Full OQ Extended ELN Expt ${Date}    2    FOQ-ELN-7 Version Save
    HomePage.Signout of ElnCore
    HomePage.Close Browser

FOQ-ELN-8: Ability to Edit an Image and Version Save
    [Documentation]    User adds annotation to image:
    ...    Image item in experiment updates to show the text "Band."
    ...    Experiment is Version Saved. Version Type states "Version."
    ...    FOQ-ELN-19 is also referenced in this test by checking the audit log after the test
    [Tags]    AUTO    EDIT_IMAGE
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node    Full OQ Extended ELN Expt ${Date}
    HomePage.Add Text to Image Item    2    Band
    HomePage.New Version Save    ${ADMIN_USR}    ${ADMIN_PW}    FOQ-ELN-8 Version Save
    sleep    1s
    HomePage.Select Experiment Node     Full OQ Extended ELN Expt ${Date}
    NavTree.Select Audit History   Full OQ Extended ELN Expt ${Date}
    AuditLog.Check Audit for Editting an Image    Full OQ Extended ELN Expt ${Date}    Gel.png    2
    HomePage.Signout of ElnCore
    HomePage.Close Browser

FOQ-ELN-9: Ability to add an Office Document
    [Documentation]    User adds the following items to the newly created experiment
    ...    Excel document is inserted into the experiment and the page of the document is shown on the screen.
    ...    FOQ-ELN-19 is also referenced in this test by checking the audit log after the test
    [Tags]    AUTO    ADD_DOCUMENT
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node    Full OQ Extended ELN Expt ${Date}
    HomePage.Insert File and Image Item    ${CURDIR}/Test Data/Example Excel Document.xlsx
    HomePage.Display Office Document    3    #Excel DOC = 3
    HomePage.Select Experiment Node    Full OQ Extended ELN Expt ${Date}
    HomePage.New Version Save    ${ADMIN_USR}    ${ADMIN_PW}    FOQ-ELN-9 Version Save
    sleep    2s
    HomePage.Select Experiment Node     Full OQ Extended ELN Expt ${Date}
    NavTree.Select Audit History   Full OQ Extended ELN Expt ${Date}
    AuditLog.Check Audit for Insert Excel Document    Full OQ Extended ELN Expt ${Date}    Example Excel Document.xlsx    1
    HomePage.Signout of ElnCore
    HomePage.Close Browser

FOQ-ELN-10: Ability to assign a workflow to a record and sign off via workflow.
    [Documentation]    User signs and starts a workflow
    ...    All items in the record are signed. have a signature appended. Each signature states the username of the
    ...    user who signed the item, the date and time of the signature, the role the user played in signing the item
    ...    and reason.
    ...    FOQ-ELN-11 is also referenced in this test by logout of the application
    ...    FOQ-ELN-19 is also referenced in this test by checking the audit log after the test
    [Tags]    AUTO    ASSIGN_WORKFLOW
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node     Full OQ Extended ELN Expt ${Date}
    HomePage.Select Review and Sign
    HomePage.Select Sign Off Record from Menu
    HomePage.Set Workflow value     OQ Test Workflow
    HomePage.Select Sign All
    HomePage.Confirm Sign Off    ${ADMIN_USR}    ${ADMIN_PW}    FOQ-ELN-10 Record Sign Off
    HomePage.Assign Witness Sign Off Task    ${ADMIN_USR}    ${ADMIN_PW}    ${User1}
    sleep    5s
    HomePage.Select Experiment Node     Full OQ Extended ELN Expt ${Date}
    NavTree.Select Audit History   Full OQ Extended ELN Expt ${Date}
    AuditLog.Check Audit for Actioner Sign Off   Full OQ Extended ELN Expt ${Date}
    HomePage.Signout of ElnCore
    HomePage.Close Browser

FOQ-ELN-13: Ability to action a task, sign-off via a workflow, publish via a workflow and to lock record
    [Documentation]    	User selects task and performs sign-off
    ...    Opening the PDF, by clicking on it in the navigator, displays a copy of the items in the record and the Word
    ...    and Excel documents appended at the end. A second signature has been appended to each item with the username,
    ...    date, time, role and reason on.
    ...
    ...    On viewing the Experiment and hovering the mouse of the document items the edit button does not display.
    ...
    ...    Each item in the Experiment view displays a green flag.
    ...
    ...    The status on the Experiment is Archived
    ...    FOQ-ELN-12 is also referenced in this test by login of the user to action the task
    ...    FOQ-ELN-19 is also referenced in this test by checking the audit log after the test
    [Tags]    AUTO    WORKFLOWS
    LoginPage.Login to ElnCore    ${User1}    ${User1PWD}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node     Full OQ Extended ELN Expt ${Date}
    HomePage.Select My Tasks Navigation
    MyTasks.Review Task from List     Witness Sign-Off    Full OQ Extended ELN Expt ${Date}    #Full OQ Extended ELN Expt ${Date}
    HomePage.Select Sign All
    HomePage.Confirm Sign Off    ${User1}    ${User1PWD}    FOQ-ELN-10 Record Sign Off
    HomePage.Acknowledge Publishing Dialog
    sleep    3s
    MyTasks.Check New Task Not Listed    Full OQ Extended ELN Expt ${Date}
    MyTasks.Check Recently Closed Task Listed    Full OQ Extended ELN Expt ${Date}
    HomePage.Select Navigator Navigation
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node     Full OQ Extended ELN Expt ${Date}
    HomePage.Check Experiment is Locked    Full OQ Extended ELN Expt ${Date}
    HomePage.Select Experiment Node     Full OQ Extended ELN Expt ${Date}
    NavTree.Select Audit History   Full OQ Extended ELN Expt ${Date}
    AuditLog.Check Audit for Record Publish   Full OQ Extended ELN Expt ${Date}
    HomePage.Signout of ElnCore
    HomePage.Close Browser

FOQ-ELN-14: Ability to allow further editing
    [Documentation]    User unlocks record to allow further editing:
    ...    Record is unlocked (padlock item not shown) and edit buttons appear on items when hovering mouse over.
    ...    FOQ-ELN-19 is also referenced in this test by checking the audit log after the test
    [Tags]     AUTO    EDITTING
    LoginPage.Login to ElnCore    ${User1}    ${User1PWD}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node     Full OQ Extended ELN Expt ${Date}
    HomePage.Select Allow Further Editing    ${User1}    ${User1PWD}
    HomePage.Select Experiment Node     Full OQ Extended ELN Expt ${Date}
    NavTree.Select Record Options Menu    Full OQ Extended ELN Expt ${Date}
    NavTree.Confirm Editing Permitted
    HomePage.Select Experiment Node     Full OQ Extended ELN Expt ${Date}
    NavTree.Select Audit History   Full OQ Extended ELN Expt ${Date}
    AuditLog.Check Audit for Allow Further Editing       Full OQ Extended ELN Expt ${Date}
    HomePage.Signout of ElnCore
    HomePage.Close Browser

FOQ-ELN-15: Editing Signed and Published Items
    [Documentation]    	User selects signed text item for edit:
    ...     Text item is updated and contains the extra text added "A third edit."
    [Tags]    AUTO    EDITTING
    LoginPage.Login to ElnCore    ${User1}    ${User1PWD}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node     Full OQ Extended ELN Expt ${Date}
    NavTree.Click on Text Item Tree Node
    ElnCoreNav.Select Edit Button    0    # Text Item
    HomePage.Accept Signatures Warning Message    ${User1}    ${User1PWD}    0    FOQ-ELN-13 A third edit
    HomePage.New Version Save    ${User1}    ${User1PWD}    FOQ-ELN-13 Version Save
    HomePage.Confirm Save Complete
    sleep    2s
    HomePage.Select Experiment Node    Full OQ Extended ELN Expt ${Date}
    HomePage.Signout of ElnCore
    HomePage.Close Browser

FOQ-ELN-19: Ability to see Version History
    [Documentation]    	User can open the experiment version history:
    ...     Content is the same as shown in PDF generated in FOQ-ELN-15.
    ...
    ...     On restoring the record the experiment view is displayed with 4 items in (Text, Word Document, Image
    ...     and Excel Document), the content of which are the same as the PDF generated in FOQ-ELN-13. There are
    ...     no signatures or publishing flags present on the items.
    ...
    ...     After saving the record as a version the Version number property value is 8.
    [Tags]    AUTO    VERSION_HISTORY
    LoginPage.Login to ElnCore    ${User1}    ${User1PWD}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node    Full OQ Extended ELN Expt ${Date}
    HomePage.Select Version History from Record Options Menu    Full OQ Extended ELN Expt ${Date}
    VersionHistory.Select Version from Tree    Full OQ Extended ELN Expt ${Date}    v4
    VersionHistory.Confirm Documents Signed     3     3            # No of Docs Signed, No of Signatures
    VersionHistory.Restore Previous Version    4
    HomePage.New Version Save        ${User1}    ${User1PWD}    FOQ-ELN-14 Restore Version
    HomePage.Confirm Save Complete
    HomePage.Select Experiment Node    Full OQ Extended ELN Expt ${Date}
    HomePage.Check Record Version    Full OQ Extended ELN Expt ${Date}    9
    HomePage.Signout of ElnCore
    HomePage.Close Browser

FOQ-ELN-16: Ability to delete items
    [Documentation]    	User selects Text item for deletion:
    ...    Item is deleted.
    ...    FOQ-ELN-19 is also referenced in this test by checking the audit log after the test
    ...    FOQ-ELN-20 is also referenced in this test by log out of the user from the application
    [Tags]    AUTO    DELETE_ITEM
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node     Full OQ Extended ELN Expt ${Date}
    HomePage.Delete Document    0    #Text DOC = 0
    HomePage.Select Experiment Node    Full OQ Extended ELN Expt ${Date}
    HomePage.New Version Save    ${ADMIN_USR}    ${ADMIN_PW}    FOQ-ELN-15 Delete Item Version Save
    sleep    2s
    HomePage.Select Experiment Node     Full OQ Extended ELN Expt ${Date}
    NavTree.Select Audit History   Full OQ Extended ELN Expt ${Date}
    AuditLog.Check Audit for Delete Items   Full OQ Extended ELN Expt ${Date}
    HomePage.Signout of ElnCore
    HomePage.Close Browser

*** Keyword ***
Capture Current Date
    ${DATE}=    Get Current Date    result_format=%Y-%m-%d %H:%M
    set suite variable    ${DATE}

Create Default Test Data
    ${experiment_name}=    Create Unique ID    ${TEST NAME}
    Set Test Variable    ${experiment_name}
    ${project_id}=    EntityAPILibrary.Ensure project is Present    2    OQ Project    # 2 is Administrators Group
    ${experiment_id}=    EntityAPILibrary.Create Experiment    ${project_id}    ${experiment_name}
    ${word_doc_id}=    EntityAPILibrary.Create Generic Document    ${experiment_id}    ${CURDIR}/Test Data/Example Office Document.docx
    EntityAPILibrary.Set Display Page    ${experiment_id}    ${word_doc_id}    0
    ${excel_doc_id}=    EntityAPILibrary.Create Generic Document    ${experiment_id}    ${CURDIR}/Test Data/Example Excel Document.xlsx
    EntityAPILibrary.Set Display Page    ${experiment_id}    ${excel_doc_id}    0
    EntityAPILibrary.Version Save    ${experiment_id}    Data Added
