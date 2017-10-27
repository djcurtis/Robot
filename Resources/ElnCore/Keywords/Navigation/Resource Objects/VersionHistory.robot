*** Settings ***
Library    IDBSSelenium2Library
Resource          ../../Common/common_resource.robot
Resource          ../../Selenium/general_resource.robot


*** Variables ***


*** Keywords ***

Click Version Node
    [Arguments]    ${version_reference}
    wait until page contains element    xpath=//div[@class="gwt-Hyperlink ewb-entity-treenode-text"]/a[contains(text(),'${version_reference}')]
    Robust Click    xpath=//div[@class="gwt-Hyperlink ewb-entity-treenode-text"]/a[contains(text(),'${version_reference}')]

Select Save As
    wait until page contains element    xpath=//*[@id="ewb-record-action-bar"][contains(text(),'Save As')]
    Robust Click    xpath=//*[@id="ewb-record-action-bar"][contains(text(),'Save As')]

Select Restore Record
    wait until page contains element    xpath=//*[@id='ewb-record-action-bar-restore-record']
    Robust Click    xpath=//*[@id='ewb-record-action-bar-restore-record']

Accept Removal of Signatures Dialog
    wait until page contains element    xpath=//div[contains(@class,'ewb-message-box-text')][contains(text(),'Restoring a previous version will remove any signatures')]
    Robust Click    xpath=//*[@id='okButton']

Confirm Version Selected
    [Arguments]    ${experiment_name}    ${version_reference}
    wait until page contains element  xpath=//div[contains(@class, "ewb-label-for ewb-panel-header-label")][contains(text(),'${experiment_name} (${version_reference})')]

Confirm Version History Displayed
    [Arguments]    ${experiment_name}
    wait until page contains element  xpath=//div[contains(@class,'ewb-panel-header-label')][contains(text(),'Version History for ${experiment_name}')]


