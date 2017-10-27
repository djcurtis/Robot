*** Settings ***
Library           IDBSSwingLibrary
Library           QuantrixLibrary
Library           IDBSCustomSwingComponentLibrary
Library           DynamicJavaLibrary
Resource          ../../../Libraries/IDBS Spreadsheet/common_spreadsheet_keywords.txt

*** Variables ***
${resultTypesTree}    NewEditSearchPanel.resultTypesTree    # Id of the Data to Retrieve checkbox list
${expectedResultTypeCount}    32    # The expected number of result types to appear in the Data to Retrieve panel
${searchFilterTextField}    NewEditSearchPanel.searchFilter    # Id of the search filter text field
${searchNameTextField}    NewEditSearchPanel.Name    # Id of the name text field
${addSearchButton}    SearchToolPane.Add.Button    # Id of the add search button
${searchListTable}    searchListTable    # Id of the search list
${addORlink}      AbstractQueryBuilder.addOrLinkLabel
${addANDlink}     AbstractQueryBuilder.addAndLinkLabel
${editPane_runSearchButton}    NewEditSearchPanel.run
${editPane_saveSearchButton}    NewEditSearchPanel.save
${newSearchButton}    xpath=//*[contains(@class,'AddButton')]
${backButton}     NewEditSearchPanel.cancel
${queryRow_deleteButton}    QueryBuilderUI.delete    # Requires the query row number as a suffix
${documentCriteriaCombo}    NewEditSearchPanel.documentCriteria
${operandTextfield}    OPERAND.TextField_
${operandNumberfield}    OPERAND.NumberField_
${operandDatefield}    OPERAND.DateField_
${entityTypeDropDownIdPrefix}    ENTITY_TYPE_DROPDOWN    # Prefix of Ids for the entity type dropdown menu combo box
${attributeDropDownIdPrefix}    ATTRIBUTE_DROPDOWN    # Prefix of Ids for the attribute menu combo box
${operatorDropDownIdPrefix}    OPERATOR_DROPDOWN    # Prefix of Ids for the operator drop down
${operandBooleanDropDown}    OPERAND.booleanComboBox_    # Prefix for boolean operand dropdown
${unitCatalogDropDown}    UNIT.catalogComboBox_
${operandListComponent}    OPERAND.fromValueField_
${readOnlyDateFrom}    OPERAND.DateFieldFromLabel
${readOnlyDateTo}    OPERAND.DateFieldToLabel
${operandDictFixDropDown}    OPERAND.dictionaryFixedComboBox_
${RESULTSFOLDER}    New Search    # The name of the folder returned for query results by default for a blank search name
${parameterButton}    expressionButton
${addCSQElink}    xpath=//*[text()='There are no search criteria. Click here to add a condition.']
${operandDictFixOneOfDropDown}    OPERAND.dictionaryFixedComboBox_single_

*** Keywords ***
New Search
    Wait Until Keyword Succeeds    2s    1s    Push New Search Button
    Add OR search condition    # Starts a new query
    : FOR    ${index}    IN RANGE    0    3
    \    ${added}    run keyword and return status    Component Should Be Visible    ${entityTypeDropDownIdPrefix}Button0
    \    run keyword if    ${added}    Exit For Loop
    Run Keyword Unless    ${added}    Fail    Failed to add 'OR' search condition.

Push New Search Button
    Push button    ${newSearchButton}
    Wait Until Keyword Succeeds    3s    0.5s    Component Is enabled    ${addORlink}

Ok Embeded Search
    Push Button    OK

Add AND search condition
    [Arguments]    ${rowNum}    # 0-based row index in the search criteria panel of the row in which the insert hyperlink appears
    Push Button    ${addANDlink}${rowNum}

Add OR search condition
    Push Button    ${addORlink}

Delete Query Row
    [Arguments]    ${rowNum}    # Row number in the search criteria list
    Push Button    ${queryRow_deleteButton}${rowNum}

Run Search
    [Arguments]    ${search_timeout}=60s
    Push Button    ${editPane_runSearchButton}
    # wait for the search to start
    sleep    2s
    # there may be a progress dialog - if so, wait until it goes...
    Wait Until Keyword Succeeds    ${search_timeout}    2s    IDBSSwingLibrary.Dialog Should Not Be Open    Running search...

