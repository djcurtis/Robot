*** Settings ***
Documentation     A resource file containing IDBS defined keywords used for testing the IDBS E-WorkBook Web Client application. This resource file contains keywords applicable to the hierarchy functionality.
...               This file covers the attribute editors within the properties panel.
...               This file is loaded by the common_resource.txt file which is automatically loaded when running tests through the Robot Framework.
...               *Version: E-WorkBook Web Client 9.2.0*
Library           IDBSSelenium2Library
Library           String
Resource          general_resource.robot

*** Variables ***
${attribute list id}    ${EMPTY}

*** Keywords ***
Toggle Attribute Sections
    [Arguments]    ${editor_id}
    [Documentation]    Toggles the Mandatory and Optional attribute sections if the editor specified is hidden
    ...
    ...    *Arguments*
    ...
    ...    _editor_id_ - The ID of the attribute to be interacted with
    ...
    ...    *Precondition*
    ...
    ...    The create/edit entity properties dialog must be open
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example
    ...    | Toggle Attribute Sections | ewb-attribute-editor-keyword |
    ${status}    ${value}=    Run Keyword And Ignore Error    Element Should Be Visible    ${editor_id}
    Run Keyword If    '${status}'=='FAIL'    Run Keyword And Ignore Error    Expand Mandatory Section
    ${status}    ${value}=    Run Keyword And Ignore Error    Element Should Be Visible    ${editor_id}
    Run Keyword If    '${status}'=='FAIL'    Run Keyword And Ignore Error    Expand Optional Section

Check Boolean Attribute Value
    [Arguments]    ${attribute name}    ${attribute value}
    [Documentation]    Checks the boolean attribute given by ${attribute name} is set to 'true' or 'false' based on the ${attribute value} specified
    ...
    ...    *Arguments*
    ...    Attribute Name = The name of the attribute being checked
    ...    Attribute Value = Either "true" (checked) or "false" (unchecked)
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    Open Edit Properties Dialog | My Experiment | TILE
    ...    Check Boolean Attribute Value | Confined | false
    Run Keyword If    '${attribute value}'=='true'    Checkbox Should Be Selected    xpath=//*[@id="ewb-attribute-editor-${attribute name}"]/input
    Run Keyword If    '${attribute value}'=='false'    Checkbox Should Not Be Selected    xpath=//*[@id="ewb-attribute-editor-${attribute name}"]/input

Check Text Attribute Value
    [Arguments]    ${attribute name}    ${attribute value}
    [Documentation]    Checks the text attribute given by ${attribute name} is set to ${attribute value}
    ...
    ...    *Arguments*
    ...    Attribute Name = The name of the attribute being checked
    ...    Attribute Value = The expected attribute value
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    Open Edit Properties Dialog | My Experiment | TILE
    ...    Check Text Attribute Value | myTextAttribute | Something
    Textfield Should Contain    ewb-attribute-editor-${attribute name}    ${attribute value}

Check Date Attribute Value
    [Arguments]    ${attribute name}    ${attribute value}
    [Documentation]    Checks the value of a date attribute given by the ${attribute name} is set to the value given by ${attribute value}.
    ...
    ...    *Arguments*
    ...    Attribute Name = The name of the attribute being checked
    ...    Attribute Value = The expected value of the attribute
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    Open Edit Properties Dialog | My Experiment | TILE
    ...    Check Date Attribute Value | myDateAttribute | 12-Nov-2011
    Textfield Should Contain    ewb-attribute-editor-${attribute name}-textbox    ${attribute value}

Check List Attribute Value
    [Arguments]    ${attribute name}    ${attribute value}
    [Documentation]    Checks the value of a list attribute given by the ${attribute name} is set to ${attribute value}.
    ...
    ...    *Arguments*
    ...    Attribute Name = The name of the attribute being checked
    ...    Attribute Value = The expected value selected within the list (combo) box
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    Open Edit Properties Dialog | My Experiment | TILE
    ...    Check List Attribute Value | myListAttribute | Started
    Confirm Combobox Value    ewb-attribute-editor-${attribute name}    ${attribute value}

Set Boolean Attribute
    [Arguments]    ${attribute name}    ${attribute value}
    [Documentation]    Sets the boolean attribute given by ${attribute name} to 'true' or 'false' based on the ${attribute value} specified
    ...    Valid values of ${attribute value} are "true" and "false" only.
    Toggle Attribute Sections    xpath=//*[@id="ewb-attribute-editor-${attribute name}"]/input
    Run Keyword If    '${attribute value}'=='true'    Select Checkbox    xpath=//*[@id="ewb-attribute-editor-${attribute name}"]/input
    Run Keyword If    '${attribute value}'=='false'    Unselect Checkbox    xpath=//*[@id="ewb-attribute-editor-${attribute name}"]/input
    Run Keyword If    '${attribute value}'=='true'    Checkbox Should Be Selected    xpath=//*[@id="ewb-attribute-editor-${attribute name}"]/input
    Run Keyword If    '${attribute value}'=='false'    Checkbox Should Not Be Selected    xpath=//*[@id="ewb-attribute-editor-${attribute name}"]/input

