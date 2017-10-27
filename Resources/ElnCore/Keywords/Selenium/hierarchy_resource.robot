*** Settings ***
Documentation     A resource file containing IDBS defined keywords used for testing the IDBS E-WorkBook Web Client application. This resource file contains keywords applicable to the hierarchy functionality.
...               This file covers the management of entities on the hierarchy and within the central content panel This file is loaded by the common_resource.txt file which is automatically loaded when running tests through the Robot Framework.
...               *Version: E-WorkBook Web Client 9.2.0*
Resource          attributes_resource.robot
Library           IDBSSelenium2Library
Resource          general_resource.robot
Resource          ../Web Services/Core Web Services/Entity Service/rest_entity_service_resource.robot
#Resource          ../Web Services/Core Web Services/Entity Lock Service/rest_entity_lock_service.robot
Resource          ../Web Services/Core Web Services/Entity XMLConfiguration/entity_xml_configuration_resource.robot
## Library           EntityAPILibrary
Library           WebHelperFunctions/

*** Variables ***
${temp flag}      ${EMPTY}
${ewb-entity-command-move}    ewb-entity-command-move

*** Keywords ***
Create Entity
    [Arguments]    ${entity type}    ${entity name}    ${parent entity}    ${creation location}
    [Documentation]    *Description*
    ...    Basic creation of any entity type configured within the system. \ Only the display attribute is configured.
    ...
    ...    *Arguments*
    ...    ${entity type} = Display type of the entity type being created. e.g. "Experiment"
    ...    ${entity name} = The display name to be used for the new entity.
    ...    ${parent entity} = The parent entity of the new entity.
    ...    ${creation location} = Where to create the entity from. Either "CONTENT HEADER", "TILE", "NAVIGATOR" or "DIALOG"
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    If using ${creation location} = TILE, the parent entity tile must be displayed in the content panel
    ...    If using ${creation location} = CONTENT HEADER, the content panel must be displaying the parent entity
    ...    If using ${creation location} = NAVIGATOR, the parent entity must be visible in the navigator panel
    ...    If using ${creation location} = DIALOG, the parent entity must be open the content panel
    ...
    ...    *Example*
    ...    Log In Via Login Dialog | Username | Password
    ...    Create Entity | Group | myGroup | Root | NAVIGATOR
    Run Keyword If    '${creation location}' == 'CONTENT HEADER'    Dialog Create Entity    ${entity type}    ${entity name}
    Run Keyword If    '${creation location}' == 'TILE'    Dialog Create Entity    ${entity type}    ${entity name}
    Run Keyword If    '${creation location}' == 'NAVIGATOR'    Navigator Tree Create Entity    ${parent entity}    ${entity type}    ${entity name}
    Run Keyword If    '${creation location}' == 'DIALOG'    Dialog Create Entity    ${entity type}    ${entity name}

Content Header Create Entity
    [Arguments]    ${Entity Type}    ${Title}
    [Documentation]    *Should be accessed by "Create Entity" keyword with the creation location argument "CONTENT HEADER"*
    ...
    ...    *Description*
    ...    Basic creation of any entity type configured within the system. Only the display attribute is configured.
    ...
    ...    *Arguments*
    ...    ${entity type} = Display type of the entity type being created. e.g. "Experiment"
    ...    ${title} = The display name to be used for the new entity.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    the content panel must be displaying the parent entity
    ...
    ...    *Example*
    ...    Log In Via Login Dialog | Username | Password
    ...    Content Header Create Entity | Group | myGroup
    Wait Until Keyword Succeeds    10s    1s    Open Content Header Tool Menu
    Create Default Entity    ${Entity Type}    ${Title}

Tile Create Entity
    [Arguments]    ${Tile Display Name}    ${Entity Type}    ${Title}
    [Documentation]    *Should be accessed by "Create Entity" keyword with the creation location argument "TILE"*
    ...
    ...    *Description*
    ...    Basic creation of any entity type configured within the system. Only the display attribute is configured.
    ...
    ...    *Arguments*
    ...    ${tile display name} = The name of the parent entity
    ...    ${entity type} = Display type of the entity type being created. e.g. "Experiment"
    ...    ${title} = The display name to be used for the new entity.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    the content panel must be displaying the parent entity as a tile
    ...
    ...    *Example*
    ...    Log In Via Login Dialog | Username | Password
    ...    Tile Create Entity | Administrators | Project | myProject
    Wait Until Keyword Succeeds    10s    1s    Open Tile Header Tool Menu    ${Tile Display Name}
    Create Default Entity    ${Entity Type}    ${Title}

Navigator Tree Create Entity
    [Arguments]    ${Parent Display Name}    ${Entity Type}    ${Title}
    [Documentation]    *Should be accessed by "Create Entity" keyword with the creation location argument "NAVIGATOR"*
    ...
    ...    *Description*
    ...    Basic creation of any entity type configured within the system. Only the display attribute is configured.
    ...
    ...    *Arguments*
    ...    ${parent display name} = The name of the parent entity
    ...    ${entity type} = Display type of the entity type being created. e.g. "Experiment"
    ...    ${title} = The display name to be used for the new entity.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    the parent entity must be visible in the navigator panel
    ...
    ...    *Example*
    ...    Log In Via Login Dialog | Username | Password
    ...    Navigator Tree Create Entity | Administrators | Project | myProject
    Wait Until Keyword Succeeds    10s    1s    Open Navigator Tool Menu    ${Parent Display Name}
    Robust Click    ewb-entity-menu-new
    Create Default Entity    ${Entity Type}    ${Title}    Dialog

Dialog Create Entity
    [Arguments]    ${Entity Type}    ${Title}
    [Documentation]    *Should be accessed by "Create Entity" keyword with the creation location argument "DIALOG"*
    ...
    ...    *Description*
    ...    Basic creation of any entity type configured within the system. Only the display attribute is configured.
    ...
    ...    *Arguments*
    ...    ${entity type} = Display type of the entity type being created. e.g. "Experiment"
    ...    ${title} = The display name to be used for the new entity.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    the parent entity must be open in the content panel
    ...
    ...    *Example*
    ...    Log In Via Login Dialog | Username | Password
    ...    Dialog Create Entity | Project | myProject
    Robust Click    xpath=//*[contains(@class,"ewb-new-entity-panel")]
    Wait Until Page Contains Element    xpath=//*[contains(@class,"ewb-new-entity-dialog")]
    Create Default Entity    ${Entity Type}    ${Title}    Dialog

