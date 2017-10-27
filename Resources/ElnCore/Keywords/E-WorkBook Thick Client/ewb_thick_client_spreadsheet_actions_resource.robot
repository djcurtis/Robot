*** Settings ***
Library           String
Library           Collections
Resource          ../../../Resources/ElnCore/Keywords/Common/common_resource.robot
Resource          ewb_thick_client_document_entity_actions_resource.robot
Library           IDBSSwingLibrary
Library           RobotRemoteAgent

*** Variables ***
${rowHeader}      class=SheetRowHeaderComponent
${columnHeader}    class=SheetColumnHeaderComponent
${cellBody}       class=SheetBodyComponent
${modelBrowser}    class=ModelBrowserTree
@{AuditColumnHeaders}    Sequence    Date    Time    Server Date/Time    User    Type    Description
...               Sheet    Source    Comment

*** Keywords ***
Add Audit Comment
    [Arguments]    ${auditComment}
    [Documentation]    Selects the add audit comment from the tools menu and inserts the added text.
    ...
    ...    *Arguments*
    ...    _auditComment_ The text you wish to comment on the audit log record with
    ...
    ...    *Preconditions*
    ...    Ensure that the relevant audit record is selected ini the audit log table
    ...
    ...    *Return Value*
    ...    _none_
    ...
    ...    *Example*
    ...
    ...    | Add Audit Comment | myComment |
    Select From Menu    Tools|Auditing|Add Audit Comment
    Select Dialog    Enter audit comment
    Insert Into Text Field    AUDITCOMMENT    ${auditComment}
    Push Button    text=OK

Change Cell Value in Visible Table
    [Arguments]    ${table_name}    ${row}    ${column}    ${new_value}
    [Documentation]    Selects a cell in the table and enters new values into the cell
    ...
    ...    *Arguments*
    ...
    ...    _table_name_
    ...    The table name
    ...
    ...    _row_
    ...    The row identifier
    ...
    ...    _column_
    ...    The column identifier
    ...
    ...    _new_value_
    ...    The value you wish to enter into the cell
    ...
    ...    *Preconditions*
    ...    The table must be visible and editable
    ...
    ...    *Return Value*
    ...    _none_
    ...
    ...    *Example*
    ...
    ...    | Change Cell Value in Visible Table | Table1 | B1 | Data1 | _value_ |
    Click On Component at Coordinates    xpath=//*[@name='${table_name}' and contains(@class,'AbstractModelDocumentViewUI$QInternalFrame')]//*[@name='Body']    10    10
    Select Context    xpath=//*[@name='${table_name}' and contains(@class,'AbstractModelDocumentViewUI$QInternalFrame')]
    : FOR    ${current_row}    IN RANGE    ${row}
    \    Send Keyboard Event    VK_DOWN
    : FOR    ${current_row}    IN RANGE    ${column}
    \    Send Keyboard Event    VK_RIGHT
    Type To Component    xpath=//*[@name='${table_name}' and contains(@class,'AbstractModelDocumentViewUI$QInternalFrame')]    ${new_value}
    Send Keyboard Event    VK_ENTER    # Hit enter key to get Spreadsheet to refresh

Check Audit Values
    [Arguments]    ${file}    ${user}    ${type}    ${description}    ${comment}
    [Documentation]    Checks the last most row of the audit log when given the CSV file from an exported table
    ...
    ...    Doesn't check date, time, server date/time, sheet & source
    ...
    ...    *Arguments*
    ...
    ...    _file_
    ...    The file string of the audit log in CSV format, exported from the audit table
    ...
    ...    _user_
    ...    The user responsible for the auditing event
    ...
    ...    _type_
    ...    The type of auditing event
    ...
    ...    _description_
    ...    The description of the auditing event
    ...
    ...    _comment_
    ...    Any auditing comment added to the event
    ...
    ...    *Preconditions*
    ...    The audit table should have been exported and the string of the file passed to this keyword
    ...
    ...    *Return Value*
    ...    _none_
    ...
    ...    *Example*
    ...
    ...
    ...    | ${auditFile}= | Export Table | Audit Log | Audit Log | ${uniqueID} | ${TEMPDIR} |
    ...    | ${auditfileString}= | Get File | ${TEMPDIR}${\}${auditFile}.csv |
    ...    | Check Audit Values | \ ${auditfileString} | Administrator | Sheet Added | Sheet Table4 added | _user comment_ |
    @{AuditRowValues}=    _Get Final Row from Export    ${file}
    Should Be Equal    @{AuditRowValues}[4]    ${user}
    Should Be Equal    @{AuditRowValues}[5]    ${type}
    Should Be Equal    @{AuditRowValues}[6]    ${description}
    Should Be Equal    @{AuditRowValues}[9]    ${comment}

