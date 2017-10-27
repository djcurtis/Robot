*** Settings ***
Library    IDBSSelenium2Library
Library    EntityAPILibrary
Library    ManualActionLibrary
Library    Process

*** Keywords ***

Execute AutoHotKey
    [Arguments]    ${autohotkey_path}    ${autohotkey_script}
    Run Process      ${autohotkey_path}    ${autohotkey_script}