*** Settings ***
Documentation     A resource file containing IDBS defined keywords used for testing the IDBS E-WorkBook Web Client application. This resource file contains keywords applicable to the hierarchy functionality.
...               This file covers the management of record child entities (documents) within a record. This file is loaded by the common_resource.txt file which is automatically loaded when running tests through the Robot Framework.
...               *Version: E-WorkBook Web Client 9.2.0*
#Library           OracleLibrary
Resource          properties_resource.robot
Resource          ../Common/common_resource.robot
Resource          hierarchy_resource.robot
Resource          combobox_widget_resource.robot
#Library           .WebHelperFunctions/
Resource          general_resource.robot
Library           String
Library           EntityAPILibrary
Library           OperatingSystem
Resource          attributes_resource.robot
Resource          system_resource.robot
Library           IDBSSelenium2Library

*** Variables ***
${lock record}    ewb-editor-command-open-record    # depreciated
${unlock record}    ewb-editor-command-close-record
${draft save record}    ewb-editor-command-draft-save-record
${discard record changes}    ewb-editor-command-close-record
${delete document}    ewb-editor-command-delete-doc
${move up}        ewb-editor-command-move-up
${move to top}    ewb-editor-command-move-to-top
${move down}      ewb-editor-command-move-down
${move to end}    ewb-editor-command-move-to-end
${edit properties}    ewb-editor-command-edit-doc
${HTML start editing}    ewb-command-start-editing
${HTML apply edits}    ewb-command-apply-edits
${HTML cancel edits}    ewb-command-cancel-editing
${Insert Link Menu}    ewb-create-link-item
${Insert Web Link}    ewb-create-web-link
${Edit Web Link}    ewb-edit-web-link-command
${Insert Text Item}    ewb-create-text-item
${Text Item Type Prefix}    ewb-create-text-item
${version save record}    ewb-editor-command-version-save-record
${Insert File Item}    ewb-create-file-item
${File Item Type Prefix}    ewb-create-file-item-
${Insert Page Break}    ewb-editor-command-insert-page-break
${next document number}    ${EMPTY}
${document icon id}    ${EMPTY}
${document type id}    ${EMPTY}
${document title id}    ${EMPTY}
${document menu button id}    ${EMPTY}
${document top properties id}    ${EMPTY}
${document body id}    ${EMPTY}
${document bottom properties id}    ${EMPTY}
${document signatures id}    ${EMPTY}
${document expand button id}    ${EMPTY}
${last document found}    ${EMPTY}
${Insert Entity Link}    ewb-create-entity-link-command
${Edit Entity Link}    ewb-entity-link-edit-link
${Edit Entity Link Display Options}    ewb-entity-link-display-options
${record editing content header}    ewb-record-action-bar    # The editing menu containing the save and close record options
${full record mode}    ewb-record-menu-full
${minimal record mode}    ewb-record-menu-minimal
${template sequential edit menu}    ewb-template-editor-toggle-sequential-edit
${template confined edit menu}    ewb-template-editor-toggle-confined-edit
${pin all items button}    ewb-record-action-bar-pin-all
${unpin all items button}    ewb-record-action-bar-unpin-all
${Insert Placeholder Item}    ewb-create-placeholder-item
${Placeholder Data Type}    ewb-placeholder-data-type
${Placeholder File Type}    ewb-placeholder-file-type
${Placeholder Instructions}    ewb-placeholder-instructions
${Edit Placeholder Item}    ewb-command-start-editing
${Save Placeholder Item}    ewb-command-apply-edits
${page locked for editing message}    Unable to open the record as it is already locked by
${dialog container}    xpath=//div[contains(@class,'ewbdialog-container')]
${message box text locator}    xpath=//div[contains(@class,'ewb-message-box-text')]
${Edit Menu Option}    ewb-command-edit-record-menu
${Insert Record Menu}    ewb-insert-record-item-button
${panel header label}    xpath=//div[@id='application-header-toolButton']/../../div[1]
${version save comment box}    ewb-authentication-user-additional-comment
@{insert menu item list}    ewb-create-file-item    ewb-create-link-item    ewb-editor-command-insert-page-break    ewb-create-sketch-item    ewb-create-text-item
${ewb-follow-record}    ewb-follow-record
${view version history menu}    ewb-view-version-history-command
${Image Download Link Suffix}    -image-download-link
${prevent-further-editing-id}    ewb-editor-command-prevent-record-edit
${allow-further-editing-id}    ewb-editor-command-allow-record-edit
${delete-all-comments-id}    ewb-editor-command-delete-all-comments
${delete-all-comments}    Delete All Comments
${user action note id}    ewb-authentication-user-action-note    # The user action note ID (e.g. version save reason)
${export-to-pdf-id}    ewb-command-pdf-record-menu
${record-outline-edit-class}    ewb-record-outline-editing
${unable to open permissions message}    Unable to open the record as you do not have the necessary edit permissions.
${Insert ewb ss item}    ewb-ss-create-spreadsheet-item
${no_button}      //div[@class='ewbdialog-container']//button[text()='No']
${version_button}    //div[@class='ewbdialog-container']//button[text()='Version']
${cancel_button}    //div[@class='ewbdialog-container']//button[text()='Cancel']

*** Keywords ***
Lock Record If Unlocked
    [Documentation]    Locks the currently displayed record if it is currently unlocked and checks the "open" and "close" menu icons within
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    -The record must be in the central content panel for this keyword to succeed
    ...    -The common_resource file must contain the correct oracle details
    ...
    ...    *Example*
    ...    Click Tile | My Experiment
    ...    Lock Record If Unlocked
    ${ENTITY_ID}=    Get Entity Id From Record
    ${entity lock status}=    Check Record Lock State With Entity Id    ${ENTITY_ID}
    Run Keyword If    '${entity lock status}'=='F'    Lock Record For Editing

Lock Record For Editing
    [Documentation]    Attempts to lock the currently displayed record *regardless of its current lock state*
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    -The record must be in the central content panel for this keyword to succeed
    ...    -The common_resource file must contain the correct oracle details
    ...
    ...    *Example*
    ...    Click Tile | My Experiment
    ...    Lock Record For Editing
    Open Record Properties
    Edit Entity Properties
    Cancel Edit Entity Properties
    Click away from Property Panel

Unlock Record
    [Documentation]    Unlocks the record currently open, stops all editting regardless of whether any unsaved changes are present in the record.
    Wait Until Keyword Succeeds    10s    0.1s    Open Record Editing Header Tool Menu
    Click Link    xpath=//li[contains(@id,'${unlock record}')]/a
    ${check status}    ${value} =    Run Keyword And Ignore Error    Wait Until Page Contains Element    xpath=//div[contains(text(), 'The record contains modifications which will be lost by continuing')]    2s
    Run Keyword If    '${check status}'=='PASS'    Click OK

Unlock Record If Locked
    [Documentation]    Unlocks the record if it is currently open.
    ${ENTITY_ID}=    Get Entity Id From Record
    ${entity lock status}=    Check Record Lock State With Entity Id    ${ENTITY_ID}
    Run Keyword If    '${entity lock status}'=='T'    Unlock Record
    ${check status}    ${value} =    Run Keyword And Ignore Error    Wait Until Page Contains Element    xpath=//div[contains(text(), 'The record contains modifications which will be lost by continuing.')]    2s
    Run Keyword If    '${check status}'=='PASS'    Click OK

Draft Save Record
    [Documentation]    TEMPORARY KEYWORD - AWAITING SAVE IMPLEMENTATION
    ...
    ...    *Description*
    ...    Draft saves the currently displayed record
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - The draft save option must be active, else this keyword will fail
    ...
    ...    *Example*
    ...    Lock Record For Editting
    ...    Open Content Header Tool Menu
    ...    Add Text Item | Abstract
    ...    Draft Save Record
    #Click on record header before save to ensure we are checking the correct entity version state
    Wait Until Keyword Succeeds    30s    3s    Check Record Version State    CACHE
    Open Record Editing Header Tool Menu
    ${menu save status} =    IDBSSelenium2Library.Get Element Attribute    ${draft save record}@class
    Should Not Contain    ${menu save status}    x-item-disabled
    Robust Click    ${draft save record}
    Dialog Should Not Be Present    Indicate the reason for saving the record
    Run Keyword and Ignore Error    Wait Until Element Does Not Contain    xpath=//*[@class="ewb-record-edit-header-anchor"]    Saving    30s    # Save button text changes from 'Saving' to 'Save As' when save is complete
    Wait Until Keyword Succeeds    30s    3s    Check Record Version State    DRAFT

Version Save Record
    [Arguments]    ${username}    ${password}    ${save reason}    ${additional comments}=none
    [Documentation]    *Version saves the currently displayed record*
    ...
    ...    *Arguments*
    ...    - ${username} = the currently authenticated user name
    ...    - ${password} = the currently authenticated password
    ...    - ${save reason} = the reason for save - must be a valid reason (pick up from Experiment Save Reasons catalog term)
    ...    - ${additional comments}=none = optional additional save comments to be added to the save
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - The version save option must be active, else this keyword will fail
    ...
    ...    *Example*
    ...    | Add Text Item | Abstract |
    ...    | Version Save Record | Administrator | Administrator | Data Added | Saving with new text item in place |
    #Click on record header before save to ensure we are checking the correct entity version state
    Wait Until Keyword Succeeds    10s    1s    Check Record Version State    CACHE    DRAFT
    Open Record Editing Header Tool Menu
    Robust Click    ${version save record}
    Dialog Should Be Present    Indicate the reason for saving the record
    Select User Action Note    ${save reason}
    Run Keyword Unless    '${additional comments}'=='none'    Input Text    ${version save comment box}    ${additional comments}
    Run Keyword Unless    '${additional comments}'=='none'    Textarea Should Contain    ${version save comment box}    ${additional comments}
    Wait Until Keyword Succeeds    30 sec    1 sec    Authenticate Session    ${username}    ${password}
    Wait Until Keyword Succeeds    10s    1s    Wait Until Page Contains Element    css=#${record editing content header}[aria-hidden=true]    20s
    Wait Until Keyword Succeeds    10s    1s    Check Record Version State    VERSION

Discard Changes to Record
    [Arguments]    ${selectButton}=okButton
    [Documentation]    *Description*
    ...    - Selects Record : Save As > Discard Changes for to the currently displayed record.
    ...    - Default Action is to select OK to discard changes
    ...
    ...    *Arguments*
    ...    - ${selectButton} \ default value = *okButton* to accept discard
    ...    - other values = *cancelButton* to cancel changes
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - The Discard Changes option must be active, else this keyword will fail
    ...
    ...    *Example*
    #Click on record header before save to ensure we are checking the correct entity version state
    Wait Until Keyword Succeeds    10s    1s    Check Record Version State    CACHE
    Open Record Editing Header Tool Menu
    ${menu save status} =    IDBSSelenium2Library.Get Element Attribute    ${discard record changes}@class
    Should Not Contain    ${menu save status}    x-item-disabled
    Robust Click    ${discard record changes}
    Wait Until Page Contains Element    xpath=//div[@id="ewb-message-box-warn"]    10s
    Robust Click    ${selectButton}