Close spreadsheet
    [Documentation]    Closes current spreadsheet
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    Assumes the Spreadsheet window has context
    ...
    ...    *Example*
    ...    | Close current spreadsheet |
    IDBSSwingLibrary.Close Window    regexp=.*Spreadsheet

Export Table
    [Arguments]    ${tableName}    ${tablePath}    ${uniqueIdentifier}    ${filePath}
    [Documentation]    Selects a table from the document browser and exports the table as a .CSV file to a folder destination
    ...
    ...    *Arguments*
    ...
    ...    _tableName_
    ...    The name of the table you wish to export
    ...
    ...    _tablePath_
    ...    The path of the table you wish to select as given in the document browser, excluding ROOT, separated by a pipe
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
    ...    | ${fileName}= | Export Table | Table1 | Folder1\|Table1 | ${uniqueID} | ${TEMPDIR} |
    Select Table from Document Browser    ${tableName}    ${tablePath}
    Select From Menu    File|Export|Delimited Text File...
    Sleep    1s
    Select Dialog    Export Delimited Text Data File
    Push Button    Next >
    Select Dialog    Export Delimited Text Data File
    Select From Combo Box    delimiter-combo    Pipe (|)
    Sleep    1s
    Push Button    Finish
    Choose From File Chooser    ${filePath}${/}${tableName}_${uniqueIdentifier}
    ${exportCSVName}=    Set Variable    ${tableName}_${uniqueIdentifier}
    [Return]    ${exportCSVName}

Get Column Items
    [Arguments]    ${CSVFile}
    ${column}=    Fetch From Left    ${CSVFile}    \n
    @{Coulmntems}=    Split String    ${column}    \|
    log    @{Coulmntems}
    [Return]    @{Coulmntems}

Get Headers from Export
    [Arguments]    ${CSVFile}
    [Documentation]    Takes a string from 'Get File' keyword and removes the first line(\ ) and splits into a list seperating on commas. List is returned.
    ...
    ...    *Arguments*
    ...
    ...    _CSVfile_
    ...    The name of the table you wish to export
    ...
    ...    *Preconditions*
    ...    Ensure that the Table has been exported as CSV
    ...
    ...    *Return Value*
    ...    _@{headers}_
    ...    The column headers of the exported CSV file, returned as a list
    ...
    ...    *Example*
    ...
    ...    | ${fileName}= | Export Table | Table1 | Folder1\|Table1 | ${uniqueID} | ${TEMPDIR} |
    ...    | ${fileString}= | Get File | ${TEMPDIR}${\}${fileName}.csv |
    ...    | @{headers}= | Get Headers from Export | \ ${fileString} |
    ...    | List Should be Equal | @{headers} | @{checkList} |
    ${headers}=    Fetch From Left    ${CSVFile}    \n
    @{headers}=    Split String    ${headers}    \|
    log    ${headers}
    [Return]    @{headers}

Insert New Table
    [Documentation]    Inserts a new table via the toolbar button
    ...
    ...    *Arguments*
    ...
    ...    _none_
    ...
    ...    *Preconditions*
    ...    Spreadsheet must be open
    ...
    ...    *Return Value*
    ...    _none_
    ...
    ...    *Example*
    ...
    ...    | Insert New Table |
    Push Button    xpath=//button[@tooltip='Insert Table']

Open Spreadsheet in current Experiment
    [Arguments]    ${item_type}    ${caption}
    [Documentation]    Opens an existing spreadsheet from a record and selects the window.
    ...
    ...    *Arguments*
    ...
    ...    _item_type_
    ...    The spreadsheet item type
    ...
    ...    _caption_
    ...    The spreadsheets caption, usually the file name
    ...
    ...    *Preconditions*
    ...    That a spreadheet must be present in the record
    ...
    ...    *Return Value*
    ...    _none_
    ...
    ...    *Example*
    ...
    ...    | Open Spreadsheet in current Experiment | Data Entry: | spreadsheet.bss |
    Double-click on document in current experiment    ${item_type}    ${caption}
    Select Window    regexp=.*Spreadsheet    180

