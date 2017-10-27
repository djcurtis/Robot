*** Settings ***
Documentation     A resource file containing IDBS defined keywords used for testing the IDBS E-WorkBook Web Client application. This resource file contains keywords applicable to testing the properties panel.
...               This file is loaded by the common_resource.txt file which is automatically loaded when running tests through the Robot Framework.
...               *Version: E-WorkBook Web Client 9.1.0*
Library           CheckLibrary
Library           Collections
Library           IDBSSelenium2Library
Resource          general_resource.robot
Resource          record_resource.robot

*** Variables ***
${value cell locator}    /../..//*[contains(@class, 'ewb-property-value')]
${mandatory header}    propertiesHeader_Mandatory
${optional header}    propertiesHeader_Optional
${read only header}    propertiesHeader_Read Only
${version infomation header}    propertiesHeader_Version Information
${properties panel title}    xpath=//div[contains(@class, 'ewb-attribute-selection-panel')]
${unique id title}    xpath=//div[text()="Unique Id"]
${version number title}    xpath=//div[text()="Version number"]
${user title}     xpath=//div[text()="User"]
${timestamp title}    xpath=//div[text()="Time Stamp"]
${comment title}    xpath=//div[text()="Comment"]
${unique id value}    xpath=//div[text()="Unique Id"]${value cell locator}
${version number value}    xpath=//div[text()="Version number"]${value cell locator}
${user value}     xpath=//div[text()="User"]${value cell locator}
${timestamp value}    xpath=//div[text()="Timestamp"]${value cell locator}
${comment value}    xpath=//div[text()="Comment"]${value cell locator}
${additional comment value}    xpath=//div[text()="Additional Comment"]${value cell locator}
${status title}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="Status")]
${title title}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="Title")]
${name title}     xpath=//div[contains(@class, 'ewb-property-name') and (text()="Name")]
${item type title}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="Item Type")]
${status value}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="Status")]${value cell locator}
${title value}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="Title")]${value cell locator}
${name value}     xpath=//div[contains(@class, 'ewb-property-name') and (text()="Name")]${value cell locator}
${confined title}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="Confined")]
${coshh title}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="COSHH Refs")]
${keywords title}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="Keywords")]
${exp ref title}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="Prev. Exp. Ref")]
${seq edit title}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="Sequential Edit")]
${status change title}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="Status Change")]
${template title}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="Template")]
${templates title}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="Templates")]
${target entity title}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="Target Entity Type")]
${confined value}    xpath=//div[text()="Confined"]${value cell locator}
${coshh value}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="COSHH Refs")]${value cell locator}
${keywords value}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="Keywords")]${value cell locator}
${exp ref value}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="Prev. Exp. Ref")]${value cell locator}
${seq edit value}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="Sequential Edit")]${value cell locator}
${status change value}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="Status Change")]${value cell locator}
${template value}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="Template")]${value cell locator}
${templates value}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="Templates")]${value cell locator}
${target entity value}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="Target Entity Type")]${value cell locator}
${pinned value}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="Pinned Entity")]${value cell locator}
${publishing state value}    xpath=//div[contains(@class, 'ewb-property-name') and (text()="Publishing State")]${value cell locator}
${edit prop button}    edit-properties

*** Keywords ***
Check Properties Panel Present
    [Documentation]    Checks that the Properties Panel is present in the UI.
    Wait Until Page Contains Element    xpath=//div[text()="Properties"]

Check Properties Button Not Present
    [Documentation]    Checks that the Properties Panel Icon is not present in the UI.
    Wait Until Page Does Not Contain Element    ewb-record-action-bar-properties    10s
    Wait Until Page Does Not Contain Element    xpath=//img[contains(@class, 'ewb-entity-properties-button')]    10s

Collapse Mandatory Section
    [Documentation]    Ensures that the mandatory section is collapsed
    Wait Until Keyword Succeeds    10s    1s    _Collapse Section    ${mandatory header}

Collapse Optional Section
    [Documentation]    Ensures that the optional section is collapsed
    Wait Until Keyword Succeeds    10s    1s    _Collapse Section    ${optional header}

Collapse Read Only Section
    [Documentation]    Ensures that the read only section is collapsed
    Wait Until Keyword Succeeds    10s    1s    _Collapse Section    ${read only header}

Collapse Version Information Section
    [Documentation]    Ensures that the version information section is collapsed
    Wait Until Keyword Succeeds    10s    1s    _Collapse Section    ${version infomation header}

Expand Mandatory Section
    [Documentation]    Ensures that the mandatory section is expanded
    Wait Until Keyword Succeeds    10s    1s    _Expand Section    ${mandatory header}

Expand Optional Section
    [Documentation]    Ensures that the optional section is expanded
    Wait Until Keyword Succeeds    10s    1s    _Expand Section    ${optional header}

