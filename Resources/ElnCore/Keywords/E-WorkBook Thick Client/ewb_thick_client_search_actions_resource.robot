*** Settings ***
Resource          ewb_thick_client_general_actions_resource.robot
Resource          ewb_thick_client_record_entity_actions_resource.robot
Library           OperatingSystem
Library           PyWinAutoLibrary
Library           IDBSSwingLibrary
Library           RobotRemoteAgent

*** Variables ***
${current_search_row}    1

*** Keywords ***
Add query with or
    Push Button    AbstractQueryBuilder.addOrLinkLabel
    ${current_search_row}=    Evaluate    ${current_search_row}+1
    ${current_search_row}=    Set Test Variable    ${current_search_row}    # Make test wide

Check that data from document "${document_path}" is returned
    ${row}=    Find Table Row    class=com.idbs.ewb.tool.search.results.ResultsTable    ${document_path}    Path (Document)
    Run Keyword If    ${row}==-1    Fail    Could not find any date from document "${document_path}" in the search results.

Check that data from experiment "${experiment_path}" is returned
    ${row}=    Find Table Row    class=com.idbs.ewb.tool.search.results.ResultsTable    ${experiment_path}    Path (Experiment)
    Run Keyword If    ${row}==-1    Fail    Could not find any date from experiment "${experiment_path}" in the search results.

Close Entity
    [Arguments]    ${entityname}
    [Documentation]    Closes an open entity be it a record entity or search tab
    Change tab    ${entityname}
    Select from E-WorkBook Main Menu    File    Close ${entityname}

Close Quick Search
    Select Dialog    Quick Search
    Close Dialog    Quick Search

Close current search
    Push Button    xpath=//*[contains(@class,'CloseButton') and @showing='true']
    Select E-WorkBook Main Window
    Sleep    1    Give E-WorkBook time to redraw the navigator tree

Create saved search
    [Arguments]    ${path}    ${name}
    ${pipe_separated_path}=    Replace String    ${path}    /    |
    ${old_timeout}=    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    1
    Tree Node Should Not Exist    class=WorkbenchNavigatorTree    ${pipe_separated_path}|${name}
    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    ${old_timeout}
    Select From Navigator Tree Right-click Menu    ${pipe_separated_path}    New|Search...
    Select Dialog    New Search
    Insert Into Text Field    name_editor    ${name}
    Push Button    OK
    Select E-WorkBook Main Window

Ensure show in spreadsheet checkbox is unchecked
    scroll To Component    xpath=//*[contains(text(),'Show in Spreadsheet')]
    Uncheck Check Box    text=Show in Spreadsheet

Enter query for document form data is from file
    [Arguments]    ${file_name}    ${form_field}    ${form_operator}    ${form_value}
    Push Button    ENTITY_TYPE_DROPDOWNButton${current_search_row}_0
    Click On Component    xpath=//*[@name='ENTITY_TYPE_DROPDOWNMenu${current_search_row}_0']//*[text()='Document']
    Sleep    0.5s
    Push Button    ATTRIBUTE_DROPDOWNButton${current_search_row}_0
    Click On Component    xpath=//menuitem[text()='Form Data']
    Sleep    0.5s
    Push Button    OPERATOR_DROPDOWNButton${current_search_row}_0
    Click On Component    xpath=//menuitem[text()='is']
    Select From Combo Box    ENTITY_QUERY_BUILDER_ROW.locationDrop_${current_search_row}_0    From File
    Insert Into Text Field    ENTITY_QUERY_BUILDER_ROW.textField_${current_search_row}_0    ${file_name}
    Select From Combo Box    ENTITY_QUERY_BUILDER_ROW.formFieldDropdown_${current_search_row}_0    ${form_field}
    Select From Combo Box    ENTITY_QUERY_BUILDER_ROW.operatorDropdown_${current_search_row}_0    ${form_operator}
    Select From Combo Box    xpath=//combobox[@name='ENTITY_QUERY_BUILDER_ROW.operatorTypeDropdown_${current_search_row}_0' and @showing='true']    ${form_value}