Dialog Create Entity And Expect Failure
    [Documentation]    *Description*
    ...    Click the 'New Entity' button and expect it to fail with an error dialog
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    the parent entity must be open in the content panel
    ...
    ...    *Example*
    ...    Log In Via Login Dialog | Username | Password
    ...    Dialog Create Entity And Expect Failure
    Robust Click    xpath=//*[contains(@class,"ewb-new-entity-panel")]
    Wait Until Page Contains Element    ewb-message-box-error

Create Default Entity
    [Arguments]    ${Entity Type}    ${Title}    ${Mode}=Menu
    [Documentation]    Selects New > ${Type} from the context menu using "Select New Entity Type" keyword and enters the ${Title} value into the display attribute field and creates the entity.
    Register Keyword To Run On Failure    Nothing
    Run Keyword Unless    '${Mode}' == 'Dialog'    Select New Entity Type    ${Entity Type}
    ${new-entity-id}=    Evaluate    ('ewb-entity-command-new-' + '${Entity Type}'.upper()).replace(' ', '_')
    Run Keyword If    '${Mode}' == 'Dialog'    Robust Click    ${new-entity-id}
    Register Keyword To Run On Failure    Capture Page Screenshot
    Edit Entity Properties Dialog Should Be Present
    Run Keyword If    '${Entity Type}' == 'Folder'    Set Text Attribute    name    ${Title}
    Run Keyword If    '${Entity Type}' == 'Group'    Set Text Attribute    name    ${Title}
    Run Keyword If    '${Entity Type}' == 'Project'    Set Text Attribute    title    ${Title}
    Run Keyword If    '${Entity Type}' == 'Landing Page'    Set Text Attribute    name    ${Title}
    Run Keyword Unless    '${Entity Type}' == 'Folder' or '${Entity Type}' == 'Group' or '${Entity Type}' == 'Project' or '${Entity Type}' == 'Landing Page'    Wait Until Keyword Succeeds    30s    5s    Set List Attribute Text Entry    title
    ...    ${Title}
    Run Keyword If    '${Entity Type}' == 'Folder'    Textfield Should Contain    ewb-attribute-editor-name    ${Title}
    Run Keyword If    '${Entity Type}' == 'Group'    Textfield Should Contain    ewb-attribute-editor-name    ${Title}
    Run Keyword If    '${Entity Type}' == 'Project'    Textfield Should Contain    ewb-attribute-editor-title    ${Title}
    Run Keyword If    '${Entity Type}' == 'Landing Page'    Textfield Should Contain    ewb-attribute-editor-name    ${Title}
    Run Keyword Unless    '${Entity Type}' == 'Folder' or '${Entity Type}' == 'Group' or '${Entity Type}' == 'Project' or '${Entity Type}' == 'Landing Page'    Textfield Should Contain    ewb-attribute-editor-title-input    ${Title}
    Save Entity Properties And Wait
    Wait Until Title Is    IDBS E-WorkBook - ${Title}    60s
    Wait For No Mask

Select New Entity Type
    [Arguments]    ${Type}
    [Documentation]    Selects New > ${Type} from the context menu. The context menu being used must be open before using this keyword.
    Robust Click    xpath=//*[contains(@class,"ewb-new-entity-panel")]
    Wait Until Page Contains Element    xpath=//*[contains(@class,"ewb-new-entity-dialog")]
    ${new-entity-id}=    Evaluate    ('ewb-entity-command-new-A_' + '${Type}'.upper()).replace(' ', '_')
    Robust Click    ${new-entity-id}
    Edit Entity Properties Dialog Should Be Present

Open Edit Properties Dialog
    [Arguments]    ${entity name}    ${menu location}
    [Documentation]    *Description*
    ...    Opens the edit properties dialog for the entity given by the ${entity name}
    ...
    ...    *Arguments*
    ...    ${entity name} = the display name of the entity to be editted
    ...    ${menu location} = the location to access the edit properties menu, the valid options for this argument is "CONTENT HEADER", "TILE" or "NAVIGATOR"
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    If using ${menu location} = TILE, the parent entity tile must be displayed in the content panel
    ...    If using ${menu location} = CONTENT HEADER, the content panel must be displaying the parent entity
    ...    If using ${menu location} = NAVIGATOR, the parent entity must be visible in the navigator panel
    ...
    ...    *Example*
    ...    Log In Via Login Dialog | Username | Password
    ...    Open Edit Properties Dialog | Administrators | TILE
    Run Keyword If    '${menu location}' == 'CONTENT HEADER'    Content Header Open Entity Properties    ${entity name}
    Run Keyword If    '${menu location}' == 'TILE'    Tile Edit Entity Properties    ${entity name}
    Run Keyword If    '${menu location}' == 'NAVIGATOR'    Navigator Edit Entity Properties    ${entity name}

Content Header Open Entity Properties
    [Arguments]    ${entity name}
    [Documentation]    Opens the edit properties dialog for the entity given by ${entity name} using the content header context menu.
    Robust Click    ewb-record-action-bar-properties
    Wait Until Page Contains Element    edit-properties
    Click Element    edit-properties
    Wait Until Page Contains Element    save-properties

Tile Edit Entity Properties
    [Arguments]    ${entity name}
    [Documentation]    Opens the edit properties dialog for the entity given by ${entity name} using the tile context menu.
    Open Record Tile Properties    ${entity name}
    Edit Entity Properties

Navigator Edit Entity Properties
    [Arguments]    ${entity name}
    [Documentation]    Opens the edit properties dialog for the entity given by ${entity name} using the navigator context menu.
    Open Navigator Tool Menu    ${entity name}
    Robust Click    ewb-show-properties-command
    Edit Entity Properties

Delete Entity
    [Arguments]    ${entity name}    ${menu location}    ${deletion reason}    ${deletion comment}    ${username}    ${password}
    [Documentation]    Deletion of any entity within the system.
    ...    ${entity name} = The display name of the entity to be deleted.
    ...    ${deletion location} = Where to delete the entity from. Either "NAVIGATOR" or "TILE"
    Wait Until Keyword Succeeds    10s    1s    Run Keyword If    '${menu location}' == 'CONTENT HEADER'    Open Content Header Delete Entity Dialog    ${entity name}
    Wait Until Keyword Succeeds    10s    1s    Run Keyword If    '${menu location}' == 'TILE'    Open Tile Delete Entity Dialog    ${entity name}
    Wait Until Keyword Succeeds    10s    1s    Run Keyword If    '${menu location}' == 'NAVIGATOR'    Open Navigator Delete Entity Dialog    ${entity name}
    Select User Action Note    ${deletion reason}
    Enter Deletion Comment    ${deletion comment}
    Authenticate Session    ${username}    ${password}
    sleep    3s

