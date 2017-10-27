*** Settings ***
Library           IDBSSwingLibrary
Library           RobotRemoteAgent
Library           IDBSSelenium2Library
Library           EntityAPILibrary
Resource          ../Common/common_resource.robot
Library           EntityAPILibrary
Resource          ../Selenium/general_resource.robot
Resource          common_spreadsheet_keywords.robot
Resource          ../Selenium/quantrix_web_resource.robot
Resource          ../Common/general setup tools.robot

*** Variables ***
${InstructionSheetDialog}    InstructionSetDesignerDialog

*** Keywords ***
Open Instruction Sheet dialog
    [Documentation]    This Keyword launches the the Instruction Set Designer in the spreadsheet Designer
    ...
    ...    _Precondtion_
    ...    The Spreadsheet Desginer needs to be opened and the user must be logged in with the \ right permission i.e. Modeler
    Select From Designer Menu    Tools|Instruction Set Designer...
    Sleep    2s
    Wait Until Keyword Succeeds    30s    1s    Select Dialog    ${InstructionSheetDialog}

Select single instruction
    [Documentation]    This keywords selects the option to set a single instruction set for use in a spreadsheet in the Instruction Sheet dialog
    ...
    ...    Assumes the dialog is already open and has focus
    Push Radio Button    SingleInstructionSetButton
    Radio Button Should Be Selected    SingleInstructionSetButton

Select to set instructions for Perspective
    [Documentation]    This selects the option to set instructions per perspective in the Instruction sheet dialog
    Push Radio Button    InstructionSetPerPerspectiveButton
    Radio Button Should Be Selected    InstructionSetPerPerspectiveButton

Instruction Sheet Suite Setup
    [Documentation]    This key word creates Group and project for test experiment setup
    Kill All Spreadsheet Designer Sessions    # to handle failure and possibly open modal dialogs from other test runs
    Create Hierarchy For Experiments    INSTRUCTION SHEETS

Instruction Sheet Test Setup
    [Documentation]    Sets up the experiment for tests and opens the web browser to the experiment URL page
    Create Test Experiment    INSTRUCTION SHEETS
    Weblaunch Open Browser to Page    ${experiment_url}    ${VALID USER}    ${VALID PASSWD}

Instruction Sheet Suite Teardown
    [Documentation]    Deletes all suite suite and test setup
    Suite Teardown
    Run Keyword And Ignore Error    Delete Experiment and Hierarchy

Instruction Sheet Test Teardown
    [Documentation]    Removes lock from experiment
    Kill All Spreadsheet Designer Sessions
    run keyword and ignore error    Unlock Test Experiment
    Close All Browsers

Select Instruction
    [Arguments]    ${index}
    [Documentation]    Selects an instruction at the given position in the Spreadsheet Designer - Instruction Set Designer
    ...
    ...    *Arguments*
    ...
    ...    _index_ - the position of the instruction in the list (starting at 1)
    ...
    ...
    ...    *Prerequisites*
    ...
    ...    The spreadsheet designer must be open and there must be some instructions present
    ...
    ...    Example
    ...
    ...    | Select Instruction | 0 |
    ...    | Verify text for Text Instruction | _myText_ |
    Wait Until Keyword Succeeds    6s    2s    Click On Component    xpath=//*[contains(@class,'PreviewViewImpl')]//*[contains(@class,'com.idbs.ewb.ss.ui.instructions.internal.PreviewViewImpl$InstructionPanel')]//*[contains(@class, 'javax.swing.JTextArea')][${index}]
    # Add a small delay after selecting the instruction to try and make tests more stable.
    Sleep    1s

Delete Instruction
    [Documentation]    This keyword deletes an instruction in the list of set instructions in the Instruction Set Designer dialog
    ...
    ...    _Precondition_
    ...
    ...    The Instruction Set Designer needs to be opened and an instruction needs to be selected in order to delete the instruction from the list
    Push Button    DeleteSelectedInstruction

Add Group Instruction
    [Documentation]    This keyword selects the option to create a Group Instruction
    ...
    ...    _Precondition_
    ...
    ...    The Instruction Set Designer needs to be opened in the Spreadsheet Designer and a perspective needs to be selected in the list of perspective in the instruction dialog
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    Push button    AddInstructionType
    Activate Dialog    InstructionTypeSelector
    Select Dialog    InstructionTypeSelector
    Click On Component    NewInstruction-group
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    Component Should Be Visible    class=GroupingInstructionPreview$1

Add Text Instruction
    [Documentation]    Selects the option to create a text instruction in the Spreadsheet Set Designer dialog
    ...
    ...    _Pre-condition_
    ...
    ...    The Instruction Set Designer dialog needs to be opened in the Spreadsheet Designer
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    Push button    AddInstructionType
    Activate Dialog    InstructionTypeSelector
    Select Dialog    InstructionTypeSelector
    Click On Component    NewInstruction-text

