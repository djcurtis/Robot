*** Settings ***
Resource    ../Navigation/Resource Objects/AuditLog.robot
Library           IDBSSelenium2Library
Library           EntityAPILibrary
Library           DateTime
#Library           OracleLibrary
Library           OperatingSystem
Library           FileLibrary
Library           String

*** Variables ***
${TIMESTAMP}      ${EMPTY}

*** Keywords ***

Check Audit for Create Experiment
    [Arguments]    ${experiment_name}
    AuditLog Message Should Contain    Created version 1 (VERSION) of EXPERIMENT entity '${experiment_name}' (Created EXPERIMENT)
    #AuditLog Comment Should Contain    Created EXPERIMENT :
    AuditLog.Return to E-WorkBook    ${experiment_name}

Check Audit for Create Text Item
    [Arguments]    ${experiment_name}
    AuditLog Message Should Contain    Created (VERSION) item 'Text (text/html)' in entity '/Root/OQ Group/OQ Project/${experiment_name}'
    #AuditLog Comment Should Contain    Data Added : IOQ-ELN-4 Insert Text Items Version Save
    AuditLog.Return to E-WorkBook    ${experiment_name}

Check Audit for Edit Text Item
    [Arguments]    ${experiment_name}
    AuditLog Message Should Contain    Updated version 2 (CACHE) of TEXT_DOCUMENT entity 'Text'
    AuditLog.Return to E-WorkBook    ${experiment_name}

Check Audit for Insert Office Document
    [Arguments]    ${experiment_name}
    AuditLog Message Should Contain    Created (VERSION) item 'Example Office Document.docx (application/vnd.openxmlformats-officedocument.wordprocessingml.document)' in entity '/Root/OQ Group/OQ Project/${experiment_name}'
    AuditLog.Return to E-WorkBook    ${experiment_name}

Check Audit for Insert Spreadsheet Document
    [Arguments]    ${experiment_name}
    AuditLog Message Should Contain    Created (VERSION) item 'Spreadsheet (application/x-idbs-web-spreadsheet)' in entity '/Root/OQ Group/OQ Project/${experiment_name}'
    AuditLog.Return to E-WorkBook    ${experiment_name}

Check Audit for Insert EWB Spreadsheet Document
    [Arguments]    ${experiment_name}
    AuditLog Message Should Contain    Created (VERSION) item 'OQ Spreadsheet Test File.ewbss (application/octet-stream)' in entity '/Root/OQ Group/OQ Project/${experiment_name}'
    AuditLog.Return to E-WorkBook    ${experiment_name}

Check Audit for Insert Excel Document
    [Arguments]    ${experiment_name}    ${file_name}    ${version}
    AuditLog Message Should Contain    Created version ${version} (CACHE) of DOCUMENT entity '${file_name}' (Created DOCUMENT)
    AuditLog.Return to E-WorkBook    ${experiment_name}

Check Audit for Edit Office Document
    [Arguments]    ${experiment_name}
    AuditLog Message Should Contain    Updated version 2 (CACHE) of DOCUMENT entity 'Example Office Document.docx'
    Return to E-WorkBook    ${experiment_name}

Check Audit for Inserting an Image
    [Arguments]    ${experiment_name}
    AuditLog Message Should Contain    Created version 1 (CACHE) of DOCUMENT entity 'Gel.png' (Created DOCUMENT)
    AuditLog.Return to E-WorkBook    ${experiment_name}

Check Audit for Editting an Image
    [Arguments]    ${experiment_name}    ${image_name}    ${version}
    AuditLog Message Should Contain    Updated version ${version} (VERSION) of DOCUMENT entity '${image_name}'
    AuditLog.Return to E-WorkBook    ${experiment_name}

Check Audit for Version Save
    [Arguments]    ${experiment_name}    ${version}    ${comment}
    set selenium speed    1
    AuditLog Comment Should Contain    ${comment}
    set selenium speed    0
    AuditLog.Return to E-WorkBook    ${experiment_name}

Check Audit for PDF of Record
    [Arguments]    ${experiment_name}
    AuditLog Message Should Start With    Created version 1 (VERSION) of PDF entity
    AuditLog Message Should Contain    ${experiment_name}' (Created PDF)
    AuditLog.Return to E-WorkBook    ${experiment_name}

Check Audit for Record Sign Off
    [Arguments]    ${experiment_name}
    AuditLog Message Should Contain    Actioner signed off item 'Example Excel Document.xlsx'
    AuditLog Message Should Contain    Actioner signed off item 'Example Office Document.docx'
    AuditLog Message Should Contain    Actioner signed off item 'Text'
    AuditLog.Return to E-WorkBook    ${experiment_name}