Expand Read Only Section
    [Documentation]    Ensures that the read only section is expanded
    Wait Until Keyword Succeeds    10s    1s    _Expand Section    ${read only header}

Expand Version Information Section
    [Documentation]    Ensures that the version information section is expanded
    Wait Until Keyword Succeeds    10s    1s    _Expand Section    ${version infomation header}

Check Mandatory Section Expanded - Default Record Types
    [Documentation]    Checks that all mandatory fields are expanded.
    ...    This keyword handles the default record types of Experiment, Report and Template.
    Element Should Be Visible    ${status title}
    Element Should Be Visible    ${title title}

Check Mandatory Section Expanded - Non-Record Types
    [Arguments]    ${record type}
    [Documentation]    This keyword kicks off the corresponding keyword to check that all mandatory fields are expanded based on the ${record type} argument.
    ...    Supported record types are *Root*, *Group*, and *Project*.
    Run Keyword If    '${record type}'=='Root'    Check Read Only Section Expanded - Root
    Run Keyword If    '${record type}'=='Group'    Check Mandatory Section Expanded - Group
    Run Keyword If    '${record type}'=='Project'    Check Mandatory Section Expanded - Project

Check Read Only Section Expanded - Root
    [Documentation]    Checks that all read only fields are expanded.
    ...    This keyword handles the default Root
    Wait Until Element Is Visible    ${name title}

Check Mandatory Section Expanded - Group
    [Documentation]    Checks that all mandatory fields are expanded.
    ...    This keyword handles the default non-record types of Group.
    Wait Until Element Is Visible    ${name title}

Check Mandatory Section Expanded - Project
    [Documentation]    Checks that all mandatory fields are expanded.
    ...    This keyword handles the default non-record type of Project.
    Wait Until Element Is Visible    ${title title}

Check Optional Section Expanded - Default Record Types
    [Documentation]    Checks that all optional fields are expanded.
    ...    This keyword handles the default record types of Experiment and Report. "Check Optional Section Collapsed - Default Template Entities" keyword should be used for templates.
    Wait Until Element Is Visible    ${coshh title}
    Wait Until Element Is Visible    ${keywords title}
    Wait Until Element Is Visible    ${exp ref title}

Check Read Only Section Expanded - Default Record Types
    [Documentation]    Checks that all read only fields are expanded.
    ...    This keyword handles the default record types of Experiment and Report. "Check Read Only Section Collapsed - Default Template Entities" keyword should be used for templates.
    Wait Until Element Is Visible    ${confined title}
    Wait Until Element Is Visible    ${seq edit title}
    Wait Until Element Is Visible    ${status change title}
    Wait Until Element Is Visible    ${template title}
    Wait Until Element Is Visible    ${templates title}

Check Optional Section Expanded - Default Templete Entities
    [Documentation]    Checks that all optional fields are expanded.
    ...    This keyword handles the default template entity only.
    Check Optional Section Expanded - Default Record Types
    Wait Until Element Is Visible    ${target entity title}

Check Read Only Section Expanded - Default Templete Entities
    [Documentation]    Checks that all read only fields are expanded.
    ...    This keyword handles the default template entity only.
    Check Read Only Section Expanded - Default Record Types

Check Version Information Section Expanded
    [Documentation]    Checks that all version information fields are expanded.
    ...    This keyword is applicable to all entity types.
    Wait Until Element Is Visible    ${unique id title}
    Wait Until Element Is Visible    ${version number title}
    Wait Until Element Is Visible    ${user title}
    Wait Until Element Is Visible    ${timestamp title}
    Wait Until Element Is Visible    ${comment title}

Check Mandatory Section Collapsed - Default Record Types
    [Documentation]    Checks that all mandatory fields are collapsed.
    ...    This keyword handles the default record types of Experiment, Report and Template.
    Wait Until Element Is Not Visible    ${status title}
    Wait Until Element Is Not Visible    ${title title}

Check Mandatory Section Collapsed - Non-Record Types
    [Arguments]    ${record type}
    [Documentation]    This keyword kicks off the corresponding keyword to check that all mandatory fields are collapsed based on the ${record type} argument.
    ...    Supported record types are *Root*, *Group*, and *Project*.
    Run Keyword If    '${record type}'=='Root'    Check Read Only Section Collapsed - Root
    Run Keyword If    '${record type}'=='Group'    Check Mandatory Section Collapsed - Group
    Run Keyword If    '${record type}'=='Project'    Check Mandatory Section Collapsed - Project

Check Read Only Section Collapsed - Root
    [Documentation]    Checks that all read only fields are collapsed.
    ...    This keyword handles the default non-record types of Root
    Wait Until Element Is Not Visible    ${name title}

