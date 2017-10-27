*** Settings ***
Documentation     contains keywords for working with searches in the designer and web editor
Library           EntityAPILibrary
Library           IDBSSelenium2Library
Library           IDBSSwingLibrary
Library           FileLibrary
Resource          embedded_search_keywords.txt
Resource          ../common_spreadsheet_keywords.txt

*** Variable ***
${multiple_queries_button_panel_xpath}    xpath=.//div[@class='row-wrapper search-panel']    # the xpath to identify the panel containing the multiple query buttons

*** Keywords ***
Create search in hierarchy
    [Arguments]    ${parent id}    ${file path}    ${dataypes}=${EMPTY}    ${measures}=${False}
    [Documentation]    Creates a new search (with a unique name) in the hierarchy
    ...
    ...    *Arguments*
    ...
    ...    _parent id_ - the parent entity ID in which the search will be created
    ...
    ...    _file path_ - the path to the file containing the search XML data
    ...
    ...    _datatypes_ - a list of data types to return (e.g. DOCUMENT or DOCUMENT,GROUP)
    ...
    ...    *Returns*
    ...
    ...    the name of the newly created search
    ${time}=    get time    epoch
    ${search name}=    Set Variable    ${time}_search
    ${search_1_id}=    Create Search    ${parent id}    ${search name}    ${file path}    ${dataypes}    include_measures=${measures}
    [Return]    ${search name}

Query Data button should not exist
    [Documentation]    This asserts that the query data button is not present in the spreadsheet web editor
    Page Should Not Contain Element    xpath=.//div[@class='chevron-link-item queries']

Select and run search from hierarchy
    [Arguments]    ${search timeout}    @{path as element names}
    [Documentation]    This will select a pre-saved search from the entity browser and run that search. \ It will attempt to wait for the search to finish before returning (by checking for the existance of the progress dialog) - it is up to the caller to ensure the data is actually present before continuing.
    ...
    ...    *Arguments*
    ...
    ...    _search timeout_ - the time in which this keyword should wait for the search to run. Uses the same format as per the "Wait Until Keyword Succeeds"
    ...
    ...    _path as element names_ - this is a list of entity names that are used to walk the navigation tree and select a search.
    ...
    ...
    ...    *Pre-requisites*
    ...
    ...    the spreadsheet designer must be open
    Select From Designer Menu    Tools|Run Saved Search
    IDBSSwingLibrary.Activate Dialog    Select a search
    ${path}=    set variable    ${EMPTY}
    # loop throug the path elements - selecting each one in turn. \ if they are not not valid (i.e. do not enable the OK button) then expand their children & keep looping.
    : FOR    ${entity}    IN    @{path as element names}
    \    ${path}=    Set Variable If    '${path}' == '${EMPTY}'    ${entity}    ${path}|${entity}
    \    log    path to set: ${path}
    \    IDBSSwingLibrary.Select Tree Node    entityTree    ${path}
    \    ${enabled}=    IDBSSwingLibrary.Component Is Enabled    OK
    \    run keyword if    ${enabled}    Exit For Loop
    \    IDBSSwingLibrary.Expand Tree Node    entityTree    ${path}
    \    Wait Until Keyword Succeeds    10s    0.3s    IDBSSwingLibrary.Tree Node Should Be Expanded    entityTree    ${path}
    IDBSSwingLibrary.Push Button    OK
    # first we wait until the search progress dialog appears, then we wait for it to disappear before continuing
    # give the progress dialog a chance to appear
    sleep    0.5s
    Disable Taking Screenshots On Failure
    ${old timeout}=    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout    2
    Wait Until Keyword Succeeds    ${search timeout}    2s    IDBSSwingLibrary.Dialog Should not Be Open    Run Search
    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout    ${old timeout}
    Enable Taking Screenshots On Failure
    common_spreadsheet_keywords.Select Spreadsheet Window

Query Data Button should exist
    [Documentation]    This asserts that the query data button is present in the spreadsheet web editor
    Wait Until Page Contains Element    xpath=.//div[@class='chevron-link-item queries']    10s