Check Audit for Actioner Sign Off
    [Arguments]    ${experiment_name}
    AuditLog Message Should Contain    Actioner signed off item 'Gel.png'
    AuditLog Message Should Contain    Actioner signed off item 'Example Excel Document.xlsx'
    AuditLog Message Should Contain    Actioner signed off item 'Example Office Document.docx'
    AuditLog Message Should Contain    Actioner signed off item 'Text'
    AuditLog.Return to E-WorkBook    ${experiment_name}

Check Audit for Reviewer Sign Off
    [Arguments]    ${experiment_name}
    AuditLog Message Should Contain    Reviewer signed off item 'Gel.png'
    AuditLog Message Should Contain    Reviewer signed off item 'Example Excel File.xlsx'
    AuditLog Message Should Contain    Actioner signed off item 'Example Office Document.docx'
    AuditLog Message Should Contain    Actioner signed off item 'Text'
    AuditLog.Return to E-WorkBook    ${experiment_name}

Check Audit for Record Publish
    [Arguments]    ${experiment_name}
    AuditLog Message Should Contain    Created version 1 (VERSION) of PDF entity
    AuditLog Message Should Contain    ${experiment_name}' (Created PDF)
    AuditLog Message Should Contain    Locked For Editing changed from: 'false' : to new value '[true]'
    AuditLog.Return to E-WorkBook    ${experiment_name}

Check Audit for Allow Further Editing
    [Arguments]    ${experiment_name}
    AuditLog Message Should Contain    Locked For Editing changed from: 'true' : to new value '[false]'
    AuditLog.Return to E-WorkBook    ${experiment_name}

Check Audit for Delete Items
    [Arguments]    ${experiment_name}
    AuditLog Message Should Contain    Deleted item 'Text (text/html)
    AuditLog.Return to E-WorkBook    ${experiment_name}

Check Audit for Catalog Value Entry
    [Arguments]    ${experiment_name}    ${location}    ${value}
    set selenium speed    1
    AuditLog Event Location And Message Should Contain    ${location}     ${value}
    #AuditLog Event Location Should Contain    ${location}
    #AuditLog Message Should Contain    ${value}
    set selenium speed    0
    AuditLog.Return to E-WorkBook    ${experiment_name}

Check Audit for Event and Message Entry
    [Arguments]    ${experiment_name}    ${location}    ${value}
    set selenium speed    1
    AuditLog Event Location And Message Should Contain    ${location}     ${value}
    #AuditLog Event Location Should Contain    ${location}
    #AuditLog Message Should Contain    ${value}
    set selenium speed    0
    AuditLog.Return to E-WorkBook    ${experiment_name}

Check Audit for Knockout
    [Arguments]    ${experiment_name}    ${location}    ${value}
    set selenium speed    1
    AuditLog Event Location And Message Should Contain    ${location}     ${value}
    #AuditLog Event Location Should Contain    ${location}
    #AuditLog Message Should Contain    ${value}
    set selenium speed    0
    AuditLog.Return to E-WorkBook    ${experiment_name}

Check Audit for Deleting Value in Cell
    [Arguments]    ${experiment_name}    ${location}    ${value}
    set selenium speed    1
    AuditLog Event Location And Message Should Contain    ${location}     ${value}
    #AuditLog Event Location Should Contain    ${location}
    #AuditLog Message Should Contain    ${value}
    set selenium speed    0
    AuditLog.Return to E-WorkBook    ${experiment_name}

#Check audit log for user
#    [Arguments]    ${user_name}    ${seconds_to_go_back}    ${expected_file}    @{extra_substitutions}
#    Connect To Database    ${CORE_USERNAME}    ${CORE_PASSWORD}    ${DB_SERVER}    ${ORACLE_SID}
#    Create File    ${OUTPUTDIR}/get_user_audit_log.sql    SELECT USER_NAME, HISTORY_TYPE, MESSAGE FROM history_entries WHERE user_name='${user_name}' and ZONE_STAMP >= systimestamp - numtodsinterval(${seconds_to_go_back},'SECOND') ORDER BY ZONE_STAMP asc, MESSAGE asc
#    Execute Sql Script And Write To Csv File    ${OUTPUTDIR}/get_user_audit_log.sql    ${OUTPUTDIR}/user_audit_log.csv
#    Disconnect From Database
#    Replace Regexp In File    ${OUTPUTDIR}/user_audit_log.csv    ${user_name}    *** USERNAME ***
#    :FOR    ${subsitution}    IN      @{extra_substitutions}
#    \    ${substituition_pattern}    ${mask}=    Split String    ${subsitution}    =    1
#    \    Replace Regexp In File    ${OUTPUTDIR}/user_audit_log.csv    ${substituition_pattern}    ${mask}
#    Compare Files    ${OUTPUTDIR}/user_audit_log.csv    ${expected_file}    ${OUTPUTDIR}/user_audit_log_diff.html
