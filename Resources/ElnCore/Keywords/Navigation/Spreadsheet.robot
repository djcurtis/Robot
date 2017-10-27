*** Settings ***
Resource    ../Navigation/Resource Objects/Spreadsheet.robot
Resource    ../Navigation/Resource Objects/ElnCoreNav.robot
Library     IDBSSelenium2Library
Library     EntityAPILibrary
Library     DateTime
Library     QuantrixLibrary
Resource    ../IDBS Spreadsheet/instruction_sheet_keywords.robot
Resource    ../Selenium/quantrix_web_resource.robot
Resource    ../Selenium/quantrix_web_resource.robot
Resource    ../IDBS Spreadsheet/curve_fitting_web_resource.robot


*** Variables ***



*** Keywords ***

Spreadsheet Editor Loaded
    Spreadsheet.Verify Spreadsheet Page Loaded

Return to E-WorkBook
    Spreadsheet.Select Return to E-WorkBook

Use Instructions Panel
    Spreadsheet.Select Instructions Tab

Use Data Panel
    Spreadsheet.Select Data Tab

Select Instruction Item
    [Arguments]    ${instruction_item}
    Spreadsheet.Select Instructions Tab
    Verify Instructions Exist    ${instruction_item}
    Tick Instruction    ${instruction_item}

Select Instruction Action
    [Arguments]    ${instruction_item}
    Spreadsheet.Select Instructions Tab
    Verify Instructions Exist    ${instruction_item}
    Select Action Button    ${instruction_item}

Confirm Instruction Checked
    [Arguments]    ${instruction_item}
    Group should be ticked    ${instruction_item}

Select Import Action on Instruction
    [Arguments]    ${instruction_item}    ${file_path}
    Click on File Import Instruction    ${instruction_item}
    Data Import Page Select File To Import    ${file_path}

Select Done Action on Instruction
    [Arguments]    ${instruction_item}
    Click on Navigation Instruction    ${instruction_item}
    Click on Done Instruction
    ElnCoreNav.Check Homepage Root Exists    #Confirms E-WorkBook is displayed and Spreadsheet Editor is shut down

Knockout data from table
    [Arguments]    ${tab_name}    ${rowNo}    ${colNo}    ${viewName}=${EMPTY}
    Select Sheet In Tab    ${tab_name}
    Select Cell in Editor    ${rowNo}    ${colNo}    ${tab_name}
    Use Data Panel
    Wait Until Keyword Succeeds    10s    2s     Press Knockout Instruction Button
    Cell should be knocked out    ${rowNo}    ${colNo}    ${tab_name}

Knockout data from Chart
    [Arguments]    ${tab_name}    ${rowNo}    ${colNo}    ${rowNoStart}    ${colNoStart}    ${rowNoEnd}    ${colNoEnd}    ${viewName}=${EMPTY}
    Select Sheet In Tab    ${tab_name}
    Start Curve Fitting Browser    ${tab_name}    ${rowNo}    ${colNo}
    Knockout Chart Selection    ${rowNoStart}    ${colNoStart}    ${rowNoEnd}    ${colNoEnd}    # drag box around the 4 and 6 time points
    Exit Curve Fitting Browser
    Spreadsheet Editor Loaded

Confirm table cell is Knocked Out
    [Arguments]    ${tab_name}    ${rowNo}    ${colNo}
    Cell should be knocked out    ${rowNo}    ${colNo}    ${tab_name}

Open Drop Down for Perspective Selection
    [Arguments]    ${perspective_name}
    Select Perspective Picker    ${perspective_name}

Delete Cell contents
    [Arguments]    ${view_name}    ${row_no}    ${col_no}    ${text}
    Confirm Sheet Selected    ${view_name}
    Type to Cell in Editor    ${view_name}    ${row_no}    ${col_no}    ${text}

Write to Cell
    [Arguments]    ${view_name}    ${row_no}    ${col_no}    ${text}
    Confirm Sheet Selected    ${view_name}
    Type to Cell in Editor    ${view_name}    ${row_no}    ${col_no}    ${text}

Select Perspective View
    [Arguments]    ${perspective_name}
    wait until keyword succeeds  10    5    Click Perspective In Picker By Name    ${perspective_name}

Save Cell Value
    [Arguments]    ${row_no}    ${col_no}    ${view_name}
    ${CELL_VALUE}    Spreadsheet.Get Editor Cell Value    ${row_no}    ${col_no}    ${view_name}
    set suite variable    ${CELL_VALUE}

Get Editor Cell Value
    [Arguments]    ${row_no}    ${col_no}    ${view_name}
    [Documentation]    Get the Cell Value of Cell in the Spreadsheet Editor
    Wait Until Element Is Visible    xpath=//*[@id='view-${view_name}']//*[@id='c${row_no}-${col_no}']
    ${cell_value}=    Execute Javascript    return document.getElementById('c${row_no}-${col_no}').innerHTML
    [Return]    ${cell_value}

Check Search Result Cell
    [Arguments]    ${Expected Text}    ${rowNo}    ${colNo}
    Spreadsheet.Select Spreadsheet Frame
    Spreadsheet.Verify Cell Value    ${Expected Text}    ${rowNo}    ${colNo}

Verify Cell Value
    [Arguments]    ${Expected Text}    ${rowNo}    ${colNo}
    [Documentation]    Verifies the text within the cell matches the expected value
    ${passed}=    Run Keyword And Return Status    wait until page contains element    xpath=//*[@id='c${rowNo}-${colNo}'][contains(text(),'${Expected Text}')]
    Run Keyword Unless    ${passed}    Capture Page Screenshot    # If the cell value doesn't contain what we expected, ${passed} will be false. Ensuring screenshot is taken here so that we can see any problems.
    Run Keyword Unless    ${passed}    Fail    Expected text: '${Expected Text}' not present in cell. See screenshot or expand 'Element Text Should Be' attempts for more info.

