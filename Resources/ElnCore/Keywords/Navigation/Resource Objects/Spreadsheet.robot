*** Settings ***
Library    IDBSSelenium2Library
Resource          ../../Selenium/general_resource.robot

*** Variables ***
${SPREADSHEET_FRAME} =    lite-editor-frame

*** Keywords ***

Select Spreadsheet Frame
    unselect frame
    Wait Until Page contains element    ${SPREADSHEET_FRAME}    10s
    select frame  ${SPREADSHEET_FRAME}
    sleep    1s

Verify Spreadsheet Page Loaded
    Select Spreadsheet Frame

Select Return to E-WorkBook
    Select Spreadsheet Frame
    Robust Click    xpath=//*[@class='command-return'][contains(@title,'Return to E-WorkBook')]

Select Instructions Tab
    Select Spreadsheet Frame
    Robust Click    xpath=//*[@id='nav-tab-1']

Select Data Tab
    Select Spreadsheet Frame
    Robust Click    xpath=//*[@id='nav-tab-2']

Click on Done Instruction
    Select Spreadsheet Frame
    Robust Click    xpath=//div[@class='instruction done']/div[contains(text(),'Done')]

Select Action Button
    [Arguments]    ${instruction_name}
    Select Spreadsheet Frame
    Robust Click    xpath=//div[@class='message'][contains(text(),'${instruction_name}')]/..//div[@class='action-button']

Press Knockout Instruction Button
    Select Spreadsheet Frame
    Robust Click    xpath=//div[@class='data-panel']//button[contains(@title,'Knockout the selected cell')]

Press Undo Knockout Instruction Button
    Select Spreadsheet Frame
    Robust Click    xpath=//div[@class='data-panel']//button[contains(@title,'Remove any knockouts from the selected cells')]

Select Perspective Picker
    [Arguments]    ${perspective_name}
    Select Spreadsheet Frame
    Robust Click    xpath=//div[@class='perspective-selector']//button[contains(text(),'${perspective_name}')]