Save Search
    Button Should Be Enabled    ${editPane_saveSearchButton}
    Push Button    ${editPane_saveSearchButton}

Cancel Search
    Push Button    ${backButton}
    sleep    500ms
    Wait Until Keyword Succeeds    10s    2s    IDBSSwingLibrary.Component Should Be Visible    ${newSearchButton}

Push Search Criteria Collapse Button
    [Documentation]    Expands/Collapses Search Criteria Panel
    Push Button    NewEditSearchPanel.SearchCriteria.Collapse_button

Push Data to Retrieve Collapse Button
    [Documentation]    Expands/Collapses Data to Retrieve Panel
    Push Button    NewEditSearchPanel.DataToRetrieve.Collapse_button

Select Entity in Data to Retrieve Tree
    [Arguments]    ${entity_selection}
    ${node_count}=    Get Tree Node Count    xpath=//*[contains(@Class,'AncestralEntityTree')]
    : FOR    ${node_index}    IN RANGE    ${node_count}
    \    ${node_label}    Get Tree Node Label    xpath=//*[contains(@Class,'AncestralEntityTree')]    ${node_index}
    \    Run Keyword If    "${node_label}"=="${entity_selection}"    Exit For Loop
    Click On Tree Node    xpath=//*[contains(@Class,'AncestralEntityTree')]    ${node_index}

Enter New Search Name
    [Arguments]    ${name}
    Click On Component    ${searchNameTextField}
    Run Keyword Unless    '${OPERATING_SYSTEM}'=='OSX'    Send Keyboard Event    VK_A    CTRL_MASK
    Run Keyword If    '${OPERATING_SYSTEM}'=='OSX'    Send Keyboard Event    VK_A    META_MASK
    Type To Component    ${searchNameTextField}    ${name}

Enter Filter
    [Arguments]    ${name}
    Clear Filter
    IDBSSwingLibrary.Scroll To Component    ${searchFilterTextField}
    Click On Component    ${searchFilterTextField}
    Run Keyword Unless    '${OPERATING_SYSTEM}'=='OSX'    Send Keyboard Event    VK_A    CTRL_MASK
    Run Keyword If    '${OPERATING_SYSTEM}'=='OSX'    Send Keyboard Event    VK_A    META_MASK
    Sleep    1s
    Type To Component    ${searchFilterTextField}    ${name}

Check Result Type
    [Arguments]    ${rowIndex}
    ${nodeCount}=    Get Tree Node Count    ${resultTypesTree}
    Click On Tree Node    ${resultTypesTree}    ${rowIndex}

Wait Until Populated
    [Documentation]    Wait until the search tool pane is populated, this typically doesn't take long
    Wait Until Keyword Succeeds    20s    1s    Data to Retrieve Is Populated

Data to Retrieve Is Populated
    ${nodeCount}=    Get Tree Node Count    ${resultTypesTree}
    Should Be Equal As Integers    ${nodeCount}    ${expectedResultTypeCount}

Is Result Type Checked
    [Arguments]    ${resultTypeName}
    [Documentation]    Returns true if the result type is checked.
    ...    Example:
    ...    ${isChecked}= \ \ \ Is Result Type Checked \ \ \ Experiment
    ${isChecked}=    DynamicJavaLibrary.Evaluate Component Expression    ${resultTypesTree}    $.getCheckedItemModel().isChecked("${resultTypeName}")
    [Return]    ${isChecked}    # true if the result is checked, false otherwise

Get Result Type At Row
    [Arguments]    ${row}    # The row index (0-based)
    ${nodeName}=    DynamicJavaLibrary.Evaluate Component Expression    ${resultTypesTree}    $.getPathForRow(${row}).getLastPathComponent().getEntityType().getDisplayName()
    [Return]    ${nodeName}    # The name of the result type

Get Result Type Count
    ${rowCount}=    Get Tree Node Count    ${resultTypesTree}
    [Return]    ${rowCount}    # The number of rows

