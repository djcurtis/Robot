*** Settings ***
Resource          ewb_thick_client_general_actions_resource.robot
Library           String
#Library           PyWinAutoLibrary
Library           CheckLibrary
Library           IDBSSwingLibrary
Library           RobotRemoteAgent

*** Keywords ***
Change record layout
    [Arguments]    ${paper size}=${EMPTY}    ${Portrait or Landscape}=${EMPTY}    ${horizontal margin}=${EMPTY}    ${vertical margin}=${EMPTY}    ${OK or Cancel}=${EMPTY}
    [Documentation]    Keyword opens the page setup menu from an EWB record and allows the user to select the page layout settings and apply or cancel them.
    ...
    ...    *Arguments*
    ...
    ...    _paper size_
    ...    a numeric value, select from the list as an index, e.g.: A3 = 0, A4 = 1, Letter = 4, etc.
    ...
    ...    _Portrait or Landscape_
    ...    sets the page to portrait or landscape, only accepts the (case sensitive) inputs Portrait or Landscape
    ...
    ...    _horizontal margin_
    ...    an integer value between 1 and 30
    ...
    ...    _vertical margin_
    ...    an integer value between 1 and 30
    ...
    ...    _OK or Cancel_
    ...    keyword presses the OK or Cancel buttons, only accepts the OK or Cancel (case sensitive) inputs
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    An open EWB record
    ...
    ...    *Example*
    ...    | Select Window | IDBS E-WorkBook - Workbook Editor | | | | |
    ...    | Change record layout | 4 | Landscape | 10 | 20 | OK |
    ...    | Change record layout | ${paper size} | ${Portrait or Landscape} | ${horizontal margin} | ${vertical margin} | ${OK or Cancel} |
    ...    This changes the page layout to letter, landscape with 10 and 20 mm margins
    Select Window    IDBS E-WorkBook - Workbook Editor
    Select From Menu    File|Page Setup...
    Select Dialog    Page Setup    30
    Run Keyword If    '${paper size}'!='${EMPTY}'    Select From Combo Box    class=JComboBox    ${paper size}
    Run Keyword If    '${Portrait or Landscape}'!='${EMPTY}'    Push Radio Button    text=${Portrait or Landscape}
    Run Keyword If    '${horizontal margin}'!='${EMPTY}'    Set Spinner Number Value    0    ${horizontal margin}
    Run Keyword If    '${vertical margin}'!='${EMPTY}'    Set Spinner Number Value    1    ${vertical margin}
    Run Keyword If    '${OK or Cancel}'!='${EMPTY}'    Push Button    text=${OK or Cancel}
    Run Keyword If    '${OK or Cancel}'!='${EMPTY}'    Select Window    IDBS E-WorkBook - Workbook Editor    30

Change staus of current experiment to
    [Arguments]    ${new_status}
    [Documentation]    Changes the status of the current experiment.
    ...
    ...    *Arguments*
    ...    _new_status_
    ...    Status the experiment should have after the change.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with an experiment open and the current tab.
    ...
    ...    *Example*
    ...    | Change staus of current experiment to | Completed |
    Select from E-WorkBook Main Menu    Record    Properties...
    Select Dialog    regexp=Properties .*
    Push Button    statusName_editor_button
    Wait Until Keyword Succeeds    60 seconds    2 seconds    Click On List Item    class=JList    ${new_status}
    Push Button    text=OK
    Select E-WorkBook Main Window

Change tab
    [Arguments]    ${tabname}
    Select from E-WorkBook Main Menu    Window    ${tabname}

Check experiment status for ${experiment_path} is
    [Arguments]    ${expected_status}
    [Documentation]    Verify that the status for the experiment specified \ is as expected.
    ...
    ...    This uses right-click > Properties option on the navigator tree to display the options dialog.
    ...
    ...    *Arguments*
    ...    _experiment_path_
    ...    Path of the experiment to check.
    ...
    ...    _expected_status_
    ...    Expected status.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with the navigator tree visible.
    ...
    ...    *Example*
    ...    | Check experiment status for \Root\Testing\Florian\Test Experiment is | Completed |
    ${pipe_separated_path}=    Replace String    ${experiment_path}    /    |
    ${old_timeout}=    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    1
    Check Item Exists in navigator Tree    ${pipe_separated_path}
    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    ${old_timeout}
    Select From Navigator Tree Right-click Menu    ${pipe_separated_path}    .*Properties.*
    Select Dialog    regexp=Properties.*
    ${actual_status}=    Get Text Field Value    statusName_editor_textField
    Check String Equals    Verify status of experiment is as expected.    ${actual_status}    ${expected_status}    0
    Push Button    Cancel
    Select E-WorkBook Main Window

Check experiment version for ${experiment_path} is
    [Arguments]    ${expected_version}
    [Documentation]    Verify that the version for the experiment specified is as expected.
    ...
    ...    This uses right-click > Properties option on the navigator tree to display the options dialog.
    ...
    ...    *Arguments*
    ...    _experiment_path_
    ...    Path of the experiment to check.
    ...
    ...    _expected_version_
    ...    Expected experiment version.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with the navigator tree visible.
    ...
    ...    *Example*
    ...    | Check experiment version for \Root\Testing\Florian\Test Experiment is | 2 |
    ${pipe_separated_path}=    Replace String    ${experiment_path}    /    |
    ${old_timeout}=    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    1
    Check Item Exists in navigator Tree    ${pipe_separated_path}
    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    ${old_timeout}
    Select From Navigator Tree Right-click Menu    ${pipe_separated_path}    .*Properties.*
    Select Dialog    regexp=Properties.*
    ${actual_version}=    Get Text Field Value    Version number field
    Check Number Equals    Verify versionumber of experiment is as expected.    ${actual_version}    ${expected_version}    0
    Push Button    Cancel
    Select E-WorkBook Main Window

