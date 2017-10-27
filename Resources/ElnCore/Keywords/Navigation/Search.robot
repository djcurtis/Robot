*** Settings ***
Resource    ../Navigation/Resource Objects/Search.robot
Library     IDBSSelenium2Library
Library     EntityAPILibrary
Library     DateTime

*** Variables ***
${TIMESTAMP}
${SEARCH_BUTTON} =     xpath=//*[@id="go"]
${SEARCH_FIELD} =    xpath=//*[@id="searchBox"]//input[2]
${SEARCH_FRAME} =    xpath=//*[@id="search-page-container-frame"]
${RESULT_LIST} =    xpath=//div[@id='resultList']

*** Keywords ***

Select Search
    Search.Select Search Button

Search for Term
    [Arguments]    ${SEARCH_TERM}
    Select Search Frame
    Enter Search Term    ${SEARCH_TERM}
    Select Search
    Check Search Term Result Successful    ${SEARCH_TERM}
    unselect frame