Select Search Condition Row
    [Arguments]    ${rowNum}    # 0-based row number
    [Documentation]    Select the row in the Search Criteria panel
    ...    Preconditions:
    ...    The row must have been previously selected.
    ${status}    ${result=}    Run Keyword And Ignore Error    Component Should Be Visible    ENTITY_TYPE_LABEL${rowNum}
    Run Keyword If    '${status}' == 'PASS'    Click On Component    ENTITY_TYPE_LABEL${rowNum}    1

Select Search Condition Entity Type
    [Arguments]    ${rowNum}    ${entityType}    # The 0-based search criterion row and the descriptive name of the entity type
    Component Should Be Visible    ${entityTypeDropDownIdPrefix}Button${rowNum}
    Sleep    1s
    Click On Component    ${entityTypeDropDownIdPrefix}Button${rowNum}
    Sleep    1s
    # DynamicJavaLibrary.Set Context To Popup Menu Root
    Select From Active Popup Menu    ${entityType}
    #
    Wait Until Keyword Succeeds    10s    1s    Check Dropdown Selection    ${entityTypeDropDownIdPrefix}List${rowNum}    ${entityType}

Select Search Condition Attribute
    [Arguments]    ${rowNum}    ${attribute}
    Component Should Be Visible    ${attributeDropDownIdPrefix}Button${rowNum}
    Sleep    1s
    Click On Component    ${attributeDropDownIdPrefix}Button${rowNum}
    Sleep    1s
    Select From Active Popup Menu    ${attribute}
    #
    ${elements}=    String.Split String    ${attribute}    /
    Wait Until Keyword Succeeds    10s    1s    Check Dropdown Selection    ${attributeDropDownIdPrefix}List${rowNum}    ${elements[-1]}

Select Search Condition Operator
    [Arguments]    ${rowNum}    ${operator}
    Component Should Be Visible    ${operatorDropDownIdPrefix}Button${rowNum}
    Sleep    1s
    Click On Component    ${operatorDropDownIdPrefix}Button${rowNum}
    Sleep    1s
    Select From Active Popup Menu    ${operator}
    #
    Wait Until Keyword Succeeds    10s    1s    Check Dropdown Selection    ${operatorDropDownIdPrefix}List${rowNum}    ${operator}

Enter Search Condition Text Operand
    [Arguments]    ${rowNum}    ${text}
    Component Should Be Visible    ${operandTextfield}${rowNum}
    Sleep    1s
    Click On Component    ${operandTextfield}${rowNum}    1
    Sleep    1s
    Type Into Text Field    ${operandTextfield}${rowNum}    ${text}

Enter Search Condition Row
    [Arguments]    ${rowNum}    ${entityType}    ${attribute}    ${operator}
    Select Search Condition Entity Type    ${rowNum}    ${entityType}
    Select Search Condition Attribute    ${rowNum}    ${attribute}
    Select Search Condition Operator    ${rowNum}    ${operator}

Open Search Toolpane
    [Documentation]    Selects the menu option Data > E-Workbook Search to open the Search ToolPane
    Component Should Not Exist    ${addSearchButton}    2
    : FOR    ${i}    IN RANGE    5
    \    ${selected}=    Run Keyword and Return Status    Select From Designer Menu    Data|E-WorkBook Search
    \    ${opened}=    Run Keyword and Return Status    Wait Until Component Is Visible    ${addSearchButton}    3
    \    Return From Keyword If    ${opened}
    Run Keyword Unless    ${opened}    Fail    Search toolpane was not opened after 5 attempts.

Close Search Toolpane
    [Documentation]    Selects the menu option Data > E-Workbook Search to close the Search ToolPane
    Component Should Be Visible    ${addSearchButton}
    Select From Designer Menu    Data|E-WorkBook Search
    Sleep    1s
    Component Should Not Exist    ${addSearchButton}    5

Clear Filter
    IDBSSwingLibrary.Scroll To Component    ${searchFilterTextField}
    Clear Text Field    ${searchFilterTextField}

Enter Search Condition Dictionary Fixed Operand
    [Arguments]    ${rowNum}    ${operand}
    Component Should Be Visible    ${operandDictFixDropDown}${rowNum}
    Sleep    1s
    Select From Combo Box    ${operandDictFixDropDown}${rowNum}    ${operand}

Enter Search Condition Boolean Operand
    [Arguments]    ${rowNum}    ${operand}
    Component Should Be Visible    ${operandBooleanDropDown}${rowNum}
    Sleep    1s
    Select From Combo Box    ${operandBooleanDropDown}${rowNum}    ${operand}