Check for popup warning
    ${status}    ${check}=    Run Keyword And Ignore Error    Dialog Should Not Be Open    Use Experiment
    run keyword if    '${status}'=='FAIL'    _close use experiment dialog

Check save compliance message is
    [Arguments]    ${message}
    [Documentation]    This keyword starts to performs a version save on the current experiment unitil it gets to the username & password dialog and then checks that the sign-off message is as expected. Once the sign-off message has been checked the version save gets cancelled.
    ...
    ...    *Arguments*
    ...
    ...    _message_
    ...    The expected sign-off message
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with an experiment open and the current tab. The experiment also needs to have changes that haven't been saved as a version for the version save to be successful.
    ...
    ...    *Example*
    ...    | Check save compliance message is | ${COMPLIANCE_MESSAGE} |
    Push Button    /root/core1/RecordSaveVersionBBBBBBBBBBBBBBBBBBB
    Select Dialog    Authentication
    ${actual_compliance_message}=    Get Text Field Value    authenticationDialogLegalText
    Check String Equals    Check that the save compliance message is as expected    ${message}    ${actual_compliance_message}    ${True}
    Close Dialog    Authentication
    Select E-WorkBook Main Window

Close current experiment
    [Documentation]    Closes the current experiment. It does not handle any unsaved changes warnings.
    ...
    ...    Note: This is an alias for "Close current record entity"
    ...
    ...    *Arguments*
    ...
    ...    None
    ...
    ...    *Return value*
    ...
    ...    None
    ...
    ...    *Precondition*
    ...
    ...    This keyword expects an open E-WorkBook window with an experiment open and the current tab. The experiment can't have any unsaved changes.
    ...
    ...    *Example*
    ...
    ...    | Close current experiment |
    Close current record entity

Close current record entity
    [Documentation]    Closes the current record entity tab. It does not handle any unsaved changes warnings.
    ...
    ...    *Arguments*
    ...
    ...    None
    ...
    ...    *Return value*
    ...
    ...    None
    ...
    ...    *Precondition*
    ...
    ...    This keyword expects an open E-WorkBook window with a record entity open and the current tab. The entity can't have any unsaved changes.
    ...
    ...    *Example*
    ...
    ...    | Close current record entity |
    Push Button    xpath=//*[contains(@class,'CloseButton') and @showing='true']
    Select E-WorkBook Main Window
    Sleep    1    Give E-WorkBook time to redraw the navigator tree

Close current report
    [Documentation]    Closes the current report. It does not handle any unsaved changes warnings.
    ...
    ...    Note: This is an alias for "Close current record entity"
    ...
    ...    *Arguments*
    ...
    ...    None
    ...
    ...    *Return value*
    ...
    ...    None
    ...
    ...    *Precondition*
    ...
    ...    This keyword expects an open E-WorkBook window with an report open and the current tab. The report can't have any unsaved changes.
    ...
    ...    *Example*
    ...
    ...    | Close current report |
    Close current record entity

Close current template
    [Documentation]    Closes the current template. It does not handle any unsaved changes warnings.
    ...
    ...    Note: This is an alias for "Close current record entity"
    ...
    ...    *Arguments*
    ...
    ...    None
    ...
    ...    *Return value*
    ...
    ...    None
    ...
    ...    *Precondition*
    ...
    ...    This keyword expects an open E-WorkBook window with an template open and the current tab. The template can't have any unsaved changes.
    ...
    ...    *Example*
    ...
    ...    | Close current template |
    Close current record entity

Copy record entity
    [Arguments]    ${source_path}    ${destination_container}    ${destination_name}
    ${pipe_separated_destination_container}=    Replace String    ${destination_container}    /    |
    ${old_timeout}=    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    1
    Tree Node Should Not Exist    class=WorkbenchNavigatorTree    ${pipe_separated_destination_container}|${destination_name}
    ${pipe_separated_source_path}=    Replace String    ${source_path}    /    |
    Select From Navigator Tree Right-click Menu    ${pipe_separated_source_path}    .*Copy\\.\\.\\..* \ \ \ \ \
    Select Dialog    Copy Hierarchy    5
    Push Button    text=...
    Select Dialog    Select 'Copy to' destination    5
    Wait Until Keyword Succeeds    60s    1s    Tree Node Should Exist    class=NavigatorTree    ${pipe_separated_destination_container}
    Select Tree Node    class=NavigatorTree    ${pipe_separated_destination_container}
    Tree Node Should Be Selected    class=NavigatorTree    ${pipe_separated_destination_container}
    Robust close dialog    Select 'Copy to' destination    OK
    Select Dialog    Copy Hierarchy    5
    Insert Into Text Field    title_editor_textField    ${destination_name}
    Push Button    OK
    Sleep    2s    Wait for copy to start
    Select E-WorkBook Main Window
    Check Item Exists in navigator Tree    ${pipe_separated_destination_container}|${destination_name}    300s
    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    ${old_timeout}

