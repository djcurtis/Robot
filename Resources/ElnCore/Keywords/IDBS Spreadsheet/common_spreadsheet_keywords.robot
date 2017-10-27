*** Settings ***
Documentation     Resource for keywords primarily used for automating the Spreadsheet Designer
Library           RobotRemoteAgent
Library           IDBSSwingLibrary
Library           QuantrixLibrary
Resource          ../Selenium/general_resource.robot
Library           IDBSSelenium2Library
Library           Collections
Library           SystemUtilitiesLibrary
Library           DynamicJavaLibrary
Library           IDBSCustomSwingComponentLibrary
Library           DateTime
Library           String
Library           CheckLibrary
Library           OperatingSystem
Resource          ../Selenium/hierarchy_resource.robot
Resource          ../Selenium/record_resource.robot
Library           EntityAPILibrary
Resource          ../Common/general setup tools.robot

*** Variables ***
${weblaunch_alias}    ssEditor
${data_dim}       Data
${spreadsheet_designer_dialog_title}    Spreadsheet Designer    # The default name for dialogs such as JOptionPane that are created in the spreadsheet designer app
${spreadsheet_designer_frame_title_regex}    regexp=.*Spreadsheet Designer    # a regex shortcut to identify the main spreadsheet designer window
${spreadsheet_designer_frame_title_suffix}    Spreadsheet Designer    # this is used in conjunction with a file name prefix, for example "data entry.ewbss" + ${spreadsheet_designer_frame_title_suffix}
${DATA_ENTRY_SPREADSHEET_REGEX}    regexp=(?!Untitled.*).* - .*    # handy utility to match a data entry item type spreadsheet
${RESULTS_SUMMARY_SPREADSHEET_REGEX}    regexp=(?!Untitled.*).* - .*    # handy utility to match a results summary item type spreadsheet
${OTHER_SPREADSHEET_REGEX}    regexp=(?!Untitled.*).* - .*    # handy utility to match an Other item type spreadsheet (as created when calling EntityAPILibrary.Insert IDBS Spreadsheet Document)
${PREVIEW_DIALOG}    regxp=.*Generating Previews.*
${MODELER_ROLE}    Modeler
${USER_ROLE}      User
${VIEWER_ROLE}    Viewer
${exception_dialog_id}    An Error Has Occurred
${close_window_button}    xpath=//*[contains(@class,'SubxComponent')]    # The 'X' button in the top right of a quantrix dialog or window.
${SPREADSHEET_DESIGNER_OPEN}    ${False}    # Boolean

*** Keywords ***
Initialise Spreadsheet and select window
    [Arguments]    ${file_name}=${EMPTY}    # the name of the file opened in the spreadsheet window
    [Documentation]    Initialises the spreadsheet (Designer as per current branding) by loading the relevant libraries and activates the window
    ...
    ...    *Arguments*
    ...
    ...    _file_name_ \ (Optional) the name of the spreadsheet file opened. This is a combination of "itemtype - experimentname.ewbss". Leaving this blank will cause a regex to be used that selects _any_ window whose title ends in spreadsheet designer
    Wait Until Keyword Succeeds    60s    5s    IDBSSwingLibrary.Load Library Into Remote Application
    Run Keyword If    '${OPERATING_SYSTEM}'=='OSX'    Sleep    30s    #OSX is slow to load the spreadsheet designer
    Wait Until Keyword Succeeds    60s    5s    QuantrixLibrary.Load Library Into Remote Application
    IDBSCustomSwingComponentLibrary.Load Library Into Remote Application
    DynamicJavaLibrary.Load Library Into Remote Application
    common_spreadsheet_keywords.Select Spreadsheet Window    ${file_name}

Select Spreadsheet Window
    [Arguments]    ${file_name}=${EMPTY}    # the name of the file opened in the spreadsheet window.
    [Documentation]    Selects the IDBS Spreadsheet main window.
    ...
    ...    *Arguments*
    ...
    ...    _file_name_ \ (Optional) the name of the spreadsheet file opened. \ This is typically the experiment item caption. \ If inserted via the "insert item menu" (i.e. the caption is blank) then ${uncaptioned_spreadsheet_filename} should be used. \ Leaving this blank will cause a regex to be used that selects _any_ window whose title ends in spreadsheet designer
    ${window_title}=    Set Variable If    '${file_name}'== '${EMPTY}'    ${spreadsheet_designer_frame_title_regex}    ${file_name} - ${spreadsheet_designer_frame_title_suffix}
    Enable Taking Screenshots On Failure
    ${status}    ${msg}=    run keyword and ignore error    IDBSSwingLibrary.Activate Window    ${window_title}    180
    run keyword if    '${status}' == 'FAIL'    Capture Designer Screenshot and Fail    Unable to select spreadsheet window

Select From Designer Menu
    [Arguments]    ${menu_string}
    [Documentation]    *Selects menu items from the Spreadsheet Designer menu bar*
    ...
    ...    - on Windows - uses the SwingLibrary to interact with the menu bar
    ...    - on OSX - uses AppleScript to interact with the menu bar
    ...
    ...    *Note: Uses the ${OPERATING_SYSTEM} variable to determine WINDOWS or OSX*
    ...
    ...    *Arguments*
    ...    - _menu_string_ - the menu string, pipe seperated in the same format as "Select From Menu" (e.g. "File|Save As...")
    ...
    ...    *Return Value*
    ...
    ...    _None_
    ...
    ...    *Preconditions*
    ...
    ...    The spreadsheet designer should be loaded before calling this keyword
    ...
    ...    *Example*
    ...    | Select From Designer Menu | _File|Save As..._ |
    # basically, the keyword doesn't _always_ work - the menu items don't activate    # so let's try again, just in case.
    ${status}    ${msg}=    Run Keyword And Ignore Error    _Internal Select From Designer Menu    ${menu_string}
    run keyword if    '${status}' == 'FAIL'    _Internal Select From Designer Menu    ${menu_string}

Show Model Browser
    [Documentation]    Ensures that the Model Browser is visible, and gives it the focus.
    ...
    ...    *Preconditions"
    ...    spreadsheet loaded and has focus
    ${model_browser_exists}    ${model_browser_exists_message}=    Run Keyword And Ignore Error    Component Should Have Visible Flag    BrowserTree
    Run Keyword If    '${model_browser_exists}'=='FAIL'    Push Button    ModelBrowserPulldownButton

Select Sheet in Model Browser
    [Arguments]    ${sheet_name}    ${clickCount}=2    ${sheet_type}=MATRIX
    [Documentation]    selects the specified sheet in the model browser
    ...
    ...    *Arguments*
    ...
    ...    _sheet_name_ the name of the sheet to select
    ...
    ...    _clickCount_ the number of clicks to perform \ 1 to select, 2 to "open" (default:2 _for legacy reasons))
    Show Model Browser
    ${node_count}=    Get Tree Node Count    BrowserTree
    : FOR    ${node_index}    IN RANGE    ${node_count}
    \    ${node_label}    Get Tree Node Label    BrowserTree    ${node_index}
    \    Run Keyword If    "${node_label}"=="${sheet_name}"    Exit For Loop
    Run Keyword Unless    "${node_label}"=="${sheet_name}"    Capture Designer Screenshot and Fail    Could not find sheet ${sheet_name} in model browser.
    # we know the sheet exists & we have the right tree node    # so click it
    ${result}    ${msg}=    Run Keyword And Ignore Error    _internal open sheet from model browser    ${node_index}    ${clickCount}    ${sheet_name}
    ...    ${sheet_type}
    # some times the automation system doesn't actually click the tree node (but doesn't complain).    # so if the keyword fails then we just try again (once)    # just in case
    run keyword if    '${result}' == 'FAIL'    _internal open sheet from model browser    ${node_index}    ${clickCount}    ${sheet_name}    ${sheet_type}

Open Sheet from Model Browser
    [Arguments]    ${sheet_name}
    [Documentation]    Opens the Model Browser if not already open, and double-clicks the node for the specified sheet.
    Select Sheet in Model Browser    ${sheet_name}
    Ensure Sheet Is Open    ${sheet_name}

Close All Sheets
    [Documentation]    Closes all open views in the spreadsheet designer
    Select From Designer Menu    View|Close All Views*
    Sleep    2s

Ensure Sheet Is Open
    [Arguments]    ${sheet_name}
    [Documentation]    Verifies the sheet name is present
    Component Should Have Visible Flag    xpath=//*[@name='${sheet_name}']

Ensure Sheet Is Closed
    [Arguments]    ${sheet_name}
    [Documentation]    Verifies the sheet name is not open
    Component Should Not Exist    xpath=//*[@name='${sheet_name}']

New Matrix
    [Arguments]    ${sheet_name}=${EMPTY}
    [Documentation]    Creates a new matrix with the specified name. *NOTE: this is a designer keyword*
    ...
    ...    *Arguments*
    ...
    ...    _sheet_name_ \ default: empty. specify a name if you want your matrix named something specific. \ Leave it blank to use the system generated name.
    ...
    ...
    ...    *Returns*
    ...
    ...    the actual name of the created sheet.
    ${result}    ${sheet_name_1}=    Run Keyword And Ignore Error    _internal new matrix    ${sheet_name}
    # some times the automation system doesn't actually click the button (but doesn't complain).    # so if the keyword fails then we just try again (once)    # just in case
    ${sheet_name_2}=    run keyword if    '${result}' == 'FAIL'    _internal new matrix    ${sheet_name}
    ${actual_sheet_name}=    Set Variable If    '${result}' != 'FAIL'    ${sheet_name_1}    ${sheet_name_2}
    [Return]    ${actual_sheet_name}    # returns the sheet name actually used

Delete Sheet
    [Arguments]    ${sheet_name}
    [Documentation]    deletes the specified sheet from the model
    ...
    ...    *Arguments*
    ...
    ...    _sheet_name_ the sheet to delete
    Select Sheet in Model Browser    ${sheet_name}    1    ${EMPTY}
    # select model browser by clicking, otherwise delete key goes to wrong component
    Click On Component    model-browser
    sleep    500ms
    Send Keyboard Event    VK_DELETE

Select Category
    [Arguments]    ${sheet_name}    ${category_name}
    [Documentation]    selects the specified category on the specified sheet. \ This will open the sheet from the model browser first
    ...
    ...
    ...    *Arguments*
    ...
    ...    _sheet_name_ the sheet that contains the category
    ...
    ...    _category_name_ the category to select
    Open Sheet from Model Browser    ${sheet_name}
    ${old_timeout}=    Set Jemmy Timeout    ComponentOperator.WaitComponentTimeout    1
    Click On Component    xpath=//*[@name='${sheet_name}']//*[@name='CategoryTile${category_name}']
    Set Jemmy Timeout    ComponentOperator.WaitComponentTimeout    ${old_timeout}

Navigate From Column Tray To Row Tray
    [Documentation]    Assuming that the current selection is a category tile in the column tray, selects the first category tile in the row tray for the same matrix.
    Send Keyboard Event    VK_TAB
    Send Keyboard Event    VK_RIGHT

Rename Variable Node With Type-ahead
    [Arguments]    ${sheet_name}    ${node_name}
    [Documentation]    Renames the currently selected node, using type-ahead.
    ...
    ...    This assumes that the node has a type-ahead editor, so is only applicable to variable nodes: data category items and non-data categories.
    # send a key press event to initiate editing.
    Send Multiple Keyboard Events    VK_A
    # wait for the editor to appear before continuing
    Wait Until Keyword Succeeds    5s    1s    IDBSSwingLibrary.Component Should Exist    xpath=//*[@name='${sheet_name}']//*[contains(@class,'TypeAheadEditor')]
    Send Keyboard Event    VK_BACK_SPACE
    Type Into Text Field    xpath=//*[@name='${sheet_name}']//*[contains(@class,'TypeAheadEditor')]    ${node_name}
    # Wait for type-ahead suggestions to appear.    # TODO I guess we should wait for the existance of the dropdown before sending the VK_ENTER    # but we can't do that with current libraries, so we add a nastly sleep
    Sleep    3s
    # Select the first suggestion.
    Accept Current Suggestion from Type Ahead Editor    ${sheet_name}

