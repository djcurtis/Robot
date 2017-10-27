*** Settings ***
Library           IDBSHttpLibrary
Resource          ../common_resource.robot    # Common resources
Library           TestDataGenerationLibrary

*** Keywords ***
HTTP Header Setup
    Create Http Context    ${SERVER}:${WEB_SERVICE_PORT}    https
    Set Basic Auth    ${SERVICES USERNAME}    ${SERVICES PASSWORD}
    Set Request Header    Accept    application/json;charset=utf-8
    Set Request Header    Content-Type    application/json;charset=utf-8

XML HTTP Header Setup
    Create Http Context    ${SERVER}:${WEB_SERVICE_PORT}    https
    ${authorization}=    Base64 Encode String    ${SERVICES USERNAME}:${SERVICES PASSWORD}
    Set Basic Auth    ${SERVICES USERNAME}    ${SERVICES PASSWORD}
    Set Request Header    X-Web-Client-Author-Credentials    BASIC ${authorization}
    Set Request Header    Accept    application/xml;charset=utf-8
    Set Request Header    Content-Type    application/xml;charset=utf-8

Binary HTTP Header Setup
    Create Http Context    ${SERVER}:${WEB_SERVICE_PORT}    https
    Set Basic Auth    ${SERVICES USERNAME}    ${SERVICES PASSWORD}

HTTP Header Setup With Custom User
    [Arguments]    ${user}    ${pwd}
    [Documentation]    allows for HTTP setup using a custom user
    ...
    ...    *Arguments*
    ...
    ...    _user_ - the username
    ...
    ...    _pwd_ - the password for the user
    ...
    ...
    ...    *Example*
    ...
    ...    | HTTP Header Setup with custom user | John | John1
    ...    | POST | ${url}
    Create Http Context    ${SERVER}:${WEB_SERVICE_PORT}    https
    Set Basic Auth    ${user}    ${pwd}
    Set Request Header    Accept    application/json;charset=utf-8
    Set Request Header    Content-Type    application/json;charset=utf-8
