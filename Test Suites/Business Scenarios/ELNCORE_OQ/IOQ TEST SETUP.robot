*** Settings ***
Documentation    Test Data and Permissions set up for OQ
...
...
Suite Setup
Suite Teardown
Test Setup
Test Teardown
Force Tags
Resource          ../../../../Resources/ElnCore/Keywords/E-WorkBook Thick Client/ewb_thick_client_general_actions_resource.robot
Resource          ../../../../Resources/ElnCore/Keywords/E-WorkBook Thick Client/ewb_thick_client_workflow_actions_resource.robot
Resource          ../../../../Resources/ElnCore/Keywords/E-WorkBook Thick Client/ewb_thick_client_general_actions_resource.robot
Resource          ../../../../Resources/ElnCore/Keywords/Common/common_resource.robot
Resource          ../../../../Resources/ElnCore/Keywords/E-WorkBook Thick Client/ewb_thick_client_configuration_actions_resources.robot
Resource          ../../../../Resources/ElnCore/Keywords/E-WorkBook Thick Client/ewb_thick_client_workflow_actions_resource.robot
Resource          ./Test data/IOQ-ELN-Config - Alcami.robot
Library           IDBSSelenium2Library
Library           DateTime

#pybot -T -d results "Test Suites/Business Scenarios/ELNCORE_OQ/IOQ TEST SETUP.robot"

*** Variables ***
${DATE}

*** Test Cases ***

Setup Hierarchy
    [Documentation]
    [Tags]  HIERARCHY
    Create OQ Hierarchy    OQ_GROUP    OQ Group    Custom record type    False    False    False

Setup Users
    [Documentation]
    [Tags]  USERS
    Create Users and Assign User Roles

Setup Workflows
    [Documentation]
    [Tags]    WFLOW
    Set-up: Workflows

*** Keyword ***

Set-up: Workflows
    [Documentation]    This test carries out the thick client configuration of the E-WorkBook system ready for the smoke test to be carried out.
    ...
    ...    It covers:
    ...    - Hierarchy creation (Groups, Projects and Experiments with data)
    ...    - Entity role creation
    ...    - User role creation
    ...    - User creation
    ...    - User group creation
    ...    - Assignment of roles to users and groups on entities
    ...    - Workflow creation
    ...    - Importing of a catalog
    ...    - Enabling of the Spreadsheet Data transform
    Login to E-WorkBook    ${EWB_THICK_SERVER}:${THICK_CLIENT_PORT}    ${ADMIN_USER}    ${ADMIN_PW}
    Run Keyword And Continue On Failure    Create OQ WorkFlow
    Select E-WorkBook Main Window
    Close E-WorkBook
    [Teardown]    Thick client teardown

