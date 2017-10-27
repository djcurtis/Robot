*** Settings ***
Documentation     Instance OQ Test Suite
...
...               The instance OQ test specification, which is described below, is designed to test the high level
...               features of Spreadsheet and confirm that that the product is functional on the provided infrastructure
...               following installation and is behaving as expected. It is not designed to check all features in
...               E-WorkBook since the complete application has gone through thorough testing as part of the application's.
...               For further details regarding the application's development and associated tests please see the separate
...               SDLC procedures.
...
...               This test assumes that the  E-WorkBook has not been modified from the installed product and that the
...               OQ - ELN v1.0 test has already been executed (ie Instance OQ project already exists).
...
Suite Setup
Suite Teardown
Test Setup
Test Teardown
Force Tags
Library           IDBSSelenium2Library
Library           DateTime
Library           EntityAPILibrary
Library           TestDataGenerationLibrary
Library           ManualActionLibrary
Library           Dialogs
Resource          ../../../Resources/ElnCore/Keywords/Access Control/LoginPage.robot
Resource          ../../../Resources/ElnCore/Keywords/Navigation/HomePage.robot
Resource          ../../../Resources/ElnCore/Keywords/Navigation/AuditLog.robot
Resource          ../../../Resources/ElnCore/Keywords/Navigation/NavTree.robot
Resource          ../../../Resources/ElnCore/Keywords/Navigation/Spreadsheet.robot
Resource          ../ELNCORE_OQ/Test data/IOQ-ELN-Config - Alcami.robot



#pybot -T -d results -i TEST "Test Suites/Business Scenarios/SPREADSHEET_OQ/IOQ-SSv1_0.robot"

*** Variables ***


*** Test Cases ***
IOQ-SSH-0: Execution Log
    [Documentation]
    ...
    [Tags]    MANUAL
    ${TESTED_BY}=    Get Value from User    Name of person performing test:    default
    ${BROWSER_VERSION}=    Get Value from User    Browser and version used to perform test:    default
    Manual Action    Attach Screen shot of Operating System Version Thick Client Installed on
    Manual Action    Attach Screen shot of Thick Client About Page used for Web Client Administration

IOQ-SSH-1: Test successful login to the E-WorkBook web application:
    [Documentation]    An authenticated user can access the application with appropriate credentials based on the
    ...    authentication method being used.
    ...
    ...    Following correct user credentials being inserted a successful login occurs and the user is presented with the navigator view
    [Tags]    SYSTEM_ACCESS
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    HomePage.Signout of ElnCore

IOQ-SSH-2: Ability to open a project in E-WorkBook
    [Documentation]    User opens Instance OQ Project
    ...
    ...    Instance OQ Project opens.
    [Tags]    CREATE_PROJECT
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    NavTree.Create Project    OQ Project
    HomePage.Signout of ElnCore

IOQ-SSH-3: Ability to create a record (Experiments) in E-WorkBook.
    [Documentation]    User creates an experiment called "Instance OQ SSH Expt <Date>" within the system
    ...
    ...    Blank Experiment is created with the title "Instance OQ SS Expt <Date>." With <Date> being replaced with the date when test is executed.
    [Tags]    CREATE_RECORD
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    Capture Current Date
    HomePage.Create New Blank Experiment    Instance OQ SSH-3 Expt-${DATE}
    HomePage.Verify Experiment Created    Instance OQ SSH-3 Expt-${DATE}
    HomePage.Select Experiment Node     Instance OQ SSH-3 Expt-${DATE}
    NavTree.Select Audit History   Instance OQ SSH-3 Expt-${DATE}
    AuditLog.Check Audit for Create Experiment    Instance OQ SSH-3 Expt-${DATE}
    HomePage.Signout of ElnCore