Enter query for document measures contains
    [Arguments]    ${dictionary}    ${attribute}    ${operator}    ${value}
    Push Button    ENTITY_TYPE_DROPDOWNButton${current_search_row}_0
    Click On Component    xpath=//*[@name='ENTITY_TYPE_DROPDOWNMenu${current_search_row}_0']//*[text()='Document']
    Sleep    0.5s
    Push Button    ATTRIBUTE_DROPDOWNButton${current_search_row}_0
    Click On Component    xpath=//menuitem[text()='Measures']
    Sleep    0.5s
    Push Button    OPERATOR_DROPDOWNButton${current_search_row}_0
    Click On Component    xpath=//menuitem[text()='contains']
    Push Button    xpath=//*[contains(@class,'TermLookup')]//button
    Select Dialog    Browse dictionaries and terms
    Type Into Text Field    0    ${dictionary}
    Click On Component    class=JPopupMenu
    Sleep    0.5s
    Wait for glass pane to disappear
    Push Button    OK
    Select E-WorkBook Main Window
    Push Button    xpath=//*[contains(@class,'catalog.JCatalogQueryBuilder')]//button[@name='ATTRIBUTE_DROPDOWNButton0_0']
    Click On Component    xpath=//menuitem[text()='${attribute}']
    Push Button    xpath=//*[contains(@class,'catalog.JCatalogQueryBuilder')]//button[@name='OPERATOR_DROPDOWNButton0_0']
    Click On Component    xpath=//menuitem[text()='${operator}']
    Insert Into Text Field    xpath=//*[contains(@class,'catalog.JCatalogQueryBuilder')]//*[contains(@class,'JStringField')]    ${value}

Enter query for document reaction is exact from file
    [Arguments]    ${chemsitry_file}
    Push Button    ENTITY_TYPE_DROPDOWNButton${current_search_row}_0
    Click On Component    xpath=//*[@name='ENTITY_TYPE_DROPDOWNMenu${current_search_row}_0']//*[text()='Document']
    Sleep    0.5s
    Push Button    ATTRIBUTE_DROPDOWNButton${current_search_row}_0
    Click On Component    xpath=//menuitem[text()='Reactions']
    Sleep    0.5s
    Push Button    OPERATOR_DROPDOWNButton${current_search_row}_0
    Click On Component    xpath=//menuitem[text()='is exact']
    Select From Popup Menu    xpath=//*[contains(@class,'ChemicalStructureQueryComponent')]    Open File...
    Choose From File Chooser    ${chemsitry_file}
    Select Dialog    Question
    Push Radio Button    text=Resize Structure
    Push Button    text=OK
    Select E-WorkBook Main Window

Enter query for document text contains
    [Arguments]    ${text}
    Setup Simple Query    Document    Text    contains    ${text}

Enter query for experiment title is
    [Arguments]    ${experiment_title}
    Setup Simple Query    Experiment    Title    is    ${experiment_title}

Initialise search panel
    Select E-WorkBook Main Window
    Comment    Make sure that there aren't any other "search panes open (eg on the home screen)
    Select from E-WorkBook Main Menu    File    Close All    # M
    Wait for glass pane to disappear
    Select from E-WorkBook Main Menu    Tools    Search
    Wait for glass pane to disappear
    Click On Component    xpath=//*[contains(@class,'DefaultQueryBuilderRowUI$ComboBoxLabel')]
    Set Test Variable    ${current_search_row}    0

Open Saved Search
    [Arguments]    ${path}
    Open Record Entity    ${path}    # Saved seraches open exactly the same way as record entities

Run Saved Search
    [Arguments]    ${path}
    Open Saved Search    ${path}
    Run search

Run Spreadsheet Search
    [Arguments]    ${search_name}=    ${search_timeout}=600    ${spreadsheet_timeout}=600
    scroll To Component    xpath=//*[contains(text(),'Run Search')]
    Push Button    text=Run Search
    Timer Start    run_spreadsheet_search_timer    ${search_name}
    Wait Until Keyword Succeeds    ${search_timeout}    0.2 seconds    Component Should Not Have Visible Flag    class=BusyGlassPane
    Select Window    regexp=.*Spreadsheet    ${spreadsheet_timeout}    1
    Timer Check Elapsed    run_spreadsheet_search_timer

Run quick search
    [Arguments]    ${query_value}    ${include_names}=${False}    ${include_item_text}=${False}    ${include_attributes}=${False}    ${match_within_words}=${False}
    Select from E-WorkBook Main Menu    Tools    Quick Search
    Select Dialog    Quick Search
    Uncheck All Checkboxes
    Run Keyword If    ${include_item_text}    Check Check Box    text=Names
    Run Keyword If    ${include_item_text}    Check Check Box    text=Item text
    Run Keyword If    ${include_attributes}    Check Check Box    text=Attributes
    Run Keyword If    ${match_within_words}    Check Check Box    text=Match within words
    ${initial_result_rows}=    Get List Item Count    class=QuickSearchResultsList
    Type Into Text Field    0    ${query_value}
    sleep    0.5s    Give search time to start
    Wait Until Keyword Succeeds    600 seconds    0.2 seconds    Component Should Not Have Visible Flag    xpath=//label[not(text())]    # The little wanger is a label without text
    ${final_result_rows}=    Get List Item Count    class=QuickSearchResultsList
    Run Keyword If    ${final_result_rows}==${initial_result_rows}    Fail    No results were returned by quick search
    Push Button    Cancel
    Select E-WorkBook Main Window

