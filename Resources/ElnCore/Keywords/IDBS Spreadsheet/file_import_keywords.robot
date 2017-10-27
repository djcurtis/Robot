*** Settings ***
Library           QuantrixLibrary
Resource          ../Common/common_resource.robot
Resource          ../IDBS Spreadsheet/common_spreadsheet_keywords.robot
Resource          ../Selenium/quantrix_web_resource.robot
Resource          ../Common/general setup tools.robot

*** Variables ***
${DATA_SOURCE_DESCRIPTION}    Imports data from structured text files
${DATASOURCE_DESCRIPTION_XPATH}    xpath=//*[@name='WizardPane']/*[text()='${DATA_SOURCE_DESCRIPTION}']    # the datasource description label is not named so we need this unstable path to identify it

*** Keywords ***
DataLink Output Create Two Dimensional Table
    [Documentation]    creates a Two Dimensional Table as an output from the datalink wizard. \ This just accepts the defaults of the wizard from start to finish
    ...
    ...    *Pre-requisites*
    ...
    ...    The datalink wizard must be open and on the select data destination stage.
    component should exist    DataSourceList    2
    List should contain    DataSourceList    Two Dimensional Table
    click on list item    DataSourceList    Two Dimensional Table
    # got to first column as row names
    IDBSSwingLibrary.Push Button    Next >
    # go to replace/append rows
    IDBSSwingLibrary.Push Button    Next >
    Wait Until Keyword Succeeds    2s    0.1s    Component Is Enabled    Finish
    push button    Finish
    sleep    1s    wait for the import table to be built

File Import Suite Setup
    Create Hierarchy For Experiments    FILE_IMPORT

File Import Test Setup
    [Documentation]    Creates a new experiment and goes to it in the browser
    ${unique_id}=    Get Time    epoch
    Set Suite Variable    ${experiment_name}    FILE_IMPORT_${unique_id}_EXPERIMENT
    ${experiment_id}=    EntityAPILibrary.Create Experiment    ${project_id}    ${experiment_name}
    ${experiment_id}=    Run Keyword And Continue On Failure    Evaluate    '${experiment_id}'.translate(None, '"')
    ${experiment_url}=    Create Entity URL    ${experiment_id}
    Set Suite Variable    ${experiment_url}
    Set Suite Variable    ${experiment_id}
    weblaunch Open Browser To Page    ${experiment_url}    ${VALID USER}    ${VALID PASSWD}
    Navigation Title Check    IDBS E-WorkBook - ${experiment_name}

File Import Test Teardown
    [Arguments]    ${shutdown_designer}=no
    [Documentation]    Creates a new experiment and goes to it in the browser
    ...
    ...    *Arguments*
    ...
    ...    _shutdown designer_ default: no - specify yes to shutdown an open spreadsheet designer session.
    run keyword if    '${shutdown_designer}'=='yes'    Run Keyword And Ignore Error    Shut down weblaunch
    run keyword if    '${shutdown_designer}'=='yes'    Kill All Spreadsheet Designer Sessions    # to handle failure and possibly open modal dialogs from other test runs
    Run Keyword And Ignore Error    EntityAPILibrary.Unlock Entity    ${experiment_id}
    Close All Browsers

File Import Suite Teardown
    [Documentation]    Closes all browsers and deletes all entities if passed successfully
    Kill All Spreadsheet Designer Sessions    # to handle failure and possibly open modal dialogs from other test runs
    Suite Teardown
    Run Keyword And Ignore Error    Delete Hierarchy

Insert spreadsheet and start Designer
    [Documentation]    inserts a new spreadsheet into the current experiment and then starts the spreadsheet designer and swtiches into the modeler role.
    ...
    ...    *Pre-requisites*
    ...
    ...    an open, empty experiment must be active/selected in the e-workbook web client
    Insert new Spreadsheet from menu    draft
    Wait Until Document Present    0
    Version Save Record    ${VALID USER}    ${VALID PASSWD}    Break
    Kill All Spreadsheet Designer Sessions    # to handle failure and possibly open modal dialogs from other test runs
    Start Weblaunch    ${DATA_ENTRY_SPREADSHEET_REGEX}

Import Files Into Field Should Be Visible
    [Documentation]    Verifies that the 'Import files into' box is visible on the File Import panel.
    Element Should Be Visible    css=div.file-import-wrapper

Using Import Definition Field Should Be Visible
    [Documentation]    Verifies that the 'Using import definition' box is visible on the 'File Import' panel.
    Element Should Be Visible    css=div.import-definition-wrapper

Upload File Box Should Be Visible
    [Documentation]    Verifies that the 'Drag files here' box is visible on the File Import panel.
    Element Should Be Visible    css=div.drop-target

File Order Box Should Be Visible
    [Documentation]    Verifies that the file re-ordering box is visible on the File Import panel.
    Element Should Be Visible    css=.simple-listbox

Import Button Should Be Visible
    [Documentation]    Verifies that the Import button on the File Import panel is visible.
    Element Should Be Visible    css=.import-button

File Import Hints Should Be Visible
    [Documentation]    Verifies that the hint text on the File Import panel in the web editor is visible.
    Xpath Should Match X Times    //div[contains(@class,'footnote')]    2

Open File Import Panel
    [Documentation]    Clicks the File Import button on the data panel to slide in the File Import panel in the web editor.
    ...
    ...    Requires that the Data panel is visible.
    Robust Click    css=div.file-import