IOQ-SSH-4: Ability to insert a spreadsheet file into a record (Experiment)
    [Documentation]    User inserts "OQ Spreadsheet Test File.ewbss" into the experiment
    ...
    ...    Spreadsheet item created with the title of "Unknown" and a caption of "OQ Spreadsheet Test File.ewbss".
    [Tags]    INSERT_ITEM
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    Capture Current Date
    HomePage.Create New Blank Experiment    Instance OQ SSH-4 Expt-${DATE}
    HomePage.Verify Experiment Created    Instance OQ SSH-4 Expt-${DATE}
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    #HomePage.Insert Spreadsheet Item    //used for empty new Spreadsheet
    HomePage.Insert File and Image Item    ${CURDIR}/Test Data/OQ Spreadsheet Test File.ewbss
    #TODO Check Spreadsheet item is inserted successfully
    HomePage.New Version Save    ${ADMIN_USR}    ${ADMIN_PW}    IOQ-SSH-4 Insert Spreadsheet Documents Version Save
    HomePage.Select Experiment Node     Instance OQ SSH-4 Expt-${DATE}
    NavTree.Select Audit History   Instance OQ SSH-4 Expt-${DATE}
    AuditLog.Check Audit for Insert EWB Spreadsheet Document    Instance OQ SSH-4 Expt-${DATE}
    HomePage.Select Experiment Node     Instance OQ SSH-4 Expt-${DATE}
    NavTree.Select Audit History   Instance OQ SSH-4 Expt-${DATE}
    AuditLog.Check Audit for Version Save    Instance OQ SSH-4 Expt-${DATE}    1    IOQ-SSH-4 Insert Spreadsheet Documents Version Save
    HomePage.Signout of ElnCore

IOQ-SSH-5: Ability to open the spreadsheet for editing.
    [Documentation]    User opens the spreadsheet item for editing
    ...
    ...    Spreadsheet web editor opens and the "Data Input" perspective is displayed. In the Setup Table, the
    ...    Project Name data field is populated via Smart Fill with "Instance OQ Project"
    [Tags]    EDIT_SPRDSHT
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    NavTree.Click on Spreadsheet Item Tree Node    OQ Spreadsheet Test File.ewbss
    ElnCoreNav.Select Edit Button    0    # Spreadsheet Item
    Spreadsheet.Spreadsheet Editor Loaded
    Spreadsheet.Return to E-WorkBook
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    HomePage.New Version Save    ${ADMIN_USR}    ${ADMIN_PW}    IOQ-SSH-5 Open Spreadsheet for editing Version Save
    HomePage.Select Experiment Node     Instance OQ SSH-4 Expt-${DATE}
    HomePage.Signout of ElnCore

IOQ-SSH-6: Ability to select a catalog term value from within the spreadsheet and associated values are populated by pick list linking.
    [Documentation]    User selects OQ Study:
    ...
    ...    "Study 1" can be selected and cell is populated with this value. The Study Code cell is automatically populated with "S1"
    [Tags]    CATALOG
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    NavTree.Click on Spreadsheet Item Tree Node    OQ Spreadsheet Test File.ewbss
    ElnCoreNav.Select Edit Button    0    # Spreadsheet Item
    Spreadsheet.Spreadsheet Editor Loaded
    Write to Cell    Setup Table    2    0    Study 1
    Select Sheet In Tab    Setup Table
    Spreadsheet.Return to E-WorkBook
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    HomePage.New Version Save    ${ADMIN_USR}    ${ADMIN_PW}    IOQ-SSH-6 Select a Catalog term Version Save
    HomePage.Select Experiment Node     Instance OQ SSH-4 Expt-${DATE}
    NavTree.Select Audit History   Instance OQ SSH-4 Expt-${DATE}
    AuditLog.Check Audit for Catalog Value Entry    Instance OQ SSH-4 Expt-${DATE}    Setup Table::OQ Study   	Value added to cell: Study 1
    HomePage.Select Experiment Node     Instance OQ SSH-4 Expt-${DATE}
    NavTree.Select Audit History   Instance OQ SSH-4 Expt-${DATE}
    AuditLog.Check Audit for Catalog Value Entry    Instance OQ SSH-4 Expt-${DATE}    Setup Table::Study Code    Value added to cell: S1
    HomePage.Signout of ElnCore