Rename Variable Node
    [Arguments]    ${sheet_name}    ${node_name}
    [Documentation]    Renames the currently selected node, without using type-ahead.
    ...
    ...    This assumes that the node has a type-ahead editor (although type-ahead won't be activated), so is only applicable to variable nodes: data category items and non-data categories.
    # F2 doesn't engage type-ahead in category items. We don't need type-ahead per se, but we need to know what type of editor control to look for in the xpath.
    Send Keyboard Event    VK_A
    Send Keyboard Event    VK_BACK_SPACE
    Type Into Text Field    xpath=//*[@name='${sheet_name}']//*[contains(@class,'TypeAheadEditor')]    ${node_name}
    # Don't wait for type-ahead suggestions.
    Send Keyboard Event    VK_ENTER

Rename Non-Variable Node
    [Arguments]    ${sheet_name}    ${node_name}
    [Documentation]    Renames the currently selected node.
    ...
    ...    This assumes that the node has its Quantrix editor (not type-ahead), so is only applicable to non-variable nodes: data category, all groups, and non-data catagory items.
    Set Current Cell Value    ${sheet_name}    ${node_name}

Link or Map Category
    [Arguments]    ${sheet_name}    ${category_name}
    [Documentation]    Renames the currently selected category, using type-ahead.
    ...
    ...    This is an alias for Rename Variable Node With Type-ahead.
    Rename Variable Node With Type-ahead    ${sheet_name}    ${category_name}

Link or Map Data Category Item
    [Arguments]    ${sheet_name}    ${item_name}
    [Documentation]    Renames the currently selected data category item, using type-ahead.
    ...
    ...    This is an alias for Rename Variable Node With Type-ahead.
    Rename Variable Node With Type-ahead    ${sheet_name}    ${item_name}

Rename Item of Non-Data Category
    [Arguments]    ${sheet_name}    ${item_name}
    [Documentation]    Renames the currently selected item node of a non-data category.
    ...
    ...    This is an alias for Rename Non-Variable Node.
    Rename Non-Variable Node    ${sheet_name}    ${item_name}

Rename Item of Data Category
    [Arguments]    ${sheet_name}    ${item_name}
    [Documentation]    Renames the currently selected item node of the current table's data category.
    ...
    ...    This is an alias for Rename Variable Node.
    Rename Variable Node    ${sheet_name}    ${item_name}

Rename Group
    [Arguments]    ${sheet_name}    ${group_name}
    [Documentation]    Renames the currently selected group node of a category.
    ...
    ...    This is an alias for Rename Non-Variable Node.
    Rename Non-Variable Node    ${sheet_name}    ${group_name}

Rename Non-Data Category
    [Arguments]    ${sheet_name}    ${category_name}
    [Documentation]    Renames the currently selected category, which is assumed to be a non-data category.
    ...
    ...    This is an alias for Rename Variable Node.
    Rename Variable Node    ${sheet_name}    ${category_name}

Rename Data Category
    [Arguments]    ${sheet_name}    ${category_name}
    [Documentation]    Renames the currently selected category, which is assumed to be the current table's data category.
    ...
    ...    This is an alias for Rename Non-Variable Node.
    Rename Non-Variable Node    ${sheet_name}    ${category_name}

Select First Cell in Matrix
    [Arguments]    ${sheet_name}
    [Documentation]    Clicks on the MatrixGridBodyComponent (i.e. quantrix spreadsheet) where found for the given sheet name. This keyword is for automating the UI. If your test does not explicitly require automation of the UI, it is advisable to use the QuantrixLibrary Select Cell in Matrix keyword instead.
    Click On Component At Coordinates    xpath=//*[@name='${sheet_name}']//*[contains(@class, 'MatrixGridBodyComponent')]    2    2
    Sleep    1s    Giving UI time to select cell    # Possibly necessary if another cell is already selected

Current Range List Constraint
    [Documentation]    Obtains the list constraint for the current range from the constraint dialog
    ...
    ...    *Returns*
    ...
    ...    a sorted list ready for comparison
    ...
    ...    *Example*
    ...
    ...    | @{expected_values}= | Create List | A | B |
    ...    | @{actual_values}= | Current Range List Constraint | |
    ...    | Lists should be equal | ${actual_values} | ${expected_values} | |
    Select From Designer Menu    Data|Constrain Input...
    Select Dialog    Constrain Input
    ${constraint_type}=    Get Selected Value From List    ValueTypeList
    Should Be Equal    ${constraint_type}    List
    ${list_constraint}=    Get List Values    DisplayList
    Close Dialog    Constrain Input
    Select Spreadsheet Window
    ${truncated_string}=    String.Get Substring    ${list_constraint}    1    -1
    @{list_of_values}=    String.Split String    ${truncated_string}    ,${SPACE}
    Collections.Sort List    ${list_of_values}
    [Return]    @{list_of_values}    # a sorted list of the values in the range constraint

Current Range Should Be Unconstrained
    [Documentation]    Asserts that the current range has 'Any' as its constraint.
    Select From Designer Menu    Data|Constrain Input...
    Select Dialog    Constrain Input
    ${constraint_type}=    Get Selected Value From List    ValueTypeList
    Should Be Equal    ${constraint_type}    Any
    Close Dialog    Constrain Input
    Select Spreadsheet Window

Current Range Should Have Category Constraint
    [Arguments]    ${expected_category_name}
    [Documentation]    Asserts that the current range has the expected 'Category' constraint.
    Select From Designer Menu    Data|Constrain Input...
    Select Dialog    Constrain Input
    ${constraint_type}=    Get Selected Value From List    ValueTypeList
    Should Be Equal    ${constraint_type}    Dimension
    ${actual_category_name}=    Get Selected Item From Combo Box    xpath=//*[contains(@class,'CategoryComboBox')]
    Should Be Equal    ${actual_category_name}    ${expected_category_name}
    Close Dialog    Constrain Input
    Select Spreadsheet Window

Current Range Should Have Decimal Constraint
    [Arguments]    ${expected_operator}    ${expected_first_bound}=    ${expected_second_bound}=
    [Documentation]    Asserts that the current range has the expected 'Decimal' constraint.
    Select From Designer Menu    Data|Constrain Input...
    Select Dialog    Constrain Input
    ${constraint_type}=    Get Selected Value From List    ValueTypeList
    Should Be Equal    ${constraint_type}    Decimal
    ${actual_operator}=    Get Selected Item From Combo Box    xpath=//*[@name='DecimalConstraintPanel']//*[contains(@class,'ComboBox')]
    Should Be Equal    ${actual_operator}    ${expected_operator}
    ${first_bound_visible}    ${first_bound_visible_message}=    Run Keyword And Ignore Error    Component Should Be Visible    xpath=//*[@name='DecimalConstraintPanel']//*[contains(@class,'TextField')][1]
    ${actual_first_bound}=    Run Keyword If    '${first_bound_visible}'<>'FAIL'    Get Text Field Value    xpath=//*[@name='DecimalConstraintPanel']//*[contains(@class,'TextField')][1]
    Should Be Equal    ${actual_first_bound}    ${expected_first_bound}
    ${second_bound_visible}    ${second_bound_visible_message}=    Run Keyword And Ignore Error    Component Should Be Visible    xpath=//*[@name='DecimalConstraintPanel']//*[contains(@class,'TextField')][2]
    ${actual_second_bound}=    Run Keyword If    '${second_bound_visible}'<>'FAIL'    Get Text Field Value    xpath=//*[@name='DecimalConstraintPanel']//*[contains(@class,'TextField')][2]
    Should Be Equal    ${actual_second_bound}    ${expected_second_bound}
    Close Dialog    Constrain Input
    Select Spreadsheet Window

Current Cell Value
    [Documentation]    Obtains the currently selected cell value.
    ...
    ...    Achieves this assertion in a somewhat Heath-Robinson fashion: by copying to clipboard and pasting into the 'notes' dialog.
    Run Keyword Unless    '${OPERATING_SYSTEM}'=='OSX'    Send Keyboard Event    VK_C    CTRL_MASK
    Run Keyword If    '${OPERATING_SYSTEM}'=='OSX'    Send Keyboard Event    VK_C    META_MASK
    Select From Designer Menu    Edit|Edit Note...
    Select Dialog    Edit Note
    Click On Component    xpath=//*[contains(@class,'TextArea')]
    Run Keyword Unless    '${OPERATING_SYSTEM}'=='OSX'    Send Keyboard Event    VK_V    CTRL_MASK
    Run Keyword If    '${OPERATING_SYSTEM}'=='OSX'    Send Keyboard Event    VK_V    META_MASK
    ${cell_value}=    Get Text Field Value    xpath=//*[contains(@class,'TextArea')]
    Close Dialog    Edit Note
    Select Spreadsheet Window
    [Return]    ${cell_value}    # current cell value

Set Current Cell Value
    [Arguments]    ${sheet_name}    ${cell_value}
    [Documentation]    Sets the current cell value.
    Send Keyboard Event    VK_F2
    Run Keyword Unless    '${OPERATING_SYSTEM}'=='OSX'    Send Keyboard Event    VK_A    CTRL_MASK
    Run Keyword If    '${OPERATING_SYSTEM}'=='OSX'    Send Keyboard Event    VK_A    META_MASK
    ${editor_xpath}=    Get Cell Editor xPath    ${sheet_name}
    Type To Component    ${editor_xpath}    ${cell_value}
    # quantrix 6 (well, 5.9 onwards) has introduced a new dynamic type-ahead component for list based constraints    # and after typing we need to pause to ensure it has given us a chance to select our item from the list    # otherwise we'll end up with a blank cell when we don't want one
    sleep    600ms
    Send Keyboard Event    VK_ENTER

Export Table
    [Arguments]    ${tableName}    ${uniqueIdentifier}    ${filePath}
    [Documentation]    Selects a table from the document browser and exports the table as a .CSV file to a folder destination
    ...
    ...    *Arguments*
    ...
    ...    _tableName_
    ...    The name of the table you wish to export
    ...
    ...    _uniqueIdentifier_
    ...    A unique identifier used to distinguish your exported file from others, must be given and unique, as using an already present ID will cause the step to fail
    ...
    ...    _filePath_
    ...    The location you wish to save the file
    ...
    ...    *Preconditions*
    ...    The spreadsheet must be open, a unique ID should be generated for use
    ...
    ...    *Return Value*
    ...    _exportCSVName_
    ...    The name of the file exported, without extension or path
    ...
    ...    *Example*
    ...
    ...    | ${uniqueID}= | Create UniqueID |
    ...    | ${fileName}= | Export Table | Table1 | ${uniqueID} | ${TEMPDIR} |
    Select From Designer Menu    File|Export|Delimited Text File...
    Sleep    500ms
    Select Dialog    Export Delimited Text Data File
    Push Button    deselect
    Check Check Box    xpath=//*[text()='${tableName}']
    Push Button    Next >
    Select Dialog    Export Delimited Text Data File
    Select From Combo Box    delimiter-combo    Pipe (|)
    Push Button    Finish
    Choose From File Chooser    ${filePath}${/}${tableName}_${uniqueIdentifier}
    ${exportCSVName}=    Set Variable    ${tableName}_${uniqueID}
    [Return]    ${exportCSVName}

Variable Unit Should Be
    [Arguments]    ${expected_unit}=${EMPTY}
    [Documentation]    Asserts that the currently selected variable has the expected unit.
    ...
    ...    *Arguments*
    ...    - _expected_unit_ - the expected unit to compare to, leave blank to assert no unit is set
    ...
    ...    *Return Value*
    ...
    ...    None
    Select From Designer Menu    Data|Unit of Measurement...
    Select Dialog    Unit of Measurement
    ${is_combo}    ${is_combo_message}=    Run Keyword And Ignore Error    Combo Box Should Be Enabled    unitSelector
    ${actual_unit_text}=    Run Keyword If    '${is_combo}'=='FAIL'    Get Text Field Value    unitSelector
    ${actual_unit_combo}=    Run Keyword If    '${is_combo}'!='FAIL'    Get Selected Item From Combo Box    unitSelector
    ${actual_unit}=    Set Variable If    '${is_combo}'=='FAIL'    ${actual_unit_text}    ${actual_unit_combo}
    # 'No unit' selected from combo comes out as ' '.
    ${actual_unit}=    Set Variable If    '${actual_unit}'==' '    ${EMPTY}    ${actual_unit}
    Check String Equals    Checking the selected variable has the expected unit set    ${actual_unit}    ${expected_unit}
    Close Dialog    Unit of Measurement
    common_spreadsheet_keywords.Select Spreadsheet Window

Set Variable Unit
    [Arguments]    ${unit}=    # omit ${unit} to unset the unit
    [Documentation]    Sets the unit for the currently selected variable.
    Select From Designer Menu    Data|Unit of Measurement...
    Select Dialog    Unit of Measurement
    ${is_combo}    ${is_combo_message}=    Run Keyword And Ignore Error    Combo Box Should Be Enabled    unitSelector
    Run Keyword If    '${is_combo}'=='FAIL'    Type Into Text Field    unitSelector    ${unit}
    Run Keyword If    '${is_combo}'<>'FAIL'    Select From Combo Box    unitSelector    ${unit}
    Send Keyboard Event    VK_ENTER
    Select Spreadsheet Window

Set Format
    [Arguments]    ${format}
    [Documentation]    Sets the number format for the currently selected range
    Push Button    QuickNumberFormat
    # Select "More...", which is the last item in the popup menu.
    Send Keyboard Event    VK_UP
    Sleep    1000ms
    Send Keyboard Event    VK_ENTER
    Select Dialog    Edit Custom Number Format
    IDBSSwingLibrary.Type Into Text Field    xpath=//*[contains(@class,'TextField')]    ${format}
    Sleep    500ms
    IDBSSwingLibrary.Push Button    OK
    Select Spreadsheet Window

Switch spreadsheet role
    [Arguments]    ${role}=Modeler    ${password}=${EMPTY}
    [Documentation]    switches the current role of the spreadsheet
    ...
    ...    *Arguments*
    ...
    ...    _role_ - the role to switch to (default: Modeler)
    ...
    ...    _password_ - the password for the role (default: none)
    ...
    ...    *Precondition*
    ...    The spreadsheet must be open and focused
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...    | Switch spreadsheet role |
    ...    | Switch spreadsheet role | Modeler | ABC123 |
    ...    | Switch spreadsheet role | Viewer |
    ${result}    ${msg}=    Run Keyword And Ignore Error    Validate Current Spreadsheet Role    ${role}
    run keyword if    '${result}'== 'FAIL'    Select From Designer Menu    Tools|Security|Switch Role...
    run keyword if    '${result}'== 'FAIL'    Sign into spreadsheet    ${role}    ${password}

Sign into spreadsheet
    [Arguments]    ${role}=${MODELER_ROLE}    ${password}=${EMPTY}
    [Documentation]    signs into the spreadsheet using the specified role. \ assumes the sign in dialog is already displayed. \ Will re-select the spreadsheet window once done.
    IDBSSwingLibrary.Component Should Be Visible    class=LoginPane
    ${val}=    Run Keyword And Ignore Error    Get Combobox Values    class=ComboBox    # need this to kick next select into gear, otherwise it doesn't work.
    Select From Combo Box    class=ComboBox    ${role}
    IDBSSwingLibrary.Insert Into Text Field    class=JPasswordField    ${password}
    IDBSSwingLibrary.Push Button    text=Login
    common_spreadsheet_keywords.Select Spreadsheet Window

Validate Current Spreadsheet Role
    [Arguments]    ${role}
    [Documentation]    Validates the current role the spreadsheet is logged in as.
    ...
    ...    *Arguments*
    ...
    ...    _role_ - the role to check
    ...
    ...
    ...    *Precondition*
    ...    The spreadsheet must be open and focused
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...    | Validate Current Spreadsheet Role | Modeler
    Wait Until Keyword Succeeds    15s    2s    Component Should Exist    xpath=*//*[contains(@class,JLabel) and text()='${role}']

Start weblaunch
    [Arguments]    ${file_name}    ${spreadsheet_index}=1    # the name of the file opened in the spreadsheet window.
    [Documentation]    loads the various libraries and activates the weblaunch for the spreadsheet on the current web page
    ...
    ...    *Arguments*
    ...
    ...    _file_name_ the name of the spreadsheet file opened. This is a combination of "itemtype - experimentname.ewbss".
    ...
    ...    _spreadsheet_index_ - the index (1-base) of the spreadsheet to select. \ no need to specify if there is only one spreadsheet in the experiment
    ...
    ...    *NOTE*
    ...    check out the regex variables in this resource for handy \ items.
    # ensure we are starting in a clean state
    Run Keyword and Ignore Error    Kill All Spreadsheet Designer Sessions    # There is a very rare failure case here where, if it has just been shut down, the designer process can be still running when the kill command is given, but close while the command is still trying to kill it. In this case, we see a NoSuchProcess error in the log. In order to avoid this outcome, I've opted for an ignore error.
    # activte weblaunch button
    Select Document Header    ${spreadsheet_index}
    ${click_index}=    Evaluate    ${spreadsheet_index}-1
    Robust Click    document-header-${click_index}-menuButton
    Robust Click    ewb-command-ss-webstart-edit
    Connect to Spreadsheet Designer    ${file_name}
    Set Spreadsheet Designer Open Flag    ${True}

Shut down weblaunch
    [Arguments]    ${save_option}=No
    [Documentation]    Closes the spreadsheet editor, saving changes if specified and required. \ This will wait until the web editor had closed the "external editing" dialog before returning.
    ...    *Arguments*
    ...
    ...    _save_ - \ Yes/No/Cancel (i.e. which button to push when prompted) (default: No)
    ...
    ...    *Precondition*
    ...    There must a running spreadsheet editor
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...    | shutdown spreadsheet |
    ...    | shutdown spreadsheet | No |
    ...    | shutdown spreadsheet | Yes |
    ...    | shutdown spreadsheet | Cancel |
    # Add a small delay before trying to close the application, without this the close sometimes fails
    Sleep    1s
    Run Keyword If    '${OPERATING_SYSTEM}'=='OSX'    Select From Designer Menu    Spreadsheet Designer|Quit Spreadsheet Designer
    Run Keyword Unless    '${OPERATING_SYSTEM}'=='OSX'    common_spreadsheet_keywords.Select Spreadsheet Window
    Run Keyword Unless    '${OPERATING_SYSTEM}'=='OSX'    Select From Designer Menu    File|Exit
    ${save_required}=    Run Keyword And Return Status    Spreadsheet Should Be Dirty
    # it is possible that the close window keyword will actually shut down the application (e.g. if there are no changes to be saved) and in that case there is no need to actually save changes and all that good stuff.
    run keyword if    ${save_required}    _Save changes and wait for application to close    ${save_option}
    Set Spreadsheet Designer Open Flag    ${False}
    Run Keyword and Ignore Error    Wait Until Element Is Not Visible    css=.ewb-launcher-panel    30s

_Save changes and wait for application to close
    [Arguments]    ${save_option}
    [Documentation]    PRIVATE - Do not call.
    ...
    ...    This is used to handle a graceful shutdown of the spreadsheet designer following a request to exit
    # close save changes dialog if open
    ${passed}    ${ignore}=    Run Keyword And Ignore Error    IDBSSwingLibrary.Dialog Should Be Open    ${spreadsheet_designer_dialog_title}
    Run Keyword If    '${passed}'=='PASS'    IDBSSwingLibrary.Activate Dialog    ${spreadsheet_designer_dialog_title}
    Run Keyword If    '${passed}'=='PASS'    Wait Until Keyword Succeeds    10s    1s    Component Is Enabled    xpath=//*[@name="OptionPane.button" and text()="${save_option}"]
    ...    # Yes/No buttons
    Run Keyword If    '${passed}'=='PASS'    IDBSSwingLibrary.Push Button    xpath=//*[@name="OptionPane.button" and text()="${save_option}"]    # Yes/No buttons
    # wait for editing session to finish
    ${closed}=    Run Keyword and Return Status    Wait For Current Java Application To Close    3 minutes
    Run Keyword Unless    ${closed}    Capture Designer Screenshot and Fail    Took more than 3 minutes to save the designer spreadsheet

Weblaunch Open Browser to Page
    [Arguments]    ${Web Client Page}    ${user}    ${password}    ${expected_error}=${None}
    [Documentation]    Opens browser to ${Web Client Page} and logs in using ${user} and ${password} credentials and waits for page to load
    ...
    ...    _THIS INITIALISES THE BROWSER TO ALLOW THE DESIGNER TO BE AUTOMATED_
    ${agent_path}=    RobotRemoteAgent.Get Java Agent Option
    ${environment_vars}=    Create Dictionary    JAVA_TOOL_OPTIONS    ${agent_path}    _JAVA_OPTIONS    ${EMPTY}
    ${alias}=    Open Browser to Page    ${Web Client Page}    ${user}    ${password}    expected_error=${None}    environment_variables=${environment_vars}
    [Return]    ${alias}

Designer Open Browser To Root
    [Arguments]    ${user}=${VALID USER}    ${password}=${VALID PASSWD}
    [Documentation]    Opens browser to ${ROOT URL} and logs in using ${user} and ${password} credentials and waits for page to load
    ...
    ...    *Arguments*
    ...
    ...    _user_ - the user to log in as (default is ${VALID_USER})
    ...
    ...    _password_ - the user password for the user (default is ${VALID_PASSWORD})
    ...
    ...    _THIS INITIALISES THE BROWSER TO ALLOW THE DESIGNER TO BE AUTOMATED_
    weblaunch Open Browser to Page    ${ROOT URL}    ${user}    ${password}
    Wait Until Title Is    IDBS E-WorkBook - Root    30s

Designer Open Browser To Entity
    [Arguments]    ${entity_id}    ${user}=${VALID USER}    ${password}=${VALID PASSWD}
    [Documentation]    Opens browser to the given entity and logs in using ${user} and ${password} credentials and waits for page to load
    ...
    ...    *Arguments*
    ...
    ...    _entity_id - the entity
    ...
    ...    _user_ - the user to log in as (default is ${VALID_USER})
    ...
    ...    _password_ - the user password for the user (default is ${VALID_PASSWORD})
    ...
    ...    _THIS INITIALISES THE BROWSER TO ALLOW THE DESIGNER TO BE AUTOMATED_
    ${entity_url}=    Create Entity URL    ${entity_id}
    weblaunch Open Browser to Page    ${entity_url}    ${user}    ${password}
    Wait Until Keyword Succeeds    30s    1s    Check For Selected Entity    ${entity_id}

Rename Selected Sheet
    [Arguments]    ${sheet_name}
    [Documentation]    renames the sheet currently selected in the model browser
    ...
    ...    * Arguments *
    ...
    ...    _sheet_name_ the name we want to apply to the sheet
    ...
    ...    * Preconditions *
    ...
    ...    the model browser must have focus and the appropriate sheet must be selected
    Send Keyboard Event    VK_F2
    Sleep    300ms
    Run Keyword Unless    '${OPERATING_SYSTEM}'=='OSX'    Send Keyboard Event    VK_A    CTRL_MASK
    Run Keyword If    '${OPERATING_SYSTEM}'=='OSX'    Send Keyboard Event    VK_A    META_MASK
    Type Into Text Field    xpath=//*[@name='BrowserTree']//*[contains(@class,'JTextField')]    ${sheet_name}
    Send Keyboard Event    VK_ENTER
    Sleep    300ms

Save WebLaunch Spreadsheet
    [Documentation]    saves the current spreadsheet
    # do we need to save? check the title bar for the magic "*"
    ${window_title}=    get selected window title
    ${start_char}=    Get Substring    ${window_title}    0    1
    run keyword if    '${start_char}' == '*'    QuantrixLibrary.Mark Spreadsheet As About To Be Saved
    run keyword if    '${start_char}' == '*'    Select From Designer Menu    File|Update E-WorkBook
    run keyword if    '${start_char}' == '*'    wait until keyword succeeds    200s    5s    QuantrixLibrary.Ensure Spreadsheet Has Been Saved

Ensure problem pane is visible and refreshed
    [Documentation]    ensures that the problem pane is visible within the spreadsheet designer and that it has been refreshed
    ...
    ...    *Pre-requisites*
    ...
    ...    The spreadsheet designer must be running and initialised for testing.
    ${problems_pane_exists}    ${problems_pane_exists_message}=    Run Keyword And Ignore Error    Component Should Not Exist    problems-table
    Run Keyword If    '${problems_pane_exists}'=='PASS'    Select From Designer Menu    Tools|Problems
    Run Keyword If    '${problems_pane_exists}'=='PASS'    Wait Until Keyword Succeeds    2s    0.5s    Component Should Be Visible    problems-table
    Push Button    refresh-button

Close problems pane
    [Documentation]    ensures that the problems pane is closed
    ${problems_pane_exists}    ${problems_pane_exists_message}=    Run Keyword And Ignore Error    Component Should Be Visible    problems-table
    Run Keyword If    '${problems_pane_exists}'=='PASS'    Select From Designer Menu    Tools|Problems
    # wai...until is used to let Quantrix actually close the tool pane window
    Run Keyword If    '${problems_pane_exists}'=='PASS'    Wait Until Keyword Succeeds    3s    1s    Component Should not exist    problems-table
    ...    2

problem should be present
    [Arguments]    ${problem_description}    ${problem_location}=${EMPTY}
    [Documentation]    Checks the problems pane to see if a problem with the specified description (and optionally, location) exists
    ...
    ...    *Arguments*
    ...
    ...    _problem_description_ - this is the description of the problem. \ This must be supplied.
    ...
    ...    _problem_location_ - this is the location of the problem. \ This is optional. \ \ If specified, then the location must match as well as the description.
    ...
    ...
    ...
    ...    *Pre-requsites*
    ...
    ...    The problem pane should be visible
    ...
    ...    The problem (if present) should be visible on the table (i.e. not filtered or excluded by max rows)
    ${found_desc}=    Set Variable    ${EMPTY}
    ${found_loc}=    Set Variable    ${EMPTY}
    ${check_location}    ${check_location_message}    Run Keyword And Ignore Error    should not be empty    ${problem_location}
    ${row_count}=    Get Table Row Count    problems-table
    : FOR    ${row}    IN RANGE    ${row_count}
    \    #check description
    \    ${cell_val}=    Get Table Cell Value    problems-table    ${row}    Description
    \    ${match}    ${match_msg}    run keyword and ignore error    Should Be Equal As Strings    ${problem_description}    ${cell_val}
    \    ${found_desc}=    run keyword if    '${match}' == 'PASS'    Set Variable    true
    \    ${found_loc}=    run keyword if    '${match}' == 'PASS'    Get Table Cell Value    problems-table    ${row}
    \    ...    Location
    \    run keyword if    '${match}' == 'PASS'    Exit For Loop
    # confirm we found the description
    Should Not Be Empty    ${found_desc}
    # check the location value (optional)
    Run Keyword if    '${check_location}' == 'PASS'    Should Be Equal As Strings    ${problem_location}    ${found_loc}

problem should not be present
    [Arguments]    ${problem_description}
    [Documentation]    Checks the problems pane to see that a problem with the specified description does not exist. \ *Arguments*
    ...
    ...    _problem_description_ - this is the description of the problem. \ This must be supplied.
    ...
    ...
    ...    *Pre-requsites*
    ...
    ...    The problem pane should be visible.
    ...
    ...
    ...    *NOTE*
    ...
    ...    This only checks the visible list of problems. \ If the list is filtered to exclude the description then this counts as if the problem is not there
    ${found_desc}=    Set Variable    ${EMPTY}
    ${row_count}=    Get Table Row Count    problems-table
    : FOR    ${Var}    IN RANGE    ${row_count}-1
    \    ${cell_val}=    Get Table Cell Value    problems-table    ${Var}    Description
    \    Should Not Be Equal As Strings    ${problem_description}    ${cell_val}

Kill All Spreadsheet Designer Sessions
    [Documentation]    this kills any running Spreadsheet designer processes. \ General rule of thumb is to:
    ...
    ...    1. call this in suite/test setup to ensure there are no running processes that might break you
    ...
    ...    2. call this in suite/test teardown to ensure you leave things in a happy place.
    ...
    ...    better safe than sorry!
    Run Keyword Unless    '${OPERATING_SYSTEM}'=='OSX'    Kill Processes With Name    EWBWebSS.exe
    Run Keyword If    '${OPERATING_SYSTEM}'=='OSX'    Kill Processes With Name    JavaAppLauncher
    # Make sure that where designer fails unexpectedly, the launch dialog is dismissed
    Run Keyword and Ignore Error    Wait Until Keyword Succeeds    4s    500ms    Dismiss Launch Dialog

Resynchronise Spreadsheet Mapping
    [Documentation]    This keyword resynchronises a catalog mapping in the spreadsheet
    ...
    ...    _Precondition_
    ...    Requires spreadsheet to containg catalog mapping and for the mapping to be selected in the catalog mapping dialog
    Push Button    resynchNow

View Catalog Mappings In a Spreadsheet
    [Documentation]    This keyword selects the option to view the catalog mappings in the Spreadsheet Designer. When this option is selected, the catalog mappings dialog is displayed in the panle of the spreadsheet designer.
    ...
    ...    _Preconditions_
    ...
    ...    The Spreadsheet Designer MUST be opened with a user that has permission to use all functionality in the spreadsheet, thus to be able to select the 'Catalog Mappings' option from the toolbar menu in the Spreadsheet Designer
    Select From Designer Menu    Data|Catalog Mappings
    IDBSSwingLibrary.Component Should Exist    catalogMappingToolPane    10
    Wait Until Keyword Succeeds    5s    1s    IDBSSwingLibrary.Component Should Be Visible    catalogMappingToolPane

Save Perspective
    [Arguments]    ${name}
    [Documentation]    Saves the current UI layout as a perspective with the given name of ${name}
    ...
    ...    Assumes the designer is already using the modeler role
    Select From Designer Menu    View|Perspectives|Save Perspective...
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    Save Perspective
    Sleep    3s
    IDBSSwingLibrary.Type Into Text Field    class=javax.swing.plaf.basic.BasicComboBoxEditor$BorderlessTextField    ${name}
    IDBSSwingLibrary.Push Button    ok

Unmap Catalog Mapping
    [Documentation]    This selects the unmap button in the catalog mapping dialog
    ...
    ...    -Precodnitions-
    ...
    ...    Requires the Mapping tab in catalog mapping dialog to be launched in the spreadsheet designer. Also requires a variable in the matrix to have been mapped to a term so that the summary of the mapping can be displayed in the catalog mapping dialog
    Push Button    unmap

Undo Spreadsheet Action
    [Documentation]    Selects the Undo button in the spreadsheet designer
    ...
    ...    _Preconditions_
    ...
    ...    Requires the spreadsheet designer to be launched and an action to have been carried out in the designer
    ${timeout}=    Set Jemmy Timeout    ComponentOperator.WaitComponentEnabledTimeout    5    # Don't want to wait all day for this
    IDBSSwingLibrary.Button Should Be Enabled    DocUndo
    Push Button    DocUndo
    Set Jemmy Timeout    ComponentOperator.WaitComponentEnabledTimeout    ${timeout}    # Set it back to what it was so as not to interefere with other tests.

Redo Spreadsheet Actions
    [Documentation]    Selects the Re-do button in the spreadsheet designer
    ...
    ...    _Preconditions_
    ...
    ...    Requires the spreadsheet designer to be launched and an action to have been carried out in the designer
    Push Button    DocRedoRepeat

Select Spreadsheet Dimension
    [Arguments]    ${catName}    ${clickTimes}
    [Documentation]    Selects a Dimension Tile in the currently open table
    ...
    ...    *Arguments*
    ...
    ...    _catName_
    ...    The name of the dimension you wish to select
    ...
    ...    _clickTimes_
    ...    The number of times the dimension tile should be clicked when selecting
    ...
    ...    *Preconditions*
    ...    The table must be curently open and editable
    ...
    ...    *Return Value*
    ...    _none_
    ...
    ...    *Example*
    ...
    ...    | Select Dimension | Data | 2 |
    Click On Component    xpath=//*[@name='CategoryTile${catName}']    ${clickTimes}

Map Catalog Item
    [Documentation]    This selects the "Map to" button in the Catalog Mappings panel in the spreadsheet designer
    ...
    ...    _Preconditions_
    ...
    ...    This keyword requires the catalog mapping dialog to be opened in the spreadsheet designer. The term and the porperty to be mapped also needs to have been selected in the catalog tab.
    Push button    mapTo

is Generating Preview Dialog Open
    [Documentation]    Returns true/false based on the generating previews dialog being open. This is done by looping a number of times and checking every 100ms or so to see if the dialog is preseted
    ...
    ...    *Returns*
    ...
    ...    true/false indicating if the dialog is open or not
    ${is open}=    set Variable    ${False}
    ${old timeout}=    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout    1
    # TEMPORARY COMMENTING OUT TO TRY AND GET MORE INFO ON FAILING UNIT TESTS
    Comment    Disable Taking Screenshots On Failure
    : FOR    ${index}    IN RANGE    1    6
    \    ${result}    ${err_message}=    Run Keyword And Ignore Error    dialog should be open    ${PREVIEW_DIALOG}
    \    ${is open}=    set variable if    '${result}' == 'PASS'    ${True}    ${False}
    \    run keyword if    '${result}' == 'PASS'    Exit For Loop
    \    Enable Taking Screenshots On Failure
    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout    ${old timeout}
    [Return]    ${is open}

wait for preview dialog to close
    [Documentation]    waits for the spreadsheet "generating previews" dialog to close
    ${old timeout}=    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout    1
    Disable Taking Screenshots On Failure
    wait until keyword succeeds    30s    5s    dialog should not be open    ${PREVIEW_DIALOG}
    Enable Taking Screenshots On Failure
    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout    ${old timeout}

Create Formula for active matrix
    [Arguments]    ${formula}
    [Documentation]    creates a formula in the active matrix
    ...
    ...    *Arguments*
    ...
    ...    _formula_ - the formula to add
    ...
    ...    *Pre-requisites*
    ...
    ...    o spreadsheet designer must be open
    ...
    ...    o a single matrix must be displayed
    wait until keyword succeeds    2s    500ms    IDBSSwingLibrary.Component Should Be Visible    FormulaTable
    IDBSSwingLibrary.Click On Component    FormulaTable
    sleep    200ms    allow time for formula selection
    # create a new row to avoid blatting any existing formula
    IDBSSwingLibrary.Send Keyboard Event    VK_ENTER
    IDBSSwingLibrary.Send Keyboard Event    VK_F2
    IDBSSwingLibrary.Type Into Text Field    class=FormulaTextEditor    ${formula}
    IDBSSwingLibrary.Send Keyboard Event    VK_ENTER

Select First Column in Matrix
    [Arguments]    ${sheet_name}
    [Documentation]    selects the first column in the specified matrix
    ...
    ...    *Arguments*
    ...
    ...    _sheet_name_ - the name of the matrix
    ...
    ...    *Example*
    ...
    ...    | Select First Column in Matrix | matrix1
    Click On Component At Coordinates    xpath=//*[@name='${sheet_name}']//*[contains(@class, 'ColumnHeaderComponent')]    2    2

Ensure Spreadsheet Is Dirty To Allow A Save To Occur
    [Documentation]    This is used to ensure a spreadsheet is dirty, meaning that a subsequent call to save the spreasdheet will actually work.
    ...
    ...    This is typically used when a test suite is involves lots of tests against the designer and you don't want to restart the designer for each test. \ So, in this situation you would normally ensure in the _Test Setup_ that the spreadsheet is "clean" and will not interrupt with saving prompts
    ...
    ...
    ...    *Example*
    ...
    ...    | Select Spreadsheet Window
    ...    | Ensure Spreadsheet Is Dirty To Allow A Save To Occur
    ...    | Save WebLaunch Spreadsheet
    ${new_matrix}=    new matrix
    delete sheet    ${new_matrix}

Close Model Browser
    [Documentation]    Closes the model browser
    ...
    ...    *Example*
    ...
    ...    | Close Model Browser
    # there are instances where the internal "clicking" just doesn't work, so we add a try-again safety net.
    Wait Until Keyword Succeeds    30s    2s    _Internal Close Model Browser

Close Format Toolpane
    [Documentation]    Closes the Format tool pane
    ...
    ...    *Example*
    ...
    ...    | Close Format Toolpane
    : FOR    ${i}    IN RANGE    5
    \    ${present}=    Run Keyword and Return Status    Component Should Exist    property-inspector    3
    \    Exit For Loop If    not ${present}    # Once it's gone, we're done
    \    Select From Designer Menu    Format|Format Toolbox    # Used to use the F3 shortcut here, but that has a tendency to open the Windows search and lose focus on the Designer.
    \    ${dismissed}=    Run Keyword And Return Status    Wait Until Keyword Succeeds    5s    1s    Component Should Not Exist
    \    ...    property-inspector    3
    \    ${present}=    Set Variable If    ${dismissed}    ${False}    ${True}
    \    Exit For Loop If    not ${present}
    Return From Keyword If    not ${present}
    Capture Designer Screenshot and Fail    Format Toolpane could not be closed after 5 attempts.    # We only reach this point if it's still open.

_Pick File Using OSX File Chooser
    [Arguments]    ${file_path}
    [Documentation]    Picks a file using the file chooser on OSX (using Quaqua look and feel)
    ...
    ...    *Should not be called directly - logic to call this keyword is implemented in "Add File to be imported"*
    ...
    ...    *Assumptions*
    ...
    ...    - File chooser is already open
    ...    - file_path argument value is expected to be normalised before being passed to this keyword, including a preceeding forward slash
    ...
    ...    *Arguments*
    ...
    ...    - _file_path_ - the normalised full file path including preceeding forward slash
    ...
    ...
    ...    *Example*
    ...    | _Pick File Using OSX File Chooser | /Users/automation/example.txt |
    #Get to Root
    Sleep    2s
    @{combo_box_values}=    IDBSSwingLibrary.Get Combobox Values    0
    IDBSSwingLibrary.Select From Combo Box    0    @{combo_box_values}[-1]
    Sleep    1s
    ${selected_value}=    IDBSSwingLibrary.Get Selected Item From Combo Box    0
    Sleep    1s
    ${first_list_items}=    IDBSSwingLibrary.Get List Values    xpath=//*[contains(@class,'quaqua.JBrowser$1')][1]
    Run Keyword If    '${selected_value}' in '${first_list_items}'    IDBSSwingLibrary.Select From List    xpath=//*[contains(@class,'quaqua.JBrowser$1')][1]    ${selected_value}
    ${index_offset}=    Set Variable If    '${selected_value}' in '${first_list_items}'    2    1    #offset list selection by two if the root volume needs to be selected first
    ${file_path}=    Replace String    ${file_path}    /    ${EMPTY}    1
    @{file_parts}=    Split String    ${file_path}    /
    ${part_length}=    Get Length    ${file_parts}
    : FOR    ${index}    IN RANGE    ${part_length}
    \    Sleep    1s
    \    ${corrected_path}=    Set Variable If    '@{file_parts}[${index}]'=='.virtualenvs'    auto_virtualenvs    @{file_parts}[${index}]
    \    ${xpath_index}=    Evaluate    ${index}+${index_offset}
    \    #click on item in list
    \    ${li}=    IDBSSwingLibrary.Get List Values    xpath=//*[contains(@class,'quaqua.JBrowser$1')][${xpath_index}]
    \    ${status}    ${value}=    Run Keyword And Ignore Error    Wait Until Keyword Succeeds    5s    1s
    \    ...    IDBSSwingLibrary.Select From List    xpath=//*[contains(@class,'quaqua.JBrowser$1')][${xpath_index}]    ${corrected_path}
    \    ${sel}=    IDBSSwingLibrary.Get Selected Value From List    xpath=//*[contains(@class,'quaqua.JBrowser$1')][${xpath_index}]
    \    #workaround for potential quaqua bug where the root menu list is not fixed
    \    ${index_offset}=    Set Variable If    '${status}'=='FAIL'    2    ${index_offset}
    \    ${xpath_index}=    Evaluate    ${index}+${index_offset}
    \    Run Keyword If    '${status}'=='FAIL'    Wait Until Keyword Succeeds    5s    1s    IDBSSwingLibrary.Select From List
    \    ...    xpath=//*[contains(@class,'quaqua.JBrowser$1')][${xpath_index}]    ${corrected_path}
    \    ${sel}=    Run Keyword If    '${status}'=='FAIL'    IDBSSwingLibrary.Get Selected Value From List    xpath=//*[contains(@class,'quaqua.JBrowser$1')][${xpath_index}]
    Push Button    text=Open

Insert Mapped
    [Documentation]    Selects the button to "Insert after" in the catalog mapping dialog
    Push button    insertAfter

Get category and items for matrix
    [Arguments]    ${matrix}
    [Documentation]    returns the category & item names for the specified matrix
    ...
    ...    *Arguments*
    ...
    ...    _matrix_ - the matrix of interest
    ...
    ...    *Returns"
    ...
    ...    _Dimension_ - the name of the non-data dimension
    ...
    ...    _Item_ - the name of the first item in Dimension
    ...
    ...    _DataItem_ - the name of the first item in the Data Dimension
    ...
    ...    *Example*
    ...
    ...    | ${Dimension} | ${Item} | ${DataItem}= | Get category and items for matrix | ${Table}
    ...    | Robust Confirm Cell Value | ${Table}::${DataItem}:${Item} | Hello
    ${Dimension}=    Get Category Name    ${matrix}    Row    0
    ${Item}=    Get Category Item Name By Index    ${matrix}    ${Dimension}    -1
    ${DataItem}=    Get Category Item Name By Index    ${matrix}    Data    -1
    [Return]    ${Dimension}    ${Item}    ${DataItem}

Timestamp Is Between
    [Arguments]    ${timestamp}    ${afterOrEq}    ${beforeOrEq}    ${tolerance_seconds}=0
    [Documentation]    Check that the specified timestamp lies within the specified range.
    ...
    ...    *arguments*
    ...
    ...    ${timestamp} = The timestamp to check.
    ...
    ...    ${afterOrEq} = The lower bound of the range, i.e. the date and time that _${timestamp}_ must either be equal to, or lie after.
    ...
    ...    ${beforeOrEq} = The upper bound of the range, i.e. the date and time that _${timestamp}_ must either be equal to, or lie before.
    ...
    ...    ${tolerance_seconds} = A number of seconds of tolerance to add either side of the range described by _${afterOrEq}_ and _${beforeOrEq}_.
    ...
    ...    *return value*
    ...
    ...    _true_ if the timestamp lies within the specified range, _false_ otherwise
    ...
    ...    *notes*
    ...
    ...    The arguments _${timestamp}_, _${afterOrEq}_ and _${beforeOrEq}_ can be any object convertible by the built-in *Convert Date* function. For example, these can be strings in the following format:
    ...
    ...    2015-12-01 17:28:30
    ...
    ...    This keyword is *not* robust against the range being specified in reverse order. _${afterOrEq}_ *must* lie _before_ (or be equal to) _${beforeOrEq}_, or this keyword will always return _false_.
    ${ts_adjust}=    Convert Time    ${tolerance_seconds}
    ${dt_afterOrEq}=    Convert Date    ${afterOrEq}
    ${dt_afterOrEq}=    Subtract Time From Date    ${dt_afterOrEq}    ${ts_adjust}
    ${dt_beforeOrEq}=    Convert Date    ${beforeOrEq}
    ${dt_beforeOrEq}=    Add Time To Date    ${dt_beforeOrEq}    ${ts_adjust}
    ${isAfterOrEq}=    Timestamp Is After Or Equal    ${timestamp}    ${dt_afterOrEq}
    ${isBeforeOrEq}=    Timestamp Is Before Or Equal    ${timestamp}    ${dt_beforeOrEq}
    Run Keyword Unless    ${isAfterOrEq}    Return From Keyword    ${FALSE}
    Run Keyword Unless    ${isBeforeOrEq}    Return From Keyword    ${FALSE}
    Return From Keyword    ${TRUE}

Timestamp Is After Or Equal
    [Arguments]    ${timestamp}    ${afterOrEq}
    [Documentation]    Check that the specified timestamp lies after, or is equal to, another timestamp.
    ...
    ...    *arguments*
    ...
    ...    ${timestamp} = The timestamp to check.
    ...
    ...    ${afterOrEq} = The timestamp to compare to, i.e. the date and time that _${timestamp}_ must either lie after, or be equal to.
    ...
    ...    *return value*
    ...
    ...    _true_ if _${timestamp}_ lies after, or is equal to, _${afterOrEq}_;
    ...    _false_ otherwise
    ...
    ...    *notes*
    ...
    ...    The arguments _${timestamp}_ and _${afterOrEq}_ can be any object convertible by the built-in *Convert Date* function. For example, these can be strings in the following format:
    ...
    ...    2015-12-01 17:28:30
    # Convert timestamp strings to DateTime objects
    ${dt_ts}=    Convert Date    ${timestamp}    datetime
    ${dt_op}=    Convert Date    ${afterOrEq}    datetime
    # Compare the YEAR, MONTH, DAY, HOUR, MINUTE and SECOND elements of the timestamps, in order of most-significant to least-significant. Note: if sub-second values (milliseconds etc.) are present, they are ignored.
    # YEAR
    Return From Keyword If    ${dt_ts.year} < ${dt_op.year}    ${FALSE}
    Return From Keyword If    ${dt_ts.year} > ${dt_op.year}    ${TRUE}
    # MONTH
    Return From Keyword If    ${dt_ts.month} < ${dt_op.month}    ${FALSE}
    Return From Keyword If    ${dt_ts.month} > ${dt_op.month}    ${TRUE}
    # DAY
    Return From Keyword If    ${dt_ts.day} < ${dt_op.day}    ${FALSE}
    Return From Keyword If    ${dt_ts.day} > ${dt_op.day}    ${TRUE}
    # HOUR
    Return From Keyword If    ${dt_ts.hour} < ${dt_op.hour}    ${FALSE}
    Return From Keyword If    ${dt_ts.hour} > ${dt_op.hour}    ${TRUE}
    # MINUTE
    Return From Keyword If    ${dt_ts.minute} < ${dt_op.minute}    ${FALSE}
    Return From Keyword If    ${dt_ts.minute} > ${dt_op.minute}    ${TRUE}
    # SECOND
    Return From Keyword If    ${dt_ts.second} < ${dt_op.second}    ${FALSE}
    Return From Keyword    ${TRUE}    # If we get here, the timestamp is after, or equal to, the operand.

Timestamp Is Before Or Equal
    [Arguments]    ${timestamp}    ${beforeOrEq}
    [Documentation]    Check that the specified timestamp lies before, or is equal to, another timestamp.
    ...
    ...    *arguments*
    ...
    ...    ${timestamp} = The timestamp to check.
    ...
    ...    ${beforeOrEq} = The timestamp to compare to, i.e. the date and time that _${timestamp}_ must either lie before, or be equal to.
    ...
    ...    *return value*
    ...
    ...    _true_ if _${timestamp}_ lies before, or is equal to, _${beforeOrEq}_;
    ...    _false_ otherwise
    ...
    ...    *notes*
    ...
    ...    The arguments _${timestamp}_ and _${beforeOrEq}_ can be any object convertible by the built-in *Convert Date* function. For example, these can be strings in the following format:
    ...
    ...    2015-12-01 17:28:30
    Run Keyword And Return    Timestamp Is After Or Equal    ${beforeOrEq}    ${timestamp}    # Implemented in terms of the Timestamp Is After Or Equal keyword

_Internal Close Model Browser
    [Documentation]    NOT FOR GENERAL USE
    ${model_browser_exists}    ${model_browser_exists_message}=    Run Keyword And Ignore Error    Component Should Have Visible Flag    BrowserTree
    Run Keyword If    '${model_browser_exists}'=='PASS'    Push Button    ModelBrowserPulldownButton
    # wait for browser to close
    Wait Until Keyword Succeeds    8s    2s    IDBSSwingLibrary.Component Should Not exist    BrowserTree    1

Map Category and validate mapping
    [Arguments]    ${sheet_name}    ${mapping_name}
    [Documentation]    maps the selected category (using type-ahead).
    ...
    ...    note: this will fail if ${mapping_name} does not subsequently have a mapping after the rename (this is more of a safety net to help identify issues rather than a general use case).
    Rename Variable Node With Type-ahead    ${sheet_name}    ${mapping_name}
    ${mapped}=    QuantrixLibrary.Get Mapped Term Name For Variable    ${mapping_name}
    run keyword if    '${mapped}' == '${EMPTY}'    fail    category was not mapped but should have been

Map Data Item and validate mapping
    [Arguments]    ${sheet_name}    ${mapping_name}
    [Documentation]    maps the selected data item (using type-ahead).
    ...
    ...    note: this will fail if ${mapping_name} does not subsequently have a mapping after the rename (this is more of a safety net to help identify issues rather than a general use case).
    Rename Variable Node With Type-ahead    ${sheet_name}    ${mapping_name}
    ${mapped}=    QuantrixLibrary.Get Mapped Term Name For Variable    ${mapping_name}
    run keyword if    '${mapped}' == '${EMPTY}'    fail    data item was not mapped but should have been

_Internal Select From Designer Menu
    [Arguments]    ${menu_string}
    [Documentation]    *Selects menu items from the Spreadsheet Designer menu bar*
    ...
    ...    - on Windows - uses the SwingLibrary to interact with the menu bar
    ...    - on OSX - uses AppleScript to interact with the menu bar
    ...
    ...    *Note: Uses the ${OPERATING_SYSTEM} variable to determine WINDOWS or OSX*
    ...
    ...    *Arguments*
    ...    - _menu_string_ - the menu string, pipe seperated in the same format as "Select From Menu" (e.g. "File|Save As...")
    ...
    ...    *Return Value*
    ...
    ...    _None_
    ...
    ...    *Preconditions*
    ...
    ...    The spreadsheet designer should be loaded before calling this keyword
    ...
    ...    *Example*
    ...    | Select From Designer Menu | _File|Save As..._ |
    #OSX implementation - AppleScript
    @{menu_list}=    Split String    ${menu_string}    |
    ${menu_args}=    Set Variable    "@{menu_list}[0]"
    ${menu_list_length}=    Get Length    ${menu_list}
    : FOR    ${index}    IN RANGE    1    ${menu_list_length}
    \    ${menu_args}=    Set Variable    ${menu_args} "@{menu_list}[${index}]"
    Run Keyword If    ('${OPERATING_SYSTEM}'=='OSX') and (len(${menu_list})==2)    OperatingSystem.Run    osascript "${CURDIR}/AppleScript/designer_menu.scpt" ${menu_args}
    Run Keyword If    ('${OPERATING_SYSTEM}'=='OSX') and (len(${menu_list})==3)    OperatingSystem.Run    osascript "${CURDIR}/AppleScript/designer_sub_menu.scpt" ${menu_args}
    Run Keyword If    ('${OPERATING_SYSTEM}'=='OSX') and not (2 <= len(${menu_list}) <=3)    Fail    Can only interact with menus and immediate sub-menus using available AppleScripts
    #Windows implementation - SwingLibrary
    Run Keyword Unless    '${OPERATING_SYSTEM}'=='OSX'    Select From Menu    ${menu_string}

Add Rows to Matrix
    [Arguments]    ${table}    ${RowsToAdd}
    [Documentation]    Takes the first cell in ${table} and press Enter ${RowsToAdd} times for new rows.
    Select First Cell in Matrix    ${table}
    Send Multiple Keyboard Events    VK_LEFT
    : FOR    ${element}    IN RANGE    ${RowsToAdd}
    \    Send Multiple Keyboard Events    VK_ENTER    #New Rows

_internal new matrix
    [Arguments]    ${sheet_name}=${EMPTY}
    [Documentation]    Creates a new matrix with the specified name.
    ...
    ...    *Arguments*
    ...
    ...    _sheet_name_ \ default: empty. specify a name if you want your matrix named something specific. \ Leave it blank to use the system generated name.
    ...
    ...
    ...    *Returns*
    ...
    ...    the actual name of the created sheet.
    # Ensure that the model browser is visible beforehand.
    Show Model Browser
    ${current_sheet_name}=    Get Selected Sheet Name    true
    # Sometimes the insert matrix button is not enabled because no context is selected, so select the browser if not enabled
    ${toolbar_button_enabled}    ${toolbar_button_enabled_message}=    Run Keyword And Ignore Error    Button Should Be Enabled    DocInsertMatrix
    Run Keyword If    '${toolbar_button_enabled}' == 'FAIL'    Click On Component    BrowserTree
    Push Button    DocInsertMatrix
    # we need to wait for quantrix to finish inserting the new sheet before we continue - easiest way to do that is to check the selected names over a period of time
    : FOR    ${loop}    IN RANGE    1    11
    \    sleep    0.3s
    \    ${status}    ${new_sheet_name}=    Run Keyword And Ignore Error    Get Selected Sheet Name    true
    \    run keyword if    '${new_sheet_name}' != '${current_sheet_name}'    exit for loop
    # make sure we haven't just timed out....
    Should Not Be Equal    ${new_sheet_name}    ${current_sheet_name}
    Run Keyword Unless    '${sheet_name}' == '${EMPTY}'    Rename Selected Sheet    ${sheet_name}
    Run Keyword Unless    '${sheet_name}' == '${EMPTY}'    sleep    200ms    # sleep to allow UI time to process rename
    ${actual_sheet_name}=    Get Selected Sheet Name    true
    [Return]    ${actual_sheet_name}    # returns the sheet name actually used

_internal open sheet from model browser
    [Arguments]    ${node_index}    ${clickCount}    ${sheet_name}    ${sheet_type}
    [Documentation]    *NOT FOR PUBLIC USE - INTERNAL API ONLY*
    ...
    ...    selects/opens the specified sheet index (using ${node_index}) from the model browser by clicking ${clickCount} times and then verifies the sheet is open based on the ${sheet_type} and ${sheet_name}
    ...
    ...
    ...    note: sheet_type must be one of the following \ (case senstitive values)
    ...
    ...    - MATRIX
    ...    - TABLEVIEW
    ...    - CHARTVIEW
    ...    - CANVAS
    ...    - ${EMPTY}
    ...
    ...    _leave it as ${empty} to perform no post-click validation_
    ...
    ...    *Assumptions*
    ...
    ...    the sheet must be present in the spreadsheet and that the node index matches the spreadsheet
    Click On Tree Node    BrowserTree    ${node_index}    ${clickCount}
    ${xpath}=    Set Variable If    '${sheet_type}' == 'MATRIX'    xpath=//*[@name="${sheet_name}"]//*[contains(@class, "MatrixGridBodyComponent")]    '${sheet_type}' == 'TABLEVIEW'    xpath=//*[@name="${sheet_name}"]//*[contains(@class, "MatrixGridBodyComponent")]    '${sheet_type}' == 'CHARTVIEW'
    ...    xpath=//*[@name="${sheet_name}"]//*[contains(@class, "FilterTrayComponent")]    '${sheet_type}' == 'CANVAS'    xpath=//*[@name="${sheet_name}"]//*[@name="ToggleInteractionButton"]    '${sheet_type}' == '${EMPTY}'    ${EMPTY}
    log    ${xpath}
    run keyword unless    '${xpath}' == '${EMPTY}'    wait until keyword succeeds    5s    1s    Component Should Be Visible    ${xpath}

Type to Matrix Cell
    [Arguments]    ${sheet_name}    ${row}    ${column}    ${cell_value}
    [Documentation]    Selects a cell in the spreadsheet designer and adds text
    Select First Cell in Matrix    ${sheet_name}
    Select Cell In Matrix    ${row}    ${column}
    Set Current Cell Value    ${sheet_name}    ${cell_value}

Insert or Create Spreadsheet
    [Arguments]    ${spreadsheet_name}    ${test_data_directory}    ${experiment_id}
    [Documentation]    Checks the given test data directory to see if a spreadsheet with the given name already exists. If it does, then it inserts it into the given experiment, otherwise it will create a blank spreadsheet.
    ...
    ...
    ...    *Args*:
    ...    - ${spreadsheet_name} - The name of the spreadsheet you wish to search for in the test data folder. Note that '.ewbss' is omitted.
    ...    - ${test_data_directory} - The path to the test data directory
    ...    - ${experiment} - The entity id of the experiment to create the spreadsheet in.
    ...
    ...
    ...    *Example Use*:
    ...
    ...
    ...    | ${experiment_id}= \ \ \ \ \ \ \ \ \ \ \ | *Create Experiment* | ${project_id} \ \ \ \ \ \ \ \ \ \ \ \ \ \ | My Experiment |
    ...    | *Insert or Create Spreadsheet* | ${TEST_NAME} \ \ \ \ \ \ \ \ \ | ${CURDIR}/Test Data | ${experiment_id} |
    ...
    ...
    ...    This example can be used a suite's test setup. At the beginning of each test, it will search for a spreadsheet in the current directory's test data folder that shares a name with the current test (e.g. 'Test Case 1.ewbss') and insert it to the given experiment if present. If not present, the keyword will add a blank spreadsheet instead.
    @{file_list}=    OperatingSystem.List Files In Directory    ${test_data_directory}
    ${has_bespoke_spreadsheet}=    Set Variable    ${EMPTY}
    #Loop through the listed files in Test Data, searching for the spreadsheet
    : FOR    ${file}    IN    @{file_list}
    \    ${has_bespoke_spreadsheet}=    Set Variable IF    '${file}' == '${spreadsheet_name}.ewbss'    True
    \    Exit For Loop If    '${has_bespoke_spreadsheet}' == 'True'
    Run Keyword If    '${has_bespoke_spreadsheet}' == 'True'    Insert Idbs Spreadsheet Document    ${experiment_id}    ${test_data_directory}/${spreadsheet_name}.ewbss
    Run Keyword If    '${has_bespoke_spreadsheet}' != 'True'    Create Idbs Spreadsheet Document    ${experiment_id}

Set Text In Expression Widget Field
    [Arguments]    ${expression_widget_name}    ${text}    ${parent_component_xpath}=${EMPTY}
    [Documentation]    Inserts text into the text field of an expression widget using the Swing Library 'Insert Into Text Field' keyword.
    ...
    ...    *Arguments*
    ...    - expression_widget_name - the name of the expression widget
    ...    - text - the text to insert into the expression widget
    ...    - parent_component_xpath - the parent of the expression widget, optional addition to be used when you need to be specific about which expression widget you are refereing too e.g. when the expression widget has a generic name.
    ...
    ...    *Example Use*:
    ...
    ...    | *Set Text In Expression Widget Field* | FIT_TITLE_PICKER | My Fit Title |
    ...
    ...    Will set the text in the text field of the FIT_TITLE_PICKER expression widget to "My Fit Title"
    ...    |
    ...
    ...    | *set Text In Expression Widget Field* | FIT_TITLE_PICKER | My Fit Title | xpath=//*[@name="FIT_TITLE_PANEL"] |
    ...
    ...    Will set the text in the text field of the FIT_TITLE_PICKER expression widget which is the child of FIT_TITLE_PANEL to "My Fit Title".
    ${xpath}=    _get expression widget text field xpath    ${expression_widget_name}
    ${xpath}=    Set Variable If    '${parent_component_xpath}'    ${parent_component_xpath}${xpath}    xpath=${xpath}
    Wait Until Keyword Succeeds    20s    500ms    Component Should Be Visible    ${xpath}
    Wait Until Keyword Succeeds    20s    500ms    Insert Into Text Field    ${xpath}    ${text}

Get Text From Expression Widget Field
    [Arguments]    ${expression_widget_name}
    [Documentation]    Gets text from the text field of an expression widget using the Swing Library 'Get Text Field Value'' keyword.
    ...
    ...    *Arguments*
    ...    - expression_widget_name - the name of the expression widget
    ...
    ...    *Returns*
    ...    - text - the retrieved text
    ...
    ...    *Example Use*:
    ...
    ...    | ${text}= | *Get Text From Expression Widget Field* | FIT_TITLE_PICKER |
    ...
    ...    Will get the text in the text field of the FIT_TITLE_PICKER expression widget.
    ${xpath}=    _get expression widget text field xpath    ${expression_widget_name}
    Wait Until Keyword Succeeds    20s    500ms    Component Should Be Visible    xpath=${xpath}
    ${text}=    Wait Until Keyword Succeeds    20s    500ms    IDBSSwingLibrary.Get Text Field Value    xpath=${xpath}
    [Return]    ${text}

Clear Text In Expression Widget Field
    [Arguments]    ${expression_widget_name}
    [Documentation]    Clears text in the text field of an expression widget using the Swing Library 'Clear Text Field' keyword.
    ...
    ...    *Arguments*
    ...    - expression_widget_name - the name of the expression widget
    ...
    ...    *Example Use*:
    ...
    ...    | *Clear Text In Expression Widget Field* | FIT_TITLE_PICKER |
    ...
    ...    Will clear the text in the text field of the FIT_TITLE_PICKER expression widget.
    ${xpath}=    _get expression widget text field xpath    ${expression_widget_name}
    Wait Until Keyword Succeeds    20s    500ms    Component Should Be Visible    xpath=${xpath}
    Wait Until Keyword Succeeds    20s    500ms    Clear Text Field    xpath=${xpath}

Cell Value Should Equal
    [Arguments]    ${cell}    ${expected}
    [Documentation]    Compares the value retrieved from a given cell reference with a given expected value and fails if the results differ. Primarily created to be used in conjunction with 'Wait Until Keywords Succeeds' to allow leeway for situations where the cell value might not have been immediately updated.
    ...
    ...    *Arguments*
    ...    - cell - Quantrix style cell reference
    ...    - expected - The expected value of the cell
    ${result}=    QuantrixLibrary.Get Cell Value    ${cell}
    Should Be Equal    ${result}    ${expected}

Matrix Formula Count Should Equal
    [Arguments]    ${matrix}    ${expected_count}
    [Documentation]    Compares the formula count retrieved from a given matrix with a given expected formula count and fails if the results differ. Primarily created to be used in conjunction with 'Wait Until Keywords Succeeds' to allow leeway for situations where the formula count might not have been immediately updated.
    ...
    ...    *Arguments*
    ...    - matrix - Name of the matrix, e.g Table1
    ...    - expected_count - The expected formula count of the matrix
    ...
    ...    *Example Uses*
    ...    | *Matrix Formula Count Should Equal* | Table1 | 2 |
    ...
    ...    | *Wait Until Keyword Succeeds* | 5s | 500ms | *Matrix Formula Count Should Equal* | Table1 | 2 |
    ${count}=    QuantrixLibrary.Get Matrix Formula Count    ${matrix}
    Should Be Equal As Integers    ${count}    ${expected_count}

Matrix Formula Should Equal
    [Arguments]    ${matrix}    ${formula_index}    ${expected formula}
    [Documentation]    Compares the formula retrieved from a given index of a given matrix with a given expected formula and fails if the results differ. Primarily created to be used in conjunction with 'Wait Until Keywords Succeeds' to allow leeway for situations where the formula might not have been immediately updated.
    ...
    ...    *Arguments*
    ...    - matrix - Name of the matrix, e.g Table1
    ...    - formula_index - the index of the formula (starts at 0)
    ...    - expected_formula - The expected formula to be found
    ...
    ...    *Example Uses*
    ...    | *Matrix Formula Should Equal* | Table1 | 0 | Table1:Data1-1:B1 = 1 |
    ...
    ...    | *Wait Until Keyword Succeeds* | 3s | 250ms | *Matrix Formula Should Equal* | Table1 | 0 | Table1:Data1-1:B1 = 1 |
    ${actual_formula}=    QuantrixLibrary.Get Matrix Formula    ${matrix}    ${formula_index}
    Should Be Equal    ${actual_formula}    ${expected formula}

_get expression widget text field xpath
    [Arguments]    ${expression_widget_name}
    [Documentation]    Given the name of an expression widget, returns the xpath to its text field. Private function used by the Get, Set and Clear text keywords for expression widgets.
    ${prefix}=    Set Variable    //*[contains(@name,'
    ${suffix}=    Set Variable    ')]//*[contains(@class,'ExpressionWidget')]
    ${xpath}=    Set Variable    ${prefix}${expression_widget_name}${suffix}
    [Return]    ${xpath}

Send Multiple Keyboard Events
    [Arguments]    @{keyboard_events}
    [Documentation]    Uses a FOR loop to send keyboard events spaced with a 500ms delay. The reason this was created was to avoid issues caused by keyboard events being sent too quickly for the designer to react to them.
    ${ke_list}=    Create List    @{keyboard_events}
    ${length}=    Get Length    ${ke_list}
    : FOR    ${i}    IN RANGE    ${length}
    \    Send Keyboard event    ${ke_list[${i}]}
    \    Sleep    500ms    # Sending key events too quickly doesn't always register

Wait Until Component Is Visible
    [Arguments]    ${component}    ${timeout}=10s
    [Documentation]    Wrapper for Component Should Be Visible that allows overriding of the Jemmy timeout (defaults to 10 seconds).
    ...
    ...    *Arguments*
    ...    - ${timeout} - in seconds.
    ...
    ...    *e.g.*
    ...    | *Wait Until Component Is Visible* | myComponent | 20 |
    ${original_timeout}=    Set Jemmy Timeout    ComponentOperator.WaitComponentTimeout    1    # The jemmy timeout will take precedence over the Wait timeout, so we set it very small here. This is particularly worthwhile since the default jemmy timeout is 10 seconds, so we could be waiting a lot longer than we need to.
    Wait Until Keyword Succeeds    ${timeout}    1s    Component Should Be Visible    ${component}    # The jemmy timeout will only wait for the component to exist; it doesn't care about visibility, so we need to wrap Should be Visible in a Wait Until Succeeds.
    Set Jemmy Timeout    ComponentOperator.WaitComponentTimeout    ${original_timeout}    # Reset the jemmy timeout to whatever it was before, so we're not disturbing other activity

Wait Until Component Is Not Visible
    [Arguments]    ${component}    ${timeout}=10
    [Documentation]    Wrapper for Component Should Be Visible that allows overriding of the Jemmy timeout (defaults to 10 seconds).
    ...
    ...    *Arguments*
    ...    - ${timeout} - in seconds.
    ...
    ...    *e.g.*
    ...    | *Wait Until Component Is Not Visible* | myComponent | 20 |
    ${original_timeout}=    Set Jemmy Timeout    ComponentOperator.WaitComponentTimeout    1    # The jemmy timeout will take precedence over the Wait timeout, so we set it very small here. This is particularly worthwhile since the default jemmy timeout is 10 seconds, so we could be waiting a lot longer than we need to.
    Wait Until Keyword Succeeds    ${timeout}    1s    Component Should Not Be Visible    ${component}    # The jemmy timeout will only wait for the component to exist; it doesn't care about visibility, so we need to wrap Should not be Visible in a Wait Until Succeeds.
    Set Jemmy Timeout    ComponentOperator.WaitComponentTimeout    ${original_timeout}    # Reset the jemmy timeout to whatever it was before, so we're not disturbing other activity

Wait Until Component Has Visible Flag
    [Arguments]    ${component}    ${jemmy_override}=10
    [Documentation]    Wrapper for Component Should Have Visible Flag. Useful in situations where the 'Visible' check and 'Visible' flag return different results. Allows overriding of the default jemmy timeout of 10 seconds
    ${original_timeout}=    Set Jemmy Timeout    ComponentOperator.WaitComponentTimeout    ${jemmy_override}
    Component Should Have Visible Flag    ${component}
    Set Jemmy Timeout    ComponentOperator.WaitComponentTimeout    ${original_timeout}

Wait Until Component Does Not Have Visible Flag
    [Arguments]    ${component}    ${jemmy_override}=10
    [Documentation]    Wrapper for Component Should Not Have Visible Flag. Useful in situations where the 'Visible' check and 'Visible' flag return different results. Allows overriding of the default jemmy timeout of 10 seconds
    ${original_timeout}=    Set Jemmy Timeout    ComponentOperator.WaitComponentTimeout    ${jemmy_override}
    Component Should Not Have Visible Flag    ${component}
    Set Jemmy Timeout    ComponentOperator.WaitComponentTimeout    ${original_timeout}

Matrix Formula Count Should Not Equal
    [Arguments]    ${matrix}    ${expected_count}
    [Documentation]    Compares the formula count retrieved from a given matrix with a given expected formula count and fails if the results do not differ. Primarily created to be used in conjunction with 'Wait Until Keywords Succeeds' to allow leeway for situations where the formula count might not have been immediately updated.
    ...
    ...    *Arguments*
    ...    - matrix - Name of the matrix, e.g Table1
    ...    - expected_count - The expected formula count of the matrix
    ...
    ...    *Example Uses*
    ...    | *Matrix Formula Count Should Not Equal* | Table1 | 2 |
    ...
    ...    | *Wait Until Keyword Succeeds* | 5s | 500ms | *Matrix Formula Count Should Not Equal* | Table1 | 2 |
    ${count}=    QuantrixLibrary.Get Matrix Formula Count    ${matrix}
    Should Not Be Equal As Integers    ${count}    ${expected_count}

Clear Cell in Matrix
    [Arguments]    ${cell_x}    ${cell_y}
    [Documentation]    Clears the given cell in the currently selected matrix by selecting it with the QuantrixLibrary and sending a VK_DELETE
    Select Cell In Matrix    ${cell_x}    ${cell_y}
    Send Keyboard Event    VK_DELETE

Capture Designer Screenshot and Fail
    [Arguments]    ${failure_message}
    [Documentation]    Takes a screenshot of the java application currently connected to by the Swing library and then fails with the given message.
    ...
    ...
    ...    This keyword takes a failure message as an argument, which will be included in the log when the failure occurs.
    Capture Designer Screenshot
    Fail    ${failure_message} - For the screenshot, expand 'Capture Swing Screenshot and Fail' > 'Capture Swing Screenshot' > 'Run Keyword and Ignore Error' > 'Component Should Exist' > 'Component Should Exist' in the log.

Capture Designer Screenshot
    [Documentation]    Takes a screenshot of the java application currently connected to by the Swing library. Since there is no library keyword for this, it is achieved by running 'component should be visible' for an invalid locator.
    Run Keyword and Ignore Error    Enable Taking Screenshots On Failure    # Just in case it's off
    Run Keyword And Ignore Error    Component Should Exist    supercalifragilisticexpialidocious    1    #Super quick timeout because this \ should always fail

Close Any Open Exceptions
    ${exception_dialog_present}=    Run Keyword And Return Status    Select Dialog    ${exception_dialog_id}    2
    Run Keyword If    ${exception_dialog_present}    Click on Component    ${close_window_button}

Accept Current Suggestion from Type Ahead Editor
    [Arguments]    ${sheet_name}
    [Documentation]    Some logic to accept the current type ahead editor suggestion by hitting VK_ENTER, then expecting the type ahead editor to be closed. Runs within a FOR loop and tries several times to cover cases where the type ahead editor occasionally fails to close.
    # Close the Type Ahead Editor
    Send Multiple Keyboard Events    VK_ENTER    # We know it has to happen at least once, so sending this now speeds things up a little
    : FOR    ${i}    IN RANGE    10
    \    ${still_visible}=    Run Keyword And Return Status    Wait Until Component Is Visible    xpath=//*[@name='${sheet_name}']//*[contains(@class,'TypeAheadEditor')]    1    # Type Ahead Editor
    \    Run Keyword Unless    ${still_visible}    Exit For Loop    # Handles the case where editor is dismissed between the end of one iteration and the start of another
    \    Send Multiple Keyboard Events    VK_ENTER
    \    ${dismissed}=    Run Keyword and Return Status    Wait Until Component Is Not Visible    xpath=//*[@name='${sheet_name}']//*[contains(@class,'TypeAheadEditor')]    1    # Type Ahead Editor
    \    Exit For Loop If    ${dismissed}    # Once it's gone, we're done here.
    Run Keyword If    ${still_visible}    Fail    Type Ahead Editor failed to close
    # Close the cell editor
    ${cell_editor_xpath}=    Get Cell Editor xPath    ${sheet_name}
    : FOR    ${i}    IN RANGE    10
    \    ${still_visible}=    Run Keyword And Return Status    Wait Until Component Is Visible    ${cell_editor_xpath}    1
    \    Run Keyword Unless    ${still_visible}    Exit For Loop    # Handles the case where editor is dismissed between the end of one iteration and the start of another
    \    Send Multiple Keyboard Events    VK_ENTER
    \    ${still_visible}=    Run Keyword and Return Status    Wait Until Component Is Not Visible    ${cell_editor_xpath}    1
    \    Run Keyword Unless    ${still_visible}    Exit For Loop
    Run Keyword If    ${still_visible}    Fail    Cell Editor failed to close

Get Cell Editor xPath
    [Arguments]    ${sheet_name}
    ${xpath}=    Set Variable    xpath=//*[@name='${sheet_name}']//*[@name='CellEditor']
    [Return]    ${xpath}

Dismiss Launch Dialog
    Click Button    xpath=//*[@class='ewb-button close-button']

Select Node from Tree
    [Arguments]    ${tree_name}    ${node_name}
    [Documentation]    Selects a node from a tree and confirms it has been selected. Tries 5 times, following which it fails if still unselected.
    Tree Node Should Exist    ${tree_name}    ${node_name}
    : FOR    ${i}    IN RANGE    5
    \    Click On Tree Node    ${tree_name}    ${node_name}
    \    ${selected}=    Run Keyword And Return Status    Wait Until Keyword Succeeds    3s    1s    Tree Node Should Be Selected
    \    ...    ${tree_name}    ${node_name}
    \    Exit For Loop If    ${selected}
    \    Sleep    2s
    Run Keyword Unless    ${selected}    Capture Designer Screenshot and Fail    Tree node ${node_name} was not selected from tree ${tree_name} after 5 attempts.

Click Tree Node and Ensure Selected
    [Arguments]    ${tree}    ${node}    ${attempts}=5    ${retry_interval}=2s
    [Documentation]    Clicks on a tree node and ensures it is selected.
    : FOR    ${i}    IN RANGE    ${attempts}
    \    Click On Tree Node    ${tree}    ${node}
    \    ${selected}=    Run Keyword and Return Status    Tree Node Should Be Selected    ${tree}    ${node}
    \    Exit For Loop If    ${selected}
    \    Sleep    ${retry_interval}

Spreadsheet Should Be Dirty
    ${window_title}=    get selected window title
    ${start_char}=    Get Substring    ${window_title}    0    1
    Should Be Equal As Strings    ${start_char}    *

Close Current Window
    Click on Component    xpath=//*[contains(@class,'SubxComponent')]    #Click on the 'X' button to close the window

Delete First Row of Matrix
    [Arguments]    ${matrix_name}
    [Documentation]    Deletes the first row in a matrix by clicking on the first cell, then sending VK_LEFT and VK_DELETE keyboard events. Note that this will only work if the matrix contains more than one row.
    Select First Cell In Matrix    ${matrix_name}
    Send Multiple Keyboard Events    VK_LEFT    VK_DELETE

Set Spreadsheet Designer Open Flag
    [Arguments]    ${true_or_false}    # Boolean
    Set Suite Variable    ${SPREADSHEET_DESIGNER_OPEN}    ${true_or_false}

Connect to Spreadsheet Designer
    [Arguments]    ${file_name}=${EMPTY}
    ${connected}=    Run Keyword And Return Status    RobotRemoteAgent.Connect To Java Application    ${weblaunch_alias}
    Run Keyword Unless    ${connected}    Capture Page Screenshot    # If we can't connect, we need to find out why
    Run Keyword Unless    ${connected}    Fail    Failed to make the connection to the spreadsheet designer.
    # load libraries
    Initialise Spreadsheet and select window    ${file_name}

Swing Text Field Text Should Equal
    [Arguments]    ${locator}    ${expected}
    [Documentation]    Checks if ${expected} text is present in the ${locator} text field.
    ${actual}=    IDBSSwingLibrary.Get Text Field Value    ${locator}
    Should Be Equal    ${actual}    ${expected}

Designer Single Session Suite Setup
    [Arguments]    ${entity_prefix}    ${spreadsheet_file}=${EMPTY}
    [Documentation]    Suite Setup for a single designer session test suite. Where possible, it is preferred to use a single designer session over multiple designer sessions, as this runs much faster. It is recommended that the single session keywords are used in conjunction with additional checks during test teardowns to ensure that the designer is returned to a clean state.
    ...
    ...    Creates the entity hierarchy for the test, navigates to the new experiment and opens a new spreadsheet in the designer.
    ...
    ...    This setup allows the user to specify a spreadsheet in the second argument that will be inserted if present. Otherwise a fresh spreadsheet will be created.
    Create Experiment and Hierarchy    ${entity_prefix}
    # experiment id and url generated in previous keyword
    Run Keyword If    '${spreadsheet_file}'    Insert Idbs Spreadsheet Document    ${experiment_id}    ${spreadsheet_file}    ELSE    EntityAPILibrary.Create Idbs Spreadsheet Document
    ...    ${experiment_id}
    Weblaunch Open Browser to Page    ${experiment_url}    ${VALID USER}    ${VALID PASSWD}
    # start designer
    Start Weblaunch    ${DATA_ENTRY_SPREADSHEET_REGEX}
    Maximize Window    ${DATA_ENTRY_SPREADSHEET_REGEX}

Designer Single Session Test Setup
    [Documentation]    Test Setup for a single designer session test suite. Where possible, it is preferred to use a single designer session over multiple designer sessions, as this runs much faster. It is recommended that the single session keywords are used in conjunction with additional checks during test teardowns to ensure that the designer is returned to a clean state.
    ...
    ...    Saves the spreadsheet. This avoids auto-save interruptions in long running suites.
    # save the spreadsheet so that we aren't interrupted by auto-save during a potentially long running suite
    Save WebLaunch Spreadsheet

Designer Single Session Suite Teardown
    [Documentation]    Suite Teardown for a single designer session test suite. Where possible, it is preferred to use a single designer session over multiple designer sessions, as this runs much faster. It is recommended that the single session keywords are used in conjunction with additional checks during test teardowns to ensure that the designer is returned to a clean state.
    ...
    ...    Closes spreadsheet designer, all browsers and attempts to delete all entities.
    Run Keyword If    ${SPREADSHEET_DESIGNER_OPEN}    Shut down weblaunch    # If we failed mid-test, shutdown here.
    Run Keyword And Ignore Error    Kill All Spreadsheet Designer Sessions    # If shutdown failed again, kill it
    Run Keyword And Ignore Error    Unlock Test Experiment
    Suite Teardown
    Delete Hierarchy

Designer Single Session Test Teardown
    [Documentation]    Test Teardown for a single designer session test suite. Where possible, it is preferred to use a single designer session over multiple designer sessions, as this runs much faster. It is recommended that the single session keywords are used in conjunction with additional checks during test teardowns to ensure that the designer is returned to a clean state.
    Close Any Open Exceptions    # In single designer instance tests, exceptions thrown in one test case can fail an entire suite. This keyword ensures that exceptions thrown are closed before continuing.
    # Recommend using this keyword in conjunction with additional checks similar to the above in order to ensure that the spreadsheet is returned to a clean state.

Designer Multi Session Suite Setup
    [Arguments]    ${entity_prefix}
    [Documentation]    Suite Setup for a multi designer session test suite. Where possible, it is preferred to use a single designer session as that runs much faster. \ creates the entity hierarchy for the test and opens the browser to the project. ${entity_prefix} is used to name the project and groups.
    Create Hierarchy For Experiments    ${entity_prefix}
    Designer Open Browser To Entity    ${project_id}    # Created in the previous keyword

Designer Multi Session Suite Teardown
    [Documentation]    Suite Teardown for a multi designer session test suite. Where possible, it is preferred to use a single designer session as that runs much faster. \ Closes all browsers and deletes all entities.
    Suite Teardown
    Delete Hierarchy

Designer Multi Session Test Setup
    [Arguments]    ${entity_prefix}    ${spreadsheet_file}=${EMPTY}    ${go_to_experiment}=${True}    ${open_spreadsheet}=${True}
    [Documentation]    Test Setup for a multi designer session test suite. Where possible, it is preferred to use a single designer session as that runs much faster. \ Creates a new experiment and adds a spreadsheet. If supplied, a test data spreadsheet will be inserted. Otherwise a fresh spreadsheet will be created. The experiment and spreadsheet are then opened in the designer.
    Force Page Reload
    Create Test Experiment    ${entity_prefix}
    # experiment id and url generated during previous keyword
    ${spreadsheet_id}=    Run Keyword If    '${spreadsheet_file}'    EntityAPILibrary.Insert Idbs Spreadsheet Document    ${experiment_id}    ${spreadsheet_file}    ELSE
    ...    EntityAPILibrary.Create Idbs Spreadsheet Document    ${experiment_id}
    Set Test Variable    ${spreadsheet_id}
    # Go to experiment if desired
    Run Keyword If    ${go_to_experiment}    Go To Experiment    ${experiment_id}
    # If go to experiment is false, then we can't open the spreadsheet, so handle that impossible scenario here
    ${open_spreadsheet}    Set Variable If    not ${go_to_experiment}    ${False}    ${open_spreadsheet}
    # start designer if desired
    Run Keyword If    ${open_spreadsheet}    Start Weblaunch    ${DATA_ENTRY_SPREADSHEET_REGEX}

Designer Multi Session Test Teardown
    [Arguments]    ${spreadsheet_save_option}=No    ${record_save_option}=NONE    # Must be Yes, No or Cancel for spreadsheet; VERSION, DRAFT or DISCARD are the options for record - anything else will do nothing (e.g. NONE).
    [Documentation]    Test Teardown for a multi designer session test suite. Where possible, it is preferred to use a single designer session as that runs much faster. \ Shuts down the designer and if necessary kills any processes that fail to close. Discards changes to the experiment and unlocks it.
    # If open, close the designer. If still open after that, kill the designer process.
    Run Keyword If    ${SPREADSHEET_DESIGNER_OPEN}    Shut down weblaunch    ${spreadsheet_save_option}
    Run Keyword If    ${SPREADSHEET_DESIGNER_OPEN}    Kill All Spreadsheet Designer Sessions
    # Depending on preference, save or don't
    run keyword if    '${record_save_option}' == 'DISCARD'    Run Keyword And Ignore Error    Discard Changes to Record
    run keyword if    '${record_save_option}' == 'DRAFT'    run keyword and ignore error    Draft Save Record
    run keyword if    '${record_save_option}' == 'VERSION'    Run Keyword And Ignore Error    Version Save Record    ${VALID USER}    ${VALID PASSWD}    saving data
    # Unlock the experiment
    Run Keyword And Ignore Error    Unlock Test Experiment

Expression Widget Text Should Equal
    [Arguments]    ${locator}    ${expected_text}
    [Documentation]    Ensures that an Expression Widget's Text Field contains the expected text. You will likely need to use the GUI Inspector in order to find the locator required.
    ...
    ...    Example use:
    ...
    ...    | *Expression Widget Text Field Should Contain* | MY_EXPRESSION_WIDGET | My Expected Text |
    ${actual_text}=    Get Text From Expression Widget Field    ${locator}
    Should Be Equal    ${actual_text}    ${expected_text}

Wait Until Component Does Not Exist
    [Arguments]    ${locator}    ${timeout}=10s
    [Documentation]    Waits until a component does not exist, overriding the jemmy timeout in order to ensure we don't get stuck waiting for it.
    ...
    ...    *Example Uses*
    ...
    ...    By default, it will wait up to ten seconds for a component to stop existing:
    ...    | *Wait Until Component Does Not Exist* | MY_COMPONENT |
    ...
    ...
    ...    This will wait up to a minute for a component to \ stop existing:
    ...    | *Wait Until Component Does Not Exist* | MY_COMPONENT | 1m |
    Wait Until Keyword Succeeds    ${timeout}    1s    Component Should Not Exist    ${locator}    1    # Set a super short jemmy timeout to ensure it doesn't take too long to fail

Select Column In Matrix
    [Arguments]    ${table_name}    ${column_index}
    [Documentation]    Selects a specific column in matrix.
    ...
    ...    Column index refers to how far to the right the intended column is.
    ...
    ...    *Example*
    ...
    ...    If your intended column is 3 in from the left then the column index would be 2 (the first column is zero indexed).
    Select First Column in Matrix    ${table_name}
    : FOR    ${i}    IN RANGE    ${column_index}
    \    Send Multiple Keyboard Events    VK_RIGHT

Combo Box Selected Item Should Be
    [Arguments]    ${combo_box_id}    ${selected_item}
    [Documentation]    Confirms that a given item in a combo box is slected.
    ${selected}    Get Selected Item From Combo Box    ${combo_box_id}
    Should Be Equal    ${selected}    ${selected_item}

Label text should contain
    [Arguments]    ${label_id}    ${expected_text}
    [Documentation]    Checks that the given label (label_id) text contains (expected text)
    ${label_content}    Get Label Content    ${label_id}
    Should Contain    ${label_content}    ${expected_text}

Close E-WorkBook Options Dialog
    [Documentation]    Closes the Tools > E-WorkBook Options dialog in the spreadsheet designer
    Close Dialog    E-WorkBook Options

Open E-WorkBook Options Dialog
    [Documentation]    Opens the Tools > E-WorkBook Options dialog in the spreadsheet designer
    Select From Designer Menu    Tools|E-WorkBook Options...
    Activate Dialog    E-WorkBook Options