Check Mandatory Section Collapsed - Group
    [Documentation]    Checks that all mandatory fields are collapsed.
    ...    This keyword handles the default non-record types of Group.
    Wait Until Element Is Not Visible    ${name title}

Check Mandatory Section Collapsed - Project
    [Documentation]    Checks that all mandatory fields are collapsed.
    ...    This keyword handles the default non-record type of Project.
    Wait Until Element Is Not Visible    ${title title}

Check Optional Section Collapsed - Default Record Types
    [Documentation]    Checks that all optional fields are collapsed.
    ...    This keyword handles the default record types of Experiment and Report. "Check Optional Section Collapsed - Default Template Entities" keyword should be used for templates.
    Wait Until Element Is Not Visible    ${coshh title}
    Wait Until Element Is Not Visible    ${keywords title}
    Wait Until Element Is Not Visible    ${exp ref title}

Check Read Only Section Collapsed - Default Record Types
    [Documentation]    Checks that all read only fields are collapsed.
    ...    This keyword handles the default record types of Experiment and Report. "Check Read Only Section Collapsed - Default Template Entities" keyword should be used for templates.
    Wait Until Element Is Not Visible    ${confined title}
    Wait Until Element Is Not Visible    ${seq edit title}
    Wait Until Element Is Not Visible    ${status change title}
    Wait Until Element Is Not Visible    ${template title}
    Wait Until Element Is Not Visible    ${templates title}

Check Optional Section Collapsed - Default Templete Entities
    [Documentation]    Checks that all optional fields are collapsed.
    ...    This keyword handles the default template entity only.
    Check Optional Section Collapsed - Default Record Types
    Wait Until Element Is Not Visible    ${target entity title}

Check Read Only Section Collapsed - Default Templete Entities
    [Documentation]    Checks that all read only fields are collapsed.
    ...    This keyword handles the default template entity only.
    Check Read Only Section Collapsed - Default Record Types

Check Version Information Section Collapsed
    [Documentation]    Checks that all version information fields are collapsed.
    ...    This keyword is applicable to all entity types.
    Wait Until Element Is Not Visible    ${unique id title}
    Wait Until Element Is Not Visible    ${version number title}
    Wait Until Element Is Not Visible    ${user title}
    Wait Until Element Is Not Visible    ${timestamp title}
    Wait Until Element Is Not Visible    ${comment title}

Check Unique ID Value
    [Arguments]    ${value}
    [Documentation]    Checks that the properties panel displayed Unique ID value is the same as ${value}
    Wait Until Page Contains Element    ${unique id value}    10s
    Element Text Should Be    ${unique id value}    ${value}

Check Version Number Value
    [Arguments]    @{given_value}
    [Documentation]    Checks that the properties panel displayed Version Number value is the same as ${given_value}
    ...    Has a wait until success set at every 1s for 30s.
    ...
    ...    *Arguments*
    ...
    ...    - _given_value_ - one or more expected version values
    Wait Until Page Contains Element    xpath=//body[@ewb-selected-entity-version-state]    30s
    ${actual_value}=    IDBSSelenium2Library.Get Element Attribute    xpath=//body@ewb-selected-entity-version-state    # This looks a little weird, but there should only ever be one element on the page with the 'ewb-selected-entity-id' attribute, so we use that to select the element and then extract the attribute value
    Collections.List Should Contain Value    ${given_value}    ${actual_value}

Check User Value
    [Arguments]    ${value}
    [Documentation]    Checks that the properties panel displayed User value is the same as ${value}
    Wait Until Page Contains Element    ${user value}    10s
    Element Text Should Be    ${user value}    ${value}

Check Timestamp Value
    [Arguments]    ${value}
    [Documentation]    Checks that the properties panel displayed Timestamp value is the same as ${value}
    Wait Until Page Contains Element    ${timestamp value}    10s
    Element Text Should Be    ${timestamp value}    ${value}

Check Comment Value
    [Arguments]    ${value}
    [Documentation]    Checks that the properties panel displayed Comment value is the same as ${value}
    Wait Until Page Contains Element    ${comment value}    10s
    Element Text Should Be    ${comment value}    ${value}

Check Additional Comment Value
    [Arguments]    ${value}
    [Documentation]    Checks that the properties panel displayed Additional Comment value is the same as ${value}
    Wait Until Page Contains Element    ${additional comment value}    10s
    Element Text Should Be    ${additional comment value}    ${value}

Check Status Value
    [Arguments]    ${value}
    [Documentation]    Checks that the properties panel displayed Status value is the same as ${value}
    Wait Until Page Contains Element    ${status value}
    Element Text Should Be    ${status value}    ${value}

Check Title Value
    [Arguments]    ${value}
    [Documentation]    Checks that the properties panel displayed Title value is the same as ${value}
    Wait Until Page Contains Element    ${title value}
    Element Text Should Be    ${title value}    ${value}