Create experiment
    [Arguments]    ${path}    ${name}    ${status}=${EMPTY}
    [Documentation]    This keyword creates an new Experiment with a given name. The new experiment is created under the container specified by the _path_ variable and will be named with _name_.
    ...
    ...    This uses the Create Record Entity keyword to do the work.
    ...
    ...    *Arguments*
    ...
    ...    _path_
    ...    The path under which the experiment should be created with the different levels separated by a / character. The path needs to start with Root.
    ...
    ...    _name_
    ...    The name for the new experiment
    ...
    ...    _status_
    ...    [optional] The status for the new experiment
    ...
    ...    *Return value*
    ...
    ...    _experiment_path_
    ...    The path of the complete experiment, including the path and the name of the experiment in the following format:
    ...    ${path}/${name}
    ...    e.g. Root/Biochem/P-Biochem/Biochem Workflow Experiment
    ...
    ...    *Precondition*
    ...
    ...    This keyword expects an open E-WorkBook window.
    ...
    ...    *Example*
    ...
    ...    | ${experiment_path}= | Create Experiment | /Root/Biochem/P-Biochem | Biochem Workflow Experiment | |
    ...    | ${experiment_path}= | Create Experiment | /Root/Biochem/P-Biochem | Biochem Workflow Experiment | Started |
    ${experiment_path}=    Create record entity    Experiment    ${path}    ${name}    ${status}
    [Return]    ${experiment_path}

Create experiment from entity
    [Arguments]    ${path}    ${name}    ${templatepath}    ${status}=${EMPTY}
    [Documentation]    This keyword creates an new Experiment with a given name from an existing experiment. The new experiment is created under the container specified by the _path_ variable and will be named with _name_.
    ...
    ...    This uses the Create Record Entity keyword to do the work.
    ...
    ...    *Arguments*
    ...
    ...    _path_
    ...    The path under which the experiment should be created with the different levels separated by a / character. The path needs to start with Root.
    ...
    ...    _name_
    ...    The name for the new experiment
    ...
    ...    _templatepath_
    ...    The path in the hierarchy where the experiment exists
    ...
    ...    _status_
    ...    [optional] The status for the new experiment
    ...
    ...    *Return value*
    ...
    ...    _experiment_path_
    ...    The path of the complete experiment, including the path and the name of the experiment in the following format:
    ...    ${path}/${name}
    ...    e.g. Root/Biochem/P-Biochem/Biochem Workflow Experiment
    ...
    ...    *Precondition*
    ...
    ...    This keyword expects an open E-WorkBook window.
    ...    The experiment you are creating from exists in the hierarchy under the project level
    ...
    ...    *Example*
    ...
    ...    | ${experiment_path}= | Create Experiment | /Root/Biochem/P-Biochem | Biochem/P-Biochem | Biochem Workflow Experiment | |
    ...    | ${experiment_path}= | Create Experiment | /Root/Biochem/P-Biochem | Biochem/P-Biochem | Biochem Workflow Experiment | Started |
    ${experiment_path}=    Create record from entity    Experiment    ${path}    ${name}    ${templatepath}    ${status}
    [Return]    ${experiment_path}

Create experiment using standard title
    [Arguments]    ${path}    ${standard_title}    ${status}
    [Documentation]    This keyword creates an new Experiment with a name that is selected from the list of standard experiment titles.
    ...
    ...    The new experiment is created under the container specified by the _path_ variable.
    ...
    ...    *Arguments*
    ...    _path_
    ...    The path under which the experiment should be created
    ...
    ...    _standard_title_
    ...    One of the value from the list of standard titles set-up in the E-WorkBook catalog.
    ...
    ...    _status_
    ...    The status of the new experiment.
    ...
    ...    *Return value*
    ...    _Experiment_path_
    ...    The path of the complete experiment, including the path and the name of the experiment in the following format:
    ...    ${path}/${name}{timestamp}
    ...    e.g. \ /Root/Biochem/P-Biochem \ Biochem Workflow Experiment/Test NameA343D3E
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window.
    ...
    ...    *Example*
    ...    | ${experiment_path}= | Create experiment using standard title | path=/Root/Biochem/P-Biochem | standard_title=New test title | status=New test status |
    ${Experiment_path}=    Create record entity    Experiment    ${path}    ${standard_title}    ${status}    ${True}
    [Return]    ${Experiment_path}

