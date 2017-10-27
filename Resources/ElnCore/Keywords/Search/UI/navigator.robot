*** Settings ***
Library           IDBSSelenium2Library
Resource          ../../../Libraries/Web Client/Selenium/comments_resource.txt
Resource          ../../../Libraries/Web Client/Selenium/general_resource.txt
Resource          ../API/Search/search_api.txt

*** Keywords ***
Open Browser to EWB Login
    Open Browser    ${LOGIN URL}    ${BROWSER}
    Run Keyword And Ignore Error    Maximize Browser Window
    Set Selenium Speed    ${DELAY}
    Wait Until Title Is    IDBS E-WorkBook    300s

User credentials
    [Documentation]    Supply test credentials on opened login screen
    Wait Until Keyword Succeeds    20s    2s    Input username    ${SERVICES USERNAME}
    Wait Until Keyword Succeeds    20s    2s    Input Password    ${SERVICES PASSWORD}
    Wait Until Keyword Succeeds    20s    2s    Submit Credentials

Navigate Search Screen
    [Documentation]    Navigate to Search screen
    Unselect Frame
    Robust click    search-link-label

Logout
    unselect frame
    Wait Until Page Contains Element    xpath=//a[@class='ewb-root-menu-item app-header-user-name']    15s
    Click Link    xpath=//a[@class='ewb-root-menu-item app-header-user-name']
    Robust Click    app-header-link-log-off
    Robust Click    css=.ewb-anchor
    Wait Until Page Contains Element    login-submit

Supply Non Default User Credentials
    [Arguments]    ${user}    ${password}
    [Documentation]    Supply different that test credentials on opened login screen
    Wait Until Keyword Succeeds    20s    2s    Input username    ${user}
    Wait Until Keyword Succeeds    20s    2s    Input Password    ${password}
    Wait Until Keyword Succeeds    20s    2s    Submit Credentials

Navigate Navigator Screen
    [Documentation]    Navigate to Navigator screen
    unselect frame
    Robust click    navigator-link-label
    reload page

Login To EWB
    [Documentation]    - open browser
    ...    - login to EWB with Administrator credentials
    Open Browser to EWB Login
    User credentials

Go To EWB Home
    [Documentation]    Navigate to the EWB Home URL
    Go To    ${LOGIN URL}