Check Name Value
    [Arguments]    ${value}
    [Documentation]    Checks that the properties panel displayed Name value is the same as ${value}
    Wait Until Page Contains Element    ${name value}
    Element Text Should Be    ${name value}    ${value}

Check Confined Value
    [Arguments]    ${value}
    [Documentation]    Checks that the properties panel displayed Confined value is the same as ${value}
    Wait Until Page Contains Element    ${confined value}    10s
    Element Text Should Be    ${confined value}    ${value}

Check Pinned Value
    [Arguments]    ${value}
    [Documentation]    Checks that the properties panel displayed Pinned value is the same as ${value}
    Wait Until Page Contains Element    ${pinned value}    10s
    Element Text Should Be    ${pinned value}    ${value}

Check COSHH Value
    [Arguments]    ${value}
    [Documentation]    Checks that the properties panel displayed COSHH value is the same as ${value}
    Wait Until Page Contains Element    ${coshh value}    10s
    Element Text Should Be    ${coshh value}    ${value}

Check Keywords Value
    [Arguments]    ${value}
    [Documentation]    Checks that the properties panel displayed Keywords value is the same as ${value}
    Wait Until Page Contains Element    ${keywords value}    10s
    Element Text Should Be    ${keywords value}    ${value}

Check Exp Ref Value
    [Arguments]    ${value}
    [Documentation]    Checks that the properties panel displayed Exp Ref value is the same as ${value}
    Wait Until Page Contains Element    ${exp ref value}    10s
    Element Text Should Be    ${exp ref value}    ${value}

Check Seq Edit Value
    [Arguments]    ${value}
    [Documentation]    Checks that the properties panel displayed Seq Edit value is the same as ${value}
    Wait Until Page Contains Element    ${seq edit value}    10s
    Element Text Should Be    ${seq edit value}    ${value}

Check Status Change Value
    [Arguments]    ${value}
    [Documentation]    Checks that the properties panel displayed Status Change value is the same as ${value}
    Wait Until Page Contains Element    ${status change value}    10s
    Element Text Should Be    ${status change value}    ${value}

Check Template Value
    [Arguments]    ${value}
    [Documentation]    Checks that the properties panel displayed Template value is the same as ${value}
    Wait Until Page Contains Element    ${template value}    10s
    Element Text Should Be    ${template value}    ${value}

Check Templates Value
    [Arguments]    ${value}
    [Documentation]    Checks that the properties panel displayed Templates value is the same as ${value}
    Wait Until Page Contains Element    ${templates value}    10s
    Element Text Should Be    ${templates value}    ${value}

Check Target Entity Value
    [Arguments]    ${value}
    [Documentation]    Checks that the properties panel displayed Target Entity value is the same as ${value}
    Wait Until Page Contains Element    ${target entity value}    10s
    Element Text Should Be    ${target entity value}    ${value}

Check Root Properties Panel Values
    Wait Until Keyword Succeeds    15s    5s    Open Tiles Header Properties
    Ensure All properties Sections Expanded - Root
    Check Name Value    Root
    Check Version Number Value In Properties    1
    Check User Value    Administrator User
    Check Comment Value    Create root entity
    Click away from Property Panel

Check Group Properties Panel Values
    [Arguments]    ${name}    ${version no}    ${user}    ${comment}
    [Documentation]    Checks the values of the default group level attributes.
    ...    ${name} = Group Name
    ...    ${version no} = Group Version Number
    ...    ${user} = Username (not full name)
    ...    ${comment} = Version Comment (Note: initial version = "Created GROUP")
    Wait Until Keyword Succeeds    15s    5s    Open Tiles Header Properties
    Ensure All properties Sections Expanded - Group
    Check Name Value    ${name}
    Check Version Number Value In Properties    ${version no}
    Check User Value    ${user}
    Check Comment Value    ${comment}
    Click away from Property Panel

Check Project Properties Panel Values
    [Arguments]    ${title}    ${version no}    ${user}    ${comment}
    [Documentation]    Checks the values of the default project level attributes.
    ...    ${title} = Project Title
    ...    ${version no} = Project Version Number
    ...    ${user} = Username (not full name)
    ...    ${comment} = Version Comment (Note: initial version = "Created PROJECT")
    Wait Until Keyword Succeeds    15s    5s    Open Tiles Header Properties
    Ensure All properties Sections Expanded - Project
    Check Title Value    ${title}
    Check Version Number Value In Properties    ${version no}
    Check User Value    ${user}
    Check Comment Value    ${comment}
    Click away from Property Panel