Check Record Version State
    [Arguments]    @{given_value}
    [Documentation]    Checks that the record is in the given state
    Robust Click    xpath=//div[@class="ewb-document-panel-header"]//div[@class="gwt-Label"]
    ${result}=    Run Keyword And Return Status    Check Version Number Value    @{given_value}
    Run Keyword Unless    ${result}    Capture Page Screenshot
    Run Keyword Unless    ${result}    Fail

Get Record Confined State
    [Documentation]    Returns the confined state of the record
    Robust Click    xpath=//div[@class="ewb-document-panel-header"]//div[@class="gwt-Label"]
    ${actual_value}=    IDBSSelenium2Library.Get Element Attribute    xpath=//body@ewb-selected-entity-confined-entity
    [Return]    ${actual_value}

Get Record Sequential State
    [Documentation]    Returns the sequential state of the record
    Robust Click    xpath=//div[@class="ewb-document-panel-header"]//div[@class="gwt-Label"]
    ${actual_value}=    IDBSSelenium2Library.Get Element Attribute    xpath=//body@ewb-selected-entity-sequential-edit
    [Return]    ${actual_value}

Collapse All Record Documents
    [Documentation]    Collapses all of the record document items using the record context menu
    Open Content Header Tool Menu
    Click Element    ${Collapse All Documents}    don't wait
    # Validation Check
    Open Content Header Tool Menu
    Element Should Be Disabled    ${Collapse All Documents}
    Element Should Be Enabled    ${Expand All Documents}

Expand All Record Documents
    [Documentation]    Expands all of the record document items using the record context menu
    Open Content Header Tool Menu
    Click Element    ${Expand All Documents}    don't wait
    # Validation Check
    Open Content Header Tool Menu
    Element Should Be Disabled    ${Expand All Documents}
    Element Should Be Enabled    ${Collapse All Documents}

Collapse Document
    [Arguments]    ${Document Number}
    [Documentation]    Collapses or expands a document in a record dependant on the current state, based on the order in the document.
    ...    Note: first document = 0
    Click Element    document-header-${Document Number}-expanderButton

Check Document Collapsed
    [Arguments]    ${Document Number}
    [Documentation]    Checks that the document is collapsed.
    ...    Note: first document = 1
    # Keyword Stub

Check Document Expanded
    [Arguments]    ${Document Number}
    [Documentation]    Checks that the document is expanded.
    ...    Note: first document = 1
    # Keyword Stub

Open Document Header Tool Menu
    [Arguments]    ${Document_Number}
    [Documentation]    Opens the tool menu for the document based on the document order.
    ...    Note: first document = 0
    Robust Click    xpath=//div[@id='document-header-${Document_Number}-menuButton']/img

Delete Document
    [Arguments]    ${Document Number}
    [Documentation]    *Description*
    ...    Deletes a document from the open record based on the order within the record.
    ...
    ...    *Arguments*
    ...    ${Document Number} = The number of the document being editted, based on the order in the record. First document = 0, second document = 1 etc
    ...
    ...    *Return value*
    ...    ${applet id} = The ID of the text editor applet created
    ...
    ...    *Precondition*
    ...    - The record must be opened for editing
    ...
    ...    *Example*
    ...    Lock Record For Editting
    ...    Delete Document | 0
    ...    Page Should Not Contain
    Wait Until Page Contains Element    document-header-${Document Number}-entityImage    30s
    Page Should Contain Element    document-header-${Document Number}-itemTypeLabel
    Page Should Contain Element    document-header-${Document Number}-editableTitleTable
    Page Should Contain Element    document-properties-top-${Document Number}-panel
    Page Should Contain Element    document-body-${Document Number}-panel
    Page Should Contain Element    document-properties-bottom-${Document Number}-panel
    Page Should Contain Element    document-signatures-${Document Number}-panel
    Open Document Header Tool Menu    ${Document Number}
    Robust Click    ${delete document}
    Page Should Not Contain Element    ${delete document}
    Click OK
    Wait Until Page Does Not Contain Element    document-header-${Document Number}-entityImage    10s
    Page Should Not Contain Element    document-header-${Document Number}-itemTypeLabel
    Page Should Not Contain Element    document-header-${Document Number}-editableTitleTable
    Page Should Not Contain    document-properties-top-${Document Number}-panel
    Page Should Not Contain    document-body-${Document Number}-panel
    Page Should Not Contain    document-properties-bottom-${Document Number}-panel
    Page Should Not Contain    document-signatures-${Document Number}-panel

Move Document Up
    [Arguments]    ${Document Number}
    [Documentation]    Moves a document up one place in the record, based on the order within the record.
    ...    Note: first document = 1
    Open Document Header Tool Menu    ${Document Number}
    Robust Click    ${move up}

Move Document To Top
    [Arguments]    ${Document Number}
    [Documentation]    Moves a document to the top of the record, based on the order within the record.
    ...    Note: first document = 1
    Open Document Header Tool Menu    ${Document Number}
    Robust Click    ${move to top}

Move Document Down
    [Arguments]    ${Document Number}
    [Documentation]    Moves a document down one place in the record, based on the order within the record.
    ...    Note: first document = 1
    Open Document Header Tool Menu    ${Document Number}
    Robust Click    ${move down}

Move Document To End
    [Arguments]    ${Document Number}
    [Documentation]    Moves a document to the end of the record, based on the order within the record.
    ...    Note: first document = 1
    Open Document Header Tool Menu    ${Document Number}
    Robust Click    ${move to end}

Start Text Editor Edit Session
    [Arguments]    ${Document Number}
    [Documentation]    *Description*
    ...    Starts an edit session on the text document specified based on the order within the record.
    ...
    ...    *Arguments*
    ...    ${Document Number} = The number of the document being editted, based on the order in the record. First document = 0, second document = 1 etc
    ...
    ...    *Return value*
    ...    ${applet id} = The ID of the text editor applet created
    ...
    ...    *Precondition*
    ...    - The record must be opened for editing
    ...
    ...    *Example*
    ...    Lock Record For Editting
    ...    ${myApplet} = | Start Text Editor Edit Session | 1
    ...    Page Should Contain Element | ${myApplet}
    # handy shortcut to "select" item and show edit button
    Open Document Header Tool Menu    ${Document Number}
    Click Edit Document Button    ${Document Number}
    Wait Five Seconds
    ${applet id} =    Set Variable    //div[@id='document-body-${Document Number}-panel']//*//div[@class='mce-tinymce mce-container mce-panel']
    Wait Until Page Contains Element    xpath=${applet id}    30 sec
    [Return]    ${applet id}

Stop Text Editor Edit Session
    [Arguments]    ${Document Number}    ${applet number}=none
    [Documentation]    *Description*
    ...    Stops an edit session on the text document specified based on the order within the record.
    ...
    ...    *Arguments*
    ...    ${Document Number} = The number of the document being editted, based on the order in the record. First document = 1, second document = 2 etc
    ...    ${applet number}=none = Optional argument, the ID of the applet being closed. Will not be evaluated if not included.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - The record must be opened for editing
    ...
    ...    *Example*
    ...    Lock Record For Editting
    ...    ${myApplet} = | Start Text Editor Edit Session | 1
    ...    Stop Text Editor Edit Session | 1 | ${myApplet}
    Run Keyword Unless    "${applet number}"=="none"    Wait Until Page Contains Element    ${applet number}
    Apply Inline Edit    ${Document Number}
    Run Keyword Unless    "${applet number}"=="none"    Wait Until Page Does Not Contain Element    ${applet number}

Menu Option Should Be Enabled
    [Arguments]    ${menu option text}
    [Documentation]    *Description*
    ...    Evaluates an individual menu option to enusre it is enabled
    ...
    ...    *Arguments*
    ...    ${menu option text} = The text of the menu option being evaluated
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    The menu containing the menu option must have been opened using one of the keywords:
    ...    - Open Document Header Tool Menu
    ...    - Open Content Header Tool Menu
    ...    - Open Navigator Tool Menu
    ...    - Open Tile Header Tool Menu
    ...
    ...    *Example*
    ...    Lock Record For Editting
    ...    Open Document Header Tool Menu | 1 \ //Opening the tool menu for the first document in the record
    ...    Menu Option Should Be Enabled | Delete
    Wait Until Page Contains Element    xpath=//a[text()="${menu option text}"]    30s
    ${menu option display status} =    IDBSSelenium2Library.Get Element Attribute    xpath=//a[text()="${menu option text}"]@class
    ${check status}    ${value} =    Run Keyword And Ignore Error    Should Not Contain    ${menu option display status}    x-item-disabled
    Run Keyword If    '${check status}'=='FAIL'    Capture Page Screenshot
    Run Keyword If    '${check status}'=='FAIL'    Fail    Menu option "${menu option text}" was not enabled

Menu Option Should Not Be Enabled
    [Arguments]    ${menu option text}
    [Documentation]    *Description*
    ...    Evaluates an individual menu option to enusre it is disabled
    ...
    ...    *Arguments*
    ...    ${menu option text} = The text of the menu option being evaluated
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    The menu containing the menu option must have been opened using one of the keywords:
    ...    - Open Document Header Tool Menu
    ...    - Open Content Header Tool Menu
    ...    - Open Navigator Tool Menu
    ...    - Open Tile Header Tool Menu
    ...
    ...    *Example*
    ...    Open Document Header Tool Menu | 1 \ //Opening the tool menu for the first document in the record
    ...    Menu Option Should Not Be Enabled | Delete
    ${menu option display status} =    IDBSSelenium2Library.Get Element Attribute    xpath=//a[text()="${menu option text}"]@class
    ${check status}    ${value} =    Run Keyword And Ignore Error    Should Contain    ${menu option display status}    x-item-disabled
    Run Keyword If    '${check status}'=='FAIL'    Capture Page Screenshot
    Run Keyword If    '${check status}'=='FAIL'    Fail    Menu option "${menu option text}" was not disabled

Add Web Link
    [Arguments]    ${link address}    ${simulate_mouse_action}=${False}
    [Documentation]    *Description*
    ...    Adds a web link to an open record
    ...
    ...    *Arguments*
    ...
    ...    - ${link address} = The web link address being added to the record
    ...    - ${simulate_mouse_action} = Whether to use simulated mouse actions instead of Javascript to control the menu. Set to ${True} if required. Note: Setting to ${True} may introduce stability issues when executing tests locally.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - The record must be opened for editing
    ...
    ...    *Example*
    ...    Lock Record For Editting
    ...    Open Content Header Tool Menu
    ...    Menu Option Should Be Enabled | Insert Web Link
    ...    Add Web Link | http://www.idbs.com
    Open Insert Menu
    Robust Click    ewb-create-web-link
    Dialog Should Be Present    Web Link
    Input Text    ewb-web-link-text-editor    ${link address}
    Textfield Should Contain    ewb-web-link-text-editor    ${link address}
    Click OK
    Dialog Should Not Be Present    Web Link
    Wait Until Page Contains Element    xpath=//div[contains(@class,'ewb-document-body-container')]//a[@href='${link address}']

