*** Settings ***
Documentation     Full OQ Test Suite
...
...               The Full OQ test specification, which is described below, is designed
...               to test the high level features of E-WorkBook ELN/Core and confirm that that
...               the product is functional on the provided infrastructure following installation
...               and is behaving as expected. It is not designed to check all features in E-WorkBook
...               since the complete application has gone through thorough testing as part of the
...               application's development. For further details regarding the application's development
...               and associated tests please see the separate SDLC procedures.
Suite Setup
Suite Teardown
Test Setup
Test Teardown
Force Tags

Resource          ../../../Resources/ElnCore/Keywords/Access Control/LoginPage.robot
Resource          ../../../Resources/ElnCore/Keywords/Navigation/HomePage.robot
Resource          ../../../Resources/ElnCore/Keywords/Navigation/AuditLog.robot
Resource          ../../../Resources/ElnCore/Keywords/Navigation/Search.robot
Resource          ../../../Resources/ElnCore/Keywords/Navigation/NavTree.robot
Library           IDBSSelenium2Library
Library           IDBSHttpLibrary
Library           DateTime
Library           EntityAPILibrary
Library           TestDataGenerationLibrary
Library           ManualActionLibrary
Library           Dialogs
Resource          ./Test data/IOQ-ELN-Config - internal.robot


#pybot -T -d results -i SMOKE "Tests/Business Scenarios/ELNCORE_OQ/IOQ-ELN.robot"

*** Variables ***
${DATE}           ${EMPTY}

*** Test Cases ***

FOQ-ELN-0: Execution Log
    [Documentation]
    ...
    [Tags]    MANUAL
    set selenium speed    1
    ${TESTED_BY}=    Get Value from User    Name of person performing test:    default
    ${BROWSER_VERSION}=    Get Value from User    Browser and version used to perform test:    default
    Manual Action    Attach Screen shot of Operating System Version Thick Client Installed on
    Manual Action    Attach Screen shot of Thick Client About Page used for Web Client Administration

IOQ-ELN-1: Access Control - Valid Login
    [Documentation]    Test successful E-WorkBook Password Server login to the E-WorkBook web application
    ...    Following correct user credentials being inserted a successful login
    ...    occurs and the user is presented with the navigator view.
    ...
    ...
    ...    An authenticated user can access the application with appropriate credentials based
    ...    on the authentication method being used.
    ...
    ...    IOQ-ELN-8 is also referenced to this test case validating the Audit entry is recorded correctly.
    [Tags]    SYSTEM_ACCESS
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    HomePage.Signout of ElnCore
    HomePage.Close Browser

# Commented by Dan Curtis 27/9/2017 - Script commented out as also covered by Permissions OQ
#IOQ-ELN-1.1: Access Control - InValid Credentials
#    [Documentation]    Test InValid E-WorkBook Password Server Credentials do not allow access to the E-WorkBook web application
#    ...    Following InValid user credentials being inserted the user is prevented from
#    ...    accessing the web application.
#   ...
#    ...    Only an authenticated user can access the application with appropriate credentials based
#    ...    on the authentication method being used.
#    [Tags]    SYSTEM_ACCESS
#    run keyword and ignore error    LoginPage.Login to ElnCore    Adm    Admini    ${URL-EWBServer}
#    LoginPage.Verify Access Denied - Credentials
#    close browser

IOQ-ELN-2: Ability to create a group and project in E-WorkBook
    [Documentation]    Ability to create a group and project in E-WorkBook
    ...    Group and Project are created with the title "OQ Project"
    ...
    ...    IOQ-ELN-8 is also referenced to this test case validating the Audit entry is recorded correctly.
    [Tags]    CREATE_PROJECT
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Create Group    OQ Group
    NavTree.Select Group Node    OQ Group
    NavTree.Create Project    OQ Project
    HomePage.Signout of ElnCore
    HomePage.Close Browser

