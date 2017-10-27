*** Settings ***
Library           OperatingSystem
#Library           PyWinAutoLibrary
Library           IDBSSwingLibrary
Library           IDBSSelenium2Library
Library           RobotRemoteAgent
Library           SystemUtilitiesLibrary
Library           String

*** Variables ***

*** Keywords ***
Check Item Exists in navigator Tree
    [Arguments]    ${item_path}    ${timeout}=60sec
    Wait Until Keyword Succeeds    ${timeout}    5s    Open Navigator Tree to Item    ${item_path}

Clean Up E-WorkBook
    Run Keyword And Ignore Error    Close All Dialogs
    Comment    Kill any remaining thick clients
    Kill Processes With Name    EWBClient.exe
    Comment    Get client log
    ${local_app_data}=    Get Environment Variable    LOCALAPPDATA    %{USERPROFILE}/Local Settings/Application Data    # XP only has a USERPROFILE variable, WINDOWS 7 has LOCALAPPDATA
    ${ewb_log_file_path}=    Set Variable    ${local_app_data}/IDBS/E-WorkBook Client/EWBClient.log
    ${log_exists}    ${message}=    Run Keyword And Ignore Error    File Should Not Exist    ${ewb_log_file_path}    Log file exists.
    Run Keyword Unless    '${log_exists}'=='PASS'    Save log file    ${ewb_log_file_path}
    Remove File    ${ewb_log_file_path}

Close E-WorkBook
    [Documentation]    Closes E-WorkBook. If any confirm save dialogs pop-up, it clicks the No button.
    ...
    ...    After 20 seconds, it forcibly kills the EWBClient process, if it still exisst.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window.
    ...
    ...    *Example*
    ...    | Close E-WorkBook |
    Select E-WorkBook Main Window
    Select from E-WorkBook Main Menu    File    Exit
    Select Dialog    Confirm Exit    60
    Push Button    text=Yes
    ${save_confirm_dialog_is_open}    ${message}=    Run Keyword And Ignore Error    Select Dialog    SaveConfirmDialog    2
    Run Keyword If    '${save_confirm_dialog_is_open}'=='PASS'    Push Button    text=No
    Sleep    3s    Give E-WorkBook time to close down fully

Close E-WorkBook Tab
    [Arguments]    ${tab_name}
    [Documentation]    Closes a tab in EWB given the Tabs name
    ...
    ...    Requires that the tab be open and visible and that the E-WorkBook Main Window is selected
    ...
    ...    *Arguments*
    ...    _tab_name_
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    E-WorkBook Main Window is selected and tab is visible
    ...
    ...    *Example*
    ...    | Select E-WorkBook Main Window | \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ |
    ...    | Close E-WorkBook Tab | Home |
    IDBSSwingLibrary.Set Jemmy Timeout    ComponentOperator.WaitComponentTimeout    1
    Click On Label    text=${tab_name}
    Push Button    xpath=//*[contains(@class,'CloseButton') and @showing='true']
    Select E-WorkBook Main Window
    ${old_component_timeout}=    IDBSSwingLibrary.Set Jemmy Timeout    ComponentOperator.WaitComponentTimeout    1
    Wait Until Keyword Succeeds    120s    2s    Label Should Not Exist    text=${tab_name}
    IDBSSwingLibrary.Set Jemmy Timeout    ComponentOperator.WaitComponentTimeout    ${old_component_timeout}

Close E-WorkBook sketch tool
    Select Window    regexp=.*Sketch Tool    120
    Close Window    regexp=.*Sketch Tool
    Select E-WorkBook Main Window

Close E-WorkBook spreadsheet
    Disable Taking Screenshots On Failure
    IDBSSwingLibrary.Select Window    regexp=.*Spreadsheet    120
    Enable Taking Screenshots On Failure
    IDBSSwingLibrary.Close Window    regexp=.*Spreadsheet
    Select E-WorkBook Main Window