IOQ-SSH-7: Ability to type values into a cell.
    [Documentation]    Insert "Sample 1" into the OQ Sample cell
    ...
    ...    "Sample 1" is inserted into the OQ Sample data cell. In addition, the Last Modified Date and Last Modified By data cells
    ...    are automatically populated with the time stamp (Date and Time) and the ID of the user currently logged in.
    [Tags]    CELLS
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node    	Instance OQ SSH-4 Expt-2017-10-11 12:34    #Instance OQ SSH-4 Expt-${DATE}
    NavTree.Click on Spreadsheet Item Tree Node    OQ Spreadsheet Test File.ewbss
    ElnCoreNav.Select Edit Button    0    # Spreadsheet Item
    Spreadsheet.Spreadsheet Editor Loaded
    Write to Cell    Setup Table    4    0    Sample 1
    Select Sheet In Tab    Setup Table
    Save Cell Value    5    0    Setup Table     #capture cell date for IOQ-SSH-17
    Spreadsheet.Return to E-WorkBook
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-2017-10-11 12:34    #Instance OQ SSH-4 Expt-${DATE}
    HomePage.New Version Save    ${ADMIN_USR}    ${ADMIN_PW}    IOQ-SSH-7 Ability to type values into cell Version Save
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-2017-10-11 12:34    #Instance OQ SSH-4 Expt-${DATE}
    NavTree.Select Audit History   Instance OQ SSH-4 Expt-2017-10-11 12:34    #Instance OQ SSH-4 Expt-${DATE}
    AuditLog.Check Audit for Catalog Value Entry    Instance OQ SSH-4 Expt-2017-10-11 12:34    Setup Table::Project Name    OQ Project
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-2017-10-11 12:34    #Instance OQ SSH-4 Expt-${DATE}
    NavTree.Select Audit History   Instance OQ SSH-4 Expt-2017-10-11 12:34    #Instance OQ SSH-4 Expt-${DATE}
    AuditLog.Check Audit for Catalog Value Entry    Instance OQ SSH-4 Expt-2017-10-11 12:34    Setup Table::OQ Sample    Sample 1
    HomePage.Signout of ElnCore

IOQ-SSH-8: Ability to mark instructions as complete.
    [Documentation]    Mark "Capture Sample ID" instruction as complete
    ...
    ...    Can update "Capture Sample ID" as complete. Green tick is displayed.
    [Tags]    INSTRUCTIONS
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    NavTree.Click on Spreadsheet Item Tree Node    OQ Spreadsheet Test File.ewbss
    ElnCoreNav.Select Edit Button    0    # Spreadsheet Item
    Spreadsheet.Spreadsheet Editor Loaded
    Spreadsheet.Use Instructions Panel
    Spreadsheet.Select Instruction Item    Capture Sample ID
    Spreadsheet.Confirm Instruction Checked    Capture Sample ID
    Spreadsheet.Return to E-WorkBook
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    HomePage.New Version Save    ${ADMIN_USR}    ${ADMIN_PW}    IOQ-SSH-8 Ability to mark instructions complete Version Save
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    HomePage.Signout of ElnCore

IOQ-SSH-9: Ability to import a raw data file.
    [Documentation]    Import auc-data.txt file
    ...
    ...    Data is inserted into the Observations table and mapped to the series and time
    [Tags]    IMPORT
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    NavTree.Click on Spreadsheet Item Tree Node    OQ Spreadsheet Test File.ewbss
    ElnCoreNav.Select Edit Button    0    # Spreadsheet Item
    Spreadsheet.Spreadsheet Editor Loaded
    Spreadsheet.Select Import Action on Instruction    Import AUC Data    ${CURDIR}/Test Data/auc-data.txt
    Click File Import Button
    Select Sheet In Tab    Observations
    comment    value    row    column
    Verify Cell Value    0.5    0    0
    Verify Cell Value    7.10    1    1
    Spreadsheet.Select Instruction Item    Import AUC Data
    Spreadsheet.Return to E-WorkBook
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    HomePage.New Version Save    ${ADMIN_USR}    ${ADMIN_PW}    IOQ-SSH-9 Ability to import raw data Version Save
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    NavTree.Select Audit History   Instance OQ SSH-4 Expt-${DATE}
    AuditLog.Check Audit for Event and Message Entry    Instance OQ SSH-4 Expt-${DATE}    Observations    DataLink updated
    HomePage.Signout of ElnCore

