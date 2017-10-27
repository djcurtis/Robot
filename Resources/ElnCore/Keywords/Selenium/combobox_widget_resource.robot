*** Settings ***
Library           IDBSSelenium2Library
Resource          general_resource.robot
Library           CheckLibrary

*** Keywords ***
Select And Confirm Combobox Value
    [Arguments]    ${combobox id}    ${new value}    ${expected value}=
    [Documentation]    Select a value from the specified combo box drop down and confirm that the value then appears in the combo box text field
    ${expected value}    Set Variable If    '${expected value}'==''    ${new value}    ${expected value}
    Wait Until Keyword Succeeds    60s    5s    __Open Combobox
    #check for the element in the list
    ${status}    ${value}=    Run Keyword And Ignore Error    Page Should Contain Element    //table[contains(@class,'idbs-gwt-combobox-items')]//td[contains(@class, 'list-item')]/div[text()='${new value}']
    #If present just select it
    Run Keyword If    '${status}'=='PASS' and '${new value}'!='${EMPTY}'    Robust Click    //table[contains(@class,'idbs-gwt-combobox-items')]//td[contains(@class, 'list-item')]/div[text()='${new value}']
    #If not present it might be on another scroll page
    Run Keyword If    '${status}'=='FAIL' and '${new value}'!='${EMPTY}'    Scroll Through Combobox List and Select Item    ${combobox id}    ${new value}
    #Handle empty case
    Run Keyword If    '${new value}'=='${EMPTY}'    Robust Click    //table[contains(@class,'idbs-gwt-combobox-items')]//tr[1]/td/div
    Confirm Combobox Value    ${combobox id}    ${expected value}

Enter And Confirm Combobox Value
    [Arguments]    ${combobox id}    ${new value}
    [Documentation]    Enter a value into the combo box and confirm that the value then appears in the combo box text field
    Robust Click    xpath=//div[@id='${combobox id}']//input[contains(@class,'gwt-TextBox')]
    Input Text    xpath=//div[@id='${combobox id}']//input[contains(@class,'gwt-TextBox')]    ${new value}
    Sleep    5s    # Don't blur too early - sometimes this can break the text input
    Simulate    xpath=//div[@id='${combobox id}']//input[contains(@class,'gwt-TextBox')]    blur
    Confirm Combobox Value    ${combobox id}    ${new value}

Confirm Combobox Value
    [Arguments]    ${combobox id}    ${expected value}
    [Documentation]    Confirm that the given value appears in the combo box text field
    Wait Until Keyword Succeeds    5s    1s    _InternalConfirmComboboxValue    ${combobox id}    ${expected value}

Get Combobox Value
    [Arguments]    ${combobox id}
    [Documentation]    Return the value of the given combo box
    Wait Until Page Contains Element    xpath=//div[@id='${combobox id}']//input[contains(@class,'gwt-TextBox')]    30s
    ${value}    Get Value    xpath=//div[@id='${combobox id}']//input[contains(@class,'gwt-TextBox')]
    [Return]    ${value}

_InternalConfirmComboboxValue
    [Arguments]    ${combobox id}    ${expected_value}
    [Documentation]    Confirm that the given value appears in the combo box text field
    ${value}    Get Combobox Value    ${combobox id}
    Check String Equals    Verifying actual value of combobox ${combobox id}    ${value.strip()}    ${expected_value.strip()}    case_sensitive=${True}    failure_stops_test=${True}

Scroll Through Combobox List and Select Item
    [Arguments]    ${combobox_id}    ${item}
    ${status}    ${value}=    Run Keyword And Ignore Error    Page Should Contain Element    xpath=//table[@id="${combobox_id}-paging-toolbar"]//img[@aria-label="Next page" and @aria-disabled="false"]
    Run Keyword If    '${status}'=='PASS'    Robust Click    xpath=//table[@id="${combobox_id}-paging-toolbar"]//img[@aria-label="Next page"]
    ${status2}    ${value2}=    Run Keyword And Ignore Error    Wait Until Page Contains Element    //table[contains(@class,'idbs-gwt-combobox-items')]//td[contains(@class, 'list-item')]/div[text()='${new value}']    3s
    Run Keyword If    '${status2}'=='PASS'    Robust Click    //table[contains(@class,'idbs-gwt-combobox-items')]//td[contains(@class, 'list-item')]/div[text()='${new value}']
    Run Keyword If    '${status2}'=='FAIL'    Run Keyword If    '${status}'=='PASS'    Scroll Through Combobox List and Select Item    ${combobox_id}    ${item}

__Open Combobox
    Robust Click    xpath=//div[@id='${combobox id}']//img    image
    Wait Until Page Contains Element    xpath=//table[contains(@class, 'idbs-gwt-combobox-items')]    10s
