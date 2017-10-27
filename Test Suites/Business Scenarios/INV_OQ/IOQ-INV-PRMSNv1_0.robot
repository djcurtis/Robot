*** Settings ***
Documentation     Instance OQ Test Suite
...
...               The OQ test specification, which is described below, is designed to confirm that the E-WorkBook
...               ELN/Core permissions are functioning as expected for use in a validated environment. This test is
...               based on restricting the permissions available for a user and confirming the expected behavior.
...
...               Prerequisites
...               This test assumes that the  E-WorkBook Inventory has not been modified from the installed product
...               and that the Instance OQ - Inventory v1.0 been executed (ie Equipment item "OQ Test Item 1" exists).
...
...               A user account is available that is assigned to the ImsUser E-WorkBook user group. This user should
...               be used for the entire test execution.
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

#pybot -T -d results -i SMOKE "Tests/Business Scenarios/ELNCORE_OQ/IOQ-ELN.robot"

*** Variables ***


*** Test Cases ***




IOQ-INV-0: Execution Log
    [Documentation]
    ...
    [Tags]
    ${INV_INSTANCE_NAME}=    Get Value from User    Inventory Instance Name:    default
    ${EWB_INSTANCE_NAME}=    Get Value from User    E-WorkBook Instance Name:    default
    ${TESTED_BY}=    Get Value from User    Name of person performing test:    default
    ${INV_VERSION}=    Get Value from User    E-WorkBook version and build    default
    ${EWB_VERSION}=    Get Value from User    E-WorkBook version and build    default
    ${BROWSER_VERSION}=    Get Value from User    Browser and version used to perform test:    default

FOQ-INVP-1: A user entering the wrong password will be denied access to E-WorkBook Inventory
    [Documentation]   Test unsuccessful login to the E-WorkBook Inventory application:
    ...
    ...    Logon dialog remains displayed and the message "Sign in failed: invalid user name / password" is displayed.
    [Tags]
    Manual Action    Launch application.
    Manual Action    Enter user credentials, with the wrong password, in logon dialog and press "sign-in."



FOQ-INVP-2: A user without the E-WorkBook Inventory Write permission cannot create an Experiment
    [Documentation]    Test that a user without the relevant permission cannot create an Item.
    ...
    ...     The "ADD NEW..." option is not displayed.
    [Tags]
    Manual Action    Launch application.
    Manual Action    Enter user credentials in logon dialog and press "sign-in."
    Manual Action    Check the availability of the "ADD NEW..." option on the left panel


FOQ-INVP-3: A user without the E-WorkBook Inventory Write permission cannot edit an existing Item.
    [Documentation]    Test that a user without the relevant permission cannot edit an existing Item.
    ...
    ...    Test 3a: The xxx dialog is not displayed on clicking the status and a pencil icon is not displayed
    ...    on the card.
    ...
    ...    Test 3b: The edit item option is disabled.
    [Tags]     MANUAL
    Manual Action    Test 3a: Click on "OQ Test Item 1" card:
    Manual Action    1. Click on the status 2. Check for display of a pencil icon
    Manual Action    Test 3b: Click on "OQ Test Item 1" card:
    Manual Action    1. Select OPTIONS 2. Check availability of the Edit item option.

FOQ-INVP-4: A user without the E-WorkBook Inventory Delete permission cannot delete an existing Item.
    [Documentation]    Test that a user without the relevant permission cannot delete an existing Item.
    ...
    ...    The Delete item option is disabled.
    [Tags]
    Manual Action    Click on "OQ Test Item 1" card
    Manual Action    Select Options
    Manual Action    Check availability of the Delete item option.

FOQ-INVP-5: Ability to review E-WorkBook system audit log for successful and failed user logon to E-WorkBook Inventory
    [Documentation]    Test that successful and failed logons are captured in the system audit log
    ...
    ...    There is a value in the audit trail with a Type of LOGIN SUCCEEDED and a Message similar to "User 'XXXX'
    ...    logged in successfully. Where "XXXX" equals the user name of the successful login in step FOQ-ELNP-3.
    ...
    ...    There is a value in the audit trail with a Message similar to "User 'XXXX' failed to login (Invalid
    ...    credentials supplied due to:JBAS011843: Failed instantiate InitialContextFactory
    ...    com.sun.jndi.ldap.LdapCtxFactory from classloader org.jboss.as.security.plugins.ModuleClassLoaderLocator$CombinedClassLoader@5afdb25b)"
    ...    Where "XXXX" equals the user name of the failed login attempted in step FOQ-ENP-1
    ...
    ...    The time shown in the audit trail will correspond to the date and time recorded for FOQ-ENP-1. In the audit
    ...    trail the offset from UTC is shown for the time. Depending on how the times have been recorded for the test,
    ...    it may be necessary to correct the time to the timezone shown in the audit trail.
    ...
    ...    It is not possible to edit the audit log.
    [Tags]
    Manual Action    Open E-WorkBook Desktop Client
    Manual Action    Logon with appropriate user credentials
    Manual Action    User Tools Menu select Audit Log...
    Manual Action    Select "All user logons"
    Manual Action    Change filter to make sure that date range includes date of test.
    Manual Action    Press OK to open Audit Log View
    Manual Action    Right Click on "Type" column and select Filter > Filter Values...
    Manual Action    Select "LOGIN SUCCEEDED" and "LOGIN FAILED"
    Manual Action    Right Click on "Host" column and select Filter > Filter Values...
    Manual Action    Select the value of the Inventory Management system