Run Search From List
    [Arguments]    ${rowNum}
    Component Should Be Visible    ${searchListTable}
    Select Table Cell    ${searchListTable}    ${rowNum}    0
    Component Should Be Visible    runSearchButton
    Push Button    runSearchButton

Edit Search From List
    [Arguments]    ${rowNum}
    Component Should Be Visible    ${searchListTable}
    Select Table Cell    ${searchListTable}    ${rowNum}    0
    Component Should Be Visible    editSearchButton
    Push Button    editSearchButton

Delete Search From List
    [Arguments]    ${rowNum}
    Component Should Be Visible    ${searchListTable}
    Select Table Cell    ${searchListTable}    ${rowNum}    0
    Component Should Be Visible    deleteSearchButton
    Push Button    deleteSearchButton

Get Search Name From List
    [Arguments]    ${rowNum}
    Component Should Be Visible    ${searchListTable}
    Select Table Cell    ${searchListTable}    ${rowNum}    0
    ${searchName}    Get Table Cell Value    ${searchListTable}    ${rowNum}    0
    [Return]    ${searchName}

Saved Search List is Empty
    [Documentation]    Checks that in the Saved Search List there is a message stating when no searches are saved
    ${emptySearchList}=    EvaluateComponentFunction    ${searchListTable}    model=$.getModel();return model.getRowCount();
    Should Be Equal As Numbers    ${emptySearchList}    0    Empty message is not showing

Get Menu Combo Box Selection
    [Arguments]    ${comboListId}
    ${selection}=    Evaluate Component Expression    ${comboListId}    $.getModel().size() == 0 ? null : $.getModel().getElementAt(0).caption()
    [Return]    ${selection}

Get Selected Search Condition Entity Type
    [Arguments]    ${rowNum}
    Select Search Condition Row    ${rowNum}
    ${selection}=    Evaluate Component Expression    ${entityTypeDropDownIdPrefix}List${rowNum}    $.getModel().size() == 0 ? null : $.getModel().getElementAt(0).caption()
    [Return]    ${selection}

Get Selected Search Condition Attribute
    [Arguments]    ${rowNum}
    Select Search Condition Row    ${rowNum}
    ${selection}=    Evaluate Component Expression    ${attributeDropDownIdPrefix}List${rowNum}    $.getModel().size() == 0 ? null : $.getModel().getElementAt(0).caption()
    [Return]    ${selection}

Get Selected Search Condition Operator
    [Arguments]    ${rowNum}
    Select Search Condition Row    ${rowNum}
    ${selection}=    Evaluate Component Expression    ${operatorDropDownIdPrefix}List${rowNum}    $.getModel().size() == 0 ? null : $.getModel().getElementAt(0).operator().getName()
    [Return]    ${selection}

Get All Result Types
    ${resultTypes}=    Evaluate Component Expression    ${resultTypesTree}    (function(){model = $.getModel(); root = model.getRoot(); result=[]; for (var i = 0; i < model.getChildCount(root); ++i) { result.push(model.getChild(root, i).getDisplayName()); } return result;})();
    [Return]    ${resultTypes}

Get All Entity Types
    [Arguments]    ${rowNum}
    ${entityTypes}=    Get All Menu Combo Box Items    ${entityTypeDropDownIdPrefix}List${rowNum}
    [Return]    ${entityTypes}

Get All Attributes
    [Arguments]    ${rowNum}
    ${attributes}=    Get All Menu Combo Box Items    ${attributeDropDownIdPrefix}List${rowNum}
    [Return]    ${attributes}

Get All Operators
    [Arguments]    ${rowNum}
    ${operators}=    Get All Menu Combo Box Items    ${operatorDropDownIdPrefix}List${rowNum}
    [Return]    ${operators}

