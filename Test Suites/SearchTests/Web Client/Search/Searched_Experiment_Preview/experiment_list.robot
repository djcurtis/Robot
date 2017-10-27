*** Settings ***
Documentation     Suite is for SH-1070 story.
...               Tests that search not reexecuted after clicking previou/next button and changing sort order
Suite Setup       setup
Test Setup        Navigate Search Screen
Test Teardown     Reload Page
Library           CheckLibrary
Library           EntityAPILibrary
Library           IDBSSelenium2Library
Resource          ../../../../Resources/API/Search/search_api.txt
Resource          ../../../../Resources/UI/navigator.txt
Resource          ../../../../Resources/UI/Search_Page/search_ui.txt
Resource          ../../../../Resources/UI/Search_Page/search_result_ui.txt
Library           DateTime

*** Test Cases ***
Verify Changing Sort Order Not Reexecute Filtered Search
    [Documentation]    Verify Changing Sort Order Not Reexecute Filtered Search
    ...    - execute search
    ...    - set filter options
    ...    - verify yellow message and 'Search' button pulsing
    ...    - sort result
    ...    - verify yellow message and 'Search' button pulsing
    [Tags]    BUILD_ACCEPTANCE
    Perform Advanced Search    experiment    Group|Name|is|${groupName}
    Click Search Button
    Set Filter Options    Record type    Report
    Verify Search Button Pulsating
    Verify Yellow Message Bar Exist
    Sort Result By    Title: Z to A
    Verify No Search In Progress Spinner    20s
    Verify Search Button Pulsating
    Verify Yellow Message Bar Exist

Verify Changing Sort Order Not Reexecute Updated Search
    [Documentation]    Verify Changing Sort Order Not Reexecute Update Search
    ...    - execute search
    ...    - update search options
    ...    - verify yellow message and 'Search' button pulsing
    ...    - sort result
    ...    - verify yellow message and 'Search' button pulsing
    [Tags]    BUILD_ACCEPTANCE
    Perform Advanced Search    experiment    Group|Name|is|${groupName}
    Click Search Button
    Click Advanced Search Link
    Perform Advanced Search    *e*    Any Record|Name|is|experiment
    Verify Search Button Pulsating
    Verify Yellow Message Bar Exist
    Sort Result By    Title: Z to A
    Verify No Search In Progress Spinner    20s
    Verify Search Button Pulsating
    Verify Yellow Message Bar Exist

Verify Clicking Next Button Not Reexecute Filtered Search
    [Documentation]    Verify Clicking Next Button Not Reexecute Filtered Search
    ...    - execute search
    ...    - set filter options
    ...    - verify yellow message and 'Search' button pulsing
    ...    - click next
    ...    - verify yellow message and 'Search' button pulsing
    ...    - verify second page search result
    [Tags]    BUILD_ACCEPTANCE
    Perform Advanced Search    experiment    Group|Name|is|${groupName}
    Click Search Button
    Set Filter Options    Record type    Report
    Verify Search Button Pulsating
    Verify Yellow Message Bar Exist
    Click Next
    Verify No Search In Progress Spinner    20s
    Verify Search Button Pulsating
    Verify Yellow Message Bar Exist
    Verify Result Page Number    2

Verify Clicking Next Button Not Reexecute Updated Search
    [Documentation]    Verify Clicking Next Button Not Reexecute Update Search
    ...    - execute search
    ...    - update search options
    ...    - verify yellow message and 'Search' button pulsing
    ...    - click next
    ...    - verify yellow message and 'Search' button pulsing
    ...    - verify second page search result
    [Tags]    BUILD_ACCEPTANCE
    Perform Advanced Search    experiment    Group|Name|is|${groupName}
    Click Search Button
    Click Advanced Search Link
    Perform Advanced Search    *e*    Any Record|Name|is|experiment
    Verify Search Button Pulsating
    Verify Yellow Message Bar Exist
    Click Next
    Verify No Search In Progress Spinner    20s
    Verify Search Button Pulsating
    Verify Yellow Message Bar Exist
    Verify Result Page Number    2

Verify Clicking Next Button Not Reexecute Edit Advanced Search Tile
    [Documentation]    Verify Clicking Next Button Not Reexecute Edit Advanced Search Tile
    ...    - execute advanced search
    ...    - edit advanced search tile
    ...    - verify yellow message and 'Search' button pulsing
    ...    - click Next button
    ...    - verify yellow message and 'Search' button pulsing
    ...    - click Previous Button
    ...    - verify yellow message and 'Search' button pulsing
    [Tags]    BUILD_ACCEPTANCE
    Perform Advanced Search    *e*    Group|Name|is|${groupName}    Any Record|Name|contains|experiment
    Click Search Button
    Edit Advanced Term Text Value And Operator    Name    contains    experiment    contains    exper
    Verify Search Button Pulsating
    Verify Yellow Message Bar Exist
    Click Next
    Verify No Search In Progress Spinner    20s
    Verify Search Button Pulsating
    Verify Yellow Message Bar Exist
    Verify Result Page Number    2
    Click Previous
    Verify No Search In Progress Spinner    20s
    Verify Search Button Pulsating
    Verify Yellow Message Bar Exist
    Verify Result Page Number    1

Verify Changing Sort Order Not Reexecute Edit Advanced Search Tile
    [Documentation]    Verify Changing Sort Order Not Reexecute Edit Advanced Search Tile
    ...    - execute advanced search
    ...    - edit advanced search tile
    ...    - verify yellow message and 'Search' button pulsing
    ...    - sort result
    ...    - verify yellow message and 'Search' button pulsing
    [Tags]    BUILD_ACCEPTANCE
    Perform Advanced Search    *e*    Group|Name|is|${groupName}    Any Record|Name|contains|experiment
    Click Search Button
    Edit Advanced Term Text Value And Operator    Name    contains    experiment    contains    exp
    Verify Yellow Message Bar Exist
    Sort Result By    Title: Z to A
    Verify No Search In Progress Spinner    20s
    Verify Yellow Message Bar Exist
    Verify Result Page Number    1

*** Keywords ***
setup
    [Documentation]    setup creates 35 experiment for one group
    ${currentDate}=    Get Current Date
    ${groupName}=    Set Variable    Group ${currentDate}
    ${groupId}=    EntityAPILibrary.Create Group    1    ${groupName}
    Set suite Variable    ${groupName}
    Set suite Variable    ${groupId}
    ${projectId}=    EntityAPILibrary.Create Project    ${groupId}    project
    : FOR    ${i}    IN RANGE    35
    \    ${experimentId}=    EntityAPILibrary.Create Experiment    ${projectId}    ${i} experiment    Started
    \    EntityAPILibrary.Version Save    ${experimentId}    Data Added
    \    Comment    Delete All Searches Via API
    \    Comment    Login To EWB
    Login To EWB

teardown
    EntityAPILibrary.Unlock Entity And Children    ${groupId}
    EntityAPILibrary.Delete Entity    ${groupId}    As intended    As intended
    close browser
