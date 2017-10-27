*** Settings ***
Resource          ewb_thick_client_general_actions_resource.robot
Library           String
Library           IDBSSwingLibrary
Library           RobotRemoteAgent

*** Keywords ***
Add Entity Type To Hierarchy
    [Arguments]    ${parent}    ${entity_type}
    Select Dialog    Configuration
    Wait for glass pane to disappear
    Comment    Set context to hierarchy tab
    __Select Config dialog tab    Flexible Hierarchy
    Select Tab As Context    Hierarchy
    ${old_timeout}=    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    1
    ${status}    ${value}=    Run Keyword And Ignore Error    IDBSSwingLibrary.Tree Node Should Not Exist    class=HierarchyTree    ${parent}|${entity_type}
    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    ${old_timeout}
    Run Keyword If    '${status}'=='PASS'    Wait Until Keyword Succeeds    600s    20s    __Add entity type to flexible hierarchy tree    ${parent}
    ...    ${entity_type}

Add New Attribute To Entity Type
    [Arguments]    ${entity_type}    ${name}    ${caption}    ${type}    ${description}=    ${is_mandatory}=${False}
    ...    ${is_read_only}=${False}    ${is_linked}=${False}    ${dictionary}=
    Select Dialog    Configuration
    __Select Config dialog tab    Flexible Hierarchy
    Select Tab As Context    Entity Types
    ${typeRow}=    _Find Entity Type Row    ${entity_type}
    Click On Table Cell    0    ${typeRow}    2
    ${attributeRow}=    Find Table Row    1    ${name}
    Run Keyword If    ${attributeRow}!=-1    Fail    Attriburte ${name} already exists for entity type ${entityType}. Can't create attribute.
    Push Button    NewAttributeButton
    Select Dialog    New Attribute
    Insert Into Text Field    xpath=//*[contains(@class,'JStringField')]    ${name}
    Insert Into Text Field    xpath=//*[contains(@class,'JTextField')]    ${caption}
    Wait Until Keyword Succeeds    30s    3s    Select From Combo Box    0    ${type}    # This sometimes fails on the first attempt
    Insert Into Text Field    xpath=//*[contains(@class,'JTextPane')]    ${description}
    Uncheck Check Box    0
    Run Keyword If    ${is_mandatory}    Check Check Box    0
    Uncheck Check Box    1
    Run Keyword If    ${is_read_only}    Check Check Box    1
    Uncheck Check Box    2
    Run Keyword If    ${is_linked}    Check Check Box    2
    Run Keyword If    '${dictionary}'!=''    _Set New Entity Attribute Dictionary    ${dictionary}
    Push Button    text=OK
    Select Dialog    Configuration
    Wait for glass pane to disappear

Add attribute to managed file set
    [Arguments]    ${fileset}    ${name}    ${type}
    [Documentation]    This switches the E-WorkBook configuration dialog to the "Managed File Set Types" tab. It then adds a new attibute to a file set type as specified by the arguments. *Note:* Only attributes with a type of text can currently be created in a meaningful way as the set-up necessary for the other attribute types isn't currently supported.
    ...
    ...    *Arguments*
    ...    _fileset_
    ...    The managed file set type that the attribute should be added to.*Note:* This file set type needs to exist before the attibute is added.
    ...
    ...    _name_
    ...    Name for the new managed file set attribute.
    ...
    ...    _type_
    ...    The type of the attribute.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects a logged-in E-WorkBook window with the configuration dialog open and active. It also expectes the managed file set type that should have the new attribute to exist in the system.
    ...
    ...    *Example*
    ...    | Add attribute to managed file set | fileset=Test fileset | name=test attribute | type=Free Text |
    Select Dialog    Configuration
    Wait for glass pane to disappear
    __Select Config dialog tab    Managed File Set Types
    ${file_set_type_row}=    Find Table Row    image_type_table    ${fileset}
    Run Keyword If    ${file_set_type_row}==-1    Fail    Could not find file set "${fileset}"
    Select Table Cell    image_type_table    ${file_set_type_row}    0
    Push Button    CreateAttributeAction
    Select Dialog    Attribute
    Insert Into Text Field    attribute_name    ${name}
    Select From Combo Box    0    ${type}
    Push Button    OK
    Select Dialog    Configuration
    Wait for glass pane to disappear
    Push Button    Apply Button
    Wait for glass pane to disappear