Select term from catalog
    [Arguments]    ${ANDquery_row}    ${ORquery_row}    @{path as element names}
    [Documentation]    ${ANDquery_row} = Query row separator number from 0, between AND blocks
    ...
    ...    ${ORquery_row} = Second query row separator from 0, between OR statements within AND blocks
    Wait Until Keyword Succeeds    15s    3s    Button Should Be Enabled    termLookup${ANDquery_row}_${ORqueryrow}_button
    Push Button    termLookup${ANDquery_row}_${ORqueryrow}_button
    Select Dialog    Select a term
    IDBSSwingLibrary.Get Tree Node Count    termTree
    ${path}=    set variable    ${EMPTY}
    # loop throug the path elements - selecting each one in turn. \ if they are not not valid (i.e. do not enable the OK button) then expand their children & keep looping.
    : FOR    ${entity}    IN    @{path as element names}
    \    ${path}=    Set Variable If    '${path}' == '${EMPTY}'    ${entity}    ${path}|${entity}
    \    log    path to set: ${path}
    \    Select Node from Tree    termTree    ${path}
    \    ${enabled}=    Wait Until Keyword Succeeds    10s    1s    IDBSSwingLibrary.Component Is Enabled    OK_BUTTON
    \    run keyword if    ${enabled}    Exit For Loop
    \    IDBSSwingLibrary.Expand Tree Node    termTree    ${path}
    \    Wait Until Keyword Succeeds    10s    0.3s    IDBSSwingLibrary.Tree Node Should Be Expanded    termTree    ${path}
    \    # wait until the child elements have been returned as well    # because the tree can report as expanded before the children are populated
    \    Wait Until Keyword Succeeds    10s    1s    _verify tree node has children    termTree    ${path}
    IDBSSwingLibrary.Push Button    OK_BUTTON
    common_spreadsheet_keywords.Select Spreadsheet Window

Add Text Item to Search List
    [Arguments]    ${rowNo}    ${Text}
    [Documentation]    Adds a text item to a string list in the search UI
    Component Should Be Visible    ${operandTextfield}single_${rowNo}    # Text field
    Sleep    0.5s
    Click On Component    ${operandTextfield}single_${rowNo}
    Run Keyword Unless    '${OPERATING_SYSTEM}'=='OSX'    Send Keyboard Event    VK_A    CTRL_MASK
    Run Keyword If    '${OPERATING_SYSTEM}'=='OSX'    Send Keyboard Event    VK_A    META_MASK
    Sleep    0.5s
    Type Into Text Field    ${operandTextfield}single_${rowNo}    ${Text}
    Push Button    Add    # Add

Enter Catalog Sub Query Unit Operand
    [Arguments]    ${ANDquery_row}    ${ORquery_row}    ${operand}
    [Documentation]    ${ANDquery_row} = Query row separator number from 0, between AND blocks
    ...
    ...    ${ORquery_row} = Second query row separator from 0, between OR statements within AND blocks
    ...
    ...
    ...    Selects from UNIT drop down
    Component Should Be Visible    ${unitCatalogDropDown}${ANDquery_row}_${ORquery_row}
    Sleep    1s
    Select From Combo Box    ${unitCatalogDropDown}${ANDquery_row}_${ORquery_row}    ${operand}

Select Search Catalog Property
    [Arguments]    ${ANDquery_row}    ${ORquery_row}    ${attribute}
    [Documentation]    ${ANDquery_row} = Query row separator number from 0, between AND blocks
    ...
    ...    ${ORquery_row} = Second query row separator from 0, between OR statements within AND blocks
    ...
    ...
    ...    Selects from the property drop down
    ...
    ...    Requires a valid Catalog Term to have been selected
    Component Should Be Visible    ${attributeDropDownIdPrefix}List${ANDquery_row}_${ORquery_row}
    Sleep    1s
    Click On Component    ${attributeDropDownIdPrefix}List${ANDquery_row}_${ORquery_row}
    Sleep    1s
    Select From Active Popup Menu    ${attribute}
    #
    Wait Until Keyword Succeeds    10s    1s    Check Dropdown Selection    ${attributeDropDownIdPrefix}List${ANDquery_row}_${ORquery_row}    ${attribute}

