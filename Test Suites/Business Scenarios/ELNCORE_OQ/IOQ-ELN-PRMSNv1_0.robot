*** Settings ***
Documentation     ElnCore OQ Permission Test Suite
...
...               The OQ test specification, which is described below, is designed to confirm that the E-WorkBook
...               ELN/Core permissions are functioning as expected for use in a validated environment. This test is
...               based on restricting the permissions available for a user and confirming the expected behavior.
...
...               Prerequisites
...               This test assumes that the  E-WorkBook has not been modified from the installed product and that the
...               Instance OQ - ELN v1.0 been executed (ie Instance OQ project already exists).
...
...               There is a user account that can be used to modify the permissions available to a second user. The
...               test initially relies on two security roles being created:
...                     User Role (OQ User Role) that has been assign all user permissions.
...                     Entity Role (OQ Entity Role) that has been assigned all entity permissions.
...                     For the Test User:
...                         OQ User Role is only user role assigned.
...                         OQ Entity Role is only entity role assigned. This role should be assigned at Root.
...               For further details on the security configuration see OQ Initial Security Setup.docx
...               The setup for each test including changes to the security roles, if needed, will be described in the
...               relevant test description below.
Suite Setup
Suite Teardown
Test Setup
Test Teardown
Force Tags

Resource          ../../../Resources/ElnCore/Keywords/Access Control/LoginPage.robot
Resource          ../../../Resources/ElnCore/Keywords/Navigation/HomePage.robot
Resource          ../../../Resources/ElnCore/Keywords/Navigation/AuditLog.robot
Resource          ../../../Resources/ElnCore/Keywords/Navigation/NavTree.robot
Library           IDBSSelenium2Library
Library           IDBSHttpLibrary
Library           DateTime
Library           EntityAPILibrary
Library           TestDataGenerationLibrary
Library           ManualActionLibrary
Library           Dialogs
Library           OperatingSystem
Resource          ../../../Resources/ElnCore/Keywords/E-WorkBook Thick Client/ewb_thick_client_general_actions_resource.robot
Resource          ./Test data/IOQ-ELN-Config - Alcami.robot

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

FOQ-ELNP-1: A user entering the wrong password will be denied access to E-WorkBook
    [Documentation]    Test unsuccessful login to the E-WorkBook web application:
    ...    Logon dialog remains displayed and the message "Sign in failed: invalid user name / password" is displayed.
    [Tags]    SYSTEM_ACCESS
    run keyword and ignore error    LoginPage.Login to ElnCore    Adm    Admini    ${URL-EWBServer}
    LoginPage.Verify Access Denied - Credentials
    HomePage.Close Browser

FOQ-ELNP-2: A user without the USE_EWB_WEB_CLIENT user permission cannot access the E-WorkBook web client.
    [Documentation]    Test that a user without the relevant permission cannot access the web client.
    ...    Setup: Change OQ User role so that the USE_EWB_WEB_CLIENT permission is removed.
    ...
    ...    Post Test step: Change OQ User role so that the USE_EWB_WEB_CLIENT permission is added.
    ...
    ...    Logon dialog remains displayed and the message "You do not have permission to use the E-WorkBook web
    ...    client. Please contact your administrator." is displayed.
    [Tags]    SYSTEM_ACCESS
    LoginPage.Login to ElnCore    ${User2}    ${User2PWD}    ${URL-EWBServer}
    LoginPage.Verify Access Denied - Permissions
    HomePage.Close Browser

FOQ-ELNP-3: A user without the CREATE_EXPERIMENT entity permission cannot create an Experiment.
    [Documentation]    Test that a user without the relevant permission cannot create an Experiment.
    ...    Setup: Change OQ Entity role so that the CREATE_EXPERIMENT permission is removed.
    ...
    ...    Post Test step: Change OQ Entity role so that the CREATE_EXPERIMENT permission is added.
    ...
    ...    Create New dialog opens. The ability to create an Experiment is not available to the user.
    [Tags]    CREATE_EXPT
    LoginPage.Login to ElnCore    ${User4}    ${User4PWD}    ${URL-EWBServer}
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    Capture Current Date
    HomePage.Confirm Permission Denied for Experiment
    HomePage.Signout of ElnCore
    HomePage.Close Browser