Set Text Attribute
    [Arguments]    ${attribute name}    ${attribute value}
    [Documentation]    Sets the text attribute given by ${attribute name} to the value given by ${attribute value}
    Toggle Attribute Sections    ewb-attribute-editor-${attribute name}
    Input Text    ewb-attribute-editor-${attribute name}    ${attribute value}
    Textfield Value Should Be    ewb-attribute-editor-${attribute name}    ${attribute value}
    Comment    Call Selenium Api    fireEvent    ewb-attribute-editor-${attribute name}    blur

Set Date Attribute Text Entry
    [Arguments]    ${attribute name}    ${attribute value}
    [Documentation]    Sets the value of a date attribute given by the ${attribute name} to the value given by ${attribute value}. The attribute value must be set to the correct format for the attribute else the keyword will.
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears within the web client ID's
    ...    - attribute value = the attribute value to be entered
    ...
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Open Edit Properties Dialog | My Experiment | TILE |
    ...    | Set Date Attribute Text Entry | dateAttribute | 09-12-11 |
    Toggle Attribute Sections    ewb-attribute-editor-${attribute name}-textbox
    Input Text    ewb-attribute-editor-${attribute name}-textbox    ${attribute value}
    Simulate    ewb-attribute-editor-${attribute name}-textbox    blur
    Wait Until Page Does Not Contain Element    xpath=//*[contains(@class, 'ewb-editor-invalid')]    30s
    Textfield Should Contain    ewb-attribute-editor-${attribute name}-textbox    ${attribute value}

Set Date Attribute From Calender
    [Arguments]    ${attribute name}    ${date value}
    [Documentation]    Sets the value of a date attribute given by the ${attribute name} to the value given by ${attribute value}, using the calender picker
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears within the web client ID's
    ...    - date value = the attribute value to be entered. Currently Supported value = TODAY
    ...
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Open Edit Properties Dialog | My Experiment | TILE |
    ...    | Set Date Attribute From Calender | dateAttribute | TODAY |
    Toggle Attribute Sections    ewb-attribute-editor-${attribute name}-button
    Page Should Not Contain Element    datePicker
    Robust Click    ewb-attribute-editor-${attribute name}-button
    Page Should Contain Element    datePicker
    ${selected date value}=    Run Keyword If    '${date value}'=='TODAY'    Get Text    xpath=//td/div[contains(@class, 'datePickerDayIsToday')]
    Run Keyword If    '${date value}'=='TODAY'    Robust Click    xpath=//td/div[contains(@class, 'datePickerDayIsToday')]
    Wait Until Keyword Succeeds    60s    5s    Textfield Should Contain    ewb-attribute-editor-${attribute name}-textbox    ${selected date value}

Set Date Attribute Invalid Text Entry
    [Arguments]    ${attribute name}    ${attribute value}    ${expected error message}
    [Documentation]    Sets the value of a date attribute given by the ${attribute name} to the value given by ${attribute value} and checks that the value is marked as being invalid.
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears within the web client ID's
    ...    - attribute value = the attribute value to be entered
    ...    - expected error message = the error message provided on the error icon tooltip
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Open Edit Properties Dialog | My Experiment | TILE |
    ...    | Set Date Attribute Invalid Text Entry | dateAttribute | invalid | The property value is invalid. Invalid Format |
    Toggle Attribute Sections    ewb-attribute-editor-${attribute name}-textbox
    Input Text    ewb-attribute-editor-${attribute name}-textbox    ${attribute value}
    Comment    Move focus away from input field to trigger field validation
    Focus    save-properties
    Wait Until Page Contains Element    ewb-attribute-editor-${attribute name}-validation-failed-image    60s    No Invalid Value Flag Found
    ${displayed error message}=    IDBSSelenium2Library.Get Element Attribute    ewb-attribute-editor-${attribute name}-validation-failed-image@title
    Should Be Equal    ${expected error message}    ${displayed error message}
    Textfield Should Contain    ewb-attribute-editor-${attribute name}-textbox    ${attribute value}

Set List Attribute
    [Arguments]    ${attribute name}    ${attribute value}
    [Documentation]    Sets the value of a list attribute given by the ${attribute name} with the ${attribute value} using the dropdown menu
    ...
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears within the web client ID's
    ...    - attribute value = the attribute value to be entered, if set to "EMPTY" the field will be left blank or cleared of any previous value.
    ...
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Open Edit Properties Dialog | My Experiment | TILE |
    ...    | Set List Attribute | listAttribute | new value |
    ...    | Set List Attribute | listAttribute | EMPTY |
    Toggle Attribute Sections    xpath=//*[@id="ewb-attribute-editor-${attribute name}"]
    Select And Confirm Combobox Value    ewb-attribute-editor-${attribute name}    ${attribute value}

Set List Attribute Text Entry
    [Arguments]    ${attribute name}    ${attribute value}    ${max iterations}=5
    [Documentation]    Sets the value of a list attribute given by the ${attribute name} with the ${attribute value} using text entry.
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears within the web client ID's
    ...    - attribute value = the attribute value to be entered
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Open Edit Properties Dialog | My Experiment | TILE |
    ...    | Set List Attribute Text Entry | listAttribute | new value |
    Toggle Attribute Sections    ewb-attribute-editor-${attribute name}-input
    Enter And Confirm Combobox Value    ewb-attribute-editor-${attribute name}    ${attribute value}

