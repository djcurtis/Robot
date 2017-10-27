*** Settings ***
Documentation     Resource file containing keywords specific to sign off in the E-WorkBook web client.
Library           IDBSSelenium2Library
Resource          general_resource.robot
Resource          record_resource.robot
Resource          workflow_resource.robot

*** Variables ***
${sign-off-record-command}    ewb-record-sign-off-command

*** Keywords ***
Select Document To Sign
    [Arguments]    ${document_number}
    [Documentation]    *Selects a document to sign*
    ...
    ...    *Arguments*
    ...    - _document_number_ - the number of the document to select (first document = 0)
    ...
    ...    *Return Value*
    ...
    ...    None
    Robust Click    document-header-${document_number}-customWidget-selection

Click Sign All Button
    [Documentation]    *Clicks the "Sign All" button in the sign off view*
    ...
    ...    *Arguments*
    ...
    ...    None
    ...
    ...    *Return Value*
    ...
    ...    None
    Wait Until Element Is Visible    xpath=//div[@class='ewb-record-outline-sign-header-panel']    30s
    Scroll Element Into View    ewb-record-outline-sign-off-footer-sign-all
    Simulate    ewb-record-outline-sign-off-footer-sign-all    click
    Run Keyword If    '${BROWSER}'=='IE'    Robust Click    ewb-record-outline-sign-off-footer-sign-all    # Clicks again as first is not registered

Click Sign Selected Button
    [Documentation]    *Clicks the "Sign Selected" button in the sign off view*
    ...
    ...    *Arguments*
    ...
    ...    None
    ...
    ...    *Return Value*
    ...
    ...    None
    Wait Until Page Contains Element    xpath=//button[@id='ewb-record-outline-sign-off-footer-sign-selected']    30s
    Scroll Element Into View    ewb-record-outline-sign-off-footer-sign-selected
    Simulate    ewb-record-outline-sign-off-footer-sign-selected    click
    Run Keyword If    '${BROWSER}'=='IE'    Robust Click    ewb-record-outline-sign-off-footer-sign-selected    # Clicks again as first is not registered

Check Document Signed
    [Arguments]    ${document_number}    ${signer}    ${reason}=IGNORE    ${role}=IGNORE
    [Documentation]    *Checks that a document is signed by checking the signoff details*
    ...
    ...    *Arguments*
    ...    - _document_number_ - the number of the document to check (first document =0)
    ...    - _signer_ - the user who signed the record (can be either the username or full name)
    ...    - _reason_ - the sign off reason
    ...    - _role_ - the sign off role
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...    | Check Document Signed | 0 | Administrator | Experiment Completed | Actioner |
    Wait Until Page Contains Element    xpath=//table[@id="document-signatures-${document_number}-panel"]//div[text()="Digitally Signed By: "]/../../td[2]/div[text()[contains(., '${signer}')]]    30s
    Run Keyword Unless    '${reason}'=='IGNORE'    Wait Until Page Contains Element    xpath=//table[@id="document-signatures-${document_number}-panel"]//div[text()="Reason: "]/../../td[2]/div[text()="${reason}"]    30s
    Run Keyword Unless    '${role}'=='IGNORE'    Wait Until Page Contains Element    xpath=//table[@id="document-signatures-${document_number}-panel"]//div[text()="Role:"]/../../td[2]/div[text()="${role}"]    30s

Check Document Not Signed
    [Arguments]    ${document_number}
    [Documentation]    *Checks that a document has not been signed*
    ...
    ...    *Arguments*
    ...    - _document_number_ - the number of the document to check (first document =0)
    ...
    ...    *Return Value*
    ...
    ...    None
    Wait Until Page Does Not Contain Element    xpath=//table[@id="document-signatures-${document_number}-panel"]/tbody/tr    30s

Start Sign off
    [Arguments]    ${wait_for_render}=True    # If true, the keyword waits until the view has been rendered and fails if this does not happen
    [Documentation]    *Starts the sign off process for a record by opening the sign off view*
    ...
    ...    *Arguments*
    ...
    ...    None
    ...
    ...    *Return Value*
    ...
    ...    None
    Check Record Header Bar Loaded
    Robust Click    ${content header workflows button}
    ${result}=    Run Keyword and Ignore Error    Robust Click    ewb-record-sign-off-command
    Select No Workflow Option
    Run Keyword If    ${result}!=('PASS', None)    Robust Click    ${content header workflows button}
    Run Keyword If    ${result}!=('PASS', None)    Robust Click    ewb-record-sign-off-command
    Run Keyword If    ${wait_for_render}    Wait Until Page Contains Element    xpath=//div[contains(@class,'ewb-record-outline-sign-footer-panel')]    # (Hopefully) wait for the signoff page to be fully rendered before proceding
    Run Keyword If    ${wait_for_render}    Wait Until Page Contains Element    xpath=//img[contains(@class,'ewb-document-header-selection-widget-unselected')]    # Double check, look for the signoff button on a document

