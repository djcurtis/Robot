*** Settings ***
Library           IDBSSelenium2Library
Resource          ../Common/common_resource.robot
Resource          general_resource.robot
Library           CheckLibrary
Library           OperatingSystem
Resource          record_resource.robot

*** Variables ***
${spreadsheet item type}    Data Entry:
${Display Sheets Header}    xpath=//div[@class="ewb-label ewb-dialog-label ewb-window-header-title"]
${Save Button}    xpath=//button[contains(@class, 'save-button')]
${Save Label}     xpath=//*[contains(@class, 'save-label')]
${Close Dialog Button}    xpath=//button[contains(@class, 'close')]
${insert image url}    ${WEB_CLIENT_HTTP_SCHEME}://${SERVER}:${WEB_CLIENT_PORT}/EWorkbookWebApp/resources/images/site/logo_header.png    # Need a url that is served from a valid/certified web site
${xpath_web_spreadsheet_alert_popup}    xpath=//div/div[@class="popupContent"]
${lite_editor_frame_id}    lite-editor-frame
${cell_editor_id}    STANDARD_EDITOR

*** Keywords ***
Add Sheet to Display
    [Documentation]    Adds a sheet selected inthe model browser to the displaying column
    Robust Click    addSelectedSheet

Auto Calc Status Should Be Set To Auto
    [Documentation]    Verifies the calculation link in the data tab has a status set to 'Auto'
    ...
    ...    For this keyword to succeed, the Data tab should already be selected
    Wait Until Element Text Is    xpath=*//div[contains(@class, 'calculations')]//span[@class='status']    Auto    5s

Auto Calc Status Should Be Set To Off
    [Documentation]    Verifies the calculation link in the data tab has a status set to 'Off'
    ...
    ...    For this keyword to succeed, the Data tab should already be selected
    Wait Until Element Text Is    xpath=*//div[contains(@class, 'calculations')]//span[@class='status']    Off    5s

Bold Toggle Button Is Not Pressed
    [Documentation]    Tests that the bold toggle button is in a pressed state
    Page Should Not Contain Element    xpath=.//*[@data-property-name='fontBold' and contains(@class, 'active')]

Bold Toggle Button Is Pressed
    [Documentation]    Tests that the bold toggle button is in a pressed state
    Page Should Contain Element    xpath=.//*[@data-property-name='fontBold' and contains(@class, 'active')]

Change Number Format
    [Arguments]    ${New Format Type}    ${Display Text}
    [Documentation]    Changes the number format for the selected cells
    Robust Click    xpath=*//button[contains(@class, 'datatype-picker')]
    Robust Click    xpath=.//*[@data-type-name='${New Format Type}']
    Sleep    2s
    Verify Selection Format    ${Display Text}

Check Displayed Sheet
    [Arguments]    ${index}    ${tableName}
    [Documentation]    Ensures that the table in position index is correct by checking text
    ${indexMinusOne} =    evaluate    int(${index})-1
    Element Text Should Be    xpath=//div[@__idx='${indexMinusOne}']/div    ${tableName}

Clear Model Browser Filter
    Robust Click    xpath=.//*[@id='content-container']//i[contains(@class, "clear-filter")]

Clear Spreadsheet Tab Dropdown Menu Filter
    [Documentation]    Removes any filter from the tab dropdown menu
    Robust Click    xpath=.//span[@class='perspective-tabs']//i[contains(@class, 'clear-filter')]

Click Auto Calc Toggle Switch
    ${element}=    Set Variable    xpath=*//div[contains(@class, 'calculation-panel')]//span[contains(@class, 'toggle-bg')]
    ${initial_state}=    IDBSSelenium2Library.Get Element Attribute    ${element}@class
    : FOR    ${i}    IN RANGE    5
    \    Robust Click    ${element}
    \    ${clicked}=    Run Keyword and Return Status    Wait Until Keyword Succeeds    3s    1s    Element Should Not Be Visible
    \    ...    ${initial_state}
    \    Exit For Loop If    ${clicked}
    Run Keyword Unless    ${clicked}    The auto calculate toggle was not clicked

Click Data Import Link
    Robust Click    xpath=.//*[contains(@class, 'file-import')]
    Wait Until Element Is Visible    xpath=.//button[contains(@class, 'import-button')]

Click File Import Button
    Element Should Be Enabled    xpath=.//button[contains(@class, 'import-button')]
    Robust Click    xpath=.//button[contains(@class, 'import-button')]

Click Left Tab Button
    [Documentation]    Clicks the spreadsheet perspective left tab navigation button
    Robust Click    xpath=.//span[contains(@class, 'perspective-tabs-left-button')]

Click Perspective In Picker By Index
    [Arguments]    ${perspective-index}
    Robust Click    xpath=.//*[contains(@class, 'perspective-list')]/li[${perspective-index}]

Click Perspective In Picker By Name
    [Arguments]    ${perspective-name}
    Robust Click    xpath=.//*[contains(@class, 'perspective-list')]/li[@data-item='${perspective-name}']

Click Redo Button
    # Verify button is not disabled first, give this a chance to succeed rather than fail straight away
    Redo Button Should Be Enabled
    Click Element    redo-button

Click Refresh All Calculations Button
    Robust Click    xpath=*//button[contains(@class, 'btn-refresh all')]
    Sleep    10
    Wait Until Element Text Contains    xpath=*//button[contains(@class, 'btn-refresh all')]    Refresh All    30

Click Refresh Changed Calculations Button
    Robust Click    xpath=*//button[contains(@class, 'btn-refresh changed')]

Click Right Tab Button
    [Documentation]    Clicks the spreadsheet perspective right tab navigation button
    Robust Click    xpath=.//span[contains(@class, 'perspective-tabs-right-button')]

Click Tab Menu Item
    [Arguments]    ${tab name}    ${menu item text}
    Open Tab Menu    ${tab name}
    # List items should now be present
    Robust Click    xpath=.//*[contains(@class, 'perspective-tabs')]//ul[@class='nav nav-tabs']//li[@data-model-name='${tab name}']//ul/li/a[@data-menu-item-text='${menu item text}']

Click Undo Button
    [Documentation]    Clicks the Undo button
    # Verify button is not disabled first, give this a chance to succeed rather than fail straight away
    Undo Button Should Be Enabled
    Click Element    undo-button

Close Drawer
    [Documentation]    Closes the app drawer.
    ...
    ...
    ...    Note that this will fail is the app drawer is not in an opened state
    Wait Until Keyword Succeeds    10s    1S    Verify Drawer Is Open
    Robust Click    xpath=//div[@class='toggle drawer-toggle']
    Wait Until Keyword Succeeds    10s    1S    Verify Drawer Is Closed

Close Tab Menu
    [Documentation]    Simply clicks an element to ensure that no menus are open
    Click Element    xpath=.//*[contains(@class, 'perspective-tabs')]

Close Zoom Image Dialog
    [Documentation]    Closes the zoom image dialog
    Robust Click    ${Close Dialog Button}

Collapse Button Should Be Visible On Fullscreen Tab Group
    Wait Until Page Contains Element    xpath=.//*[@data-tab-panel-fullscreen='true']//*[contains(@class, 'perspective-expand-button')]/i[contains(@class, 'fa-compress')]    5s

Collapse Expanded Tab Group
    Robust Click    xpath=.//*[@data-tab-panel-fullscreen='true']//*[contains(@class, 'perspective-expand-button')]

Compare URLs
    [Arguments]    ${url}    ${expected-url}
    [Documentation]    Fuzzily compares the two URLs
    ${url}=    Evaluate    '${url}'.lower()
    ${expected-url}=    Evaluate    '${expected-url}'.lower()
    Check String Starts With    URLs    ${url}    ${expected-url}

Confirm Left Tab Button Disabled
    [Documentation]    Fails if the spreadsheet perspective left tab navigation button is not disabled
    Wait Until Page Contains Element    xpath=.//span[contains(@class, 'perspective-tabs-left-button disabled-button')]

Confirm Left Tab Button Enabled
    [Documentation]    Fails if the spreadsheet perspective left tab navigation button is disabled
    Wait Until Page Contains Element    xpath=.//span[@class='perspective-toolbar-button perspective-tabs-left-button']

Confirm Left Tab Button Hidden
    [Documentation]    Fails if the spreadsheet perspective left tab navigation button is not hidden
    Wait Until Element Is Not Visible    xpath=.//span[contains(@class,'perspective-toolbar-button perspective-tabs-left-button')]    5s

Confirm Left Tab Button Visible
    [Documentation]    Fails if the spreadsheet perspective left tab navigation button is hidden
    Wait Until Element Is Visible    xpath=.//span[contains(@class,'perspective-toolbar-button perspective-tabs-left-button')]    5s

Confirm Right Tab Button Disabled
    [Documentation]    Fails if the spreadsheet perspective right tab navigation button is not disabled
    Wait Until Page Contains Element    xpath=.//span[contains(@class, 'perspective-tabs-right-button disabled-button')]

Confirm Right Tab Button Enabled
    [Documentation]    Fails if the spreadsheet perspective right tab navigation button is disabled
    Wait Until Page Contains Element    xpath=.//span[@class='perspective-toolbar-button perspective-tabs-right-button']

Confirm Right Tab Button Hidden
    [Documentation]    Fails if the spreadsheet perspective right tab navigation button is not hidden
    Wait Until Element Is Not Visible    xpath=.//span[contains(@class,'perspective-toolbar-button perspective-tabs-right-button')]    5s