Rename spreadsheet table
    [Arguments]    ${table_path}    ${table_name}    ${new_table_name}
    [Documentation]    Renames a table within the document browser
    ...
    ...    *Arguments*
    ...
    ...    _table path_
    ...
    ...    the path for the table, if the table is not under a folder then just type the table name here, if there is a folder(s) then type folder name/table name
    ...
    ...    _table name_
    ...
    ...    the current name of the table you wish to change
    ...
    ...    _new table name_
    ...
    ...    the name you wish to change the table name to
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Precondition*
    ...    Selected the open spreadsheet that contains the table you wish to rename
    ...
    ...    *Example*
    ...    | Rename spreadsheet table | ${table path} | ${table name} | ${new table name} |
    ...    | Rename spreadsheet table | Folder1/Table1 | Table1 | Renamed |
    Select Window    regexp=.*Spreadsheet
    ${document_browser_exists}    ${document_browser_exists_message}=    Run Keyword And Ignore Error    Component Should Have Visible Flag    xpath=//*[@name='Document Browser' and contains(@class,'AbstractModelDocumentViewUI$QInternalFrame')]
    Run Keyword If    '${document_browser_exists}'=='FAIL'    Select From Menu    View|Document Browser
    Click On Component At Coordinates    xpath=//*[@name='Document Browser' and contains(@class,'AbstractModelDocumentViewUI$QInternalFrame')]    10    10
    ${nbr_tree_nodes}=    Get Tree Node Count    BrowserTree
    : FOR    ${node_number}    IN RANGE    ${nbr_tree_nodes}
    \    ${current_node_path}=    Get Tree Node Path    BrowserTree    ${node_number}
    \    Run Keyword If    "${current_node_path}"=="__ROOT|${table_path}"    Exit For Loop
    Click On Tree Node at Coordinates    BrowserTree    ${node_number}    2    7    7
    log    ${node_number}
    Component Should Have Visible Flag    xpath=//*[@name='${table_name}' and contains(@class,'AbstractModelDocumentViewUI$QInternalFrame')]
    Send Keyboard Event    VK_F2
    Insert Into Text Field    class=JTextField    ${new_table_name}

Select Audit log Table
    [Documentation]    Selects the audit log table form the document browser, used to force the spreadsheet compliance dialogue to pop up when Batch compliance is enabled.
    ...    As the keyword _Select Table from Document Browser_ but without the table enable check, and with the audit log table hardcoded.
    ...
    ...    *Arguments*
    ...    _none_
    ...
    ...    *Return Value*
    ...    _none_
    ...
    ...    *Example*
    ...
    ...    | Select Audit log Table |
    # Select Audit Table
    Select Window    regexp=.*Spreadsheet
    ${document_browser_exists}    ${document_browser_exists_message}=    Run Keyword And Ignore Error    Component Should Have Visible Flag    xpath=//*[@name='Document Browser' and contains(@class,'AbstractModelDocumentViewUI$QInternalFrame')]
    Run Keyword If    '${document_browser_exists}'=='FAIL'    Select From Menu    View|Document Browser
    Click On Component At Coordinates    xpath=//*[@name='Document Browser' and contains(@class,'AbstractModelDocumentViewUI$QInternalFrame')]    10    10
    ${nbr_tree_nodes}=    Get Tree Node Count    BrowserTree
    : FOR    ${node_number}    IN RANGE    ${nbr_tree_nodes}
    \    ${current_node_path}=    Get Tree Node Path    BrowserTree    ${node_number}
    \    Run Keyword If    "${current_node_path}"=="__ROOT|Audit log"    Exit For Loop
    Click On Tree Node at Coordinates    BrowserTree    ${node_number}    2    7    7

Select Cell in Visible Table
    [Arguments]    ${table_name}    ${row}    ${column}
    [Documentation]    Selects a cell in the table without entering values
    ...
    ...    *Arguments*
    ...
    ...    _table_name_
    ...    The table name
    ...
    ...    _row_
    ...    The row identifier
    ...
    ...    _column_
    ...    The column identifier
    ...
    ...    *Preconditions*
    ...    The table must be visible and editable
    ...
    ...    *Return Value*
    ...    _none_
    ...
    ...    *Example*
    ...
    ...    | Select Cell in Visible Table | Table1 | B1 | Data1 |
    Select Context    ${table_name}
    Click On Component At Coordinates    Body    2    2
    : FOR    ${current_row}    IN RANGE    ${row}
    \    Send Keyboard Event    VK_DOWN
    : FOR    ${current_row}    IN RANGE    ${column}
    \    Send Keyboard Event    VK_RIGHT