Add File Import Instruction
    [Documentation]    This keyword adds a File Import instruction in the Instructiobn Set Designer
    ...
    ...    _Precondition_
    ...    Requires the Instruction Set Designer needs to be opened in the Spreadsheet Designer
    ...
    ...    Either one of the option to select "Single Instruction Set for Spreadsheet" or Select "Instruction Set per Perspective"
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    Push button    AddInstructionType
    Activate Dialog    InstructionTypeSelector
    Select Dialog    InstructionTypeSelector
    Click On Component    NewInstruction-fileimport

Add Done Instruction
    [Documentation]    This keyword adds a done instruction in the Instruction Set Designer and verifies that a done instruction was added
    ...
    ...    _Precondition_
    ...    Requires the Instruction Set Designer needs to be opened in the Spreadsheet Designer
    ...
    ...    Either one of the option to select "Single Instruction Set for Spreadsheet" or Select "Instruction Set per Perspective"
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    Push button    AddInstructionType
    Activate Dialog    InstructionTypeSelector
    Select Dialog    InstructionTypeSelector
    Click On Component    NewInstruction-done
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    #Verfies that a Done instruction has been added
    Click On Component    class=PreviewViewImpl$InstructionPanel
    Click On Label    text=Done

Add Navigation Instruction
    [Documentation]    This keyword adds a Navigation instruction in the Instructiobn Set Designer
    ...
    ...    _Precondition_
    ...    Requires the Instruction Set Designer needs to be opened in the Spreadsheet Designer
    ...
    ...    Either one of the option to select "Single Instruction Set for Spreadsheet" or Select "Instruction Set per Perspective"
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    Push button    AddInstructionType
    Activate Dialog    InstructionTypeSelector
    Select Dialog    InstructionTypeSelector
    Click On Component    NewInstruction-navigation
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}

Add Query Refresh Instruction
    [Documentation]    This keyword adds a Query Refresh instruction in the Instructiobn Set Designer
    ...
    ...    _Precondition_
    ...    Requires the Instruction Set Designer needs to be opened in the Spreadsheet Designer
    ...
    ...    Either one of the option to select "Single Instruction Set for Spreadsheet" or Select "Instruction Set per Perspective"
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    Push button    AddInstructionType
    Activate Dialog    InstructionTypeSelector
    Select Dialog    InstructionTypeSelector
    Click On Component    NewInstruction-query
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}

Select from Perspective List
    [Arguments]    ${name_of_perspective}
    [Documentation]    This key words selects a perspective when the option to set instructions per perspective is selected.
    ...
    ...    The persective are identified by their name and using the argumrent ${name_of_perspctive)
    ...
    ...    _Pre Condition_
    ...
    ...    Requires the Instrion Set Designer dialog to be opened in the spreadsheet designer and a list of persipective to have been configured for the spreadsheet
    IDBSSwingLibrary.Select From List    PerspectiveList    ${name_of_perspective}

Insert Text for Text Instruction
    [Arguments]    ${insert_text}
    [Documentation]    Selects the text dialog and types a given text to it
    ...
    ...    _Pre-condition_
    ...
    ...    The Instruction Set Designer dialog needs to be opened in the Spreadsheet Designer and the option to either set instruction for whole spreadsheet or for perspectives needs to be selected and a text item must be added to the seleted option
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    Click On Component    text-instruction-text    1
    Type To Component    text-instruction-text    ${insert_text}

Insert Instruction Label
    [Arguments]    ${insert_text}
    [Documentation]    Selects the group dialog and types a given text to it
    ...
    ...    _Pre-condition_
    ...
    ...    The Instruction Set Designer dialog needs to be opened in the Spreadsheet Designer and the option to either set instruction for whole spreadsheet or for perspectives needs to be selected and a group item must be added to the seleted option
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    Click On Component    GROUP_CONTROL_HEADING_TEXT_AREA    1
    Type To Component    GROUP_CONTROL_HEADING_TEXT_AREA    ${insert_text}

Verify text for Text Instruction
    [Arguments]    ${textvalue}
    [Documentation]    Verifies that the text inserted into the text dialog for instruction is correct
    ...
    ...    _Pre-condition_
    ...
    ...    A text must be enetered into the text instruction field of the Spreadsheet Set Designer dialog
    ${textFieldValue}=    Get Text Field Value    text-instruction-text
    Should Be Equal    ${textvalue}    ${textFieldValue}

Verify FileImport Label Text
    [Arguments]    ${textvalue}
    [Documentation]    This Keyword verifies the text that was set inserted for a group instruction
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    ${textFieldValue}=    Get Text Field Value    FileImportLabel
    Should Be Equal    ${textvalue}    ${textFieldValue}

Close Instruction Sheet Dialog
    [Documentation]    This closes the Spredsheet Set Designer dialog in the spreadsheet designer
    Close Dialog    ${InstructionSheetDialog}

Set Height Lines
    [Arguments]    ${insert_number}
    [Documentation]    This Keyword allows the user to define the number of lines that should be shown within the instructions
    ...
    ...
    ...    _Precondition_
    ...    The Instruction Set desginer dialog needs to be opened in the Spreadsheet Designer
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    Click On Component    class=JFormattedTextField    1
    Send Keyboard Event    VK_DELETE
    Type To Component    class=JFormattedTextField    ${insert_number}

