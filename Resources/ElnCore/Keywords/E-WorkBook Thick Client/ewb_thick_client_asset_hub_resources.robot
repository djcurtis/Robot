*** Settings ***
Resource          ewb_thick_client_general_actions_resource.robot
Resource          ewb_thick_client_document_entity_actions_resource.robot
Resource          ewb_thick_client_configuration_actions_resources.robot
Library           IDBSSwingLibrary
Library           TimingLibrary
Library           SubversionLibrary
Library           OperatingSystem
Library           FileLibrary
Resource          ewb_thick_client_non_record_entity_actions_resource.robot
Resource          ewb_thick_client_record_entity_actions_resource.robot
Resource          ewb_thick_client_spreadsheet_actions_resource.robot
Resource          ewb_thick_client_asset_hub_resources.robot
Resource          ewb_thick_client_search_actions_resource.robot
Library           RobotRemoteAgent

*** Keywords ***
Close current spreadsheet
    [Documentation]    Closes current spreadsheet
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    Assumes the Spreadsheet window has context
    ...
    ...    *Example*
    ...    | Close current spreadsheet |
    Close Window    regexp=.*Spreadsheet

Create Folder
    [Arguments]    ${group_name}    ${project_name}    ${folder_name}
    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    1
    Tree Node Should Exist    class=WorkbenchNavigatorTree    Root|${group_name}
    Tree Node Should Exist    class=WorkbenchNavigatorTree    Root|${group_name}|${project_name}
    Tree Node Should Not Exist    class=WorkbenchNavigatorTree    Root|${group_name}|${project_name}|${folder_name}
    Select From Tree Node Popup Menu    class=WorkbenchNavigatorTree    Root|${group_name}|${project_name}    New|Folder...
    Select Dialog    New Folder
    Insert Into Text Field    name_editor    ${folder_name}
    Push Button    OK
    Select E-WorkBook Main Window
    Wait Until Keyword Succeeds    60 seconds    0.5 seconds    Tree Node Should Exist    class=WorkbenchNavigatorTree    Root|${group_name}|${project_name}|${folder_name}

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
    ${experiment_path}=    Create record entity from entity    Experiment    ${path}    ${name}    ${templatepath}    ${status}
    [Return]    ${experiment_path}

Create record entity from entity
    [Arguments]    ${entity_type}    ${path}    ${name}    ${templatepath}    ${status}=${EMPTY}    ${is_standard_name}=${False}
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
    Select From Tree Node Popup Menu    class=WorkbenchNavigatorTree    ${pipe_separated_path}    New|${entity_type}...
    Wait Until Keyword Succeeds    20    0.5    Select Dialog    New ${entity_type}
    log    New ${entity_type}
    Run Keyword If    '${entity_type}'=='Experiment'    _select template/experiment for template_    ${templatepath}
    Run Keyword If    '${entity_type}'=='Template'    _select template/record for template_    ${templatepath}
    Run Keyword If    "${status}"!="${EMPTY}"    Push Button    statusName_editor_button
    Run Keyword If    "${status}"!="${EMPTY}"    Wait Until Keyword Succeeds    60 seconds    2 seconds    Click On List Item    class=JList
    ...    ${status}
    Run Keyword Unless    ${is_standard_name}    Insert Into Text Field    title_editor_textField    ${name}
    Run Keyword If    ${is_standard_name}    Push Button    title_editor_button
    Run Keyword If    ${is_standard_name}    Wait Until Keyword Succeeds    60 seconds    2 seconds    Click On List Item    class=JList
    ...    ${name}
    Push Button    text=OK
    Comment    Run Keyword If    "${entity_type}"=="Experiment"    Wait Until Keyword Succeeds    20    0.5    Select Dialog
    ...    Use Experiment
    Comment    Push Button    text=Yes
    Comment    Wait Until Keyword Succeeds    60 seconds    0.5 seconds    Remote.Select Window    IDBS E-WorkBook - Workbook Editor
    Comment    Wait for glass pane to disappear
    ${entity_path}=    Set Variable    ${path}/${name}
    [Return]    ${entity_path}