Record Should Contain Link
    [Arguments]    ${link address}    ${web page title}=none
    [Documentation]    *Description*
    ...    Checks that a link is present in the record and checks that it links to the correct page
    ...
    ...    *Arguments*
    ...    ${link address} = The web link address being added to the record
    ...    ${web page title}=none The title of the web page being linked to. This argument is optional, the page title will not be evaluated if this argument is not included.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - The record must be displayed when this keyword is called
    ...
    ...    *Example*
    ...    Record Should Contain Link | www.google.co.uk | Google
    Wait Until Page Contains Element    xpath=//a[text()="${link address}" and @href='${link address}']    30s
    Run Keyword Unless    '${web page title}'=='none'    Click Element    xpath=//a[text()="${link address}" and @href='${link address}']
    Run Keyword Unless    '${web page title}'=='none'    Wait Until Keyword Succeeds    10s    1s    Select Window    ${web page title}
    Run Keyword Unless    '${web page title}'=='none'    Close Window
    Run Keyword Unless    '${web page title}'=='none'    Select Window

Edit Web Link
    [Arguments]    ${document number}    ${link address}
    [Documentation]    *Description*
    ...    Edits an existing web link to an open record
    ...
    ...    *Arguments*
    ...    ${document number} = The position of the document in the record, first document = 1
    ...    ${link address} = The new web link address
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - The record must be opened for editing
    ...
    ...    *Example*
    ...    Lock Record For Editting
    ...    Edit Web Link | 1 | www.mynewaddress.com
    Select Document Header    ${document number}
    ${zeroIndex}=    Evaluate    ${document number}-1
    Click Edit Document Button    ${zeroIndex}
    Dialog Should Be Present    Edit Content
    Input Text    ewb-web-link-text-editor    ${link address}
    Textfield Should Contain    ewb-web-link-text-editor    ${link address}
    Click OK
    Dialog Should Not Be Present    Edit Content
    Wait For No Mask

Add Text Item
    [Documentation]    *Description*
    ...    Adds a new text item to an open record
    ...
    ...    *Arguments*
    ...    - None
    ...
    ...    *Return value*
    ...    - The Applet ID of the text item created
    ...
    ...    *Precondition*
    ...    - The record must be opened for editing
    ...
    ...    *Example*
    ...    Lock Record For Editting
    ...    Open Content Header Tool Menu
    ...    Menu Option Should Be Enabled | Insert Text
    ...    Add Text Item
    # check number of text items in the record
    ${xpath count} =    Get Matching Xpath Count    //div[contains(@class, 'ewb-editable-entity-title-itemTypeLabel') and contains(text(), 'Text')]
    Convert To Integer    ${xpath count}
    ${xpath count} =    Evaluate    ${xpath count}+1
    # insert new text item
    ${applet id}=    Wait Until Keyword Succeeds    60s    5s    __Insert new text item
    # check that text item is present in record
    Xpath Should Match X Times    //div[contains(@class, 'ewb-editable-entity-title-itemTypeLabel') and contains(text(), 'Text')]    ${xpath count}
    # check that new text item is in active edit mode
    Wait Until Page Contains Element    ${applet id}    30s
    [Return]    ${applet id}

Add File Item
    [Arguments]    ${File Item Type}    ${File Path}    ${Expected Dialog Title}    ${Expected File Type}=FILE    ${simulate_mouse_action}=${False}
    [Documentation]    Adds a new file item to an open record
    ...
    ...    *Arguments*
    ...    - ${File Item Type} = The item type of the file item being created
    ...    - ${File Path} = The path to the file (must be accessable from the automation client machine being used)
    ...    - ${Expected File Type} = Expected file type after insertion (e.g. Image files will automatically convert to images instead of file links), will default to FILE if not specified
    ...    - ${simulate_mouse_action} = Whether to use simulated mouse actions instead of Javascript to control the menu. Set to ${True} if required. Note: Setting to ${True} may introduce stability issues when executing tests locally.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - The record must be opened for editing
    ...
    ...    *Example*
    ...    | Lock Record For Editting |
    ...    | Open Content Header Tool Menu |
    ...    | Menu Option Should Be Enabled | Insert Text |
    ...    | Add File Item | Other | C:\\QTP Data\\E-WorkBook\\Test Data\\Search Test Data\\Images\\image.jpg | SVG_IMAGE |
    Get Next Document ID Set
    ${xpath count} =    Get Matching Xpath Count    //span[contains(@class, 'ewb-document-header-type') and contains(text(), '${File Item Type}')]
    Convert To Integer    ${xpath count}
    ${xpath count} =    Evaluate    ${xpath count}+1
    Open Insert Menu
    Robust Click    ewb-create-file-item
    Wait For Mask
    #Remove class attribute - makes the actual input field visible - required for WebDriver
    Wait Until Page Contains Element    ewb-web-file-input
    Execute Javascript    window.document.getElementById('ewb-web-file-input').removeAttribute('class');
    ${File Path}=    Normalize Path    ${File Path}
    Choose File    ewb-web-file-input    ${File Path}
    Click OK
    Wait For No Mask

Close Edit Properties Dialog and Save
    [Arguments]    ${record type}    ${save type}    ${username}=none    ${password}=none    ${save reason}=none    ${additional comments}=none
    [Documentation]    Closes an open properties dialog and saves
    ...
    ...    *Arguments*
    ...    ${record type} = the record type being acted upon e.g. "Experiment"
    ...    ${save type} = the type of save to be performed, either DRAFT or VERSION or NON_RECORD (NON_RECORD for non record entities which have no draft option) or CANCEL (cancels the save)
    ...    ${username}=none = username for version save
    ...    ${password}=none = password for version save
    ...    ${save reason}=none = save reason for version save
    ...    ${additional comments}=none = optional additional comments for version save
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - A dialog that prompts a save on clicking OK must be open
    ...
    ...    *Example*
    Save Entity Properties
    Wait Until Page Contains Element    xpath=//div[contains(@class,'ewbdialog')]
    ${dialog_message_reason}=    Run Keyword Unless    '${save type}'=='NON_RECORD'    Get Text    xpath=//div[contains(@class, 'ewb-message-box-text')]
    Run Keyword Unless    '${save type}'=='NON_RECORD'    Should Contain    ${dialog_message_reason}    Do you want to save these changes?
    Run Keyword If    '${save type}'=='DRAFT'    Robust Click    xpath=//button[text()="Save Draft"]
    Run Keyword If    '${save type}'=='VERSION'    Robust Click    xpath=//button[text()="Version"]
    Run Keyword If    '${save type}'=='CANCEL'    Click Cancel
    Run Keyword If    '${save type}'=='VERSION'    Properties Version Save    ${username}    ${password}    ${save reason}    ${additional comments}
    Run Keyword If    '${save type}'=='NON_RECORD'    Properties Version Save    ${username}    ${password}    ${save reason}    ${additional comments}
    Wait For No Mask

Add Page Break
    [Documentation]    *Description*
    ...    Adds a page break to an open record
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - The record must be opened for editing
    ...
    ...    *Example*
    ...    | Lock Record For Editting |
    ...    | Open Content Header Tool Menu |
    ...    | Menu Option Should Be Enabled | Insert Web Link |
    ...    | Add Page Break |
    ${xpath count} =    Get Matching Xpath Count    //div[contains(@class, 'ewb-page-break-root-container')]
    Convert To Integer    ${xpath count}
    ${xpath count} =    Evaluate    ${xpath count}+1
    Open Insert Menu
    Robust Click    ${Insert Page Break}
    Wait Until Keyword Succeeds    30s    5s    Xpath Should Match X Times    //div[contains(@class, 'ewb-page-break-root-container')]    ${xpath count}

Insert Entity Link
    [Arguments]    ${Navigator Level 1}    ${Navigator Level 2}=none    ${Navigator Level 3}=none    ${Navigator Level 4}=none    ${Navigator Level 5}=none    ${Navigator Level 6}=none
    ...    ${Navigator Level 7}=none    ${Navigator Level 8}=none    ${Navigator Level 9}=none    ${Navigator Level 10}=none    ${simulate_mouse_action}=${False}
    [Documentation]    *Inserts a new entity link into the open record*
    ...
    ...    *Arguments*
    ...    - ${Navigator Level 1} = the first entity in the entity link path (usually "Root")
    ...    - ${Navigator Level x}=none optional additional entities in the entity link path (up to 10 levels max)
    ...    - ${simulate_mouse_action} = Whether to use simulated mouse actions instead of Javascript to control the menu. Set to ${True} if required. Note: Setting to ${True} may introduce stability issues when executing tests locally.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - The record must be opened for editing
    ...
    ...    *Example*
    ...    | Lock Record For Editting |
    ...    | Open Content Header Tool Menu |
    ...    | Menu Option Should Be Enabled | Insert Entity Link |
    ...    | Insert Entity Link | Root | Testing | Steve | My Experiment |
    Open Insert Menu
    Robust Click    ewb-create-entity-link-command
    Dialog Should Be Present    Select an Item
    Click Navigator Node    ${Navigator Level 1}
    Run Keyword Unless    '${Navigator Level 2}'=='none'    Expand Navigator Node    ${Navigator Level 1}
    Run Keyword Unless    '${Navigator Level 2}'=='none'    Click Navigator Node    ${Navigator Level 2}
    Run Keyword Unless    '${Navigator Level 3}'=='none'    Expand Navigator Node    ${Navigator Level 2}
    Run Keyword Unless    '${Navigator Level 3}'=='none'    Click Navigator Node    ${Navigator Level 3}
    Run Keyword Unless    '${Navigator Level 4}'=='none'    Expand Navigator Node    ${Navigator Level 3}
    Run Keyword Unless    '${Navigator Level 4}'=='none'    Click Navigator Node    ${Navigator Level 4}
    Run Keyword Unless    '${Navigator Level 5}'=='none'    Expand Navigator Node    ${Navigator Level 4}
    Run Keyword Unless    '${Navigator Level 5}'=='none'    Click Navigator Node    ${Navigator Level 5}
    Run Keyword Unless    '${Navigator Level 6}'=='none'    Expand Navigator Node    ${Navigator Level 5}
    Run Keyword Unless    '${Navigator Level 6}'=='none'    Click Navigator Node    ${Navigator Level 6}
    Run Keyword Unless    '${Navigator Level 7}'=='none'    Expand Navigator Node    ${Navigator Level 6}
    Run Keyword Unless    '${Navigator Level 7}'=='none'    Click Navigator Node    ${Navigator Level 7}
    Run Keyword Unless    '${Navigator Level 8}'=='none'    Expand Navigator Node    ${Navigator Level 7}
    Run Keyword Unless    '${Navigator Level 8}'=='none'    Click Navigator Node    ${Navigator Level 8}
    Run Keyword Unless    '${Navigator Level 9}'=='none'    Expand Navigator Node    ${Navigator Level 8}
    Run Keyword Unless    '${Navigator Level 9}'=='none'    Click Navigator Node    ${Navigator Level 9}
    Run Keyword Unless    '${Navigator Level 10}'=='none'    Expand Navigator Node    ${Navigator Level 9}
    Run Keyword Unless    '${Navigator Level 10}'=='none'    Click Navigator Node    ${Navigator Level 10}
    Click OK