Check For Scroll Component
    [Documentation]    This checks that the scroll compnent is present in the text preview when lines of text have exceeded the amount of line hieghts configured in the Spreadsheet Set Designer
    ...
    ...    _Precondition_
    ...
    ...    This requires a text greater than the amouount of lines to have been set for a text instruction
    Component Should Be Visible    xpath=.//*[contains(@class, 'TextInstructionPreview')]/*[contains(@class, 'JScrollPane$ScrollBar')]

Verify scroll component is not present
    [Documentation]    This checks that the scroll compnent is NOT present in the previewof the text instruction when lines of text have exceeded the amount of line hieghts configured in the Spreadsheet Set Designer
    ...
    ...    _Precondition_
    ...
    ...    This requires a text greater than the amouount of lines to have been set for a text instruction
    Component Should Not Be Visible    xpath=.//*[contains(@class, 'TextInstructionPreview')]/*[contains(@class, 'JScrollPane$ScrollBar')]

Verify Deletion of Instruction
    [Documentation]    This checks that instruction is no longer present in the Instruction Set Dialog once deleted
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    Click On Component    class=PreviewViewImpl
    Component Should Not Exist    class=PreviewViewImpl$InstructionPanel

Verify Tick Indicator for Group \ Instructions
    [Documentation]    This checks that a tick indicator is present for Group instructions
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    Click On Component    class=GroupingInstructionPreview$1
    Component Should Exist    class=TickIndicatorPanel
    Component Should Be Visible    class=TickIndicatorPanel

No tick indicator for Done Instructions
    [Documentation]    This checks that the Done instruction does not have a tick inidcator in the preview
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    Click On Component    class=PreviewViewImpl$InstructionPanel
    Component Should Not Exist    class=TickIndicatorPanel

Verify Group Label
    [Arguments]    ${textLable}
    [Documentation]    This verifies that the correct label has been set for the group instructions
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    Label Should Exist    text=${textLable}

Set Navigation Instruction Type
    [Arguments]    ${nav index}
    [Documentation]    Sets the navigation sub type based on the given ${nav index} value which should be a numerical value in the range of:
    ...
    ...    0 \ \ (URL)
    ...    1 \ \ (VIEW)
    ...    2 \ \ (PERSPECTIVE)
    Select From Combo Box    TypeSelectorCombo    ${nav index}

Insert Text for Navigation Instruction
    [Arguments]    ${instruction text}
    [Documentation]    Inserts text into the URL field of an already selected URL navigation instruction
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    Click On Component    LabelTextField    1
    Type To Component    LabelTextField    ${instruction text}

Insert URL for Navigation Instruction
    [Arguments]    ${url text}
    [Documentation]    Inserts text into the instruction label
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    Click On Component    UrlTextField    1
    Type To Component    UrlTextField    ${url text}

Verify Navigation Label
    [Arguments]    ${expected label}
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    click on label    NavigationPreviewLabel
    ${labelText}=    Get Label Content    NavigationPreviewLabel
    Should Be Equal    ${labelText}    <html>${expected label}</html>

Select View for Navigation Instruction
    [Arguments]    ${view name}
    [Documentation]    Selects a view from the navigation combo
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    Select From Combo Box    ViewComboBox    ${view name}

Select Perspective for Navigation Instruction
    [Arguments]    ${perspective name}
    [Documentation]    Selects a perspective from the combo box in the navigation instruction panel
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    Select From Combo Box    PerspectiveComboBox    ${perspective name}

Default Table for Import dropdown
    [Arguments]    ${fileimport}=default value
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    Push Button    class=com.subx.general.ui.iapi.plaf.FlatArrowButton
    ${val}=    Run Keyword And Ignore Error    Get Combobox Values    FileImportTables
    Select From Combo Box    FileImportTables    ${fileimport}

Verify Default Table to Import Field
    [Arguments]    ${Import Def Value}
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    ${val}=    Run Keyword And Ignore Error    Get Combobox Values    FileImportDefinitions
    Select From Combo Box    FileImportDefinitions    ${Import Def Value}

Select Blank
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    Sleep    1S
    Push Button    class=com.subx.general.ui.iapi.plaf.FlatArrowButton    #class=WindowsComboBoxUI$XPComboBoxButton
    Send Keyboard Event    VK_DOWN
    Send Keyboard Event    VK_ENTER

Verify File Import Preview
    [Arguments]    ${FileImportLable}
    [Documentation]    Verifies the preview displays how the file import instructions added will be displayed in the Web Client
    ...
    ...    Also checks that the correct label is present in the preview of the file import instruction preview
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    Click On Component    class=PreviewViewImpl$InstructionPanel
    Component Should Be Visible    class=PreviewViewImpl$InstructionPanel
    Click On Component    class=PreviewViewImpl$InstructionPanel
    click on label    class=JXLabel
    ${labeltext}    Get Label Content    class=JXLabel
    Should Be Equal    ${FileImportLable}    ${FileImportLable}