# Commented by Dan Curtis 23/8/2017 -  Set as something to look at as future improvement.
#IOQ-ELN-3: Ability to create a record (Experiments) in E-WorkBook using Navigator Tree
#    [Documentation]    User creates an experiment called "Instance OQ Expt <Date>" within the system
#    ...    Blank Experiment is created with the title "Instance OQ Expt <Date>." With <Date> being
#    ...    replaced with the date when test is executed.
#    [Tags]    CREATE_RECORD
#    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
#    LoginPage.Login Success
#    HomePage.Select Administrator Group Node
#    HomePage.Select Project Node    OQ Project
#    Capture Current Date
#    NavTree.Create New Blank Experiment from Nav Tree    OQ Project    Instance OQ Nav Tree Experiment-${DATE}
#    HomePage.Verify Experiment Created    Instance OQ Nav Tree Experiment-${DATE}
#    HomePage.Select Experiment Node     Instance OQ Nav Tree Experiment-${DATE}
#    NavTree.Select Audit History   Instance OQ Nav Tree Experiment-${DATE}
#    AuditLog.Check Audit for Create Experiment    Instance OQ Nav Tree Experiment-${DATE}
#    HomePage.Signout of ElnCore

IOQ-ELN-3: Ability to create a record (Experiments) in E-WorkBook using Tile
    [Documentation]    User creates an experiment called "Instance OQ Expt <Date>" within the system
    ...    Blank Experiment is created with the title "Instance OQ Expt <Date>." With <Date> being
    ...    replaced with the date when test is executed.
    ...
    ...    IOQ-ELN-8 is also referenced to this test case validating the Audit entry is recorded correctly.
    [Tags]    CREATE_RECORD
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    Capture Current Date
    HomePage.Create New Blank Experiment    Instance OQ Experiment-${DATE}
    HomePage.Verify Experiment Created    Instance OQ Experiment-${DATE}
    HomePage.Select Experiment Node     Instance OQ Experiment-${DATE}
    NavTree.Select Audit History   Instance OQ Experiment-${DATE}
    AuditLog.Check Audit for Create Experiment    Instance OQ Experiment-${DATE}
    HomePage.Signout of ElnCore
    HomePage.Close Browser

IOQ-ELN-4: Ability to insert Text items into the Experiment
    [Documentation]    User adds Text Item to the newly created experiment
    ...    Text item is created in the experiment and displays "This is an example of some text."
    ...
    ...    IOQ-ELN-8 is also referenced to this test case validating the Audit entry is recorded correctly.
    [Tags]    INSERT_ITEM
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node    Instance OQ Experiment-${DATE}
    HomePage.Insert Text Record Item
    HomePage.Insert Text into Item    This is an example of some text
    HomePage.New Version Save    ${ADMIN_USR}    ${ADMIN_PW}    IOQ-ELN-4 Insert Text Items Version Save
    HomePage.Select Experiment Node     Instance OQ Experiment-${DATE}
    HomePage.Confirm Item Entry Displayed    Text    0    This is an example of some text
    HomePage.Select Experiment Node     Instance OQ Experiment-${DATE}
    NavTree.Select Audit History   Instance OQ Experiment-${DATE}
    AuditLog.Check Audit for Create Text Item    Instance OQ Experiment-${DATE}
    HomePage.Signout of ElnCore
    HomePage.Close Browser

IOQ-ELN-5: Ability to insert Office Documents into the Experiment
    [Documentation]    User adds Office document Items to the newly created experiment
    ...    Word document is inserted into the experiment and the page of the document is shown on the screen.
    ...
    ...    IOQ-ELN-8 is also referenced to this test case validating the Audit entry is recorded correctly.
    [Tags]    INSERT_ITEM
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node    Instance OQ Experiment-${DATE}
    HomePage.Insert File and Image Item    ${CURDIR}/Test Data/Example Office Document.docx
    HomePage.Insert File and Image Item    ${CURDIR}/Test Data/Example Excel Document.xlsx
    HomePage.Display Office Document    1    #Word DOC = 1
    HomePage.Display Office Document    2    #Excel DOC = 2
    HomePage.New Version Save    ${ADMIN_USR}    ${ADMIN_PW}    IOQ-ELN-5 Insert Office Documents Version Save
    HomePage.Select Experiment Node     Instance OQ Experiment-${DATE}
    NavTree.Select Audit History   Instance OQ Experiment-${DATE}
    AuditLog.Check Audit for Insert Office Document    Instance OQ Experiment-${DATE}
    HomePage.Signout of ElnCore
    HomePage.Close Browser