Confirm Right Tab Button Visible
    [Documentation]    Fails if the spreadsheet perspective right tab navigation button is hidden
    Wait Until Element Is Visible    xpath=.//span[contains(@class,'perspective-toolbar-button perspective-tabs-right-button')]    5s

Confirm Sheet Menu Hidden
    [Documentation]    Fails if the spreadsheet perspective view menu is not hidden
    Wait Until Element Is Not Visible    xpath=.//span[contains(@class,'dropdown-toggle perspective-toolbar-button perspective-menu-button')]    5s

Confirm Sheet Menu Visible
    [Documentation]    Fails if the spreadsheet perspective view menu is hidden
    Wait Until Element Is Visible    xpath=.//span[contains(@class,'dropdown-toggle perspective-toolbar-button perspective-menu-button')]    5s

Confirm Sheet Selected
    [Arguments]    ${View Name}
    [Documentation]    Confirms that a sheet with the given name is currently the selected sheet
    Wait Until Page Contains Element    xpath=.//li[@data-model-name='${View Name}' \ and contains(@class, 'model-view-tab') and contains(@class, 'active')]    5s

Confirm Tab Dropdown Menu Item Is Active
    [Arguments]    ${view-name}
    [Documentation]    Verifies that the given view is marked as the active one in the drop down menu
    Page Should Contain Element    xpath=.//*[@id='content-container']//ul[contains(@class, 'perspective-menu')]/li[@data-model-name='${view-name}' and contains(@class, 'active')]

Confirm Tab Dropdown Menu Item is Hidden
    [Arguments]    ${view-name}
    [Documentation]    Verifies that an item in the tab dropdown menu is hidden (by filtering)
    Page Should Contain Element    xpath=.//*[@id='content-container']//ul[contains(@class, 'perspective-menu')]/li[@data-model-name='${view-name}']
    Element Should Not Be Visible    xpath=.//*[@id='content-container']//ul[contains(@class, 'perspective-menu')]/li[@data-model-name='${view-name}']

Confirm Tab Dropdown Menu Item is Visible
    [Arguments]    ${view-name}
    [Documentation]    Verifies that an item in the tab dropdown menu is visible (not filtered)
    Page Should Contain Element    xpath=.//*[@id='content-container']//ul[contains(@class, 'perspective-menu')]/li[@data-model-name='${view-name}']
    Element Should Be Visible    xpath=.//*[@id='content-container']//ul[contains(@class, 'perspective-menu')]/li[@data-model-name='${view-name}']

Data Import Link Should Be Present
    Page Should Contain Element    xpath=.//*[contains(@class, 'file-import')]

Data Import Link Should Not Be Present
    Page Should Not Contain Element    xpath=.//*[contains(@class, 'file-import')]

Data Import Page Select File To Import
    [Arguments]    ${file path}
    Execute Javascript    window.document.getElementById("file-upload-field").removeAttribute("class");
    ${real_path}=    Normalize Path    ${file path}
    Choose File    file-upload-field    ${real_path}

Edit Cell in Editor
    [Arguments]    ${rowNo}    ${colNo}
    [Documentation]    Selects a cell in the spreadsheet widget, in the LITE editor. Starts at co ordinates : 0,0
    Run Keyword Unless    '${OPERATING_SYSTEM}'=='OSX'    Double Click Element    //*[@id='c${rowNo}-${colNo}']/../../../..    #click on parent element to ensure multiple cell selections are reliably performed
    Run Keyword If    '${OPERATING_SYSTEM}'=='OSX'    Simulate    //*[@id='c${rowNo}-${colNo}']/../../../..    dblclick
    Sleep    0.5s

Enter Filter Into Model Browser
    [Arguments]    ${filter-text}
    Input Text    xpath=.//*[@class="model-browser-content"]//input[@id="filter"]    ${filter-text}

Enter Filter Into Spreadsheet Tab Dropdown Menu
    [Arguments]    ${filter-text}
    [Documentation]    Enters some text into the filter field of the tab drop down menu
    Input Text    xpath=.//span[@class='perspective-tabs']//input[@id='filter']    ${filter-text}

Exit Link Is Present
    Page Should Contain Element    xpath=//a[@class='command-return']

Exit Spreadsheet Lite Editor
    [Arguments]    ${timeout}=180s
    [Documentation]    Exits from the spreadsheet editor. If the editor was launched in 'edit' mode then this keyword attempts to wait for the spreadsheet to be saved before returning.    # Keyword is unstable
    ...
    ...    *Arguments*
    ...
    ...    _Timeout_ - the time to wait for this to happen. default is 120s
    Robust Click    xpath=//a[@class='command-return']
    Wait For Lite Editor Close    ${timeout}

Exit Spreadsheet Lite Editor And Confirm Auto Recalc
    [Arguments]    ${timeout}=120s
    [Documentation]    Exits from the spreadsheet editor. If the editor was launched in 'edit' mode then this keyword attempts to wait for the spreadsheet to be saved before returning.    # Keyword is unstable
    ...
    ...    This variant also expects a prompt when closing to refrsh calcs on exit. \ The keyword will then confirm the operation
    ...
    ...
    ...    *Arguments*
    ...
    ...    _Timeout_ - the time to wait for this to happen. default is 120s
    Robust Click    xpath=//a[@class='command-return']
    Wait Until Page Contains Element    confirmDialog
    Robust Click    xpath=*//button[@data-action='primary']
    Wait For Lite Editor Close    ${timeout}