Select Dimension
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

Select Spreadsheet Window
    [Documentation]    Selects the currently open spreadsheet window
    ...
    ...    *Arguments*
    ...    _none_
    ...
    ...    *Preconditions*
    ...    That a spreadheet must be present and open
    ...
    ...    *Return Value*
    ...    _none_
    IDBSSwingLibrary.Select Window    regexp=.*Spreadsheet

Select Table from Document Browser
    [Arguments]    ${table_path}    ${table_name}
    [Documentation]    Selects a table within the documnet browser
    ...
    ...    *Arguments*
    ...
    ...    _table_path_
    ...    The path to the table to select, excluding ROOT, and seperated by a pipe
    ...
    ...    _table_name_
    ...    The name of the table to select
    ...
    ...    *Preconditions*
    ...    The spreadsheet must be open
    ...
    ...    *Return Value*
    ...    _none_
    ...
    ...    *Example*
    ...
    ...    | Select Table from Document Browser | Folder1\|Table1 | Table1 |
    IDBSSwingLibrary.Select Window    regexp=.*Spreadsheet
    ${document_browser_exists}    ${document_browser_exists_message}=    Run Keyword And Ignore Error    Component Should Have Visible Flag    xpath=//*[@name='Document Browser' and contains(@class,'AbstractModelDocumentViewUI$QInternalFrame')]
    Run Keyword If    '${document_browser_exists}'=='FAIL'    Select From Menu    View|Document Browser
    Click On Component At Coordinates    xpath=//*[@name='Document Browser' and contains(@class,'AbstractModelDocumentViewUI$QInternalFrame')]    10    10
    ${nbr_tree_nodes}=    Get Tree Node Count    BrowserTree
    : FOR    ${node_number}    IN RANGE    ${nbr_tree_nodes}
    \    ${current_node_path}=    Get Tree Node Path    BrowserTree    ${node_number}
    \    Run Keyword If    "${current_node_path}"=="__ROOT|${table_path}"    Exit For Loop
    Click On Tree Node at Coordinates    BrowserTree    ${node_number}    2    7    7
    log    ${node_number}
    Component Should Have Visible Flag    xpath=//*[@name='${table_name}' and contains(@class,'AbstractModelDocumentViewUI$QInternalFrame')]
    Select From Menu    View|Document Browser    # Hide document browser to make sure it doesn't get clicked on by accident

Sign Audit Compliance
    [Arguments]    ${reasonForChange}    ${addComment}
    [Documentation]    When spreadsheet compliance is turned on, this keyword will aloow you to sign the pop up dialogue, selecting a reason from the drop down and adding a comment.
    ...
    ...    *Arguments*
    ...
    ...    _reasonForChange_
    ...    The reason for change that can be selected from the drop down menu, currently consist of by default:
    ...    - Animal died
    ...    - Data not needed
    ...    - As intended
    ...    - Error correction
    ...
    ...    _addComment_
    ...    The comment you wish to add to the audit log in addition to the reason for change
    ...
    ...    *Preconditions*
    ...    That the project has spreadsheet compliance turned on
    ...
    ...    *Return Value*
    ...    _none_
    ...
    ...    *Example*
    ...
    ...    | Sign Audit Compliancee | Data not needed | myComment |
    # Fill in the change log
    Sleep    1s
    Select Dialog    Enter audit details
    Push Button    text=Select All    #Tooltip=Select All Events
    Select From Combo Box    GLPReasonDialog.REASONS_COMBOBOX    ${reasonForChange}
    Insert Into Text Field    class=JTextArea    ${addComment}
    Push Button    GLPReasonDialog.Apply
    Push Button    GLPReasonDialog.OK