Select Query to Refresh
    [Arguments]    ${query name}
    [Documentation]    Selects a query to refresh in the Query Refresh Instruction editor
    ...
    ...    _Precondition_
    ...
    ...    The instruction set designer should be open and a Query Refresh Instruction must already be active
    Select From Combo Box    queryDropdown    ${query name}

Verify Query Refresh Preview
    [Arguments]    ${label}
    [Documentation]    Verifies the preview text for ther query refresh instruction is the supplied value
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    click on label    QueryRefreshPreviewLabel
    ${labelText}=    Get Label Content    QueryRefreshPreviewLabel
    Should Be Equal    ${labelText}    <html>${label}</html>

Insert Text for Query Refresh Instruction
    [Arguments]    ${instruction text}
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    Click On Component    labelTextArea    1
    Type To Component    labelTextArea    ${instruction text}

Check for Text Instruction
    [Arguments]    ${index}    ${text}
    [Documentation]    Checks for a text instruction at the given position and with the specified text
    ...
    ...    *Arguments*
    ...
    ...    _index_ - the position of the text instruction in the list (starting at 1)
    ...
    ...    _text_ - the text the instruction should have
    ...
    ...    *Prerequisites*
    ...
    ...    The spreadsheet web editor must be open and there must be some instructions present
    ...
    ...    Example
    ...
    ...    Check for Text Instruction | 1 | This is the first item
    ${locator}=    set variable    xpath=//div[@class='instructions-container']/div/div[${index}]
    ${type}=    IDBSSelenium2Library.get element attribute    ${locator}@data-instruction-type
    should be equal as strings    ${type}    text
    Element Text Should Be    ${locator}//div[@class='middle']//div[@class='message']    ${text}

Instruction should be unticked
    [Arguments]    ${index}
    [Documentation]    Checks that an instruction at the given position is unticked
    ...
    ...    *Arguments*
    ...
    ...    _index_ - the position of the instruction in the list (starting at 1)
    ...
    ...
    ...    *Prerequisites*
    ...
    ...    The spreadsheet web editor must be open and there must be some instructions present
    ...
    ...    Example
    ...
    ...    Instruction should be unticked | 1
    ${locator}=    set variable    xpath=//div[@class='instructions-container']/div/div[${index}]//div[@class='tick-wrapper']//i[@class='fa fa-lg notticked']
    Wait Until Element Is Visible    ${locator}    5s

Tick Instruction
    [Arguments]    ${instruction_name}
    [Documentation]    Ticks the instruction at the specified index. if the action is already ticked, then it is left alone
    ...
    ...    *Arguments*
    ...
    ...    _index_ - the position of the instruction in the list (starting at 1)
    ...
    ...
    ...    *Prerequisites*
    ...
    ...    The spreadsheet web editor must be open and there must be some instructions present (and the instruction specified must be tickable)
    ...
    ...    Example
    ...
    ...    Tick Instruction | 1
    ${locator}=    set variable    xpath=//div[@class='middle']/div[@class='instruction-container']/div[@class='message'][contains(text(),'${instruction_name}')]/../../preceding-sibling::div/div[@class='tick-wrapper']//i[@class='fa fa-lg notticked']
    ${ticked_locator}    set variable    xpath=//div[@class='middle']/div[@class='instruction-container']/div[@class='message'][contains(text(),'${instruction_name}')]/../../preceding-sibling::div/div[@class='tick-wrapper']//i[@class='fa fa-lg ticked fa-check-circle']

    ${is_unticked}    ${msg}    run keyword and ignore error    element should be visible    ${locator}
    run keyword if    '${is_unticked}' == 'PASS'    click element    ${locator}
    Wait Until Page Contains Element    ${ticked_locator}

Untick Instruction
    [Arguments]    ${index}
    [Documentation]    Unticks the instruction at the specified index. if the action is already unticked, then it is left alone
    ...
    ...    *Arguments*
    ...
    ...    _index_ - the position of the instruction in the list (starting at 1)
    ...
    ...
    ...    *Prerequisites*
    ...
    ...    The spreadsheet web editor must be open and there must be some instructions present (and the instruction specified must be tickable)
    ...
    ...    Example
    ...
    ...    Untick Instruction | 1
    ${locator}=    set variable    xpath=//div[@class='instructions-container']/div/div[${index}]//div[@class='tick-wrapper']//i[@class='fa fa-lg ticked fa-check-circle']
    ${is_ticked}    ${msg}    run keyword and ignore error    element should be visible    ${locator}
    run keyword if    '${is_ticked}' == 'PASS'    click element    ${locator}

Instruction should be ticked
    [Arguments]    ${index}
    [Documentation]    Checks that an instruction at the given position is ticked
    ...
    ...    *Arguments*
    ...
    ...    _index_ - the position of the instruction in the list (starting at 1)
    ...
    ...
    ...    *Prerequisites*
    ...
    ...    The spreadsheet web editor must be open and there must be some instructions present
    ...
    ...    Example
    ...
    ...    Instruction should be unticked | 1
    ${locator}=    set variable    xpath=//div[@class='instructions-container']/div/div[${index}]//div[@class='tick-wrapper']//i[@class='fa fa-lg ticked fa-check-circle']
    Wait Until Element Is Visible    ${locator}    5s

