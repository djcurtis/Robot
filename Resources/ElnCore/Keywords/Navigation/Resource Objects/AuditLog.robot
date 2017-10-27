*** Settings ***
Library    IDBSSelenium2Library


*** Variables ***
${AUDIT_PAGE_TITLE} =    xpath=//div[@id='auditHeaderTitle'][contains(text(),'Entity Audit History')]
${AUDIT_WINDOW_TITLE} =

${AUDITLOG_MESSAGE} =    xpath=//*[@class="table-content-tr-td message-column style-scope audit-table"]
${AUDITLOG_COMMENT} =    xpath=//*[@class="table-content-tr-td reason-column style-scope audit-table"]
${AUDITLOG_EVENTLOCATION} =    xpath=//*[@class="table-content-tr-td event-location-column style-scope audit-table"]

*** Keywords ***
Select Audit Window
    Wait Until Keyword Succeeds    10    2    IDBSSelenium2Library.Select Window    Entity Audit Log
    sleep    1s

Return to E-WorkBook
    [Arguments]    ${experiment_name}
    Wait Until Keyword Succeeds    10    2    IDBSSelenium2Library.Select Window    IDBS E-WorkBook - ${experiment_name}
    sleep    1s

Check Header Title Exists
    PAGE SHOULD CONTAIN ELEMENT    ${AUDIT_PAGE_TITLE}

AuditLog Message Should Contain
    [Arguments]    ${message}
    PAGE SHOULD CONTAIN ELEMENT    ${AUDITLOG_MESSAGE}[contains(text(),"${message}")]

AuditLog Event Location Should Contain
    [Arguments]    ${location}
    PAGE SHOULD CONTAIN ELEMENT    ${AUDITLOG_EVENTLOCATION}[starts-with(text(),"${location}")]

AuditLog Message Should Start With
    [Arguments]    ${message}
    PAGE SHOULD CONTAIN ELEMENT    ${AUDITLOG_MESSAGE}[starts-with(text(),"${message}")]

AuditLog Event Location And Message Should Contain
    [Arguments]    ${location}    ${value}
    PAGE SHOULD CONTAIN ELEMENT    xpath=//*[@class="table-content-tr-td event-location-column style-scope audit-table"][contains(text(),"${location}")]/../*[@class="table-content-tr-td message-column style-scope audit-table"][contains(text(),"${value}")]

AuditLog Comment Should Contain
    [Arguments]    ${COMMENT}
    PAGE SHOULD CONTAIN ELEMENT    ${AUDITLOG_COMMENT}[contains(text(),"${COMMENT}")]