Edit Entity Link
    [Arguments]    ${document number}    ${Navigator Level 1}    ${Navigator Level 2}=none    ${Navigator Level 3}=none    ${Navigator Level 4}=none    ${Navigator Level 5}=none
    ...    ${Navigator Level 6}=none    ${Navigator Level 7}=none    ${Navigator Level 8}=none    ${Navigator Level 9}=none    ${Navigator Level 10}=none
    [Documentation]    *Inserts a new entity link into the open record*
    ...
    ...    *Arguments*
    ...    ${document number} = the number of the document to be edited, first document = 1
    ...    ${Navigator Level 1} = the first entity in the entity link path (usually "Root")
    ...    ${Navigator Level x}=none optional additional entities in the entity link path
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - The record must be opened for editing
    ...
    ...    *Example*
    ...    | Lock Record For Editting |
    ...    | Open Content Header Tool Menu |
    ...    | Menu Option Should Be Enabled | Insert Entity Link |
    ...    | Insert Entity Link | Root | Testing | Steve | My First Experiment |
    ...    | Record Should Contain Entity Link | My First Experiment | EXPERIMENT | /Root/Testing/Steve/My First Experiment | 1 |
    ...    | Edit Entity Link | 1 | Root | Testing | Steve | My Second Experiment |
    ...    | Record Should Contain Entity Link | My Second Experiment | EXPERIMENT | /Root/Testing/Steve/My Second Experiment | 1 |
    Select Document Header    ${document number}
    ${zeroIndex}=    Evaluate    ${document number}-1
    Click Edit Document Button    ${zeroIndex}
    Dialog Should Be Present    Select an Item
    Wait Five Seconds    # Waiting for dialog to expand all nodes first
    Expand Navigator Node    ${Navigator Level 1}
    Click Navigator Node    ${Navigator Level 1}
    Run Keyword Unless    '${Navigator Level 2}'=='none'    Expand Navigator Node    ${Navigator Level 1}
    Run Keyword Unless    '${Navigator Level 2}'=='none'    Click Navigator Node    ${Navigator Level 2}
    Run Keyword Unless    '${Navigator Level 3}'=='none'    Expand Navigator Node    ${Navigator Level 2}
    Run Keyword Unless    '${Navigator Level 3}'=='none'    Click Navigator Node    ${Navigator Level 3}
    Run Keyword Unless    '${Navigator Level 4}'=='none'    Expand Navigator Node    ${Navigator Level 3}
    Run Keyword Unless    '${Navigator Level 4}'=='none'    Click Navigator Node    ${Navigator Level 4}
    Run Keyword Unless    '${Navigator Level 5}'=='none'    Expand Navigator Node    ${Navigator Level 4}
    Run Keyword Unless    '${Navigator Level 5}'=='none'    Click Navigator Node    ${Navigator Level 5}
    Run Keyword Unless    '${Navigator Level 6}'=='none'    Expand Navigator Node    ${Navigator Level 5}
    Run Keyword Unless    '${Navigator Level 6}'=='none'    Click Navigator Node    ${Navigator Level 6}
    Run Keyword Unless    '${Navigator Level 7}'=='none'    Expand Navigator Node    ${Navigator Level 6}
    Run Keyword Unless    '${Navigator Level 7}'=='none'    Click Navigator Node    ${Navigator Level 7}
    Run Keyword Unless    '${Navigator Level 8}'=='none'    Expand Navigator Node    ${Navigator Level 7}
    Run Keyword Unless    '${Navigator Level 8}'=='none'    Click Navigator Node    ${Navigator Level 8}
    Run Keyword Unless    '${Navigator Level 9}'=='none'    Expand Navigator Node    ${Navigator Level 8}
    Run Keyword Unless    '${Navigator Level 9}'=='none'    Click Navigator Node    ${Navigator Level 9}
    Run Keyword Unless    '${Navigator Level 10}'=='none'    Expand Navigator Node    ${Navigator Level 9}
    Run Keyword Unless    '${Navigator Level 10}'=='none'    Click Navigator Node    ${Navigator Level 10}
    Click OK

Record Should Contain Entity Link
    [Arguments]    ${Entity Name}    ${Entity Type}    ${Entity Link Path}    ${Link Version}=${None}
    [Documentation]    *Validates an entity link in the open record*
    ...
    ...    *Arguments*
    ...    ${Entity Name} = The display name of the entity linked to
    ...    ${Entity Type} = The entity type as it appears in the Flexible Hierarchy e.g. EXPERIMENT or PROJECt etc
    ...    ${Entity Link Path} = The full path to the entity e.g. /Root/Testing/Steve/My Experiment
    ...    ${Link Version}=none Optional validation of the link version (not the version of the entity being linked to)
    ...    ${Property} = Optional validation of a property expected to be displayed
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - The record must be displayed within the web client
    ...
    ...    *Example*
    ...    | Lock Record For Editting |
    ...    | Open Content Header Tool Menu |
    ...    | Menu Option Should Be Enabled | Insert Entity Link |
    ...    | Insert Entity Link | Root | Testing | Steve | My Experiment |
    ...    | Record Should Contain Entity Link | My Experiment | EXPERIMENT | /Root/Testing/Steve/My Experiment | 1 |
    Run Keyword If    '${Link Version}'=='none'    Wait Until Page Contains Element    xpath=//div[contains(text(), '${Entity Name} Link:')]    30s
    Run Keyword Unless    '${Link Version}'=='none'    Wait Until Page Contains Element    xpath=//span[text()="(v${Link Version}) "]    30s
    Wait Until Page Contains Element    xpath=//img[contains(@src, '${Entity Type}')]    30s
    Wait Until Page Contains Element    xpath=//a[text()="${Entity Link Path}"]    30s

Click Entity Link
    [Arguments]    ${Entity Name}    ${Entity Link Path}    ${Enity Version Number}
    ${entity link href} =    IDBSSelenium2Library.Get Element Attribute    xpath=//a[text()="${Entity Link Path}"]@href
    Robust Link Click    xpath=//a[text()="${Entity Link Path}"]
    ${dialog check status}    ${dialog check value} =    Run Keyword And Ignore Error    Page Should Contain    are you sure you want to leave without saving your changes?
    Run Keyword If    '${dialog check status}'=='PASS'    Click OK
    Wait Until Keyword Succeeds    10s    0.1s    Select Window    title=IDBS E-WorkBook - ${Entity Name}
    Location Should Contain    ${entity link href}
    Open Record Properties
    Check Generic Attribute Value    Version number    1
    Click away from Property Panel
    Title Should Be    IDBS E-WorkBook - ${Entity Name}
    Close Window
    [Teardown]    Select Window

Override Lock
    [Arguments]    ${override lock}
    Run Keyword If    '${override lock}'=='yes'    Click OK
    Run Keyword If    '${override lock}'=='no'    Click Cancel

Open Record Editing Header Tool Menu
    Robust Click    ${record editing content header}
    Wait Until Page Contains Element    ${context tool menu}    30s

Minimal Record Mode
    [Documentation]    Puts the web client into "Minimal Record Mode".
    ...    Can only be used whilst a record entity is currently displayed.
    Open Content Header Tool Menu
    Robust Click    ${minimal record mode}

Full Record Mode
    [Documentation]    Puts the web client into "Full Record Mode".
    ...    Can only be used whilst a record entity is currently displayed.
    Open Content Header Tool Menu
    Robust Click    ${full record mode}

Version Save Record With Wait
    [Arguments]    ${username}    ${password}    ${save reason}    ${additional comments}=none
    [Documentation]    *DEPRECATED* USE "VERSION SAVE RECORD"
    ...
    ...    *Description*
    ...    Version saves the currently displayed record
    ...    (Modified to include a 5 \ sec wait before checking the authentication screen for the login-userid element, as it was failing on a second browser)
    ...
    ...
    ...    *Arguments*
    ...    ${username} = the currently authenticated user name
    ...    ${password} = the currently authenticated password
    ...    ${save reason} = the reason for save - must be a valid reason (pick up from Experiment Save Reasons catalog term)
    ...    ${additional comments}=none = optional additional save comments to be added to the save
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - The version save option must be active, else this keyword will fail
    ...
    ...    *Example*
    ...    Lock Record For Editting
    ...    Open Content Header Tool Menu
    ...    Add Text Item | Abstract
    ...    Version Save Record | Administrator | Administrator | Data Added | Saving with new text item in place
    Wait Until Keyword Succeeds    30s    5s    Open Record Editing Header Tool Menu
    ${menu save status} =    IDBSSelenium2Library.Get Element Attribute    ${version save record}@class
    Should Not Contain    ${menu save status}    x-item-disabled
    Robust Click    ${version save record}
    Dialog Should Be Present    Indicate the reason for saving the record
    Robust Click    xpath=//div[text()="${save reason}"]
    ${Attribute}    IDBSSelenium2Library.Get Element Attribute    xpath=//div[text()="${save reason}"]@class
    Should Contain    ${Attribute}    ewb-listbox-item-selected
    Run Keyword Unless    '${additional comments}'=='none'    Input Text    xpath=//textarea[contains(@class,'ewb-textbox')]    ${additional comments}
    Run Keyword Unless    '${additional comments}'=='none'    Textfield Should Contain    xpath=//textarea[contains(@class,'ewb-textbox')]    ${additional comments}
    Click OK
    Dialog Should Not Be Present    Indicate the reason for saving the record
    Wait Five Seconds
    Authenticate Session    ${username}    ${password}

Set Sequential Edit
    [Arguments]    ${toggle_status}
    [Documentation]    *Description*
    ...    Sets the sequential editing status for a template
    ...
    ...    *Arguments*
    ...    ${toggle_status} = possible values are 'on' or 'off'
    ${sequential}=    Get Record Sequential State
    ${prev_kw}=    Register Keyword To Run On Failure    Nothing    #Handle capturing of page screenshots on IE when accessing context menus
    ${status}    ${value}=    Run Keyword And Ignore Error    Open Content Header Tool Menu
    Run Keyword If    '${status}'=='FAIL'    Capture Page Screenshot
    Run Keyword If    '${status}'=='FAIL'    Fail    Failed to open Context Menu
    ${status}    ${value}=    Run Keyword And Ignore Error    Run Keyword If    '${sequential}'!='${toggle_status}'    Robust Click    ${template sequential edit menu}
    Run Keyword If    '${status}'=='FAIL'    Capture Page Screenshot
    Run Keyword If    '${status}'=='FAIL'    Fail    Failed to toggle sequential edit
    [Teardown]    Register Keyword To Run On Failure    Capture Page Screenshot

Set Confined
    [Arguments]    ${toggle_status}
    [Documentation]    *Description*
    ...    Sets the confined editing status for a template
    ...
    ...    *Arguments*
    ...    ${toggle_status} = possible values are 'on' or 'off'
    ${confined}=    Get Record Confined State
    ${prev_kw}=    Register Keyword To Run On Failure    Nothing    #Handle capturing of page screenshots on IE when accessing context menus
    ${status}    ${value}=    Run Keyword And Ignore Error    Open Content Header Tool Menu
    Run Keyword If    '${status}'=='FAIL'    Capture Page Screenshot
    Run Keyword If    '${status}'=='FAIL'    Fail    Failed to open Context Menu
    ${status}    ${value}=    Run Keyword And Ignore Error    Run Keyword If    '${confined}'!='${toggle_status}'    Robust Click    ${template confined edit menu}
    Run Keyword If    '${status}'=='FAIL'    Capture Page Screenshot
    Run Keyword If    '${status}'=='FAIL'    Fail    Failed to toggle confined edit
    [Teardown]    Register Keyword To Run On Failure    Capture Page Screenshot