Press Main Query Data Button
    [Documentation]    This will either (depending on your setup):
    ...
    ...    1. run the single search
    ...
    ...    2. open the multiple search panel
    Wait Until Element Is Visible    xpath=.//div[@class='chevron-link-item queries']
    IDBSSelenium2Library.Click Element    xpath=.//div[@class='chevron-link-item queries']

Launch Saved Seach Dialog
    [Documentation]    This opens the saved search dialog in the spreadsheet designer
    Select From Designer Menu    Tools|Run Saved Search
    Select Dialog    searchSelector    10

Select Saved Search From Tree
    [Arguments]    ${Search_path}
    [Documentation]    This selects a search in the navigatory tree
    ...
    ...    _Preconditions_ The search must have been previously saved in the navigator tree from the desktop client
    ...
    ...    _Arguments_
    ...
    ...    ${Search_path} = path in the tree node where the search is saved
    Click On Tree Node    entityTree    ${Search_path}

Confirm Index Category
    [Arguments]    ${sheet_name}    ${category_name}
    [Documentation]    Select category in opened matrix
    Click On Component    xpath=//*[@name='${sheet_name}']//*[@name='CategoryTile${category_name}']
    Should Be Equal    ${category_name}    ${category_name}

Export Selected Table
    [Arguments]    ${tableName}    ${uniqueIdentifier}    ${filePath}
    ${uniqueID}=    Get time    epoch
    Select From Designer Menu    File|Export|Delimited Text File...
    Sleep    500ms
    Select Dialog    Export Delimited Text Data File
    Push button    deselect
    Check Check Box    xpath=//*[text()='${tableName}']
    Push Button    Next >
    Select Dialog    Export Delimited Text Data File
    Select From Combo Box    delimiter-combo    Pipe (|)
    Push Button    Finish
    Choose From File Chooser    ${filePath}${/}${tableName}_${uniqueIdentifier}
    ${exportCSVName}=    Set Variable    ${tableName}_${uniqueIdentifier}
    [Return]    ${exportCSVName}

Verify Data Category Headers
    [Arguments]    ${tableName}
    ${uniqueID}=    Get time    epoch
    ${name}=    Export Selected Table    ${tableName}    ${uniqueID}    ${OUTPUT_DIR}
    Sleep    10s
    ${file}=    Get File    ${OUTPUT_DIR}${/}${name}.csv
    Sleep    2s
    @{headers}=    Get Headers from Export    ${file}
    [Return]    @{headers}

Confirm value in Table
    [Arguments]    ${tableName}    ${column_name}    ${value}
    Sleep    10s
    ${uniqueID}=    Get time    epoch
    ${name}=    Export Selected Table    ${tableName}    ${uniqueID}    ${OUTPUT_DIR}
    Sleep    10s
    ${file}=    Get File    ${OUTPUT_DIR}${/}${name}.csv
    Sleep    2s
    # Get header list
    ${headers}    String.Fetch From Left    ${file}    \n
    @{headers}=    Split String    ${headers}    \|
    log    ${headers}
    # Match col to get index
    Comment    ${col_index}    Collections.Get Index From List    @{headers}    ${column_name}
    Comment    @{headers}=    Get Headers from Export    ${file}
    ${list}=    Get Headers from Export    ${file}
    ${col_index}    Collections.Get Index From List    ${list}    ${column_name}
    Comment    List Should Contain    ${list}    ES2_SUBJECT_TERM1_Index
    Run Keyword If    "${col_index}"=="-1"    Fail    The column doesn't exist
    # Get row list
    ${rows}=    Split String    ${file}    \n
    # Count rows
    ${row_no}=    Get List Item Count    ${rows}
    Run Keyword If    ${row_no}<1    Fail    No rows in table
    # Get List of row values
    ${col_values}=    Create List
    FOR:    ${element}    IN RANGE    ${row_no}
    \    ${single_row}=    Split String    ${rows}[${element}]    \|
    \    ${row_value}=    Get From List    ${single_row}[${col_index}]
    \    Append To List    ${col_values}    ${row_value}
    Should Contain    ${col_values}    ${value}

