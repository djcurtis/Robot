*** Settings ***
Library    IDBSSelenium2Library
Resource          ../../Selenium/general_resource.robot

*** Variables ***
${SEARCH_BUTTON} =     xpath=//*[@id="go"]
${SEARCH_FIELD} =    xpath=//*[@id="searchBox"]//input[2]
${SEARCH_FRAME} =    search-page-container-frame
${RESULT_LIST} =    xpath=//div[@id='resultList']

*** Keywords ***

Select Search Frame
    unselect frame
    Wait Until Element Is Visible    ${SEARCH_FRAME}    10s
    select frame  ${SEARCH_FRAME}
    sleep    1s

Verify Search Page Loaded
    Select Search Frame

Select Search Button
    Robust Click    ${SEARCH_BUTTON}
    sleep   10s

Enter Search Term
    [Arguments]    ${SEARCH_TERM}
    Wait Until Element Is Visible    ${SEARCH_FIELD}    10s
    Input Text    ${SEARCH_FIELD}    ${SEARCH_TERM}


Check Search Term Result Successful
    [Arguments]    ${SEARCH_TERM}
    wait until page contains element   xpath=//div[@class='experimenttitle'][contains(text(),'${SEARCH_TERM}')]