Select Search Catalog Operator
    [Arguments]    ${ANDquery_row}    ${ORquery_row}    ${operator}
    [Documentation]    ${ANDquery_row} = Query row separator number from 0, between AND blocks
    ...
    ...    ${ORquery_row} = Second query row separator from 0, between OR statements within AND blocks
    ...
    ...
    ...    Selects from the operator drop down
    ...
    ...    Requires a valid Catalog Term and Property to have been selected
    Wait Until Component Is Visible    ${operatorDropDownIdPrefix}List${ANDquery_row}_${ORquery_row}
    Sleep    1s
    Click On Component    ${operatorDropDownIdPrefix}List${ANDquery_row}_${ORquery_row}
    Sleep    1s
    Select From Active Popup Menu    ${operator}
    #
    Wait Until Keyword Succeeds    10s    1s    Check Dropdown Selection    ${operatorDropDownIdPrefix}List${ANDquery_row}_${ORquery_row}    ${operator}

Get All Catalog Operators
    [Arguments]    ${ANDquery_row}    ${ORquery_row}
    [Documentation]    Gets all the operators for a catalogue \ sub query row
    ...
    ...    ${ANDquery_row} = Query row separator number from 0, between AND blocks
    ...
    ...    ${ORquery_row} = Second query row separator from 0, between OR statements within AND blocks
    ${operators}=    Get All Menu Combo Box Items    ${operatorDropDownIdPrefix}List${ANDquery_row}_${ORquery_row}
    [Return]    ${operators}

Enter Search Catalog Number Operand
    [Arguments]    ${ANDquery_row}    ${ORquery_row}    ${number}
    [Documentation]    Enters a number into a number input field, when creating a catalog sub query
    ...
    ...    ${ANDquery_row} = Query row separator number from 0, between AND blocks
    ...
    ...    ${ORquery_row} = Second query row separator from 0, between OR statements within AND blocks
    Component Should Be Visible    ${operandNumberfield}${ANDquery_row}_${ORquery_row}
    Sleep    1s
    Click On Component    ${operandNumberfield}${ANDquery_row}_${ORquery_row}    1
    Sleep    1s
    Type Into Text Field    ${operandNumberfield}${ANDquery_row}_${ORquery_row}    ${number}

Check Result Type By Name
    [Arguments]    ${entity_type_display_name}
    [Documentation]    Checks the requested entity result type in the result type tree
    ...
    ...    *Arguments*
    ...
    ...    _entity_type_display_name_ - the display name for the entity result type
    ...
    ...    *Example*
    ...
    ...    | Check result Type By Name | Experiment
    ${index}=    get tree node index    ${resultTypesTree}    ${entity_type_display_name}
    ${status}=    Is Result Type Checked    ${entity_type_display_name}
    Run Keyword If    '${status}'=='False'    Click On Tree Node    ${resultTypesTree}    ${index}

Wait For Transform
    [Arguments]    ${spreadsheet_id}    ${timeout}=20
    [Documentation]    Checks to see if the Transform has finished SUCCESSFULLY for a spreadsheet document
    ...
    ...    *Arguments*
    ...
    ...    _spreadsheet_id_ : The ID of the spreadsheet document
    ...
    ...    _timeout_ : The time duration, in 2 seconds, to check the transform status for
    : FOR    ${element}    IN RANGE    ${timeout}
    \    Sleep    5s
    \    ${transform_status}=    _Get Transform Status    ${spreadsheet_id}
    \    Exit For Loop If    '${transform_status}'=='AVAILABLE'
    \    Exit For Loop If    '${transform_status}'=='FAILED'
    log    ${transform_status}
    Run Keyword If    '${transform_status}'!='AVAILABLE'    _Get Transform Comment    ${spreadsheet_id}
    Run Keyword If    '${transform_status}'!='AVAILABLE'    Fail    The Transform is not available

Wait For Transform Failure
    [Arguments]    ${spreadsheet_id}    ${timeout}=20
    [Documentation]    Checks to see if the Transform has finished as a FAILURE for a spreadsheet document
    ...
    ...    *Arguments*
    ...
    ...    _spreadsheet_id_ : The ID of the spreadsheet document
    ...
    ...    _timeout_ : The time duration, in 2 seconds, to check the transform status for
    : FOR    ${element}    IN RANGE    ${timeout}
    \    Sleep    2s
    \    ${FAILED}=    _Check Transform Failure    ${spreadsheet_id}
    \    Run Keyword If    '${FAILED}'=='1'    Exit For Loop
    ${transform_status}=    _Get Transform Status    ${spreadsheet_id}
    log    ${transform_status}
    Run Keyword If    '${transform_status}'!='FAILED'    Fail    The Transform is not Failed