Set Entity Link Attribute
    [Arguments]    ${attribute name}    ${Navigator Level 1}    ${Navigator Level 2}=none    ${Navigator Level 3}=none    ${Navigator Level 4}=none    ${Navigator Level 5}=none
    ...    ${Navigator Level 6}=none    ${Navigator Level 7}=none    ${Navigator Level 8}=none    ${Navigator Level 9}=none    ${Navigator Level 10}=none
    [Documentation]    Sets the value of a entity link/versioned entity link attribute given by the ${attribute name} with the path specified by the ${Navigator Level X} arguments
    ...
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears within the web client ID's
    ...    - Navigator Level 1 = The root level element (should almost always be "Root")
    ...    - Navigator Level 2=none = The second level element (e.g. a group on a default hiearchy) (Optional)
    ...    - Navigator Level 3=none = The third level element (Optional)
    ...    - Navigator Level 4=none = The fourth level element (Optional)
    ...    - Navigator Level 5=none = The fifth level element (Optional)
    ...    - Navigator Level 6=none = The sixth level element (Optional)
    ...    - Navigator Level 7=none = The seventh level element (Optional)
    ...    - Navigator Level 8=none = The eighth level element (Optional)
    ...    - Navigator Level 9=none = The ninth level element (Optional)
    ...    - Navigator Level 10=none = The tenth level element (Optional)
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Open Edit Properties Dialog | My Experiment | TILE |
    ...    | Set Entity Link Attribute | entityLink | Root | Testing | Steve | My Experiment |
    Toggle Attribute Sections    ewb-attribute-editor-entityLink-${attribute name}-navButton
    Robust Click    ewb-attribute-editor-entityLink-${attribute name}-navButton
    Dialog Should Be Present    Select an Item
    Expand Navigator Node    ${Navigator Level 1}
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
    Wait Until Element Is Enabled    xpath=//div[text()="Select an Item"]/ancestor::div[@class="ewbdialog-container"]//button[@id="okButton"]    15s
    Wait Until Keyword Succeeds    15s    2s    Robust Click    xpath=//div[text()="Select an Item"]/ancestor::div[@class="ewbdialog-container"]//button[@id="okButton"]

Set Entity Link List Attribute
    [Arguments]    ${attribute name}    ${entity link path}    ${Navigator Level 1}    ${Navigator Level 2}=none    ${Navigator Level 3}=none    ${Navigator Level 4}=none
    ...    ${Navigator Level 5}=none    ${Navigator Level 6}=none    ${Navigator Level 7}=none    ${Navigator Level 8}=none    ${Navigator Level 9}=none    ${Navigator Level 10}=none
    [Documentation]    Sets the value of a entity link/versioned entity link list attribute given by the ${attribute name} with the path specified by the ${Navigator Level X} arguments
    ...
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears within the web client ID's
    ...    - entity link path = the path as expected to be displayed for the entity link
    ...    - Navigator Level 1 = The root level element (should almost always be "Root")
    ...    - Navigator Level 2=none = The second level element (e.g. a group on a default hiearchy) (Optional)
    ...    - Navigator Level 3=none = The third level element (Optional)
    ...    - Navigator Level 4=none = The fourth level element (Optional)
    ...    - Navigator Level 5=none = The fifth level element (Optional)
    ...    - Navigator Level 6=none = The sixth level element (Optional)
    ...    - Navigator Level 7=none = The seventh level element (Optional)
    ...    - Navigator Level 8=none = The eighth level element (Optional)
    ...    - Navigator Level 9=none = The ninth level element (Optional)
    ...    - Navigator Level 10=none = The tenth level element (Optional)
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Open Edit Properties Dialog | My Experiment | TILE |
    ...    | Set Entity Link List Attribute | entityLink | /Root/Testing/Steve/My Experiment | Root | Testing | Steve | My Experiment |
    Toggle Attribute Sections    ewb-attribute-editor-entityLink-${attribute name}-navButton
    Set Entity Link Attribute    ${attribute name}    ${Navigator Level 1}    ${Navigator Level 2}    ${Navigator Level 3}    ${Navigator Level 4}    ${Navigator Level 5}
    ...    ${Navigator Level 6}    ${Navigator Level 7}    ${Navigator Level 8}    ${Navigator Level 9}    ${Navigator Level 10}
    Check Entity Link Attribute Value    ${attribute name}    ${entity link path}
    Robust Click    ewb-attribute-editor-listBox-${attribute name}-addButton
    Check Entity Link Attribute Value    ${attribute name}    ${EMPTY}
    Page Should Contain Element    xpath=//div[@id="ewb-attribute-editor-listBox-${attribute name}"]//div[text()="${entity link path}"]