Cancel Sign Off
    [Documentation]    *Cancels the sign off process*
    ...
    ...    *Arguments*
    ...
    ...    None
    ...
    ...    *Return Value*
    ...
    ...    None
    Robust Click    ewb-record-action-bar-cancel

Sign All
    [Arguments]    ${user-name}=${VALID USER}    ${password}=${VALID PASSWD}
    [Documentation]    *Signs all items in the experiment*
    ...
    ...    *Arguments*
    ...
    ...    ${user-name} the user (defaults to ${VALID USER}
    ...    ${pasword} the password (defaults to ${VALID PASSWD}
    ...
    ...    *Return Value*
    ...
    ...    None
    Click Sign All Button
    Select User Action Note    Experiment Completed
    Authenticate Session    ${user-name}    ${password}
    Wait For No Mask

Sign All And Wait For Success
    [Arguments]    ${user-name}=${VALID USER}    ${password}=${VALID PASSWD}
    [Documentation]    *Signs all items in the experiment and waits for the signoff to finish*
    ...
    ...    *Arguments*
    ...
    ...    ${user-name} the user (defaults to ${VALID USER}
    ...    ${pasword} the password (defaults to ${VALID PASSWD}
    ...
    ...    *Return Value*
    ...
    ...    None
    Sign All    ${user-name}    ${password}
    Confirm Record Can Be Edited    # Wait until the record can be edited again, at this point we know that the signoff has finished

Sign Document
    [Arguments]    ${document index}
    [Documentation]    *Sign the document at the specified index (assuming the sign off view is open)*
    ...
    ...    *Arguments*
    ...    - _document_index_ - the index of the document to sign. First document = 0
    ...
    ...    *Return Value*
    ...
    ...    None
    Wait Until Element Is Visible    xpath=//div[@class='ewb-record-outline-sign-header-panel']    30s
    ${document selection widget}    Set Variable    document-header-${document index}-customWidget-selection
    Robust Click    ${document selection widget}
    Click Sign Selected Button
    Select User Action Note    Experiment Completed
    Authenticate Session    ${VALID USER}    ${VALID PASSWD}

Select Task To Associate With Sign Off
    [Documentation]    *Clicks to associate the task with the sign off (only first task)*
    ...
    ...    *Arguments*
    ...
    ...    None
    ...
    ...    *Return Value*
    ...
    ...    None
    Robust Click    ${SELECT_TO_COMPLETE_TASK_LINK_ID}
    Robust Click    xpath=//div[@class='ewb-record-outline-task-summary-widget']//button

Confirm Sign Off View Present
    [Documentation]    *Confirms that the sign off view is currently displayed in the active browser*
    ...
    ...    *Arguments*
    ...
    ...    None
    ...
    ...    *Return Value*
    ...
    ...    None
    Wait Until Element Is Visible    xpath=//div[@class='ewb-record-outline-sign-header-panel']    30s

Set Sign As Value
    [Arguments]    ${value}
    [Documentation]    This keyword sets the Sign As value to ${value} during a sign off.
    ...
    ...    *${value}* = the value to be entered into the field, should match one of the values in the Sign Off Roles catalog of EWB. Default values fo rthis field are Actioner and Reviewer.
    Wait Until Keyword Succeeds    30s    0.2s    Robust Click    xpath=//div[contains(@id,'ewb-record-outline-sign-off-role')]/div/div/img
    Wait Until Keyword Succeeds    30s    0.2s    Robust Click    xpath=//td[contains(@class,'list-item')]/div[text()="${value}"]

Set Sign Off Workflow
    [Arguments]    ${workflow_text}
    [Documentation]    Select a workflow from the workflow combobox when signing a record.
    ...
    ...    *Arguments*
    ...
    ...    _workflow_text_ - the name (or partial name) of the workflow to select
    ...
    ...    *Return Value*
    ...
    ...    None
    Robust Click    xpath=//*[@id="ewb-record-outline-sign-off-workflow"]/*[contains(@class, 'idbs-gwt-combobox')]//img
    Robust Click    xpath=//*[contains(@class, 'idbs-gwt-combobox-items')]//*[contains(text(), '${workflow_text}')]

Select No Workflow and Sign All
    [Arguments]    ${user-name}=${VALID USER}    ${password}=${VALID PASSWD}
    Select No Workflow Option
    Click Sign All Button
    Select User Action Note    Experiment Completed
    Authenticate Session    ${user-name}    ${password}
    Wait For No Mask

Select No Workflow Sign All and Wait For Success
    [Arguments]    ${user-name}=${VALID USER}    ${password}=${VALID PASSWD}
    Select No Workflow and Sign All    ${user-name}    ${password}
    Confirm Record Can Be Edited    # Wait until the record can be edited again, at this point we know that the signoff has finished

Start Quick Record Sign Off
    [Documentation]    Start Quick sign off from the record menu.
    Open Content Header Workflows Menu
    Robust Click    ${sign-off-record-command}
    Wait Until Page Contains Element    ${sign-record-workflow}
