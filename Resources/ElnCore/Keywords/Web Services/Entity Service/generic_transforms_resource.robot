*** Settings ***
Resource          rest_entity_service_resource.txt
Resource          ../../Web Services/REST_SecurityService/rest_security_service_resource.txt

*** Variables ***
${GENERIC TRANSFORM DATA ENDPOINT}    /transformation/data
${spreadsheetTransformType}    idbs:spreadsheet_generic

*** Keywords ***
Get Generic Transformed Spreadsheet Data
    [Arguments]    ${entityid}    ${transformType}    ${entityversionid}
    [Documentation]    *GET*
    ...
    ...    /ewb/services/1.0/entities/${entityId}/transformation/data
    ...
    ...    application/json
    ...
    ...    Gets transformed data for a specific entity version and transformation type.
    ...    Permissions required:
    ...    - OPEN_{ENTITY_TYPE}
    ...    Returned HTTP status codes are:
    ...    - 200 (ok): the server has fulfilled the request
    ...    - 400 (bad request): any of the request parameters is missing or wrong
    ...    - 403 (forbidden): Incorrect permissions
    ...    - 404 (not found): the specified resource does not exist
    ...
    ...    Parameters
    ...
    ...
    ...    | *name* | *description* | *type* |
    ...    | entityId | the string representing the entity id | path |
    ...    | entityVersionId | the id of the entity version to retrieve transformed data for | query |
    ...    | transformationType | the transformation type \ | query |
    Request Setup
    Log    ${ENTITY SERVICE ENDPOINT}/${entityid}${GENERIC TRANSFORM DATA ENDPOINT}?transformationType=${transformType}&entityVersionId=${entityversionid}
    GET    ${ENTITY SERVICE ENDPOINT}/${entityid}${GENERIC TRANSFORM DATA ENDPOINT}?transformationType=${transformType}&entityVersionId=${entityversionid}
    Sleep    2s
    ${responseBody}=    Get Response Body
    Log    ${responseBody}
    [Return]    ${responseBody}

Wait For Generic Transform
    [Arguments]    ${spreadsheet_id}    ${timeout}=20
    [Documentation]    Checks to see if the Generic Transform has finished SUCCESSFULLY for a spreadsheet document
    ...
    ...    Specific to *Spreadsheet Generic Transforms* not spreadsheet mart transforms
    ...
    ...    *Arguments*
    ...
    ...    _spreadsheet_id_ : The ID of the spreadsheet document
    ...
    ...    _timeout_ : The time duration, in 2 seconds, to check the transform status for
    : FOR    ${element}    IN RANGE    ${timeout}
    \    Sleep    5s
    \    ${AVAILABLE}=    _Check Generic Transform Available    ${spreadsheet_id}
    \    Run Keyword If    '${AVAILABLE}'=='1'    Exit For Loop
    ${transform_status}=    _Get Generic Transform Status    ${spreadsheet_id}
    log    ${transform_status}
    Run Keyword If    '${transform_status}'!='AVAILABLE'    Fail    The Generic Transform is not available

Wait For Generic Transform Failure
    [Arguments]    ${spreadsheet_id}    ${timeout}=20
    [Documentation]    Checks to see if the Generic Transform has finished as a FAILURE for a spreadsheet document
    ...
    ...    Specific to *Spreadsheet Generic Transforms* not spreadsheet mart transforms
    ...
    ...    *Arguments*
    ...
    ...    _spreadsheet_id_ : The ID of the spreadsheet document
    ...
    ...    _timeout_ : The time duration, in 2 seconds, to check the transform status for
    : FOR    ${element}    IN RANGE    ${timeout}
    \    Sleep    2s
    \    ${FAILED}=    _Check Generic Transform Failure    ${spreadsheet_id}
    \    Run Keyword If    '${FAILED}'=='1'    Exit For Loop
    ${transform_status}=    _Get Generic Transform Status    ${spreadsheet_id}
    log    ${transform_status}
    Run Keyword If    '${transform_status}'!='FAILED'    Fail    The Generic Transform is not Failed

_Check Generic Transform Available
    [Arguments]    ${spreadsheet_id}
    [Documentation]    Given the Spreadsheet ID, this keyword connects to the database, and will return true(1) if the transform status equals AVAILABLE
    ...
    ...    Specific to *Spreadsheet Generic Transforms* not spreadsheet mart transforms
    # Transform Status from Database
    Connect To Database    ${POOL_USERNAME}    ${POOL_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    ${queryResults}=    Query    select count(*) from ENTITY_VERSION_TRANS_DATA evtd, ENTITY_VERSIONS ev where evtd.trans_data_status_id = 'AVAILABLE' and evtd.transformation_type = 'idbs:spreadsheet_generic' and evtd.entity_version_id = ev.entity_version_id and ev.entity_id = '${spreadsheet_id}'    # Checks whether transform status equals Available is True(1) or False(0)
    ${transform_available}=    Set Variable    ${queryResults[0][0]}
    log    ${transform_available}
    Disconnect From Database
    [Return]    ${transform_available}

_Check Generic Transform Failure
    [Arguments]    ${spreadsheet_id}
    [Documentation]    Given the Spreadsheet ID, this keyword connects to the database, and will return true(1) if the transform status equals FAILED
    ...
    ...    Specific to *Spreadsheet Generic Transforms* not spreadsheet mart transforms
    # Transform Status from Database
    Connect To Database    ${POOL_USERNAME}    ${POOL_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    ${queryResults}=    Query    select count(*) from ENTITY_VERSION_TRANS_DATA evtd, ENTITY_VERSIONS ev where evtd.trans_data_status_id = 'FAILED' and evtd.transformation_type = 'idbs:spreadsheet_generic' and evtd.entity_version_id = ev.entity_version_id and ev.entity_id = '${spreadsheet_id}'    # Checks whether transform status equals FAILED is True(1) or False(0)
    ${transform_failed} =    Set Variable    ${queryResults[0][0]}
    log    ${transform_failed}
    Disconnect From Database
    [Return]    ${transform_failed}

_Get Generic Transform Status
    [Arguments]    ${spreadsheet_id}
    [Documentation]    Given the Spreadsheet ID, this keyword connects to the database, and returns the transform status
    ...
    ...    Specific to *Spreadsheet Generic Transforms* not spreadsheet mart transforms
    # Transform Status from Database
    Connect To Database    ${POOL_USERNAME}    ${POOL_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    ${queryResults}=    Query    select evtd.trans_data_status_id from ENTITY_VERSION_TRANS_DATA evtd, ENTITY_VERSIONS ev where evtd.transformation_type = 'idbs:spreadsheet_generic' and evtd.entity_version_id = ev.entity_version_id and ev.entity_id = '${spreadsheet_id}'
    ${transform_status}=    Set Variable    ${queryResults[0][0]}    # If failing here check you have version saved entity
    log    ${transform_status}
    Disconnect From Database
    [Return]    ${transform_status}