Create record entity
    [Arguments]    ${entity_type}    ${path}    ${name}    ${status}=${EMPTY}    ${is_standard_name}=${False}
    [Documentation]    This keyword creates an new record entity with a given name. The new experiment is created under the container specified by the _path_ variable and will be named with _name_.
    ...
    ...    *Arguments*
    ...
    ...    _entity_type_
    ...    Display name of the new record entity as defined in the flexible hierarchy.
    ...
    ...    _path_
    ...    The path under which the record entity should be created with the different levels separated by a / character. The path needs to start with Root.
    ...
    ...    _name_
    ...    The name for the new record entity
    ...
    ...    _status_
    ...    [optional] The status for the new record entity
    ...
    ...    *Return value*
    ...
    ...    _experiment_path_
    ...    The path of the complete record entity, including the path and the name of the record entity in the following format:
    ...    ${path}/${name}
    ...    e.g. Root/Biochem/P-Biochem/Biochem Workflow Special Experiment
    ...
    ...    *Precondition*
    ...
    ...    This keyword expects an open E-WorkBook window.
    ...
    ...    *Example*
    ...
    ...    | ${entity_path}= | Create Record Entity | Special Experiment | /Root/Biochem/P-Biochem | Biochem Workflow Special Experiment | |
    ...    | ${entity_path}= | Create Record Entity | Special Experiment | /Root/Biochem/P-Biochem | Biochem Workflow Special Experiment | Started |
    ${pipe_separated_path}=    Replace String    ${path}    /    |
    ${old_timeout}=    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    1
    Tree Node Should Not Exist    class=WorkbenchNavigatorTree    ${pipe_separated_path}|${name}
    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    ${old_timeout}
    Select From Navigator Tree Right-click Menu    ${pipe_separated_path}    New|${entity_type}...
    Select Dialog    New ${entity_type}
    Run Keyword If    "${status}"!="${EMPTY}"    Push Button    statusName_editor_button
    Run Keyword If    "${status}"!="${EMPTY}"    Wait Until Keyword Succeeds    60 seconds    2 seconds    Click On List Item    class=JList
    ...    ${status}
    Run Keyword Unless    ${is_standard_name}    Insert Into Text Field    title_editor_textField    ${name}
    Run Keyword If    ${is_standard_name}    Push Button    title_editor_button
    Run Keyword If    ${is_standard_name}    Wait Until Keyword Succeeds    60 seconds    2 seconds    Click On List Item    class=JList
    ...    ${name}
    Push Button    text=OK
    IDBSSwingLibrary.Select Window    IDBS E-WorkBook - Workbook Editor    60
    Wait for glass pane to disappear
    Sleep    2s    Wait for E-WorkBook to actually load the entity fully.
    ${entity_path}=    Set Variable    ${path}/${name}
    [Return]    ${entity_path}

Create record from entity
    [Arguments]    ${entity_type}    ${path}    ${name}    ${templatepath}    ${status}=${EMPTY}    ${is_standard_name}=${False}
    [Documentation]    This keyword creates an new Experiment with a given name from an existing experiment. The new experiment is created under the container specified by the _path_ variable and will be named with _name_.
    ...
    ...    This uses the Create Record Entity keyword to do the work.
    ...
    ...    *Arguments*
    ...
    ...    _path_
    ...    The path under which the experiment should be created with the different levels separated by a / character. The path needs to start with Root.
    ...
    ...    _name_
    ...    The name for the new experiment
    ...
    ...    _templatepath_
    ...    The path in the hierarchy where the experiment exists, including Root
    ...
    ...    _status_
    ...    [optional] The status for the new experiment
    ...
    ...    *Return value*
    ...
    ...    _experiment_path_
    ...    The path of the complete experiment, including the path and the name of the experiment in the following format:
    ...    ${path}/${name}
    ...    e.g. Root/Biochem/P-Biochem/Biochem Workflow Experiment
    ...
    ...    *Precondition*
    ...
    ...    This keyword expects an open E-WorkBook window.
    ...    The experiment you are creating from exists in the hierarchy under the project level
    ...
    ...    *Example*
    ...
    ...    | ${experiment_path}= | Create Experiment | /Root/Biochem/P-Biochem | Biochem/P-Biochem | Biochem Workflow Experiment | |
    ...    | ${experiment_path}= | Create Experiment | /Root/Biochem/P-Biochem | Biochem/P-Biochem | Biochem Workflow Experiment | Started |
    ${pipe_separated_path}=    Replace String    ${path}    /    |
    ${old_timeout}=    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    1
    Tree Node Should Not Exist    class=WorkbenchNavigatorTree    ${pipe_separated_path}|${name}
    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    ${old_timeout}
    Select From Navigator Tree Right-click Menu    ${pipe_separated_path}    New|${entity_type}...
    Select Dialog    New ${entity_type}    20
    log    New ${entity_type}
    Run Keyword If    '${entity_type}'=='Experiment'    _select template/experiment for template    ${templatepath}
    Run Keyword If    '${entity_type}'=='Template'    _select template/record for template    ${templatepath}
    Run Keyword If    "${status}"!="${EMPTY}"    Push Button    statusName_editor_button
    Run Keyword If    "${status}"!="${EMPTY}"    Wait Until Keyword Succeeds    60 seconds    2 seconds    Click On List Item    class=JList
    ...    ${status}
    Run Keyword Unless    ${is_standard_name}    Insert Into Text Field    title_editor_textField    ${name}
    Run Keyword If    ${is_standard_name}    Push Button    title_editor_button
    Run Keyword If    ${is_standard_name}    Wait Until Keyword Succeeds    60 seconds    2 seconds    Click On List Item    class=JList
    ...    ${name}
    Push Button    text=OK
    Check for popup warning

