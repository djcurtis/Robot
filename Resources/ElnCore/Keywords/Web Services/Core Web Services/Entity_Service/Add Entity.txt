*** Settings ***
Documentation     The following test cases are all for the endpoint: POST /services/1.0/entities/{parentEntityId}/children
...
...               Add a new entity to a parent entity and returns the newly created entity id.
Suite Setup       Record Service Suite Setup
Suite Teardown    Record Service Suite Teardown
Force Tags        EWB-SAPI-SSP-ENT-AEN    Add Entity
# Library           EntityAPILibrary
# Library           SecurityAPILibrary
Library           XMLLibrary
Resource          ../../../Libraries/common_resource.txt
Resource          record_service_resources.txt    # suite setup and teardown
Resource          ../../../Libraries/Web Services/REST_SecurityService/rest_security_service_resource.txt
Resource          ../../../Libraries/General Setup/general setup tools.txt
Resource          ../../../Libraries/Core Web Services/Record Service/rest_record_service_resource.txt    # REST Record Service
Resource          ../../../Libraries/Core Web Services/Entity Service/rest_entity_service_resource.txt    # REST Entity Service
Resource          ../../../Libraries/Core Web Services/SAPI_Types/ewb_types_resource.txt    # Resources for building EWB DTO, e.g. DTO to commit, create experiment, list inbox items.

*** Test Cases ***
Add entity
    [Documentation]    EWB-SAPI-SSP-ENT-AEN-S001
    ...
    ...    A successful call returns the HTTP status 200 and a the newly created entity id
    [Tags]    EWB-SAPI-SSP-ENT-AEN-S001
    ${experiment_name}=    Set Variable    AEN-S001
    ${experiment_id}=    Create Experiment    ${project_id}    ${experiment_name}
    ${experiment_version_id}=    Get Entity Version ID    ${experiment_id}
    # Checking expectations
    ${sapi_entity_dto}=    Get Entity    ${experiment_id}    ${experiment_version_id}
    Check Xml Element Value Contains    check experiment id value    ${sapi_entity_dto}    ${experiment_name}    entityName    elementNamespace=http://entity.services.ewb.idbs.com

Add entity with not existing parent entity
    [Documentation]    EWB-SAPI-SSP-ENT-AEN-S002
    ...
    ...    If the parent entity does not exist, then the HTTP status code 404 is returned to the client
    [Tags]    EWB-SAPI-SSP-ENT-AEN-S002
    ${experiment_name}=    Set Variable    AEN-S002
    # missing parent id
    ${experiment_id}=    Create Experiment    WrongParentId    ${experiment_name}    404

Add entity with no permissions
    [Documentation]    EWB-SAPI-SSP-RES-GEN-S003
    ...
    ...    A client requires the CREATE_<ENTITY_TYPE> permission. If it does not have it, then the HTTP status code 403 is returned to the client
    [Tags]    EWB-SAPI-SSP-ENT-AEN-S003
    ${experiment_name}=    Set Variable    AEN-S003
    Use User With Permissions    ${username}    ${password}    ${project_id}
    ${experiment_id}=    Create Experiment    ${project_id}    ${experiment_name}    403

Add entity with missing parent entity
    [Documentation]    EWB-SAPI-SSP-ENT-AEN-S004
    ...
    ...    If the call parameter ‘parentEntityId’ is missing or invalid, then the HTTP status code 400 is returned to the client
    [Tags]    EWB-SAPI-SSP-ENT-AEN-S004
    ${experiment_name}=    Set Variable    AEN-S004
    # missing parent id
    ${experiment_id}=    Create Experiment    ${EMPTY}    ${experiment_name}    404

Add entity invalid DTO
    [Documentation]    EWB-SAPI-SSP-ENT-AEN-S005
    ...
    ...    If the SAPIEntityDefinition is missing or invalid (e.g. missing mandatory attributes), then the HTTP status code 400 is returned to the client
    [Tags]    EWB-SAPI-SSP-ENT-AEN-S005
    ${experiment_name}=    Set Variable    AEN-S005
    # invalid DTO - missing attribute
    ${sapi_entity_definition}=    Build Experiment DTO    ${experiment_name}    ${EMPTY}
    ${experiment_id}=    Add Entity With Custom DTO    ${project_id}    ${sapi_entity_definition}    400
    # invalid DTO - wrong type
    ${sapi_data_updated_info}=    Set Variable    ${EMPTY}    # experiment has no data info
    ${attribute_update_sequence_node}=    Build SAPIAttributeUpdateSequence    title=TestTitle    statusName=Started    # mandatory attribute
    ${entity_definition_node}=    Build SAPIEntityDefinition    WrongType    ${experiment_name}    ${sapi_data_updated_info}    ${attribute_update_sequence_node}
    ${sapi_entity_definition}=    XMLLibrary.Get Xml    ${entity_definition_node}
    ${experiment_id}=    Add Entity With Custom DTO    ${project_id}    ${sapi_entity_definition}    400

*** Keywords ***