FOQ-ELNP-4: Ability to create an experiment, add items to that experiment and version save experiment
    [Documentation]    User creates an experiment called "OQ Permission Expt <Date>" within the system:
    ...    Version save experiment that contains a text item.
    [Tags]    CREATE_EXPT
    LoginPage.Login to ElnCore    ${ADMIN_USR}    ${ADMIN_PW}    ${URL-EWBServer}
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    Capture Current Date
    HomePage.Create New Blank Experiment    Instance OQ Permission Experiment-${DATE}
    HomePage.Verify Experiment Created    Instance OQ Permission Experiment-${DATE}
    HomePage.Select Experiment Node    Instance OQ Permission Experiment-${DATE}
    HomePage.Insert Text Record Item
    HomePage.Insert Text into Item    This is an example of some text
    HomePage.New Version Save    ${ADMIN_USR}    ${ADMIN_PW}     IOQ-ELN-4 Insert Text Items Version Save
    sleep    1s
    HomePage.Select Experiment Node     Instance OQ Permission Experiment-${DATE}
    NavTree.Select Audit History   Instance OQ Permission Experiment-${DATE}
    AuditLog.Check Audit for Create Text Item    Instance OQ Permission Experiment-${DATE}
    HomePage.Signout of ElnCore
    HomePage.Close Browser

FOQ-ELNP-5: A user without the EDIT_EXPERIMENT entity permission cannot edit an existing Experiment.
    [Documentation]    User creates an experiment called "Full OQ Extended ELN Expt <Date>" within the system using a template:
    ...    Setup: Change OQ Entity role so that the EDIT_EXPERIMENT permission is removed.
    ...
    ...    Post Test step: Change OQ Entity role so that the EDIT_EXPERIMENT permission is added.
    [Tags]    EDIT_EXPT
    LoginPage.Login to ElnCore    ${User5}    ${User5PWD}    ${URL-EWBServer}
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node    Instance OQ Permission Experiment-${DATE}
    HomePage.Confirm Permission Denied for Record
    HomePage.Select Experiment Node    Instance OQ Permission Experiment-${DATE}
    HomePage.Check Experiment is Locked    Instance OQ Permission Experiment-${DATE}
    HomePage.Signout of ElnCore
    HomePage.Close Browser

FOQ-ELNP-6: A user without the DELETE_EXPERIMENT entity permission cannot delete an existing Experiment.
    [Documentation]    Test that a user without the relevant permission cannot delete an Experiment.
    ...         Setup: Change OQ Entity role so that the DELETE_EXPERIMENT permission is removed.
    ...
    ...         Post Test step: Change OQ Entity role so that the DELETE_EXPERIMENT permission is added.
    ...
    ...         Delete option is disabled.
    [Tags]    DELETE_EXPT
    LoginPage.Login to ElnCore    ${User5}    ${User5PWD}    ${URL-EWBServer}
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node    Instance OQ Permission Experiment-${DATE}
    HomePage.Check Experiment Cannot be Deleted    Instance OQ Permission Experiment-${DATE}
    HomePage.Signout of ElnCore
    HomePage.Close Browser

FOQ-ELNP-7: A user without the SIGNOFF_TASK cannot sign Records (Experiments)
    [Documentation]   Test that a user without the relevant permission cannot perform a sign-off.
    ...     Setup: Change OQ Entity role so that the SIGNOFF_TASK permission is removed.
    ...
    ...     Dialog is shown with the following message: "Unable to sign items in the current record, you must have the SIGNOFF_TASK permission granted."
    [Tags]    SIGN_OFF
    LoginPage.Login to ElnCore    ${User3}    ${User3PWD}    ${URL-EWBServer}
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node    Instance OQ Permission Experiment-${DATE}
    HomePage.Select Review and Sign
    HomePage.Select Sign Off Record from Menu
    HomePage.Confirm Permission Denied for Sign Off
    HomePage.Signout of ElnCore
    HomePage.Close Browser

