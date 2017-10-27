*** Settings ***
Documentation     Keywords for managing/verifying list of search results
Library           IDBSSelenium2Library
Resource          ../../../../Libraries/Web Client/Selenium/general_resource.txt
Library           String
Resource          locators/search_ui.txt
Resource          locators/search_result_ui.txt

*** Keywords ***
Verify Previewed Searched Item Title
    [Arguments]    ${name}    ${path}
    [Documentation]    Verify that title and tree path for the previeved search result item are equals ${name} and ${path} accordingly
    ${xpath_name}    set variable    xpath=//div[@class='main-display']//span[text()='${name}'and @class='name']
    Wait Until Element Is Not Visible    ${searchingSpinner}    30s
    Wait Until Page Contains Element    ${xpath_name}    15s
    ${actual_name}    Get Text    ${xpath_name}
    ${actual_path}    Get Text    ${previewedResultItemPathLabel}
    Should Be Equal as Strings    ${name}    ${actual_name}
    Should Be Equal as Strings    ${path}    ${actual_path}

Select Search Result By Index
    [Arguments]    ${index}
    [Documentation]    Select searched result to be preview by index ${index} index should start with 0.
    ${index}    evaluate    ${index}+1
    Robust Click    //div[@id='resultList']/div[contains(@class,'miniViewTuple')][${index}]

Sort Result By
    [Arguments]    ${sortBy}
    [Documentation]    Execute searched result sorting by options ${sortBy}
    ...
    ...    ${sortBy} is option text, for example:
    ...
    ...    'Last edited date: oldest first'
    ...    'Created date: newest first'
    unselect frame
    select frame    ${searchFrame}
    Robust Click    ${sortResultDropBox}
    Robust Click    //div[@id="ewb-popup-menu"]//a[text()='${sortBy}']
    Wait Until Element Is Not Visible    ${searchingSpinner}    30s

Verify Search Result List Exact By Title
    [Arguments]    @{titlesList}
    [Documentation]    Verify that titles of search results are :
    ...    - equal @{titlesList}
    ...    - size is equal @{titlesList} size
    ...    - sorting is the same with @{titlesList} sorting
    unselect frame
    select frame    ${searchFrame}
    ${xpath}    set variable    ${searchResultTitleList}
    Wait Until Page Contains Element    ${xpath}    15s
    unselect frame
    select frame    ${searchFrame}
    @{resultListItems}    Get WebElements    ${xpath}
    ${listSize}    Get Length    ${resultListItems}
    ${expectedListSize}    Get Length    ${titlesList}
    Should be Equal As Integers    ${expectedListSize}    ${listSize}
    : FOR    ${i}    IN RANGE    0    ${listSize}
    \    ${expected}    set variable    ${titlesList[${i}]}
    \    ${actual}    Get Text    ${resultListItems[${i}]}
    \    Should Be Equal As Strings    ${expected}    ${actual}

Filter Search Result By
    [Arguments]    ${filterType}    ${filterOptions}    # ${filterOptions} is list of options, separated by "|", for example opt1|opt2|opt3...
    [Documentation]    Filter searched result by filter type ${filterType}. Select list of filter options ${filterOptionls} \ under filter type.
    ${groupXpath}    set variable    //div[@id="allfilters"]//span[text()='${filterType}' and @class='filter-section-header']
    ${groupButtonXpath}    set variable    ${groupXpath}/../i
    Wait Until page contains element    ${groupXpath}
    ${elementClass}    IDBSSelenium2Library.Get Element Attribute    ${groupButtonXpath}@class
    ${lines}    Get Lines Matching Regexp    ${elementClass}    .*closed.*
    ${lines}    set variable    ${lines}
    Run keyword If    '${lines}'!='${EMPTY}'    Robust Click    ${groupXpath}
    log    ${lines}
    @{filterOptions}    Split String    ${filterOptions}    |
    : FOR    ${filterOption}    IN    @{filterOptions}
    \    Robust Click    //*[contains(@class,'subfilter')]//span[text()='${filterOption}']/../i
    Wait Until Keyword Succeeds    2s    10s    Robust Click    ${applyFilterButton}
    Wait Until Element Is Not Visible    ${searchingSpinner}    30s

Clear Filter
    [Documentation]    Clear filter by clicking 'Clear' button.
    Robust Click    ${filterClearButton}
    Wait Until Element Is Not Visible    ${searchingSpinner}    30s