IOQ-SSH-10: Ability to knockout data points out from table
    [Documentation]    Knockout Conc values for Time points 4&6 for OQ Series 1
    ...
    ...    Data points are knocked out and the knock out indicator is displayed on the two cells. Also values
    ...    are shown to be knocked out in the associated chart (OQ Series 1) in the Summary table. Chart calculations update
    [Tags]    KNOCKOUT
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    NavTree.Click on Spreadsheet Item Tree Node    OQ Spreadsheet Test File.ewbss
    ElnCoreNav.Select Edit Button    0    # Spreadsheet Item
    Spreadsheet.Spreadsheet Editor Loaded
    Spreadsheet.Knockout data from table     Observations    3    1
    Spreadsheet.Knockout data from table     Observations    4    1
    Spreadsheet.Return to E-WorkBook
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    HomePage.New Version Save    ${ADMIN_USR}    ${ADMIN_PW}    IOQ-SSH-9 Ability to import raw data Version Save
    HomePage.Select Experiment Node     Instance OQ SSH-4 Expt-${DATE}
    NavTree.Select Audit History   Instance OQ SSH-4 Expt-${DATE}
    AuditLog.Check Audit for Knockout     Instance OQ SSH-4 Expt-${DATE}    Observations::Conc:'4':OQ Series.'1'    Knockout was applied to the cell    #Event Location "Observations::Conc:'4':OQ Series.'1'"; Message "Knockout was applied to the cell."
    HomePage.Select Experiment Node     Instance OQ SSH-4 Expt-${DATE}
    NavTree.Select Audit History   Instance OQ SSH-4 Expt-${DATE}
    AuditLog.Check Audit for Knockout     Instance OQ SSH-4 Expt-${DATE}    Observations::Conc:'6':OQ Series.'1'    Knockout was applied to the cell    #Event Location "Observations::Conc:'6':OQ Series.'1'"; Message "Knockout was applied to the cell."
    HomePage.Signout of ElnCore

IOQ-SSH-11: Ability to knockout data points on the chart
    [Documentation]    Open Summary perspective.
    ...
    ...    Summary perspective opens and the charts and raw data table are shown.
    ...
    ...    IOQ-SSH-14: Ability to return to the record (Experiment) is covered by returning to the Experiment in E-WorkBook.
    [Tags]    KNOCKOUT
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    NavTree.Click on Spreadsheet Item Tree Node    OQ Spreadsheet Test File.ewbss
    ElnCoreNav.Select Edit Button    0    # Spreadsheet Item
    Spreadsheet.Spreadsheet Editor Loaded
    Spreadsheet.Knockout data from Chart    Summary    2    1    40    70    90    10
    Select Sheet In Tab    Observations
    Confirm table cell is Knocked Out    Observations    3    2    # row    col
    Confirm table cell is Knocked Out    Observations    4    2    # row    col
    Spreadsheet.Return to E-WorkBook
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    HomePage.New Version Save    ${ADMIN_USR}    ${ADMIN_PW}    IOQ-SSH-9 Ability to import raw data Version Save
    HomePage.Select Experiment Node     Instance OQ SSH-4 Expt-${DATE}
    NavTree.Select Audit History   Instance OQ SSH-4 Expt-${DATE}
    AuditLog.Check Audit for Knockout    Instance OQ SSH-4 Expt-${DATE}    Observations::Timept:'4':OQ Series.'2'    Knockout was applied to the cell    #Event Location "Observations::Timept:'4':OQ Series.'2'"; Message "Knockout was applied to the cell."
    HomePage.Select Experiment Node     Instance OQ SSH-4 Expt-${DATE}
    NavTree.Select Audit History   Instance OQ SSH-4 Expt-${DATE}
    AuditLog.Check Audit for Knockout    Instance OQ SSH-4 Expt-${DATE}    Observations::Timept:'6':OQ Series.'2'    Knockout was applied to the cell    #Event Location "Observations::Timept:'6':OQ Series.'2'"; Message "Knockout was applied to the cell."
    HomePage.Select Experiment Node     Instance OQ SSH-4 Expt-${DATE}
    NavTree.Select Audit History   Instance OQ SSH-4 Expt-${DATE}
    AuditLog.Check Audit for Knockout    Instance OQ SSH-4 Expt-${DATE}    Observations::Conc:'4':OQ Series.'2'    Knockout was applied to the cell    #Event Location "Observations::Conc:'4':OQ Series.'2'"; Message "Knockout was applied to the cell."
    HomePage.Select Experiment Node     Instance OQ SSH-4 Expt-${DATE}
    NavTree.Select Audit History   Instance OQ SSH-4 Expt-${DATE}
    AuditLog.Check Audit for Knockout    Instance OQ SSH-4 Expt-${DATE}    Observations::Conc:'6':OQ Series.'2'    Knockout was applied to the cell    #Event Location "Observations::Conc:'6':OQ Series.'2'"; Message "Knockout was applied to the cell."
    HomePage.Signout of ElnCore