Start Spreadsheet Designer
    [Arguments]    ${file_name}    ${Document_no}    ${document_header_no}
    [Documentation]    Opens the spreadsheet designer for any spreadsheet in an open record.
    ...
    ...    Note: This keyword is similar to the Start WebLaunch keyword, but the start web launch keyword only opens the first spreadsheet in a record in the spreadsheet designer.
    ...
    ...    _Arguments_
    ...
    ...    The ${document_header_no} is the document header of the list spreadsheets in an open record. Starts with 0
    # activte weblaunch button
    Select Document Header    ${Document_no}
    Robust Click    document-header-${document_header_no}-menuButton
    Robust Click    ewb-command-ss-webstart-edit
    RobotRemoteAgent.Connect To Java Application    ${weblaunch_alias}
    # load libraries
    Initialise Spreadsheet and select window    ${file_name}

Export Selected Table to CSV
    [Arguments]    ${tableName}    ${uniqueIdentifier}    ${filePath}
    ${uniqueID}=    Get time    epoch
    Select From Designer Menu    File|Export|Delimited Text File...
    Sleep    500ms
    Select Dialog    Export Delimited Text Data File
    Push Button    Next >
    Select Dialog    Export Delimited Text Data File
    Select From Combo Box    delimiter-combo    Pipe (|)
    Push Button    Finish
    Choose From File Chooser    ${filePath}${/}${tableName}_${uniqueIdentifier}
    ${exportCSVName}=    Set Variable    ${tableName}_${uniqueIdentifier}
    [Return]    ${exportCSVName}

Verify Data Category Item
    [Arguments]    ${table_name}    @{expected_values}
    [Documentation]    Gets the data categories (column headers) from export of the given ${table_name} and checks for the presence of one or more @{expected_values}.
    ...
    ...    *Arguments*
    ...
    ...    - _table_name_ - the name of the table to export from the open spreadsheet
    ...    - _expected_values_ - one or more expected values which should be present as data categories
    ...
    ...    *Return Value*
    ...
    ...    A list of headers from the exported table
    ${uniqueID}=    Get time    epoch
    ${name}=    Export Selected Table to CSV    ${table_name}    ${uniqueID}    ${OUTPUT_DIR}
    ${file}=    Wait Until Keyword Succeeds    10s    1s    Get File    ${OUTPUT_DIR}${/}${name}.csv
    @{headers}=    spreadsheet_search_keywords.Get Headers from Export    ${file}
    Check List Contains    Checking data categories contain expected values    ${headers}    ${expected_values}
    [Return]    @{headers}

Run All Queries Button Should Exist
    [Documentation]    This asserts that the run all queries \ button is present in the spreadsheet web editor
    Page Should Contain Element    xpath=.//button[contains(@class, 'refresh-all')]

Run All Queries
    [Documentation]    This runs all queries in the spreadsheet
    robust click    xpath=.//button[contains(@class, 'refresh-all')]    button

Create New Search For Contents Of Test Group
    [Arguments]    ${search_name}    ${entity_type_returned}
    [Documentation]    creates and saves a "group name is _XXXX_" search (returning the specified entity type as results)
    ...
    ...    *Arguments*
    ...
    ...    _search_name_ - what would you like to call this search?
    ...
    ...    _entity_type_to_be_returned_ - the (display) name of the entity (e.g. Experiment, Group, Project)
    ...
    ...    *Pre-requisites*
    ...
    ...    the spreadsheet designer is open and the embedded search tool is open, showing the new search button.
    ...
    ...    *Example*
    ...
    ...    | Create New Search For Contents Of Test Group | This is my search | Experiment
    New Search
    Enter New Search Name    ${search_name}
    Enter Search Condition Row    0    Group    Name    is
    Enter Search Condition Text Operand    0    ${group_name}
    Enter Filter    ${entity_type_returned}
    Sleep    1s    # wait for filter to filter
    Check Result Type By Name    ${entity_type_returned}
    Save Search