Check Record Properties Panel Values
    [Arguments]    ${status}    ${title}    ${version no}    ${user}    ${comment}    ${confined}
    ...    ${coshh}    ${keywords}    ${exp ref}    ${seq edit}    ${status change}    ${template}
    ...    ${templates}
    [Documentation]    Checks the values of the default record level attributes. This does not include Template entities.
    ...    ${status} = Status Value
    ...    ${title} = Record Title
    ...    ${version no} = Record Version Number
    ...    ${user} = Username (not full name)
    ...    ${comment} = Version Comment
    ...    ${confined} = Confined Value
    ...    ${coshh} = COSHH Refs Value
    ...    ${keywords} = Keywords Value
    ...    ${exp ref} = Exp Ref Value
    ...    ${seq edit} = Sequential Edit Value
    ...    ${status change} = Status Change Value
    ...    ${template} = Template Value
    ...    ${templates} = Templates Value
    Wait Until Keyword Succeeds    15s    5s    Open Record Properties
    Ensure All properties Sections Expanded - Default Record Type
    Check Status Value    ${status}
    Check Title Value    ${title}
    Check Version Number Value In Properties    ${version no}
    Check User Value    ${user}
    Check Comment Value    ${comment}
    Check Confined Value    ${confined}
    Check COSHH Value    ${coshh}
    Check Keywords Value    ${keywords}
    Check Exp Ref Value    ${exp ref}
    Check Seq Edit Value    ${seq edit}
    Check Status Change Value    ${status change}
    Check Template Value    ${template}
    Check Templates Value    ${templates}
    Click away from Property Panel

Check Template Properties Panel Values
    [Arguments]    ${status}    ${title}    ${version no}    ${user}    ${comment}    ${confined}
    ...    ${coshh}    ${keywords}    ${exp ref}    ${seq edit}    ${status change}    ${template}
    ...    ${templates}    ${target entity}
    [Documentation]    Checks the values of the default template level attributes.
    ...    ${status} = Status Value
    ...    ${title} = Record Title
    ...    ${version no} = Record Version Number
    ...    ${user} = Username (not full name)
    ...    ${comment} = Version Comment
    ...    ${confined} = Confined Value
    ...    ${coshh} = COSHH Refs Value
    ...    ${keywords} = Keywords Value
    ...    ${exp ref} = Exp Ref Value
    ...    ${seq edit} = Sequential Edit Value
    ...    ${status change} = Status Change Value
    ...    ${template} = Template Value
    ...    ${templates} = Templates Value
    ...    ${target entity} = Target Entity Value
    Wait Until Keyword Succeeds    15s    5s    Open Record Properties
    Ensure All properties Sections Expanded - Default Record Type
    Check Status Value    ${status}
    Check Title Value    ${title}
    Check Version Number Value In Properties    ${version no}
    Check User Value    ${user}
    Check Comment Value    ${comment}
    Check Confined Value    ${confined}
    Check COSHH Value    ${coshh}
    Check Keywords Value    ${keywords}
    Check Exp Ref Value    ${exp ref}
    Check Seq Edit Value    ${seq edit}
    Check Status Change Value    ${status change}
    Check Template Value    ${template}
    Check Templates Value    ${templates}
    Check Target Entity Value    ${target entity}
    Click away from Property Panel

Check Generic Attribute Value
    [Arguments]    ${attribute name}    ${value}
    [Documentation]    Checks that the properties panel displayed Status value is the same as ${value}
    ${result}    ${message}=    Run Keyword and Ignore Error    Wait Until Keyword Succeeds    10s    1s    Element Text Should Be
    ...    xpath=//div[contains(@class, 'ewb-property-name') and text()="${attribute name}"]/../../td[3]/div    ${value}
    Run Keyword If    '${result}'!='PASS'    Wait Until Keyword Succeeds    10s    1s    Element Text Should Be    xpath=//div[text()="${attribute name}"]/../../td[3]/div
    ...    ${value}

Check Generic URL Value
    [Arguments]    ${attribute name}    ${display value}    ${link value}
    [Documentation]    Checks the displayed value and link value of a generic URL attribute
    ...
    ...    *Arguments*
    ...    attribute name = the attribute name as it is displayed within the properties panel
    ...    display value = the expected display value as displayed within the properties panel
    ...    link value = the expected link value as used if the link was clicked
    ...
    ...    *Precondition*
    ...    The attribute being checked must be visible within the properties panel
    ...
    ...    *Example*
    ...    | Set Text Attribute | URL Attribute 1 | http://www.idbs.com |
    ...    | Set Text Attribute | URL Attribute 2 | www.idbs.com |
    ...    | Click OK |
    ...    | Check Generic URL Value | URL Attribute 1 | http://www.idbs.com | http://www.idbs.com |
    ...    | Check Generic URL Value | URL Attribute 2 | www.idbs.com | http://www.idbs.com |
    Wait Until Page Contains Element    xpath=//div[contains(@class, 'ewb-property-name') and (text()="${attribute name}")]/../../td[3]/div/a
    Element Text Should Be    xpath=//div[contains(@class, 'ewb-property-name') and (text()="${attribute name}")]/../../td[3]/div/a    ${display value}
    ${temp href value}=    IDBSSelenium2Library.Get Element Attribute    xpath=//div[contains(@class, 'ewb-property-name') and (text()="${attribute name}")]/../../td[3]/div/a@href
    Should Be Equal    ${temp href value}    ${link value}

