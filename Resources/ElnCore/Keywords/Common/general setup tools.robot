*** Settings ***
Documentation     contains utility keywords that perform common setup tasks for test suites, avoiding duplication across tests.
# Library           EntityAPILibrary
Resource          ../Selenium/general_resource.robot

*** Keywords ***
Create Experiment and Hierarchy
    [Arguments]    ${entity_prefix}    # used to allow for easy identification of entities when browsing if the tests fail.
    [Documentation]    Creates a stock hierarchy (Group/Project/Experiment) ready for use in tests. \ Should be used in conjunction with the _Delete Experiment and Hierarchy_ keyword
    ...
    ...    *Arguments*
    ...
    ...    _entity_prefix_ - a piece of text to be pre-pended to each entity being created to allow for easy identification if tests fail.
    ...
    ...
    ...    *Suite Variables*
    ...
    ...    The following suite variables are made available from this method:
    ...
    ...    _group_id_, _group_name_, _group_url_
    ...
    ...    _project_id_, _project_name_, _project_url_
    ...
    ...    _experiment_id_, _experiment_name_, _experiment_url_
    Create Hierarchy For Experiments    ${entity_prefix}
    Create Test Experiment    ${entity_prefix}

Create Hierarchy For Experiments
    [Arguments]    ${entity_prefix}    # used to allow for easy identification of entities when browsing if the tests fail.
    [Documentation]    Creates a stock hierarchy (Group/Project) ready for experiments to be created in tests. \ Should be used in conjunction with the _Delete Hierarchy_ keyword
    ...
    ...    *Arguments*
    ...
    ...    _entity_prefix_ - a piece of text to be pre-pended to each entity being created to allow for easy identification if tests fail.
    ...
    ...
    ...    *Suite Variables*
    ...
    ...    The following suite variables are made available from this method:
    ...
    ...    _group_id_, _group_name_, _group_url_
    ...
    ...    _project_id_, _project_name_, _project_url_
    ${unique_id}=    Get Time    epoch
    Set Suite Variable    ${rest_api_host}    ${SERVER}
    #create hierarchy
    Set Suite Variable    ${group_name}    ${entity_prefix}_${unique_id}_GROUP
    Set Suite Variable    ${project_name}    ${entity_prefix}_${unique_id}_PROJECT
    ${group_id}=    EntityAPILibrary.Create Group    1    ${group_name}
    ${project_id}=    EntityAPILibrary.Create Project    ${group_id}    ${project_name}
    Set Suite Variable    ${group_id}
    Set Suite Variable    ${project_id}
    #set entity URLs
    ${group_url}=    Create Entity URL    ${group_id}
    Set Suite Variable    ${group_url}
    ${project_url}=    Create Entity URL    ${project_id}
    Set Suite Variable    ${project_url}

Create Test Experiment
    [Arguments]    ${entity_prefix}    # used to allow for easy identification of entities when browsing if the tests fail.
    [Documentation]    Creates an experiment for a test
    ...
    ...    *Arguments*
    ...
    ...    _entity_prefix_ - a piece of text to be pre-pended to each entity being created to allow for easy identification if tests fail.
    ...
    ...
    ...    *Suite Variables*
    ...
    ...    The following suite variables are made available from this method:
    ...
    ...    _experiment_id_, _experiment_name_, _experiment_url_
    ${unique_id}=    Get Time    epoch
    Set Suite Variable    ${experiment_name}    ${entity_prefix}_${unique_id}_EXPERIMENT
    ${experiment_id}=    EntityAPILibrary.Create Experiment    ${project_id}    ${experiment_name}
    ${experiment_url}=    Create Entity URL    ${experiment_id}
    Set Suite Variable    ${experiment_url}
    Set Suite Variable    ${experiment_id}

Delete Experiment and Hierarchy
    [Documentation]    Unlocks the experiment & then deletes the hierarchy created by the _Create Experiment and Hierarchy_ keyword
    Unlock Test Experiment
    Delete Hierarchy

Delete Hierarchy
    [Documentation]    Deletes the hierarchy created by the _Create Hierarchy for Experiments_ keyword
    EntityAPILibrary.Unlock Entity And Children    ${groupId}
    EntityAPILibrary.Delete Entity    ${group_id}    As Intended    Test Comment

Reload Page Before Test
    [Documentation]    Reloads the page to 'soft' reset the web client before starting a test. Need to handle the case where the record may be locked, so try to click the 'OK' button on the dialog that may displayed stating this.
    Reload Page
    Run Keyword And Ignore Error    Click Button    okButton    # not using RobustClick here as the OK button may not appear and we don't want to delay the test by waiting for it unnecessarily

Unlock Test Experiment
    [Documentation]    Unlocks the experiment
    Run Keyword And Ignore Error    EntityAPILibrary.Unlock Entity    ${experiment_id}

Create Test Template
    [Arguments]    ${entity_prefix}    # used to allow for easy identification of entities when browsing if the tests fail.
    [Documentation]    Creates a template for a test
    ...
    ...    *Arguments*
    ...
    ...    _entity_prefix_ - a piece of text to be pre-pended to each entity being created to allow for easy identification if tests fail.
    ...
    ...
    ...    *Suite Variables*
    ...
    ...    The following suite variables are made available from this method:
    ...
    ...    _template_id_, _template_name_, _template_url_
    ${unique_id}=    Get Time    epoch
    Set Suite Variable    ${template_name}    ${entity_prefix}_${unique_id}_TEMPLATE
    ${template_id}=    EntityAPILibrary.Create Template    ${project_id}    ${template_name}
    ${template_url}=    Create Entity URL    ${template_id}
    Set Suite Variable    ${template_url}
    Set Suite Variable    ${template_id}

Create Test SHADOW_CUSTOM
    [Arguments]    ${entity_prefix}    # used to allow for easy identification of entities when browsing if the tests fail.
    [Documentation]    Creates the custom record SHADOW_CUSTOM for a test via the API service
    ...
    ...    *Arguments*
    ...
    ...    _entity_prefix_ - a piece of text to be pre-pended to each entity being created to allow for easy identification if tests fail.
    ...
    ...    *Pre-requisites*
    ...
    ...    There must be an entity type of SHADOW_CUSTOM configured in the flexible heirarchy
    ...
    ...    *Suite Variables*
    ...
    ...    The following suite variables are made available from this method:
    ...
    ...    _custom_id_, _custom_name_, _custom_url_
    ${unique_id}=    Get Time    epoch
    Set Suite Variable    ${custom_name}    ${entity_prefix}_${unique_id}_Custom
    ${custom_id}=    EntityAPILibrary.Create Entity    SHADOW_CUSTOM    ${project_id}    ${custom_name}    title:::${custom_name}    statusName:::Started
    ${custom_url}=    Create Entity URL    ${custom_id}=
    Set Suite Variable    ${custom_url}
    Set Suite Variable    ${custom_id}