Confirm Deletion of Entity With Tasks
    [Documentation]    Checks for the presence of the tasks deletion warning message and continues with the deletion when the dialog appears.
    Wait Until Page Contains Element    xpath=//div[contains(text(), 'There are tasks defined for this entity or its children. Deleting the entity will delete all tasks defined against it and its children. Do you want to continue with the delete?')]    30s
    Click OK

Cancel Deletion of Entity With Tasks
    [Documentation]    Checks for the presence of the tasks deletion warning message and cancels the deletion when the dialog appears
    Dialog Should Be Present    Delete Entity Tasks?
    Wait Until Page Contains Element    xpath=//div[contains(text(), 'There are tasks defined for this entity or its children. Deleting the entity will delete all tasks defined against it and its children. Do you want to continue with the delete?')]    30s
    Click Cancel

Check Entity Deleted
    [Arguments]    ${entity name}
    [Documentation]    Checks that the entity specified by ${entity name} has been deleted. Checks the tile view and expanded navigator only
    Wait Until Page Does Not Contain Element    xpath=//a[contains(@class, 'ewb-anchor') and (text()="${entity name}")]    30s
    Wait Until Page Does Not Contain Element    xpath=//div[@title="${entity name}"]/table/tbody/tr/td[2]/div/table/tbody/tr/td[2]/div/a    30s
    Reload Page
    Wait Until Page Contains Element    xpath=//a[contains(@class, 'ewb-breadcrumb-terminal')]    20s
    Robust Click    xpath=//a[contains(@class, 'ewb-breadcrumb-terminal')]
    Wait Until Page Does Not Contain Element    xpath=//a[contains(@class, 'ewb-anchor') and (text()="${entity name}")]    30s
    Wait Until Page Does Not Contain Element    xpath=//div[@title="${entity name}"]/table/tbody/tr/td[2]/div/table/tbody/tr/td[2]/div/a    30s

Check Entity Not Deleted
    [Arguments]    ${entity name}
    [Documentation]    Checks that the entity specified by ${entity name} has not been deleted. Checks the tile view and expanded navigator only
    Scroll Element Into View    xpath=//table[@title="${entity name}" and contains(@id, 'entity-panel')]
    Page Should Contain Element    xpath=//table[@title="${entity name}" and contains(@id, 'entity-panel')]
    Page Should Contain Element    xpath=//div[@title="${entity name}"]/table/tbody/tr/td[2]/div/table/tbody/tr/td[2]/div/a
    Reload Page
    Wait Until Page Contains Element    xpath=//a[contains(@class, 'ewb-breadcrumb-terminal')]    20s
    Robust Click    xpath=//a[contains(@class, 'ewb-breadcrumb-terminal')]
    Page Should Contain Element    xpath=//table[@title="${entity name}" and contains(@id, 'entity-panel')]
    Wait Until Page Contains Element    xpath=//div[@title="${entity name}"]/table/tbody/tr/td[2]/div/table/tbody/tr/td[2]/div/a    30s

Open Content Header Delete Entity Dialog
    [Arguments]    ${entity name}
    [Documentation]    Opens the delete entity dialog for the entity given by ${entity name} using the content header context menu.
    Open Content Header Tool Menu
    Select Delete Entity    ${entity name}

Open Tile Delete Entity Dialog
    [Arguments]    ${entity name}
    [Documentation]    Opens the delete entity dialog for the entity given by ${entity name} using the tile context menu.
    Open Tile Header Tool Menu    ${entity name}
    Select Delete Entity    ${entity name}

Open Navigator Delete Entity Dialog
    [Arguments]    ${entity name}
    [Documentation]    Opens the delete entity dialog for the entity given by ${entity name} using the navigator context menu.
    Open Navigator Tool Menu    ${entity name}
    Select Delete Entity    ${entity name}

Select Delete Entity
    [Arguments]    ${entity name}
    [Documentation]    Selects "Delete" from the context menu. The context menu must be open before using this keyword.
    Click link    xpath=//a[text()="Delete"]

Select Deletion Reason
    [Arguments]    ${deletion reason}
    [Documentation]    Enter Documentation Here
    Robust Click    xpath=//div[text()="${deletion reason}"]
    ${Attribute}    IDBSSelenium2Library.Get Element Attribute    xpath=//div[text()="${deletion reason}"]@class
    Should Contain    ${Attribute}    ewb-listbox-item-selected

Enter Deletion Comment
    [Arguments]    ${deletion comment}
    [Documentation]    Enter Documentation Here
    Wait Until Page Contains Element    ewb-authentication-user-additional-comment
    ${status}    ${value}=    Run Keyword And Ignore Error    Should Be Empty    ${deletion comment}
    Run Keyword If    '${status}'=='FAIL'    Input Text    ewb-authentication-user-additional-comment    ${deletion comment}
    ${text_field_value}=    Run Keyword If    '${status}'=='FAIL'    Get Value    ewb-authentication-user-additional-comment
    Run Keyword If    '${status}'=='FAIL'    Should Be Equal As Strings    ${text_field_value}    ${deletion comment}

Open Comment History
    Robust Link Click    ewb-authentication-user-recent-comment-link

Select Historical Delete Comment
    [Arguments]    ${Historical Comment}
    Wait Until Page Contains Element    xpath=//a[text()="${Historical Comment}"]
    Robust Link Click    xpath=//a[text()="${Historical Comment}"]
    Wait Until Keyword Succeeds    10s    1s    Textarea Should Contain    xpath=//textarea[contains(@class,'ewb-textbox')]    ${Historical Comment}

Check Historical Comment Listed
    [Arguments]    ${Historical Comment}    ${List Position}
    ${prev_kw}=    Register Keyword To Run On Failure    Nothing
    Wait Until Element Text Is    xpath=//li[contains(@id,'ewb-authentication-user-action-note-history-')]/../li[${List Position}]/a    ${Historical Comment}    10s
    Register Keyword To Run On Failure    ${prev_kw}

Move Entity
    [Arguments]    ${entity name}    ${old parent entity}    ${new parent entity}    ${move location}
    [Documentation]    Basic creation of any entity type configured within the system.
    ...    ${entity name} = The display name of the entity to be moved.
    ...    ${old parent entity} = The current parent entity of the entity to be moved.
    ...    ${new parent entity} = The new parent entity of the entity to be moved.
    ...    ${deletion location} = Where to move the entity from. Either "NAVIGATOR" or "TILE"
    # KEYWORD STUB

