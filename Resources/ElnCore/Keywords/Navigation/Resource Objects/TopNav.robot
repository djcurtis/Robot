*** Settings ***
Library    IDBSSelenium2Library
Resource          ../../Selenium/general_resource.robot

*** Variables ***
${USER_ACCOUNT_LINK} =    xpath=//*[@id='app-header-link-account']
${SIGNOUT_LINK} =   xpath=//span[@id='app-header-link-log-off']

*** Keywords ***

Go To Account Menu
    [Documentation]    Clicks the User Account Link
    Robust Click    ${USER_ACCOUNT_LINK}

Select Signout
    [Documentation]    Select the Signout link
    Robust Click    ${SIGNOUT_LINK}