Select Instructions Tab
    [Documentation]    selects the instructions tab (Spreadsheet Web Editor)
    Select Drawer Tab    1

Verify Instructions Exist
    [Arguments]    ${instruction_name}    ${timeout}=10s    ${retry_interval}=1s
    [Documentation]    confirms that instructions are present for the open spreadsheet (Spreadsheet Web Editor)
    ...
    ...    *prerequisites*
    ...    the spreadsheet web editor must be open
    Wait Until Element Is Visible    xpath=//div[@class='middle']/div[@class='instruction-container']/div[@class='message'][contains(text(),'${instruction_name}')]    10s

Check for Group Instruction
    [Arguments]    ${index}    ${text}
    [Documentation]    Checks for a group instruction at the given position and with the specified text (Spreadsheet Web Editor)
    ...
    ...    *Arguments*
    ...
    ...    _index_ - the position of the group instruction in the list (starting at 1)
    ...
    ...    _text_ - the text the group should have
    ...
    ...    *Prerequisites*
    ...
    ...    The spreadsheet web editor must be open and there must be some instructions present
    ...
    ...    Example
    ...
    ...    Check for Group Instruction | 1 | Group 1
    ${locator}=    set variable    xpath=//div[@class='instructions-container']/div/div[${index}]
    ${type}=    IDBSSelenium2Library.get element attribute    ${locator}@data-instruction-type
    should be equal as strings    ${type}    group
    Element Text Should Be    ${locator}/div[@class='heading']    ${text}

Check for Done Instruction
    [Arguments]    ${index}
    [Documentation]    Checks for a Done instruction at the given position (Spreadsheet Web Editor)
    ...
    ...    *Arguments*
    ...
    ...    _index_ - the position of the Done instruction in the list (starting at 1)
    ...
    ...    *Prerequisites*
    ...
    ...    The spreadsheet web editor must be open and there must be some instructions present
    ...
    ...    Example
    ...
    ...    Check for Done Instruction | 1
    ${locator}=    set variable    xpath=//div[@class='instructions-container']/div/div[${index}]
    ${type}=    IDBSSelenium2Library.get element attribute    ${locator}@data-instruction-type
    should be equal as strings    ${type}    done

Check for Navigation Instruction
    [Arguments]    ${index}    ${text}
    [Documentation]    Checks for a navigation instruction at the given position and with the specified text (Spreadsheet Web Editor)
    ...
    ...    *Arguments*
    ...
    ...    _index_ - the position of the navigation instruction in the list (starting at 1)
    ...
    ...    _text_ - the text the instruction should have
    ...
    ...    *Prerequisites*
    ...
    ...    The spreadsheet web editor must be open and there must be some instructions present
    ...
    ...    Example
    ...
    ...    Check for navigation Instruction | 1 | google it
    ${locator}=    set variable    xpath=//div[@class='instructions-container']/div/div[${index}]
    ${type}=    IDBSSelenium2Library.get element attribute    ${locator}@data-instruction-type
    should be equal as strings    ${type}    navigation
    Element Text Should Be    ${locator}//div[@class='middle']//div[@class='message']    ${text}

Check for File Import Instruction
    [Arguments]    ${index}    ${text}
    [Documentation]    Checks for a File import instruction at the given position and with the specified text (Spreadsheet Web Editor)
    ...
    ...    *Arguments*
    ...
    ...    _index_ - the position of the fileimport instruction in the list (starting at 1)
    ...
    ...    _text_ - the text the instruction should have
    ...
    ...    *Prerequisites*
    ...
    ...    The spreadsheet web editor must be open and there must be some instructions present
    ...
    ...    Example
    ...
    ...    Check for File Import Instruction | 1 | laod raw data
    ${locator}=    set variable    xpath=//div[@class='instructions-container']/div/div[${index}]
    ${type}=    IDBSSelenium2Library.get element attribute    ${locator}@data-instruction-type
    should be equal as strings    ${type}    fileimport
    Element Text Should Be    ${locator}//div[@class='message']    ${text}

Check for Query Refresh Instruction
    [Arguments]    ${index}    ${text}
    [Documentation]    Checks for a Query Refresh instruction at the given position and with the specified text (Spreadsheet Web Editor)
    ...
    ...    *Arguments*
    ...
    ...    _index_ - the position of the fileimport instruction in the list (starting at 1)
    ...
    ...    _text_ - the text the instruction should have
    ...
    ...    *Prerequisites*
    ...
    ...    The spreadsheet web editor must be open and there must be some instructions present
    ...
    ...    Example
    ...
    ...    Check for Query Refresh Instruction | 1 | Search 1
    ${locator}=    set variable    xpath=//div[@class='instructions-container']/div/div[${index}]
    ${type}=    IDBSSelenium2Library.get element attribute    ${locator}@data-instruction-type
    should be equal as strings    ${type}    query
    Element Text Should Be    ${locator}//div[@class='middle']//div[@class='message']    ${text}

