*** Settings ***
Library           IDBSSwingLibrary
Library           TimingLibrary
Library           SubversionLibrary
Library           OperatingSystem
Library           FileLibrary
Library           RobotRemoteAgent
Resource          ewb_thick_client_general_actions_resource.robot
Resource          ewb_thick_client_document_entity_actions_resource.robot
Resource          ewb_thick_client_record_entity_actions_resource.robot
Resource          ewb_thick_client_non_record_entity_actions_resource.robot

*** Keywords ***
Apply Stoic defaults
    Open Parallel Synthesis Console
    Parallel Synthesis Default
    Select Dialog    Parallel Synthesis Console
    Close Dialog    Parallel Synthesis Console

Enumeration process
    Open Parallel Synthesis Console
    Parallel Synthesis Enumeration    Automatic

Import SD File Content
    [Arguments]    ${filepath}    ${table}    ${type}    ${dimension}
    Select from E-WorkBook Main Menu    Item    Chemistry    Import SD File Content
    Select Dialog    IDBS SD File Import    30
    Push Button    text=...
    Choose From File Chooser    ${filepath}
    Select Dialog    IDBS SD File Import    30
    Push Button    text=Next >
    Select Dialog    IDBS SD File Import    30
    sleep    5
    Select From Combo Box    xpath=//*[@class="TableSelectionPanel"]/[@class="JPanel"]/[@class="JPanel"]/[@class="JComboBox"]    ${table}
    Select From Combo Box    xpath=//*[@class="FieldMappingPanel"]/[@class="JScrollPane"]/[@class="JViewport"]/[@class="JPanel"]/[@class="JComboBox"][2]    ${type}
    Select From Combo Box    xpath=//*[@class="FieldMappingPanel"]/[@class="JScrollPane"]/[@class="JViewport"]/[@class="JPanel"]/[@class="JComboBox"][3]    ${dimension}
    Push Button    text=Finish

Open Parallel Synthesis Console
    Select E-WorkBook Main Window
    ${panel_description}=    __Build document panel description and scroll to view    Other:    Chem
    Focus to Component    ${panel_description}
    Push Button    text=ChemApps
    Select From List    class=JList    2
    Select Dialog    Parallel Synthesis Console    30

Parallel Synthesis Default
    Push Button    class=com.idbs.chemistry.utilities.internal.IconButton[3]
    Select Dialog    Stoichiometry Defaults    30
    Push Button    text=Yes
    Wait Until Keyword Succeeds    1000    5    Select E-WorkBook Main Window

Parallel Synthesis Enumeration
    [Arguments]    ${enumeration}
    Push Button    class=com.idbs.chemistry.utilities.internal.IconButton[2]
    Select Dialog    Enumerate    30
    Push Radio Button    text=${enumeration}
    Push Button    OK
    Select Dialog    Information    600
    sleep    2
    Push Button    text=OK
    sleep    2
    Close Dialog    Parallel Synthesis Console
    Select E-WorkBook Main Window

Parallel Synthesis Setup
    [Arguments]    ${enumeration}
    Push Button    class=com.idbs.chemistry.utilities.internal.IconButton[1]
    Select Dialog    Parallel Synthesis Setup    30
    Push Radio Button    text=${enumeration}
    Push Button    OK
    Close Dialog    Parallel Synthesis Console
    Select E-WorkBook Main Window

Parallel Synthesis Views
    Push Button    class=com.idbs.chemistry.utilities.internal.IconButton[4]
    Select Dialog    Reaction View Selection    30
    Push Button    class=JButton[6]
    sleep    5
    Push Button    OK
    Wait for glass pane to disappear
    Select Dialog    Parallel Synthesis Console
    Close Dialog    Parallel Synthesis Console
    Select E-WorkBook Main Window

Reaction views
    Open Parallel Synthesis Console
    Parallel Synthesis Views

Setup process
    [Documentation]    The keyword initiates the setup process from Parallel synthesis console.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with an experiment open and the current tab. The experiment also needs to have a valid Reaction added as a pre-requisite by uploading the sample SKC file
    ...
    ...    *Example*
    ...    | Setup process |
    Select E-WorkBook Main Window
    Open Parallel Synthesis Console
    Parallel Synthesis Setup    Generate products and reactions
    Select E-WorkBook Main Window
