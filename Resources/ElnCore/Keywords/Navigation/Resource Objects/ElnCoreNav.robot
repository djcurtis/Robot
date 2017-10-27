*** Settings ***
Library    IDBSSelenium2Library
Library    ManualActionLibrary
Library    Dialogs
Resource          ../../Common/common_resource.robot
Resource          ../../Selenium/general_resource.robot


*** Variables ***
${ROOT_BREADCRUMB} =    xpath=//a[contains(@class, 'ewb-breadcrumb-terminal') and contains(text(), 'Root')]
${HOMEPAGE_TITLE} =    app-header-title
${HOMEPAGE_ELEMENT} =    xpath=.//*[@id='navigator-link-label']
#${HOMEPAGE_ROOTELEMENT} =   .//*[@id='ewb-appshell-center-header']/div[2]/div/div[1][contains(text(),'Root')
${NEW_ITEM_ICON} =   xpath=//img[@class='new-item-icon']
${NEW_PROJECT_TITLE_FIELD} =    ewb-attribute-editor-title
${NEW_GROUP_NAME_FIELD} =    ewb-attribute-editor-name
${CREATE_BUTTON} =  save-properties
${ok_button} =   okButton
${NEW_PROJECT_BREADCRUMB} =  xpath=//*[@id='ewb-card-layout-crumb-3']/div[1]/a
${NEW_TILE_ICON} =  xpath=//div[@class='ewb-new-entity-panel']
${NEW_PROJECT_ICON} =  xpath=//div[@id='ewb-entity-command-new-PROJECT']//div[@class='gwt-Label label'][contains(@title,'Project')]
${NEW_GROUP_ICON} =  xpath=//div[@id='ewb-entity-command-new-GROUP']//div[@class='gwt-Label label'][contains(@title,'Group')]
${NEW_BLANK_EXPERIMENT_ICON} =     xpath=//div[@id='ewb-entity-command-new-EXPERIMENT']//div[@class='gwt-Label label'][contains(@title,'Blank Experiment')]
${NEW_TEMPLATE_ICON} =     xpath=//div[@id='ewb-entity-command-new-TEMPLATE']//div[@class='gwt-Label label'][contains(@title,'Template')]
${INSERT_RECORD_ITEM_BUTTON} =    ewb-insert-record-item-button
${INSERT_ITEM_POPUP} =    ewb-new-entity-dialog-popup
${TEXT_ITEM} =    xpath=//div[@class='entity-type-panel']/div[@class='entities']/div[@id='ewb-create-text-item']
${FILE_ITEM} =    xpath=//div[@class='entity-type-panel']/div[@class='entities']/div[@id='ewb-create-file-item']
${SPREADSHEET_ITEM} =    xpath=//div[@class='entity-type-panel']/div[@class='entities']/div[@id='ewb-ss-create-spreadsheet-item']
${FIND_TEMPLATE} =    xpath=//div[@class='find-template'][@tabindex='0']//div[@class='gwt-Label label'][contains(@title,'Find Template')]
${image_item} =    xpath=//div[@class='ewb-center-child']/img
${DISCARD_CHANGES_LINK} =    ewb-editor-command-close-record
${TEXT_PANEL} =    tinymce
${TEXT_APPLY_BUTTON} =    xpath=//*[@class='ewb-document-header-button-primary'][contains(text(),'Apply')]
${TEXT_EDIT_BUTTON} =    xpath=//*[@class='ewb-document-header-button-primary'][contains(text(),'Edit')]
#Save As Button
${SAVEAS_BUTTON} =    xpath=//*[@id='ewb-record-action-bar'][contains(text(),'Save As')]
${SAVE_AS_MENU_ITEM_NEW_VERSION} =    xpath=//*[@id='ewb-editor-command-version-save-record']
${VERSION_SAVE_REASON_DROPDOWN} =    xpath=//div[@id='ewb-authentication-user-action-note']//*[@class='gwt-TextBox enabled']
${COMMENT_FIELD} =    xpath=//*[@id='ewb-authentication-user-additional-comment']
#Review and Sign Button
${REVIEW_AND_SIGN_BUTTON} =    xpath=//*[@class="workflows-text}"][contains(text(),'Review & Sign')]
${PUBLISH_PDF_MENU_ITEM} =    xpath=//*[@id='ewb-entity-command-publish']/a
${SIGN_OFF_RECORD_MENU_ITEM} =    xpath=//*[@id='ewb-record-sign-off-command']/a
#Workflows
${WORKFLOW_COMBOBOX} =    xpath=//*[@id='ewb-record-outline-sign-off-workflow']/div[@class='idbs-gwt-combobox enabled ewb-combobox']//img[@class='gwt-Image dropdown']
${WORKFLOW_SELECTION_ITEM_DONT_START} =    xpath=//div[@class='ewb-workflow-item-dont-start']
${SET_WORKFLOW_VALUE} =    xpath=//div[@class'ewb-workflow-item']/div[@class='name']
${REVIEW_AND_SIGN_SIGN_ALL_BUTTON} =    xpath=//button[@id='ewb-record-outline-sign-off-footer-sign-all']
${CREATE_WORKFLOW_BUTTON} =    ewb-workflows-creation-step-two-create
${SIGN_SELECTED_BUTTON} =    ewb-record-outline-sign-off-footer-sign-selected