Turn On Spreadsheet compliance
    [Arguments]    ${groupName}    ${projectName}    ${BvS}    ${username}    ${password}
    [Documentation]    Turns on Spreadsheet compliance for a given project
    ...
    ...    *Arguments*
    ...
    ...    _groupName_
    ...    The name of the group in which the project exists
    ...
    ...    _projectName_
    ...    The name of the project in which you wish GLP to be configured on
    ...
    ...    _BvS_
    ...    Batch vs. Single prompting selection; input either Batch or Single
    ...
    ...    _usrername_
    ...    The credentials you wish to use to verify the compliance change
    ...
    ...    _password_
    ...    The credentials you wish to use to verify the compliance change
    ...
    ...    *Preconditions*
    ...    That the Group exists and is not in a folder structure
    ...
    ...    *Return Value*
    ...    _none_
    ...
    ...    *Example*
    ...
    ...    | Turn on Spreadsheet compliance | myGroup | myProject | Admin | Pass |
    Select From Tree Node Popup Menu    class=WorkbenchNavigatorTree    Root|${groupName}|${projectName}    Configure|Spreadsheet Compliance Settings...
    Select Dialog    SsComplianceConfigurationDialog
    Check Check Box    GLP_CHECKBOX
    Run Keyword If    '${BvS}'=='Batch'    Push Radio button    text=Prompt for a batch of changes
    Run Keyword If    '${BvS}'=='Single'    Push Radio button    text=Prompt for each change
    Push Button    OK
    # Save
    Select Dialog    E-WorkBook - Credentials
    Insert Into Text Field    class=JStringField    ${username}
    Insert Into Text Field    class=JStringPasswordField    ${password}
    Push Button    text=Continue
    Select E-WorkBook Main Window

Update Experiment
    Select Window    regexp=.*Spreadsheet
    Push Button    updateSSItemPanelToolbarButton
    ${old_dialog_wait_timeout}=    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout    0.01
    Wait Until Keyword Succeeds    10s    1s    Dialog Should Be Open    regexp=Performing action.*
    Wait Until Keyword Succeeds    600s    1s    Dialog Should Not Be Open    regexp=Performing action.*
    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout    ${old_dialog_wait_timeout}

Update single spreadsheet cell & close
    [Arguments]    ${tablepath}    ${tablename}    ${row}    ${column}    ${newval}
    Select Table from Document Browser    ${tablepath}    ${tablename}
    Change Cell Value in Visible Table    ${tablename}    ${row}    ${column}    ${newval}
    Update Experiment
    Close spreadsheet

Verify cell value in BioBook spreadsheet
    [Arguments]    ${expected_value}    ${tablename}    ${tablepath}    ${rownumber}
    [Documentation]    Gets the value from the cell of the transform data by exporting the data from the 2.4 spreadsheet table data into a CSV and then getting the value from a specified cell, thus verifying that the value is present
    ...
    ...    Arguments
    ...
    ...    ${expected_value} = \ The value that should be present in the cell
    ...
    ...    ${tablename} = The name of the given table where value is being checked
    ...
    ...    ${tablepath = The path of the table (same as tablename}
    ...
    ...    ${rownumber} = row number of cell
    ...
    ...    Example ${getmeasurevalue}[3]
    ...
    ...
    ...
    ...
    ...    _EXAMPLE_
    ...
    ...    Verify cell value = Dog | Table1 \ | \ Table1 | 3 \
    ${uniqueID}=    Get time    epoch
    ${name}=    ewb_thick_client_spreadsheet_actions_resource.Export Table    ${tablename}    ${tablepath}    ${uniqueID}    ${OUTPUT_DIR}
    Sleep    2s
    ${file}=    Get File    ${OUTPUT_DIR}${/}${name}.csv
    @{Getmeasurevalue}=    _Get Final Row from Export    ${file}
    List Should Contain Value    @{Getmeasurevalue}[${rownumber}]    ${expected_value}

_Get Final Row from Export
    [Arguments]    ${CSVFile}
    [Documentation]    Takes a string from 'Get File' keyword and removes the last line(\ ) and splits into a list seperating on commas. List is returned.
    ...
    ...    Keyword is used as part of the _Check Audit Values_ keyword
    ...
    ...    _CSVfile_
    ...    The name of the table you wish to export
    ...
    ...    *Preconditions*
    ...    Ensure that the Table has been exported as CSV
    ...
    ...    *Return Value*
    ...    _@{lastRowItems}_
    ...    The column headers of the exported CSV file, returned as a list
    ...
    ...    *Example*
    ...
    ...    | ${fileName}= | Export Table | Table1 | Folder1\|Table1 | ${uniqueID} | ${TEMPDIR} |
    ...    | ${fileString}= | Get File | ${TEMPDIR}${\}${fileName}.csv |
    ...    | @{lastRowItems}= | _Get Final Row from Export | \ ${fileString} |
    ...    | List Should be Equal | @{lastRowItems} | @{checkList} |
    ${lastRow}=    Fetch From Right    ${CSVFile}    \n
    @{lastRowItems}=    Split String    ${lastRow}    \|
    log    ${lastRowItems}
    [Return]    @{lastRowItems}