Login to E-WorkBook
    [Arguments]    ${server}    ${username}    ${password}    ${check_message_of_the_day}=${EMPTY}
    [Documentation]    Logs into e-WorkBook using the supplied username, password and server.
    ...
    ...    Prior to logging in, it tries to close any open E-WorkBook windows and kills any E-WorkBook processes that are still left after its has tried to close all the windows. If it has to close or kill anything it logs a warning.
    ...
    ...    Once everything has been shut down, it minimises all the windows and launches E-WorkBook using the shortcut on the desktop. It performs a login using the server, username and password supplied. Once E-WorkBook has logged in, any Messages of the day or Tip of the days are dismissed and the E-WorkBook windows is placed in a standard position and resized to be a standard size.
    ...
    ...    *Arguments*
    ...    _server_
    ...    The machine name or ip addressof the E-WorkBook server to log into. *This needs to included the port as well.*
    ...    _username_
    ...    The username to use for the login.
    ...    _password_
    ...    The password to use for the login.
    ...    _check_message_of_the_day_
    ...    (optional) If this is specified, the keyword checks that the message of the day is as supplied in this variable value.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects E-WorkBook to be installed on the test machine and a icon to be on the desktop.
    ...
    ...    *Example*
    ...    | Login to E-WorkBook | server=vpcsewbauto1:5277 | username=Biochem | password=Biochem | |
    ...    | Login to E-WorkBook | server=vpcsewbauto1:5277 | username=Biochem | password=Biochem | check_message_of_the_day=This is the message of the day. |
    ${output}=    Kill Processes With Name    EWBClient.exe
    Log    ${output}
    Comment    Delete any experiment backups
    Run Keyword And Ignore Error    Empty Directory    %{APPDATA}/IDBS/E-WorkBook Client/Backup/Experiments
    Comment    Minimise All Windows
    Start Java Application    EWB-Client    C:/Progra~1/IDBS/E-Workbook/EWBClient/EWBClient.exe    timeout=5 Minutes    webstart_main_class_regexp=com.kensingtonspace.client.webstart.WebProcess
    Log    Application launched
    Wait Until Keyword Succeeds    2m    2s    IDBSSwingLibrary.Load Library Into Remote Application
    Disable Taking Screenshots On Failure
    ${activated_window}=    Run Keyword and Return Status    Activate Window    IDBS E-WorkBook Login    180
    Run Keyword Unless    ${activated_window}    Capture Swing Screenshot and Fail    Failed to activate Login window
    Enable Taking Screenshots On Failure
    Insert Into Text Field    xpath=//*[contains(@class,'JStringField')]    ${username}
    Insert Into Text Field    xpath=//*[contains(@class,'JStringPasswordField')]    ${password}
    Wait Until Keyword Succeeds    120 seconds    5 seconds    Type Into Combobox    0    ${server}
    Push Button    text=OK
    Wait Until Keyword Succeeds    180 seconds    0.5 seconds    _Is E-WorkBook Ready
    Sleep    3s    Wait for E-WorkBook to really be ready

Move Cursor to Staus bar
    [Documentation]    Move the cursor to the E-WorkBook client status bar.
    Click On Component At Coordinates    class=WorkbenchStatusBarImpl$1    10    10

Open Navigator Tree to Item
    [Arguments]    ${item_path}
    ${pipe_separated_path}=    Replace String    ${item_path}    /    |
    ewb_thick_client_general_actions_resource.Refresh Navigator Tree
    Clear Tree Selection    class=WorkbenchNavigatorTree
    @{parts}=    Split String From Right    ${pipe_separated_path}    |
    ${parent_path}=    Set Variable    ${EMPTY}
    : FOR    ${level_index}    IN RANGE    len(${parts})-1
    \    Run Keyword If    ${level_index}==0    Expand Tree Node    class=WorkbenchNavigatorTree    @{parts}[${level_index}]
    \    Run Keyword If    ${level_index}>0    Expand Tree Node    class=WorkbenchNavigatorTree    ${parent_path}|@{parts}[${level_index}]
    \    ${parent_path}=    Set Variable If    '${parent_path}'==''    @{parts}[${level_index}]    ${parent_path}|@{parts}[${level_index}]
    Select Tree Node    class=WorkbenchNavigatorTree    ${pipe_separated_path}
    Tree Node Should Exist    class=WorkbenchNavigatorTree    ${pipe_separated_path}

Refresh Navigator Tree
    [Documentation]    Refreshes the E-Workbook Navigator tree
    Select E-WorkBook Main Window
    Push Button    xpath=//*[contains(@tooltip,'Refresh navigator display')]
    Wait for glass pane to disappear

Robust close dialog
    [Arguments]    ${dialogname}    ${Buttonname}
    ${status}    ${check}=    Run Keyword And Ignore Error    IDBSSwingLibrary.Dialog Should Not Be Open    ${dialogname}
    Run Keyword If    '${status}'!='PASS'    Push Button    ${Buttonname}
    Run Keyword If    '${status}'=='PASS'    Robust close dialog    ${dialogname}    ${Buttonname}

Save log file
    [Arguments]    ${ewb_log_file_path}
    Comment    Replace colon, slashes and space in test name as they cause problems in a file name
    ${sanitised_test_name}=    Replace String    ${TEST NAME}    :    ${EMPTY}
    ${sanitised_test_name}=    Replace String    ${sanitised_test_name}    ${SPACE}    _
    ${sanitised_test_name}=    Replace String    ${sanitised_test_name}    /    ${EMPTY}
    ${sanitised_test_name}=    Replace String    ${sanitised_test_name}    \\    ${EMPTY}
    ${saved_log_file}=    Set Variable    ${OUTPUT DIR}/${sanitised_test_name}_EWBClient.log
    Copy File    ${ewb_log_file_path}    ${saved_log_file}
    ${errors}=    Grep File    ${saved_log_file}    ERROR
    Should Be Empty    ${errors}    There were some errors recorded in the client log file. Check ${saved_log_file}

