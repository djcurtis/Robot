*** Settings ***
Library    IDBSSelenium2Library
Resource          ../../Selenium/general_resource.robot

*** Variables ***


*** Keywords ***

Verify My Tasks Page Loaded
    wait until page contains element   xpath=//div[@class='ewb-tasks-workflows-filters']

Verify New Task Not Listed
    [Arguments]    ${experiment_name}
    wait until page does not contain element  xpath=//*[starts-with(@id, "ewb-tasks-list-info")][contains(text(),'${experiment_name}')]

Verify Recently Closed Task Listed
    [Arguments]    ${experiment_name}
    wait until page contains element  xpath=//*[starts-with(@id, "ewb-tasks-list-info")][contains(text(),'${experiment_name}')]

Select Recently Closed Task Filter
    Robust Click    xpath=//div[@id='ewb-tasks-standard-filter-recently-completed']//*[@class='ewb-label'][contains(text(),'Recently Closed')]

Select Task
    [Arguments]    ${workflow_name}
    Robust Click    xpath=//*[starts-with(@id,"ewb-tasks-list-info")][contains(text(),'${workflow_name}')]

Select Sign Off Button
    wait until page contains element    xpath=//*[@id='ewb-tasks-sign-off-button']
    Robust Click    xpath=//*[@id='ewb-tasks-sign-off-button']

Confirm Sign Off View Appears
    [Arguments]    ${experiment_name}
    wait until page contains element  xpath=//div[contains(@class,'ewb-label-for ewb-panel-header-label')][contains(text(),'Sign Off - ${experiment_name}')]