Create Users and Assign User Roles
    run keyword and ignore error    SecurityAPILibrary.Create Entity Role    OQ Sign Off    Sign Off Manager    SIGNOFF_TASK    INITIATE_PUBLISHING
    Run Keyword And ignore error    SecurityAPILibrary.Create Entity Role    OQ Use Experiment    Not able to create experiments    EDIT_EXPERIMENT    OPEN_EXPERIMENT    VIEW_EXPERIMENT    ALLOW_DRAFT_EXPERIMENTS
    Run Keyword And ignore error    SecurityAPILibrary.Create Entity Role    OQ View Experiment    Not able to create records    OPEN_EXPERIMENT    VIEW_EXPERIMENT    ALLOW_DRAFT_EXPERIMENTS
    Run Keyword And ignore error    SecurityAPILibrary.Create Entity Role    OQ Manage Experiment    Experiment Owner    CREATE_EXPERIMENT    EDIT_EXPERIMENT    OPEN_EXPERIMENT    VIEW_EXPERIMENT    DELETE_EXPERIMENT    ALLOW_DRAFT_EXPERIMENTS
    Run Keyword And ignore error    SecurityAPILibrary.Create Entity Role    OQ View Role    View Role    VIEW_TEMPLATE    VIEW_EXPERIMENT    VIEW_REPORT    VIEW_PROJECT    VIEW_GROUP    VIEW_PDF    VIEW_PDF_FOLDER
    Run Keyword And ignore error    SecurityAPILibrary.Create Entity Role    OQ Open Hierarchy    Permission to open items in the hierarchy above experiments (needed for workflows)    OPEN_PROJECT    OPEN_ROOT    OPEN_GROUP    OPEN_FOLDER

    Run Keyword And ignore error    SecurityAPILibrary.Create User    ${User1}    Standard OQ User    ${User1PWD}
    Run Keyword And ignore error    SecurityAPILibrary.Assign System Role To User    ${User1}    ALL_SYSTEM_PERMISSIONS
    Run Keyword And ignore error    SecurityAPILibrary.Assign Entity Role To User    ${User1}    OQ Open Hierarchy    /Root/Administrators/
    Run Keyword And ignore error    SecurityAPILibrary.Assign Entity Role To User    ${User1}    OQ View Role    /Root/Administrators
    Run Keyword And ignore error    SecurityAPILibrary.Assign Entity Role To User    ${User1}    OQ Sign Off    /Root/Administrators
    Run Keyword And ignore error    SecurityAPILibrary.Assign Entity Role To User    ${User1}    OQ Use Experiment    /Root/Administrators

    Run Keyword And ignore error    SecurityAPILibrary.Create User    ${User2}    No Access to EWB    ${User2PWD}

    Run Keyword And ignore error    SecurityAPILibrary.Create User    ${User3}    OQ Create Expt    ${User3PWD}
    Run Keyword And ignore error    SecurityAPILibrary.Assign System Role To User    ${User3}    ALL_SYSTEM_PERMISSIONS
    Run Keyword And ignore error    SecurityAPILibrary.Assign Entity Role To User    ${User3}    OQ Manage Experiment    /Root/Administrators
    Run Keyword And ignore error    SecurityAPILibrary.Assign Entity Role To User    ${User3}    OQ View Role    /Root/Administrators
    Run Keyword And ignore error    SecurityAPILibrary.Assign Entity Role To User    ${User3}    OQ Open Hierarchy    /Root/Administrators
    Run Keyword And ignore error    SecurityAPILibrary.Assign Entity Role To User    ${User3}    OQ Use Experiment    /Root/Administrators

    Run Keyword And ignore error    SecurityAPILibrary.Create User    ${User4}    OQ No Create Expt    ${User4PWD}
    Run Keyword And ignore error    SecurityAPILibrary.Assign System Role To User    ${User4}    ALL_SYSTEM_PERMISSIONS
    Run Keyword And ignore error    SecurityAPILibrary.Assign Entity Role To User    ${User4}    OQ Use Experiment    /Root/Administrators
    Run Keyword And ignore error    SecurityAPILibrary.Assign Entity Role To User    ${User4}    OQ View Role    /Root/Administrators
    Run Keyword And ignore error    SecurityAPILibrary.Assign Entity Role To User    ${User4}    OQ Open Hierarchy    /Root/Administrators

    Run Keyword And ignore error    SecurityAPILibrary.Create User    ${User5}    OQ View Expt    ${User5PWD}
    Run Keyword And ignore error    SecurityAPILibrary.Assign System Role To User    ${User5}    ALL_SYSTEM_PERMISSIONS
    Run Keyword And ignore error    SecurityAPILibrary.Assign Entity Role To User    ${User5}    OQ View Role    /Root/Administrators
    Run Keyword And ignore error    SecurityAPILibrary.Assign Entity Role To User    ${User5}    OQ Open Hierarchy    /Root/Administrators
    Run Keyword And ignore error    SecurityAPILibrary.Assign Entity Role To User    ${User5}    OQ View Experiment    /Root/Administrators

Create OQ WorkFlow
    Open Workflow Configuration    Root/Administrators
    Create New Configuration    OQ Test Workflow    OQ Workflow Description
    Select Workflow Process    Sequential
    Set Workflow time limit    7    Days
    Select Workflow Entity Types    Experiment    Report    Template    Form
    Create New Workflow Task    Author Sign Off    Sign Off    Actioner
    Enable Automatically close task checkbox
    Add to Task User Pool    ${ADMIN_USER}
    Save Task Configuration
    Create New Workflow Task    Witness Sign Off    Sign Off    Reviewer
    Enable Set Experiment Status After Task Completion    Archived
    Enable Publish Record After Task Completion
    Add to Task User Pool    ${User1}
    Save Task Configuration
    #TODO Set System Actions Change Lock status to Locked
    Save Workflow Changes and Close Dialog


Create OQ Hierarchy
    [Arguments]    ${name}    ${display_name}    ${description}    ${versioned}=${False}    ${contains_documents}=${False}    ${run_transforms}=${False}
    # create new Entity Type group OQ_GROUP
    Configure New Entity Type    OQ_GROUP    OQ Group    Custom record type    False    False    False
    # Configure Hierarchy of OQ_GROUP to include :
    #       WEB_SEARCH
    #       IS_RESOURCES
    #       SEARCH
    #       SPREADSHEET_FORM
    #       FORM
    #       LANDING_PAGE
    #       LOOKUP_SOURCE
    #       TEMPLATE
    #       SPREADSHEET
    #       REPORT
    #       EXPERIMENT
    # create new group with Entity Type OQ_GROUP called OQ Group



#Delete Users and Roles
#    [Documentation]    Test successful login to the E-WorkBook web application
#    Disable User   ${User1}    Disable OQ Test OQUser1
#    Disable User   ${User2}    Disable OQ Test OQUser2
#    Disable User   ${User3}    Disable OQ Test OQUser3

#    Delete Role  OQ_NoAccess    Test Complete OQ_NoAccess role deleted
#    Delete Role  OQ_CreateExp   Test Complete OQ_CreateExp role deleted
#    Delete Role  OQ_NoCreateExp    Test Complete OQ_NoCreateExp role deleted