IOQ-SSH-12: Ability to view data on a Canvas.
    [Documentation]    Open Summary perspective.
    ...
    ...    Summary perspective opens and the charts and raw data table are shown.
    [Tags]    VIEW_CANVAS
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    NavTree.Click on Spreadsheet Item Tree Node    OQ Spreadsheet Test File.ewbss
    ElnCoreNav.Select Edit Button    0    # Spreadsheet Item
    Spreadsheet.Spreadsheet Editor Loaded
    Open Drop Down for Perspective Selection    Data Input
    Click Perspective In Picker By Name    Summary
    Confirm Sheet Selected    Summary Canvas
    Spreadsheet.Return to E-WorkBook
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    Discard Changes
    HomePage.Signout of ElnCore

IOQ-SSH-13: Ability to Delete values in a cell
    [Documentation]    Delete Cell Value
    ...
    ...    Value removed and the calculations update.
    [Tags]    DELETE
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    NavTree.Click on Spreadsheet Item Tree Node    OQ Spreadsheet Test File.ewbss
    ElnCoreNav.Select Edit Button    0    # Spreadsheet Item
    Spreadsheet.Spreadsheet Editor Loaded
    Open Drop Down for Perspective Selection    Data Input
    Select Perspective View    Summary
    Delete Cell contents    Summary Canvas    0    1    ${EMPTY}
    Spreadsheet.Return to E-WorkBook
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    HomePage.New Version Save    ${ADMIN_USR}    ${ADMIN_PW}    IOQ-SSH-13 Ability to import raw data Version Save
    HomePage.Select Experiment Node     Instance OQ SSH-4 Expt-${DATE}
    NavTree.Select Audit History   Instance OQ SSH-4 Expt-${DATE}
    AuditLog.Check Audit for Deleting Value in Cell    Instance OQ SSH-4 Expt-${DATE}    Observations::Conc:'.5':OQ Series.'1'    Value removed from cell    #Event Location "Observations::Conc:'.5':OQ Series.'1'"; Message "Value removed from cell"
    HomePage.Signout of ElnCore

IOQ-SSH-15: Ability to display pages of the spreadsheet
    [Documentation]    Display Spreadsheet pages in Experiment
    ...
    ...    Three spreadsheet pages are displayed in the Experiment.
    ...    IOQ-SSH-16 Ability to perform a version save is included in the scope of this test
    [Tags]    DISPLAY_PAGES
    LoginPage.Login to ElnCore    ${ADMIN_USER}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    HomePage.Display Spreadsheet Document    0    1    #SS DOC = 0, Page number =1
    HomePage.New Version Save    ${ADMIN_USER}    ${ADMIN_PW}    IOQ-SSH-15 Display Pages Version Save
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    HomePage.Signout of ElnCore