Add new item type
    [Arguments]    ${name}    ${data_type}
    [Documentation]    This switches the E-WorkBook configuration dialog to the "Item Types" tab. It then adds a new item type as specified by the arguments
    ...
    ...    *Arguments*
    ...    _name_
    ...    Name for the new item type.
    ...
    ...    _data_type_
    ...    The E-WorkBook data type that this item type correponds to.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects a logged-in E-WorkBook window with the configuration dialog open and active.
    ...
    ...    *Example*
    ...    | Add new item type | name=Item Test | data_type=SKETCH |
    Select Dialog    Configuration
    Wait for glass pane to disappear
    __Select Config dialog tab    Item Types
    Push Button    Add
    Select Dialog    Add New Item Type
    Insert Into Text Field    0    ${name}
    Select From Dropdown Menu    0    ${data_type}
    Push Button    OK
    Select Dialog    Configuration
    Wait for glass pane to disappear

Add new managed file set format
    [Arguments]    ${name}    ${mandatory_files}
    [Documentation]    This switches the E-WorkBook configuration dialog to the "Managed File Set Types" tab. It then adds a new managed file set format as specified by the arguments. In order to be able to access the new managed file set format dialog it needs to go through some of the new managed file set type dialogs.
    ...
    ...    *Arguments*
    ...    _name_
    ...    Name for the new managed file set format.
    ...
    ...    _mandatory_files_
    ...    The extensions of the mandatory files that have to be part of the file set to make it valid.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects a logged-in E-WorkBook window with the configuration dialog open and active.
    ...
    ...    *Example*
    ...    | Add new managed file set format | name=JPEG | mandatory_files=jpg |
    Select Dialog    Configuration
    Wait for glass pane to disappear
    __Select Config dialog tab    Managed File Set Types
    Push Button    NewEntityTypeButton
    Select Dialog    New Managed File Set Type
    Push Button    text=...
    Select Dialog    2    # Need to use index as the titles of all the dialogs are the same
    Push Button    NewEntityTypeButton
    Select Dialog    3    # Need to use index as the titles of all the dialogs are the same
    Insert Into Text Field    format_name    ${name}
    Insert Into Text Field    mandatory_files    ${mandatory_files}
    Push Button    OK
    Select Dialog    2
    Push Button    OK
    Select Dialog    New Managed File Set Type
    Push Button    Cancel
    Select Dialog    Configuration
    Wait for glass pane to disappear

Add new managed file set type
    [Arguments]    ${name}    ${format}
    [Documentation]    This switches the E-WorkBook configuration dialog to the "Managed File Set Types" tab. It then adds a new managed file set type as specified by the arguments.
    ...
    ...    *Arguments*
    ...    _name_
    ...    Name for the new managed file set type.
    ...
    ...    _format_
    ...    The managed file set format to be used by the new type. *Note:* This format needs to exist before the managed file set type is created.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects a logged-in E-WorkBook window with the configuration dialog open and active. It also expectes the managed file set format used for the file set type to exist in the system.
    ...
    ...    *Example*
    ...    | Add new managed file set type | name=Test fileset | format=JPEG |
    Select Dialog    Configuration
    Wait for glass pane to disappear
    __Select Config dialog tab    Managed File Set Types
    Push Button    NewEntityTypeButton
    Select Dialog    New Managed File Set Type
    Insert Into Text Field    image_type_name    ${name}
    Push Button    text=...
    Select Dialog    2    # Need to use index as the titles of all the dialogs are the same
    ${row}=    Find Table Row    image_format_table    ${format}    Name
    Run Keyword If    ${row}==-1    Fail    Could not find format ${format}
    Click On Table Cell    image_format_table    ${row}    0
    Push Button    OK
    Select Dialog    New Managed File Set Type
    Push Button    OK
    Select Dialog    Configuration
    Wait for glass pane to disappear
    Push Button    Apply Button
    Wait for glass pane to disappear