_Check Transform Available
    [Arguments]    ${spreadsheet_id}
    [Documentation]    Given the Spreadsheet ID, this keyword connects to the database, and will return true(1) if the transform status equals AVAILABLE
    ...
    ...    Specific to *Spreadsheet Mart Transforms* not spreadsheet generic transforms
    # Transform Status from Database
    Connect To Database    ${POOL_USERNAME}    ${POOL_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    ${queryResults}=    Query    select count(*) from ENTITY_VERSION_TRANS_DATA evtd, ENTITY_VERSIONS ev where evtd.trans_data_status_id = 'AVAILABLE' and evtd.transformation_type = 'idbs:spreadsheet_mart' and evtd.entity_version_id = ev.entity_version_id and ev.entity_id = '${spreadsheet_id}'    # Checks whether transform status equals Available is True(1) or False(0)
    ${transform_available}=    Set Variable    ${queryResults[0][0]}
    log    ${transform_available}
    Disconnect From Database
    [Return]    ${transform_available}

_Check Transform Failure
    [Arguments]    ${spreadsheet_id}
    [Documentation]    Given the Spreadsheet ID, this keyword connects to the database, and will return true(1) if the transform status equals FAILED
    ...
    ...    Specific to *Spreadsheet Mart Transforms* not spreadsheet generic transforms
    # Transform Status from Database
    Connect To Database    ${POOL_USERNAME}    ${POOL_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    ${queryResults}=    Query    select count(*) from ENTITY_VERSION_TRANS_DATA evtd, ENTITY_VERSIONS ev where evtd.trans_data_status_id = 'FAILED' and evtd.transformation_type = 'idbs:spreadsheet_mart' and evtd.entity_version_id = ev.entity_version_id and ev.entity_id = '${spreadsheet_id}'    # Checks whether transform status equals FAILED is True(1) or False(0)
    ${transform_failed} =    Set Variable    ${queryResults[0][0]}
    log    ${transform_failed}
    Disconnect From Database
    [Return]    ${transform_failed}

_Get Transform Status
    [Arguments]    ${spreadsheet_id}
    [Documentation]    Given the Spreadsheet ID, this keyword connects to the database, and returns the transform status
    ...
    ...    Specific to *Spreadsheet Mart Transforms* not spreadsheet generic transforms
    # Transform Status from Database
    Connect To Database    ${POOL_USERNAME}    ${POOL_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    ${queryResults}=    Query    select evtd.trans_data_status_id from ENTITY_VERSION_TRANS_DATA evtd, ENTITY_VERSIONS ev where evtd.transformation_type = 'idbs:spreadsheet_mart' and evtd.entity_version_id = ev.entity_version_id and ev.entity_id = '${spreadsheet_id}' order by evtd.TIME_STAMP DESC
    ${transform_status}=    Set Variable    ${queryResults[0][0]}    # If failing here check you have version saved entity
    log    ${transform_status}
    Disconnect From Database
    [Return]    ${transform_status}

Add Range to Search Parameters Dialogue
    [Arguments]    ${range}
    [Documentation]    - Keyword adds range and clicks the OK button, reselecting the Spreadsheet window after
    ...    - Ensure the dialogue is open _before_ trying to add the range \ by clicking the correct parameter button
    ...
    ...    *Arguments*
    ...
    ...    _range_ :the range given as a standard quantrix range
    ...
    ...    *Example*
    ...
    ...    | Push Button | ${parameterButton}0_0 |
    ...    | Add Range to Search Parameters Dialogue | Table1::Data1 |
    Select Dialog    Select a spreadsheet cell or range
    Click On Component    ExpressionChooserDialog.expressionWidget
    Run Keyword Unless    '${OPERATING_SYSTEM}'=='OSX'    Send Keyboard Event    VK_A    CTRL_MASK
    Run Keyword If    '${OPERATING_SYSTEM}'=='OSX'    Send Keyboard Event    VK_A    META_MASK
    Type To Component    ExpressionChooserDialog.expressionWidget    ${range}
    Push Button    OK_BUTTON
    Select Spreadsheet Window

Dismiss Error Banner If Present
    Run Keyword And Ignore Error    Dismiss Error Banner

Check Error Banner Absent
    Run Keyword And Expect Error    *    Dismiss Error Banner

Check Error Banner Present And Dismiss
    Dismiss Error Banner

Dismiss Error Banner
    [Arguments]    ${timeout}=10
    ${original_timeout}=    Set Jemmy Timeout    ComponentOperator.WaitComponentEnabledTimeout    ${timeout}
    Push Button    xpath=//*[@class="com.quantrix.ui.internal.problems.CloseButton"]
    Set Jemmy Timeout    ComponentOperator.WaitComponentEnabledTimeout    ${original_timeout}

_verify tree node has children
    [Arguments]    ${tree_component_name}    ${tree_node_path}
    [Documentation]    used to verify that a given tree node has children
    ${child_names}=    IDBSSwingLibrary.Get Tree Node Child Names    ${tree_component_name}    ${tree_node_path}
    ${number_of_children}=    Get Length    ${child_names}
    Should Be True    ${number_of_children} > 0

Find Search In List
    [Arguments]    ${searchName}
    [Documentation]    Find the embedded search with the specified name
    ...
    ...    Precondition: The search list is open
    ...
    ...    returns the index of the search in the list or -1 if not found.
    ${rowIndex}=    EvaluateComponentFunction    ${searchListTable}    model=$.getModel(); for (i = 0; i < model.getRowCount(); ++i) { search=model.getValueAt(i,0); if (search.getTitle().equals("${searchName}")) return $.convertRowIndexToView(i); } return -1;
    [Return]    ${rowIndex}

Delete All Searches In List
    [Documentation]    Delete all searches in the list
    ...
    ...    Precondition: The search list is open
    ...
    ...    Postcondition: The serach list is empty
    ...
    ...    returns the index of the search in the list or -1 if not found.
    ${numSearches}=    Evaluate Component Function    ${searchListTable}    return $.getRowCount();
    : FOR    ${i}    IN RANGE    ${numSearches}
    \    Delete Search From List    0
    Wait Until Keyword Succeeds    10s    2s    Saved Search List is Empty

Maximise Search Toolpane
    [Documentation]    *Description*
    ...
    ...    This keyword expands the search toolpane across the width of the Spreadsheet Designer, by double clicking the Header tab of the toolpane.
    ...
    ...    *Arguments*
    ...
    ...    None
    ...
    ...    *Note:* Works in the *Spreadsheet Designer*
    Wait Until Keyword Succeeds    10s    2s    Click On Component    xpath=//*[@class='net.infonode.tabbedpanel.titledtab.TitledTab$2']    2    # Expands Pane

Add Catalog Sub Query Editor conditions
    [Documentation]    Pushes the link within the search toolpane that allows you to add catalogue details to a particular query
    ...
    ...    Note: *Spreadsheet Designer* keyword
    Wait Until Keyword Succeeds    3s    0.5s    Component Is enabled    ${addCSQElink}
    Push Button    ${addCSQElink}

Check Dropdown Selection
    [Arguments]    ${identifier}    ${value}
    [Documentation]    Checks the Spreadsheet Search Dropdown has the selected element
    ${selected_item}=    Get Selected Value From List    ${identifier}
    Should Be Equal    ${selected_item}    ${value}

_Get Transform Comment
    [Arguments]    ${spreadsheet_id}
    [Documentation]    Given the Spreadsheet ID, this keyword connects to the database, and returns the transform status
    ...
    ...    Specific to *Spreadsheet Mart Transforms* not spreadsheet generic transforms
    # Transform Status from Database
    Connect To Database    ${POOL_USERNAME}    ${POOL_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    ${queryResults}=    Query    select evtd.ERROR_COMMENT \ from ENTITY_VERSION_TRANS_DATA evtd, ENTITY_VERSIONS ev where evtd.transformation_type = 'idbs:spreadsheet_mart' and evtd.entity_version_id = ev.entity_version_id and ev.entity_id = '${spreadsheet_id}' order by evtd.TIME_STAMP DESC
    ${transform_comment}=    Set Variable    ${queryResults[0][0]}    # If failing here check you have version saved entity
    log    ${transform_comment}
    Disconnect From Database
    [Return]    ${transform_comment}