Group should be unticked
    [Arguments]    ${instruction_name}
    [Documentation]    Checks that an group at the given position is unticked (Spreadsheet Web Editor)
    ...
    ...    *Arguments*
    ...
    ...    _index_ - the position of the group in the list (starting at 1)
    ...
    ...
    ...    *Prerequisites*
    ...
    ...    The spreadsheet web editor must be open and there must be some instructions present
    ...
    ...    Example
    ...
    ...    Group should be unticked | 1
    ${locator}=    set variable    xpath=//div[@class='middle']/div[@class='instruction-container']/div[@class='message'][contains(text(),'${instruction_name}')]/../../preceding-sibling::div/div[@class='tick-wrapper']//i[@class='fa fa-lg notticked']
    Wait Until Page Contains Element    xpath=//div[@class='middle']/div[@class='instruction-container']/div[@class='message'][contains(text(),'${instruction_name}')]/../../preceding-sibling::div/div[@class='tick-wrapper']//i[@class='fa fa-lg notticked']    30s
    Element Should Be Visible    ${locator}

Group should be ticked
    [Arguments]    ${instruction_name}
    [Documentation]    Checks that the group at the given position is ticked (Spreadsheet Web Editor)
    ...
    ...    *Arguments*
    ...
    ...    _index_ - the position of the group in the list (starting at 1)
    ...
    ...
    ...    *Prerequisites*
    ...
    ...    The spreadsheet web editor must be open and there must be some instructions present
    ...
    ...    Example
    ...
    ...    Group should be unticked | 1
    ${locator}=    set variable    xpath=//div[@class='middle']/div[@class='instruction-container']/div[@class='message'][contains(text(),'${instruction_name}')]/../../preceding-sibling::div/div[@class='tick-wrapper']//i[@class='fa fa-lg ticked fa-check-circle']

    Wait Until Page Contains Element    xpath=//div[@class='middle']/div[@class='instruction-container']/div[@class='message'][contains(text(),'${instruction_name}')]/../../preceding-sibling::div/div[@class='tick-wrapper']//i[@class='fa fa-lg ticked fa-check-circle']    30s
    Element Should Be Visible    ${locator}

Collapse Group
    [Arguments]    ${index}
    [Documentation]    Collapses the group at the specified position. if the group is already collapsed then it is left alone (Spreadsheet Web Editor)
    ...
    ...    *Arguments*
    ...
    ...    _index_ - the position of the group instruction in the list (starting at 1)
    ...
    ...
    ...    *Prerequisites*
    ...
    ...    The spreadsheet web editor must be open and there must be some instructions present (and the instruction specified must be tickable)
    ...
    ...    Example
    ...
    ...    Collapse Group | 1
    ${locator}=    set variable    //div[@class='instructions-container']/div/div[${index}]
    # check it is a group
    ${type}=    IDBSSelenium2Library.get element attribute    ${locator}@data-instruction-type
    run keyword if    '${type}' != 'group'    fail    trying to collapse a non group instruction: ${type}
    # check it is expanded and so can be collapsed
    ${indicator locator}=    set variable    ${locator}/div[@class='expander']/i[@class='fa fa-caret-down']
    ${status}    ${msg}=    run keyword and ignore error    Element Should Be Visible    ${indicator locator}
    run keyword if    '${Status}' == 'PASS'    Robust Click    ${indicator locator}
    # wait for collapse to occur
    run keyword if    '${Status}' == 'PASS'    Element Should Be Visible    ${locator}/div[@class='expander']/i[@class='fa fa-caret-right']

Expand Group
    [Arguments]    ${index}
    [Documentation]    Expands the group at the specified position. if the group is already expanded then it is left alone (Spreadsheet Web Editor)
    ...
    ...    *Arguments*
    ...
    ...    _index_ - the position of the group instruction in the list (starting at 1)
    ...
    ...
    ...    *Prerequisites*
    ...
    ...    The spreadsheet web editor must be open and there must be some instructions present (and the instruction specified must be tickable)
    ...
    ...    Example
    ...
    ...    Expand Group | 1
    ${locator}=    set variable    //div[@class='instructions-container']/div/div[${index}]
    # check it is a group
    ${type}=    IDBSSelenium2Library.get element attribute    ${locator}@data-instruction-type
    run keyword if    '${type}' != 'group'    fail    trying to expand \ a non group instruction: ${type}
    # check it is expanded and so can be collapsed
    ${indicator locator}=    set variable    ${locator}/div[@class='expander']/i[@class='fa fa-caret-right']
    ${status}    ${msg}=    run keyword and ignore error    Element Should Be Visible    ${indicator locator}
    run keyword if    '${Status}' == 'PASS'    Robust Click    ${indicator locator}
    # wait for expand to occur
    run keyword if    '${Status}' == 'PASS'    Element Should Be Visible    ${locator}/div[@class='expander']/i[@class='fa fa-caret-down']