FOQ-ELNP-8: Ability to delete a record
    [Documentation]    Test that the user can delete a record.
    ...    Record date and time of test.
    [Tags]    DELETE_EXPT
    LoginPage.Login to ElnCore    ${User3}    ${User3PWD}    ${URL-EWBServer}
    NavTree.Select Group Node    OQ Group
    HomePage.Select Project Node    OQ Project
    HomePage.Select Experiment Node    Instance OQ Permission Experiment-${DATE}
    HomePage.Delete Experiment    Instance OQ Permission Experiment-${DATE}    ${User3}    ${User3PWD}
    HomePage.Select Project Node    OQ Project
    HomePage.Verify Experiment Not Present    Instance OQ Permission Experiment-${DATE}
    HomePage.Signout of ElnCore
    HomePage.Close Browser

FOQ-ELN-9: Ability to review system audit log for user failed logon
    [Documentation]    Test that failed logons are captured in the system audit log
    ...    There is a value in the audit trail with a Type of LOGIN SUCCEEDED and a Message similar
    ...    to "User 'XXXX' logged in successfully.
    ...    Where "XXXX" equals the user name of the successful login in step FOQ-ELNP-3.
    ...
    ...    There is a value in the audit trail with a Message similar to "User 'XXXX' failed to login (Invalid
    ...    credentials supplied due to:JBAS011843: Failed instantiate InitialContextFactory com.sun.jndi.ldap.LdapCtxFactory
    ...    from classloader org.jboss.as.security.plugins.ModuleClassLoaderLocator$CombinedClassLoader@5afdb25b)
    ...    Where "XXXX" equals the user name of the failed login attempted in step FOQ-ENP-1
    ...
    ...    The time shown in the audit trail will correspond to the date and time recorded for FOQ-ENP-1. In the audit
    ...    trail the offset from UTC is shown for the time. Depending on how the times have been recorded for the test,
    ...    it may be necessary to correct the time to the timezone shown in the audit trail.
    ...
    ...    It is not possible to Edit the Audit Log
    [Tags]    AUDIT    MANUAL
    Manual Action   Login to E-WorkBook client    #Login to E-WorkBook    ${EWB_THICK_SERVER}:${THICK_CLIENT_PORT}    ${ADMIN_USE}    ${ADMIN_PW}
    Manual Action   User Tools Menu select Audit Log...
    Manual Action   Select "All user logons"
    Manual Action   Change filter to make sure that date range includes date of test.
    Manual Action   Press OK to open Audit Log View
    Manual Action   Right Click on "Type" column and select Filter > Filter Values...
    Manual Action   Select "LOGIN FAILED"
    Manual Action   Select "LOGIN SUCCEEDED"
    Manual Action   Confirm Editting the Audit Log is not permitted
    #Select E-WorkBook Main Window
    Manual Action    Close E-WorkBook
    HomePage.Close Browser


FOQ-ELNP-10: Ability to review system audit log for record deletions
    [Documentation]    Test that deletions are recorded in the system audit log
    ...     There is a value in the audit trail with a Message similar to "Deleted entity '/Root/Administrators/Instance OQ/IOQ Permission Expt <Date>'
    ...     of type 'Experiment' (As Intended)
    ...
    ...     <Date> will equal the same value as recorded for step FOQ-ENP-4
    ...     The time shown in the audit trail will correspond to the date and time recorded for FOQ-ENP-8. In the audit
    ...     trail the offset from UTC is shown for the time. Depending on how the times have been recorded for the test,
    ...     it may be necessary to correct the time to the timezone shown in the audit trail:
    ...
    ...     The user performing the deletion, in step FOQ-ENP-4, will also be shown.
    ...
    ...     It is not possible to Edit the Audit Log
    [Tags]    AUDIT    MANUAL
    Manual Action   Login to E-WorkBook client    #Login to E-WorkBook    ${EWB_THICK_SERVER}:${THICK_CLIENT_PORT}    ${ADMIN_USR}    ${ADMIN_PW}
    Manual Action   User Tools Menu select Audit Log...
    Manual Action   Select "All Entities"
    Manual Action   Change filter to make sure that date range includes date of test.
    Manual Action   Press OK to open Audit Log View
    Manual Action   If necessary (to easily see relevant data):
    Manual Action   Right Click on "User" column and select Filter > Filter Values...
    Manual Action   Select User who performed delete test step FOQ-ENP-8
    Manual Action   Confirm Editting the Audit Log is not permitted
    #Select E-WorkBook Main Window
    Manual Action   Close E-WorkBook
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