${SELECT_FILE_BUTTON} =    xpath=//*[@id='ewb-web-file-input']


${SEARCH_HEADER_LINK} =    xpath=//div[@id='ewb-header-link-search'][contains(@title,'Search for E-WorkBook records')]
${MY_TASKS_HEADER_LINK} =    xpath=//div[@id='app-header-link-tasks-label'][contains(text(),'My Tasks')]
${NAVIGATOR_HEADER_LINK} =    xpath=//div[@id='navigator-link-label'][contains(text(),'Navigator')]



*** Keywords ***

Check Header Title Exists
    Wait Until Page Contains Element    ${HOMEPAGE_TITLE}

Check Homepage Root Exists
    Wait Until Page Contains Element    ${HOMEPAGE_ELEMENT}

Select New Tile
    Robust Click    ${NEW_TILE_ICON}

Select New Record Tile
    wait until page contains element  xpath=//*[@id='ewb-insert-record-item-button']
    Robust Click    xpath=//*[@id='ewb-insert-record-item-button']

Select Create New Project
    Robust Click    ${NEW_PROJECT_ICON}

Select Create New Group
    Robust Click    ${NEW_GROUP_ICON}

Select Create New Blank Experiment
    Robust Click    ${NEW_BLANK_EXPERIMENT_ICON}

Enter Mandatory Field - Project Name
    wait until page contains element    xpath=//*[@id="ewb-attribute-editor-Project-input"]
    Input Text     xpath=//*[@id="ewb-attribute-editor-Project-input"]    General
    Robust Click    xpath=//*[@id="ewb-attribute-editor-listBox-Project-addButton"]

Select Create New Template
    Robust Click    ${NEW_TEMPLATE_ICON}

Enter New Project Name
    [Arguments]  ${PROJECT_NAME}
    Input Text  ${NEW_PROJECT_TITLE_FIELD}  ${PROJECT_NAME}

Enter New Group Name
    [Arguments]  ${GROUP_NAME}
    Input Text  ${NEW_GROUP_NAME_FIELD}  ${GROUP_NAME}

Enter New Experiment Name
    [Arguments]  ${EXPERIMENT_NAME}
    wait until page contains element    ewb-attribute-editor-title-input
    Input Text  ewb-attribute-editor-title-input    ${EXPERIMENT_NAME}

Enter New Template Name
    [Arguments]  ${TEMPLATE_NAME}
    wait until page contains element    ewb-attribute-editor-title-input
    Input Text  ewb-attribute-editor-title-input   ${TEMPLATE_NAME}

Select Insert Record Item Button
    Robust Click    ${INSERT_RECORD_ITEM_BUTTON}
    wait until page contains element    ${INSERT_ITEM_POPUP}

Select Text Item
    Robust Click    ${TEXT_ITEM}

Select Image
    Robust Click    ${image_item}

Select Image in Editor
    Robust Click    xpath=//*[@id='svg-element-0']

Select Find Template
    Robust Click    ${FIND_TEMPLATE}


