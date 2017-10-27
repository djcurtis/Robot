*** Settings ***
Library    IDBSSelenium2Library
Resource          ../../Selenium/general_resource.robot

*** Variables ***
${OK_BUTTON} =    xpath=//*[@id='okButton']
${SELECT_ALL_BUTTON} =    xpath=//*[@id='display-pages-select-all-button']
${UNSELECT_ALL_BUTTON} =    xpath=//*[@id='display-pages-unselect-all-button']

${text_item_frame} =    text-editor-panel-3-editorimpl_ifr
${tmplt_text_item_frame} =    text-editor-panel-1-editorimpl_ifr
*** Keywords ***
Select All Pages
    ${present}=    Run Keyword and Return Status    IDBSSelenium2Library.Element Should Be Visible   ${SELECT_ALL_BUTTON}
    run keyword if     ${present}    Robust Click    ${SELECT_ALL_BUTTON}

Click Insert Button
    Robust Click    ${OK_BUTTON}

Check screen for Text Item content
    [Arguments]    ${text}
    unselect frame
    Wait Until Element Is Visible    ${text_item_frame}    15s
    select frame  ${text_item_frame}
    sleep    2s
    page should contain element    xpath=//*[@id='tinymce']/*[contains(text(),'${text}')]
    unselect frame

Check Template screen for Text Item content
    [Arguments]    ${text}
    unselect frame
    Wait Until Element Is Visible    ${tmplt_text_item_frame}    15s
    select frame  ${tmplt_text_item_frame}
    sleep    2s
    page should contain element    xpath=//*[@id='tinymce']/*[contains(text(),'${text}')]
    unselect frame

Check screen for Office Document Content
    [Arguments]    ${item_ref}
    Wait Until page contains Element    xpath=//div[@id='document-body-${item_ref}-panel']//*[@class='gwt-Image']    15s

Check screen for Spreadsheet Content
    [Arguments]    ${item_ref}    ${page_no}
    Wait Until page contains Element    xpath=//div[@id='document-body-${item_ref}-panel']/table/tbody/tr/td/table/tbody//tr[${page_no}]//div[@class='ewb-display-page-image-preview']