Add new simple term to catalog
    [Arguments]    ${catalog}    ${term_value}
    [Documentation]    This switches the E-WorkBook configuration dialog to the "Catalog" tab. It then opens the specified catalog and add a new term using the term values specified.
    ...
    ...    *Arguments*
    ...    _catalog_
    ...    The catalog in E-WorkBook that the new term should be added under. The catalog is specified with all the hierarchical levels separated by /
    ...    eg: /Experiment Dictionaries/Experiment Titles
    ...
    ...    _@{term_value_
    ...    A list of term attributes with their values in a [attribute name]=[value] format.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects a logged-in E-WorkBook window with the configuration dialog open and active.
    ...
    ...    *Example*
    ...    | Add new term to catalog | catalog=/Experiment Dictionaries/Experiment Titles | title=New test title |
    Select Dialog    Configuration
    Wait for glass pane to disappear
    __Select Config dialog tab    Catalog
    __Select item in Catalog Tree    ${catalog}
    Push Button    Create
    Select Dialog    Create new value
    Insert Into Text Field    0    ${term_value}
    Push Button    OK
    Select Dialog    Configuration
    Wait for glass pane to disappear
    __Select Config dialog tab    Catalog
    Push Button    text=Apply

Add open with value
    [Arguments]    ${command_name}    ${command_path}    ${data_type}
    [Documentation]    This switches the E-WorkBook configuration dialog to the "Open With Values" tab. It then adds a new open with value as specified by the arguments
    ...
    ...    *Arguments*
    ...    _command_name_
    ...    Name for the new open with command
    ...
    ...    _command_path_
    ...    The executable to call when the open with command is invoked.
    ...
    ...    _data_type_
    ...    The E-WorkBook data type that this open with is applicable to.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects a logged-in E-WorkBook window with the configuration dialog open and active.
    ...
    ...    *Example*
    ...    | Add open with value | command_name=Send Test | command_path=C:/WINDOWS/notepad.exe | data_type=PLAIN_TEXT |
    Select Dialog    Configuration
    Wait for glass pane to disappear
    __Select Config dialog tab    Open With Values
    Push Button    Add
    Select Dialog    Adding New Open With Value
    Insert Into Text Field    0    ${command_name}
    Insert Into Text Field    1    ${command_path}
    Select From Dropdown Menu    0    ${data_type}
    Push Button    OK
    Select Dialog    Configuration

Apply Configuration Changes
    Sleep    5s    Give E-WorkBook a chance to do all the changes
    Select Dialog    Configuration
    Push Button    xpath=//*[text()='Apply' and @enabled='true']
    Wait for glass pane to disappear

Change compliance message to
    [Arguments]    ${new_message}
    [Documentation]    This switches the E-WorkBook configuration dialog to the "Compliance" tab and then set the compliance message to the value specified.
    ...
    ...    *Arguments*
    ...    _new_message_
    ...    The new message to be used in the electronic signature dialog.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects a logged-in E-WorkBook window with the configuration dialog open and active.
    ...
    ...    *Example*
    ...    | Change compliance message to | ${COMPLIANCE_MESSAGE} |
    ...    | Change compliance message to | Your signature here is legally binding |
    Select Dialog    Configuration
    Wait for glass pane to disappear
    __Select Config dialog tab    Compliance
    Insert Into Text Field    xpath=//*[@name='LEGALSTATEMENT']//*[contains(@class,'JTextArea')]    ${new_message}
    Push Button    text=Apply

Close configuration dialog
    [Documentation]    This closes the E-WorkBook configuration dialog.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects a logged-in E-WorkBook window with the configuration dialog open and active.
    ...
    ...    *Example*
    ...    | Close configuration dialog |
    Select Dialog    Configuration
    Close Dialog    Configuration
    Select E-WorkBook Main Window

Configure New Entity Type
    [Arguments]    ${name}    ${display_name}    ${description}    ${versioned}=${False}    ${contains_documents}=${False}    ${run_transforms}=${False}
    Select Dialog    Configuration
    __Select Config dialog tab    Flexible Hierarchy
    Select Tab As Context    Entity Types
    ${row}=    Find Table Row    0    ${name}
    Run Keyword If    ${row}!=-1    Fail    Can't re-create existing entity type ${name}
    Push Button    NewEntityTypeButton
    Select Dialog    New Entity Type
    Insert Into Text Field    0    ${name}
    Insert Into Text Field    1    ${display_name}
    Insert Into Text Field    xpath=//*[contains(@class,'JTextPane')]    ${description}s
    Uncheck Check Box    0
    Run Keyword If    ${versioned}    Check Check Box    0
    Uncheck Check Box    1
    Run Keyword If    ${contains_documents}    Check Check Box    1
    Uncheck Check Box    2
    Run Keyword If    ${run_transforms}    Check Check Box    2
    Push Button    text=OK
    Select Dialog    Configuration
    Wait for glass pane to disappear
    Apply Configuration Changes
    Wait Until Keyword Succeeds    300s    1s    _Find Entity Type Row    ${name}

Delete from catalog
    [Arguments]    ${path}
    [Documentation]    Deletes from the catalog the specified Dictionary or Term
    ...
    ...    *Arguments*
    ...    _path_
    ...    The path of the Dictionary or Term to be deleted seperated by a /
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects a logged-in E-WorkBook window with the configuration dialog open and active.
    ...
    ...    *Example*
    ...    | Delete from catalog | ${path} |
    ...    | Delete from catalog | SomeDictionary |
    ...    | Delete from catalog | SomeDictionary/SomeTerm |
    ${pipe_separated_path}=    Replace String    ${path}    /    |
    Select Dialog    Conf
    __Select Config dialog tab    Catalog
    __Select Catalog Tree Node    ${pipe_separated_path}
    Expand Tree Node    class=TermTree    ${pipe_separated_path}
    Click On Tree Node    class=TermTree    ${pipe_separated_path}    1
    Push Button    Delete
    Sleep    2
    Send Keyboard Event    VK_ENTER
    Select Dialog    Conf

Enable "${transform_name}" transform
    [Documentation]    Enables the transform called ${transform_name} in the configuration dialog.
    ...
    ...    *Arguments*
    ...    _transform_name_
    ...    The name of the transform to enable
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects a logged-in E-WorkBook window with the configuration dialog open and active.
    ...
    ...    *Example*
    ...    | Enable "Spreadsheet Data" transform |
    Select Dialog    Configuration
    __Select Config dialog tab    Transforms
    ${row}=    Find Table Row    0    ${transform_name}    Transform
    Log    ${row}
    Select Table Cell    0    ${row}    Transform    # Select the ${transform_name} Transform
    ${is_active}=    Get Table Cell Value    0    ${row}    Active
    Run Keyword If    '${is_active}' == 'false'    Click On Table Cell    0    ${row}    Active
    Run Keyword If    '${is_active}' == 'false'    Push Button    text=Apply
    ${is_active}=    Get Table Cell Value    0    ${row}    Active
    Should Be Equal    ${is_active}    true

Import catalog
    [Arguments]    ${catalog_path}    ${timeout}=300
    [Documentation]    Imports a catalog into the E-WorkBook system catalog form an exported catalog file.
    ...
    ...    *Arguments*
    ...    _catalog_path_
    ...    Path to the catalog file on the local file system.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects a logged-in E-WorkBook window with the configuration dialog open and active.
    ...
    ...    *Example*
    ...    | Import catalog | C:/QTP Data/E-Workbook/Test Data/smoke test files/Basic Data/Reference Catalog.xml |
    Select Dialog    Configuration    5
    __Select Config dialog tab    Catalog
    Push Button    Import catalog items
    sleep    5
    Choose From File Chooser    ${catalog_path}
    Sleep    3s    Give import time to work
    Select Dialog    E-WorkBook    ${timeout}
    Component Should Exist    xpath=//*[contains(@class,Jlabel) and contains(.," was imported successfully")]
    Push Button    text=OK
    Sleep    5s    Give E-WorkBook time to sort itself out
    Select Dialog    Configuration

Open configuration dialog
    [Documentation]    This opens the E-WorkBook configuration dialog.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects a logged -in E-WorkBook window. The login needs to have been performed using a username nad password that have access to the configuration dialog.
    ...
    ...    *Example*
    ...    | Open configuration dialog |
    Select E-WorkBook Main Window
    Wait Until Keyword Succeeds    60 seconds    2 seconds    Select from E-WorkBook Main Menu    Tools    Configuration\.\.\.
    Comment    Check for configuration dialog lock pop-up and select yes, if it appears
    Disable Taking Screenshots On Failure
    ${configuration_lock}    ${result}=    Run Keyword And Ignore Error    Select Dialog    Configuration Dialogue already locked    2
    Enable Taking Screenshots On Failure
    Run Keyword If    '${configuration_lock}'=='PASS'    Push Button    text=Yes
    IDBSSwingLibrary.Select Dialog    Configuration
    Sleep    2s    Make sure the dialog is fully loaded

Open term for editing
    [Arguments]    ${catalog}    ${term}
    [Documentation]    This switches the E-WorkBook configuration dialog to the "Catalog" tab. It then opens the specified catalog and selects the specified term. If it finds the expected term, it then toggles the default status of that term value.
    ...
    ...    *Arguments*
    ...    _catalog_
    ...    The catalog in E-WorkBook that the term exists under. The catalog is specified with all the hierarchical levels separated by /
    ...    eg: /Experiment Dictionaries/Experiment Titles
    ...
    ...    _term_
    ...    The term within the catalog above that should have its default status toggled.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects a logged-in E-WorkBook window with the configuration dialog open and active. The catalog and term being affected also needs to exist prior to this command running.
    ...
    ...    *Example*
    ...    | Toggle default value status for term | catalog=/Experiment Dictionaries/Experiment Titles | term=New test title |
    Select Dialog    Configuration
    __Select Config dialog tab    Catalog
    __Select item in Catalog Tree    ${catalog}
    ${term_row}=    Find Table Row    TuplesPanel.tupleTable    ${term}
    Run Keyword If    ${term_row}<0    Fail    Could not find term ${term} in list of terms for catalog ${catalog}.
    Select Table Cell    TuplesPanel.tupleTable    ${term_row}    0
    Push Button    Edit

Open user setup menu
    [Documentation]    Opens the user Set Up... menu and confirms the dialog appears.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Precondition*
    ...    The user has logged into EWB
    ...
    ...    *Example*
    ...    | Select Window | IDBS E-WorkBook - Home Page |
    ...    | Open user setup menu | |
    Select E-WorkBook Main Window
    Wait Until Keyword Succeeds    60 seconds    2 seconds    Select from E-WorkBook Main Menu    Tools    Set Up...
    Select Dialog    Set Up    60

Re-open E-WorkBook
    Close configuration dialog
    Close E-WorkBook
    Login to E-WorkBook    server=${SERVER}:${THICK_CLIENT_PORT}    username=${VALID USER}    password=${VALID PASSWD}
    Open configuration dialog

Set message of the day to
    [Arguments]    ${new_message}
    [Documentation]    This switches the E-WorkBook configuration dialog to the "Message of the Day" tab and then set the message of the day to the value specified.
    ...
    ...    *Arguments*
    ...    _new_message_
    ...    The new message of the day to be used by E-WorkBook
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects a logged-in E-WorkBook window with the configuration dialog open and active.
    ...
    ...    *Example*
    ...    | Set message of the day to | ${TEST_MESSAGE_OF_THE_DAY} |
    ...    | Set message of the day to | Good Morning!! |
    Select Dialog    Configuration
    __Select Config dialog tab    Message of the Day
    Insert Into Text Field    1    ${new_message}
    Push Button    text=OK

Set template availability to
    [Arguments]    ${option}
    [Documentation]    This switches the E-WorkBook configuration dialog to the "Templates" tab. It then sets the availability of templates as specified by the option value.
    ...
    ...    *Arguments*
    ...    _option_
    ...    AUTHORISED TEMPLATES ONLY or ALL TEMPLATES depending on the type of template availability that E-WorkBook should be set to. This value is not case sensitive.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects a logged-in E-WorkBook window with the configuration dialog open and active.
    ...
    ...    *Example*
    ...    | Set template availability to | Authorised Templates Only |
    Select Dialog    Configuration
    __Select Config dialog tab    Templates
    Run Keyword If    "${option}".upper()=="ALL TEMPLATES"    Push Radio Button    textregexp=.*All Templates.*
    Run Keyword If    "${option}".upper()=="AUTHORISED TEMPLATES ONLY"    Push Radio Button    textregexp=.*Authorised Templates Only.*

Toggle default value status for term
    [Arguments]    ${catalog}    ${term}
    [Documentation]    This switches the E-WorkBook configuration dialog to the "Catalog" tab. It then opens the specified catalog and selects the specified term. If it finds the expected term, it then toggles the default status of that term value.
    ...
    ...    *Arguments*
    ...    _catalog_
    ...    The catalog in E-WorkBook that the term exists under. The catalog is specified with all the hierarchical levels separated by /
    ...    eg: /Experiment Dictionaries/Experiment Titles
    ...
    ...    _term_
    ...    The term within the catalog above that should have its default status toggled.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects a logged-in E-WorkBook window with the configuration dialog open and active. The catalog and term being affected also needs to exist prior to this command running.
    ...
    ...    *Example*
    ...    | Toggle default value status for term | catalog=/Experiment Dictionaries/Experiment Titles | term=New test title |
    Select Dialog    Configuration
    __Select Config dialog tab    Catalog
    __Select item in Catalog Tree    ${catalog}
    ${term_row}=    Find Table Row    TuplesPanel.tupleTable    ${term}
    Run Keyword If    ${term_row}<0    Fail    Could not find term ${term} in list of terms for catalog ${catalog}.
    Select Table Cell    TuplesPanel.tupleTable    ${term_row}    1
    Push Button    Toggle default status
    Push Button    text=Apply

_Attempt to add Entity Type to Hierarchy
    [Arguments]    ${parent}    ${entity_type}
    Select Dialog    Configuration
    Wait for glass pane to disappear
    Comment    Set context to hierarchy tab
    __Select Config dialog tab    Flexible Hierarchy
    Select Tab As Context    Hierarchy
    Right Click On Tree Node    0    ${parent}
    Select Dialog    Configuration
    Sleep    1s    Give E-WorkBook time to draw the poup menu
    ${menu_result}    ${message}=    Run Keyword And Ignore Error    Select from visible popup menu    xpath=//*[contains(@class,'JPopupMenu')]    Add Entity Type|${entity_type}
    Comment    Take screeshot
    Run Keyword If    '${menu_result}'=='FAIL'    Take Screenshot
    Comment    Re-open EWB to force a reload of the GUI
    Run Keyword If    '${menu_result}'=='FAIL'    Re-open E-WorkBook
    Comment    Pass the failure back to the caller
    Run Keyword If    '${menu_result}'=='FAIL'    Fail    ${message}

_Find Entity Type Row
    [Arguments]    ${entity_type}
    Select Dialog    Configuration
    __Select Config dialog tab    Flexible Hierarchy
    Select Tab As Context    Entity Types
    ${row}=    Find Table Row    0    ${entity_type}
    Comment    Reopen confifuration dialog if they keyword fails
    Run Keyword If    ${row}==-1    Close configuration dialog
    Run Keyword If    ${row}==-1    Close E-WorkBook
    Run Keyword If    ${row}==-1    Login to E-WorkBook    ${SERVER}:${THICK_CLIENT_PORT}    ${VALID USER}    ${VALID PASSWD}
    Run Keyword If    ${row}==-1    Open configuration dialog
    Run Keyword If    ${row}==-1    __Select Config dialog tab    Flexible Hierarchy
    Run Keyword If    ${row}==-1    Select Tab As Context    Entity Types
    Run Keyword If    ${row}==-1    Fail    Failed to find entity type ${entity_type}
    [Return]    ${row}

_Set New Entity Attribute Dictionary
    [Arguments]    ${attribute_dictionary}
    [Documentation]    *Sets the dictionary attribute field*
    ...
    ...    *Preconditions*
    ...    - New attribute dialog is open
    ...    - Dictionary field is active (a dictionary type needs to have been previously selected)
    ...
    ...    *Arguments*
    ...    - _attribute_dictionary_ - in the form "/Experiment Dictionaries/Experiment Titles" (including preceeding slash)
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    | _Set New Entity Attribute Dictionary | /Experiment Dictionaries/Experiment Titles |
    IDBSSwingLibrary.Click On Component    xpath=//*[contains(@class,'BasicLookupComponentUI')]    #ensures focus is on this field (required to allow picker to be displayed)
    Insert Into Text Field    xpath=//*[contains(@class,'BasicLookupComponentUI')]    ${attribute_dictionary}
    Sleep    5    #allow picker to appear
    IDBSSwingLibrary.Send Keyboard Event    VK_ENTER
    Sleep    5    #allow enter event time to take effect

__Add entity type to flexible hierarchy tree
    [Arguments]    ${parent}    ${entity_type}
    Click On Tree Node    class=HierarchyTree    0
    Click On Tree Node    class=HierarchyTree    ${parent}
    Select From Left Click Popup Menu    AddEntityTypeNodeButton    ${entity_type}
    ${status}    ${message}=    Run Keyword And Ignore Error    IDBSSwingLibrary.Tree Node Should Exist    class=HierarchyTree    ${parent}|${entity_type}
    Comment    Reopen confifuration dialog if they keyword fails
    Run Keyword If    '${status}'=='FAIL'    Close configuration dialog
    Run Keyword If    '${status}'=='FAIL'    Close E-WorkBook
    Run Keyword If    '${status}'=='FAIL'    Login to E-WorkBook    ${SERVER}:${THICK_CLIENT_PORT}    ${VALID USER}    ${VALID PASSWD}
    Run Keyword If    '${status}'=='FAIL'    Open configuration dialog
    Run Keyword If    '${status}'=='FAIL'    __Select Config dialog tab    Flexible Hierarchy
    Run Keyword If    '${status}'=='FAIL'    Select Tab As Context    Hierarchy
    Comment    Re-run the check to give the correct result.
    IDBSSwingLibrary.Tree Node Should Exist    class=HierarchyTree    ${parent}|${entity_type}

__Expand Catalog Tree Node
    [Arguments]    ${tree_node}
    ${nbr_nodes}=    Get Tree Node Count    class=TermTree
    : FOR    ${i}    IN RANGE    ${nbr_nodes}
    \    ${node_path}=    Get Tree Node Path    class=TermTree    ${i}
    \    Run Keyword If    "${node_path}"=="${tree_node}"    Expand Tree Node    class=TermTree    ${i}

__Select Catalog Tree Node
    [Arguments]    ${tree_node}
    ${nbr_nodes}=    Get Tree Node Count    class=TermTree
    : FOR    ${i}    IN RANGE    ${nbr_nodes}
    \    ${node_path}=    Get Tree Node Path    class=TermTree    ${i}
    \    Run Keyword If    "${node_path}"=="${tree_node}"    Select Tree Node    class=TermTree    ${i}

__Select Config dialog tab
    [Arguments]    ${tab_name}
    Select Dialog    Configuration
    Wait for glass pane to disappear
    Select Tab as context    <html><body><div style="padding-right:10px;padding-left:10px;padding-bottom:1px">${tab_name}</div></body></html>

__Select item in Catalog Tree
    [Arguments]    ${slash_separated_path}
    ${slash_separated_parent}    ${last_node}=    Split String From Right    ${slash_separated_path}    /    1
    @{levels}=    Split String    ${slash_separated_parent}    /
    Expand Tree Node    class=TermTree    0
    Sleep    3s    Give tree time to react
    Select Dialog    Configuration
    Wait for glass pane to disappear
    __Select Config dialog tab    Catalog
    ${current_tree_node}=    Set Variable    ${EMPTY}
    : FOR    ${next_level}    IN    @{levels}
    \    ${current_tree_node}=    Set Variable    ${current_tree_node}|${next_level}
    \    __Expand Catalog Tree Node    ${current_tree_node}
    \    Sleep    3s    Give tree time to react
    \    Select Dialog    Configuration
    \    Wait for glass pane to disappear
    \    __Select Config dialog tab    Catalog
    __Select Catalog Tree Node    ${current_tree_node}|${last_node}

Configure DataLink
    [Arguments]    ${Name}    ${Driver}    ${Type}    @{Parameters}
    [Documentation]    Configures a DataLink connection in the E-WorkBook Configuration dialogue
    ...
    ...    *Arguments*
    ...
    ...    _Name_
    ...    The name of the Configuration
    ...
    ...    _Driver_
    ...    The driver used to connect to your database:
    ...    | *Selection Needed* | *Argument to use* |
    ...    | Oracle Database JDBC Driver | Oracle |
    ...    | Microsoft JDBC Driver for SQL Server | SQLServer |
    ...
    ...    _Type_
    ...    The connection type to use:
    ...    | *Selection Needed* | *Argument to use* | *Available For* |
    ...    | Generic JDBC URL | Generic | Oracle |
    ...    | Oracle JDBC Thin URL | Thin | Oracle |
    ...    | Oracle JDBC OCI Driver | OCI | Oracle |
    ...    | Generic JDBC URL | Generic | SQLServer |
    ...
    ...    _Parameters_
    ...    A List of the parameters of your database
    ...    | *Selected Connection* | *Parameter Fields* | *Default Values* |
    ...    | Generic JDBC URL | JDBC Connection URL: | jdbc: |
    ...    | Oracle JDBC OCI Driver | TNS Name: | _BLANK_ |
    ...    | Oracle JDBC Thin URL | Hostname / IP Address: | _BLANK_ |
    ...    | \ | Port: | 1521 |
    ...    | \ | SID: | _BLANK_ |
    ...
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...
    ...    This keyword expects a logged-in E-WorkBook window with the configuration dialog open and active.
    ...
    ...    *Example*
    ...
    ...    | *Open configuration dialog* | \ | \ |
    ...    | @{threeParaList}= | *Create List* | myServer | 1521 | ORCL |
    ...    | *Configure DataLink* | myConfiguration1 | Oracle | Thin | ${threeParaList} |
    ...    | *Close configuration dialog* | \ | \ |
    Run Keyword If    '${Driver}'=='SQLServer'    _Configure SQLServer DataLink    ${Name}    @{Parameters}
    Run Keyword If    '${Driver}'=='Oracle'    _Configure Oracle DataLink    ${Name}    ${Type}    @{Parameters}

_Configure SQLServer DataLink
    [Arguments]    ${Name}    @{Parameters}
    [Documentation]    Configures a DataLink connection in the E-WorkBook Configuration dialogue using the Microsoft JDBC Driver for SQL Server
    ...
    ...    *Arguments*
    ...
    ...    _Name_
    ...    The name of the Configuration
    ...
    ...    _Parameters_
    ...    A list of the parameters of your database
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword is run internally as part of Configure DataLink
    log    ${Parameters}
    Select Dialog    Configuration    5
    __Select Config dialog tab    DataLink
    Push Button    ADD_DATALINK_CONFIG_BUTTON
    Select Dialog    New DataLink Configuration    100
    # Configuration Name:
    Insert Into Text Field    NAME_FIELD    ${Name}
    # Configuration Driver:
    Select From Dropdown Menu    DRIVER_COMBO    Microsoft JDBC Driver for SQL Server
    # Connection - Auto Fills
    # Parameters
    Insert Into Text Field    PARAMETER_FIELD_0    @{Parameters}[0]
    Push Button    SAVE_BUTTON
    Sleep    5s    Give E-WorkBook time to sort itself out
    Select Dialog    Configuration

_Configure Oracle DataLink
    [Arguments]    ${Name}    ${Type}    @{Parameters}
    [Documentation]    Configures a DataLink connection in the E-WorkBook Configuration dialogue for the Oracle Database JDBC Driver
    ...
    ...    *Arguments*
    ...
    ...    _Name_
    ...    The name of the Configuration
    ...
    ...    _Type_
    ...    The connection type to use:
    ...    | *Selection Needed* | *Argument to use* | *Available For* |
    ...    | Generic JDBC URL | Generic | Oracle |
    ...    | Oracle JDBC Thin URL | Thin | Oracle |
    ...    | Oracle JDBC OCI Driver | OCI | Oracle |
    ...
    ...    _Parameters_
    ...    A List of the parameters of your database
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword is run internally as part of Configure DataLink
    log    ${Parameters}
    Select Dialog    Configuration    5
    __Select Config dialog tab    DataLink
    Push Button    ADD_DATALINK_CONFIG_BUTTON
    Select Dialog    New DataLink Configuration    100
    # Configuration Name:
    Insert Into Text Field    NAME_FIELD    ${Name}
    # Configuration Driver:
    Select From Dropdown Menu    DRIVER_COMBO    Oracle Database JDBC Driver
    # Connection Type:
    Run Keyword If    '${Type}'=='Generic'    Select From Dropdown Menu    CONNECTION_TYPE_COMBO    Generic JDBC URL
    Run Keyword If    '${Type}'=='Thin'    Select From Dropdown Menu    CONNECTION_TYPE_COMBO    Oracle JDBC Thin URL
    Run Keyword If    '${Type}'=='OCI'    Select From Dropdown Menu    CONNECTION_TYPE_COMBO    Oracle JDBC OCI Driver
    # Parameters
    Insert Into Text Field    PARAMETER_FIELD_0    @{Parameters}[0]    #TNS/URL
    Run Keyword If    '${Type}'=='Thin'    Insert Into Text Field    PARAMETER_FIELD_1    @{Parameters}[1]    #Port
    Run Keyword If    '${Type}'=='Thin'    Insert Into Text Field    PARAMETER_FIELD_2    @{Parameters}[2]    #SID
    Push Button    SAVE_BUTTON
    Sleep    5s    Give E-WorkBook time to sort itself out
    Select Dialog    Configuration