Verify Number Of Search Result
    [Arguments]    ${expectedNumber}
    [Documentation]    Verify number of searched result should be equal ${expectedNumber} by:
    ...    - list of searcheditems
    ...    - total number label
    unselect frame
    select frame    ${searchFrame}
    Wait Until Element Is Not Visible    ${searchingSpinner}    30s
    Sleep    3s
    Wait Until Page Contains Element    ${totalSearchResultLabel}
    Wait Until Page Contains Element    ${searchResultList}
    ${tuple-index}    Evaluate    ${expectedNumber}-1
    Wait Until Page Contains Element    xpath=//div[@tuple-index="${tuple-index}"]
    ${actualNumber}    Get Matching Xpath Count    ${searchResultList}
    ${expectedLabel}    set variable    1 of ${expectedNumber}
    ${actulaLabel}    get text    ${totalSearchResultLabel}
    Should Be Equal As Integers    ${expectedNumber}    ${actualNumber}
    Should Be Equal As Strings    ${expectedLabel}    ${actulaLabel}

Verify Blank Search Result
    [Documentation]    Verify that search returns no result, and 'No Result' message appears
    unselect frame
    select frame    ${searchFrame}
    Wait until Page Contains element    ${blankSearchResultLabel}    30s
    Wait Until Page Does Not Contain Element    ${searchResultList}    30s

Verify Search Result List Contains Elements By Title
    [Arguments]    @{titlesList}
    [Documentation]    Verify Search Result \ List Contains Elements By Title
    ...    - contains elements from list @{titlesList}
    ...    - assuming all result is on one page
    unselect frame
    select frame    ${searchFrame}
    Wait Until Page Contains Element    ${searchResultTitleList}    15s
    unselect frame
    select frame    ${searchFrame}
    ${expecetd_listSize}    Get Length    ${titlesList}
    : FOR    ${i}    IN RANGE    0    ${expecetd_listSize}
    \    Wait Until Page Contains Element    xpath=//div[@class='experimenttitle' and text()='${titlesList[${i}]}']

Verify Search Result List Does Not Contain Elements By Title
    [Arguments]    @{titlesList}
    [Documentation]    Verify Search Result \ List Does Not \ Contain Elements By Title
    ...    - does not contains elements from list @{titlesList}
    ...    - assuming all result is on one page
    unselect frame
    select frame    ${searchFrame}
    Wait Until Page Contains Element    ${searchResultTitleList}    15s
    unselect frame
    select frame    ${searchFrame}
    ${expecetd_listSize}    Get Length    ${titlesList}
    : FOR    ${i}    IN RANGE    0    ${expecetd_listSize}
    \    Wait Until Page Does not contain element    xpath=//div[@class='experimenttitle' and text()='${titlesList[${i}]}']

Verify Blank Chemistry Search Result
    unselect frame
    select frame    ${searchFrame}
    Wait until Page Contains element    ${blankChemistrySearchResultLabel}    30s
    Wait Until Page Does Not Contain Element    ${searchResultList}    30s

Set Filter Options
    [Arguments]    ${filterType}    ${filterOptions}    # ${filterOptions} is list of options, separated by "|", for example opt1|opt2|opt3...
    [Documentation]    Select \ filter type ${filterType}. Select list of filter options ${filterOptions} under filter type.
    ${groupXpath}    set variable    //div[@id="allfilters"]//span[text()='${filterType}' and @class='filter-section-header']
    ${groupButtonXpath}    set variable    ${groupXpath}/../i
    Wait Until page contains element    ${groupXpath}
    ${elementClass}    IDBSSelenium2Library.Get Element Attribute    ${groupButtonXpath}@class
    ${lines}    Get Lines Matching Regexp    ${elementClass}    .*closed.*
    Run keyword If    '${lines}'!='${EMPTY}'    Robust Click    ${groupXpath}
    @{filterOptions}    Split String    ${filterOptions}    |
    : FOR    ${filterOption}    IN    @{filterOptions}
    \    Robust Click    //*[contains(@class,'subfilter')]//span[text()='${filterOption}']/../i

Click Next
    unselect frame
    select frame    ${searchFrame}
    Robust Click    ${nextButton}

Click Previous
    unselect frame
    select frame    ${searchFrame}
    Robust Click    ${previuosButton}

Verify Result Page Number
    [Arguments]    ${pageNumber}
    [Documentation]    Verify Result Page Number
    ...    - check that search result page is ${pageNumber} number.
    ...    - we assume, that number experiment on the page is 25
    ...    - calculation is based on index of selected experiment text label
    unselect frame
    select frame    ${searchFrame}
    Wait Until Element Is Not Visible    ${searchingSpinner}    30s
    Wait Until Page Contains Element    ${totalSearchResultLabel}
    ${Label}    get text    ${totalSearchResultLabel}
    log    ${Label}
    ${strs}    Split String    ${Label}
    ${pageNumberActual}    Evaluate    ${strs[0]}/26+1
    Should Be Equal As Integers    ${pageNumber}    ${pageNumberActual}