Press Done
    [Arguments]    ${index}
    [Documentation]    Presses the done instruction at the specified index.(Spreadsheet Web Editor)
    ...
    ...    *Arguments*
    ...
    ...    _index_ - the position of the instruction in the list (starting at 1)
    ...
    ...
    ...    *Prerequisites*
    ...
    ...    The spreadsheet web editor must be open and there must be some instructions present (and the instruction specified must be tickable)
    ...
    ...    Example
    ...
    ...    Press Done \ | 5
    # make sure it is actually a done instruction
    ${type}=    IDBSSelenium2Library.Get Element Attribute    xpath=//div[@class='instructions-container']/div/div[${index}]@data-instruction-type
    Should Be Equal As Strings    ${type}    done
    ${locator}=    set variable    xpath=//div[@class='instructions-container']/div/div[${index}]/div
    click element    ${locator}

Click on Navigation Instruction
    [Arguments]    ${instruction_name}
    [Documentation]    Clicks on the \ navigation instruction at the given position (Spreadsheet Web Editor)
    ...
    ...    *Arguments*
    ...
    ...    instruction_name - the name of the instruction
    ...
    ...
    ...    *Prerequisites*
    ...
    ...    The spreadsheet web editor must be open and there must be some instructions present
    ...
    ...    Example
    ...
    ...    Click on navigation Instruction | View Summary
    #${locator}=    set variable    xpath=//div[@class='instructions-container']/div/div[${index}]//div[@class='action-panel']//div[@class='action-button']
    ${locator}=    set variable    xpath=//div[@class='message'][contains(text(),'${instruction_name}')]/../div[@class='action-panel']/div[@class='action-button']
    Robust Click    ${locator}

Click on File Import Instruction
    [Arguments]    ${instruction_name}
    [Documentation]    Clicks on the \ File Import instruction at the given position (Spreadsheet Web Editor)
    ...
    ...    *Arguments*
    ...
    ...    _index_ - the position of the file import instruction in the list (starting at 1)
    ...
    ...
    ...    *Prerequisites*
    ...
    ...    The spreadsheet web editor must be open and there must be some instructions present
    ...
    ...    Example
    ...
    ...    Click on file import Instruction | 1
    ${locator}=    set variable    //div[@class='message'][contains(text(),'${instruction_name}')]/../div[@class='fileimport-button fa fa-chevron-right fa-1']
    click element    ${locator}

Click on Query Refresh Instruction
    [Arguments]    ${index}
    [Documentation]    Clicks on the Query Refresh instruction at the given position (Spreadsheet Web Editor)
    ...
    ...    *Arguments*
    ...
    ...    _index_ - the position of the query refresh instruction in the list (starting at 1)
    ...
    ...
    ...    *Prerequisites*
    ...
    ...    The spreadsheet web editor must be open and there must be some instructions present
    ...
    ...    Example
    ...
    ...    Click on Query Refresh Instruction | 1
    ${locator}=    set variable    xpath=//div[@class='instructions-container']/div/div[${index}]//div[@class='action-panel']//div[@class='action-button']
    click element    ${locator}

Progress for instruction is incomplete
    [Arguments]    ${index}
    [Documentation]    Checks that the progress for an instruction at the given position is incomplete (Spreadsheet Web Editor)
    ...
    ...    *Arguments*
    ...
    ...    _index_ - the position of the instruction in the list (starting at 1)
    ...
    ...
    ...    *Prerequisites*
    ...
    ...    The spreadsheet web editor must be open and there must be some instructions present
    ...
    ...    Example
    ...
    ...    Instruction should be unticked | 1
    ...    Progress for instruction is incomplete | 1
    ${zero_base_index}=    Evaluate    ${index}-1
    ${td_locator}=    Set Variable    xpath=//div[@class='progress-panel']//td[@data-segment-index='${zero_base_index}']
    ${locator}=    set variable    xpath=//div[@class='progress-panel']//td[@data-segment-index='${zero_base_index}']/div[@class='incomplete']
    # incomplete elements are \ zero width & it appears that IE11 is "smart" and doesn't display that element at all, so need an alternate check for IE path
    Run Keyword Unless    '${BROWSER}'=='IE'    Element Should Be Visible    ${locator}
    Run Keyword If    '${BROWSER}'=='IE'    Element Should Be Visible    ${td_locator}
    Run Keyword If    '${BROWSER}'=='IE'    Page Should Contain Element    ${locator}

Progress for instruction is complete
    [Arguments]    ${index}
    [Documentation]    Checks that the progress for an instruction at the given position is complete (Spreadsheet Web Editor)
    ...
    ...    *Arguments*
    ...
    ...    _index_ - the position of the instruction in the list (starting at 1)
    ...
    ...
    ...    *Prerequisites*
    ...
    ...    The spreadsheet web editor must be open and there must be some instructions present
    ...
    ...    Example
    ...
    ...    Instruction should be unticked | 1
    ...    Progress for instruction is incomplete | 1
    ${zero_base_index}=    Evaluate    ${index}-1
    ${locator}=    set variable    xpath=//div[@class='progress-panel']//td[@data-segment-index='${zero_base_index}']/div[@class='complete']
    Wait Until Element Is Visible    ${locator}    10s