Select Template Name
    [Arguments]    ${template_name}
    set selenium speed    1
    wait until page contains element    xpath=//div[@class='gwt-Hyperlink ewb-entity-treenode-text']/a[contains(text(),'${template_name}')]
    Robust Click    xpath=//div[@class='gwt-Hyperlink ewb-entity-treenode-text']/a[contains(text(),'${template_name}')]
    set selenium speed    1

Select File and Image Item
    Robust Click    ${FILE_ITEM}

Select Upload Button
    Robust Click    ${SELECT_FILE_BUTTON}

Select Spreadsheet Item
    Robust Click    ${SPREADSHEET_ITEM}

Select Search Image
    Robust Click    ${SEARCH_HEADER_LINK}

Select My Tasks
    Robust Click    ${MY_TASKS_HEADER_LINK}

Select Navigator
    set selenium speed    2
    wait until page contains element     ${NAVIGATOR_HEADER_LINK}
    Robust Click    ${NAVIGATOR_HEADER_LINK}
    set selenium speed    1




Select Record Options Menu
    wait until page contains element    xpath=//div[@id='application-header-toolButton']/img
    Robust Click    xpath=//div[@id='application-header-toolButton']/img
    wait until page contains element    xpath=//*[@id='ewb-record-menu']

Select Entity Options Menu
    [Arguments]    ${entity_ref}
    wait until page contains element   xpath=//div[@id='document-header-${entity_ref}-menuButton']/img
    Robust Click  xpath=//div[@id='document-header-${entity_ref}-menuButton']/img

Select Allow Further Editing
    wait until page contains element    xpath=//*[@id='ewb-editor-command-allow-record-edit']/a[contains(text(),'Allow Further Editing')]
    Robust Click    xpath=//*[@id='ewb-editor-command-allow-record-edit']/a[contains(text(),'Allow Further Editing')]

Enter Version Save Reason
    wait until page contains element    ${VERSION_SAVE_REASON_DROPDOWN}
    Input Text    ${VERSION_SAVE_REASON_DROPDOWN}    Data Added

Enter Version Save Comment
    [Arguments]    ${VERSION_SAVE_COMMENT}
    Input Text    ${COMMENT_FIELD}    ${VERSION_SAVE_COMMENT}

Select New Version from Menu
    Robust Click    ${SAVE_AS_MENU_ITEM_NEW_VERSION}

Select Apply Text Change
    wait until page contains element    ${TEXT_APPLY_BUTTON}
    Robust Click    ${TEXT_APPLY_BUTTON}

Select Discard Text Change
    [Arguments]    ${item_ref}
    wait until page contains element    xpath=//*[@id='document-header-${item_ref}-customWidget-acceptAndDiscard']//*[@class='ewb-document-header-button'][contains(@title,'Discard Changes')]
    Robust Click    xpath=//*[@id='document-header-${item_ref}-customWidget-acceptAndDiscard']//*[@class='ewb-document-header-button'][contains(@title,'Discard Changes')]

Signature Panel Removed for Item
    [Arguments]    ${item_ref}
    wait until page does not contain element    xpath//*[@id='document-signatures-${item_ref}-panel']//*[@class='ewb-signature-panel-cell']/div[contains(@class,'ewb-signature-panel')]

Select File to Update
    [Arguments]    ${test_path}    ${document_name}
    Wait Until Element Is Visible       xpath=//button[contains(text(),'Browse')]    20
    Input Text    xpath=//input[@id='ewb-web-file-input']    ${EXECDIR}/${test_path}/${document_name}


Select Menu Update File Option
    Robust Click    xpath=//*[@id="ewb-command-file-editing-upload"]/a[contains(text(),'Update File')]

Update File Window Displayed
    wait until page contains element    xpath=//*[@id='ewb-web-file-input']

Confirm Status Value
    [Arguments]    ${EXPT_STATUS}
    element text should be    xpath=//div[@class='ewb-document-panel-footer']//*[contains(text(), '${EXPT_STATUS}')]    ${EXPT_STATUS}

Add Text to Text Area
    [Arguments]    ${text_entry}
    Input Text    xpath=//textarea[contains(@class,'ewb-textbox')]    ${text_entry}
    Robust Click    ${ok_button}

Select Ok Button
    Robust Click    ${ok_button}