Create report
    [Arguments]    ${path}    ${name}    ${status}=${EMPTY}
    [Documentation]    This keyword creates an new report with a given name. The new report is created under the container specified by the _path_ variable and will be named with _name_.
    ...
    ...    This uses the Create Record Entity keyword to do the work.
    ...
    ...    *Arguments*
    ...
    ...    _path_
    ...    The path under which the report should be created with the different levels separated by a / character. The path needs to start with Root.
    ...
    ...    _name_
    ...    The name for the new report
    ...
    ...    _status_
    ...    [optional] The status for the new report
    ...
    ...    *Return value*
    ...
    ...    _report_path_
    ...    The path of the complete report, including the path and the name of the report in the following format:
    ...    ${path}/${name}
    ...    e.g. Root/Biochem/P-Biochem/Biochem Report
    ...
    ...    *Precondition*
    ...
    ...    This keyword expects an open E-WorkBook window.
    ...
    ...    *Example*
    ...
    ...    | ${report_path}= | Create Report | Root/Biochem/P-Biochem | Biochem Report | |
    ...    | ${report_path}= | Create Report | Root/Biochem/P-Biochem | Biochem Report | Started |
    ${report_path}=    Create record entity    Report    ${path}    ${name}    ${status}
    [Return]    ${report_path}

Create template
    [Arguments]    ${path}    ${name}    ${status}=${EMPTY}
    [Documentation]    This keyword creates an new template with a given name. The new template is created under the container specified by the _path_ variable and will be named with _name_.
    ...
    ...    This uses the Create Record Entity keyword to do the work.
    ...
    ...    *Arguments*
    ...
    ...    _path_
    ...    The path under which the template should be created with the different levels separated by a / character. The path needs to start with Root
    ...
    ...    _name_
    ...    The name for the new template
    ...
    ...    _status_
    ...    [optional] The status for the new template
    ...
    ...    *Return value*
    ...
    ...    _template_path_
    ...    The path of the complete template, including the path and the name of the template in the following format:
    ...    ${path}/${name}
    ...    e.g. Root/Biochem/P-Biochem/Biochem Template
    ...
    ...    *Precondition*
    ...
    ...    This keyword expects an open E-WorkBook window.
    ...
    ...    *Example*
    ...
    ...    | ${template_path}= | Create Template | Root/Biochem/P-Biochem | Biochem Template |
    ${template_path}=    Create record entity    Template    ${path}    ${name}    ${status}
    [Return]    ${template_path}

Create unique experiment
    [Arguments]    ${path}    ${name}    ${status}=${EMPTY}
    [Documentation]    Creates an new Experiment with a name that is guaranteed to be unique.
    ...
    ...    The new experiment is created under the container specified by the _path_ variable and starts with _name_ followed by the hex version of the unix timestamp.
    ...
    ...    This uses the Create Experiment keyword to do the work.
    ...
    ...    *Arguments*
    ...
    ...    _path_
    ...    The path under which the experiment should be created with the different levels separated by a / character. The path needs to start with Root.
    ...
    ...    _name_
    ...    [optional] A defined string to use as a start of the name
    ...
    ...    *Return value*
    ...
    ...    _experiment_path_
    ...    The path of the complete experiment, including the path and the name of the experiment in the following format:
    ...    ${path}/${name}{timestamp}
    ...    e.g. \ /Root/Biochem/P-Biochem \ Biochem Workflow Experiment/Test NameA343D3E
    ...
    ...    *Precondition*
    ...
    ...    This keyword expects an open E-WorkBook window.
    ...
    ...    *Example*
    ...
    ...    | ${experiment_path}= | Create unique Experiment | /Root/Biochem/P-Biochem | Biochem Workflow Experiment | |
    ...    | ${experiment_path}= | Create unique Experiment | /Root/Biochem/P-Biochem | Biochem Workflow Experiment | Started |
    ${epoch}=    Get Time    epoch
    ${epoch}=    Convert to Hex    ${epoch}
    ${unique_name}=    Catenate    ${name}    ${epoch}
    ${Experiment_path}=    Create experiment    ${path}    ${unique_name}    ${status}
    [Return]    ${Experiment_path}

Delete Record Entity
    [Arguments]    ${path}    ${username}    ${password}    ${reason}
    ${pipe_separated_path}=    Replace String    ${path}    /    |
    ${old_timeout}=    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    1
    Tree Node Should Exist    class=WorkbenchNavigatorTree    ${pipe_separated_path}
    Select From Navigator Tree Right-click Menu    ${pipe_separated_path}    .*Delete
    Select Dialog    Authentication    30
    Push Button    ReasonForChangeField_button
    Wait Until Keyword Succeeds    60 seconds    2 seconds    Click On List Item    class=JList    ${reason}
    Insert Into Text Field    class=JStringField    ${username}
    Insert Into Text Field    class=JStringPasswordField    ${password}
    Push Button    authenticationDialogOKButton
    Select E-WorkBook Main Window
    Check Item Exists in navigator Tree    ${pipe_separated_path}    300s
    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    ${old_timeout}

Generate pdf for current experiment
    [Documentation]    Generates a pdf for the current experiment using the Generate PDF button on the toolbar.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with an experiment open and the current tab. The experiment also needs to be saved to allow the PDF creation to succeed
    ...
    ...    *Example*
    ...    | Generate pdf for current experiment |
    Push Button    /root/core3/RecordGeneratePDF
    Wait for glass pane to disappear

Open Experiment
    [Arguments]    ${experiment_path}
    [Documentation]    Opens an exising experiment in the navigator tree.
    ...
    ...    *Arguments*
    ...    _experiment_path_
    ...    The path of the experiment with the different levels separated by /
    ...    e.g. /Root/Biochem/P-Biochem \ Biochem Workflow Experiment/Biochem Test Experiment
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window.
    ...
    ...    *Example*
    ...    | Open Experiment | /Root/Biochem/P-Biochem \ Biochem Workflow Experiment/Biochem Test Experiment |
    Open Record Entity    ${experiment_path}