Select Document Header
    [Arguments]    ${document number}
    [Documentation]    *Description*
    ...    Selects the header of a document in order for it to appear selected, and to have the document attributes present in the properties panel
    Robust Click    xpath=//div[@class='ewb-document-panel-inner dragdrop-dropTarget']/div[${document number}]/div[@class='ewb-document-container-header']//span[contains(@class, 'ewb-document-header-type')]
    # The above click may cause the page to scroll, on most browsers this doesn't cause an issue. However on Chrome, this can stop subsequent clicks in the document header from working. Waiting until the document has the 'selected' class seems to help.
    # Added 'Run Keyword And Ignore Error' because in some cases (Signoff) the document panel won't have a selected class added to it
    Run Keyword And Ignore Error    Wait Until Page Contains Element    xpath=//div[@class='ewb-document-panel-inner dragdrop-dropTarget']/div[${document number} and contains(@class,'ewb-document-container-selected')]    2s

Template Pinning Buttons Should Be Enabled
    ${Attribute}    IDBSSelenium2Library.Get Element Attribute    xpath=//img[@id='${pin all items button}']@class
    Should Not Contain    ${Attribute}    ewb-disabled

Template Pinning Buttons Should Not Be Enabled
    ${Attribute}    IDBSSelenium2Library.Get Element Attribute    xpath=//img[@id='${pin all items button}']@class
    Should Contain    ${Attribute}    ewb-disabled

Pin Document
    [Arguments]    ${document number}
    [Documentation]    *Description*
    ...    Clicks the pinned indicator on a document, verifying that the original value was unpinned (Pinned Entity attribute = false).
    ...
    ...    *Precondition*
    ...    A template is open for edit.
    ...
    ...    *Arguments*
    ...    ${document number} - The 1 based index of the document in the tempate
    Select Document Header    ${document number}
    ${document number}    Evaluate    ${document number}-1
    ${pass}    ${error} =    Run Keyword And Ignore Error    Wait Until Page Contains Element    xpath=//*[@id='document-header-${document number}-pinButton' and contains(@class,'is-not-pinned')]
    Run Keyword If    '${pass}' == 'PASS'    Robust Click    document-header-${document number}-pinButton    image
    Run Keyword If    '${pass}' == 'PASS'    Wait Until Page Contains Element    xpath=//*[@id='document-header-${document number}-pinButton' and contains(@class,'is-pinned')]

Unpin Document
    [Arguments]    ${document number}
    [Documentation]    *Description*
    ...    Clicks the pinned indicator on a document, verifying that the original value was pinned (Pinned Entity attribute = true).
    ...
    ...    *Precondition*
    ...    A template is open for edit.
    ...
    ...    *Arguments*
    ...    ${document number} - The 1 based index of the document in the tempate
    ${document number}    Evaluate    ${document number}-1
    ${pass}    ${error} =    Run Keyword And Ignore Error    Wait Until Page Contains Element    xpath=//*[@id='document-header-${document number}-pinButton' and contains(@class,'is-pinned')]
    Run Keyword If    '${pass}' == 'PASS'    Robust Click    document-header-${document number}-pinButton    image
    Run Keyword If    '${pass}' == 'PASS'    Wait Until Page Contains Element    xpath=//*[@id='document-header-${document number}-pinButton' and contains(@class,'is-not-pinned')]

Unpin All Documents
    [Documentation]    Unpins all items in the template
    Robust Click    ${unpin all items button}
    Wait Until Page Contains Element    xpath=//*[@id='document-header-0-pinButton' and contains(@class,'is-not-pinned')]

Pin All Documents
    [Documentation]    Pins all items in the open template
    Robust Click    ${pin all items button}
    Wait Until Page Contains Element    xpath=//*[@id='document-header-0-pinButton' and contains(@class,'is-pinned')]

Close Locked For Edit Warning
    [Arguments]    ${locked_user}
    [Documentation]    *Description*
    ...
    ...    Checks the Message box displays the Warning "${page locked for editing message}"
    ...    and then closes the dialogue via a close button click
    Wait Until Page Contains Element    ${dialog container}    30s
    Element Text Should Be    ${message box text locator}    ${page locked for editing message} ${locked_user}
    Robust Click    okButton

Check Edit Link is Editing
    [Documentation]    Checks that the save menu is visible (i.e. the record is locked) for the currently displayed record and also that the button text is "Save As"
    ...
    ...    *Arguments*
    ...
    ...    None
    ...
    ...    *Return Value*
    ...
    ...    None
    Wait Until Element Is Visible    ${record editing content header}    10s
    Wait Until Element Text Contains    ${record editing content header}    Save As    10s

Check Panel Header Text Contains
    [Arguments]    ${Edit Text}
    [Documentation]    Ensures Panel Header contains the text ${Edit Text}
    ...
    ...    Example options:
    ...
    ...    (Sequential)
    ...    (Confined)
    ...    (Confined and Sequential)
    Wait Until Element Text Contains    ${panel header label}    ${Edit Text}    30s

Check Panel Header Text is Not
    [Arguments]    ${Edit Text}
    [Documentation]    Ensures the page doesn't contain the text ${Edit Text}
    ...
    ...    Example options:
    ...
    ...    (Sequential)
    ...    (Confined)
    ...    (Confined and Sequential)
    Wait Until Page Does Not Contain    ${Edit Text}    30s

Save Changes Prompt Dialogue
    [Arguments]    ${entity name}    ${save choice}=DRAFT
    [Documentation]    Checks dialog is present when navigating away from an unlocked entity with changes
    ...
    ...    ${save choice} will select appropriate button from dialogue, with the default set to DRAFT
    ...
    ...    DRAFT
    ...
    ...    VERSION
    ...
    ...    NO
    ...
    ...    CANCEL
    Wait Until Page Contains Element    ${dialog container}    10s
    Element Should Contain    ${message box text locator}    Changes have been made to data in ${entity name}.
    Element Should Contain    ${message box text locator}    Save session first?
    Run Keyword If    '${save choice}'=='DRAFT'    Robust Click    xpath=//button[text()='Save Draft']
    Run Keyword If    '${save choice}'=='VERSION'    Robust Click    xpath=//button[text()='Version']
    Run Keyword If    '${save choice}'=='CANCEL'    Robust Click    xpath=//button[text()='Cancel']
    Run Keyword If    '${save choice}'=='NO'    Robust Click    xpath=//button[text()='No']

Changes Lost Prompt Dialogue
    [Arguments]    ${button choice}
    [Documentation]    Checks dialog is present to confirm choice when navigating away from an unlocked entity with changes and clicking No to Save session
    ...
    ...    ${button choice} will select appropriate button from dialogue:
    ...
    ...    OK
    ...
    ...    CANCEL
    Wait Until Page Contains Element    ${dialog container}    30s
    Element Should Contain    ${message box text locator}    The record contains modifications which will be lost by continuing.
    Element Should Contain    ${message box text locator}    Are you sure you want to close?
    Run Keyword If    '${button choice}'=='OK'    Robust Click    okButton
    Run Keyword If    '${button choice}'=='CANCEL'    Robust Click    cancelButton

Open Insert Menu
    Open Insert Menu No Check
    Wait Until Page Contains Element    ${Insert Record Menu}    20s

Open Insert Menu No Check
    Wait For Record Outline
    Robust Click    ewb-insert-record-item-button

Check Draft Save is Enabled
    [Documentation]    Checks that Draft save is not disabled
    Robust Click    ${record editing content header}
    Wait Until Page Contains Element    ewb-editor-command-draft-save-record    30s
    ${menu status} =    IDBSSelenium2Library.Get Element Attribute    ewb-editor-command-draft-save-record@class
    Should Not Contain    ${menu status}    x-item-disabled

Check Version Save is Enabled
    [Documentation]    Checks that Version save is not disabled
    Robust Click    ${record editing content header}
    Wait Until Page Contains Element    ewb-editor-command-version-save-record    30s
    ${menu status} =    IDBSSelenium2Library.Get Element Attribute    ewb-editor-command-version-save-record@class
    Should Not Contain    ${menu status}    x-item-disabled

Check Draft Save is Disabled
    [Documentation]    Checks that Draft save is disabled
    Robust Click    ${record editing content header}
    Wait Until Page Contains Element    ewb-editor-command-draft-save-record    30s
    ${menu status} =    IDBSSelenium2Library.Get Element Attribute    ewb-editor-command-draft-save-record@class
    Should Contain    ${menu status}    x-item-disabled

Check Version Save is Disabled
    [Documentation]    Checks that Version save is disabled
    Robust Click    ${record editing content header}
    Wait Until Page Contains Element    ewb-editor-command-version-save-record    30s
    ${menu status} =    IDBSSelenium2Library.Get Element Attribute    ewb-editor-command-version-save-record@class
    Should Contain    ${menu status}    x-item-disabled

Document Type Should be
    [Arguments]    ${document number}    ${type}
    [Documentation]    Checks that a document in position '${document number}' should contain the type '${type}'
    ...
    ...    Document number starts at 0
    ...
    ...    For use in checking document positon when moving documents
    Wait Until Element Text Contains    xpath=//div[contains(@class, 'ewb-document-panel-inner')]/div[${document number}]    ${type}    30s

Open Editing Options And Check If Record Dirty
    [Arguments]    ${dirty}=yes    ${check_draft}=yes    ${check_version}=yes    ${timeout}=30s
    [Documentation]    Checks whether the draft and version save options are active (and therefore if the record is marked as being dirty)
    ...
    ...    *Arguments*
    ...
    ...    _dirty_ - Whether the record should be dirty at the point of calling this keyword. Defaults to "yes". Set to "no" if not expected to be dirty
    ...
    ...    _check_draft_ - Whether the draft save option should be checked. Defaults to "yes". Set to "no" if the keyword should not check the draft save state
    ...
    ...    _check_version_ - Whether the version save option should be checked. Defaults to "yes". Set to "no" if the keyword should not check the version save state
    ...
    ...    _timeout_ - The length of time to keep checking the record state before failing the keyword. Defaults to 30s. Change to any valid Robot Framework time format if a different format is required
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    The record being evaluated must be displayed in the browser at the point of calling this keyword
    ...
    ...    *Examples*
    ...
    ...    1. Checks draft and version save options assuming record is dirty
    ...    | Open Editing Options And Check If Record Dirty |
    ...    2. Checks draft and version save options assuming record is *NOT* dirty
    ...    | Open Editing Options And Check If Record Dirty | dirty=no |
    ...    3. Checks version save option only assuming record is dirty
    ...    | Open Editing Options And Check If Record Dirty | check_draft=no |
    Wait Until Keyword Succeeds    ${timeout}    1s    _Open Editing Options And Check If Record Dirty Once    ${dirty}    ${check_draft}    ${check_version}

_Open Editing Options And Check If Record Dirty Once
    [Arguments]    ${dirty}=yes    ${check_draft}=yes    ${check_version}=yes
    [Documentation]    *HELPER KEYWORD - USE "Open Editing Options And Check If Record Dirty" RATHER THAN CALLING THIS KEYWORD DIRECTLY
    Open Record Editing Header Tool Menu
    ${version menu save status} =    IDBSSelenium2Library.Get Element Attribute    ${version save record}@class
    ${draft menu save status} =    IDBSSelenium2Library.Get Element Attribute    ${draft save record}@class
    Run Keyword If    '${dirty}'=='yes' and '${check_draft}'=='yes'    Should Not Contain    ${draft menu save status}    x-item-disabled    Draft save menu option should be enabled
    Run Keyword If    '${dirty}'=='no' and '${check_draft}'=='yes'    Should Contain    ${draft menu save status}    x-item-disabled    Draft save menu option should be disabled
    Run Keyword If    '${dirty}'=='yes' and '${check_version}'=='yes'    Should Not Contain    ${version menu save status}    x-item-disabled    Version save menu option should be enabled
    Run Keyword If    '${dirty}'=='no' and '${check_version}'=='yes'    Should Contain    ${version menu save status}    x-item-disabled    Version save menu option should be disabled
    Comment    Mouse Down    ewb-record-header-panel
    Comment    Mouse Up    ewb-record-header-panel
    Comment    Robust Click    xpath=//*[@class="ewb-record-document-container"]