Select Delete Option
    [Arguments]    ${DOC_INDEX}
    Log    ${DOC_INDEX}
    Open Document Header Tool Menu    ${DOC_INDEX}
    Wait until page contains element    xpath=//*[@id='ewb-editor-command-delete-doc']
    Robust Click    xpath=//*[@id='ewb-editor-command-delete-doc']

Confirm Deletion of Document
    wait until page contains element  xpath=//*[contains(@class,'ewb-dialog-button-panel')]
    Robust Click    ${ok_button}


Select Version History
    Robust Click    xpath=//*[@id="ewb-view-version-history-command"]/a[contains(text(),'Version History')]

Select Text Frame
    Robust Click    ${TEXT_PANEL}

Select Apply Button
    Robust Click    xpath=//*[@id="saveImage"]

Save Properties
    Robust Click    ${CREATE_BUTTON}

Select Choose Template
    wait until page does not contain element    xpath=//*[contains(@class,'ewb-image-button-disabled')]
    Robust Click    ${ok_button}

Click on Text Item Header
    Click element    xpath=//*[@class='ewb-document-header-leftcol']

Confirm Warning Dialog is Present
    wait until page contains element    xpath=//div[contains(@class,'ewb-message-box-text')]

Select Reviewer Dropdown
    [Arguments]    ${TASK_ID}
    Click Element    ewb-workflows-creation-task-setup-${TASK_ID}-suggest-dropdownImage

Set User
    [Arguments]  ${USER}
    Robust click    xpath=//div[@id='ewb-popup-menu']//*[starts-with(text(),'${USER}')]

Select Popup Option
    [Arguments]  ${POPUP_OPTION}
    Robust Click    xpath=//div[@class='ewbdialog-container']//button[contains(text(),'${POPUP_OPTION}')]

Select Create Workflow Button
    click button    ${CREATE_WORKFLOW_BUTTON}

Select Record Item for Sign off
    [Arguments]    ${RECORD_ITEM}
    Click Element     document-header-${RECORD_ITEM}-customWidget-selection

Select Sign Selected Button
    Robust Click    ${SIGN_SELECTED_BUTTON}

Select Save As Button
    Robust Click    ${SAVEAS_BUTTON}

Select Edit Button
    [Arguments]    ${item_index}
    wait until page contains element     xpath=//div[@id="document-header-${item_index}-customWidget-editButton"]
    Robust Click    xpath=//div[@id="document-header-${item_index}-customWidget-editButton"]

Confirm Item Published
    [Arguments]    ${item_ref}
    wait until page contains element     xpath=//*[@id="document-header-${item_ref}-publishedImage"]

Permission Denied Confirmation Displayed
    wait until page contains element    xpath=//div[contains(@class,'ewb-message-box-text')][contains(text(),'You do not have the permissions required to be able to create something here')]
    Robust Click    ${ok_button}

Record Edit Permission Denied Confirmation Displayed
    wait until page contains element    xpath=//div[contains(@class,'ewb-message-box-text')][contains(text(),'Unable to open the record as you do not have the necessary edit permissions')]
    Robust Click    ${ok_button}

Sign Off Permission Denied Message Displayed
    wait until page contains element    xpath=//div[contains(@class,'ewb-message-box-text')][contains(text(),'Unable to sign items in the current record, you must have the SIGNOFF_TASK permission granted')]
    Robust Click    ${ok_button}

Select Plus Menu Item
    Robust Click    xpath=//div[@id='image-editor-add']/img

Select Add Text Option
    Robust Click    xpath=//a[contains(text(),'Add Text')]

Select Review and Sign Button
    Robust Click    ${REVIEW_AND_SIGN_BUTTON}

Select Sign Off Record from Menu
    Robust Click    ${SIGN_OFF_RECORD_MENU_ITEM}

Select Publish PDF from Menu
    Robust Click    ${PUBLISH_PDF_MENU_ITEM}

Select Workflow Template from Menu
    [Arguments]    ${WORKFLOW}
    Robust Click    xpath=//*[@id='${WORKFLOW}']/a

Actioner Signed Confirmed
    [Arguments]    ${RECORD_ITEM}
    element should be visible  xpath=//*[@id='document-signatures-${RECORD_ITEM}-panel']

Publishing Dialog Appears
    wait until page contains element    xpath=//div[contains(@class,'ewb-message-box-text')][contains(text(),'The task is configured to publish the record, would you like to publish the record?')]

