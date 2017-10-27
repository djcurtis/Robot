*** Settings ***
Resource          ewb_thick_client_general_actions_resource.robot
Library           String

*** Keywords ***
Batch Print experiments
    [Arguments]    ${printer_name}    ${noexperiments}    ${experimentpath1}    ${experimentpath2}=${EMPTY}    ${experimentpath3}=${EMPTY}    ${experimentpath4}=${EMPTY}
    ...    ${experimentpath5}=${EMPTY}
    [Documentation]    This keyword is for Batch printing multiple selected experiments. Multiple experiments are selected for batch print via option File > Batch Print
    ...
    ...    *Arguments*
    ...
    ...    _noexperiments_
    ...    The number of experiments to be printed
    ...
    ...    _experimentpath1_
    ...    The path EXCLUDING the Root of the first experiment to be added to the batch print
    ...
    ...    _experimentpath2_ (Optional)
    ...    The path EXCLUDING the Root of the first experiment to be added to the batch print. Set to ${EMPTY} by default
    ...
    ...    _experimentpath3_ (Optional)
    ...    The path EXCLUDING the Root of the first experiment to be added to the batch print. Set to ${EMPTY} by default
    ...
    ...    _experimentpath4_ (Optional)
    ...    The path EXCLUDING the Root of the first experiment to be added to the batch print. Set to ${EMPTY} by default
    ...
    ...    _experimentpath5_ (Optional)
    ...    The path EXCLUDING the Root of the first experiment to be added to the batch print. Set to ${EMPTY} by default
    ...
    ...    _printername_
    ...    The name of the dummy printer to be used for batch print. The scenario will log a failure if the dummy printer is not available in the list
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window, all the experiments specified in the data file path to be present and the dummy printer to be created on the system where the script is executed. The dummy printer should be created as a local printer with the printer set to XPS Port
    ...
    ...    *Example*
    ...    | Batch print experiments | datafilepath=C:/QTP Data/E-WorkBook/Test Data/Basic Experiment Actions/experiment_data.xls | printername=Dummy2 |
    Select E-WorkBook Main Window
    Select from E-WorkBook Main Menu    File    Batch Print...
    Select Dialog    Batch Printing
    : FOR    ${index}    IN RANGE    1    ${noexperiments}+1
    \    _select_experiment_for_batch_print    ${experimentpath${index}}
    sleep    1
    Push Button    OK
    Wait Until Keyword Succeeds    600s    5s    Generic Select Window    Print
    Generic Select From Combobox    &Name:ComboBox    ${printer_name}
    Generic Push Button    OK
    Select E-WorkBook Main Window

Close Printing Publishing Options Configuration Dialog
    Select Dialog    regexp=PDF/Print Format options.*
    Push Button    OK
    Select E-WorkBook Main Window

Disable Allow Override at print time
    Select Dialog    regexp=PDF/Print Format options.*
    Select Tab    Print/Publishing
    Uncheck Check Box    allowOverrideCheckbox

Disable Generate PDF/A
    Select Dialog    regexp=PDF/Print Format options.*
    Select Tab    Generate PDF/A
    Uncheck Check Box    pdfaConfigCheckBox

Enable Allow Override at print time
    Select Dialog    regexp=PDF/Print Format options.*
    Select Tab    Print/Publishing
    Check Check Box    allowOverrideCheckbox

Enable Generate PDF/A
    Select Dialog    regexp=PDF/Print Format options.*
    Select Tab    Generate PDF/A
    Check Check Box    pdfaConfigCheckBox

Open Printing Publishing Options Configuration Dialog
    [Arguments]    ${path}
    Select E-WorkBook Main Window
    ${pipe_separated_path}=    Replace String    ${path}    /    |
    Select From Navigator Tree Right-click Menu    ${pipe_separated_path}    Configure|Printing/Publishing Options...
    Select Dialog    regexp=PDF/Print Format options.*

Set Print/Publishing options
    [Arguments]    ${entity}    ${format_option}    ${printing_and_pdf}=${EMPTY}    ${publishing}=${EMPTY}
    ${number_of_rows}=    Get Table Row Count    PDF_PRINT_FORMAT_OPTIONS
    : FOR    ${option_row}    IN RANGE    ${number_of_rows}
    \    ${current_entity}=    Get Table Cell Value    PDF_PRINT_FORMAT_OPTIONS    ${option_row}    Entity
    \    ${current_option}=    Get Table Cell Value    PDF_PRINT_FORMAT_OPTIONS    ${option_row}    Format option
    \    ${current_printing_and_pdf}=    Get Table Cell Value    PDF_PRINT_FORMAT_OPTIONS    ${option_row}    Printing & PDF
    \    ${current_publishing}=    Get Table Cell Value    PDF_PRINT_FORMAT_OPTIONS    ${option_row}    Publishing
    \    Run Keyword If    '${current_entity}'.strip()=='${entity}' and '${current_option}'.strip()=='${format_option}' and '${printing_and_pdf}'!='${EMPTY}' and '${printing_and_pdf}'.upper()!='${current_printing_and_pdf}'.upper()    Click On Table Cell    PDF_PRINT_FORMAT_OPTIONS    ${option_row}    Printing & PDF
    \    Run Keyword If    '${current_entity}'.strip()=='${entity}' and '${current_option}'.strip()=='${format_option}' and '${publishing}'!='${EMPTY}' and '${publishing}'.upper()!='${current_publishing}'.upper()    Click On Table Cell    PDF_PRINT_FORMAT_OPTIONS    ${option_row}    Publishing
    \    Run Keyword If    '${current_entity}'.strip()=='${entity}' and '${current_option}'.strip()=='${format_option}'    Exit For Loop    # Abandon for loop if we have found the row

_select_experiment_for_batch_print
    [Arguments]    ${experimentpath}
    sleep    2
    ${pipe_separated_path}=    Replace String    ${experimentpath}    /    |
    ${old_timeout}=    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    1
    Tree Node Should Exist    class=NavigatorTree    ${pipe_separated_path}
    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    ${old_timeout}
    Click On Tree Node    class=NavigatorTree    ${pipe_separated_path}    2