Check And Click Generic URL Value
    [Arguments]    ${attribute name}    ${display value}    ${link value}    ${page title}
    [Documentation]    Checks and clicks on the displayed value and link value of a generic URL attribute. Note that this keyword will leave the browser on the page that was linked to so "Go Back" keyword should be used to return to the application under test.
    ...
    ...    *Arguments*
    ...    attribute name = the attribute name as it is displayed within the properties panel
    ...    display value = the expected display value as displayed within the properties panel
    ...    link value = the expected link value as used if the link was clicked
    ...    page title = the expected page title if the link is clicked
    ...
    ...    *Precondition*
    ...    The attribute being checked must be visible within the properties panel
    ...
    ...    *Example*
    ...    | Set Text Attribute | URL Attribute 1 | http://www.idbs.com |
    ...    | Set Text Attribute | URL Attribute 2 | www.idbs.com |
    ...    | Click OK |
    ...    | Check And Click Generic URL Value | URL Attribute 1 | http://www.idbs.com | http://www.idbs.com | IDBS - Enabling Science |
    ...    | Go Back |
    ...    | Check And Click Generic URL Value | URL Attribute 2 | www.idbs.com | http://www.idbs.com | IDBS - Enabling Science |
    ...    | Go Back |
    Check Generic URL Value    ${attribute name}    ${display value}    ${link value}
    Robust Click    xpath=//div[contains(@class, 'ewb-property-name') and (text()="${attribute name}")]/../../td[3]/div/a
    Wait Five Seconds
    IDBSSelenium2Library.Select Window    ${page title}
    IDBSSelenium2Library.Location Should Be    ${link value}
    IDBSSelenium2Library.Title Should Be    ${page title}
    IDBSSelenium2Library.Close Window
    IDBSSelenium2Library.Select Window

Check Generic Entity Link Attribute Value
    [Arguments]    ${attribute name}    ${entity path}
    [Documentation]    Checks the value of a entity link/versioned entity link attribute *in the properties panel* given by the ${attribute name} with the path specified by the ${entity link path} argument
    ...    The properties panel will need to be open prior to this check
    ...
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears in the web client
    ...    - entity link path = the path as expected to be displayed for the entity link
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Check Generic Entity Link Attribute Value | entityLink | /Root/Testing/Steve/My Experiment |
    Run Keyword Unless    '${entity path}'=='${EMPTY}'    Wait Until Page Contains Element    xpath=//div[text()='${attribute name}']/../../descendant::div[contains(@class, 'ewb-anchor')]/a[text()="${entity path}"]
    Run Keyword If    '${entity path}'=='${EMPTY}'    Page Should Not Contain Element    xpath=//div[text()='${attribute name}']/../../descendant::div[contains(@class, 'ewb-anchor')]/a

Check And Click Generic Entity Link Attribute Value
    [Arguments]    ${attribute name}    ${entity path}    ${target display name}    ${override lock}=yes
    [Documentation]    Checks and clicks on the value of a entity link/versioned entity link attribute *in the properties panel* given by the ${attribute name} with the path specified by the ${entity link path} argument
    ...
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears in the web client
    ...    - entity link path = the path as expected to be displayed for the entity link
    ...    - target display name = the expected display name of the entity being clicked on (and navigated to)
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Check And Click Generic Entity Link Attribute Value | entityLink | /Root/Testing/Steve/My Experiment | My Experiment |
    Check Generic Entity Link Attribute Value    ${attribute name}    ${entity path}
    ${temp href value}=    IDBSSelenium2Library.Get Element Attribute    xpath=//div[text()='${attribute name}']/../../descendant::div[contains(@class, 'ewb-anchor')]/a[text()="${entity path}"]@href
    Robust Click    xpath=//div[text()='${attribute name}']/../../descendant::div[contains(@class, 'ewb-anchor')]/a[text()="${entity path}"]
    Wait Five Seconds
    ${check status}    ${value} =    Run Keyword And Ignore Error    Page Should Contain    You already have a lock on this entity.
    Run Keyword If    '${check status}'=='PASS'    Override Lock    ${override lock}
    ${current URL}=    Get Location
    Check String Equals    ${current URL} should be ${temp href value}    ${current URL}    ${temp href value}
    Title Should Be    IDBS E-WorkBook - ${target display name}

