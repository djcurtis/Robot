*** Settings ***
Library    IDBSSelenium2Library
#Resource          ../../Common/common_resource.robot
Resource          ../../Selenium/general_resource.robot

*** Variables ***
${ROOT_BREADCRUMB} =    xpath=//a[contains(@class, 'ewb-breadcrumb-terminal') and contains(text(), 'Root')]
${ADMINISTRATOR_GROUP} =    xpath=//div[@class='gwt-Hyperlink ewb-entity-treenode-text']/a[text()='Administrators']
${ADMINISTRATOR_GROUP_DISPLAY_MENU} =    xpath=//img[@class='gwt-Image ewb-entity-treenode-menu-image']/*[contains(@title,'Display menu')]
${EXPERIMENT_AUDIT_HISTORY} =    xpath=//div[@id='ewb-popup-menu']//*[@id='ewb-view-audit-history-command']

*** Keywords ***

Go To Root
    [Documentation]    Clicks the "Root" node in the navigator tree
    Robust Link Click    Root
    Wait Until Page Contains Element    ${ROOT_BREADCRUMB}    30s

Select Administrator Group Node
    [Documentation]    Clicks the "Administrator" Group node in the navigator tree
    Robust Link Click   ${ADMINISTRATOR_GROUP}


Select Group Node
    [Arguments]    ${group_name}
    [Documentation]    Clicks the Group node in the navigator tree
    Robust Link Click   xpath=//div[@class='gwt-Hyperlink ewb-entity-treenode-text']/a[text()='${group_name}']

Select Item Node
    [Arguments]    ${node_name}
    [Documentation]    Clicks the node in the navigator tree
    Robust Link Click   xpath=//div[@class='gwt-Hyperlink ewb-entity-treenode-text']/a[contains(text(),'${node_name}')]

Select Group Node Display Menu
    [Documentation]    Clicks the Group node Navigator Menu in the navigator tree
    Robust Link Click   ${ADMINISTRATOR_GROUP_DISPLAY_MENU}

Select Project Group Node Options Menu
    [Documentation]    Clicks the Project Group node Navigator Menu in the navigator tree
    [Arguments]    ${project_name}
    Robust Link Click   xpath=//div[@class='gwt-Hyperlink ewb-entity-treenode-text']/a[contains(text(),'${project_name}')]

Select Project Node
    [Documentation]    Clicks the Defined Project node in the navigator tree
    [Arguments]    ${PROJECT_NAME}
    Robust Link Click   xpath=//div[@class='gwt-Hyperlink ewb-entity-treenode-text']/a[text()='${PROJECT_NAME}']

Select Experiment Node
    [Documentation]    Clicks the Defined Experiment node in the navigator tree
    [Arguments]    ${EXPERIMENT_NAME}
    wait until page contains element  xpath=//div[@class='gwt-Hyperlink ewb-entity-treenode-text']/a[text()='${EXPERIMENT_NAME}']
    Robust Link Click   xpath=//div[@class='gwt-Hyperlink ewb-entity-treenode-text']/a[text()='${EXPERIMENT_NAME}']

Confirm Delete Experiment Not Permitted
    wait until page contains element  xpath=//*[@id='ewb-entity-command-delete']/*[@class='x-item-disabled']

Confirm Delete Experiment Permitted
    wait until page contains element  xpath=//*[@id='ewb-entity-command-delete']/a[contains(text(),'Delete')]

Confirm Editing Not Permitted
    wait until page contains element  xpath=//*[@id='ewb-command-edit-record-menu']/a[@class='x-item-disabled']

Confirm Editing Permitted
    wait until page contains element  xpath=//*[@id='ewb-command-edit-record-menu']/a[contains(text(),'Edit')]

Select Experiment Delete Option
    Robust Click    xpath=//*[@id='ewb-entity-command-delete']/a[contains(text(),'Delete')]

Select Record Options Menu
    [Arguments]    ${EXPERIMENT_NAME}
    wait until page contains element   xpath=//div[@class='ewb-entity-treenode-type-experiment'][contains(@title,'${EXPERIMENT_NAME}')]//img[@title='Display menu'][@style='visibility: visible;']
    Robust Click    xpath=//div[@class='ewb-entity-treenode-type-experiment'][contains(@title,'${EXPERIMENT_NAME}')]//img[@title='Display menu'][@style='visibility: visible;']

Select Properties Option
    wait until page contains element  xpath=//*[@id='ewb-show-properties-command']/a[contains(text(),'Properties')]
    Robust Click    xpath=//*[@id='ewb-show-properties-command']/a[contains(text(),'Properties')]