Expand Button Should Be Visible On Tab Group
    [Arguments]    ${tab-group-index}
    Wait Until Element Is Visible    xpath=(//span[contains(@class, 'perspective-expand-button')])[${tab-group-index}]    5s

Expand Tab Group
    [Arguments]    ${tab-group-index}
    Robust Click    xpath=(//span[contains(@class, 'perspective-expand-button')])[${tab-group-index}]

FullScreen Tab Group Is Not Present
    Wait Until Page Does Not Contain Element    xpath=.//*[@data-tab-panel-fullscreen='true']    5s

FullScreen Tab Group Is Present
    Wait Until Page Contains Element    xpath=.//*[@data-tab-panel-fullscreen='true']    5s

Get Save Label
    [Documentation]    Returns the text currently stored in the save label
    ${save_label_value}=    Get Text    ${Save Label}
    [Return]    ${save_label_value}

Insert Dialog Accept Button Is Disabled
    Element Should Be Visible    xpath=*//button[@data-role='accept-button' and contains(@class, 'disabled')]

Insert Dialog Accept Button Is Enabled
    Element Should Be Present    xpath=*//button[@data-role='accept-button' and not(contains(@class, 'disabled'))]

Insert EWB Image
    [Arguments]    ${image-group-id}    ${image-project-id}    ${image-experiment-id}    ${image-id}    ${rowNo}    ${colNo}
    Select Cell in Editor    ${rowNo}    ${colNo}
    Open Insert From File Dialog
    Select Insert Dialog Tab    E-WorkBook
    Robust Click    xpath=*//li[@id='jstree-entity-id-${image-group-id}']/a
    Robust Click    xpath=*//li[@id='jstree-entity-id-${image-project-id}']/a
    Robust Click    xpath=*//li[@id='jstree-entity-id-${image-experiment-id}']/a
    Robust Click    xpath=*//li[@id='jstree-entity-id-${image-id}']/a
    Robust Click    xpath=*//button[@data-role='accept-button']
    Wait Until Page Contains Element    xpath=*//div[@id='c${rowNo}-${colNo}']/img    15s
    Wait Until Element Is Visible    xpath=*//div[@id='c${rowNo}-${colNo}']/img    15s

Insert Entity Link Into Selected Cell
    [Arguments]    ${entityID}    ${displayText}=${EMPTY}
    [Documentation]    Inserts a entity link into a selected cell
    Select Drawer Tab    2
    Robust Click    xpath=*//button[@data-insert-action='link']
    Wait Until Element Text Is    dialogLabel    Insert Link    5s
    Sleep    1s
    Robust Click    xpath=*//a[@data-editor-name='E-WorkBook']
    Sleep    1s
    Run Keyword Unless    '${displayText}'=='${EMPTY}'    Input Text    xpath=//div[contains(@class,'ewblink-panel')]//input[contains(@class,'form-control')]    ${displayText}
    Sleep    1s
    Robust Click    xpath=*//li[@id='jstree-entity-id-${entityID}']/a
    Robust Click    xpath=*//button[@data-role='accept-button']

Insert Image From File
    [Arguments]    ${file-path}    ${rowNo}    ${colNo}
    Select Cell in Editor    ${rowNo}    ${colNo}
    Open Insert From File Dialog
    Select Insert Dialog Tab    File
    Select File To Import    ${file-path}
    Robust Click    xpath=*//button[@data-role='accept-button']
    Wait Until Page Contains Element    xpath=*//div[@id='c${rowNo}-${colNo}']/img    15s
    Wait Until Element Is Visible    xpath=*//div[@id='c${rowNo}-${colNo}']/img    15s

Insert Image From URL
    [Arguments]    ${image-url}    ${rowNo}    ${colNo}
    Select Cell in Editor    ${rowNo}    ${colNo}
    Open Insert From File Dialog
    Select Insert Dialog Tab    Web
    Robust Click    urlBox
    Sleep    1s    # Sometimes it takes a while for the text box to get focus
    Input Text    urlBox    ${image-url}
    Sleep    10s    # Wait for the image to be downloaded (can take a few seconds)
    Robust Click    xpath=*//button[@data-role='accept-button']
    Wait Until Page Contains Element    xpath=*//div[@id='c${rowNo}-${colNo}']/img    15s
    Wait Until Element Is Visible    xpath=*//div[@id='c${rowNo}-${colNo}']/img    15s

Insert Timestamp Into Selected Cell
    Select Drawer Tab    2
    Robust Click    xpath=*//button[@data-insert-action='timestamp']
    Select Drawer Tab    3
    Verify Selection Format    Date/Time

Insert Web Link Into Selected Cell
    [Arguments]    ${URL}    ${displayText}=${EMPTY}
    [Documentation]    Inserts a web link into a selected cell
    Select Drawer Tab    2
    Robust Click    xpath=*//button[@data-insert-action='link']
    Wait Until Element Text Is    dialogLabel    Insert Link    5s
    Robust Click    xpath=*//a[@data-editor-name='Web']
    Input Text    urlBox    ${URL}
    Run Keyword Unless    '${displayText}'=='${EMPTY}'    Input Text    displayTextBox    ${displayText}
    Robust Click    xpath=*//button[@data-role='accept-button']

Insert new Spreadsheet from menu
    [Arguments]    ${save}=no
    [Documentation]    *Description*
    ...    Inserts a new spreadsheet from the insert menu
    ...
    ...    *Arguments*
    ...    - ${save} = Whether to draft save after inserting the Spreadsheet ("draft" to save)
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
    ...    | Add exisiting Spreadsheet from menu | Data Entry | C:\\QTP Data\\E-WorkBook\\Test Data\\Search Test Data\\Images\\image.jpg |
    # check number of document items in the record    # use that to determine the id of the item we are creating.    # bear in mind xpath is 1-base (i.e. count), and the item id's are 0-base
    ${xpath count} =    Get Matching Xpath Count    //span[contains(@class, 'ewb-document-header-type')]
    log    ${xpath count}
    ${expected_item_id}=    set variable    document-header-${xpath count}-itemTypeLabel
    # insert new text item
    Open Insert Menu
    Robust Click    ewb-ss-create-spreadsheet-item
    # check that spreadsheet item is present in record
    Wait Until Page Contains Element    ${expected_item_id}    60s
    Run Keyword If    "${save}"=="draft"    Draft Save Record

Internal Select Cell in Editor
    [Arguments]    ${rowNo}    ${colNo}    ${viewName}=${EMPTY}
    [Documentation]    Selects a cell in the spreadsheet widget, in the LITE editor. Starts at co ordinates : 0,0
    ...
    ...    *If you have more than one view showing then specify the name of the view whose cell you want to select*
    ${xpath}=    Set Variable If    '${viewName}' == '${EMPTY}'    //*[@id='c${rowNo}-${colNo}']/..    //*[@id='view-${viewName}']//*[@id='c${rowNo}-${colNo}']/..
    Robust Click    ${xpath}    #click on parent element to ensure multiple cell selections are reliably performed
    Run Keyword Unless    '${BROWSER}'=='IE'    Wait Until Page Contains Element    //*[contains(@class,'selection') and contains(@style,'pointer-events:none')]    1s
    Run Keyword If    '${BROWSER}'=='IE'    Wait Until Page Contains Element    //*[contains(@class,'selection') and contains(@style,'pointer-events: none')]    1s    #handle whitespace on IE

Italic Toggle Button Is Not Pressed
    [Documentation]    Tests that the italic toggle button is in a pressed state
    Page Should Not Contain Element    xpath=.//*[@data-property-name='fontItalic' and contains(@class, 'active')]

Italic Toggle Button Is Pressed
    [Documentation]    Tests that the italic toggle button is in a pressed state
    Page Should Contain Element    xpath=.//*[@data-property-name='fontItalic' and contains(@class, 'active')]

Model Browser Information Icon Should Contain Text
    [Arguments]    ${info-text}
    Page Should Contain Element    xpath=.//div[@class='hover-menu']//i[@data-content='${info-text}']

Model Browser Should Be Closed
    Wait Until Page Contains Element    xpath=//*[contains(@class, 'model-browser closed')]    5s

Model Browser Should Be Open
    [Documentation]    Verifies the model browser is in its open state
    Wait Until Page Contains Element    xpath=//*[contains(@class, 'model-browser open')]    5s

Model Browser Should Contain Item
    [Arguments]    ${view-name}
    Element Should Be Visible    xpath=.//div[@class="tree-container"]//div[contains(@class, "tree")]//a[@data-view-name="${view-name}"]

Model Browser Should Not Contain Item
    [Arguments]    ${view-name}
    Element Should Not Be Visible    xpath=.//div[@class="tree-container"]//div[contains(@class, "tree")]//a[@data-view-name="${view-name}"]

Move to Next Perspective
    Click Element    xpath=.//*[contains(@class, 'perspective-selector')]//span[contains(@class, 'right')]

Move to Previous Perspective
    Click Element    xpath=.//*[contains(@class, 'perspective-selector')]//span[contains(@class, 'left')]

Notification Header Should Be Hidden
    [Documentation]    Verifies the notification header is hidden (and therefore does not contain any issues)
    Wait Until Element Is Not Visible    xpath=//*[contains(@class, 'problem-widget')]    3s

Notification Header Should Be Visible
    [Documentation]    Verifies the notification header is visible (and therefore contains at least one issue)
    Wait Until Element Is Visible    xpath=//*[contains(@class, 'problem-widget')]    3s

Open Calculation Panel
    Robust Click    xpath=*//div[contains(@class, 'calculations')]
    Wait Until Page Contains Element    xpath=*//div[contains(@class, 'calculation-panel')]    30s

Open Drawer
    [Documentation]    Opens the app drawer.
    ...
    ...
    ...    Note that this will fail is the app drawer is not in a closed state
    Wait Until Keyword Succeeds    10s    1S    Verify Drawer Is Closed
    Robust Click    xpath=//div[@class='toggle drawer-toggle']
    Wait Until Keyword Succeeds    30s    2S    Verify Drawer Is Open

Open Insert From File Dialog
    Select Drawer Tab    2
    Robust Click    xpath=*//button[@data-insert-action='picture']
    Wait Until Element Text Is    dialogLabel    Insert Image    5s

Open Notification Header
    [Documentation]    Clicks the notification header
    # grr - Robust Click \ Click Element does not work on this header element, possibly as the browser sometimes shifts the view up a bit, thus obscuring the header button which may need to be entirely visible for it to be clicked using standard keywords
    Execute Javascript    document.querySelector(".problem-widget a").click()

Open Perspective Picker
    Robust Click    xpath=.//*[contains(@class, 'perspective-selector')]//button

Open Spreadsheet Tab Dropdown Menu
    [Documentation]    Opens the tab menu drop down for a simple layout with no nested tab groups
    Robust Click    xpath=.//*[@id='content-container']//span[contains(@class, 'perspective-menu-button')]

Open Tab Menu
    [Arguments]    ${tab name}
    [Documentation]    Opens the menu associated to the tab with the given tab name
    Robust Click    xpath=//*[contains(@class, 'perspective-tabs')]/ul/li[@data-model-name='${tab name}']/i

Perspective Picker Is Empty
    Page Should Contain Element    xpath=.//div[contains(@style, 'display: none')]/div[@class='perspective-selector']
    Perspective Picker Should Count X Items    0

Perspective Picker Should Count X Items
    [Arguments]    ${expected list count}
    [Documentation]    Verifies that there are n list items in the perspective picker
    ${count}=    Get Matching Xpath Count    .//*[contains(@class, "perspective-list")]//li
    Check Number Equals    The number of list items in the perspective picker    ${count}    ${expected list count}

Press Bold Toggle Button
    [Documentation]    Clicks the font bold toggle button
    Click Element At Coordinates    xpath=//button[@data-property-name='fontBold']    15    10

Press Italic Toggle Button
    [Documentation]    Clicks the font italic toggle button
    Click Element At Coordinates    xpath=//button[@data-property-name='fontItalic']    15    10

Press Underline Toggle Button
    [Documentation]    Clicks the font underline toggle button
    Click Element At Coordinates    xpath=//button[@data-property-name='fontUnderline']    15    10

Redo Button Should Be Disabled
    [Documentation]    Verifies the redo button is present and disabled
    Wait Until Page Contains Element    xpath=.//*[@id='redo-button' and contains(@class, 'disabled')]    10s    1s

Redo Button Should Be Enabled
    [Documentation]    Verifies that the Redo button is enabled
    Wait Until Page Contains Element    xpath=.//*[@id='redo-button' and not(contains(@class, 'disabled'))]    10s    1s

Redo Button Tooltip Should Be
    [Arguments]    ${expected_tooltip}
    [Documentation]    Verifies that the tooltip for the redo button is the value provided in the ${expected_tooltip} parameter
    Wait Until Page Contains Element    xpath=.//*[@id='redo-button' and contains(@title, '${expected_tooltip}')]    10s    1s

Remove Import File
    [Arguments]    ${importFileName}
    [Documentation]    Removes th0.1se named file from the list of import files
    Mouse Over    xpath=//*[@data-model-id='${importFileName}']//*[contains(@class,'fa-times')]
    Robust Click    xpath=//*[@data-model-id='${importFileName}']//*[contains(@class,'fa-times')]

Remove Sheet From Display
    [Documentation]    Removes a sheet selected in the displaying column to the model browser
    Robust Click    removeSelectedSheets

Robust Select Spreadsheet Document Header
    [Arguments]    ${document number}
    [Documentation]    *Description*
    ...
    ...    robustly attempts to select the spreadsheet document header
    ...
    ...    *Arguments*
    ...
    ...    ${document number} = The position of the document in the record, first document = 1
    ...
    ...    *Return value*
    ...
    ...    None
    ...
    ...    *Precondition*
    ...
    ...    - The record must be opened for editing
    ...
    ...    - The specified document must be a spreadsheet.
    ${docNumMinusOne}=    Evaluate    int(${document number}) -1
    : FOR    ${attempt}    IN RANGE    1    10
    \    ${status}    ${msg}    Run Keyword And Ignore Error    Element should be visible    xpath=//div[@id='document-header-${docNumMinusOne}-customWidget-editButton']/a
    \    run keyword if    '${status}' == 'PASS'    Exit For Loop
    \    run keyword if    '${status}' == 'FAIL'    Select Document Header    ${document number}
    \    sleep    200ms

Save Button Is Not Present
    Page Should Not Contain Element    ${Save Button}

Save Button Is Present
    Page Should Contain Element    ${Save Button}

Save Model
    [Documentation]    Clicks the 'Save' button causing any changes to the model to be saved
    Robust Click    ${Save Button}    button
    Sleep    2
    Wait Until Element Text Contains    ${Save Label}    Saved at    300s

Select Cell in Editor
    [Arguments]    ${rowNo}    ${colNo}    ${viewName}=${EMPTY}
    [Documentation]    Selects a cell in the spreadsheet widget, in the LITE editor. Starts at co ordinates : 0,0
    ...
    ...    *If you have more than one view showing then specify the name of the view whose cell you want to select*
    Wait Until Keyword Succeeds    20s    1s    Internal Select Cell in Editor    ${rowNo}    ${colNo}    ${viewName}

Select Displayed Sheets
    [Arguments]    ${index}    ${tableName}
    [Documentation]    Selects a sheet that is currenlty being displayed from the Select sheet dialogue
    ...
    ...    Checks the table is present and selects based on the index number - Starting at 1
    ${indexMinusOne} =    evaluate    int(${index})-1
    Element Text Should Be    xpath=//div[@__idx='${indexMinusOne}']/div    ${tableName}
    click element    xpath=//div[@__idx='${indexMinusOne}']/div

Select Drawer Tab
    [Arguments]    ${Tab Number}
    [Documentation]    Selects a tab in the application drawer based on the display text present in the tab
    Robust Click    nav-tab-${Tab Number}

Select File to Import
    [Arguments]    ${file-path}
    Execute Javascript    window.document.querySelector(".file-upload-input").removeAttribute("class");
    ${normalised-file-path}=    Normalize Path    ${file-path}
    Choose File    file-upload-field    ${normalised-file-path}

Select Import Definition for Import
    [Arguments]    ${definition name}
    [Documentation]    selects the import definition for a given File import seession. \ NOTE: this requires having had a matrix selected first (*Select Matrix To Import Into*)
    Robust Click    xpath=.//button[contains(@class, "import-definition-picker")]
    Robust Click    xpath=.//*[@data-importdefinition-name='${definition name}']

Select Insert Dialog Tab
    [Arguments]    ${editor name}
    Robust Click    xpath=*//a[@data-editor-name='${editor name}']

Select Matrix To Import Into
    [Arguments]    ${matrix name}
    # The following line first waits a short while to see if the button already contains the text, we need to do this as in some cases it takes a while for the button text to be populated. If we don't give it time to be set, then ${buttonText} will be empty but the Robust Clicks following this will fail if there is only a single table (no popup will appear)
    Run Keyword And Ignore Error    Wait Until Element Text Contains    xpath=.//button[contains(@class, "file-import-picker")]    ${matrix name}    2s
    ${buttonText}=    Get Text    xpath=.//button[contains(@class, "file-import-picker")]
    Run Keyword Unless    '${buttonText}'=='${matrix name}'    Robust Click    xpath=.//button[contains(@class, "file-import-picker")]
    Run Keyword Unless    '${buttonText}'=='${matrix name}'    Robust Click    xpath=.//*[@data-matrix-name='${matrix name}']

Select Sheet From Menu
    [Arguments]    ${View Name}
    [Documentation]    Selects the given sheet using the perspective tab menu. This method will return an error if the given sheet fails to be selected.
    Robust Click    xpath=.//span[contains(@class, 'perspective-menu-button')]
    Robust Click    xpath=.//li[@data-model-name='${View Name}' and contains(@class, 'model-view-menu')]
    Confirm Sheet Selected    ${View Name}

Select Sheet In Tab
    [Arguments]    ${view_name}
    [Documentation]    Activates a tab that displayed a given sheet
    Wait Until Page Contains Element    xpath=.//*[contains(@class,'perspective-selector')]
    ${noperspectives}    ${value}=    Run Keyword and Ignore Error    Page Should Contain Element    xpath=.//*[contains(@class,'no-perspectives')]
    Run Keyword If    '${noperspectives}' == 'PASS'    Wait Until Keyword Succeeds    10s    1s    Robust Click    xpath=.//*[text() = '${view_name}']
    : FOR    ${i}    IN RANGE    5
    \    Robust Click    xpath=.//*[@class='perspective-tabs']/ul/li/a[@title='${view_name}']
    \    ${table_loaded}=    Run Keyword And Return Status    Element Should Be Visible    view-${view_name}    5s
    \    Exit For Loop If    ${table_loaded}
    Run Keyword Unless    ${table_loaded}    Fail    Table view didn't load after 5 attempts

Select Sheet in Browser
    [Arguments]    ${index}    ${clickNo}=1
    [Documentation]    Selects the table in the model browser of the select sheets to display dialogue, using the index (position number) - starting at 1
    Run keyword if    ${clickNo}==1    Robust Click    xpath=//div[@id='selectSheetsToDisplayDialog']//div[@aria-posinset='${index}']
    Run keyword if    ${clickNo}>1    Robust Click    xpath=//div[@id='selectSheetsToDisplayDialog']//div[@aria-posinset='${index}']
    Run keyword if    ${clickNo}>1    Robust Double Click Element    xpath=//div[@id='selectSheetsToDisplayDialog']//div[@aria-posinset='${index}']

Select Spreadsheet Editor Frame
    [Documentation]    Selects the frame containing the spreadsheet editor
    Select Frame    ${lite_editor_frame_id}
    ${status}    ${value}=    Run Keyword And Ignore Error    Wait Until Page Contains Element    xpath=//a[@class="command-return"]    60s
    Run Keyword If    '${status}'=='FAIL'    Select Frame    ${lite_editor_frame_id}
    Wait Until Page Contains Element    xpath=//a[@class="command-return"]    5s

Select View In Model Browser
    [Arguments]    ${view-name}
    Robust Click    xpath=//div[@class="tree-container"]//div[contains(@class, "tree")]//a[@data-view-name="${view-name}"]

Select View In Spreadsheet Dropdown Menu
    [Arguments]    ${view-name}
    [Documentation]    Selects a view in the tab drop down menu - assumes that Open Spreadsheet Tab Dropdown Menu has been called
    Robust Click    xpath=//*[@id='content-container']//ul[contains(@class, 'perspective-menu')]/li[@data-model-name='${view-name}']/a

Set Background Colour For Active Selection
    [Arguments]    ${Hex Colour}    ${ieRGB}    ${rowNo}    ${colNo}
    [Documentation]    Sets the font colour for the active cells
    Robust Click    xpath=//*[contains(@class, 'fill-colour') and @data-toggle='dropdown']
    # FIREFOX & CHROME use hex codes, IE uses RGB (with spaces). \ nice eh!
    ${locator}=    Set Variable If    '${BROWSER}'=='IE'    xpath=//*[contains(@class,'fill-colour-wrapper')]//ul/table[@class='colour-picker']//div[@style='background-color: ${ieRGB};']    xpath=//*[contains(@class,'fill-colour-wrapper')]//ul/table[@class='colour-picker']//div[@style='background-color: #${Hex Colour}']
    Robust Click    ${locator}
    # Verify Cell Style assumes the parent is being formatted. \ For some reason, setting the background colour is applied to the grand parent!
    Select Cell in Editor    ${rowNo}    ${colNo}
    Sleep    2s
    # FIREFOX & CHROME use hex codes, IE uses RGB (with spaces). \ nice eh!
    ${celllocator}=    Set Variable If    '${BROWSER}'=='IE'    xpath=//*[@id='c${rowNo}-${colNo}']/../../div[contains(@style, 'background-color: ${ieRGB};')]    xpath=//*[@id='c${rowNo}-${colNo}']/../../div[contains(@style, 'background-color:#${Hex Colour}')]
    Page Should Contain Element    ${celllocator}

Set Currency Format for Numeric Cells
    [Arguments]    ${Currency}
    [Documentation]    Sets the currency for the selected cells
    Wait Until Keyword Succeeds    5s    1s    Robust Click    xpath=//button[@title='Currency format picker']
    Robust Click    xpath=//li/a[@data-currency-format='${Currency}']

Set Date Format Style for Numeric Cells
    [Arguments]    ${Date Format}
    [Documentation]    Sets the date format style for the selected cells
    Robust Click    xpath=//*[contains(@class, 'date-format-picker')]
    Robust Click    xpath=//li/a[@data-date-format='${Date Format}']

Set Decimal Places For Numeric Cells
    [Arguments]    ${Decimal Places}
    Comment    # focus the text field first before typing into it, we do this as sometimes the 'Input Text And Press Enter' keyword doesn't handle auto selection of the text box value very well and you end up with an appended result
    Comment    Simulate    xpath=//*[@name='decimal-places']    focus
    Comment    Sleep    1s    # small delay to allow focus processing to take place
    Comment    Input Text And Press Enter    xpath=//*[@name='decimal-places']    ${Decimal Places}
    Comment    Simulate    xpath=//*[@name='decimal-places']    blur
    Wait Until Element Is Visible    xpath=//*[@name='decimal-places']
    ${current_value}=    Get Value    xpath=//*[@name='decimal-places']
    ${diff}=    Evaluate    ${Decimal Places}-${current_value}
    Run Keyword If    ${diff}<0    Robust Click    xpath=//*[contains(@class, 'decimal-places-spinner')]//i[contains(@class, 'fa-sort-down')]
    Run Keyword If    ${diff}>0    Robust Click    xpath=//*[contains(@class, 'decimal-places-spinner')]//i[contains(@class, 'fa-sort-up')]
    Run Keyword If    ${diff} != 0    Set Decimal Places For Numeric Cells    ${Decimal Places}

Set Font Face For Active Selection
    [Arguments]    ${Font Name}    ${rowNo}    ${colNo}    ${Full Font Family}    # The size to set
    [Documentation]    Sets the font name for the active cells
    Robust Click    xpath=//*[contains(@class, 'font-picker') and @data-toggle='dropdown']
    Robust Click    xpath=//*[@class='font-menu-item' and text()='${Font Name}']
    Sleep    1s
    Verify Cell Style    ${rowNo}    ${colNo}    font-family    ${Full Font Family}

Set Font Size For Active Selection
    [Arguments]    ${rowNo}    ${colNo}    # The size to set
    [Documentation]    Sets the font size for the active cells
    ...
    ...    *Modified keyword to use the up/down spinners to set the new font size as trying to type text values into the input field caused problems when automation testing*
    ${currentfontsize}=    Get Value    xpath=//*[@name='font-size']
    ${largerfontsize}=    Evaluate    ${currentfontsize} + 1
    ${smallerfontsize}=    Evaluate    ${currentfontsize} - 1
    Robust Click    xpath=//*[contains(@class,'font-size-wrapper')]//a[@class='spin-up']
    Sleep    1s
    Verify Cell Style    ${rowNo}    ${colNo}    font-size    ${largerfontsize}px
    Robust Click    xpath=//*[contains(@class,'font-size-wrapper')]//a[@class='spin-down']
    Sleep    1s
    Robust Click    xpath=//*[contains(@class,'font-size-wrapper')]//a[@class='spin-down']
    Sleep    1s
    Verify Cell Style    ${rowNo}    ${colNo}    font-size    ${smallerfontsize}px

Set Foreground Colour For Active Selection
    [Arguments]    ${Hex Colour}    ${ieRGB}    ${rowNo}    ${colNo}    ${Expected RGB Value}
    [Documentation]    Sets the font colour for the active cells
    Robust Click    xpath=//*[contains(@class, 'font-colour') and @data-toggle='dropdown']
    # FIREFOX & CHROME use hex codes, IE uses RGB (with spaces). \ nice eh!
    ${locator}=    Set Variable If    '${BROWSER}'=='IE'    xpath=//*[contains(@class,'font-colour-wrapper')]//ul/table[@class='colour-picker']//div[@style='background-color: ${ieRGB};']    xpath=//*[contains(@class,'font-colour-wrapper')]//ul/table[@class='colour-picker']//div[@style='background-color: #${Hex Colour}']
    Robust Click    ${locator}
    Sleep    1s
    Verify Cell Style    ${rowNo}    ${colNo}    color    ${Expected RGB Value}

Set Horizontal Alignment For Selection
    [Arguments]    ${Alignment}    ${rowNo}    ${colNo}    # Must be one of 'Left', 'Right' or 'Center'
    [Documentation]    Sets the horizontal alignment for a given cell
    Select Cell in Editor    ${rowNo}    ${colNo}
    Click Element At Coordinates    xpath=//*[@data-property-name='horizontalAlignment' and @data-property-value='${Alignment}']    15    10
    Sleep    1s
    ${lower case align}=    evaluate    '${Alignment}'.lower()
    Verify Cell Style    ${rowNo}    ${colNo}    text-align    ${lower case align}

Set Negative Styles for Numeric Cells
    [Arguments]    ${Style Name}
    [Documentation]    Sets the negative cell style for the current selection.
    ...
    ...    Assumes the current selection has already been formated as a number.
    ...
    ...    Possible values for ${Style Name} are:
    ...
    ...    'Standard'
    ...    'Red'
    ...    'Parenthesis'
    ...    'RedParenthesis'
    Robust Click    xpath=//button[contains(@class, 'negative-picker')]
    Robust Click    xpath=//*[@data-neg-format='${Style Name}']

Set Scientific Display for Numeric Cells
    Robust Click    xpath=//*[@name='scientific']

Set Thousand Separator for Numeric Cells
    Robust Click    xpath=//*[@name='thousand-sep']

Set Time Format Style for Numeric Cells
    [Arguments]    ${Time Format}
    [Documentation]    Sets the time format style for the selected cells
    Robust Click    xpath=//*[contains(@class, 'time-format-picker')]
    Robust Click    xpath=//li/a[@data-time-format='${Time Format}']

Set Vertical Alignment For Selection
    [Arguments]    ${Alignment}    ${rowNo}    ${colNo}    # Must be one of 'Top', 'Bottom' or 'Middle'
    [Documentation]    Sets the vertical alignment for a given cell
    Select Cell in Editor    ${rowNo}    ${colNo}
    Sleep    1s
    Click Element    xpath=//*[@data-property-name='verticalAlignment' and @data-property-value='${Alignment}']
    Sleep    1s
    ${lower case align}=    evaluate    '${Alignment}'.lower()
    Verify Cell Style    ${rowNo}    ${colNo}    vertical-align    ${lower case align}

Spreadsheet Web Editor Test Cleanup
    [Arguments]    ${experiment_to_close}=None    # The id of the experiment to be closed
    ${status}    ${msg}    Run Keyword And Ignore Error    Exit Spreadsheet Lite Editor
    Run Keyword If    '${status}'=='PASS' and '${experiment_to_close}' != 'None'    Maybe Unlock Active Record    ${experiment_to_close}
    Run Keyword If    '${status}'=='FAIL'    Close All Browsers
    Run Keyword If    '${status}'=='FAIL'    Open Browser To Root

Start Sheet Picker
    [Arguments]    ${document number}
    [Documentation]    *Description*
    ...    Edits an existing spreadsheet in an open record
    ...
    ...    *Arguments*
    ...    ${document number} = The position of the document in the record, first document = 1
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - The record must be opened for editing
    ...
    ...    *Example*
    ...    | Lock Record For Editting |
    ...    | Start Inline Edit | 0 |
    Select Document Header    ${document number}
    ${docNumMinusOne} =    evaluate    int(${document number})-1
    Robust Click    document-header-${docNumMinusOne}-menuButton
    Robust Click    ewb-editor-command-edit-selected-previews
    Sleep    5s
    Wait Until Page Contains Element    display-pages-pages-panel-scroller

Start Spreadsheet Lite Editor
    [Arguments]    ${document number}
    [Documentation]    *Description*
    ...    Edits an existing spreadsheet in an open record
    ...
    ...    *Arguments*
    ...    ${document number} = The position of the document in the record, first document = 1
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - The record must be opened for editing
    ...
    ...    *Example*
    ...    | Lock Record For Editting |
    ...    | Start Inline Edit | 0 |
    Robust Select Spreadsheet Document Header    ${document number}
    ${docNumMinusOne}=    Evaluate    int(${document number}) -1
    Robust Click    xpath=//div[@id='document-header-${docNumMinusOne}-customWidget-editButton']/a
    Wait Until Page Contains Element    xpath=//iframe[@class='gwt-Frame']    180s
    Select Spreadsheet Editor Frame
    Wait Until Page Contains Element    xpath=//div[@class='drawer open']
    Wait Until Element Is Visible    xpath=//div[@class='instruction-panel']

Start Spreadsheet Lite Editor In View Mode
    [Arguments]    ${document number}
    [Documentation]    *Description*
    ...    Opens an existing spreadsheet in view only mode
    ...
    ...    *Arguments*
    ...    ${document number} = The position of the document in the record, first document = 1
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - The record must be opened for editing
    ...
    ...    *Example*
    ...    | Lock Record For Editting |
    ...    | Start Inline Edit | 0 |
    Select Document Header    ${document number}
    ${docNumMinusOne} =    evaluate    int(${document number})-1
    Robust Click    document-header-${docNumMinusOne}-menuButton
    Robust Click    ewb-command-ss-lite-editor-view
    Wait Until Page Contains Element    xpath=//iframe[@class='gwt-Frame']    90s
    Select Spreadsheet Editor Frame
    Wait Until Page Contains Element    xpath=//div[@class='drawer open']
    Element Should Not Be Visible    xpath=//div[@class='drawer open']

Tab Menu Contains Menu Item
    [Arguments]    ${tab name}    ${menu item text}
    Open Tab Menu    ${tab name}
    Page Should Contain Element    xpath=.//*[contains(@class, 'perspective-tabs')]//ul[@class='nav nav-tabs']//li[@data-model-name='${tab name}']//ul/li/a[@data-menu-item-text='${menu item text}']
    Close Tab Menu

Tab Menu Does Not Contain Menu Item
    [Arguments]    ${tab name}    ${menu item text}
    Open Tab Menu    ${tab name}
    Page Should Not Contain Element    xpath=.//*[contains(@class, 'perspective-tabs')]//ul[@class='nav nav-tabs']//li[@data-model-name='${tab name}']//ul/li/a[@data-menu-item-text='${menu item text}']
    Close Tab Menu

Toggle Navigator
    Robust Click    xpath=.//*[@id='container']//div[contains(@class, 'hide-browser')]

Type to Cell in Editor
    [Arguments]    ${view_name}    ${row_no}    ${col_no}    ${text}
    [Documentation]    Selects a cell in the spreadsheet widget, in the LITE editor, and adds text
    ${original_value}=    Wait Until Keyword Succeeds    20s    1s    Get Text    xpath=.//*[@id='view-${view_name}']//*[@id='c${row_no}-${col_no}']
    # If the given text and existing value are the same, then we don't need to run.
    ${no_run}=    Run Keyword And Return Status    Should Be Equal As Strings    ${text}    ${original_value}
    Return From Keyword If    ${no_run}
    # Insert the text
    : FOR    ${i}    IN RANGE    5
    \    Select Cell in Editor    ${row_no}    ${col_no}    ${view_name}
    \    #Set the text
    \    Double Click to Cell    ${view_name}    ${row_no}    ${col_no}
    \    Input Text    ${cell_editor_id}    ${text}
    \    Simulate    ${cell_editor_id}    blur
    \    Wait Until Element Is Not Visible    ${cell_editor_id}    10s
    \    #Check it has changed
    \    ${value_changed}=    Run Keyword and Return Status    Wait Until Keyword Succeeds    5s    1s    Verify Cell Value Does Not Equal
    \    ...    ${original_value}    ${row_no}    ${col_no}    ${view_name}
    \    Run Keyword If    ${value_changed}    Exit For Loop
    Run Keyword Unless    ${value_changed}    Capture Page Screenshot
    Run Keyword Unless    ${value_changed}    Fail    Cell value was not changed after 5 attempts.

Type to Cell in Editor when cell on canvas
    [Arguments]    ${canvasName}    ${matrixName}    ${rowNo}    ${colNo}    ${text}
    [Documentation]    Selects a cell in the spreadsheet widget on a canvas (in the LITE editor) and adds text
    ...
    ...    *Arguments*
    ...
    ...    _canvasName_ - the name of the canvas sheet that contains the matrix whose cell we want to populate
    ...
    ...    _matrixName_ - the name of the matrix on that canvas (as opposed to the name of the matrix itself).
    ...
    ...    _rowNo_ - the row of the cell (zero base)
    ...
    ...    _colNo_ - the column of the cell (zero base)
    ...
    ...    _text_ - the value for the cell
    Wait Until Page Contains Element    xpath=.//*[@id='view-${canvasName}']//*[@id='${matrixName}']//*[@id='c${rowNo}-${colNo}']    10s    # need to select element first (double click), otherwise next double-click doesn't work    ${EMPTY}    #${text}
    Double Click To Cell in Canvas    ${canvasName}    ${matrixName}    ${rowNo}    ${colNo}
    ${editor_xpath}=    Set Variable    STANDARD_EDITOR
    #click on parent element to ensure multiple cell selections are reliably performed
    Wait Until Keyword Succeeds    10s    1s    Double Click To Cell in Canvas    ${canvasName}    ${matrixName}    ${rowNo}
    ...    ${colNo}
    Wait Until Keyword Succeeds    10s    1s    Input Text    ${editor_xpath}    ${text}
    Simulate    ${editor_xpath}    blur

Underline Toggle Button Is Not Pressed
    [Documentation]    Tests that the underline toggle button is in a pressed state
    Page Should Not Contain Element    xpath=.//*[@data-property-name='fontUnderline' and contains(@class, 'active')]

Underline Toggle Button Is Pressed
    [Documentation]    Tests that the underline toggle button is in a pressed state
    Page Should Contain Element    xpath=.//*[@data-property-name='fontUnderline' and contains(@class, 'active')]

Undo Button Should Be Disabled
    [Documentation]    Verifies the undo button is present and disabled
    Wait Until Page Contains Element    xpath=.//*[@id='undo-button' and contains(@class, 'disabled')]    10s    1s

Undo Button Should Be Enabled
    [Documentation]    Verifies the undo button should be enabled
    Wait Until Page Contains Element    xpath=.//*[@id='undo-button' and not(contains(@class, 'disabled'))]    10s    1s

Undo Button Tooltip Should Be
    [Arguments]    ${expected_tooltip}
    [Documentation]    Verifies that the tooltip for the undo button is the value provided in the ${expected_tooltip} parameter
    Wait Until Page Contains Element    xpath=.//*[@id='undo-button' and contains(@title, '${expected_tooltip}')]    10s    1s

Verify Cell Is Bold
    [Arguments]    ${rowNo}    ${colNo}
    [Documentation]    *Checks that the given cell is bold.*
    ...
    ...    A font-weight style will be returned as "700" not "bold" - bold is synonymous with 700 as per w3 fonts spec - http://www.w3.org/TR/CSS2/fonts.html#font-boldness
    ${upBROWSER}=    evaluate    '${BROWSER}'.upper()
    #Safari & Chrome uses "bold" over "700"
    Run Keyword If    '${upBROWSER}'=='SAFARI'    Verify Cell Style    ${rowNo}    ${colNo}    font-weight    bold
    ...    ELSE IF    '${upBROWSER}'=='CHROME'    Verify Cell Style    ${rowNo}    ${colNo}    font-weight
    ...    bold    ELSE    Verify Cell Style    ${rowNo}    ${colNo}    font-weight
    ...    700

Verify Cell Is Italic
    [Arguments]    ${rowNo}    ${colNo}
    Verify Cell Style    ${rowNo}    ${colNo}    font-style    italic

Verify Cell Is Struck Through
    [Arguments]    ${rowNo}    ${colNo}
    Verify Cell Style    ${rowNo}    ${colNo}    text-decoration    line-through

Verify Cell Is Underlined
    [Arguments]    ${rowNo}    ${colNo}
    Verify Cell Style    ${rowNo}    ${colNo}    text-decoration    underline

Verify Cell Link Display Name
    [Arguments]    ${rowNo}    ${colNo}    ${linkDisplayName}
    [Documentation]    Verifies the cell's web link display name is correct
    ${nameValue}=    Get Text    xpath=.//*[@id='c${rowNo}-${colNo}']/a
    Should Be Equal As Strings    ${nameValue}    ${linkDisplayName}

Verify Cell Style
    [Arguments]    ${rowNo}    ${colNo}    ${style}    ${style-value}
    [Documentation]    Verifies a cell has a given style
    ...
    ...    *arguments*
    ...    - rowNo - the row number to insepct (starts at zero)
    ...    - colNo - the column number to inspect (starts at zero)
    ...    - style - the CSS style name
    ...    - style-value - the expected value of the style
    ...
    ...    *return value*
    ...    - None
    ...
    ...    *Example*
    ...    | Verify Cell Style | 0 | 0 | font-weight | 700 |
    Select Cell in Editor    ${rowNo}    ${colNo}
    Sleep    2s
    ${style}=    Get Element Css Value    xpath=.//div[@id='c${rowNo}-${colNo}']@${style}
    ${style}=    Evaluate    '${style}'.lower().replace(' ', '')    #handle cross browser inconsistencies in style case and whitespacing
    ${style-value}=    Evaluate    '${style-value}'.lower().replace(' ', '')
    Should Be Equal As Strings    ${style}    ${style-value}

Verify Cell URL
    [Arguments]    ${rowNo}    ${colNo}    ${URL}    # The href URL to test for
    [Documentation]    Verifies a cell has a given style
    ${hrefValue}=    IDBSSelenium2Library.Get Element Attribute    xpath=.//*[@id='c${rowNo}-${colNo}']/a@href
    Check String Equals    Cell URL    ${hrefValue}    ${URL}

Verify Cell Value
    [Arguments]    ${Expected Text}    ${rowNo}    ${colNo}
    [Documentation]    Verifies the text within the cell matches the expected value
    ${passed}=    Run Keyword And Return Status    Wait Until Keyword Succeeds    10s    1s    Element Text Should Be    xpath=.//*[@id='c${rowNo}-${colNo}']    ${Expected Text}
    Run Keyword Unless    ${passed}    Capture Page Screenshot    # If the cell value doesn't contain what we expected, ${passed} will be false. Ensuring screenshot is taken here so that we can see any problems.
    Run Keyword Unless    ${passed}    Fail    Expected text: '${Expected Text}' not present in cell. See screenshot or expand 'Element Text Should Be' attempts for more info.

Verify Current Perspective
    [Arguments]    ${perspective-name}
    [Documentation]    Tests that the current perspective being displayed is the one supplied as an argument to this keyword.
    ...
    ...    This test will wait a set amount of time before it fails as it may take some time to render the selected perspective
    Wait Until Page Contains Element    xpath=.//*[contains(@class, 'perspective-selector')]//button[text()='${perspective-name}']    5

Verify Drawer Is Closed
    [Documentation]    Verifies the app drawer is in an Closed state
    Page Should Contain Element    xpath=//div[@class='drawer closed']

Verify Drawer Is Open
    [Documentation]    Verifies the app drawer is in an Open state
    Page Should Contain Element    xpath=//div[@class='drawer open']

Verify File Import Button Not Present
    Page Should Not Contain Element    xpath=.//*[contains(@class, 'import-button')]

Verify File Import Disabled
    Element Should Be Disabled    xpath=//*[contains(@class, 'import-button')]

Verify File Import Panel Hidden
    [Documentation]    Confirms that the file import panel is hidden
    Wait Until Element Is Not Visible    xpath=//*[contains(@class, 'file-import-panel')]    5s

Verify Import Definition Count
    [Arguments]    ${importDefinitionCount}
    [Documentation]    Confirms that the number of import definitions is the given value
    ...
    ...    *Arguments*
    ...
    ...    _importDefinitionCount_ - the expected number of import definitions
    Xpath Should Match X Times    //*[@data-importdefinition-name]    ${importDefinitionCount}

Verify Import Definition Selected
    [Arguments]    ${definition name}
    Wait Until Page Contains Element    xpath=.//button[contains(@class, "import-definition-picker") and contains(text(), "${definition name}")]

Verify Import File Count
    [Arguments]    ${importFileCount}
    [Documentation]    Confirms that the number of import files is the given value
    ...
    ...    *Arguments*
    ...
    ...    _importFileCount_ - the expected number of import files
    Wait Until Keyword Succeeds    5s    1s    Xpath Should Match X Times    //*[contains(@class, 'file-list-item')]    ${importFileCount}

Verify Import Matrix Count
    [Arguments]    ${matrixCount}
    [Documentation]    Confirms that the number of matrices into which a file can be imported is the given value
    ...
    ...    *Arguments*
    ...
    ...    _matrixCount_ - the expected number of matrices
    Xpath Should Match X Times    //*[@data-matrix-name]    ${matrixCount}

Verify Import Matrix Selected
    [Arguments]    ${matrix name}
    Wait Until Page Contains Element    xpath=.//button[contains(@class, "file-import-picker") and contains(text(), "${matrix name}")]

Verify Layout Is Not Displayed
    Wait Until Page Contains Element    xpath=.//*[@class='too-complex-panel']    5s

Verify Next Perspective Button Is Disabled
    Wait Until Page Contains Element    xpath=.//*[contains(@class, 'perspective-selector')]//span[contains(@class, 'right') and contains(@class, 'disabled')]    10s

Verify Next Perspective Button Is Enabled
    Page Should Contain Element    xpath=.//*[contains(@class, 'perspective-selector')]//span[contains(@class, 'nav-button right') and not(contains(@class, 'disabled'))]

Verify Notification Header Issue Count
    [Arguments]    ${expected_count}
    [Documentation]    Verifies the lite editor has a certain number of reported problems highlighted in the applicatio header
    Wait Until Element Text Contains    xpath=//*[contains(@class, 'problem-indicator')]    ${expected_count}    10s

Verify Perspective Has X Tab Groups
    [Arguments]    ${expected-count}
    Sleep    1s
    ${count}=    Get Matching Xpath Count    .//*[@class='root-panel']//*[@class='perspective-tabs']
    Check Number Equals    The number of tab groups    ${count}    ${expected-count}

Verify Perspective Picker Tooltip Is Present
    [Arguments]    ${perspective-name}
    Page Should Contain Element    xpath=.//*[contains(@class, 'perspective-list')]/li[@data-item='${perspective-name}']/div/a[@title='${perspective-name}']

Verify Previous Perspective Button Is Disabled
    Page Should Contain Element    xpath=.//*[contains(@class, 'perspective-selector')]//span[contains(@class, 'left') and contains(@class, 'disabled')]

Verify Previous Perspective Button Is Enabled
    Page Should Contain Element    xpath=.//*[contains(@class, 'perspective-selector')]//span[contains(@class, 'nav-button left') and not(contains(@class, 'enabled'))]    10s

Verify Selection Format
    [Arguments]    ${Expected Format}
    [Documentation]    Verifies the format of the current selection based on the value specified in the data type drop down
    Wait Until Element Text Is    xpath=*//button[contains(@class, 'datatype-picker')]    ${Expected Format}    10s

Verify Tab Is Active Primary
    [Arguments]    ${table name}
    Wait Until Page Contains Element    xpath=.//*[@data-model-name='${table name}' and contains(@class, 'model-view-tab') and contains(@class, 'active') and contains(@class, 'primary')]

View is Marked as Closed in the Model Browser
    [Arguments]    ${view-name}
    Wait Until Page Does Not Contain Element    xpath=.//*[contains(@class, "view-open")]//a[@data-view-name="${view-name}"]    5s

View is Marked as Open in the Model Browser
    [Arguments]    ${view-name}
    Wait Until Page Contains Element    xpath=.//*[contains(@class, "view-open")]//a[@data-view-name="${view-name}"]    5s

Wait For Lite Editor Close
    [Arguments]    ${timeout}=120s
    [Documentation]    Waits for the Lite editor to close - this is handled by ensuring that no frame is selected and then checks for the iframe denoting the iframe to disappear.
    ...
    ...    *NOTE: AFTER THIS KEYWORD HAS RUN NO FRAME WILL BE SELECTED*
    ...
    ...    *Arguments*
    ...    - timeout, default=120s
    ...
    ...    *Return Value*
    ...    - None
    ...
    ...    *Pre-requisites*
    ...    - None
    ...
    ...    *Example*
    ...    | Wait For Lite Editor Close | 10s |
    Unselect Frame
    Wait Until Page Does Not Contain Element    lite-editor-frame    ${timeout}

Zoom Image Dialog Click Reset
    # zoom in/out using the keyboard as this is more robust than hoping that a button will be there. The buttons only appear when the mouse hovers over them
    Press Key    xpath=*//div[contains(@class,'modal-body')]    r
    Sleep    1s    # Allow transform to fire

Zoom Image Dialog Click Zoom In
    # zoom in/out using the keyboard as this is more robust than hoping that a button will be there. The buttons only appear when the mouse hovers over them
    Press Key    xpath=*//div[contains(@class,'modal-body')]    i
    Sleep    1s    # Allow transform to fire

Zoom Image Dialog Click Zoom Out
    # zoom in/out using the keyboard as this is more robust than hoping that a button will be there. The buttons only appear when the mouse hovers over them
    Press Key    xpath=*//div[contains(@class,'modal-body')]    o
    Sleep    1s    # Allow transform to fire

Zoom Image Dialog Should Be Open
    Wait Until Keyword Succeeds    5s    1s    Element Text Should Be    dialogLabel    View Image

Zoom Image Dialog Verify Current Transform
    [Arguments]    ${matrix}
    ${transform}=    IDBSSelenium2Library.Get Element Css Value    previewImage@transform
    ${transform2}=    Run Keyword If    '${transform}'=='none' or '${transform}' == ''    IDBSSelenium2Library.Get Element Css Value    previewImage@-webkit-transform
    ${final}=    Set Variable If    '${transform}'=='none' or '${transform}' == ''    ${transform2}    ${transform}
    ${final}=    Evaluate    "${final}".replace(" ","")
    ${matrix}=    Evaluate    "${matrix}".replace(" ","")
    Should Be Equal    ${final}    ${matrix}

Wait for Query Mask to Finish
    [Arguments]    ${timeout}=60s    ${interval}=1s
    [Documentation]    *Description*
    ...
    ...    Waits for the Spreadsheet Web Editor mask to complete.
    ...
    ...    The mask is present when doing SQL DataLinks, Embedded searches and File Imports in the Spreadsheet Web Editor
    Run Keyword And Ignore Error    Wait Until Element Is Visible    webEditorMask    5s
    Wait Until Keyword Succeeds    ${timeout}    ${interval}    Element Should Not Be Visible    webEditorMask    # Wait for Mask

Zoom Image Dialog Transform should not be
    [Arguments]    ${matrix}
    [Documentation]    Takes a matrix value input and will ensure that the current CSS value does not match
    ${transform}=    IDBSSelenium2Library.Get Element Css Value    previewImage@transform
    ${transform2}=    Run Keyword If    '${transform}'=='none' or '${transform}' == ''    IDBSSelenium2Library.Get Element Css Value    previewImage@-webkit-transform
    ${final}=    Set Variable If    '${transform}'=='none' or '${transform}' == ''    ${transform2}    ${transform}
    ${final}=    Evaluate    "${final}".replace(" ","")
    ${matrix}=    Evaluate    "${matrix}".replace(" ","")
    Should Not Be Equal    ${final}    ${matrix}

Cell Should Be Knocked Out
    [Arguments]    ${rowNo}    ${colNo}    ${viewName}=${EMPTY}
    [Documentation]    confirms that the identified cell in the spreadsheet web editor is knocked out. \ This will try a number of times to check the knockout status before failing if the cell is not knocked out.
    ...
    ...    *If you have more than one view showing then specify the name of the view whose cell you want to select*
    ...
    ...    *Arguments*
    ...
    ...    _row_ - the row index number (starts at 0)
    ...
    ...    _col_ - the column index number (starts at 0)
    ...
    ...    _viewName_ - the name of the view (optional). Only needs to be specified if more than one table is visible at the same time.
    # build the xpath based on the optional viewName argument
    ${xpath}=    set variable if    '${viewName}' == '${EMPTY}'    //*[@id='c${rowNo}-${colNo}']/../div[@class='knockedout-indicator']    //*[@id='view-${viewName}']//*[@id='c${rowNo}-${colNo}']/../div[@class='knockedout-indicator']
    # let's try a few times to check for the component to be knocked out    # just in case it has been triggered by a calculation and it hasn't been refreshed yet.
    wait until keyword succeeds    5s    1s    Element Should Be Visible    xpath=${xpath}

Click Data Import Link With No Imports
    [Documentation]    opens the datat presses the data import button and waits for the "no info" panel.
    Robust Click    xpath=.//*[contains(@class, 'file-import')]
    Wait Until Element Is Visible    xpath=.//div[contains(@class, 'no-import-tables')]

Retrieve Cell Value
    [Arguments]    ${rowNo}    ${colNo}
    [Documentation]    Retrieves the text within the cell
    Run Keyword And Return    Get Text    xpath=.//*[@id='c${rowNo}-${colNo}']

Add Rows to Web Matrix
    [Arguments]    ${table}    ${RowsToAdd}
    [Documentation]    Takes the first cell in ${table} and press Enter ${RowsToAdd} times for new rows.
    Select Sheet In Tab    ${table}
    Select Cell in Editor    0    0    ${table}
    Press Left Arrow
    Sleep    20s

Wait for Asset Mask to Finish
    [Arguments]    ${timeout}=10s    ${interval}=1s
    [Documentation]    *Description*
    ...
    ...    Waits for the Spreadsheet Web Editor, asset update on demand mask to complete.
    ...
    ...    The mask is present when doing Asset updates and Deletes on demand in the Spreadsheet Web Editor
    Run Keyword and Ignore Error    Wait Until Keyword Succeeds    ${timeout}    ${interval}    Element Should Be Visible    webEditorMask    # Wait for Mask - ignore error here for cases where the test is too slow to detect it displaying briefly.
    Wait Until Keyword Succeeds    ${timeout}    ${interval}    Element Should Not Be Visible    webEditorMask    # Wait for Mask

Cell Should Not Be Knocked Out
    [Arguments]    ${rowNo}    ${colNo}    ${viewName}=${EMPTY}
    [Documentation]    confirms that the identified cell in the spreadsheet web editor is NOT knocked out. \ This will try a number of times to check the knockout status before failing if the cell is knocked out.
    ...
    ...    *If you have more than one view showing then specify the name of the view whose cell you want to select*
    ...
    ...    *Arguments*
    ...
    ...    _row_ - the row index number (starts at 0)
    ...
    ...    _col_ - the column index number (starts at 0)
    ...
    ...    _viewName_ - the name of the view (optional). Only needs to be specified if more than one table is visible at the same time.
    # build the xpath based on the optional viewName argument
    ${xpath}=    set variable if    '${viewName}' == '${EMPTY}'    //*[@id='c${rowNo}-${colNo}']/../div[@class='knockedout-indicator']    //*[@id='view-${viewName}']//*[@id='c${rowNo}-${colNo}']/../div[@class='knockedout-indicator']
    # let's try a few times to check for the component to be knocked out    # just in case it has been triggered by a calculation and it hasn't been refreshed yet.
    wait until keyword succeeds    5s    1s    Element Should Not Be Visible    xpath=${xpath}

Get Editor Cell Value
    [Arguments]    ${row_no}    ${col_no}    ${view_name}
    [Documentation]    Get the Cell Value of Cell in the Spreadsheet Editor
    Run Keyword If    '${view_name}'    Wait Until Element Is Visible    xpath=.//*[@id='view-${view_name}']//*[@id='c${row_no}-${col_no}']    ELSE    Wait Until Element Is Visible    c${row_no}-${col_no}
    ${cell_value}=    Execute Javascript    return document.getElementById('c${row_no}-${col_no}').innerHTML
    [Return]    ${cell_value}

Internal Double Click to Cell in Canvas
    [Arguments]    ${canvasName}    ${matrixName}    ${rowNo}    ${colNo}
    ${editor_xpath}=    Set Variable    STANDARD_EDITOR
    ${already_visible}=    Run Keyword And Return Status    Element Should Be Visible    ${editor_xpath}
    Run Keyword Unless    ${already_visible}    Robust Double Click Element    xpath=.//*[@id='view-${canvasName}']//*[@id='${matrixName}']//*[@id='c${rowNo}-${colNo}']
    Element Should Be Visible    ${editor_xpath}

Double Click To Cell in Canvas
    [Arguments]    ${canvasName}    ${matrixName}    ${rowNo}    ${colNo}
    #Workaround for Selenium double click bug
    Wait Until Keyword Succeeds    60s    1s    Internal Double Click to Cell in Canvas    ${canvasName}    ${matrixName}    ${rowNo}
    ...    ${colNo}

Internal Double Click to Cell
    [Arguments]    ${viewName}    ${rowNo}    ${colNo}
    ${editor_xpath}=    Set Variable    STANDARD_EDITOR
    ${already_visible}=    Run Keyword And Return Status    Element Should Be Visible    ${editor_xpath}
    Run Keyword Unless    ${already_visible}    Robust Click    xpath=.//*[@id='view-${viewName}']//*[@id='c${rowNo}-${colNo}']/..    # Without this first 'priming' click, the double click always fails first time.
    Run Keyword Unless    ${already_visible}    Robust Double Click Element    xpath=.//*[@id='view-${viewName}']//*[@id='c${rowNo}-${colNo}']/..
    Element Should Be Visible    ${editor_xpath}

Double Click to Cell
    [Arguments]    ${viewName}    ${rowNo}    ${colNo}
    #Workaround for Selenium double click bug
    Wait Until Keyword Succeeds    60s    1s    Internal Double Click to Cell    ${viewName}    ${rowNo}    ${colNo}

Verify Cell Value Does Not Equal
    [Arguments]    ${expected_text}    ${rowNo}    ${colNo}    ${view_name}=${EMPTY}
    [Documentation]    Verifies the text within the cell matches the expected value
    ${value}=    quantrix_web_resource.Get Editor Cell Value    ${rowNo}    ${colNo}    ${view_name}
    ${passed}=    Run Keyword And Return Status    Should Not Be Equal    ${value}    ${expected_text}
    Run Keyword Unless    ${passed}    Capture Page Screenshot    # If the cell value doesn't contain what we expected, ${passed} will be false. Ensuring screenshot is taken here so that we can see any problems.
    Run Keyword Unless    ${passed}    Fail    Expected text: '${expected_text}' not present in cell. See screenshot or expand 'Element Text Should Be' attempts for more info.

Dismiss Alert Popup
    [Documentation]    Dismisses the alert popup
    Wait Until Page Contains Element    ${xpath_web_spreadsheet_alert_popup}    30s    # Alert Pop-up
    Wait Until Element Is Enabled    xpath=//button[text()='OK']
    Click button    xpath=//button[text()='OK']

Type to Cell Editor and Expect Error
    [Arguments]    ${viewName}    ${rowNo}    ${colNo}    ${text}
    [Documentation]    Types the given ${text} into the cell at the given index: ${rowNo}-${colNo} in the table with the given ${viewName}. Following this, the keyword waits for the web spreadsheet alert popup to appear.
    ${editor_xpath}=    Set Variable    STANDARD_EDITOR
    Robust Click    xpath=.//*[@id='c${rowNo}-${colNo}']
    Robust Double Click Element    xpath=.//*[@id='c${rowNo}-${colNo}']
    Wait Until Page Contains Element    ${editor_xpath}    10s
    Input Text    ${editor_xpath}    ${text}
    Simulate    ${editor_xpath}    blur
    Wait Until Page Contains Element    ${xpath_web_spreadsheet_alert_popup}    30s    # Alert Pop-up

Validate Light Editor Selected Cell Constraint Contents
    [Arguments]    ${rowNo}    ${colNo}    @{contents}
    [Documentation]    *Description*
    ...
    ...    Activates the input cell constraints dialog for the selected cell and then checks that the contents of the input list are as specified.
    ...
    ...
    ...    NOTE: \ This is not a very robust method as there is not a nice way to actually activate the drop down. \ check out the comments inside to see how bad things really are...
    ...
    ...
    ...    *Arguments*
    ...
    ...    _${rowNo}_ the row index (0-base)
    ...
    ...    _${colNo}_ the column index (0-base)
    ...
    ...    _@{contents}_ the expected contents of the list (order is not checked)
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - The light editor must be open with the right sheet selected
    ...    - A single cell must be selected
    ...    - The cell must have a list constraint already applied to it
    ...    - There are no <img class="gwt-Image"...> tags already in the document
    ...
    ...    *Example*
    ...    | Validate Light Editor Selected Cell Constraint Contents | a | b | c | d |
    # right, this is bit hacky. \ drop-down button is not named & so we have to find it by it's class. \ but if there is one already in the DOM then we're screwed.
    Wait Until Page Does Not Contain Element    xpath=//img[@class="gwt-Image"]    3s    # reduced timeout for optimisation
    # select the cell
    Select Cell in Editor    ${rowNo}    ${colNo}
    sleep    50ms
    # click on the drop down button
    Robust Click    xpath=//div[contains(@class,"s_dropDownHead"]
    Wait Until Page Contains Element    xpath=//div[@class="popupContent"]    30s
    # check expected contents
    : FOR    ${content}    IN    @{contents}
    \    Element Text Should Be    //div[@class="popupContent"]//div[text()="${content}"]    ${content}
    #re-select the cell to close the editor
    Select Cell in Editor    ${rowNo}    ${colNo}