Wait Until Document Present
    [Arguments]    ${document_number}
    [Documentation]    Waits until the document with the given _document_number_ is present on the page.
    Wait Until Page Contains Element    document-header-${document_number}-menuButton

Unlock Record No Check
    [Documentation]    Clicks the unlock record option in the record editing menu. Does not check for and save dialogs or changes lost messages.
    Wait Until Keyword Succeeds    10s    0.1s    Open Record Editing Header Tool Menu
    Click Link    xpath=//li[@id='${unlock record}']/a

Hover Over Menu Item
    [Arguments]    ${menu_item_text}    ${simulate_mouse_events}=${False}
    [Documentation]    Hovers over a given menu item using the text to locate the menu element
    ...
    ...    *Arguments*
    ...    - menu_item_text = The text of the menu item (case sensitive)
    ...    - simulate_mouse_action = Whether to use simulated mouse actions instead of Javascript to control the menu. Set to ${True} if required. Note: Setting to ${True} may introduce stability issues when executing tests locally.
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...    | Hover Over Menu Item | Insert Link | ${True} |
    Wait Until Page Contains    ${menu_item_text}
    ${element_id}=    IDBSSelenium2Library.Get Element Attribute    xpath=//*[@id="ewb-popup-menu"]//*[text()="${menu_item_text}"]@id
    Run Keyword If    ${simulate_mouse_events}    Native Hover    ${element_id}
    Run Keyword Unless    ${simulate_mouse_events}    _Hover    ${element_id}

Click Menu Item
    [Arguments]    ${menu_item_text}
    [Documentation]    Performs a click action on the given menu item
    ...
    ...    *Arguments*
    ...    - menu_item_text - the text of the menu item to click (case sensitive)
    ...
    ...    *Return Value*
    ...
    ...    None
    Robust Click    xpath=//*[text()="${menu_item_text}"]

Native Hover
    [Arguments]    ${menu_element_id}
    [Documentation]    Performs a hover on a given menu item in order to bring up a sub-menu. The keyword subsequently shifts the focus to the sub-menu in order to prevent the menu from being closed.
    ...
    ...    *Arguments*
    ...    - menu_element_id - The ID of the menu element to hoever over
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...    | Native Hover | ewb-create-link-item |
    Run Keyword Unless    '${OPERATING_SYSTEM}'=='OSX'    Wait Until Keyword Succeeds    10s    0.1s    Mouse Over    xpath=//*[@id="${menu_element_id}"]/..
    Run Keyword Unless    '${OPERATING_SYSTEM}'=='OSX'    Wait Until Keyword Succeeds    10s    0.1s    Mouse Over    xpath=//*[contains(@class, 'x-menu x-component')][2]//*[contains(@class, 'x-menu-list-item')][1]
    Run Keyword If    '${OPERATING_SYSTEM}'=='OSX'    Log    Native events not supported on OSX, reverting to Javascript simulated hover    level=WARN
    Run Keyword If    '${OPERATING_SYSTEM}'=='OSX'    Wait Until Keyword Succeeds    10s    0.1s    _Hover    ${menu_element_id}

Follow Record
    [Documentation]    Clicks the 'Follow' record button to follow a record(only if the record is unfollowed)
    ${classes}    IDBSSelenium2Library.Get Element Attribute    ${ewb-follow-record}@class
    Run Keyword If    'off' in '${classes}'    Click Element    ${ewb-follow-record}
    Wait Until Page Contains Element    xpath=//*[contains(@class, 'on') and @id="${ewb-follow-record}"]    10s

Unfollow Record
    [Documentation]    Clicks the 'Following' record button to unfollow a record(only if the record is followed)
    ${classes}    IDBSSelenium2Library.Get Element Attribute    ${ewb-follow-record}@class
    Run Keyword If    'on' in '${classes}'    Click Element    ${ewb-follow-record}
    Wait Until Page Contains Element    xpath=//*[contains(@class, 'off') and @id="${ewb-follow-record}"]    10s

Get Image Entity Id
    [Arguments]    ${Record_Index}
    [Documentation]    This keyword searches for an item identified by *${Record_Index}* and sets the variable *${IMAGE_ENTITY_ID}* to be equal to the entity id of that image.
    ...
    ...    This only functions for images, if the ${Record_Index} does not point at an image it will fail.
    ...
    ...    *${Record_Index}* = the position of the item you wish to grab the entity id for, this only works for an image. E.g.: the first item in a record is an image, to get the entity id input the value *1*. If the fourth item is an image input the value *4*.
    ...
    ...    *${IMAGE_ENTITY_ID}* = the return value of the image.
    ${TEMP}=    IDBSSelenium2Library.Get Element Attribute    xpath=//div[contains(@id,'document-body-${Record_Index}-panel')]//tbody/tr/td/div/img@id
    ${IMAGE_ENTITY_ID}=    Fetch From Left    ${TEMP}    -
    [Return]    ${IMAGE_ENTITY_ID}

Click Image Download Link
    [Arguments]    ${Record_Index}
    [Documentation]    Clicks the image download button for the image identified by *${Record_Index}*.
    ...
    ...    *${Record_Index}* = the position of the item you wish to grab the entity id for, this only works for an image. E.g.: the first item in a record is an image, to get the entity id input the value *1*. If the fourth item is an image input the value *4*.
    Open Document Header Tool Menu    ${Record_Index}
    Click Element    ewb-file-download

Record Contains Item
    [Arguments]    ${Document_Index}    ${Item_Version_Number}    ${Caption_Yes_or_No}    ${Item_Type}    ${Caption}=${EMPTY}
    [Documentation]    This ensures that an item identified by *${Item_Version_Number}* and *${Item_Type}* (and *${Caption}* if relevant) is present in the record.
    ...
    ...    *${Document_Index}* = the position of the item in the record, first item = 0, second item = 1, etc.
    ...    *${Item_Version_Number}* = The version number of the item
    ...    *${Item_Type}* = The displayed item type e.g.: Abstract, Other, etc.
    ...    *${Caption_Yes_or_No}* = \ This only accepts the values Y and N. This is used to determine which of two keywords is run using a *Run Keyword If* section. Y if it has a caption and N if it does not.
    ...    *${Caption}* = The name of the uploaded file or item caption. This defaults to empty if there is no value input.
    Page Should Contain Element    xpath=//div[contains(@id,'document-header-${Document_Index}-itemTypeLabel') and text()="${Item_Type}:"]
    Page Should Contain Element    xpath=//span[contains(@class,'ewb-document-header-type ewb-label') and text()="(v${Item_Version_number}) "]
    Run Keyword If    '${Caption_Yes_or_No}' == 'Y'    Page Should Contain Element    xpath=//span[contains(@id,'document-header-${Document_Index}-editableTitleTable') and text()="${Caption}"]

Download Image From Record
    [Arguments]    ${image_caption}    ${download_location}    ${record_index}
    [Documentation]    Downloads an image from the currently displayed record (using the image caption for location) and saves it to a given location.
    ...
    ...    *Arguments*
    ...    - _image_caption_ - The image caption as it appears in the record
    ...    - _download_location_ - The location to download the image to
    ...
    ...    *Preconditions*
    ...
    ...    The image must be displayed in the browser before calling this keyword. The record can be open or closed to editing.
    ...
    ...    *Example*
    ...    | Download Image From Record | my_image.jpg | ${OUTPUT_DIR}/my_image_downloaded.jpg |
    ...    | Compare Images | ${OUTPUT_DIR}/my_image_downloaded.jpg | Expected Results/Web Client/Images/my_expected_image.jpg |
    Comment    Robust Click    xpath=//span[text()="${image_caption}"]
    Click Image Download Link    ${record_index}
    Comment    ${image_id}=    IDBSSelenium2Library.Get Element Attribute    xpath=//span[text()="${image_caption}"]@id
    Comment    ${image_id}    ${discarded_string}=    Split String    ${image_id}    -    1
    ${image_id}=    Get Image Entity Id    ${record_index}
    Comment    Select Frame    xpath=//iframe[@id="dlframe"][contains(@src,'JPGFile.jpg')]
    Wait Until Page Contains Element    xpath=//iframe[@id="dlframe" and contains(@src, '${image_id}')]    30s
    ${download_source}=    IDBSSelenium2Library.Get Element Attribute    dlframe@src
    WebHelperFunctions.Download File From EWB    ${download_source}    ${download_location}

Click Edit Document Button
    [Arguments]    ${document number}
    [Documentation]    Clicks the Edit button associated to a document number
    Robust Click    document-header-${document number}-entityImage
    Sleep    0.5
    ${edit_button}=    Generate Edit Document Button xPath    ${document number}
    Robust Click    ${edit_button}

Open Document To View
    [Arguments]    ${document number}
    [Documentation]    Click the View button associated to a document number
    Robust Click    document-body-${document number}-panel
    Robust Click    xpath=//div[@id='document-header-${document number}-customWidget-viewButton']/a
    sleep    3s
    Comment    Run Keyword If    '${BROWSER}'=='FIREFOX' or '${BROWSER}'=='ff' or '${BROWSER}'=='firefox'    PyWinAutoLibrary.Generic Select Window    regexp=.*Launch*
    Comment    Run Keyword If    '${BROWSER}'=='FIREFOX' or '${BROWSER}'=='ff' or '${BROWSER}'=='firefox'    PyWinAutoLibrary.Generic Send Keystrokes    {ENTER}

Open Document To Edit
    [Arguments]    ${document number}
    [Documentation]    Click the Edit button associated to a document number
    Robust Click    document-body-${document number}-panel
    Robust Click    xpath=//div[@id='document-header-${document number}-customWidget-editButton']/a
    sleep    3s
    Comment    Run Keyword If    '${BROWSER}'=='FIREFOX' or '${BROWSER}'=='ff' or '${BROWSER}'=='firefox'    PyWinAutoLibrary.Generic Select Window    regexp=.*Launch*
    Comment    Run Keyword If    '${BROWSER}'=='FIREFOX' or '${BROWSER}'=='ff' or '${BROWSER}'=='firefox'    PyWinAutoLibrary.Generic Send Keystrokes    {ENTER}

Cancel Inline Edit
    [Arguments]    ${document number}
    Robust Click    xpath=//*[@id='document-header-${document number}-customWidget-acceptAndDiscard']/tbody/tr/td/button[text()='Discard']

Apply Inline Edit
    [Arguments]    ${document number}
    Robust Click    //*[@id="document-header-${document number}-customWidget-acceptAndDiscard"]//*[@title="Apply Changes"]

Prevent Further Editing
    Open Record Header Tool Menu    ${prevent-further-editing-id}