Open Publish Experiment Items Dialog
    [Documentation]    Opens the Publish Experiment Items dialog in an experiemnt/record
    Push Button    /root/core3/PublishExperiment
    Select Dialog    Select items to publish

Open Record Entity
    [Arguments]    ${path}
    [Documentation]    This keyword creates an new record entity with a given name. The new experiment is created under the container specified by the _path_ variable and will be named with _name_.
    ...
    ...    *Arguments*
    ...
    ...    _entity_type_
    ...    Display name of the new record entity as defined in the flexible hierarchy.
    ...
    ...    _path_
    ...    The path under which the record entity should be created with the different levels separated by a / character. The path needs to start with Root.
    ...
    ...    _name_
    ...    The name for the new record entity
    ...
    ...    _status_
    ...    [optional] The status for the new record entity
    ...
    ...    *Return value*
    ...
    ...    _experiment_path_
    ...    The path of the complete record entity, including the path and the name of the record entity in the following format:
    ...    ${path}/${name}
    ...    e.g. Root/Biochem/P-Biochem/Biochem Workflow Special Experiment
    ...
    ...    *Precondition*
    ...
    ...    This keyword expects an open E-WorkBook window.
    ...
    ...    *Example*
    ...
    ...    | ${entity_path}= | Create Record Entity | Special Experiment | /Root/Biochem/P-Biochem | Biochem Workflow Special Experiment | |
    ...    | ${entity_path}= | Create Record Entity | Special Experiment | /Root/Biochem/P-Biochem | Biochem Workflow Special Experiment | Started |
    ${pipe_separated_path}=    Replace String    ${path}    /    |
    ${old_timeout}=    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    1
    Check Item Exists in navigator Tree    ${pipe_separated_path}
    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    ${old_timeout}
    # Have multiple goes at opening the enity
    Wait Until Keyword Succeeds    300s    10s    __Attempt open record entity    ${pipe_separated_path}

Print current record
    [Arguments]    ${printer_name}
    Select E-WorkBook Main Window
    Select from E-WorkBook Main Menu    File    Print...
    Wait Until Keyword Succeeds    600s    5s    Generic Select Window    Print
    Generic Select From Combobox    &Name:ComboBox    ${printer_name}
    Generic Push Button    OK
    Select E-WorkBook Main Window

Print to PDF
    [Arguments]    ${file_name}    ${file_directory}=${OUTPUT DIR}
    Select from E-WorkBook Main Menu    File    Print...
    Generic Select Window    Print
    Generic Select From Combobox    &Name:ComboBox    CutePDF Writer
    Generic Push Button    OK
    Generic Select Window    Save As
    ${windows_path}=    Join Path    ${file_directory}    ${file_name}
    Generic enter into textbox    Edit    ${windows_path}
    Generic Push Button    Save
    Select E-WorkBook Main Window

Publish current experiment
    [Documentation]    Publishes the current experiment using the Record > Publish menu item.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with an experiment open and the current tab. The experiment also needs to be saved as a version to allow the publishing to proceed.
    ...
    ...    *Example*
    ...    | Publish current experiment |
    Publish current record entity

Publish current record entity
    [Documentation]    Publishes the current experiment using the Record > Publish menu item.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with an experiment open and the current tab. The experiment also needs to be saved as a version to allow the publishing to proceed.
    ...
    ...    *Example*
    ...    | Publish current experiment |
    Open Publish Experiment Items Dialog
    Push Button    OK
    Select E-WorkBook Main Window

Publish current report
    [Documentation]    Publishes the current experiment using the Record > Publish menu item.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with an experiment open and the current tab. The experiment also needs to be saved as a version to allow the publishing to proceed.
    ...
    ...    *Example*
    ...    | Publish current experiment |
    Publish current record entity

Publish current template
    [Documentation]    Publishes the current experiment using the Record > Publish menu item.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with an experiment open and the current tab. The experiment also needs to be saved as a version to allow the publishing to proceed.
    ...
    ...    *Example*
    ...    | Publish current experiment |
    Publish current record entity

Save current experiment as version
    [Arguments]    ${username}    ${password}    ${reason}=Data Added
    [Documentation]    This keyword version saves the currently open record entity using the reason, username and password specified.
    ...
    ...    *Arguments*
    ...    _entity_type_
    ...    Name of entity type as it appears in the save dialog (eg Experiment)
    ...
    ...    _username_
    ...    Username for version save.
    ...
    ...    _password_
    ...    Password used for version save
    ...
    ...    _reason_
    ...    [Optional] Reason to select in the reason list. If no reason is specified, Data Added is used.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with a record entity open and the current tab. The record entity also needs to have changes that haven't been saved as a version for the version save to be successful.
    ...
    ...    *Example*
    ...    | Save current record entity as version | Experiment | username=Biochem | password=Biochem1 |
    ...    | Save current record entity as version | Experiment | reason=New test reason | username=Biochem | password=Biochem1 |
    Save current record as version    ${username}    ${password}    ${reason}

Save current record as draft
    Push Button    /root/core1/RecordSaveDraft
    Select E-WorkBook Main Window