Create template from entity
    [Arguments]    ${path}    ${name}    ${templatepath}    ${status}=${EMPTY}
    [Documentation]    This keyword creates an new Experiment with a given name from an existing template. The new experiment is created under the container specified by the _path_ variable and will be named with _name_.
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
    ...    The path in the hierarchy where the template exists
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
    ${template_path}=    Create record entity from entity    Template    ${path}    ${name}    ${templatepath}    ${status}
    [Return]    ${template_path}

Delete assets in spreadsheet - Timed
    [Arguments]    ${assetname}
    [Documentation]    Times how long it takes to delete assets from a spreadsheet
    ...
    ...    *Arguments*
    ...    ${assetname}
    ...    Name of the Asset to be deleted excluding the automatic pluralisation e.g. Sample
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    Assumes the correct spreadsheet containing the asset to be deleted is active and selected. \ Will delete whatever is selected, e.g whole table, individual cell, column
    ...
    ...    *Example*
    ...    |Delete assets in spreadsheet - Timed | Sample |
    Push Magic Button
    Select Magic Button Dialog
    Push Asset Delete Action Button    ${assetname}
    Select Dialog    regexp=Delete.*
    Timer Start    deletepreview    Time for ${Assetcount} assets to be retrieved to the window
    Wait Until Keyword Succeeds    3000    0.01    Button Should Be Enabled    OK
    Timer Check Elapsed    deletepreview
    Push Button    OK
    Timer Start    deletetoss    Time for ${Assetcount} assets to be retrieved to ss
    Wait Until Keyword Succeeds    3000    0.1    Button Should Be Enabled    OK
    Timer Check Elapsed    deletetoss
    Push Button    OK
    Wait for glass pane to disappear
    Select Window    regexp=.*Spreadsheet

Push Asset Delete Action Button
    [Arguments]    ${Assettext}
    [Documentation]    Pushes the Delete 'Asset' \ button in the Spreadsheet Context ActionDialog
    ...
    ...    *Arguments*
    ...    ${Assettext}
    ...    Name of the Asset to be saved excluding the automatic pluralisation e.g. Sample
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    Assumes the Spreadsheet Context Action Dialog is open
    ...
    ...    *Example*
    ...    | Push Asset Delete Action Button | Sample |
    Push Button    text=<html>Delete ${Assettext}s</html>

Push Asset Retrieve Action Button
    [Arguments]    ${Assettext}
    [Documentation]    Pushes the Retrieve 'Asset' \ button in the Spreadsheet Context ActionDialog
    ...
    ...    *Arguments*
    ...    ${Assettext}
    ...    Name of the Asset to be saved excluding the automatic pluralisation e.g. Sample
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    Assumes the Spreadsheet Context Action Dialog is open
    ...
    ...    *Example*
    ...    | Push Retrieve Action Button | Sample |
    Push Button    text=<html>Retrieve ${Assettext}s</html>

Push Asset Save Action Button
    [Arguments]    ${Assettext}
    [Documentation]    Pushes the Save 'Asset' \ button in the Spreadsheet Context ActionDialog
    ...
    ...    *Arguments*
    ...    ${Assettext}
    ...    Name of the Asset to be saved excluding the automatic pluralisation e.g. Sample
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    Assumes the Spreadsheet Context Action Dialog is open
    ...
    ...    *Example*
    ...    | Push Asset Save Action Button | Sample |
    Push Button    text=<html>Save ${Assettext}s</html>

Push Magic Button
    [Documentation]    Pushes the Spreadsheet Context Action Button
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    Assumes the \ spreadsheet has context
    ...
    ...    *Example*
    ...    | Push Magic Button |
    Select Window    regexp=.*Spreadsheet
    sleep    1
    Push Button    openSpreadsheetContextMenuButton

Push Run BioBook Searches Action Button
    [Documentation]    Pushes the Run BioBook Searches button in the Spreadsheet Context Action Dialog
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    Assumes the Spreadsheet Context Action Dialog is open
    ...
    ...    *Example*
    ...    | Push Run BioBook Searches Action Button |
    Push Button    text=<html>Run Biobook Searches</html>

Push Version save button
    [Documentation]    Pushes the Version Save Button
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    Assumes the EWB Main Window has context
    ...
    ...    *Example*
    ...    | Push Version save button |
    Push Button    /root/core1/RecordSaveVersionBBBBBBBBBBBBBBBBBBB