Allow Further Editing
    [Arguments]    ${user-name}=${VALID USER}    ${password}=${VALID PASSWD}
    Open Record Header Tool Menu    ${allow-further-editing-id}
    Authenticate Session    ${user-name}    ${password}

Confirm Record Can Be Edited
    [Documentation]    Confirms that the record can be edited by checking to see if an item within the insert menu is available and isn't disabled
    Robust Click    ${Insert Record Menu}
    Wait Until Page Contains Element    ewb-new-entity-dialog-popup
    Click away from Property Panel

Confirm Prevent Further Editing Not Available
    [Documentation]    Confirms that a dialog is displayed when the user clicks the 'prevent further editing' menu option.
    Prevent Further Editing
    Robust Click    okButton

Confirm Prevent Further Editing Disabled
    [Documentation]    Confirms that the 'prevent further editing' menu option is disabled
    Open Record Header Tool Menu
    Menu Option Should Not Be Enabled    Prevent Further Editing

Confirm Prevent Further Editing Available
    [Documentation]    Confirms that the prevent further editing menu option is available
    Open Record Header Tool Menu
    Wait Until Page Contains Element    ${prevent-further-editing-id}    30s

Confirm Allow Further Editing Disabled
    [Documentation]    Confirms that the allow further editing menu option is disabled
    Open Record Header Tool Menu
    Menu Option Should Not Be Enabled    Allow Further Editing

Delete All Comments
    Open Record Header Tool Menu    ${delete-all-comments-id}
    Page Should Contain Button    //*[@id='okButton' and text()='Yes']
    Page Should Contain Button    //*[@id='cancelButton' and text()='No']

Delete All Comments Confirmed
    Delete All Comments
    Robust Click    okButton
    Wait Until Keyword Succeeds    30s    3s    Confirm Record Comment Count Is    0
    Wait Until Keyword Succeeds    30s    3s    Confirm Document Comment Count Is    0    0

Confirm Record Comment Count Is
    [Arguments]    ${expectedCommentCount}
    ${record-comment-count}    Get Text    //*[@id='ewb-record-action-bar-comments-count']
    Should Be Equal As Integers    ${record-comment-count}    ${expectedCommentCount}

Confirm Document Comment Count Is
    [Arguments]    ${documentNumber}    ${expectedCommentCount}
    ${document-comment-count}    Get Text    //*[@id='document-header-${documentNumber}-commentsButton']/div/div
    Should Be Equal As Integers    ${document-comment-count}    ${expectedCommentCount}

Delete All Comments Cancelled
    Wait Until Page Contains Element    //*[@id='ewb-record-action-bar-comments-count']    30s
    ${original-record-comment-count}    Get Text    //*[@id='ewb-record-action-bar-comments-count']
    ${original-document-comment-count}    Get Text    //*[@id='document-header-0-commentsButton']/div/div
    Delete All Comments
    Robust Click    cancelButton
    ${record-comment-count}    Get Text    //*[@id='ewb-record-action-bar-comments-count']
    ${document-comment-count}    Get Text    //*[@id='document-header-0-commentsButton']/div/div
    Should Be Equal As Integers    ${record-comment-count}    ${original-record-comment-count}
    Should Be Equal As Integers    ${document-comment-count}    ${original-document-comment-count}

Delete All Comments Disabled
    Wait Until Page Contains Element    //*[@id='ewb-record-action-bar-comments-count']    30s
    ${original-record-comment-count}    Get Text    //*[@id='ewb-record-action-bar-comments-count']
    ${original-document-comment-count}    Get Text    //*[@id='document-header-0-commentsButton']/div/div
    Open Record Header Tool Menu    ${delete-all-comments-id}
    Page Should Not Contain Button    //*[@id='okButton' and text()='Yes']
    Page Should Not Contain Button    //*[@id='cancelButton' and text()='No']
    ${record-comment-count}    Get Text    //*[@id='ewb-record-action-bar-comments-count']
    ${document-comment-count}    Get Text    //*[@id='document-header-0-commentsButton']/div/div
    Should Be Equal As Integers    ${record-comment-count}    ${original-record-comment-count}
    Should Be Equal As Integers    ${document-comment-count}    ${original-document-comment-count}

Confirm Delete All Comments Enabled
    Wait Until Keyword Succeeds    30s    0.5s    Open Record Header Tool Menu
    Menu Option Should Be Enabled    ${delete-all-comments}

Confirm Delete All Comments Not Enabled
    Open Record Header Tool Menu
    Menu Option Should Not Be Enabled    ${delete-all-comments}

Select User Action Note
    [Arguments]    ${action note}
    [Documentation]    Select the user action note
    Select And Confirm Combobox Value    ${user action note id}    ${action note}

Confirm User Action Note Value
    [Arguments]    ${expected value}
    Confirm Combobox Value    ${user action note id}    ${expected value}

Select Move Entity in Record
    [Documentation]    Selects move entity command in the record menu
    Open Content Header Tool Menu
    Robust Click    ${ewb-entity-command-move}
    Dialog Should Be Present    Select a place on the hierarchy to move to

Click Publish
    [Documentation]    Selects the 'Publish' option in the record header menu
    Attempt Publishing - No Check
    Wait For No Mask

Confirm Publish Progress Dialog Displayed
    Wait Until Page Contains Element    xpath=//*[@id='ewb-publish-entity-dialog']    30s

Confirm Publish Flag Not Present
    [Arguments]    ${Document Number}
    Wait Until Element Is Not Visible    document-header-${Document Number}-publishedImage    30s

Confirm Publish Flag Present
    [Arguments]    ${Document Number}
    Wait Until Page Contains Element    document-header-${Document Number}-publishedImage    60s

Confirm PDFs Folder Not Present
    [Arguments]    ${experiment name}
    Page Should Not Contain Element    xpath=//div[@title='${experiment name}']//a[text()='PDFs']

Confirm PDFs Folder Present
    [Arguments]    ${experiment name}
    Wait Until Page Contains Element    xpath=//div[@title='${experiment name}']//a[text()='PDFs']    30s

Confirm Publish Completed
    [Documentation]    Waits up to 60 seconds for the publish dialog to close
    Wait Until Page Does Not Contain Element    ewb-publish-entity-dialog    60s