Instruction should be visible
    [Arguments]    ${index}
    [Documentation]    Checks that an instruction at the given position is visible (i.e. not collapsed as part of a group) (Spreadsheet Web Editor)
    ...
    ...    *Arguments*
    ...
    ...    _index_ - the position of the instruction in the list (starting at 1)
    ...
    ...
    ...    *Prerequisites*
    ...
    ...    The spreadsheet web editor must be open and there must be some instructions present
    ...
    ...    Example
    ...
    ...    Instruction should be visible | 1
    ${locator}=    set variable    //div[@class='instructions-container']/div/div[${index}]
    Wait Until Element Is Visible    ${locator}    10s

Instruction should not be visible
    [Arguments]    ${index}
    [Documentation]    Checks that an instruction at the given position is not visible (i.e. not collapsed as part of a group) (Spreadsheet Web Editor)
    ...
    ...    *Arguments*
    ...
    ...    _index_ - the position of the instruction in the list (starting at 1)
    ...
    ...
    ...    *Prerequisites*
    ...
    ...    The spreadsheet web editor must be open and there must be some instructions present
    ...
    ...    Example
    ...
    ...    Instruction should not be visible | 5
    ${locator}=    set variable    //div[@class='instructions-container']/div/div[${index}]
    Element Should Not Be Visible    ${locator}

Insert FileImport Instruction Label
    [Arguments]    ${insert_text}
    [Documentation]    Selects the file import \ instruction label and types text into it
    ...
    ...    _Pre-condition_
    ...
    ...    * The Instruction Set Designer dialog needs to be open in the Spreadsheet Designer
    ...
    ...    * The file import instruction must have been selected from the instruction set picker
    Wait Until Keyword Succeeds    20s    1s    Select Dialog    ${InstructionSheetDialog}
    Click On Component    FileImportLabel    1
    Type To Component    FileImportLabel    ${insert_text}

Click on Action Button Instruction
    [Arguments]    ${index}
    [Documentation]    Clicks on an instruction's action button in the web spredsheet editor.
    ...
    ...    ${index} - The index of the instruction (starting at 1)
    ${locator}=    set variable    xpath=//div[@class='instructions-container']/div/div[${index}]//div[@class='action-panel']//div[@class='action-button']
    Robust Click    ${locator}

Click on Panel Opening Chevron Instruction
    [Arguments]    ${index}    ${type}
    [Documentation]    Clicks on an instruction's panel opening chevron in the web. The chevron element must have a classs type ending in '-chevron fa fa-chevron-right fa-1'
    ...
    ...    Args:
    ...    ${index} - the instruction index (starting at 1)
    ...    ${type} - The instruction type
    ${locator}=    set variable    xpath=//div[@class='instructions-container']/div/div[${index}]//div[@class='${type}-chevron fa fa-chevron-right fa-1']
    click element    ${locator}

Add Instrument Reader Instruction
    [Arguments]    ${action_index}    ${config_index}=${EMPTY}    ${display_text}=${EMPTY}
    [Documentation]    Configures an Instrument reader instruction in the Spreadsheet Designer.
    ...
    ...    Args:
    ...    -${action_index} - the index of the action that you wish the instruction to perform
    ...    -${config_index} - If applicable to the instruction, the index of the configuration you wish the instruction to use.
    ...    ${display_text} - If applicable to the instruction, the text to display on the instruction.
    ...
    ...    *Pre-condition:* Instruction Set Designer Window has already been opened
    Wait Until Keyword Succeeds    10s    1s    Click on Component    AddInstructionType
    Wait Until Keyword Succeeds    10s    1s    Activate Dialog    InstructionTypeSelector
    Click on Component    NewInstruction-instrumentreader
    Activate Dialog    regexp=Instruction Set Designer
    Select From Combo Box    actionNameCombo    ${action_index}
    Run Keyword IF    '${config_index}'    Select From Combo Box    InstrumentReaderInstructionPropertiesEditor.name    ${config_index}
    Run Keyword IF    '${display_text}'    Type Into Text Field    text-instruction-text    ${display_text}

Check for Instruction Type
    [Arguments]    ${index}    ${type}    ${text}=${EMPTY}
    [Documentation]    Checks for an Instruction in the web spreadsheet editor.
    ...
    ...    Args:
    ...    - ${index} - The index of the instruction (starting at 1)
    ...    - ${type} - The instruction type
    ...    - ${text} - The display text, if applicable
    ...
    ...    *Precondition:* The Instructions panel must be open in the web spreadsheet
    ${locator}=    set variable    xpath=//div[@class='instructions-container']/div/div[${index}]
    ${displayed_type}=    IDBSSelenium2Library.get element attribute    ${locator}@data-instruction-type
    Log    ${displayed_type}
    Log    ${type}
    should be equal as strings    ${displayed_type}    ${type}
    Log    ${text}
    Run Keyword IF    '${text}'    Element Text Should Be    ${locator}//div[@class='middle']//div[@class='message']    ${text}