Check Generic Entity Link List Attribute Value
    [Arguments]    ${attribute name}    ${entity path}    ${link position}
    [Documentation]    Checks the value of a entity link list/versioned entity link list attribute *in the properties panel* given by the ${attribute name} with the path specified by the ${entity link path} argument
    ...
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears in the web client
    ...    - entity link path = the path as expected to be displayed for the entity link
    ...    - link position = the position of the link in the list, e.g. first link = 1, second link = 2 etc
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Check Generic Entity Link List Attribute Value | entityLink | /Root/Testing/Steve/My Experiment | 1 |
    Wait Until Page Contains Element    xpath=//div[text()='${attribute name}']/../../descendant::div[contains(@class, 'ewb-anchor')][${link position}]/a[text()="${entity path}"]

Check And Click Generic Entity Link List Attribute Value
    [Arguments]    ${attribute name}    ${entity path}    ${link position}    ${target display name}    ${override lock}=yes
    [Documentation]    Checks and clicks on the value of a entity link list/versioned entity link list attribute *in the properties panel* given by the ${attribute name} with the path specified by the ${entity link path} argument
    ...
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears in the web client
    ...    - entity link path = the path as expected to be displayed for the entity link
    ...    - link position = the position of the link in the list, e.g. first link = 1, second link = 2 etc
    ...    - target display name = the expected display name of the entity being clicked on (and navigated to)
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Check And Click Generic Entity Link List Attribute Value | entityLink | /Root/Testing/Steve/My Experiment | 1 | My Experiment |
    Check Generic Entity Link Attribute Value    ${attribute name}    ${entity path}
    ${temp href value}=    IDBSSelenium2Library.Get Element Attribute    xpath=//div[text()='${attribute name}']/../../descendant::div[contains(@class, 'ewb-anchor')][${link position}]/a[text()="${entity path}"]@href
    Click Link    xpath=//div[text()='${attribute name}']/../../descendant::div[contains(@class, 'ewb-anchor')][${link position}]/a[text()="${entity path}"]
    Wait Five Seconds
    ${check status}    ${value} =    Run Keyword And Ignore Error    Page Should Contain    You already have a lock on this entity.
    Run Keyword If    '${check status}'=='PASS'    Override Lock    ${override lock}
    ${current URL}=    Get Location
    Check String Equals    ${current URL} should be ${temp href value}    ${current URL}    ${temp href value}
    Title Should Be    IDBS E-WorkBook - ${target display name}

Check Entity Link List Attribute Value Not Present
    [Arguments]    ${attribute name}    ${entity path}
    [Documentation]    Checks the value is not present for entity link list/versioned entity link list attribute *in the properties panel* given by the ${attribute name} with the path specified by the ${entity link path} argument
    ...
    ...
    ...    *Arguments*
    ...    - attribute name = the name of the attribute as it appears in the web client
    ...    - entity link path = the path being checked for
    ...
    ...    *Return value*
    ...    - None
    ...
    ...    *Precondition*
    ...    - None
    ...
    ...    *Example*
    ...    | Check Entity Link List Attribute Value Not Present | entityLink | /Root/Testing/Steve/My Experiment |
    Page Should Not Contain Element    xpath=//div[text()='${attribute name}']/../../descendant::div[contains(@class, 'ewb-anchor')]/a[text()="${entity path}"]

Ensure All properties Sections Expanded - Default Record Type
    Expand Mandatory Section
    Expand Optional Section
    Expand Read Only Section
    Expand Version Information Section

Ensure All properties Sections Expanded - Root
    Expand Read Only Section
    Expand Version Information Section

Ensure All properties Sections Expanded - Group
    Expand Mandatory Section
    Expand Version Information Section

Ensure All properties Sections Expanded - Project
    Expand Mandatory Section
    Expand Version Information Section

Open Record Properties
    [Arguments]    ${skip_check}=${False}
    [Documentation]    Opens the properties dialog for the record
    Robust Click    ewb-record-action-bar-properties    image
    Run Keyword Unless    ${skip_check}    Wait Until Element Is Visible    xpath=//*[@class="ewb-properties-panel"]    2s

Open Document Properties
    [Arguments]    ${document index}
    [Documentation]    Opens the properties dialog for the specified document
    ${id}=    Evaluate    "document-header-${document index}-propertiesButton"
    Robust Click    ${id}
    Wait Until Page Contains Element    xpath=//div[@class="ewb-properties-panel"]

Open Record Tile Properties
    [Arguments]    ${entity_name}    ${skip_check}=${False}
    [Documentation]    Opens the properties dialog for the specified document
    Robust Click    xpath=//table[contains(@class, 'ewb-entity-item-panel') and (@title="${entity_name}")]//img[contains(@id,"propertiesButton")]
    Run Keyword Unless    ${skip_check}    Wait Until Element Is Visible    xpath=//*[@class="ewb-properties-panel"]