Save current record as version
    [Arguments]    ${username}    ${password}    ${reason}=Data Added
    [Documentation]    This keyword version saves the currently open record entity using the reason, username and password specified.
    ...
    ...    *Arguments*
    ...    _entity_type_
    ...    Name of entity type as it appears in the save dialog (eg Experiment)
    ...
    ...    _username_
    ...    Username for version save.
    ...
    ...    _password_
    ...    Password used for version save
    ...
    ...    _reason_
    ...    [Optional] Reason to select in the reason list. If no reason is specified, Data Added is used.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with a record entity open and the current tab. The record entity also needs to have changes that haven't been saved as a version for the version save to be successful.
    ...
    ...    *Example*
    ...    | Save current record entity as version | Experiment | username=Biochem | password=Biochem1 |
    ...    | Save current record entity as version | Experiment | reason=New test reason | username=Biochem | password=Biochem1 |
    Push Button    /root/core1/RecordSaveVersionBBBBBBBBBBBBBBBBBBB
    Select Dialog    Authentication    30
    Push Button    ReasonForChangeField_button
    Wait Until Keyword Succeeds    60 seconds    2 seconds    Click On List Item    class=JList    ${reason}
    Insert Into Text Field    class=JStringField    ${username}
    Insert Into Text Field    class=JStringPasswordField    ${password}
    Push Button    authenticationDialogOKButton
    Select E-WorkBook Main Window

Save current report as version
    [Arguments]    ${username}    ${password}    ${reason}=Data Added
    [Documentation]    This keyword version saves the currently open record entity using the reason, username and password specified.
    ...
    ...    *Arguments*
    ...    _entity_type_
    ...    Name of entity type as it appears in the save dialog (eg Experiment)
    ...
    ...    _username_
    ...    Username for version save.
    ...
    ...    _password_
    ...    Password used for version save
    ...
    ...    _reason_
    ...    [Optional] Reason to select in the reason list. If no reason is specified, Data Added is used.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with a record entity open and the current tab. The record entity also needs to have changes that haven't been saved as a version for the version save to be successful.
    ...
    ...    *Example*
    ...    | Save current record entity as version | Experiment | username=Biochem | password=Biochem1 |
    ...    | Save current record entity as version | Experiment | reason=New test reason | username=Biochem | password=Biochem1 |
    Save current record as version    ${username}    ${password}    ${reason}

Save current template as version
    [Arguments]    ${username}    ${password}    ${reason}=Data Added
    [Documentation]    This keyword version saves the currently open record entity using the reason, username and password specified.
    ...
    ...    *Arguments*
    ...    _entity_type_
    ...    Name of entity type as it appears in the save dialog (eg Experiment)
    ...
    ...    _username_
    ...    Username for version save.
    ...
    ...    _password_
    ...    Password used for version save
    ...
    ...    _reason_
    ...    [Optional] Reason to select in the reason list. If no reason is specified, Data Added is used.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with a record entity open and the current tab. The record entity also needs to have changes that haven't been saved as a version for the version save to be successful.
    ...
    ...    *Example*
    ...    | Save current record entity as version | Experiment | username=Biochem | password=Biochem1 |
    ...    | Save current record entity as version | Experiment | reason=New test reason | username=Biochem | password=Biochem1 |
    Save current record as version    ${username}    ${password}    ${reason}

Select Items to Publish
    [Arguments]    ${Item Type}    ${Caption}    ${Publish}=${EMPTY}
    [Documentation]    This allows user to select which experiment items are to be published.
    ${number_of_rows}=    Get Table Row Count    class=PublishingSelectionDialog$1
    : FOR    ${option_row}    IN RANGE    ${number_of_rows}
    \    ${current_item}=    Get Table Cell Value    class=PublishingSelectionDialog$1    ${option_row}    Item Type
    \    ${current_caption}=    Get Table Cell Value    class=PublishingSelectionDialog$1    ${option_row}    Caption
    \    ${current_availability}=    Get Table Cell Value    class=PublishingSelectionDialog$1    ${option_row}    Available to publish
    \    ${current_publishing}=    Get Table Cell Value    class=PublishingSelectionDialog$1    ${option_row}    Publish
    \    Run Keyword If    '${current_item}'.strip()=='${Item Type}' and '${current_caption}'.strip()=='${Caption}' and '${Publish}'!='${EMPTY}' and '${Publish}'.upper()!='${current_publishing}'.upper()    Click On Table Cell    class=PublishingSelectionDialog$1    ${option_row}    Publish
    \    Run Keyword If    '${current_item}'.strip()=='${Item Type}' and '${current_caption}'.strip()=='${Caption}'    Exit For Loop    # Abandon for loop if we have found the row