Retrieve assets in spreadsheet -Timed
    [Arguments]    ${assetname}
    [Documentation]    Times how long it takes to retrieve assets from a spreadsheet
    ...
    ...    *Arguments*
    ...    ${assetname}
    ...    Name of the Asset to be deleted excluding the automatic pluralisation e.g. Sample
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    Assumes the correct spreadsheet containing the asset to be deleted is active and selected. \ Will delete whatever is selected, e.g whole table, individual cell, column
    ...
    ...    *Example*
    ...    |Retrieve assets in spreadsheet - Timed | Sample |
    Push Magic Button
    Select Magic Button Dialog
    Push Asset Retrieve Action Button    ${assetname}
    Select Dialog    regexp=Retrieve.*
    Timer Start    retrievepreview    Time for ${Assetcount} assets to be retrieved to the window
    Wait Until Keyword Succeeds    3000    0.01    Button Should Be Enabled    OK
    Timer Check Elapsed    retrievepreview
    Push Button    OK
    Timer Start    retrievetoss    Time for ${Assetcount} assets to be retrieved to ss
    Wait Until Keyword Succeeds    3000    0.1    Wait for glass pane to disappear
    Timer Check Elapsed    retrievetoss
    Select Window    regexp=.*Spreadsheet

Run BioBook Searches in Spreadsheet
    Push Magic Button
    Select Magic Button Dialog
    Push Run BioBook Searches Action Button
    Timer Start    Searchresults    tiem for search to return results
    Select Dialog
    Wait Until Keyword Succeeds    3000    0.01    Button Should Be Enabled    OK
    Timer Check Elapsed    retrievepreview
    Push Button    OK
    Timer Start    retrievetoss    Time it takes for assets to be retrieved to ss
    Wait Until Keyword Succeeds    3000    0.1    Wait for glass pane to disappear
    Timer Check Elapsed    retrievetoss
    Select Window    regexp=.*Spreadsheet

Save assets in spreadsheet - Timed
    [Arguments]    ${assetname}
    [Documentation]    Times how long it takes to save assets in a spreadsheet
    ...
    ...    *Arguments*
    ...    ${assetname}
    ...    Name of the Asset to be deleted excluding the automatic pluralisation e.g. Sample
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    Assumes the correct spreadsheet containing the asset to be deleted is active and selected. \ Will delete whatever is selected, e.g whole table, individual cell, column
    ...
    ...    *Example*
    ...    |Save assets in spreadsheet - Timed | Sample |
    Push Magic Button
    Select Magic Button Dialog
    Push Asset Save Action Button    ${assetname}
    Select Asset Save dialog
    Select all assets in asset save    ${assetname}
    sleep    30
    Select Asset Save dialog
    Push Button    OK
    Timer Start    saveassetsinss    Time for ${Assetcount} Assets to be saved to the db
    Wait Until Keyword Succeeds    3000    0.1    Wait for glass pane to disappear
    Timer Check Elapsed    saveassetsinss
    Select Window    regexp=.*Spreadsheet

Save current experiment as Version with Assets
    [Arguments]    ${username}    ${password}    ${reason}=Data Added
    [Documentation]    This keyword version saves the currently open record entity using the reason, username and password specified including the Asset Preview save dialog
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
    Push Version save button
    Select Dialog    dialog10
    Wait Until Keyword Succeeds    10    0.01    Button Should Be Enabled    text=Submit
    Push Button    OK
    Wait Until Keyword Succeeds    10    0.1    Select Dialog    dialog11
    Push Button    OK
    Select Dialog    regexp=Save.*
    Select From List    ItemList    ${reason}
    Push Button    text=OK
    Select Dialog    E-WorkBook - Credentials
    Insert Into Text Field    class=JStringField    ${username}
    Insert Into Text Field    class=JStringPasswordField    ${password}
    Push Button    text=Continue
    Select E-WorkBook Main Window

Select Asset Save dialog
    [Documentation]    Selects the Asset Save Dialog and sets focus
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    Assumes the dialog is open
    ...
    ...    *Example*
    ...    |Select Asset Save Dialog |
    Select Dialog    regexp=Save.*

Select Magic Button Dialog
    [Documentation]    Selects the Spreadsheet Context Action Dialog for operations to select inside the dialog
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    Assumes the context of the Spreadsheet Window is selected
    ...
    ...    *Example*
    ...    |Select Magic Button Dialog |
    Select Dialog    regexp=Spreadsheet.*

