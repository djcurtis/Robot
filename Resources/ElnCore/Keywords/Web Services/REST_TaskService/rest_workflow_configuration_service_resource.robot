*** Settings ***
Documentation     A resource file containing IDBS defined keywords used for testing the IDBS E-WorkBook Web Client application. This resource file contains keywords applicable to the REST workflow configuration web service.
...               This file is loaded by the common_resource.txt file which is automatically loaded when running tests through the Robot Framework.
...               *Version: E-WorkBook Web Client 9.2.0*
Library           IDBSHttpLibrary
Library           String
Resource          ../../Common/common_resource.robot

*** Variables ***
${WORKFLOW CONFIG ENDPOINT}    /ewb/services/1.0/workflowconfigurations
${WORKFLOW CONFIG REQUEST ENDPOINT}    /ewb/services/1.0/workflowconfigurations/workflowrequest

*** Keywords ***
Workflow Configuration Request Setup
    Create Http Context    ${SERVER}:${WEB_SERVICE_PORT}    https
    Set Basic Auth    ${SERVICES USERNAME}    ${SERVICES PASSWORD}
    Set Request Header    Accept    application/json;charset=utf-8
    Set Request Header    Content-Type    application/json;charset=utf-8

Get Workflow Configurations For Entity
    [Arguments]    ${entity id}    ${configuration name}=none
    [Documentation]    Gets the valid workflow configurations for the entity given by the ${entity id} argument and optionally filters by a single configuration if the ${configuration name} argument is populated
    ...
    ...    *Arguments*
    ...    entity id = the entity id on which to look for workflow configurations
    ...    configuration name=none = optional attribute to filter results by a single workflow configuration
    ...
    ...    *Return value*
    ...    Response body is returned, in the format specified during setup (default = JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Workflow Configuration Request Setup
    Run Keyword If    '${configuration name}'=='none'    GET    ${WORKFLOW CONFIG ENDPOINT}?entityid=${entity id}
    Run Keyword Unless    '${configuration name}'=='none'    GET    ${WORKFLOW CONFIG ENDPOINT}?entityid=${entity id}&configuration=${configuration name}
    ${RESPONSE BODY 1}=    Get Response Body
    [Return]    ${RESPONSE BODY 1}

Get Workflow Configuration Request For Entity
    [Arguments]    ${entity id}    ${configuration name}
    [Documentation]    Gets the valid workflow configurations request required to create a valid workflow for the entity given by the ${entity id} argument the workflow configuration given by the ${configuration name} argument.
    ...
    ...    *Arguments*
    ...    entity id = the entity id on which to look for workflow configurations
    ...    configuration name = the workflow configuration name to be used
    ...
    ...    *Return value*
    ...    Response body is returned, in the format specified during setup (default = JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Workflow Configuration Request Setup
    GET    ${WORKFLOW CONFIG REQUEST ENDPOINT}?entityid=${entity id}&configuration=${configuration name}
    ${RESPONSE BODY 1}=    Get Response Body
    [Return]    ${RESPONSE BODY 1}

Get Workflow Configurations By Configuration ID
    [Arguments]    ${entityid}    ${configuration id}
    [Documentation]    Gets the workflow configuration based on the ${configuration id} given
    ...
    ...    *Arguments*
    ...    configuration id = the configuration id to use
    ...
    ...    *Return value*
    ...    Response body is returned, in the format specified during setup (default = JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Workflow Configuration Request Setup
    GET    ${WORKFLOW CONFIG ENDPOINT}?entityid=${entityid}&configuration=${configuration id}
    ${RESPONSE BODY 1}=    Get Response Body
    [Return]    ${RESPONSE BODY 1}

Get Workflow Configuration ID
    [Arguments]    ${json string}
    [Documentation]    Returns the workflow configuration ID from a given JSON string
    ...
    ...    *Arguments*
    ...    json string = the string expected to contain a single workflow configuration
    ...
    ...    *Preconditions*
    ...    None
    ...
    ...    *Example*
    ${temp workflow configuration ID}=    Get Json Value    ${json string}    /workflowConfiguration/0/workflowConfigurationId
    ${workflow configuration ID}=    Replace String    ${temp workflow configuration ID}    "    ${EMPTY}
    [Return]    ${workflow configuration ID}

Check JSON Response Value
    [Arguments]    ${json response}    ${attribute path}    ${attribute value}
    Json Value Should Equal    ${json response}    ${attribute path}    ${attribute value}

Check Number Of Tasks In Configuration
    [Arguments]    ${json response}    ${expected number of tasks}
    ${temp result 1}=    Get Json Value    ${json response}    /workflowConfiguration
    ${temp result 2}=    Parse Json    ${temp result 1}
    Length Should Be    ${temp result 2}    ${expected number of tasks}

Get Workflow Configurations For Entity And Expect Error
    [Arguments]    ${entity id}    ${status code}    ${configuration name}=none
    [Documentation]    Gets the valid workflow configurations for the entity given by the ${entity id} argument and optionally filters by a single configuration if the ${configuration name} argument is populated
    ...
    ...    *Arguments*
    ...    entity id = the entity id on which to look for workflow configurations
    ...    configuration name=none = optional attribute to filter results by a single workflow configuration
    ...
    ...    *Return value*
    ...    Response body is returned, in the format specified during setup (default = JSON)
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Workflow Configuration Request Setup
    Next Request Should Not Succeed
    Run Keyword If    '${configuration name}'=='none'    GET    ${WORKFLOW CONFIG ENDPOINT}?entityid=${entity id}
    Run Keyword Unless    '${configuration name}'=='none'    GET    ${WORKFLOW CONFIG ENDPOINT}?entityid=${entity id}&configuration=${configuration name}
    Response Status Code Should Equal    ${status code}
    ${RESPONSE BODY 1}=    Get Response Body
    Next Request Should Succeed
    [Return]    ${RESPONSE BODY 1}