Sign off current experiment
    [Arguments]    ${username}    ${password}    ${reason}="Experiment Completed"    ${role}=Actioner
    [Documentation]    Performs a sign-off on all the unsigned items in the currently open experiment in E-WorkBook.
    ...
    ...    *Arguments*
    ...    _username_
    ...    Username for sign-off
    ...
    ...    _password_
    ...    Password used for sign-off
    ...
    ...    _reason_
    ...    [Optional] Reason to select in the reason list. If no reason is specified, Experiment Completed is used.
    ...
    ...    _role_
    ...    [Optional] Role to select in the rolelist. If no reason is specified, Actioner is used.
    ...
    ...
    ...    *Return value*
    ...    Timestamp of sign-off
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with an experiment open and the current tab. The experiment also needs to be saved as a version to allow the sign-off to proceed.
    ...
    ...    *Example*
    ...    | ${signoff_timestamp}= | Sign off current experiment | username=Molbiol | password=Molbiol1 | | |
    ...    | ${signoff_timestamp}= | Sign off current experiment | reason=Experiment Completed | username=Molbiol | password=Molbiol1 | |
    ...    | ${signoff_timestamp}= | Sign off current experiment | reason=Experiment Completed | username=Molbiol | password=Molbiol1 | role=Actioner |
    Push Button    /root/core3/RecordSignoff
    Select From Visible Popup Menu    class=JPopupMenu    Quick Sign-off\.\.\..*
    ${select_task_dialog_is_open}    ${message}=    Run Keyword And Ignore Error    Select Dialog    SelectSignoffTaskDialog    2
    Run Keyword If    '${select_task_dialog_is_open}'=='PASS'    Select Table Cell    actionedTasksTable    0    0
    Run Keyword If    '${select_task_dialog_is_open}'=='PASS'    Push Button    OK
    Select Dialog    regexp=Sign.*
    Push Button    roleSelectionDropdown_button
    Wait Until Keyword Succeeds    60 seconds    2 seconds    Click On List Item    class=JList    ${role}
    Push Button    signAllButton
    ${signoff_timestamp}=    __Sign-off all items    ${reason}    ${username}    ${password}    ${role}
    Select E-WorkBook Main Window
    [Return]    ${signoff_timestamp}

Wait for all transforms
    Fail

__Attempt open record entity
    [Arguments]    ${pipe_separated_path}
    Click On Tree Node    class=WorkbenchNavigatorTree    ${pipe_separated_path}    2
    sleep    2
    ${status}    ${value}=    Run Keyword And Ignore Error    select dialog    regexp=Entity already.*
    Run Keyword If    '${status}' == 'PASS'    _unlock record at open
    Run Keyword If    '${status}' != 'PASS'    Wait for glass pane to disappear
    Select E-WorkBook Main Window
    ${path}    ${experiment}=    Split String From Right    ${pipe_separated_path}    |    1
    Component Should Have Visible Flag    xpath=//*[contains(@class,'ExtTabbedPane')]//*[text()='${experiment}']

__Sign-off all items
    [Arguments]    ${reason}    ${username}    ${password}    ${role}
    Select Dialog    Preview items for sign-off
    : FOR    ${index}    IN RANGE    200
    \    ${more_items}=    Component Is Enabled    xpath=//button[contains(.,'Next item')]
    \    Run Keyword If    not ${more_items}    Exit For Loop
    \    Push Button    text=Next item
    Push Button    text=Continue
    Select Dialog    Authentication
    Push Button    ReasonForChangeField_button
    Wait Until Keyword Succeeds    60 seconds    2 seconds    Click On List Item    class=JList    ${reason}
    Insert Into Text Field    class=JStringField    ${username}
    Insert Into Text Field    class=JStringPasswordField    ${password}
    Push Button    authenticationDialogOKButton
    ${signoff_timestamp}=    Get Time    epoch
    Select E-WorkBook Main Window
    [Return]    ${signoff_timestamp}

_close use experiment dialog
    Select Dialog    Use Experiment
    Push Button    text=Yes
    Select Window    IDBS E-WorkBook - Workbook Editor    60
    Wait for glass pane to disappear
    ${entity_path}=    Set Variable    ${path}/${name}

_select template/experiment for template
    [Arguments]    ${templatepath}
    ${pipe_separated_path}=    Replace String    ${templatepath}    /    |
    ${old_timeout}=    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    1
    ${status}    ${check}=    Run Keyword And Ignore Error    Check Box Should Be Unchecked    text=Use Template/Experiment
    Run Keyword If    '${status}'=='PASS'    Check Check Box    text=Use Template/Experiment
    IDBSSwingLibrary.Check Box Should Be Checked    text=Use Template/Experiment
    Push Button    text=...
    Select Dialog    Select Template/Experiment    5
    sleep    2    Time for the tree to refresh
    Wait Until Keyword Succeeds    60s    1s    Tree Node Should Exist    class=NavigatorTree    ${pipe_separated_path}
    Select Tree Node    class=NavigatorTree    ${pipe_separated_path}
    Tree Node Should Be Selected    class=NavigatorTree    ${pipe_separated_path}
    sleep    2
    Push Button    OK
    sleep    2
    Select Dialog    New ${entity_type}    30

_select template/record for template
    [Arguments]    ${templatepath}
    ${pipe_separated_path}=    Replace String    ${templatepath}    /    |
    ${old_timeout}=    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    1
    ${status}    ${check}=    Run Keyword And Ignore Error    Check Box Should Be Unchecked    text=Use Template/Record
    Run Keyword If    '${status}'=='PASS'    Check Check Box    text=Use Template/Record
    Push Button    text=...
    sleep    2
    Select Dialog    Select Template/Experiment
    Wait Until Keyword Succeeds    60s    1s    Tree Node Should Exist    class=NavigatorTree    ${pipe_separated_path}
    Click On Tree Node    class=NavigatorTree    ${pipe_separated_path}
    Push Button    OK
    sleep    2
    Select Dialog    New ${entity_type}    30

_unlock record at open
    select dialog    regexp=Entity already.*
    sleep    1
    Send Keyboard Key Pressed Event    VK_TAB
    Send Keyboard Key Pressed Event    VK_ENTER