Check Entity In Navigator
    [Arguments]    ${entity name}
    [Documentation]    *Description*
    ...    Checks that the entity is displayed in the navigator tree in its current state.
    ...
    ...    *Arguments*
    ...    ${entity name} = The display name of the entity being checked for
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - The keyword will fail if the navigator is not expanded to display the checked entity, collapsed sections of the hierarchy will not be checked
    ...
    ...    *Example*
    ...    Create Entity | Group | myGroup | Root | NAVIGATOR
    ...    Check Entity In Navigator | myGroup
    Wait Until Page Contains Element    xpath=//div[@title="${entity name}"]/table/tbody/tr/td[2]/div/table/tbody/tr/td[2]/div/a

Click Load More
    [Documentation]    Clicks the 'Load More' button until it is no longer visible to ensure that all tiles are loaded
    ${status}    ${message}=    Run Keyword And Ignore Error    Wait Until Page Contains Element    ewb-more-entities-panel    1s
    Run Keyword If    '${status}'=='PASS'    Robust Click    ewb-more-entities-panel
    Run Keyword If    '${status}'=='PASS'    sleep    1    # this is to give the button a chance to disappear after clicking load more
    ${status}    ${message}=    Run Keyword And Ignore Error    Wait Until Page Contains Element    ewb-more-entities-panel    1s
    Run Keyword If    '${status}'=='PASS'    Click Load More

Check Entity In Tile View
    [Arguments]    ${entity name}    ${load more}=YES
    [Documentation]    *Description*
    ...    Checks that the entity is displayed in the tile view
    ...
    ...    *Arguments*
    ...    ${entity name} = The display name of the entity being checked for
    ...    ${load more} = Controls whether or not the 'Load more...' button will be clicked before checking for the entity, defaults to 'YES'
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - The tile view containing the expected entity must be displayed
    ...
    ...    *Example*
    ...    Create Entity | Group | myGroup | Root | NAVIGATOR
    ...    Check Entity In Tile View | myGroup
    Run Keyword If    '${load more}' == 'YES'    Click Load More    # Make sure that all tiles are visible before checking
    Wait Until Page Contains Element    xpath=//table[contains(@class, 'ewb-entity-item-panel') and (@title="${entity name}")]    30 sec
    Wait Until Keyword Succeeds    30 sec    1 sec    Scroll Element Into View    xpath=//table[contains(@class, 'ewb-entity-item-panel') and (@title="${entity name}")]

Check Entity Not In Tile View
    [Arguments]    ${entity name}    ${load more}=YES
    [Documentation]    *Description*
    ...    Checks that the entity is not displayed in the tile view
    ...
    ...    *Arguments*
    ...    ${entity name} = The display name of the entity being checked for
    ...    ${load more} = Controls whether or not the 'Load more...' button will be clicked before checking for the entity, defaults to 'YES'
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - The tile view containing the checked entity must be displayed
    ...
    ...    *Example*
    ...    Log In Via Login Dialog | User | Password
    ...    Create Entity | Project | myProject | Administrators | TILE
    ...    Check Entity Not In Tile View | myProject
    Run Keyword If    '${load more}' == 'YES'    Click Load More    # Make sure that all tiles are visible before checking
    Wait Until Page Does Not Contain Element    xpath=//a[contains(@class, 'ewb-anchor') and (text()="${entity name}")]    30 sec

Check Entity Not In Navigator
    [Arguments]    ${entity name}
    [Documentation]    *Description*
    ...    Checks that the entity is not displayed in the navigator tree in its current state.
    ...
    ...    *Arguments*
    ...    ${entity name} = The display name of the entity being checked for
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    Create Entity | Group | myGroup | Root | NAVIGATOR
    ...    Collapse Nodes
    ...    Click Navigator Link | Root
    ...    Check Entity Not In Navigator | myGroup
    ${status}    ${message}=    Run Keyword And Ignore Error    Page Should Not Contain Element    xpath=//div[@title="${entity name}"]/table/tbody/tr/td[2]/div/table/tbody/tr/td[2]/div/a
    Run Keyword If    '${status}'=='FAIL'    Element Should Not Be Visible    xpath=//div[@title="${entity name}"]/table/tbody/tr/td[2]/div/table/tbody/tr/td[2]/div/a

Create Record From Template
    [Arguments]    ${entity type}    ${entity name}    ${parent entity}    ${creation location}    ${Template}
    [Documentation]    *Description*
    ...    Creation of record type from existing record or template. \ Only the display attribute is configured.
    ...
    ...    *Arguments*
    ...    ${entity type} = Display type of the entity type being created. e.g. "Experiment"
    ...    ${entity name} = The display name to be used for the new entity.
    ...    ${parent entity} = The parent entity of the new entity.
    ...    ${creation location} = Where to create the entity from. Either "DIALOG" "CONTENT HEADER", "TILE" or "NAVIGATOR"
    ...    ${Template} = Path to the template or record to use.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    If using ${creation location} = TILE, the parent entity tile must be displayed in the content panel
    ...    If using ${creation location} = CONTENT HEADER, the content panel must be displaying the parent entity
    ...    If using ${creation location} = NAVIGATOR, the parent entity must be visible in the navigator panel
    ...
    ...    *Example*
    ...    Log In Via Login Dialog | Username | Password
    ...    Create Entity | Group | myGroup | Root | NAVIGATOR
    Run Keyword If    '${creation location}' == 'DIALOG'    Dialog Create Record From Template    ${entity type}    ${entity name}    ${Template}
    Run Keyword If    '${creation location}' == 'CONTENT HEADER'    Dialog Create Record From Template    ${entity type}    ${entity name}    ${Template}
    Run Keyword If    '${creation location}' == 'TILE'    Dialog Create Record From Template    ${entity type}    ${entity name}    ${Template}
    Run Keyword If    '${creation location}' == 'NAVIGATOR'    Navigator Tree Create Record From Template    ${parent entity}    ${entity type}    ${entity name}    ${Template}
    Navigation Title Check    IDBS E-WorkBook - ${entity name}