Create New Search For Contents Of Project
    [Arguments]    ${search_name}    ${project_name}    @{entity_types_returned}
    [Documentation]    creates a "project title \ is _XXXX_" search (returning the specified entity type as results)
    ...
    ...    *Arguments*
    ...
    ...    _search_name_ - what would you like to call this search?
    ...
    ...    _project_name_ - the name of the project whose contents we want
    ...
    ...    _entity_types_returned_ - the (display) name of the entity types to be returned (e.g. Experiment, Group, Project)
    ...
    ...    *Pre-requisites*
    ...
    ...    the spreadsheet designer is open and the embedded search tool is open, showing the new search button.
    ...
    ...    *Example*
    ...
    ...    | Create New Search For Contents Of Project | This is my search | project 1 | Experiment | Report
    New Search
    Enter New Search Name    ${search_name}
    Enter Search Condition Row    0    Project    Title    is
    Enter Search Condition Text Operand    0    ${project_name}
    : FOR    ${entity_type}    IN    @{entity_types_returned}
    \    Enter Filter    ${entity_type}
    \    Sleep    1s    # wait for filter to filter
    \    Check Result Type By Name    ${entity_type}
    Enter Filter    ${EMPTY}    # need to do this to ensure that ALL checked entity types are active

Create And Run New Search For Contents Of Project
    [Arguments]    ${search_name}    ${project_name}    @{entity_types_returned}
    [Documentation]    creates AND RUNS a "project title \ is _XXXX_" search (returning the specified entity type as results)
    ...
    ...    *Arguments*
    ...
    ...    _search_name_ - what would you like to call this search?
    ...
    ...    _project_name_ - the name of the project whose contents we want
    ...
    ...    _entity_types_returned_ - the (display) name of the entity types to be returned (e.g. Experiment, Group, Project)
    ...
    ...    *Pre-requisites*
    ...
    ...    the spreadsheet designer is open and the embedded search tool is open, showing the new search button.
    ...
    ...    *Example*
    ...
    ...    | Create And Run New Search For Contents Of Project | This is my search | project 1 | Experiment | Report
    Create New Search For Contents Of Project    ${search_name}    ${project_name}    @{entity_types_returned}
    run search

Open Search ToolPane Closing Others
    [Documentation]    closes the model browser & format toolpane and then opens the search toolpane, ensuring we have good initital real estate for the UI
    common_spreadsheet_keywords.Select Spreadsheet Window
    # if this keyword has been called immediately after the designer has been launched, then it is possible that the button is clicked before things are really wired up    # which means the browser won't close.    # so we try it once, ignorning errors
    run keyword and ignore error    Close Model Browser
    Close Format Toolpane
    # and later on try again - this time reporting on errors. \ This certainly fixed it in our test cases
    Close Model Browser
    Open Search Toolpane

Create And Run New Search For Experiments in project
    [Arguments]    ${search_name}    ${project_name}    @{entity_types_returned}
    [Documentation]    creates AND RUNS a "project title \ is _XXXX_" search (returning the specified entity type as results)
    ...
    ...    *Arguments*
    ...
    ...    _search_name_ - what would you like to call this search?
    ...
    ...    _project_name_ - the name of the project whose contents we want
    ...
    ...    _entity_types_returned_ - the (display) name of the entity types to be returned (e.g. Experiment, Group, Project)
    ...
    ...    *Pre-requisites*
    ...
    ...    the spreadsheet designer is open and the embedded search tool is open, showing the new search button.
    ...
    ...    *Example*
    ...
    ...    | Create And Run New Search For Contents Of Project | This is my search | project 1 | Experiment | Report
    Create New Search For Contents Of Project    ${search_name}    ${project_name}    @{entity_types_returned}
    run search

Run Named Query
    [Arguments]    ${search_name}
    [Documentation]    Run's a query given by \ ${search_name} from the Spreadsheet Web EditorMultiple Query selection panel
    Robust Click    xpath=.//button[@title='${search_name}']    button

Refresh All Queries Button Should Be Visible
    [Documentation]    Verifies that the 'Refresh All' button is visible on the Query Data panel.
    Element Should Be Visible    css=.refresh-all

Query Should Be Visible
    [Arguments]    ${search_name}
    [Documentation]    Verifies that the button for the query specified by ${search_name} is visible on the Query Data panel in the web editor.
    Element Should Be Visible    xpath=.//button[@title='${search_name}']

Query Hints Should Be Visible
    [Documentation]    Verifeis that the hints on the Query Data panel are visible.
    Xpath Should Match X Times    //div[contains(@class,'info')]    2
