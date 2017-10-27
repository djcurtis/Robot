*** Settings ***
Documentation     A resource file containing IDBS defined keywords used for testing the IDBS E-WorkBook Web Client application. This resource file contains system keywords that are called by other keywords and should not be called directly within a test script.
...               This file is loaded by the common_resource.txt file which is automatically loaded when running tests through the Robot Framework.
...               *Version: E-WorkBook Web Client 9.2.0*
Library           IDBSSelenium2Library
#Library           OracleLibrary
Resource          general_resource.robot

*** Variables ***
${current time}    ${EMPTY}
${current full year}    ${EMPTY}
${current short year}    ${EMPTY}
${current month}    ${EMPTY}
${current day}    ${EMPTY}
${current hour}    ${EMPTY}
${current minute}    ${EMPTY}
${current second}    ${EMPTY}
${unique id value}    xpath=//div[text()="Unique Id"]/../../td[3]/div

*** Keywords ***
XML Should Contain
    [Arguments]    ${text}
    Call Selenium Api    isTextPresentXML    ${text}

XML Should Not Contain
    [Arguments]    ${text}
    ${status}    ${value} =    Run Keyword And Ignore Error    Call Selenium Api    isTextPresentXML    ${text}
    Run Keyword If    '${value}' == 'OK,false'    Log    XML text "${text}" not present, as expected
    Run Keyword Unless    '${value}' == 'OK,false'    Fail    XML should not have contained text "${text}" but it did.

Set Current Timestamp Variables
    [Documentation]    Gets timestamp variables and logs them with the following formatting:
    ...    ${current time} = yyyy-mm-dd hh:mm:ss
    ...    ${current full year} = yyyy
    ...    ${current month} = mm
    ...    ${current day} = dd
    ...    ${current hour} = hh
    ...    ${current minute} = mm
    ...    ${current second} = ss
    ${current time} =    Get Time
    ${current full year} =    Get Time    year
    ${current month} =    Get Time    month
    ${current day} =    Get Time    day
    ${current hour} =    Get Time    hour
    ${current minute} =    Get Time    min
    ${current second} =    Get Time    sec

Convert Current Year
    [Documentation]    Converts the ${current year} from a "yyyy" format to a "yy" format and stores it in the ${current short year} variable.
    ${current short year} Set Variable If    ${current year} == 2011    11
    ${current short year} Set Variable If    ${current year} == 2012    12
    ${current short year} Set Variable If    ${current year} == 2013    13
    ${current short year} Set Variable If    ${current year} == 2014    14
    ${current short year} Set Variable If    ${current year} == 2015    15
    ${current short year} Set Variable If    ${current year} == 2016    16
    ${current short year} Set Variable If    ${current year} == 2017    17
    ${current short year} Set Variable If    ${current year} == 2018    18
    ${current short year} Set Variable If    ${current year} == 2019    19
    ${current short year} Set Variable If    ${current year} == 2020    20

Non Webkit Browser Submit
    [Documentation]    Simulates login for non-webkit based browsers Supported Browsers: Internet Explorer and Firefox
    # Press Key login-submit 10
    Robust Click    login-submit

Webkit Browser Submit
    [Documentation]    Simulates login for webkit based browsers Supported Browsers: Safari and Google Chrome
    # Focus login-submit
    # Press Key Native 10 #10=enter
    Robust Click    login-submit

Set Document ID Variables
    [Arguments]    ${document number}
    [Documentation]    Sets all the ID's used for document generation to the correct number for document verification
    Set Suite Variable    ${document icon id}    document-header-${document number}-entityImage
    Set Suite Variable    ${document type id}    document-header-${document number}-itemTypeLabel
    Set Suite Variable    ${document title id}    document-header-${document number}-editableTitleTable
    Set Suite Variable    ${document menu button id}    document-header-${document number}-menuButton
    Set Suite Variable    ${document expand button id}    document-header-${document number}-expanderButton
    Set Suite Variable    ${document top properties id}    document-properties-top-${document number}-panel
    Set Suite Variable    ${document body id}    document-body-${document number}-panel
    Set Suite Variable    ${document bottom properties id}    document-properties-bottom-${document number}-panel
    Set Suite Variable    ${document signatures id}    document-signatures-${document number}-panel

Document Check
    [Arguments]     ${index}
    ${status}    ${value} =    Run Keyword And Ignore Error    Page Should Contain Element    document-header-${index}-itemTypeLabel
    ${last document found} =    Set Variable If    '${status}'=='FAIL'    t    f
    Set Suite Variable    ${last document found}
    Run Keyword If    '${last document found}'=='t'    Set Suite Variable    ${next document number}    ${index}
    Run Keyword If    '${last document found}'=='t'    Set Document ID Variables    ${next document number}

Get Entity Unique Id
    Wait Until Page Contains Element    ${unique id value}
    ${entity unique id} =    Get Text    ${unique id value}
    Set Suite Variable    ${entity unique id}