Run search
    scroll To Component    xpath=//*[contains(text(),'Run Search')]
    Push Button    text=Run Search
    Wait for glass pane to disappear

Save Search
    [Arguments]    ${path}    ${name}
    Push Button    Save Query As
    Select Dialog    Select location to save query
    ${path}    ${nodeproject}=    Split String    ${path}    /    1
    Run Keyword If    '${path}'=='My Work'    Expand Tree Node    class=com.idbs.ewb.entity.ui.navigator.NavigatorTree    ${path}
    Run Keyword If    '${path}'=='My Work'    Expand Tree Node    class=com.idbs.ewb.entity.ui.navigator.NavigatorTree    ${path}|${nodeproject}
    Click On Tree Node    class=com.idbs.ewb.entity.ui.navigator.NavigatorTree    ${path}|${nodeproject}
    Run Keyword If    '${path}'=='Root'    ${nodeproject}    ${nodetemplate}=    Split String    ${nodeproject}    /
    ...    1
    Run Keyword If    '${path}'=='Root'    Expand Tree Node    class=com.idbs.ewb.entity.ui.navigator.NavigatorTree    Root
    Run Keyword If    '${path}'=='Root'    Expand Tree Node    class=com.idbs.ewb.entity.ui.navigator.NavigatorTree    Root|${path}
    Run Keyword If    '${path}'=='Root'    Expand Tree Node    class=com.idbs.ewb.entity.ui.navigator.NavigatorTree    Root|${path}|${nodeproject}
    Run Keyword If    '${path}'=='Root'    Click On Tree Node    class=com.idbs.ewb.entity.ui.navigator.NavigatorTree    Root|${path}|${nodeproject}|${nodetemplate}
    sleep    2
    Push Button    OK
    Select Dialog    New Search    20
    Insert Into Text Field    name_editor    ${name}
    Push Button    OK
    Select E-WorkBook Main Window

Set results types to
    [Arguments]    @{result_types}
    Right Click On Tree Node At Coordinates    xpath=//*[contains(@class,'ExtTree')]    0    1    10    10
    Click On Component    xpath=//menuitem[text()='Uncheck All']
    Comment    Need to set focus back to main window
    Select E-WorkBook Main Window
    : FOR    ${result_type}    IN    @{result_types}
    \    Click On Component    xpath=//*[contains(@class,'MiniToolBars')]//*[contains(@class,'JTextField') and string-length(@name)=0]
    \    Wait Until Keyword Succeeds    60s    5s    Type Into Text Field    xpath=//*[contains(@class,'MiniToolBars')]//*[contains(@class,'JTextField') and string-length(@name)=0]    ${result_type}
    \    sleep    1
    \    Click On Tree Node At Coordinates    xpath=//*[contains(@class,'ExtTree')]    0    1    10    10

Setup Simple Query
    [Arguments]    ${entity}    ${attribute}    ${operator}    ${queryvalue}
    [Documentation]    Create a simple (one condition) query in the current search window.
    Push Button    ENTITY_TYPE_DROPDOWNButton${current_search_row}_0
    Click On Component    xpath=//*[@name='ENTITY_TYPE_DROPDOWNMenu${current_search_row}_0']//*[text()='${entity}']
    Sleep    0.5s
    Wait Until Keyword Succeeds    60s    3s    _Select From Attribute Dropdown    ${current_search_row}    ${attribute}
    Sleep    0.5s
    Push Button    OPERATOR_DROPDOWNButton${current_search_row}_0
    Click On Component    xpath=//menuitem[text()='${operator}']
    Sleep    0.5s
    Run Keyword If    "${operator}".upper()=="IS"    Insert Into Text Field    ENTITY_QUERY_BUILDER_ROW.valueLookup_${current_search_row}_0_textField    ${queryvalue}
    Run Keyword If    "${operator}".upper()=="CONTAINS"    Insert Into Text Field    EntityQueryBuilderRowUI.StringField_${current_search_row}_0    ${queryvalue}

_Select From Attribute Dropdown
    [Arguments]    ${current_search_row}    ${attribute}
    [Documentation]    Selects a value from the dropdown for the attribute editing field in the row.
    Push Button    ATTRIBUTE_DROPDOWNButton${current_search_row}_0
    Click On Component    xpath=//menuitem[text()='${attribute}']