Set Versioned Entity Link List Attribute
    [Arguments]    ${attribute name}    ${entity link path}    ${version number}    ${Navigator Level 1}    ${Navigator Level 2}=none    ${Navigator Level 3}=none
    ...    ${Navigator Level 4}=none    ${Navigator Level 5}=none    ${Navigator Level 6}=none    ${Navigator Level 7}=none    ${Navigator Level 8}=none    ${Navigator Level 9}=none
    ...    ${Navigator Level 10}=none
    [Documentation]    Sets the value of a versioned entity link list attribute given by the ${attribute name} with the path specified by the ${Navigator Level X} arguments
    ...
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears within the web client ID's
    ...    - entity link path = the path as expected to be displayed for the entity link
    ...    - version number = version number of the link e.g. v1
    ...    - Navigator Level 1 = The root level element (should almost always be "Root")
    ...    - Navigator Level 2=none = The second level element (e.g. a group on a default hiearchy) (Optional)
    ...    - Navigator Level 3=none = The third level element (Optional)
    ...    - Navigator Level 4=none = The fourth level element (Optional)
    ...    - Navigator Level 5=none = The fifth level element (Optional)
    ...    - Navigator Level 6=none = The sixth level element (Optional)
    ...    - Navigator Level 7=none = The seventh level element (Optional)
    ...    - Navigator Level 8=none = The eighth level element (Optional)
    ...    - Navigator Level 9=none = The ninth level element (Optional)
    ...    - Navigator Level 10=none = The tenth level element (Optional)
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Open Edit Properties Dialog | My Experiment | TILE |
    ...    | Set Versioned Entity Link List Attribute | versionedEntityLink | /Root/Testing/Steve/My Experiment | v1 | Root | Testing | Steve | My Experiment |
    Toggle Attribute Sections    ewb-attribute-editor-entityLink-${attribute name}-navButton
    Set Entity Link Attribute    ${attribute name}    ${Navigator Level 1}    ${Navigator Level 2}    ${Navigator Level 3}    ${Navigator Level 4}    ${Navigator Level 5}
    ...    ${Navigator Level 6}    ${Navigator Level 7}    ${Navigator Level 8}    ${Navigator Level 9}    ${Navigator Level 10}
    Check Entity Link Attribute Value    ${attribute name}    ${entity link path} (${version number})
    Robust Click    ewb-attribute-editor-listBox-${attribute name}-addButton
    Wait Until Keyword Succeeds    10s    1s    Check Entity Link Attribute Value    ${attribute name}    ${EMPTY}
    Page Should Contain Element    xpath=//div[@id="ewb-attribute-editor-listBox-${attribute name}"]/div/div/div[text()="${entity link path} (${version number})"]

Clear Entity Link Attribute
    [Arguments]    ${attribute name}
    [Documentation]    Clears the value of a entity link/versioned entity link attribute given by the ${attribute name}
    ...
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears within the web client ID's
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Open Edit Properties Dialog | My Experiment | TILE |
    ...    | Set Entity Link Attribute | entityLink | Root | Testing | Steve | My Experiment |
    ...    | Clear Entity Link Attribute | entityLink |
    Toggle Attribute Sections    ewb-attribute-editor-entityLink-${attribute name}-clearButton
    Robust Click    ewb-attribute-editor-entityLink-${attribute name}-clearButton
    Check Entity Link Attribute Value    ${attribute name}    ${EMPTY}

Check Entity Link Attribute Value
    [Arguments]    ${attribute name}    ${entity link path}
    [Documentation]    Checks the value of a entity link/versioned entity link attribute given by the ${attribute name} with the path specified by the ${entity link path} argument
    ...
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears within the web client ID's
    ...    - entity link path = the path as expected to be displayed for the entity link
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Open Edit Properties Dialog | My Experiment | TILE |
    ...    | Set Entity Link Attribute | entityLink | Root | Testing | Steve | My Experiment |
    ...    | Check Entity Link Attribute Value | entityLink | /Root/Testing/Steve/My Experiment |
    Wait Until Element Text Is    xpath=//img[@id="ewb-attribute-editor-entityLink-${attribute name}-navButton"]/../../td[contains(@class, 'ewb-textbox')]/div    ${entity link path}    60s

Set User Attribute
    [Arguments]    ${attribute name}    ${user}
    [Documentation]    Sets the value of a user type attribute
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears within the web client ID's
    ...    - user = the user name to be added
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    Open Edit Properties Dialog | My Experiment | TILE
    ...    Set User Attribute | User | Administrator
    Toggle Attribute Sections    ewb-attribute-editor-${attribute name}-input
    Input Text    ewb-attribute-editor-${attribute name}-input    ${attribute value}
    Textfield Should Contain    ewb-attribute-editor-${attribute name}-input    ${attribute value}
    Call Selenium Api    fireEvent    ewb-attribute-editor-${attribute name}-input    blur

Add To List Attribute Text Entry
    [Arguments]    ${attribute name}    ${attribute value}
    [Documentation]    Sets the value of a list attribute given by the ${attribute name} with the ${attribute value} using text entry.
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears within the web client ID's
    ...    - attribute value = the attribute value to be entered
    ...
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Open Edit Properties Dialog | My Experiment | TILE |
    ...    | Add To List Attribute Text Entry | listAttribute| new value |
    Toggle Attribute Sections    ewb-attribute-editor-${attribute name}
    Input Text    ewb-attribute-editor-${attribute name}    ${attribute value}
    Textfield Should Contain    ewb-attribute-editor-${attribute name}    ${attribute value}
    Simulate    ewb-attribute-editor-${attribute name}    blur
    Robust Click    ewb-attribute-editor-listBox-${attribute name}-addButton
    Wait Until Keyword Succeeds    30s    5s    Textfield Should Contain    ewb-attribute-editor-${attribute name}    ${EMPTY}
    Wait Until Page Contains Element    xpath=//div[@id="ewb-attribute-editor-listBox-${attribute name}"]/div/div/div[text()="${attribute value}"]