Select Audit History Menu Option
    wait until page contains element   ${EXPERIMENT_AUDIT_HISTORY}
    Robust Click    ${EXPERIMENT_AUDIT_HISTORY}

Check Version Number
    [Arguments]    ${version}
    wait until page contains element   xpath=//div[@class='gwt-Label ewb-property-value ewb-property-underline'][contains(text(),'${version}')]

Collapse Nodes
    [Documentation]    Collapses the navigator at the currently selected level.
    Click Element    navtree-link-collapse

Expand Nodes
    [Documentation]    Expands the navigator at the currently selected level.
    Click Element    navtree-link-expand

Refresh Navigator Tree
    [Documentation]    Clicks the Refresh button on the navigator tree and waits for it to refresh
    Robust Click    navtree-link-refresh

Expand Individual Navigator Node
    [Arguments]    ${link ref}
    [Documentation]    Click on a navigator link and expands the navigator on that node.
    Wait Until Page Contains Element    xpath=//div[@title="${link ref}"]/table/tbody/tr/td[1]/img
    Robust Click    xpath=//div[@title="${link ref}"]/table/tbody/tr/td[1]/img

Open Navigator Tool Menu
    [Arguments]    ${Display Name}
    Comment    Robust Click    xpath=.//*[@id='ewb-appshell-west']//*[text()='${Display Name}']
    Sleep    1s
    Scroll Element Into View    xpath=//*[@id='ewb-appshell-west']//*[text()='${Display Name}']
    Robust Click    xpath=//*[@id='ewb-appshell-west']//*[text()='${Display Name}']/../../../td[1]
    Wait Until Page Contains Element    xpath=(//*[@id='ewb-appshell-west']//*[text()='${Display Name}']/../../../td[last()-1])/img
    Robust Click    xpath=(//*[@id='ewb-appshell-west']//*[text()='${Display Name}']/../../../td[last()-1])/img
    ${result}=    Run Keyword and Ignore Error    Wait Until Page Contains Element    ${context tool menu}    5s
    Run Keyword If    ${result}!=('PASS', None)    Robust Click    xpath=//*[@id='ewb-appshell-west']//*[text()='${Display Name}']/../../../td[1]
    Run Keyword If    ${result}!=('PASS', None)    Wait Until Page Contains Element    xpath=(//*[@id='ewb-appshell-west']//*[text()='${Display Name}']/../../../td[last()-1])/img
    Run Keyword If    ${result}!=('PASS', None)    Robust Click    xpath=(//*[@id='ewb-appshell-west']//*[text()='${Display Name}']/../../../td[last()-1])/img
    Run Keyword If    ${result}!=('PASS', None)    Wait Until Page Contains Element    ${context tool menu}    5s
    Execute Javascript    document.getElementById("${context tool menu}").querySelector(".menu").classList.add("visible")
    [Teardown]

Click And Expand Link
    [Arguments]    ${LINK_REF}
    [Documentation]    Click on a navigator link and expands the navigator on that node.
    Click Link    ${LINK_REF}
    Expand Nodes
    Wait Twenty Seconds
    Title Should Be    IDBS E-WorkBook - ${LINK_REF}

Navigator Link Should Be Present
    [Arguments]    ${name}
    [Documentation]    Checks that a navigator element is displayed using the display name defined by ${name}
    Wait Until Element Is Visible    xpath=//div[@title="${name}"]/table/tbody/tr/td[2]/div/table/tbody/tr/td[2]/div/a    30 sec

Navigator Link Should Not Be Present
    [Arguments]    ${name}
    [Documentation]    Checks that a navigator element is not displayed using the display name defined by ${name}
    Wait Until Page Does Not Contain Element    xpath=//div[@title="${name}"]/table/tbody/tr/td[2]/div/table/tbody/tr/td[2]/div/a    30 sec

Check Node is Visible
    [Arguments]    ${node_name}
    [Documentation]    Check if a node name is visible in the navigator tree
    ${is_visible}=    Run Keyword and Return Status     Wait until page contains element    xpath=//div[@class='gwt-Hyperlink ewb-entity-treenode-text']/a[text()='${node_name}']
    [Return]    ${is_visible}

Select Create New Experiment from Nav Tree
    [Arguments]    ${project_name}
    Select Project Group Node Options Menu    xpath=(//*[@class='gwt-Hyperlink ewb-entity-treenode-text']/a[contains(text(),'${project_name}')]/following::td/img[contains(@class,'gwt-Image ewb-entity-treenode-menu-image')])[1]
    wait until page contains element    xpath=//*[@id='ewb-entity-menu-new']/a[text()='Create New']
    Robust Click    xpath=//*[@id='ewb-entity-menu-new']/a[text()='Create New']