Enter Workflow Value
    [Arguments]    ${workflow_name}
    Robust Click   ${WORKFLOW_COMBOBOX}
    sleep    1s
    Robust Click   xpath=//div[@class='ewb-workflow-item']/div[contains(text(),'${workflow_name}')]

Enter Workflow Value "Quick Sign Off"
    Robust Click   ${WORKFLOW_COMBOBOX}
    sleep    1s
    Robust Click   ${workflow_selection_item_dont_start}

Check Workflow Active
    [Arguments]    ${WORKFLOW}
    wait until page contains element    xpath=//div[@class='ewb-record-outline-sign-footer-panel']//*[@id='ewb-record-outline-sign-off-task-selected'][contains(text(),'${WORKFLOW}')]

Select Sign All Button
    Robust Click    xpath=//*[@id='ewb-record-outline-sign-off-footer-sign-all']

Confirm Sign All Action complete
    wait until page contains element    xpath=//div[@class='ewb-label ewb-dialog-label ewb-window-header-title'][contains(text(),'Assign Tasks to Colleagues')]

Add Text to Selected Image
    Robust Click    Add Button xpath=//div[@id="image-editor-add"]/img

Assign Task Window Displayed
    wait until page contains element    xpath=//div[contains(@class,'ewb-window-header-title')][contains(text(),'Assign Tasks to Colleagues')]

Select Discard Changes
    Robust Click    ${DISCARD_CHANGES_LINK}

Click Slide In Panel Link
    [Arguments]    ${LINK_ID}
    [Documentation]    Opens the slide in panel, clicks a link, then closes the panel
    Wait Until Keyword Succeeds    30s    5s    Open Slide In Panel
    Robust Click    ${LINK_ID}
    Run Keyword And Ignore Error    Close Slide In Panel

Go To Search Page
    [Documentation]    Clicks the search link in the web client header to load the search view.
    Robust Click    ${search link}
    Wait Until Title Is    IDBS E-WorkBook - Search    30s

Click Navigate Header Link
    Robust Click    ${navigate link}
    Wait Until Title Is    IDBS E-WorkBook - Root    30s

Click E-WorkBook Header Link
    Robust Click    ${ewb_header_link}
    Wait Until Title Is    IDBS E-WorkBook - Root    30s

Open Insert Header Tool Menu
    Wait Until Page Contains Element    ${insert header tool menu}
    Click Element    ${insert header tool menu}    don't wait
    Wait Until Page Contains Element    ${context tool menu}

Click Breadcrumb Link Tile View
    [Arguments]    ${crumb number}    ${link text}
    [Documentation]    Clicks the ${crumb number} entity on the breadcrumb navigator. Checks that the page loaded corresponses to the title attribute associated with the ${crumb number} Root = crumb number 1.
    Robust Click    xpath=//div[@id="ewb-card-layout-crumb-${crumb number}"]/div/a
    Wait Until Title Is    IDBS E-WorkBook - ${link text}    30s

Open Tile Header Tool Menu
    [Arguments]    ${Display Name}
    ${previous_kw}=    Register Keyword To Run On Failure    Nothing
    Wait Until Page Contains Element    xpath=//table[@title="${Display Name}"]
    Capture Page Screenshot
    Robust Click    xpath=//table[@title="${Display Name}"]//div[contains(@id, 'toolButton')]/img
    ${result}=    Run Keyword and Ignore Error    Wait Until Page Contains Element    ${context tool menu}    10s
    Run Keyword If    ${result}!=('PASS', None)    Robust Click    xpath=//table[@title="${Display Name}"]//div[contains(@id, 'toolButton')]/img
    Run Keyword If    ${result}!=('PASS', None)    Wait Until Page Contains Element    ${context tool menu}    10s
    Register Keyword To Run On Failure    ${previous_kw}

Open Content Header Workflows Menu
    Check Record Header Bar Loaded
    ${previous_kw}=    Register Keyword To Run On Failure    Nothing
    Wait Until Page Contains Element    ${content header workflows button}
    Click Element    ${content header workflows button}
    Wait Until Page Contains Element    ${context workflows menu}
    Register Keyword To Run On Failure    ${previous_kw}