Open Tiles Header Properties
    [Arguments]    ${skip_check}=${False}
    [Documentation]    Opens the properties dialog for the record
    Robust Click    xpath=//img[contains(@class, 'ewb-entity-properties-button')]
    Run Keyword Unless    ${skip_check}    Wait Until Element Is Visible    xpath=//*[@class="ewb-properties-panel"]

Open Navigator Properties
    [Arguments]    ${display_name}    ${skip_check}=${False}
    [Documentation]    Opens the properties dialog for a record from the navigator tree
    Open Navigator Tool Menu    ${display_name}
    Robust Click    ewb-show-properties-command
    Run Keyword Unless    ${skip_check}    Wait Until Element Is Visible    xpath=//*[@class="ewb-properties-panel"]

Check Publishing State Value
    [Arguments]    ${value}
    [Documentation]    Checks that the properties panel displayed Templates value is the same as ${value}
    Element Text Should Be    ${publishing state value}    ${value}

Click away from Property Panel
    [Documentation]    This keyword clicks the user image (non functional) in order to clear away the property panel which may be causing an obstruction when finding other elements
    Wait For No Mask
    Wait Until Keyword Succeeds    10s    1s    Internal Click Away From Property Panel

Internal Click Away From Property Panel
    Robust Click    xpath=//img[contains(@class,"user-avatar")]    # Clicks avatar picture to rid property panel
    Wait Until Element Is Not Visible    xpath=//div[contains(@class, "ewb-properties-panel")]

Check Version Number Value In Properties
    [Arguments]    ${value}
    [Documentation]    Checks that the properties panel displayed Version Number value is the same as ${value}
    ...
    ...    Has a wait until success set at every 1s for 30s
    Wait Until Page Contains Element    ${version number value}[text()="${value}"]    30s

Check property panel EDIT button present
    [Documentation]    This keyword checks for the presence of the EDIT button
    ...
    ...    - Requires the property panel be open
    ...
    ...    The EDIT button may not be present if the users permissions are restricted
    Element Should Be Visible    ${edit prop button}

Check property panel EDIT button not present
    [Documentation]    This keyword checks for the absence of the EDIT button
    ...
    ...    - Requires the property panel be open
    ...
    ...    The EDIT button may not be present if the users permissions are restricted
    Element Should Not Be Visible    ${edit prop button}

_Collapse Section
    [Arguments]    ${section}
    [Documentation]    Ensures that the given section is collapsed
    ${result}=    IDBSSelenium2Library.Get Element Attribute    xpath=//div[@id='${section}']@class
    Run Keyword If    '${result}'=='ewb-property-header expanded'    Robust Click    xpath=//div[@id='${section}']/table
    Page Should Contain Element    xpath=//*[@id='${section}' and @class='ewb-property-header']

_Expand Section
    [Arguments]    ${section}
    [Documentation]    Ensures that the given section is expanded
    ${result}=    IDBSSelenium2Library.Get Element Attribute    xpath=//div[@id='${section}']@class
    Run Keyword If    '${result}'=='ewb-property-header'    Robust Click    xpath=//div[@id='${section}']/table
    Page Should Contain Element    xpath=//*[@id='${section}' and @class='ewb-property-header expanded']

Check Mandatory section present
    [Documentation]    This keyword checks for the presence of the mandatory section
    ...
    ...    - Requires the property panel be open
    ...
    ...    The mandatory section may not be present if the users permissions are restricted
    Wait Until Element Is Visible    ${mandatory header}

Check Optional section present
    [Documentation]    This keyword checks for the presence of the optional section
    ...
    ...    - Requires the property panel be open
    ...
    ...    The optional section may not be present if the users permissions are restricted
    Wait Until Element Is Visible    ${optional header}

Check Read Only section present
    [Documentation]    This keyword checks for the presence of the read only section
    ...
    ...    - Requires the property panel be open
    ...
    ...    The read only section may not be present if the users permissions are restricted
    Wait Until Element Is Visible    ${read only header}

Check Version Information section present
    [Documentation]    This keyword checks for the presence of the version information section
    ...
    ...    - Requires the property panel be open
    Wait Until Element Is Visible    ${version infomation header}

Check Mandatory section not present
    [Documentation]    This keyword checks for the absence of the mandatory section
    ...
    ...    - Requires the property panel be open
    ...
    ...    The mandatory section may not be present if the users permissions are restricted
    Wait Until Element Is Not Visible    ${mandatory header}

Check Optional section not present
    [Documentation]    This keyword checks for the absence of the optional section
    ...
    ...    - Requires the property panel be open
    ...
    ...    The optional section may not be present if the users permissions are restricted
    Wait Until Element Is Not Visible    ${optional header}

Check Version Information section not present
    [Documentation]    This keyword checks for the absence of the version information section
    ...
    ...    - Requires the property panel be open
    Wait Until Element Is Not Visible    ${version infomation header}
