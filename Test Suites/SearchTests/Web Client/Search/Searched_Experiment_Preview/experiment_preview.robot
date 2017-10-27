*** Settings ***
Documentation     Display Experiment preview next to results
...
...               - Navigate to Search page, perform a text search
...               - Verify the results returned in 'hit-list'
...               - Verify the preview displayed for the first result in 'hit-list'
...               - Click on a different result and verify the preview displayed for it
Suite Setup       setup
Suite Teardown    teardown
Test Setup        Navigate Search Screen
Test Teardown     Go To EWB Home
Default Tags
Resource          ../../../../Resources/UI/Search_Page/search_ui.txt
Resource          ../../../../Resources/UI/Search_Page/search_result_ui.txt
Library           IDBSHttpLibrary
Library           EntityAPILibrary
Resource          ../../../../Resources/UI/navigator.txt
Resource          ../../../../Resources/API/Search/search_api.txt
Library           DateTime
Library           String

*** Test Cases ***
Display Experiment Preview Next To Result
    [Documentation]    Display Experiment Preview Next To Result
    ...    - open search screen
    ...    - execute search
    ...    - verify search number is 1 and preview search title
    ...    - execute different text search
    ...    - verify result list
    ...
    ...    Story number SH-256
    [Tags]    BROWSER_REGRESSION    BUILD_ACCEPTANCE    SRCH-FTXT
    Perform Advanced Search    ChemAxon SH-256    Group|Name|is|${groupName}
    Click Search Button
    Verify Number Of Search Result    1
    Verify Previewed Searched Item Title    ChemAxon SH-256    /Root/${groupName}/Different entities/ChemAxon SH-256
    Clear Search
    Execute Text Search    Challenging horizons
    Verify Number Of Search Result    2
    Verify Previewed Searched Item Title    Reactions    /Root/${groupName}/Different entities/Reactions
    Select Search Result By Index    1
    Verify Previewed Searched Item Title    Challenging horizons    /Root/${groupName}/Different entities/Challenging horizons

Display Total Count Of Record Matches
    [Documentation]    Display Total Count Of Record Matches
    ...    - navigate search screen
    ...    - perform search
    ...    - verify number of results
    ...    - verify search with *
    ...
    ...    Story number SH-252
    [Tags]    BROWSER_REGRESSION    BUILD_ACCEPTANCE    SRCH-FTXT
    Perform Advanced Search    "Regression test experiment"    Group|Name|is|${groupName}
    Click Search Button
    Verify Number Of Search Result    3
    Clear Search
    Execute Text Search    "Regression test experiment_2*"
    Verify Number Of Search Result    2
    Clear Search
    Execute Text Search    "Regression test experiment_*"
    Verify Number Of Search Result    3

Sorting Search Result And Hits
    [Documentation]    Sorting Search Result And Hits
    ...    - Navigate search screen
    ...    - Perform search
    ...    - Verify sorting by all available items
    ...
    ...    Story number SH-417
    [Tags]    BROWSER_REGRESSION    SRCH-FTXT
    @{experiments}    Create List    I_Regression test experiment_2_1    H_Regression test experiment_2    A_Regression test experiment_1
    Perform Advanced Search    "Regression test experiment"    Group|Name|is|${groupName}
    Click Search Button
    Sort Result By    Title: Z to A
    Verify Search Result List Exact By Title    ${experiments[0]}    ${experiments[1]}    ${experiments[2]}
    Sort Result By    Title: A to Z
    Verify Search Result List Exact By Title    ${experiments[2]}    ${experiments[1]}    ${experiments[0]}
    Sort Result By    Created date: oldest first
    Verify Search Result List Exact By Title    ${experiments[2]}    ${experiments[1]}    ${experiments[0]}
    Sort Result By    Created date: newest first
    Verify Search Result List Exact By Title    ${experiments[0]}    ${experiments[1]}    ${experiments[2]}
    Sort Result By    Last edited date: oldest first
    Verify Search Result List Exact By Title    ${experiments[2]}    ${experiments[1]}    ${experiments[0]}
    Sort Result By    Last edited date: newest first
    Verify Search Result List Exact By Title    ${experiments[0]}    ${experiments[1]}    ${experiments[2]}

Verify Filtering Of Search Results By Record type
    [Documentation]    Verify Filtering Of Search Result By Record type
    ...    - navigate search screen
    ...    - search \ by text
    ...    - verify filtering by Record type: Experiment and Report
    ...
    ...    Story number SH-427
    [Tags]    BROWSER_REGRESSION    BUILD_ACCEPTANCE    SRCH-FLTR
    Perform Advanced Search    "Regression test experiment"    Group|Name|is|${groupName}
    Click Search Button
    Filter Search Result By    Record type    Experiment
    Verify Search Result List Exact By Title    A_Regression test experiment_1
    Clear Filter
    Filter Search Result By    Record type    Report
    Verify Search Result List Exact By Title    I_Regression test experiment_2_1    H_Regression test experiment_2