Add To List Attribute Text Entry With Dropdown
    [Arguments]    ${attribute name}    ${attribute value}
    [Documentation]    Sets the value of a list attribute given by the ${attribute name} with the ${attribute value} using text entry for list attributes with dropdown menus (e.g. Dictionary Flexible/Fixed Attributes).
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears within the web client ID's
    ...    - attribute value = the attribute value to be entered
    ...
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Open Edit Properties Dialog | My Experiment | TILE |
    ...    | Add To List Attribute Text Entry With Dropdown | listAttribute| new value |
    Toggle Attribute Sections    ewb-attribute-editor-${attribute name}-input
    Enter And Confirm Combobox Value    ewb-attribute-editor-${attribute name}    ${attribute value}
    Robust Click    ewb-attribute-editor-listBox-${attribute name}-addButton
    Wait Until Keyword Succeeds    30s    5s    Textfield Should Contain    ewb-attribute-editor-${attribute name}-input    ${EMPTY}
    Wait Until Page Contains Element    xpath=//div[@id="ewb-attribute-editor-listBox-${attribute name}"]/div/div/div[text()="${attribute value}"]    30s

Add To List Attribute From Dropdown
    [Arguments]    ${attribute name}    ${attribute value}
    [Documentation]    Sets the value of a list attribute given by the ${attribute name} with the ${attribute value} using the dropdown menu.
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears within the web client ID's
    ...    - attribute value = the attribute value to be entered
    ...
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Open Edit Properties Dialog | My Experiment | TILE |
    ...    | Add To List Attribute From Dropdown | listAttribute| new value |
    Toggle Attribute Sections    xpath=//*[@id="ewb-attribute-editor-${attribute name}"]
    Select And Confirm Combobox Value    ewb-attribute-editor-${attribute name}    ${attribute value}
    Robust Click    ewb-attribute-editor-listBox-${attribute name}-addButton
    Wait Until Keyword Succeeds    30s    5s    Textfield Should Contain    ewb-attribute-editor-${attribute name}-input    ${EMPTY}
    Wait Until Page Contains Element    xpath=//div[@id="ewb-attribute-editor-listBox-${attribute name}"]/div/div/div[text()="${attribute value}"]    30s

Remove From List Attribute
    [Arguments]    ${attribute name}    ${attribute value}
    Toggle Attribute Sections    xpath=//div[@id="ewb-attribute-editor-listBox-${attribute name}"]/div/div/div[text()="${attribute value}"]
    Robust Click    xpath=//div[@id="ewb-attribute-editor-listBox-${attribute name}"]/div/div/div[text()="${attribute value}"]
    Robust Click    ewb-attribute-editor-listBox-${attribute name}-deleteButton
    Page Should Not Contain Element    xpath=//div[@id="ewb-attribute-editor-listBox-${attribute name}"]/div/div/div[text()="${attribute value}"]

Move Attribute In List Attribute
    [Arguments]    ${attribute name}    ${attribute value}    ${direction}
    [Documentation]    Moves the attribute value in a list attribute either up or downand checks its new position
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears within the web client ID's
    ...    - attribute value = the attribute value to be moved
    ...    - direction = the direction to move the entity, either "Up" or "Down"
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    Open Edit Properties Dialog | My Experiment | TILE
    ...    Move Attribute In List Attribute | StringList | Value1 | Down
    ...    Move Attribute In List Attribute | StringList | Value1 | Up
    Toggle Attribute Sections    xpath=//div[@id="ewb-attribute-editor-listBox-${attribute name}"]/div/div/div[text()="${attribute value}"]
    : FOR    ${index}    IN RANGE    1    10
    \    ${check status}=    Run Keyword And Return Status    Element Text Should Be    xpath=//div[@id="ewb-attribute-editor-listBox-${attribute name}"]/div/div[${index}]/div    ${attribute value}
    \    Run Keyword If    ${check status}    Set Suite Variable    ${attribute list id}    ${index}
    \    Run Keyword If    ${check status}    Exit For Loop
    Element Text Should Be    xpath=//div[@id="ewb-attribute-editor-listBox-${attribute name}"]/div/div[${attribute list id}]/div    ${attribute value}
    ${offset}=    Set Variable If    '${direction}'=='Up'    -1    '${direction}'=='Down'    +1
    ${attribute list id}=    Evaluate    ${attribute list id}${offset}
    Robust Click    xpath=//div[@id="ewb-attribute-editor-listBox-${attribute name}"]/div/div/div[text()="${attribute value}"]
    Robust Click    ewb-attribute-editor-listBox-${attribute name}-move${direction}Button
    Wait Until Page Contains Element    xpath=//div[@id="ewb-attribute-editor-listBox-${attribute name}"]/div/div/div[text()="${attribute value}"]
    Element Text Should Be    xpath=//div[@id="ewb-attribute-editor-listBox-${attribute name}"]/div/div[${attribute list id}]/div    ${attribute value}

Check Attribute In Correct Properties Section
    [Arguments]    ${properties section}    ${attribute name}
    [Documentation]    Checks that the specified attribute is in the correct location within the properties dialog
    ...
    ...    *Arguments*
    ...    - properties section = the section of the properties panel. Either MANDATORY, OPTIONAL or READONLY
    ...    - attribute name = the name of the attribute as it appears within the web client ID's
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Open Edit Properties Dialog | My Experiment | TILE |
    ...    | Check Attribute In Correct Properties Section | MANDATORY | title |
    Run Keyword If    '${properties section}'=='MANDATORY'    Page Should Contain Element    xpath=//*[@id="propertiesHeader_Mandatory"]/../../../descendant::div[text()="${attribute name}"]
    Run Keyword If    '${properties section}'=='OPTIONAL'    Page Should Contain Element    xpath=//*[@id="propertiesHeader_Optional"]/../../../descendant::div[text()="${attribute name}"]
    Run Keyword If    '${properties section}'=='READONLY'    Page Should Contain Element    xpath=//*[@id="propertiesHeader_Read Only"]/../../../descendant::div[text()="${attribute name}"]

