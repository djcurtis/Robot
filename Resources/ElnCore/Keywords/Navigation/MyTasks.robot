*** Settings ***
Library    IDBSSelenium2Library
Library    EntityAPILibrary
Library    DateTime
Resource    ../Navigation/Resource Objects/MyTasks.robot

*** Variables ***
${TIMESTAMP}

*** Keywords ***
Review Task from List
    [Arguments]    ${workflow_name}    ${experiment_name}
    set selenium speed    2
    Select Task    ${workflow_name}
    MyTasks.Select Sign Off Button
    MyTasks.Confirm Sign Off View Appears    ${experiment_name}
    set selenium speed    1

Check New Task Not Listed
    [Arguments]    ${experiment_name}
    MyTasks.Verify New Task Not Listed     ${experiment_name}

Check Recently Closed Task Listed
    [Arguments]    ${experiment_name}
    MyTasks.Select Recently Closed Task Filter
    MyTasks.Verify Recently Closed Task Listed     ${experiment_name}