Navigator Tree Create Record From Template
    [Arguments]    ${Parent Display Name}    ${Entity Type}    ${Title}    ${Template}
    [Documentation]    *Should be accessed by "Create Entity" keyword with the creation location argument "NAVIGATOR"*
    ...
    ...    *Description*
    ...    Basic creation of any entity type configured within the system. Only the display attribute is configured.
    ...
    ...    *Arguments*
    ...    ${parent display name} = The name of the parent entity
    ...    ${entity type} = Display type of the entity type being created. e.g. "Experiment"
    ...    ${title} = The display name to be used for the new entity.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    the parent entity must be visible in the navigator panel
    ...
    ...    *Example*
    ...    Log In Via Login Dialog | Username | Password
    ...    Navigator Tree Create Entity | Administrators | Project | myProject
    Open Navigator Tool Menu    ${Parent Display Name}
    ${type_underscores}=    Call Method    ${Entity Type}    replace    ${SPACE}    _
    ${typeUpper}=    Call Method    ${type_underscores}    upper
    Execute Javascript    document.getElementById("ewb-entity-command-template-${typeUpper}").click();
    Select New Record From Template    ${Entity Type}    ${Template}
    Edit Entity Properties Dialog Should Be Present
    Wait Until Keyword Succeeds    60s    10s    Set List Attribute Text Entry    title    ${Title}
    Save Entity Properties And Wait

Tile Create Record From Template
    [Arguments]    ${Tile Display Name}    ${Entity Type}    ${Title}    ${Template}
    [Documentation]    *Should be accessed by "Create Entity" keyword with the creation location argument "TILE"*
    ...
    ...    *Description*
    ...    Basic creation of any entity type configured within the system. Only the display attribute is configured.
    ...
    ...    *Arguments*
    ...    ${tile display name} = The name of the parent entity
    ...    ${entity type} = Display type of the entity type being created. e.g. "Experiment"
    ...    ${title} = The display name to be used for the new entity.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    the content panel must be displaying the parent entity as a tile
    ...
    ...    *Example*
    ...    Log In Via Login Dialog | Username | Password
    ...    Tile Create Entity | Administrators | Project | myProject
    Open Tile Header Tool Menu    ${Tile Display Name}
    Create New Record From Template    ${Entity Type}    ${Title}    ${Template}

Content Header Create Record From Template
    [Arguments]    ${Entity Type}    ${Title}    ${Template}
    [Documentation]    *Should be accessed by "Create Entity" keyword with the creation location argument "CONTENT HEADER"*
    ...
    ...    *Description*
    ...    Basic creation of any entity type configured within the system. Only the display attribute is configured.
    ...
    ...    *Arguments*
    ...    ${entity type} = Display type of the entity type being created. e.g. "Experiment"
    ...    ${title} = The display name to be used for the new entity.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    the content panel must be displaying the parent entity
    ...
    ...    *Example*
    ...    Log In Via Login Dialog | Username | Password
    ...    Content Header Create Entity | Group | myGroup
    Open Content Header Tool Menu
    Create New Record From Template    ${Entity Type}    ${Title}    ${Template}

Dialog Create Record From Template
    [Arguments]    ${Entity Type}    ${Title}    ${Template}
    [Documentation]    *Should be accessed by "Create Entity" keyword with the creation location argument "DIALOG", "CONTENT HEADER" or "TILE"*
    ...
    ...    *Description*
    ...    Basic creation of any entity type configured within the system. Only the display attribute is configured.
    ...
    ...    *Arguments*
    ...    ${entity type} = Display type of the entity type being created. e.g. "Experiment"
    ...    ${title} = The display name to be used for the new entity.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    the content panel must be displaying the parent entity
    ...
    ...    *Example*
    ...    Log In Via Login Dialog | Username | Password
    ...    Content Header Create Entity | Group | myGroup
    Robust Click    xpath=//*[contains(@class,"ewb-new-entity-panel")]
    Wait Until Page Contains Element    xpath=//*[contains(@class,"ewb-new-entity-dialog")]
    Create New Record From Template    ${Entity Type}    ${Title}    ${Template}

Create New Record From Template
    [Arguments]    ${Entity Type}    ${Title}    ${Template}
    [Documentation]    Selects New > ${Type} from the context menu using "Select New Entity Type" keyword and enters the ${Title} value into the display attribute field and creates the entity.
    Select Template Type in New Entity Dialog    ${Entity Type}
    Select New Record From Template    ${Entity Type}    ${Template}
    Edit Entity Properties Dialog Should Be Present
    Wait Until Keyword Succeeds    60s    10s    Set List Attribute Text Entry    title    ${Title}
    Save Entity Properties And Wait

Select New Record From Template
    [Arguments]    ${Type}    ${Template}
    [Documentation]    Selects a given template in the _Find Template_ dialogue
    ...
    ...    Choses a template from the heirarchy
    ...
    ...    The find template dialogue must be open prior to running this keyword
    ${previous_kw}=    Register Keyword To Run On Failure    Nothing
    ${status}    ${value}=    Run Keyword And Ignore Error    Dialog Should Be Present    Find Template    10s
    Run Keyword If    '${status}'=='FAIL'    Dialog Should Be Present    Find an Existing Record to Clone    10s
    Wait Five Seconds
    Select Template Node    ${Template}
    Register Keyword To Run On Failure    ${previous_kw}
    Edit Entity Properties Dialog Should Be Present

Select Template Type in New Entity Dialog
    [Arguments]    ${Type}
    [Documentation]    Selects the Find Template button in the Create New Entity dialogue for a given Record type
    ${new_entity_id}=    Evaluate    ('ewb-entity-command-new-' + '${Type}'.upper()).replace(' ', '_')
    Wait Until Keyword Succeeds    10s    1s    Robust Click    xpath=//div[@id='${new_entity_id}']/../div[@class='find-template']

Select Template Node
    [Arguments]    ${Template}
    [Documentation]    Selects specified template node in Select Item dialog
    ...
    ...    *Arguments*
    ...    ${Template} = The path to the template node
    @{levels}    Call Method    ${Template}    split    /
    Select Navigator Node    @{levels}

Select Navigator Node
    [Arguments]    @{navigator_levels}
    [Documentation]    Selects specified template node in Select Item dialog
    ...
    ...    *Arguments*
    ...    ${Template} = The path to the template node
    ${number_node_levels}=    Get Length    ${navigator_levels}
    : FOR    ${navigator_level}    IN RANGE    1    ${number_node_levels}
    \    ${navigator_level_parent}=    Evaluate    int(${navigator_level})-1
    \    Expand Navigator Node    @{navigator_levels}[${navigator_level_parent}]
    \    Expand Navigator Node    @{navigator_levels}[${navigator_level}]    # Attempted expand of the current node (even if its the terminal node) required to bring the element into view when using IEDriver
    \    Click Navigator Node    @{navigator_levels}[${navigator_level}]
    Click OK