Set Prevent Comments Being Added Or Edited System Settings Enabled
    [Arguments]    ${enabled}
    Connect To Database    ${CORE_USERNAME}    ${CORE_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    ${FIND_SETTING}    Query    SELECT COUNT(*) FROM system_settings ss WHERE ss.settings_name = 'Prevent Comment Addition And Edit When Published Enabled'
    Run Keyword If    ${FIND_SETTING[0][0]} == 0    Execute    INSERT INTO system_settings (SYSTEM_SETTINGS_ID,SETTINGS_NAME,ORDER_KEY,DATA_TYPE,STRING_DATA) VALUES ('BA6A1C73C6B14A03BE3D0D855B071481', 'Prevent Comment Addition And Edit When Published Enabled', 0, 'BOOLEAN', 'true')
    Execute    UPDATE system_settings ss SET ss.string_data = '${enabled}' WHERE ss.system_settings_id = 'BA6A1C73C6B14A03BE3D0D855B071481'
    Disconnect From Database

Confirm Export To PDF Available
    [Documentation]    Confirms that the export to pdf menu option is available
    Open Record Header Tool Menu
    Wait Until Page Contains Element    ${export-to-pdf-id}

Click Export To PDF
    [Arguments]    ${experiment name}    ${experiment id}
    Open Record Header Tool Menu    ${export-to-pdf-id}
    Comment    If the export is very quick then there is a chance that the export progress dialog wont be displayed, we don't want to fail the test if this happens so commenting out the test is the best option
    Comment    Wait Until Page Contains Element    ewb-export-record-dialog    30s
    Wait Until Page Does Not Contain Element    ewb-export-record-dialog    30s
    Wait Until Page Contains Element    xpath=//iframe[@id="dlframe" and contains(@src, '${experiment id}')]    30s
    ${download_source}=    IDBSSelenium2Library.Get Element Attribute    dlframe@src
    Comment    WebHelperFunctions.Download File From EWB    ${download_source}    ${download_location}
    Confirm PDFs Folder Not Present    ${experiment name}

Expand PDF Folder
    [Arguments]    ${experiment name}
    [Documentation]    Expands the PDF folder under the specified experiment
    Confirm PDFs Folder Present    ${experiment name}
    Robust Click    xpath=//div[@title='${experiment name}']/div//td[1]//img

Get Most Recent PDF Name
    [Arguments]    ${experiment name}
    Wait Until Page Contains Element    xpath=(//div[@title='${experiment name}']//div[contains(@title,'-${experiment name}')])[last()]    30s
    ${pdf name}    IDBSSelenium2Library.Get Element Attribute    xpath=(//div[@title='${experiment name}']//div[contains(@title,'-${experiment name}')])[last()]@title
    [Return]    ${pdf name}

Check And Dismiss Cant Publish Dialog
    [Documentation]    Checks for the presence of a dialog blocking publishing
    ...    *NOTE* Currently this will detect ANY dialog containing a 'Close' button so isn't very specific to publishing, however currently the only way to make this specific would be to check for the presence of specific text in the dialog which would result in a fairly fragile keyword.
    Wait Until Page Contains Element    okButton    30s
    Element Text Should Be    okButton    Close
    Robust Click    okButton

Check And Dismiss Cant Sign Off Dialog
    [Documentation]    Checks for the presence of a dialog blocking sign off
    ...    *NOTE* Currently this will detect ANY dialog containing a 'Close' button so isn't very specific to sign off, however currently the only way to make this specific would be to check for the presence of specific text in the dialog which would result in a fairly fragile keyword.
    Wait Until Page Contains Element    okButton    30s
    Element Text Should Be    okButton    Close
    Robust Click    okButton

Select Role
    [Arguments]    ${role}
    [Documentation]    Select a role
    Robust Click    xpath=//div[@id='ewb-record-outline-sign-off-role']//img
    Robust Click    xpath=//td[contains(@class,'null list-item')]/div[text()='${role}']
    Confirm Role Value    ${role}

Confirm Role Value
    [Arguments]    ${expected value}
    Wait Until Page Contains Element    xpath=//div[@id='ewb-record-outline-sign-off-role']//input    30s
    ${selected}    Get Value    xpath=//div[@id='ewb-record-outline-sign-off-role']/div/div/div/input
    Should Be Equal    ${selected}    ${expected value}

Check Record Header Bar Loaded
    [Documentation]    *Checks that the header bar on a record is fully loaded*
    ...
    ...    This is useful when interacting with any of the header bar controls since the header bar loads each control seperately resulting in layout changes which impact any subsequent interactions.
    ...
    ...    *Arguments*
    ...
    ...    None
    ...
    ...    *Return Value*
    ...
    ...    None
    #Check the entity type
    Wait Until Page Contains Element    xpath=//div[@id="application-header-toolButton"]/../../div[2]    30s
    ${container}=    Wait Until Keyword Succeeds    10s    0.1s    IDBSSelenium2Library.Get Element Attribute    xpath=//div[@id="application-header-toolButton"]/../../div[2]@class    #ewb-child-container = LP or non-record,
    Run Keyword If    'ewb-record-outline' in '${container}'    Wait Until Element Is Visible    ewb-record-action-bar-add-item    10s    #insert menu
    Run Keyword If    'ewb-record-outline' in '${container}'    Wait Until Element Is Visible    ewb-record-workflows    10s    #workflows menu
    Run Keyword If    'ewb-record-outline' in '${container}'    Wait Until Element Is Visible    ewb-follow-record    10s    #follow button
    Run Keyword If    'ewb-record-outline' in '${container}'    Wait Until Element Is Visible    ewb-record-action-bar-tags    10s    #tags button
    Run Keyword If    'ewb-record-outline' in '${container}'    Wait Until Element Is Visible    ewb-record-action-bar-comments    10s    #comments button
    Run Keyword If    'ewb-record-outline' in '${container}'    Wait Until Element Is Visible    application-header-toolButton    10s    #record menu

Insert Image Item
    [Arguments]    ${File Item Type}    ${File Path}    ${Expected Dialog Title}    ${Expected File Type}=FILE    ${simulate_mouse_action}=${False}
    [Documentation]    Adds a new image item to an open record
    ...
    ...    *Arguments*
    ...    - ${File Item Type} = The item type of the file item being created
    ...    - ${File Path} = The path to the file (must be accessable from the automation client machine being used)
    ...    - ${Expected File Type} = Expected file type after insertion (e.g. Image files will automatically convert to images instead of file links), will default to FILE if not specified
    ...    - ${simulate_mouse_action} = Whether to use simulated mouse actions instead of Javascript to control the menu. Set to ${True} if required. Note: Setting to ${True} may introduce stability issues when executing tests locally.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - The record must be opened for editing
    ...
    ...    *Example*
    ...    | Lock Record For Editting |
    ...    | Open Content Header Tool Menu |
    ...    | Menu Option Should Be Enabled | Insert Text |
    ...    | Insert Image Item | Other | C:\\QTP Data\\E-WorkBook\\Test Data\\Search Test Data\\Images\\image.jpg | SVG_IMAGE |
    Get Next Document ID Set
    ${xpath count} =    Get Matching Xpath Count    //span[contains(@class, 'ewb-document-header-type') and contains(text(), '${File Item Type}')]
    Convert To Integer    ${xpath count}
    ${xpath count} =    Evaluate    ${xpath count}+1
    Open Insert Menu
    Robust Click    ewb-create-file-item
    #Remove class attribute - makes the actual input field visible - required for WebDriver
    Wait Until Page Contains Element    //*[@id="ewb-web-file-input"]
    Execute Javascript    window.document.getElementById('ewb-web-file-input').removeAttribute('class');
    ${File Path}=    Normalize Path    ${File Path}
    Choose File    ewb-web-file-input    ${File Path}
    Click OK

Record Is Not Being Edited
    Page Should Not Contain Element    //div[contains(@class, '${record-outline-edit-class}')]

Record Is Being Edited
    Page Should Contain Element    //div[contains(@class, '${record-outline-edit-class}')]

Wait For Record Outline
    [Arguments]    ${timeout}=30s
    [Documentation]    Waits for the record outline to be displayed
    Wait Until Page Contains Element    xpath=//div[contains(@class, 'ewb-record-outline-scrollpane')]    ${timeout}    # wait for record outline

Open Record Header Tool Menu
    [Arguments]    ${menu_item_to_select}=IGNORE
    Open Content Header Tool Menu
    Run Keyword Unless    '${menu_item_to_select}'=='IGNORE'    Robust Click    ${menu_item_to_select}

Change Experiment Status
    [Arguments]    ${experiment-name}    ${new-status}
    Open Edit Properties Dialog    ${experiment-name}    CONTENT HEADER
    Set List Attribute    statusName    ${new-status}
    Save Entity Properties And Wait
    Click away from Property Panel

Insert Template Into Active Record
    [Arguments]    ${template_path}
    [Documentation]    Assuming a record is currently rendered in the web client, this keyword will open the insert menu, select the Find Template option and select a template to insert based on a supplied path
    # Add a small delay before opening the menu to ensure the record is initialised correctly
    Sleep    1s
    Open Insert Menu
    Robust Click    xpath=.//*[@id='ewb-new-entity-dialog-popup']//*[@class='find-template']
    ${status}    ${value}=    Run Keyword And Ignore Error    Dialog Should Be Present    Find Template
    Run Keyword If    '${status}'=='FAIL'    Dialog Should Be Present    Select an Item
    Wait Five Seconds
    Select Template Node    ${template_path}

Select Inbox Tab
    Wait Until Page Contains Element    ewb-tab-inbox
    Robust Click    ewb-tab-inbox

Close Unable to Open Record Permissions Warning
    [Documentation]    *Description*
    ...
    ...    Checks the Message box displays the Warning "${page locked for editing message}"
    ...    and then closes the dialogue via a close button click
    Wait Until Page Contains Element    ${dialog container}    30s
    Element Text Should Be    ${message box text locator}    ${unable to open permissions message}
    Robust Click    okButton

Maybe Unlock Active Record
    [Arguments]    ${record_id}
    [Documentation]    A safer version of Unlock Record that can be used in test teardowns - this version will not fail if it does not succeed.
    ...    It also assumes the active view is a record
    Run Keyword And Ignore Error    Click Element    ewb-record-action-bar
    Run Keyword And Ignore Error    Wait Until Keyword Succeeds    10s    1s    Click Element    ewb-editor-command-close-record
    Run Keyword And Ignore Error    Wait Until Keyword Succeeds    10s    1s    Click Element    okButton
    Run Keyword And Ignore Error    EntityAPILibrary.Unlock Entity    ${record_id}

__Insert new text item
    # check number of active text editor sessions in the record    # an active session is indicated by the presence of the tiny mce editor component
    ${editor count} =    Get Matching Xpath Count    //textarea[@class='gwt-TextArea']
    Convert To Integer    ${editor count}
    ${editor count} =    Evaluate    ${editor count}+1
    Open Insert Menu
    Sleep    2s
    Robust Click    ewb-create-text-item
    Wait Until Page Contains Element    xpath=(//textarea[@class='gwt-TextArea'])[${editor count}]    15s
    ${applet id}=    Wait Until Keyword Succeeds    10s    1s    IDBSSelenium2Library.Get Element Attribute    xpath=(//textarea[@class='gwt-TextArea'])[${editor count} ]/..//iframe@id
    [Return]    ${applet id}

Attempt Publishing - No Check
    Open Content Header Workflows Menu
    Robust Click    ewb-entity-command-publish

Insert Existing Item Into Active Record
    [Arguments]    ${item_path}
    [Documentation]    Assuming a record is currently rendered in the web client, this keyword will open the insert menu, select the Insert Existing Item option and select an item to insert based on a supplied path.
    ...
    ...    *Arguments*
    ...
    ...    - _item_path_ - The path to the document in the EWB hierarchy
    ...
    ...    *Example*
    ...
    ...    | Insert Existing Item Into Active Record | Root/Group/Project/Experiment/(v. 1) Web Link: Example Link |
    # Add a small delay before opening the menu to ensure the record is initialised correctly
    Sleep    1s
    Open Insert Menu
    Robust Click    id=ewb-editor-command-insert-existing-item    element
    Dialog Should Be Present    Select Item
    Wait Five Seconds
    Select Item Node    ${item_path}

Clone existing records
    [Arguments]    ${item_path}
    [Documentation]    Assuming a record is currently rendered in the web client, this keyword will open the insert menu, select the Insert Existing Item option and select an item to insert based on a supplied path
    # Add a small delay before opening the menu to ensure the record is initialised correctly
    Sleep    1s
    Open Insert Menu
    Robust Click    id=ewb-entity-command-template-EXPERIMENT    element
    Dialog Should Be Present    Find an Existing Record to Clone
    Wait Five Seconds
    Select Item Node    ${item_path}

Check record is locked by workflow and dismiss message
    [Documentation]    This keywords checks that the record currently open is locked by a workflow and that the correct dialog appears.
    ...    It then closes the dialog.
    ...
    ...    It checks by attempting to edit the first document in the record.
    Select Document Header    1
    Click Edit Document Button    0
    Wait Until Page Contains Element    xpath=//div[contains(@class, 'ewb-message-box-text')]
    Element Text Should Be    xpath=//div[contains(@class, 'ewb-message-box-text')]    Unable to open the record as it is has been locked by a workflow to prevent further editing
    Robust Click    okButton

Verify No Edit Document Button
    [Arguments]    ${document number}
    Robust Click    document-body-${document number}-panel
    ${edit_button}=    Generate Edit Document Button xPath    ${document number}
    Element Should Not Be Visible    ${edit_button}

Generate Edit Document Button xPath
    [Arguments]    ${document_index}=0
    [Documentation]    Generates the xpath for the edit button of the document at the given index in the experiment
    ${xpath}=    Set Variable    xpath=//div[@id='document-header-${document_index}-customWidget-editButton']/a
    [Return]    ${xpath}

Verify Edit Document Button is Present
    [Arguments]    ${document number}
    Robust Click    document-body-${document number}-panel
    ${edit_button}=    Generate Edit Document Button xPath    ${document number}
    Element Should Be Visible    ${edit_button}

Discard Changes Option Should Be Present
    [Documentation]    Checks for the presence of the 'Discard Changes' option in the save menu
    Open Save Menu
    Wait Until Element Is Visible    ${version save record}
    Element Should Be Visible    ${discard record changes}
    Click away from Property Panel

Discard Changes Option Should Not Be Present
    [Documentation]    Checks for the absence of the 'Discard Changes' option in the save menu
    Open Save Menu
    Wait Until Element Is Visible    ${version save record}
    Element Should Not Be Visible    ${discard record changes}
    Click away from Property Panel

'No' Option Should Be Present On Navigating Away
    [Documentation]    Checks for the presence of the 'No' option in the 'Save session first?' dialog that appears on navigating away from a record that has been dirtied.
    Robust Link Click    Root
    Sleep    1
    Wait Until Keyword Succeeds    10    1    Page Should Contain Element    ${version_button}    #waits for the 'Version' button
    Element Should Be Visible    ${no_button}
    Robust Click    ${cancel_button}    #clicks 'cancel'

'No' Option Should Not Be Present On Navigating Away
    [Documentation]    Checks for the absence of the 'No' option in the 'Save session first?' dialog that appears on navigating away from a record that has been dirtied.
    Robust Link Click    Root
    Sleep    1
    Wait Until Keyword Succeeds    10    1    Page Should Contain Element    ${version_button}    #waits for the 'Version' button
    Element Should Not Be Visible    ${no_button}
    Robust Click    ${cancel_button}    #clicks 'cancel'

Open Save Menu
    Robust Click    ${record editing content header}
    ${edit_button}=    Generate Edit Document Button xPath    ${document number}
    Element Should Not Be Visible    ${edit_button}

Add Text To Text Item
    [Arguments]    ${text}
    [Documentation]    Keyword adds text into a text item. The text item must be in edit mode first.
    ...
    ...    ${text} = text to insert
    Sleep    2    waiting for iframe to load into the DOM
    wait until keyword succeeds    2mins    5s    Insert Text into Frame    Rich Text Area. Press ALT-F9 for menu. Press ALT-F10 for toolbar. Press ALT-0 for help    ${text}

Insert Text into Frame
    [Arguments]     ${insert_text}    ${text}
    Execute Javascript    var iframe = document.querySelector('[title="${insert_text}"]'); iframe.contentDocument.getElementById("tinymce").innerHTML = '<p>${text}</p>'