Check Attribute Editor Disabled
    [Arguments]    ${editor type}    ${attribute name}
    [Documentation]    Checks that the attribute editor specified by attribute name is disabled for editting
    ...
    ...    *Arguments*
    ...    - editor type = the editor type being checked, one of the following values must be used: BOOLEAN, TEXT, DATE, USER, ENTITY_LINK, ENTITY_LINK_LIST (both non-versioned and versioned entity links), DICTIONARY_LIST (all dictionary list types), USER_LIST, STRING_LIST, DROPDOWN (dropdown covers dictionary fixed and flexible).
    ...    - attribute name = the name of the attribute as it appears within the web client ID's (note if using DICTIONARY_LINK the attribute name argument should be of the form {attribute name}-{property name} as in the below example.
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Open Edit Properties Dialog | My Experiment | TILE |
    ...    | Check Attribute Editor Disabled | BOOLEAN | myBooleanAttribute |
    ...    | Check Attribute Editor Disabled | TEXT | myTextAttribute |
    ...    | Check Attribute Editor Disabled | DATE | myDateAttribute |
    ...    | Check Attribute Editor Disabled | USER | myUserAttribute |
    ...    | Check Attribute Editor Disabled | ENTITY_LINK | myEntityLinkAttribute |
    ...    | Check Attribute Editor Disabled | ENTITY_LINK_LIST | myEntityLinkListAttribute |
    ...    | Check Attribute Editor Disabled | DROPDOWN | myDropdownAttribute |
    ...    | Check Attribute Editor Disabled | DICTIONARY_LINK | myDictionaryLinkAttribute-Property1 |
    Run Keyword If    '${editor type}'=='BOOLEAN'    Page Should Contain Element    xpath=//*[contains(@class, 'CheckBox-disabled') and (@id="ewb-attribute-editor-${attribute name}")]
    Run Keyword If    '${editor type}'=='TEXT'    Element Should Be Disabled    ewb-attribute-editor-${attribute name}
    Run Keyword If    '${editor type}'=='DATE'    Element Should Be Disabled    ewb-attribute-editor-${attribute name}-textbox
    Run Keyword If    '${editor type}'=='USER'    Element Should Be Disabled    ewb-attribute-editor-${attribute name}-input
    Run Keyword If    '${editor type}'=='DROPDOWN'    Element Should Be Disabled    ewb-attribute-editor-${attribute name}-input
    Run Keyword If    '${editor type}'=='ENTITY_LINK'    Page Should Contain Element    xpath=//div[contains(@class, 'ewb-image-button-disabled')]/img[@id="ewb-attribute-editor-entityLink-${attribute name}-navButton"]
    Run Keyword If    '${editor type}'=='DICTIONARY_LINK'    Element Should Be Disabled    ewb-attribute-editor-${attribute name}-input
    Run Keyword If    '${editor type}'=='DICTIONARY_LIST'    Element Should Be Disabled    ewb-attribute-editor-${attribute name}-input
    Run Keyword If    '${editor type}'=='DICTIONARY_LIST'    Page Should Contain Element    xpath=//img[contains(@class, 'ewb-image-button-disabled') and @id="ewb-attribute-editor-listBox-${attribute name}-addButton"]
    Run Keyword If    '${editor type}'=='DICTIONARY_LIST'    Page Should Contain Element    xpath=//img[contains(@class, 'ewb-image-button-disabled') and @id="ewb-attribute-editor-listBox-${attribute name}-deleteButton"]
    Run Keyword If    '${editor type}'=='DICTIONARY_LIST'    Page Should Contain Element    xpath=//img[contains(@class, 'ewb-image-button-disabled') and @id="ewb-attribute-editor-listBox-${attribute name}-moveUpButton"]
    Run Keyword If    '${editor type}'=='DICTIONARY_LIST'    Page Should Contain Element    xpath=//img[contains(@class, 'ewb-image-button-disabled') and @id="ewb-attribute-editor-listBox-${attribute name}-moveDownButton"]
    Run Keyword If    '${editor type}'=='STRING_LIST'    Element Should Be Disabled    ewb-attribute-editor-${attribute name}
    Run Keyword If    '${editor type}'=='STRING_LIST'    Page Should Contain Element    xpath=//img[contains(@class, 'ewb-image-button-disabled') and @id="ewb-attribute-editor-listBox-${attribute name}-addButton"]
    Run Keyword If    '${editor type}'=='STRING_LIST'    Page Should Contain Element    xpath=//img[contains(@class, 'ewb-image-button-disabled') and @id="ewb-attribute-editor-listBox-${attribute name}-deleteButton"]
    Run Keyword If    '${editor type}'=='STRING_LIST'    Page Should Contain Element    xpath=//img[contains(@class, 'ewb-image-button-disabled') and @id="ewb-attribute-editor-listBox-${attribute name}-moveUpButton"]
    Run Keyword If    '${editor type}'=='STRING_LIST'    Page Should Contain Element    xpath=//img[contains(@class, 'ewb-image-button-disabled') and @id="ewb-attribute-editor-listBox-${attribute name}-moveDownButton"]
    Run Keyword If    '${editor type}'=='USER_LIST'    Element Should Be Disabled    ewb-attribute-editor-${attribute name}-input
    Run Keyword If    '${editor type}'=='USER_LIST'    Page Should Contain Element    xpath=//img[contains(@class, 'ewb-image-button-disabled') and @id="ewb-attribute-editor-listBox-${attribute name}-addButton"]
    Run Keyword If    '${editor type}'=='USER_LIST'    Page Should Contain Element    xpath=//img[contains(@class, 'ewb-image-button-disabled') and @id="ewb-attribute-editor-listBox-${attribute name}-deleteButton"]
    Run Keyword If    '${editor type}'=='USER_LIST'    Page Should Contain Element    xpath=//img[contains(@class, 'ewb-image-button-disabled') and @id="ewb-attribute-editor-listBox-${attribute name}-moveUpButton"]
    Run Keyword If    '${editor type}'=='USER_LIST'    Page Should Contain Element    xpath=//img[contains(@class, 'ewb-image-button-disabled') and @id="ewb-attribute-editor-listBox-${attribute name}-moveDownButton"]
    Run Keyword If    '${editor type}'=='ENTITY_LINK_LIST'    Page Should Contain Element    xpath=//img[@id="ewb-attribute-editor-entityLink-${attribute name}-navButton" and contains(@class, 'ewb-image-button-disabled')]
    Run Keyword If    '${editor type}'=='ENTITY_LINK_LIST'    Page Should Contain Element    xpath=//img[contains(@class, 'ewb-image-button-disabled') and @id="ewb-attribute-editor-listBox-${attribute name}-addButton"]
    Run Keyword If    '${editor type}'=='ENTITY_LINK_LIST'    Page Should Contain Element    xpath=//img[contains(@class, 'ewb-image-button-disabled') and @id="ewb-attribute-editor-listBox-${attribute name}-deleteButton"]
    Run Keyword If    '${editor type}'=='ENTITY_LINK_LIST'    Page Should Contain Element    xpath=//img[contains(@class, 'ewb-image-button-disabled') and @id="ewb-attribute-editor-listBox-${attribute name}-moveUpButton"]
    Run Keyword If    '${editor type}'=='ENTITY_LINK_LIST'    Page Should Contain Element    xpath=//img[contains(@class, 'ewb-image-button-disabled') and @id="ewb-attribute-editor-listBox-${attribute name}-moveDownButton"]