Select E-WorkBook Main Window
    IDBSSwingLibrary.Select Window    regexp=IDBS E-WorkBook.*    60
    Wait for glass pane to disappear

Select From Navigator Tree Right-click Menu
    [Arguments]    ${tree_item}    ${menu_item}
    # make multiple attempts in case the first one fails
    Wait Until Keyword Succeeds    60s    2s    __Single Attempt Select From Navigator Tree Right-click Menu    ${tree_item}    ${menu_item}

Select from E-WorkBook Main Menu
    [Arguments]    ${level1}    ${level2}    ${level3}=${EMPTY}    ${level4}=${EMPTY}
    ${old_component_timeout}=    Set Jemmy Timeout    ComponentOperator.WaitComponentTimeout    10
    Wait Until Keyword Succeeds    180s    5s    Select From Main Menu And Wait    ${level1}|${level2}    # Sometimes it takes time for the menu to load
    Set Jemmy Timeout    ComponentOperator.WaitComponentTimeout    ${old_component_timeout}
    Run Keyword If    "${level3}"!="${EMPTY}"    Click On Component    xpath=//*[contains(@class,'JPopupMenu')]//*[text()='${level3}']
    Run Keyword If    "${level4}"!="${EMPTY}"    Click On Component    xpath=//*[contains(@class,'JPopupMenu')]//*[text()='${level4}']

Thick client teardown
    Clean Up E-WorkBook

Wait for Dialog
    [Arguments]    ${window_description}    ${timeout}=180s    ${frequency}=5s
    ${old_dialog_timeout}=    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout    1
    Wait Until Keyword Succeeds    ${timeout}    ${frequency}    Select Dialog    ${window_description}
    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout    ${old_dialog_timeout}

Wait for Window
    [Arguments]    ${window_description}    ${timeout}=180    ${frequency}=5
    ${old_window_timeout}=    Set Jemmy Timeout    WindowWaiter.WaitWindowTimeout    1
    Select Window    ${window_description}    ${timeout}
    Set Jemmy Timeout    WindowWaiter.WaitWindowTimeout    ${old_window_timeout}

Wait for glass pane to disappear
    Wait For Component To Not Have Visible Flag    class=BusyGlassPane    600

_Is E-WorkBook Ready
    Disable Taking Screenshots On Failure
    Activate Window    regexp=IDBS E-WorkBook.*    1
    ${message_of_the_day_is_open}    ${message}=    Run Keyword And Ignore Error    Select Dialog    Message of the Day    1
    Run Keyword If    '${message_of_the_day_is_open}'=='PASS'    Push Button    text=Continue
    ${tip_of_the_day_is_open}    ${message}=    Run Keyword And Ignore Error    Select Dialog    Tip of the Day    1
    Run Keyword If    '${tip_of_the_day_is_open}'=='PASS'    Push Button    text=Close
    Activate Window    regexp=IDBS E-WorkBook - Home Page    1
    [Teardown]    Enable Taking Screenshots On Failure

__Single Attempt Select From Navigator Tree Right-click Menu
    [Arguments]    ${tree_item}    ${menu_item}
    # make multiple attempts in case the first one fails
    ${pipe_separated_path}=    Replace String    ${tree_item}    /    |
    Open Navigator Tree to Item    ${pipe_separated_path}
    ${old_window_timeout}=    Set Jemmy Timeout    WindowWaiter.WaitWindowTimeout    1
    ${old_menu_push_timeout}=    Set Jemmy Timeout    JMenuOperator.PushMenuTimeou    5
    Select From Tree Node Popup Menu    class=WorkbenchNavigatorTree    ${pipe_separated_path}    ${menu_item}
    Set Jemmy Timeout    WindowWaiter.WaitWindowTimeout    ${old_window_timeout}
    Set Jemmy Timeout    JMenuOperator.PushMenuTimeou    ${old_menu_push_timeout}

Capture Swing Screenshot and Fail
    [Arguments]    ${failure_message}
    [Documentation]    Takes a screenshot of the java application currently connected to by the Swing library and then fails with the given message.
    ...
    ...
    ...    This keyword takes a failure message as an argument, which will be included in the log when the failure occurs.
    Capture Swing Screenshot
    Fail    ${failure_message} - For the screenshot, expand 'Capture Swing Screenshot and Fail' > 'Capture Swing Screenshot' > 'Run Keyword and Ignore Error' > 'Component Should Exist' > 'Component Should Exist' in the log.

Capture Swing Screenshot
    [Documentation]    Takes a screenshot of the java application currently connected to by the Swing library. Since there is no library keyword for this, it is achieved by running 'component should be visible' for an invalid locator.
    Run Keyword and Ignore Error    Enable Taking Screenshots On Failure    # Just in case it's off
    Run Keyword And Ignore Error    Component Should Exist    supercalifragilisticexpialidocious    1    #Super quick timeout because this \ should always fail

Kill All E-WorkBook Clients
    Kill Processes With Name    EWBClient.exe