Verify Filtering Of Search Results By Version
    [Documentation]    Verify Filtering Of Search Result By Record type
    ...    - navigate search screen
    ...    - search \ by text
    ...    - verify filtering by Version: Version and Draft
    ...
    ...    Story number SH-427
    [Tags]    BUILD_ACCEPTANCE    SRCH-FLTR    BROWSER_REGRESSION
    Perform Advanced Search    "Regression test experiment"    Group|Name|is|${groupName}
    Click Search Button
    Filter Search Result By    Version    Version
    Verify Search Result List Exact By Title    I_Regression test experiment_2_1    A_Regression test experiment_1
    Clear Filter
    Filter Search Result By    Version    Draft
    Verify Search Result List Exact By Title    H_Regression test experiment_2

Verify Filtering Combination Of Record Type And Version
    [Documentation]    Verify Filtering Of Search Result By Record type
    ...    - navigate search screen
    ...    - search \ by text
    ...    - verify filtering by Record type: Experiment and Report
    ...    - verify filtering by Version: Version and Draft
    ...    - and its combination
    ...
    ...    Story number SH-427
    [Tags]    BUILD_ACCEPTANCE    SRCH-FLTR    BROWSER_REGRESSION
    Perform Advanced Search    "Regression test experiment"    Group|Name|is|${groupName}
    Click Search Button
    Filter Search Result By    Record type    Experiment|Report
    Verify Search Result List Exact By Title    I_Regression test experiment_2_1    H_Regression test experiment_2    A_Regression test experiment_1
    Filter Search Result By    Version    Version|Draft
    Verify Search Result List Exact By Title    I_Regression test experiment_2_1    H_Regression test experiment_2    A_Regression test experiment_1

*** Keywords ***
setup
    [Documentation]    setup for current suite
    ${currentDate}=    Get Current Date
    ${groupName}=    Set Variable    Group ${currentDate}
    ${groupName}=    Replace String    ${groupName}    ${SPACE}    ${EMPTY}
    ${groupId}=    EntityAPILibrary.Create Group    1    ${groupName}
    Set suite Variable    ${groupName}
    Set suite Variable    ${groupId}
    ${projectId}=    EntityAPILibrary.Create Project    ${groupId}    Different entities
    ${experimentId}=    EntityAPILibrary.Create Experiment    ${projectId}    Challenging horizons    Started
    EntityAPILibrary.Create Text Document    ${experimentId}    Text document    Multiple entries    Text document with multiple entries
    EntityAPILibrary.Version Save    ${experimentId}    Data Added
    ${templateId}=    EntityAPILibrary.Create Template    ${projectId}    Reactions    Started    keywords:::challenging horizons
    Comment    ${chemId}=    EntityAPILibrary.Create Chemistry item    ${templateId}
    ${chemistryData}=    Get File    ${CURDIR}/Test_Data/Chloronaphthalene reaction (SH-520).txt
    Comment    EntityAPILibrary.Edit Chemistry Item    ${chemId}    ${templateId}    ${chemistryData}
    EntityAPILibrary.Create Web Link Document    ${templateId}    www.google.com
    EntityAPILibrary.Version Save    ${templateId}    Data Added
    ${reportId}=    EntityAPILibrary.Create Report    ${projectId}    ChemAxon SH-256
    Comment    ${chemId}=    EntityAPILibrary.Create Chemistry item    ${reportId}
    ${chemistryData}=    Get File    ${CURDIR}/Test_Data/Methylnaphthalene (SH-520).txt
    Comment    EntityAPILibrary.Edit Chemistry Item    ${chemId}    ${reportId}    ${chemistryData}
    EntityAPILibrary.Create Web Link Document    ${reportId}    www.google.com
    EntityAPILibrary.Version Save    ${reportId}    Data Added
    ${experimentId}=    EntityAPILibrary.Create Experiment    ${projectId}    A_Regression test experiment_1    Started
    EntityAPILibrary.Version Save    ${experimentId}    Data Added
    ${reportId}=    EntityAPILibrary.Create Report    ${projectId}    H_Regression test experiment_2    Started
    EntityAPILibrary.Draft Save    ${reportId}
    EntityAPILibrary.Create Report    ${projectId}    I_Regression test experiment_2_1    Started
    Delete All Searches Via API
    Login To EWB

teardown
    [Documentation]    teardown for current suite
    EntityAPILibrary.Unlock Entity And Children    ${groupId}
    EntityAPILibrary.Delete Entity    ${groupId}    As intended    As intended
    close browser