Check Empty Mandatory Attribute Error Is Displayed
    [Arguments]    ${attribute name}
    [Documentation]    Checks that the error icon and expected error tooltip is shown for empty mandatory attributes
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears within the web client ID's
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Open Edit Properties Dialog | My Experiment | TILE |
    ...    | Click OK |
    ...    | Check Empty Mandatory Attribute Error Is Displayed| title |
    Wait Until Page Contains Element    ewb-attribute-editor-${attribute name}-validation-failed-image    30s    No Invalid Value Flag Found
    ${displayed error message}=    IDBSSelenium2Library.Get Element Attribute    ewb-attribute-editor-${attribute name}-validation-failed-image@title
    Should Be Equal    ${displayed error message}    The property value is invalid. Missing Value

Check Value In List Attribute
    [Arguments]    ${attribute name}    ${attribute value}
    [Documentation]    Checks list attribute given by the ${attribute name} contains the ${attribute value} specified.
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears within the web client ID's
    ...    - attribute value = the attribute value to be checked. If "EMPTY" is used as this argument, the field will be checked to ensure it is empty of values
    ...
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Open Edit Properties Dialog | My Experiment | TILE |
    ...    | Check Value In List Attribute | listAttribute | EMPTY |
    ...    | Add To List Attribute Text Entry | listAttribute | new value |
    ...    | Check Value In List Attribute | listAttribute | new value |
    Run Keyword If    '${attribute value}'=='EMPTY'    Page Should Not Contain Element    xpath=//div[@id="ewb-attribute-editor-listBox-${attribute name}"]/div/div[@__idx]
    Run Keyword Unless    '${attribute value}'=='EMPTY'    Page Should Contain Element    xpath=//div[@id="ewb-attribute-editor-listBox-${attribute name}"]/div/div/div[text()="${attribute value}"]

Set Dictionary Linked Attribute Value
    [Arguments]    ${attribute name}    ${property name 1}    ${property value 1}    ${property name 2}=none    ${property value 2}=none    ${property name 3}=none
    ...    ${property value 3}=none    ${property name 4}=none    ${property value 4}=none    ${property name 5}=none    ${property value 5}=none
    [Documentation]    Sets the values of a dictionary linked attribute
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears within the web client ID's
    ...    - property name x = the attribute property name where x is the number as it appears, 1, 2, 3, 4, 5 (2-5 are optional)
    ...    - property value x = the attribute property value where x is the number as it appears, 1, 2, 3, 4, 5 (2-5 are optional)
    ...
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Open Edit Properties Dialog | My Experiment | TILE |
    ...    | Set Dictionary Linked Attribute Value | dictionaryLinked | prop1 | myvalue1 |
    ...    | Check Dictionary Linked Attribute Value | dictionaryLinked | prop1 | myvalue1 | prop2 | myvalue2 | prop3 | myvalue3 |
    Set List Attribute    ${attribute name}-${property name 1}    ${property value 1}
    Run Keyword Unless    '${property name 2}'=='none'    Set List Attribute    ${attribute name}-${property name 2}    ${property value 2}
    Run Keyword Unless    '${property name 3}'=='none'    Set List Attribute    ${attribute name}-${property name 3}    ${property value 3}
    Run Keyword Unless    '${property name 4}'=='none'    Set List Attribute    ${attribute name}-${property name 4}    ${property value 4}
    Run Keyword Unless    '${property name 5}'=='none'    Set List Attribute    ${attribute name}-${property name 5}    ${property value 5}