Get Entity Id From Record
    [Documentation]    Gets the entity id for the selected entity from the record html body
    ...
    ...    *Returns*
    ...
    ...    ${ENTITY_ID}
    Wait Until Page Contains Element    xpath=//body[@ewb-selected-entity-id]    30s
    ${ENTITY_ID}    IDBSSelenium2Library.Get Element Attribute    xpath=//body@ewb-selected-entity-id    # This looks a little weird, but there should only ever be one element on the page with the 'ewb-selected-entity-id' attribute, so we use that to select the element and then extract the attribute value
    [Return]    ${ENTITY_ID}

Page Should Contain Tile
    [Arguments]    ${tile name}
    Page Should Contain    xpath=//a[contains(@id,'entity-panel') and text()="${tile name}"]

Create Template
    [Arguments]    ${group name}    ${project name}    ${template name}
    [Documentation]    Creates and saves a new template in the system
    ...
    ...    *Arguments*
    ...    ${group name} - The name of the group in the navigator to create the template under
    ...    ${project name} - The name of the project in the navigator to create the template under
    ...    ${template name} - The name of the template to create
    Click Tile    ${group name}
    Click Tile    ${project name}
    Wait Five Seconds
    Create Entity    Template    ${template name}    ${project name}    CONTENT HEADER
    Wait Five Seconds
    Title Should Be    IDBS E-WorkBook - ${template name}
    Lock Record If Unlocked
    Unlock Record
    Reload Page
    Wait Five Seconds

Edit Entity by Tile Menu
    [Arguments]    ${name}    ${override lock}=yes
    [Documentation]    Opens the delete entity dialog for the entity given by ${entity name} using the tile context menu.
    Open Tile Header Tool Menu    ${name}
    Robust Link Click    xpath=//a[text()="Edit"]
    ${check status}    ${value} =    Run Keyword And Ignore Error    Page Should Contain    You already have a lock on this entity.
    Run Keyword If    '${check status}'=='PASS'    Override Lock    ${override lock}

Edit Entity by Navigator Menu
    [Arguments]    ${name}    ${override lock}=yes
    [Documentation]    Opens the delete entity dialog for the entity given by ${entity name} using the tile context menu.
    Open Navigator Tool Menu    ${name}
    Robust Click    ewb-command-edit-record-menu
    ${check status}    ${value} =    Run Keyword And Ignore Error    Wait Until Page Contains Element    xpath=//div[contains(text(), 'You already have a lock on this entity')]    2s
    Run Keyword If    '${check status}'=='PASS'    Override Lock    ${override lock}

_Hover
    [Arguments]    ${element_id}
    ${string}=    Catenate    var elem = document.getElementById('${element_id}');    if( document.createEvent) {    var evObj = document.createEvent('MouseEvents');    evObj.initEvent( 'mouseover', true, false );    elem.dispatchEvent(evObj);
    ...    } else if( document.createEventObject ) {    elem.fireEvent('onmouseover');    }
    Log    ${string}
    Wait Until Keyword Succeeds    5s    1s    Execute Javascript    ${string}

_JS_ENTER
    [Arguments]    ${element_id}
    ${js_enter}=    Catenate    document.getElementById('${element_id}').onchange();
    Comment    ${js_enter}=    Catenate    var elem = document.getElementById('${element_id}');    var eventObject = document.createEvent('TextEvent');    eventObject.initTextEvent('textInput',true,true,null,'abc\\n');    elem.dispatchEvent(eventObject);
    Comment    ${string}=    Catenate    var elem = document.getElementById('${element_id}');    if( document.createEvent) {    var evObj = document.createEvent('MouseEvents');    evObj.initEvent( 'mouseover', true, false );
    ...    elem.dispatchEvent(evObj);    } else if( document.createEventObject ) {    elem.fireEvent('onmouseover');    }
    Log    ${js_enter}
    Wait Until Keyword Succeeds    5s    1s    Execute Javascript    ${js_enter}
    Sleep    5s

Check record Entity ID
    [Arguments]    ${ENTITY_ID}
    [Documentation]    Checks that the entity ID retrieved from the record matches the entity ID specified
    ${PROPERTY_PANEL_ENTITY_ID}    Get Entity Id From Record
    Should Be Equal    ${ENTITY_ID}    ${PROPERTY_PANEL_ENTITY_ID}

Create Experiment Structure
    [Arguments]    ${user}=${VALID USER}    ${password}=${VALID PASSWD}
    [Documentation]    Creates an experiment in the hierarchy by adding all parent entities fro the root downwards.
    Advanced Create Experiment Structure    no    no    ${user}    ${password}

Advanced Create Experiment Structure
    [Arguments]    ${add-document}=yes    ${save}=version    ${user}=${VALID USER}    ${password}=${VALID PASSWD}
    [Documentation]    Creates an experiment in the hierarchy by adding all parent entities for the root downwards.
    ...
    ...    *Parameters*
    ...
    ...    _add-document_ if *yes* (the default) then a web link document type is added with a link to http://www.idbs.com
    ...
    ...    _save_ if *draft* then the experiment is draft saved, if *version* (the default) it is version saved
    ...
    ...    _user_ the name of the user used to create the experiment hierarchy, defaults to ${VALID_USER}
    ...
    ...    _password_ the password of the user used to create the experiment hierarchy, defaults to ${VALID_PASSWD}
    ...
    ...    *On exit*
    ...    _${suite-group-name}_ contains the created group name
    ...
    ...    _${suite-project-name}_ contains the created project name
    ...
    ...    _${suite-experiment-name}_ contains the created experiment name
    ...
    ...    _${suite-group-id}_ contains the group entity id
    ...
    ...    _${suite-project-id}_ contains the project entity id
    ...
    ...    _${suite-experiment-id}_ contains the experiment entity id
    ...
    ...    _${suite-document-id}_ contains the document id (if one was created)
    ${entity-name-middle}=    Get Time    epoch
    Set Suite Variable    ${suite-group-name}    Automated Test Data ${entity-name-middle}
    Set Suite Variable    ${suite-project-name}    Project ${entity-name-middle}
    Set Suite Variable    ${suite-experiment-name}    Experiment ${entity-name-middle} - 1
    Set Suite Variable    ${rest_api_host}    ${SERVER}
    Set Suite Variable    ${rest_api_user}    ${user}
    Set Suite Variable    ${rest_api_password}    ${password}
    ${GroupID}=    EntityAPILibrary.Create Group    1    ${suite-group-name}
    ${ProjectID}=    EntityAPILibrary.Create Project    ${GroupID}    ${suite-project-name}
    ${RecordID}=    EntityAPILibrary.Create Experiment    ${ProjectID}    ${suite-experiment-name}
    Set Suite Variable    ${suite-group-id}    ${GroupID}
    Set Suite Variable    ${suite-project-id}    ${ProjectID}
    Set Suite Variable    ${suite-experiment-id}    ${RecordID}
    ${document-id}=    Run Keyword If    '${add-document}'=='yes'    EntityAPILibrary.Create Web Link Document    ${suite-experiment-id}    http://www.idbs.com
    Run Keyword If    '${add-document}'=='yes'    Set Suite Variable    ${suite-document-id}    ${document-id}
    Run Keyword If    '${save}'=='version'    EntityAPILibrary.Version Save    ${suite-experiment-id}    Data Added