Open Content Header Tool Menu
    Wait Until Keyword Succeeds    30s    1s    Check Record Header Bar Loaded
    Wait Until Page Contains Element    application-header-toolButton
    Click Element    application-header-toolButton
    Comment    Click Element    ${content header tool button}
    #check the element has loaded, erratically the menu won't open, so this construct tries to click and open the menu one more time
    ${result}=    Run Keyword and Ignore Error    Wait Until Page Contains Element    ${context tool menu}    10s
    Run Keyword If    ${result}!=('PASS', '')    Robust Click    application-header-toolButton
    Run Keyword If    ${result}!=('PASS', '')    Wait Until Page Contains Element    ${context tool menu}    10s

Click Breadcrumb Link
    [Arguments]    ${crumb number}    ${link text}    ${crumb_type}=record    ${dirty_record}=No
    [Documentation]    Clicks the ${crumb number} entity on the breadcrumb navigator. Checks that the page loaded corresponses to the title attribute associated with the ${crumb number} Root = crumb number 1.
    ...
    ...    *Arguments*
    ...
    ...    - _crumb number_ - the number of the crumb. Root = 1
    ...    - _link text_ - the crumb text
    ...    - _crumb_type=record_ - optional, change to be "card-layout" if the crumb is being clicked on from a tile view rather than a record view
    ...    - _dirty_record=No_ - optional, change to "Yes" if the record is dirty hence the page title will not change (user should be prompted to save)
    ...
    ...    *Preconditon*
    ...
    ...    The crumb must be visible in the browser window
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    | Click Breadcrumb Link | Testing | 2 |
    ...    | Click Breadcrumb Link | Root | 1 | crumb_type=card-layout |
    ${page_title}=    Get Title
    Robust Click    xpath=//div[@id="ewb-${crumb_type}-crumb-${crumb number}"]/div/a
    Run Keyword If    '${dirty_record}'=='No'    Wait Until Title Is    IDBS E-WorkBook - ${link text}    30s
    Run Keyword Unless    '${dirty_record}'=='No'    Wait Until Title Is    ${page_title}    30s

Check Navigator Panel Collapsed
    [Documentation]    Checks that the navigator panel is in an collapsed state.
    Wait Until Page Contains Element    xpath=.//*[@id='ewb-appshell-west' and contains(@class, 'collapsed')]    5s

Collapse Navigator Panel
    [Documentation]    Collapses the navigator panel.
    Robust Click    xpath=.//*[@class='expandcollapse-button right' and contains(@title, 'Hide panel')]
    Wait Until Page Contains Element    xpath=.//*[@class='expandcollapse-button right' and contains(@title, 'Show panel')]    5s

Expand Navigator Panel
    [Documentation]    Expands the navigator panel.
    ${cls}=    IDBSSelenium2Library.Get Element Attribute    xpath=//*[@id='ewb-appshell-west']@class
    ${contains}=    Run Keyword and Ignore Error    Should Contain    ${cls}    collapsed
    Run Keyword If    ${contains}==('PASS', None)    Robust Click    xpath=.//*[@class='expandcollapse-button right' and contains(@title, 'Show panel')]
    Wait Until Page Does Not Contain Element    xpath=.//*[@class='expandcollapse-button right' and contains(@title, 'Show panel')]    5s

Check Navigator Panel Expanded
    [Documentation]    Checks that the navigator panel is in an expanded state.
    Wait Until Page Contains Element    ewb-appshell-west    30s
    Wait Until Page Does Not Contain Element    xpath=.//*[@id='ewb-appshell-west' and contains(@class, 'collapsed')]    10s

Navigation Title Check
    [Arguments]    ${title check}    ${timeout}=30s
    [Documentation]    Waits for the page to load by checking the page title over a 30 second period until the title matches the ${title check} variable.
    Wait Until Title Is    ${title check}    ${timeout}

Tile Should Be Present
    [Arguments]    ${name}
    [Documentation]    Checks that a tile element is displayed using the display name defined by ${name}
    Wait Until Keyword Succeeds    30 sec    1s    Scroll Element Into View    xpath=//table[@title="${name}"]
    Wait Until Element Is Visible    xpath=//table[@title="${name}"]    30 sec