IOQ-SSH-18: Ability to search for spreadsheet data   #Instance OQ SSH-4 Expt-2017-10-10 16:48

    [Documentation]    User can use a spreadsheet to search for data
    ...
    ...    Spreadsheet search completes and data shown on Summary table is as follows:
    ...    Experiment title: "Instance OQ SS Expt <Date>"
    ...    OQ Half-Life has two data points shown
    ...    "80.52761" for OQ Series_Index "1"
    ...    "96.0419" for OQ Series_Index "2"
    ...    For both data lines
    ...    OQ Sample_Index is "Sample 1"
    ...    OQ Study_Index is "Study 1"
    ...    <Date> should equal the value inserted during IOQ-SSH-3 step above.
    [Tags]    SEARCH
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-2017-10-11 10:11    #Instance OQ SSH-4 Expt-${DATE}
    #HomePage.Insert File and Image Item    ${CURDIR}/Test Data/OQ Spreadsheet Search.ewbss
    #HomePage.New Version Save    ${ADMIN_USR}    ${ADMIN_PW}    IOQ-SSH-18 Ability to search for spreadsheet data first version save
    #HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-2017-10-11 10:11    #Instance OQ SSH-4 Expt-${DATE}
    NavTree.Click on Spreadsheet Item Tree Node    OQ Spreadsheet Search.ewbss
    ElnCoreNav.Select Edit Button    1    # Spreadsheet Item
    Spreadsheet.Spreadsheet Editor Loaded
    Spreadsheet.Select Instruction Action    Run Search
    Spreadsheet.Select Instruction Action    Review Summary Data
    Select Sheet In Tab    Summary
    comment    value    row    column
    #Manual Action    OQ Series_Index 2 value should be 96.0419
    Check Search Result Cell    96.0419    1    1
    #Manual Action    OQ Series_Index 1 value should be 99.51669
    Check Search Result Cell    80.52761    0    1
    #Manual Action    OQ Series_Index 1 Sample_Index value is Sample 1
    Check Search Result Cell    Sample 1    0    4
    #Manual Action    OQ Series_Index 1 Study_Index value is Study 1
    Check Search Result Cell    Study 1    0    5
    #Manual Action    OQ Series_Index 2 Sample_Index value is Sample 1
    Check Search Result Cell    Sample 1    1    4
    #Manual Action    OQ Series_Index 2 Study_Index value is Study 1
    Check Search Result Cell    Study 1    1    5
    Spreadsheet.Return to E-WorkBook
    #HomePage.New Version Save    ${ADMIN_USR}    ${ADMIN_PW}    IOQ-SSH-9 Ability to import raw data Version Save
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-2017-10-11 10:11    #Instance OQ SSH-4 Expt-${DATE}
    HomePage.Signout of ElnCore

IOQ-SSH-19: Ability to save and then exit the application.
    [Documentation]    User can save additional data and close E-WorkBook
    ...
    ...    User signs out of application and is presented with an acknowledgement that the sign out has occurred.
    [Tags]    SAVE
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    LoginPage.Login Success
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    NavTree.Click on Spreadsheet Item Tree Node    OQ Spreadsheet Test File.ewbss
    ElnCoreNav.Select Edit Button    0    # Spreadsheet Item
    Spreadsheet.Spreadsheet Editor Loaded
    Open Drop Down for Perspective Selection    Summary
    Click Perspective In Picker By Name    Data Input
    Confirm Sheet Selected    Setup Table
    Spreadsheet.Select Import Action on Instruction    Import AUC Data    ${CURDIR}/Test Data/auc-data.txt
    Click File Import Button
    Open Drop Down for Perspective Selection    Data Input
    Click Perspective In Picker By Name    Summary
    Confirm Sheet Selected    Summary Canvas
    Spreadsheet.Click on Done Instruction
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    HomePage.New Version Save    ${ADMIN_USR}    ${ADMIN_PW}    IOQ-SSH-19 Ability to import raw data Version Save
    HomePage.Select Experiment Node    Instance OQ SSH-4 Expt-${DATE}
    HomePage.Signout of ElnCore


*** Keyword ***
Capture Current Date
    ${DATE}=     Get Current Date    result_format=%Y-%m-%d %H:%M
    set suite variable    ${DATE}