Check Dictionary Linked Attribute Value
    [Arguments]    ${attribute name}    ${property name 1}    ${property value 1}    ${property name 2}=none    ${property value 2}=none    ${property name 3}=none
    ...    ${property value 3}=none    ${property name 4}=none    ${property value 4}=none    ${property name 5}=none    ${property value 5}=none
    [Documentation]    Checks the values of a dictionary linked attribute
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears within the web client ID's
    ...    - property name x = the attribute property name where x is the number as it appears, 1, 2, 3, 4, 5 (2-5 are optional)
    ...    - property value x = the attribute property value where x is the number as it appears, 1, 2, 3, 4, 5 (2-5 are optional)
    ...
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Open Edit Properties Dialog | My Experiment | TILE |
    ...    | Check Dictionary Linked Attribute Value | dictionaryLinked | prop1 | myvalue1 | prop2 | myvalue2 | prop3 | myvalue3 |
    Dictionary Linked Attribute Selected Value Logic    ${attribute name}    ${property name 1}    ${property value 1}
    Run Keyword Unless    '${property name 2}'=='none'    Dictionary Linked Attribute Selected Value Logic    ${attribute name}    ${property name 2}    ${property value 2}
    Run Keyword Unless    '${property name 3}'=='none'    Dictionary Linked Attribute Selected Value Logic    ${attribute name}    ${property name 3}    ${property value 3}
    Run Keyword Unless    '${property name 4}'=='none'    Dictionary Linked Attribute Selected Value Logic    ${attribute name}    ${property name 4}    ${property value 4}
    Run Keyword Unless    '${property name 5}'=='none'    Dictionary Linked Attribute Selected Value Logic    ${attribute name}    ${property name 5}    ${property value 5}

Dictionary Linked Attribute Selected Value Logic
    [Arguments]    ${attribute name}    ${property name}    ${property value}
    ${value}=    Get Combobox Value    ewb-attribute-editor-${attribute name}-${property name}
    Should Be Equal As Strings    ${value}    ${property value}

Set List Attribute Invalid Text Entry
    [Arguments]    ${attribute name}    ${attribute value}    ${expected error message}
    [Documentation]    Sets the value of a list attribute given by the ${attribute name} with the ${attribute value} using text entry and checks the value is marked as being invalid.
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears within the web client ID's
    ...    - attribute value = the attribute value to be entered
    ...    - expected error message = the expected error message on the tooltip of the error icon
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Open Edit Properties Dialog | My Experiment | TILE |
    ...    | Set List Attribute Invalid Text Entry | listAttribute | my/value | The property value is invalid. Invalid item: my/value |
    Toggle Attribute Sections    ewb-attribute-editor-${attribute name}-input
    Input Text    ewb-attribute-editor-${attribute name}-input    ${attribute value}
    Simulate    ewb-attribute-editor-${attribute name}-input    blur
    Textfield Should Contain    ewb-attribute-editor-${attribute name}-input    ${attribute value}
    Save Entity Properties
    Page Should Contain Element    ewb-attribute-editor-${attribute name}-validation-failed-image    No Invalid Value Flag Found
    ${displayed error message}=    IDBSSelenium2Library.Get Element Attribute    ewb-attribute-editor-${attribute name}-validation-failed-image@title
    Should Be Equal    ${expected error message}    ${displayed error message}
    Textfield Should Contain    ewb-attribute-editor-${attribute name}-input    ${attribute value}
    Click Close

Set Textarea Attribute
    [Arguments]    ${attribute name}    ${attribute value}
    [Documentation]    Sets the text attribute given by ${attribute name} to the value given by ${attribute value}
    Toggle Attribute Sections    ewb-attribute-editor-${attribute name}
    Input Text    ewb-attribute-editor-${attribute name}    ${attribute value}
    Textarea Should Contain    ewb-attribute-editor-${attribute name}    ${attribute value}
    Comment    Call Selenium Api    fireEvent    ewb-attribute-editor-${attribute name}    blur

Check Textarea Attribute Value
    [Arguments]    ${attribute name}    ${attribute value}
    [Documentation]    Checks the text attribute given by ${attribute name} is set to ${attribute value}
    ...
    ...    *Arguments*
    ...    Attribute Name = The name of the attribute being checked
    ...    Attribute Value = The expected attribute value
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    Open Edit Properties Dialog | My Experiment | TILE
    ...    Check Text Attribute Value | myTextAttribute | Something
    Textarea Should Contain    ewb-attribute-editor-${attribute name}    ${attribute value}

Cancel Attribute Editing Dialog and Unlock Record
    [Documentation]    Keyword to close the properties dialog when editing attributes when no changes have been made and unlock the record.
    Cancel Edit Entity Properties
    Click away from Property Panel
    Open Record Editing Header Tool Menu
    Robust Click    ewb-editor-command-close-record