Tile Should Not Be Present
    [Arguments]    ${name}
    [Documentation]    Checks that a tile element is not displayed using the display name defined by ${name}
    Wait Until Page Does Not Contain Element    xpath=//table[@title="${name}"]    30 sec

Click Navigator Link
    [Arguments]    ${name}    ${override lock}=yes    ${reauthentication_required}=no
    [Documentation]    Clicks on a navigator element using the display name defined by ${name}
    ...
    ...    *Arguments*
    ...    - name = the displayed name of the navigator link being clicked on
    ...    - override lock=yes = optional argument to override any lock currently on the entity, by default this is "yes" enter a value of "no" to cancel the override process (the web client will return to the previous page).
    ...    - reauthentication_required=no - optional, set to yes if no active session is expected on clicking the navigator link (prevents page title checks)
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - The navigator link being clicked on must be present in current navigator view
    ...
    ...    *Example*
    ...    | Log In Via Login Dialog | ${VALID USER} | ${VALID PASSWD} |
    ...    | Click Navigator Link | Automated Test Data 1 |
    Run Keyword And Ignore Error    Expand Navigator Panel    #Ensure navigator panel is expanded
    Wait Until Keyword Succeeds    5s    1s    Click Link    xpath=//div[@title="${name}"]/table/tbody/tr/td[2]/div/table/tbody/tr/td[2]/div/a
    ${check status}    ${value} =    Run Keyword And Ignore Error    Wait Until Page Contains Element    xpath=//div[contains(text(), 'You already have a lock on this entity')]    2s
    Run Keyword If    '${check status}'=='PASS'    Override Lock    ${override lock}
    Run Keyword If    '${reauthentication_required}'=='no' and '${override lock}'=='yes'    Navigation Title Check    IDBS E-WorkBook - ${name}

Click Tile
    [Arguments]    ${name}    ${override lock}=yes    ${reauthentication_required}=no    ${timeout}=30
    [Documentation]    Clicks on a tile element using the display name defined by ${name}
    ...
    ...    *Arguments*
    ...    - name = the displayed name of the tile being clicked on
    ...    - override lock=yes = optional argument to override any lock currently on the entity, by default this is "yes" enter a value of "no" to cancel the override process (the web client will return to the previous page).
    ...    - reauthentication_required=no - optional, set to yes if no active session is expected on clicking the tile (prevents page title checks)
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - The tile being clicked on must be present in content view
    ...
    ...    *Example*
    ...    | Log In Via Login Dialog | ${VALID USER} | ${VALID PASSWD} |
    ...    | Click Tile | Automated Test Data 1 |
    Check Entity In Tile View    ${name}
    Robust Click    xpath=//table[contains(@class, 'ewb-entity-item-panel-box-root') and (@title="${name}")]//a    type=link
    ${check status}    ${value} =    Run Keyword And Ignore Error    Wait Until Page Contains Element    xpath=//div[contains(text(), 'You already have a lock on this entity')]    2s
    Run Keyword If    '${check status}'=='PASS'    Override Lock    ${override lock}
    Run Keyword If    '${reauthentication_required}'=='no' and '${override lock}'=='yes'    Wait Until Title Is    IDBS E-WorkBook - ${name}    ${timeout}
    Capture Page Screenshot

Open Slide In Panel
    [Documentation]    Opens the right hand slide in panel which contains various links
    #Check for the visibility of the slide in panel and only open if not already visible
    ${status}    ${value}=    Run Keyword And Ignore Error    Element Should Not Be Visible    ${slide in panel}
    Run Keyword If    '${status}'=='PASS'    Robust Click    ${show-slide-in-panel}
    Run Keyword If    '${status}'=='PASS'    Sleep    2s    #Slide in animation is 800ms so allow panel time to fully expand
    Wait Until Element Is Visible    ${slide in panel}    10s

Close Slide In Panel
    [Documentation]    Closes the right hand slide in panel which contains various links
    Wait Until Element Is Visible    hide-nav-panel-button    3s
    Robust Click    xpath=(//div[contains(@class, 'ewb-panel-header-label')])[2]    #click one of the panel headers rather than the close link, more reliable on IE

Check Text Item for Text
    [Arguments]     ${text}
    select frame     gwt-Frame
    page should contain  ${text}