Create Draft Saved Experiment Structure
    [Arguments]    ${user}=${VALID USER}    ${password}=${VALID PASSWD}
    [Documentation]    Creates a draft saved experiment in the hierarchy.
    ...
    ...    *Parameters*
    ...
    ...    _user_ the name of the user used to create the experiment hierarchy, defaults to ${VALID_USER}
    ...
    ...    _password_ the password of the user used to create the experiment hierarchy, defaults to ${VALID_PASSWD}
    ...
    ...    *On exit*
    ...    _${suite-group-name}_ contains the created group name
    ...
    ...    _${suite-project-name}_ contains the created project name
    ...
    ...    _${suite-experiment-name}_ contains the created experiment name
    ...
    ...    _${suite-group-id}_ contains the group entity id
    ...
    ...    _${suite-project-id}_ contains the project entity id
    ...
    ...    _${suite-experiment-id}_ contains the experiment entity id
    ...
    ...    _${suite-document-id}_ contains the document id (if one was created)
    Advanced Create Experiment Structure    yes    draft    ${user}    ${password}

Create Version Saved Experiment Structure
    [Arguments]    ${user}=${VALID USER}    ${password}=${VALID PASSWD}
    [Documentation]    Creates a version saved experiment in the hierarchy.
    ...
    ...    *Parameters*
    ...
    ...    _user_ the name of the user used to create the experiment hierarchy, defaults to ${VALID_USER}
    ...
    ...    _password_ the password of the user used to create the experiment hierarchy, defaults to ${VALID_PASSWD}
    ...
    ...    *On exit*
    ...    _${suite-group-name}_ contains the created group name
    ...
    ...    _${suite-project-name}_ contains the created project name
    ...
    ...    _${suite-experiment-name}_ contains the created experiment name
    ...
    ...    _${suite-group-id}_ contains the group entity id
    ...
    ...    _${suite-project-id}_ contains the project entity id
    ...
    ...    _${suite-experiment-id}_ contains the experiment entity id
    ...
    ...    _${suite-document-id}_ contains the document id (if one was created)
    Advanced Create Experiment Structure    yes    version    ${user}    ${password}

Delete Experiment Structure
    [Arguments]    ${experiment-id}=${suite-experiment-id}    ${group-id}=${suite-group-id}
    Set Rest API User    ${VALID USER}    ${VALID PASSWD}
    Run Keyword And Ignore Error    EntityAPILibrary.Unlock Entity    ${experiment-id}
    Run Keyword And Ignore Error    EntityAPILibrary.Delete Entity    ${group-id}    testing    testing

Open Browser To Entity
    [Arguments]    ${Entity Id}=1    ${User}=${VALID USER}    ${Password}=${VALID PASSWD}    # The entity Id to browse to
    Open Browser to Page    ${WEB_CLIENT_HTTP_SCHEME}://${SERVER}:${WEB_CLIENT_PORT}/EWorkbookWebApp/#entity/displayEntity?entityId=${Entity Id}&r=y&v=y    ${User}    ${Password}

Open Browser To Experiment
    [Arguments]    ${Entity Id}    ${User}=${VALID USER}    ${Password}=${VALID PASSWD}    # The entity Id to browse to
    Open Browser to Page    ${WEB_CLIENT_HTTP_SCHEME}://${SERVER}:${WEB_CLIENT_PORT}/EWorkbookWebApp/#entity/displayEntity?entityId=${Entity Id}&r=y&v=y    ${User}    ${Password}
    Check Record Header Bar Loaded
    Wait For Record Outline

Select Move Entity in Navigator
    [Arguments]    ${entity name}
    [Documentation]    Selects move entity command in the navigator
    Open Navigator Tool Menu    ${entity name}
    Robust Click    ${ewb-entity-command-move}
    Dialog Should Be Present    Select a place on the hierarchy to move to

Disable Publishing Menu Option
    [Arguments]    ${entity_id}
    [Documentation]    Disables the 'Publish' workflow menu option for the given entity
    ${PATH1}=    Get File    ${CURDIR}/../../../Test Data/Web Client/Disable Publishing Menu Option/MENU_DISPLAY_CONFIG.xml
    Replace Entity Config    ${entity_id}    MENU_DISPLAY_CONFIG    ${PATH1}

Disable Sign Off Menu Option
    [Arguments]    ${entity_id}
    [Documentation]    Disables the 'Sign Off' workflow menu option for the given entity
    ${PATH1}=    Get File    ${CURDIR}/../../../Test Data/Web Client/Disable Sign Off Menu Option/MENU_DISPLAY_CONFIG.xml
    Replace Entity Config    ${entity_id}    MENU_DISPLAY_CONFIG    ${PATH1}

Set Default Menu Options
    [Arguments]    ${entity_id}
    [Documentation]    Resets the publish and signoff menu options to their default (ON) values
    Reset Entity Config    ${entity_id}    MENU_DISPLAY_CONFIG

Go To Root Entity
    [Documentation]    Goes to Root
    Go To Entity    1

Go To Device Definitions Entity
    [Documentation]    Goes to Device Definitions
    Go To Entity    3

Go To Entity
    [Arguments]    ${entity id}
    [Documentation]    Goes to the specified entity ID
    Go To    ${WEB_CLIENT_HTTP_SCHEME}://${SERVER}:${WEB_CLIENT_PORT}/EWorkbookWebApp/#entity/displayEntity?entityId=${entity id}&r=y&v=y
    #Idea here is that if the entity takes more than 6 seconds to appear, it's probably not coming, so try the click again. Using a for loop to do that 5 times.
    :FOR    ${i}    IN RANGE    5
    \    ${entity_present}=    Run Keyword And Return Status    Wait Until Keyword Succeeds    6s    1s    Check For Selected Entity
    \    ...    ${entity id}
    \    Exit For Loop If    ${entity_present}
    Run Keyword Unless    ${entity_present}    Fail    Entity was not present after 5 navigation attempts.

Go To Experiment
    [Arguments]    ${entity id}
    [Documentation]    Goes to the specified experiment. Same as Go To Entity, however this keyword attempts to wait until the experiment has been rendered before returning
    Go To Entity    ${entity id}
    Check Record Header Bar Loaded
    Wait For Record Outline