IOQ-ELN-6: Ability to perform a Version Save
    [Documentation]    User performs a Version Save Action
    ...    Experiment is Version Saved. Version Type states "Version."
    ...
    ...    IOQ-ELN-8 is also referenced to this test case validating the Audit entry is recorded correctly.
    [Tags]    VERSION_SAVE
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node    Instance OQ Experiment-${DATE}
    HomePage.Edit Text in Item    0    This is another example of some text
    HomePage.New Version Save    ${ADMIN_USR}    ${ADMIN_PW}    IOQ-ELN-6 Edit Text Item Version Save
    HomePage.Select Experiment Node     Instance OQ Experiment-${DATE}
    NavTree.Select Audit History   Instance OQ Experiment-${DATE}
    AuditLog.Check Audit for Version Save    Instance OQ Experiment-${DATE}    4    IOQ-ELN-6 Edit Text Item Version Save
    HomePage.Signout of ElnCore
    HomePage.Close Browser

IOQ-ELN-7: Ability to perform a record sign-off
    [Documentation]    User signs all items in the record
    ...    All items in the record are signed.
    ...
    ...    Each signature states the username of the user that signed the item, the date and time of the
    ...    signature, the role of the user in signing the item and the reason.
    ...
    ...    IOQ-ELN-8 is also referenced to this test case validating the Audit entry is recorded correctly.
    [Tags]    SIGN_OFF
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node     Instance OQ Experiment-${DATE}
    HomePage.Select Review and Sign
    HomePage.Select Sign Off Record from Menu
    HomePage.Set Workflow value "Do not start..."
    HomePage.Select Sign All
    HomePage.Confirm Sign Off    ${ADMIN_USR}    ${ADMIN_PW}    IOQ-ELN-7 Record Sign Off
    HomePage.Select Experiment Node     Instance OQ Experiment-${DATE}
    NavTree.Select Audit History   Instance OQ Experiment-${DATE}
    AuditLog.Check Audit for Record Sign Off   Instance OQ Experiment-${DATE}
    HomePage.Signout of ElnCore
    HomePage.Close Browser

IOQ-ELN-9: Ability to create a PDF of the record
    [Documentation]    User creates a PDF of the record
    ...    All items are marked as being published and a PDF is created which is accessible from the navigator tree
    ...    under the "Instance OQ Expt" record entry.
    ...
    ...    Opening the PDF, by clicking on it in the navigator, displays a copy of the items in the record and the
    ...    Word document appended at the end.
    ...
    ...    IOQ-ELN-8 is also referenced to this test case validating the Audit entry is recorded correctly.
    ...    Ability to create a PDF of the record
    [Tags]    PUBLISH_PDF
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node    Instance OQ Experiment-${DATE}
    HomePage.Select Review and Sign
    HomePage.Select Publish PDF
    HomePage.Select Experiment Node     Instance OQ Experiment-${DATE}
    HomePage.Publish Flag Set for Record    0    Text Item
    HomePage.Publish Flag Set for Record    1    Word Document
    HomePage.Publish Flag Set for Record    2    Excel Document
    HomePage.Select Experiment Node     Instance OQ Experiment-${DATE}
    NavTree.Select Audit History   Instance OQ Experiment-${DATE}
    AuditLog.Check Audit for PDF of Record    Instance OQ Experiment-${DATE}
    HomePage.Signout of ElnCore
    HomePage.Close Browser

IOQ-ELN-10: Ability to perform a search for text in the system
    [Documentation]    Search for the "Instance OQ Expt <Date>"
    ...
    ...    Search results window opens and "Instance OQ Expt <Date>" is displayed as meeting the search criteria.
    [Tags]    SEARCH
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Search Icon
    sleep    2s
    Search.Search for Term     	Instance OQ Experiment-${DATE}
    HomePage.Signout of ElnCore
    HomePage.Close Browser


IOQ-ELN-11: Ability to Sign Out from application
    [Documentation]    	Perform a Sign Out event
    ...    User signs out of application and is presented with an acknowledgement that the sign off has occurred.
    [Tags]    SIGN_OUT
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    HomePage.Signout of ElnCore
    HomePage.Close Browser


*** Keyword ***
Capture Current Date
    ${DATE}=     Get Current Date    result_format=%Y-%m-%d %H:%M
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