Check Record Lock State
    [Arguments]    ${entity unique id}=none
    [Documentation]    Preconditions - must provide unique ID or be viewing the entity in the web client for this value to be automatically picked up
    Run Keyword If    '${entity unique id}'=='none'    Wait Until Keyword Succeeds    30s    0.1s    Get Entity Unique Id
    Connect To Database    ${CORE_USERNAME}    ${CORE_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    ${queryResults}    Query    select ENTITY_ID from entities where UNIQUE_VIS_ID=${entity unique id}
    ${entity id value}    Set Variable    ${queryResults[0][0]}
    Set Suite Variable    ${entity id value}
    Disconnect From Database
    Connect To Database    ${CORE_USERNAME}    ${CORE_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    ${check status}    ${value} =    Run Keyword And Ignore Error    Check If Exists In Database    select USER_ID from ENTITY_LOCKS where ENTITY_ID='${entity id value}'
    Run Keyword If    '${check status}'=='PASS'    Set Suite Variable    ${entity lock status}    T
    Run Keyword Unless    '${check status}'=='PASS'    Set Suite Variable    ${entity lock status}    F
    Disconnect From Database
    [Return]    ${entity lock status}

Check Record Lock State With Entity Id
    [Arguments]    ${entity id}
    [Documentation]    Preconditions - must provide entity ID
    Connect To Database    ${CORE_USERNAME}    ${CORE_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    ${check status}    ${value} =    Run Keyword And Ignore Error    Check If Exists In Database    select USER_ID from ENTITY_LOCKS where ENTITY_ID='${entity id}'
    Run Keyword If    '${check status}'=='PASS'    Set Suite Variable    ${entity lock status}    T
    Run Keyword Unless    '${check status}'=='PASS'    Set Suite Variable    ${entity lock status}    F
    Disconnect From Database
    [Return]    ${entity lock status}

Confirm Record Locked
    [Arguments]    ${entity id}
    [Documentation]    Preconditions - must provide entity ID
    ${Locked State} =    Check Record Lock State With Entity Id    ${entity id}
    Check String Equals    Locked State    ${Locked State}    T

Confirm Record Not Locked
    [Arguments]    ${entity id}
    [Documentation]    Preconditions - must provide entity ID
    ${Locked State} =    Check Record Lock State With Entity Id    ${entity id}
    Check String Equals    Locked State    ${Locked State}    F

Get Next Document ID Set
    [Documentation]    Sets variables for the ID's of the next document to be generated. To be used when adding new documents.
    ...
    ...    Note: Hardcoded to support up to 100 documents in a record
    ${index} =    Set Variable    1
    Set Suite Variable    ${last document found}    f
    : FOR    ${index}    IN RANGE    1    100
    \    Run Keyword If    '${last document found}'=='f'    Document Check    ${index}
    \    ${index} =    Evaluate    ${index}+1

Expand Navigator Node
    [Arguments]    ${Navigator Node Text}
    [Documentation]    Expands a navigator node *in an entity selection dialog only* (e.g. Find Template or Entity Link selection) dialogs
    ...
    ...    *Arguments*
    ...
    ...    - _navigator node text_ - The node text of the node as it appears in the client
    ...
    ...    *Return Value*
    ...
    ...    None
    Wait Until Page Contains Element    xpath=//div[contains(@class, 'ewb-entity-selection-view')]/descendant::div[@class='gwt-Tree']/div[2]/div/div
    ${root_state}=    Run Keyword and Ignore Error    Element Should Be Visible    xpath=//div[contains(@class, 'ewb-entity-selection-view')]/descendant::div[@class='gwt-Tree']/div[2]/div
    Run Keyword If    ${root_state}!=('PASS', None)    Robust Click    xpath=//div[contains(@class, 'ewb-entity-selection-view')]/descendant::div[@class='gwt-Tree']/div[2]/table/tbody/tr/td/img
    Wait Until Page Contains Element    xpath=//div[contains(@class, 'ewb-entity-selection-view')]/descendant::div[@title="${Navigator Node Text}"]/div
    ${display_state}=    IDBSSelenium2Library.Get Element Attribute    xpath=//div[contains(@class, 'ewb-entity-selection-view')]/descendant::div[@title="${Navigator Node Text}"]/div@style
    ${status}    ${value}=    Run Keyword And Ignore Error    Should Contain    ${display_state}    display: none
    Run Keyword If    '${status}'=='PASS'    Scroll Element Into View    xpath=//div[contains(@class, 'ewb-entity-selection-view')]/descendant::div[@title="${Navigator Node Text}"]/table/tbody/tr/td[1]/img
    Run Keyword If    '${status}'=='PASS'    Robust Click    xpath=//div[contains(@class, 'ewb-entity-selection-view')]/descendant::div[@title="${Navigator Node Text}"]/table/tbody/tr/td[1]/img
    Run Keyword If    '${status}'=='FAIL'    Log    Navigator node already expanded

Click Navigator Node
    [Arguments]    ${Navigator Node Text}
    Robust Click    xpath=//div[contains(@class, 'ewb-entity-selection-view')]/descendant::a[text()="${Navigator Node Text}"]

Properties Version Save
    [Arguments]    ${username}    ${password}    ${save reason}    ${additional comments}=none
    [Documentation]    Should not be called directly - use "Close Dialog and Save" to save a properties dialog
    Dialog Should Be Present    Enter your credentials to save the edit session
    Select User Action Note    ${save reason}
    Run Keyword Unless    '${additional comments}'=='none'    Input Text    xpath=//textarea[contains(@class,'ewb-textbox')]    ${save comment}
    Run Keyword Unless    '${additional comments}'=='none'    Textfield Should Contain    xpath=//textarea[contains(@class,'ewb-textbox')]    ${save comment}
    Authenticate Session    ${username}    ${password}
    Dialog Should Not Be Present    Enter your credentials to save the edit session