Check For Selected Entity
    [Arguments]    ${entity id}
    [Documentation]    Checks that the selected entity id matches the given value
    ${selected entity id}=    Get Entity Id From Record
    ${equal}=    Run Keyword and Return Status    Should Be Equal As Strings    ${selected entity id}    ${entity id}
    Run Keyword Unless    ${equal}    Capture Page Screenshot    # See if we can find out why it has failed
    Run Keyword Unless    ${equal}    Fail    Selected entity ${selected entity id} is not the expected entity ${entity id}

Rename Experiment And Save
    [Arguments]    ${user name}    ${password}    ${entity id}    ${new name}
    [Documentation]    Renames an experiment
    Go To Experiment    ${entity id}
    Open Record Properties
    Edit Entity Properties
    Wait Until Keyword Succeeds    30s    1s    Input Text    xpath=//input[contains(@id,'ewb-attribute-editor-title-input')]    ${EMPTY}
    Wait Until Keyword Succeeds    30s    1s    Input Text    xpath=//input[contains(@id,'ewb-attribute-editor-title-input')]    ${new name}
    Save Entity Properties
    Click away from Property Panel
    Version Save Record    ${user name}    ${password}    Break

Edit Entity Properties Dialog Should Be Present
    [Documentation]    Checks that the edit entity properties dialog is present
    Wait Until Page Contains Element    xpath=//div[contains(@class, 'ewb-properties-panel')]    10s
    Wait Until Page Contains Element    save-properties    10s

Save Entity Properties
    [Documentation]    Clicks the 'Save/Create' button on the entity properties page
    Focus    save-properties
    Sleep    0.5s    Give blur and focus events time to run.
    Robust Click    save-properties

Save Entity Properties And Wait
    [Documentation]    Clicks the 'Save/Create' button on the entity properties page and waits for the save to complete
    Save Entity Properties
    Wait For No Mask

Edit Entity Properties
    [Documentation]    Clicks the 'Edit' button on the entity properties page
    Robust Click    edit-properties
    Wait For Mask

Cancel Edit Entity Properties
    [Documentation]    Clicks the 'Cancel' button on the entity properties page
    Robust Click    cancel-properties
    Wait For No Mask

Select Item Node
    [Arguments]    ${item_path}
    [Documentation]    Selects specified item node in Select Item dialog
    ...
    ...    *Arguments*
    ...    ${item_path} = The path to the item node
    @{levels}    Call Method    ${item_path}    split    /
    Select Navigator Node    @{levels}

Create Record From Record
    [Arguments]    ${Entity Type}    ${Title}    ${Template}
    [Documentation]    Creates the record from the dialog box via the add entity button
    ...
    ...    Selects Cloned ${Type} from the context menu using "Select Clone Entity Type" keyword and enters the ${Title} value into the display attribute field; creating the entity.
    ...
    ...    Selects via the New button and the user should be in the parent entity of the location they wish to create in
    Robust Click    xpath=//*[contains(@class,"ewb-new-entity-panel")]
    Wait Until Page Contains Element    xpath=//*[contains(@class,"ewb-new-entity-dialog")]
    Select Clone Type in New Entity Dialog    ${Entity Type}
    Select New Record From Template    ${Entity Type}    ${Template}
    Edit Entity Properties Dialog Should Be Present
    Wait Until Keyword Succeeds    60s    10s    Set List Attribute Text Entry    title    ${Title}
    Save Entity Properties And Wait
    Navigation Title Check    IDBS E-WorkBook - ${Title}

Select Clone Type in New Entity Dialog
    [Arguments]    ${Type}
    [Documentation]    Selects the Cloned ${Type} button in the Create New Entity dialogue for a given Record type
    ${new_entity_id}=    Evaluate    ('ewb-entity-command-template-' + '${Type}'.upper()).replace(' ', '_')
    Wait Until Keyword Succeeds    10s    1s    Robust Click    ${new_entity_id}

Rename Record From Tile View
    [Arguments]    ${entity_name}    ${new_entity_name}    ${save_option}    ${user}    ${passwd}
    [Documentation]    Renames an record from tile view
    ...
    ...    *Arguments*
    ...
    ...    ${entity_name} - record name as it appears to rename
    ...    ${new_entity_name} - new title name to be used on rename
    ...    ${save_option} - save type [Draft or Version]
    ...    ${user} & \ ${passwd} - ewb user valid credentials to save
    Tile Edit Entity Properties    ${entity_name}
    Wait Until Keyword Succeeds    30s    1s    Input Text    xpath=//input[contains(@id,'ewb-attribute-editor-title-input')]    ${EMPTY}
    Wait Until Keyword Succeeds    30s    1s    Input Text    xpath=//input[contains(@id,'ewb-attribute-editor-title-input')]    ${new_entity_name}
    Save Entity Properties
    Run Keyword If    '${save_option}'=='Draft'    Robust Click    xpath=//button[text()="Save Draft"]
    Run Keyword If    '${save_option}'=='Version'    Robust Click    xpath=//button[text()="Version"]
    Run Keyword If    '${save_option}'=='Version'    Authenticate Session    ${user}    ${passwd}
    Click away from Property Panel

Rename Entity From Tile View
    [Arguments]    ${entity_name}    ${new_entity_name}    ${user}    ${passwd}
    [Documentation]    Renames an entity from tile view
    ...
    ...    This keyword version saves the entity
    ...
    ...    *Arguments*
    ...
    ...    ${entity_name} - record name as it appears to rename
    ...    ${new_entity_name} - new title name to be used on rename
    ...    ${user} & \ ${passwd} - ewb user valid credentials to save
    Tile Edit Entity Properties    ${entity_name}
    Wait Until Keyword Succeeds    30s    1s    Input Text    xpath=//input[contains(@id,'ewb-attribute-editor-title')]    ${EMPTY}
    Wait Until Keyword Succeeds    30s    1s    Input Text    xpath=//input[contains(@id,'ewb-attribute-editor-title')]    ${new_entity_name}
    Save Entity Properties
    Authenticate Session    ${user}    ${passwd}
    Click away from Property Panel

Tile Order Should Be
    [Arguments]    @{tile_names}
    ${total_tiles}=    Get Length    ${tile_names}
    : FOR    ${index}    IN RANGE    ${total_tiles}
    \    ${index2}=    evaluate    ${index}+1
    \    ${tile_name}=    Get From List    ${tile_names}    ${index}
    \    Element Should Contain    entity-panel-${index2}-header    ${tile_name}