Select all assets in asset save
    [Arguments]    ${assetname}
    [Documentation]    Pushes the select all button when saving an asset if the asset save is defaulting to only one active cell
    ...
    ...    *Arguments*
    ...    ${assetname}
    ...    Name of the Asset to be deleted excluding the automatic pluralisation e.g. Sample
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    Assumes the save asset dialog is open
    ...
    ...    *Example*
    ...    |Select all assets in asset save | Sample |
    Run Keyword And Ignore Error    Push Button    text=Select all ${assetname}s

Update Spreadsheet
    [Documentation]    Pushes the Update Spreadsheet Button in the spreadsheet
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    Assumes the spreasdheet in in focus
    ...
    ...    *Example*
    ...    |Update Spreadsheet |
    Select Window    regexp=.*Spreadsheet
    Push Button    updateSSItemPanelToolbarButton
    Comment    ${old_dialog_wait_timeout}=    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout    0.01
    Comment    Run Keyword And Ignore Error    Wait Until Keyword Succeeds    10s    0.1s    Dialog Should Be Open    regexp=Performing action.*
    Comment    Run Keyword And Ignore Error    Wait Until Keyword Succeeds    600s    0.1s    Dialog Should Not Be Open    regexp=Performing action.*
    Comment    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout    ${old_dialog_wait_timeout}

_select template/experiment for template_
    [Documentation]    Selects a template/experiment if this is the selection when creating a record from another enetity
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    Assumes thecreate new entity window is open
    ...
    ...    *Example*
    ...    | _select template/experiment for template_ |
    sleep    5
    Check Check Box    text=Use Template/Experiment
    Push Button    text=...
    sleep    5
    Select Dialog    Select Template/Experiment
    ${templatepath}    ${nodeproject}=    Split String    ${templatepath}    /    1
    ${nodeproject}    ${nodefolder}=    Split String    ${nodeproject}    /    1
    ${nodefolder}    ${nodetemplate}=    Run Keyword And Continue On Failure    Split String    ${nodefolder}    /    1
    Expand Tree Node    class=com.idbs.ewb.entity.ui.navigator.NavigatorTree    Root
    sleep    2
    Expand Tree Node    class=com.idbs.ewb.entity.ui.navigator.NavigatorTree    Root|${templatepath}
    sleep    2
    Expand Tree Node    class=com.idbs.ewb.entity.ui.navigator.NavigatorTree    Root|${templatepath}|${nodeproject}
    sleep    2
    Expand Tree Node    class=com.idbs.ewb.entity.ui.navigator.NavigatorTree    Root|${templatepath}|${nodeproject}|${nodefolder}
    sleep    2
    Click On Tree Node    class=com.idbs.ewb.entity.ui.navigator.NavigatorTree    Root|${templatepath}|${nodeproject}|${nodefolder}|${nodetemplate}
    Push Button    OK
    Wait Until Keyword Succeeds    30    1    Select Dialog    New ${entity_type}

_select template/record for template_
    [Arguments]    ${templatepath}
    [Documentation]    Selects a template/record if this is the selection when creating a record from another enetity
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    Assumes thecreate new entity window is open
    ...
    ...    *Example*
    ...    | _select template/record for template_ |
    Check Check Box    text=Use Template/Record
    Push Button    text=...
    Select Dialog    Select Template/Record
    ${templatepath}    ${nodeproject}=    Split String    ${templatepath}    /    1
    ${nodeproject}    ${nodetemplate}=    Split String    ${nodeproject}    /    1
    Expand Tree Node    class=com.idbs.ewb.entity.ui.navigator.NavigatorTree    Root
    Expand Tree Node    class=com.idbs.ewb.entity.ui.navigator.NavigatorTree    Root|${templatepath}
    Expand Tree Node    class=com.idbs.ewb.entity.ui.navigator.NavigatorTree    Root|${templatepath}|${nodeproject}
    Click On Tree Node    class=com.idbs.ewb.entity.ui.navigator.NavigatorTree    Root|${templatepath}|${nodeproject}|${nodetemplate}
    Push Button    OK
    Wait Until Keyword Succeeds    20    0.5    Select Dialog    New ${entity_type}
