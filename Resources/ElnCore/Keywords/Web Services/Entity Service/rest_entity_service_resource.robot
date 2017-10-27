*** Settings ***
Library           String
Library           IDBSHttpLibrary
Library           XMLLibrary
Library           TestDataGenerationLibrary
Library           OperatingSystem
# Library           OracleLibrary
Resource          ../../HTTP Common/http_common_resource.txt    # HTTP common resources
Resource          ../SAPI_Types/ewb_types_resource.txt    # Resources for building EWB DTO, e.g. DTO to commit, create experiment, list inbox items.
Resource          ../Cache Entity Service/rest_cache_entity_service_resource.txt    # Cache entity service keywords
Resource          ../Record Service/rest_record_service_resource.txt

*** Variables ***
${ENTITY SERVICE ENDPOINT}    /ewb/services/1.0/entities
${CACHE ENTITY SERVICE ENDPOINT}    /ewb/services/1.0/cache/entities

*** Keywords ***
Add Entity With Custom DTO
    [Arguments]    ${parent_entity_id}    ${sapi_entity_definition}    ${expected_http_status}=200
    [Documentation]    Add a child entity to a parent entity
    ...
    ...    *Arguments*
    ...
    ...    _parent_entity_id_ - the parent entity id
    ...
    ...    _sapi_entity_definition_ - The XML SAPIEntityDefinition
    ...
    ...    _expected_http_status_ - the expected http response status. Default is 200
    ...
    ...    *Return value*
    ...
    ...    A string contianing the entity id of the created entity.
    ...
    ...    *Precondition*
    ...
    ...    None
    ...
    ...    *Example*
    XML HTTP Header Setup
    Set Request Body    ${sapi_entity_definition}
    Next Request May Not Succeed
    POST    ${ENTITY SERVICE ENDPOINT}/${parent_entity_id}/children
    ${entity_id}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${entity_id}    # The newly added entity id

Create Experiment
    [Arguments]    ${parent_entity_id}    ${title}    ${expected_http_status}=200
    [Documentation]    Used to create an experiment with default attribute values.
    ...
    ...    *Arguments*
    ...
    ...    _parent_entity_id_ - the parent entity id.
    ...
    ...    _title_ - the title of the experiment.
    ...
    ...    _expected_http_status_ - the expected http response status. Default is 200
    ...
    ...    *Return value*
    ...
    ...    A string contianing the entity id of the created entity.
    ...
    ...    *Precondition*
    ...
    ...    None
    ...
    ...    *Example*
    ${experiment_dto}=    Build experiment DTO    ${title}    ${title}
    ${experiment_id}=    Add Entity With Custom DTO    ${parent_entity_id}    ${experiment_dto}    ${expected_http_status}
    [Return]    ${experiment_id}    # The created experiment id

Add File Content to Record
    [Arguments]    ${entity_id}    ${file_path}    ${file_name}
    [Documentation]    Used to add file content to an existing record.
    ...
    ...    *Arguments*
    ...    $(entity_id) The entity id of the parent entity.
    ...    ${file_path} The path of the file to load.
    ...    ${file_name} The name of the file.
    ...
    ...    *Return value*
    ...    A string containing the entity id of the new entity.
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Binary HTTP Header Setup
    ${file_attachment}=    Create Form Data Object    ${file_name}    ${file_path}
    POST    ${CACHE ENTITY SERVICE ENDPOINT}/${entity_id}/data?dataType=FILE&fileType=.doc&extractFileName=true    ${file_attachment}
    ${entity_id}=    Get Response Body
    [Return]    ${entity_id}

Get Entity Data
    [Arguments]    ${entity_id}    ${entity_version_id}    ${expected_http_status}=200
    [Documentation]    Retrieves the entity data
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the entity id
    ...
    ...    _entity_version_id_ - the entity version id
    ...
    ...    _expected_http_status_ - the expected http status. Defaulf set to 200
    ...
    ...    *Return value*
    ...
    ...    The entity data bytes
    ...
    ...    *Precondition*
    ...
    ...    The entity must exist.
    ...
    ...    *Example*
    HTTP Header Setup
    Next Request May Not Succeed
    GET    ${ENTITY SERVICE ENDPOINT}/${entity_id}/data?entityVersionId=${entity_version_id}
    ${entity_data}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${entity_data}

Commit Versioned Entity
    [Arguments]    ${entity_id}    ${expected_http_status}=204    ${author_username}=${SERVICES USERNAME}    ${author_password}=${SERVICES PASSWORD}
    [Documentation]    Creates a versioned entity from previously cached data.
    ...
    ...    *Arguments*
    ...    $(entity_id) The entity id of the parent entity.
    ...
    ...    ${entity_id} |
    ...
    ...    ${expected_http_status} optional status code if not 204 for success
    ...
    ...    ${author_username} \ optional username for author header
    ...
    ...    ${author_password} optional password for author header
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    HTTP Header Setup
    ${author_header}=    Base64 Encode String    ${author_username}:${author_password}
    Set Request Header    X-Web-Client-Author-Credentials    Basic ${author_header}
    Set Request Body    { "entityId": "${entity_id}", "entityVersionType": "VERSION", "author": { "reason": "Data Changed" } }
    Next Request May Not Succeed
    POST    ${CACHE ENTITY SERVICE ENDPOINT}/${entity_id}/commit
    Response Status Code Should Equal    ${expected_http_status}

Commit Versioned Entity With Witness
    [Arguments]    ${entity_id}    ${witness_username}    ${witness_password}    ${expected_http_status}=204
    [Documentation]    Creates a versioned entity from previously cached data.
    ...
    ...    *Arguments*
    ...    $(entity_id) The entity id of the parent entity.
    ...
    ...    ${witness_username} The optional witness username
    ...
    ...    ${witness_password} The optional witness password
    ...
    ...    ${expected_http_status} Optional status code if not 204
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    HTTP Header Setup
    ${author_header}=    Base64 Encode String    ${SERVICES USERNAME}:${SERVICES PASSWORD}
    Set Request Header    X-Web-Client-Author-Credentials    Basic ${author_header}
    ${witness_header}=    Base64 Encode String    ${witness_username}:${witness_password}
    Set Request Header    X-Web-Client-Witness-Credentials    BASIC ${witness_header}
    Set Request Body    { "entityId": "${entity_id}", "entityVersionType": "VERSION", "author": { "reason": "Data Changed" }, "witness": { "reason": "Data Changed" } \ }
    Next Request May Not Succeed
    POST    ${CACHE ENTITY SERVICE ENDPOINT}/${entity_id}/commit
    Response Status Code Should Equal    ${expected_http_status}

Commit Versioned Entity No Author
    [Arguments]    ${entity_id}    ${expected_http_status}
    [Documentation]    Attempts to commit and entity but this will fail as no author - used only by test that asserts the HTTP error status
    ...
    ...    *Arguments*
    ...    $(entity_id) The entity id of the parent entity.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    HTTP Header Setup
    Set Request Body    { "entityId": "${entity_id}", "entityVersionType": "VERSION", "author": { "reason": "Data Changed" } }
    Next Request May Not Succeed
    POST    ${CACHE ENTITY SERVICE ENDPOINT}/${entity_id}/commit
    Response Status Code Should Equal    ${expected_http_status}

Commit Versioned Entity No Body
    [Arguments]    ${entity_id}    ${expected_http_status}=204    ${author_username}=${SERVICES USERNAME}    ${author_password}=${SERVICES PASSWORD}
    [Documentation]    Creates a versioned entity from previously cached data.
    ...
    ...    *Arguments*
    ...    $(entity_id) The entity id of the parent entity.
    ...
    ...    ${entity_id} |
    ...
    ...    ${expected_http_status} optional status code if not 204 for success
    ...
    ...    ${author_username} \ optional username for author header
    ...
    ...    ${author_password} optional password for author header
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    HTTP Header Setup
    ${author_header}=    Base64 Encode String    ${author_username}:${author_password}
    Set Request Header    X-Web-Client-Author-Credentials    Basic ${author_header}
    Next Request May Not Succeed
    POST    ${CACHE ENTITY SERVICE ENDPOINT}/${entity_id}/commit
    Response Status Code Should Equal    ${expected_http_status}

Commit Draft Entity
    [Arguments]    ${entity_id}    ${expected_http_status}=204
    [Documentation]    Save a record as DRAFT
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the id of the record to save as DRAFT
    ...
    ...    _expected_http_status_ - the expected HTTP response code. Default value is 204
    ...
    ...    *Return value*
    ...
    ...    None
    ...
    ...    *Precondition*
    ...
    ...    None
    ...
    ...    *Example*
    Save As Draft Entity    ${entity_id}    ${expected_http_status}

Get Page Configuration
    [Arguments]    ${entity_id}
    [Documentation]    Used retrieve a particular entities display pages configuration
    ...
    ...    *Arguments*
    ...    $(entity_id) The entity id
    ...    $(entity_version_id) The entity version
    ...
    ...    *Return value*
    ...    An XML String representing the display pages configuration
    ...
    ...    *Precondition*
    ...    The entity must exist.
    ...
    ...    *Example*
    ${entity_version_id}=    Get Entity Version ID    ${entity_id}
    XML HTTP Header Setup
    GET    ${ENTITY SERVICE ENDPOINT}/${entity_id}/preview/configuration?entityVersionId=${entity_version_id}
    ${page_configuration_xml}=    Get Response Body
    [Return]    ${page_configuration_xml}

Get Entity Version ID
    [Arguments]    ${entity_id}    ${preferCachedCopy}=true
    HTTP Header Setup
    Get    ${ENTITY SERVICE ENDPOINT}/${entity_id}?preferCachedCopy=${preferCachedCopy}&includeVersionInfo=true
    ${Response Body 1}=    Get Response Body
    ${entity_version_id}=    Get Json Value    ${Response Body 1}    /versionInfo/versionId
    ${entity_version_id}=    Get Substring    ${entity_version_id}    1    -1
    Log    value = ${entity_version_id}
    [Return]    ${entity_version_id}

Create Project
    [Arguments]    ${parent_entity_id}    ${title}    ${expected_http_status}=200
    [Documentation]    Used to create a project with default attribute values.
    ...
    ...    *Arguments*
    ...    $(parent_entity_id) The parent entity id.
    ...    $(title) The title of the project.
    ...
    ...    *Return value*
    ...    A string contianing the entity id of the created entity.
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    ${project_dto}=    Build project DTO    ${title}    ${title}
    ${project_id}=    Add Entity With Custom DTO    ${parent_entity_id}    ${project_dto}    ${expected_http_status}
    [Return]    ${project_id}    # The project id

Create Group
    [Arguments]    ${parent_entity_id}    ${name}    ${expected_http_status}=200
    [Documentation]    Used to create a group with default attribute values.
    ...
    ...    *Arguments*
    ...
    ...    _parent_entity_id_ - the parent entity id.
    ...    _name_ - the title of the group.
    ...
    ...    *Return value*
    ...
    ...    A string contianing the entity id of the created entity.
    ...
    ...    *Precondition*
    ...
    ...    None
    ...
    ...    *Example*
    ${group_dto}=    Build group DTO    ${name}
    ${group_id}=    Add Entity With Custom DTO    ${parent_entity_id}    ${group_dto}    ${expected_http_status}
    [Return]    ${group_id}

Delete Entity
    [Arguments]    ${entity_id}    ${reason}=Deleted Test Entity    ${expected_http_status}=204
    [Documentation]    Used to delete an entity "As Intended"
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the entity id
    ...
    ...    _reason_ - the author comments
    ...
    ...    _expected_http_status_ - the expected http response status
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    ...
    ...    Delete Entity | ${experiment_id}
    ...
    ...    Delete Entity | ${experiment_id} | My comment
    ...
    ...    Delete Entity | ${experiment_id} | ${comment} | <userActionInfo xmlns="http://entity.services.ewb.idbs.com" reason="As Intended hello" additionalComment=""/>
    XML HTTP Header Setup
    ${sapi_useraction_info}=    Build Delete Entity DTO    ${reason}
    Set Request Body    ${sapi_useraction_info}
    Next Request May Not Succeed
    PUT    ${ENTITY SERVICE ENDPOINT}/${entity_id}
    Response Status Code Should Equal    ${expected_http_status}

Set Entity Data
    [Arguments]    ${entity_id}    ${file_path}    ${mime_type}    ${data_type}
    [Documentation]    Used to update an entity
    ...
    ...    *Arguments*
    ...    $(entity_id) The entity id.
    ...
    ...    $(entity_version_id) The entity id.
    ...
    ...    $(file_path) The file path including the file name. The file path separator MUST be '\\\\'.
    ...
    ...    ${mime_type} The MIME type, e.g., application/x-idbs-ewbimage
    ...
    ...    ${data_type} The IDBS data type, e.g., FILE or SVG_IMAGE
    ...
    ...    *Return value*
    ...    The updated entity version id
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Binary HTTP Header Setup
    ${file_name}=    String.Fetch From Right    ${file_path}    \\
    ${file_type}=    String.Fetch From Right    ${file_name}    .
    ${file_type}=    Set Variable    .${file_type}
    ${form_data_object}=    Create Form Data Object    ${file_name}    ${file_path}
    POST    ${CACHE ENTITY SERVICE ENDPOINT}/${entity_id}/data?dataType=${data_type}&fileType=${file_type}&extractFileName=false    ${form_data_object}
    ${new_entity_version_id}=    Get Response Body
    Response Status Code Should Equal    200
    [Return]    ${new_entity_version_id}    # The new entity version id

Add DOCUMENT With File Data
    [Arguments]    ${parent_entity_id}    ${file_path}    ${mime_type}    ${data_type}    ${item_type}=Uploaded Document
    [Documentation]    Used to update an entity
    ...
    ...    *Arguments*
    ...
    ...    $(parent_entity_id) The parent (record) entity id.
    ...
    ...    $(file_path) The file path including the file name. The file path separator MUST be '\\'.
    ...
    ...    ${mime_type} The MIME type, e.g., application/x-idbs-ewbimage
    ...
    ...    ${data_type} The IDBS data type, e.g., FILE or SVG_IMAGE
    ...
    ...    *Return value*
    ...    The updated entity version id
    ...
    ...    *Precondition*
    ...    Entity must be locked.
    ...
    ...    *Example*
    XML HTTP Header Setup
    ${file_name}=    String.Fetch From Right    ${file_path}    \\
    ${file_name}=    String.Fetch From Right    ${file_name}    /
    ${file_type}=    String.Fetch From Right    ${file_path}    .
    ${file_type}=    Set Variable    .${file_type}
    ${binary_file}=    Get Binary File    ${file_path}
    ${encoded_file}=    Base64 Encode String    ${binary_file}
    ${request_body}=    Set Variable    <?xml version="1.0" encoding="utf-8"?><entityDefinition xmlns="http://entity.services.ewb.idbs.com"><entityType>DOCUMENT</entityType><entityName>${file_name}</entityName><attributes><attribute><name>registeredids</name><values/></attribute><attribute><name>allowedDataType</name><values/></attribute><attribute><name>link</name><values/></attribute><attribute><name>itemType</name><values><value>${item_type}</value></values></attribute><attribute><name>hasDataExchangeTables</name><values/></attribute><attribute><name>sequentialEdit</name><values/></attribute><attribute><name>publishingState</name><values><value>Unpublished</value></values></attribute><attribute><name>caption</name><values><value>${file_name}</value></values></attribute><attribute><name>copiedFrom</name><values/></attribute><attribute><name>hasLinkedDataFields</name><values/></attribute><attribute><name>allowDropUpdate</name><values><value>false</value></values></attribute><attribute><name>preregisteredids</name><values/></attribute><attribute><name>annotations</name><values/></attribute><attribute><name>pinnedEntity</name><values><value>false</value></values></attribute><attribute><name>allowedFileType</name><values/></attribute></attributes><data><dataInfo mimeType="${mime_type}" fileType="${file_type}" dataType="${data_type}"/><data><dataBinary>${encoded_file}</dataBinary></data></data></entityDefinition>
    Set Request Body    ${request_body}
    POST    ${CACHE ENTITY SERVICE ENDPOINT}/${parent_entity_id}/children
    ${entity_id}=    Get Response Body
    Response Status Code Should Equal    200
    [Return]    ${entity_id}    # The if of the created entity

Add DOCUMENT (and Preview) With File Data
    [Arguments]    ${parent_entity_id}    ${data_file_path}    ${preview_file_path}    ${mime_type}    ${data_type}    ${item_type}=Uploaded Document
    [Documentation]    Used to update an entity
    ...
    ...    *Arguments*
    ...
    ...    $(parent_entity_id) The parent (record) entity id.
    ...
    ...    $(data_file_path) The file path of the data including the file name. The file path separator MUST be '\\'.
    ...
    ...    $(preview_file_path) The file path of the preview including the file name. The file path separator MUST be '\\'.
    ...
    ...    ${mime_type} The MIME type, e.g., application/x-idbs-ewbimage
    ...
    ...    ${data_type} The IDBS data type, e.g., FILE or SVG_IMAGE
    ...
    ...    *Return value*
    ...    The updated entity version id
    ...
    ...    *Precondition*
    ...    Entity must be locked.
    ...
    ...    *Example*
    XML HTTP Header Setup
    ${file_name}=    String.Fetch From Right    ${data_file_path}    \\
    ${file_name}=    String.Fetch From Right    ${file_name}    /
    ${file_type}=    String.Fetch From Right    ${data_file_path}    .
    ${file_type}=    Set Variable    .${file_type}
    ${binary_file}=    Get Binary File    ${data_file_path}
    ${data_encoded_file}=    Base64 Encode String    ${binary_file}
    ${binary_file}=    Get Binary File    ${preview_file_path}
    ${preview_encoded_file}=    Base64 Encode String    ${binary_file}
    ${request_body}=    Set Variable    <?xml version="1.0" encoding="utf-8"?><entityDefinition xmlns="http://entity.services.ewb.idbs.com"><entityType>DOCUMENT</entityType><entityName>${file_name}</entityName><attributes><attribute><name>registeredids</name><values/></attribute><attribute><name>allowedDataType</name><values/></attribute><attribute><name>link</name><values/></attribute><attribute><name>itemType</name><values><value>${item_type}</value></values></attribute><attribute><name>hasDataExchangeTables</name><values/></attribute><attribute><name>sequentialEdit</name><values/></attribute><attribute><name>publishingState</name><values><value>Unpublished</value></values></attribute><attribute><name>caption</name><values><value>${file_name}</value></values></attribute><attribute><name>copiedFrom</name><values/></attribute><attribute><name>hasLinkedDataFields</name><values/></attribute><attribute><name>allowDropUpdate</name><values><value>false</value></values></attribute><attribute><name>preregisteredids</name><values/></attribute><attribute><name>annotations</name><values/></attribute><attribute><name>pinnedEntity</name><values><value>false</value></values></attribute><attribute><name>allowedFileType</name><values/></attribute></attributes><data><dataInfo mimeType="${mime_type}" fileType="${file_type}" dataType="${data_type}"/><data><dataBinary>${data_encoded_file}</dataBinary></data><preview><dataBinary>${preview_encoded_file}</dataBinary></preview></data></entityDefinition>
    Set Request Body    ${request_body}
    POST    ${CACHE ENTITY SERVICE ENDPOINT}/${parent_entity_id}/children
    ${entity_id}=    Get Response Body
    Response Status Code Should Equal    200
    [Return]    ${entity_id}    # The if of the created entity

Add DOCUMENT With String Data
    [Arguments]    ${parent_entity_id}    ${string_data}    ${mime_type}    ${data_type}    ${item_type}=Uploaded Document    ${file_type}=xml
    ...    ${expected_http_status}=200
    [Documentation]    Add an entity of type DOCUMENT whose data consists of a text content
    ...
    ...    *Arguments*
    ...
    ...    _parent_entity_id_ - the parent (record) entity id.
    ...
    ...    _string_data_ - the file path including the file name. The file path separator MUST be '\\'.
    ...
    ...    _mime_type_ - the MIME type, e.g., application/x-idbs-ewbimage
    ...
    ...    _data_type_ - the IDBS data type, e.g., FILE or SVG_IMAGE
    ...
    ...    _item_type_ - the item type, defaults to "Uploaded Document" a string
    ...
    ...    _file_type_ - the file type, defaults to "xml" a string
    ...
    ...    _expected_http_status_ - the expected http status. Defaulf set to 200
    ...
    ...    *Return value*
    ...
    ...    The updated entity version id
    ...
    ...    *Precondition*
    ...
    ...    Entity must be locked.
    ...
    ...    *Example*
    XML HTTP Header Setup
    ${encoded_string}=    Base64 Encode String    ${string_data}
    ${request_body}=    Set Variable    <?xml version="1.0" encoding="utf-8"?><entityDefinition xmlns="http://entity.services.ewb.idbs.com"><entityType>DOCUMENT</entityType><entityName>${TEST_NAME}</entityName><attributes><attribute><name>registeredids</name><values/></attribute><attribute><name>allowedDataType</name><values/></attribute><attribute><name>link</name><values/></attribute><attribute><name>itemType</name><values><value>${item_type}</value></values></attribute><attribute><name>hasDataExchangeTables</name><values/></attribute><attribute><name>sequentialEdit</name><values/></attribute><attribute><name>publishingState</name><values><value>Unpublished</value></values></attribute><attribute><name>caption</name><values><value>${TEST_NAME}</value></values></attribute><attribute><name>copiedFrom</name><values/></attribute><attribute><name>hasLinkedDataFields</name><values/></attribute><attribute><name>allowDropUpdate</name><values><value>false</value></values></attribute><attribute><name>preregisteredids</name><values/></attribute><attribute><name>annotations</name><values/></attribute><attribute><name>pinnedEntity</name><values><value>false</value></values></attribute><attribute><name>allowedFileType</name><values/></attribute></attributes><data><dataInfo mimeType="${mime_type}" fileType="${file_type}" dataType="${data_type}"/><data><dataBinary>${encoded_string}</dataBinary></data></data></entityDefinition>
    Set Request Body    ${request_body}
    Next Request May Not Succeed
    POST    ${CACHE ENTITY SERVICE ENDPOINT}/${parent_entity_id}/children
    ${entity_id}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${entity_id}    # The id of the created entity

Add TEXT_DOCUMENT With File Data
    [Arguments]    ${parent_entity_id}    ${file_path}    ${mime_type}    ${data_type}    ${item_type}=Uploaded Document
    [Documentation]    Used to update an entity
    ...
    ...    *Arguments*
    ...
    ...    $(parent_entity_id) The parent (record) entity id.
    ...
    ...    $(file_path) The file path including the file name. The file path separator MUST be '\\'.
    ...
    ...    ${mime_type} The MIME type, e.g., application/x-idbs-ewbimage
    ...
    ...    ${data_type} The IDBS data type, e.g., FILE or SVG_IMAGE
    ...
    ...    *Return value*
    ...    The updated entity version id
    ...
    ...    *Precondition*
    ...    Entity must be locked.
    ...
    ...    *Example*
    XML HTTP Header Setup
    ${file_name}=    String.Fetch From Right    ${file_path}    \\
    ${file_name}=    String.Fetch From Right    ${file_name}    /
    ${file_type}=    String.Fetch From Right    ${file_path}    .
    ${file_type}=    Set Variable    .${file_type}
    ${binary_file}=    Get Binary File    ${file_path}
    ${encoded_file}=    Base64 Encode String    ${binary_file}
    ${request_body}=    Set Variable    <?xml version="1.0" encoding="utf-8"?><entityDefinition xmlns="http://entity.services.ewb.idbs.com"><entityType>TEXT_DOCUMENT</entityType><entityName>${file_name}</entityName><attributes><attribute><name>registeredids</name><values/></attribute><attribute><name>allowedDataType</name><values/></attribute><attribute><name>link</name><values/></attribute><attribute><name>itemType</name><values><value>${item_type}</value></values></attribute><attribute><name>hasDataExchangeTables</name><values/></attribute><attribute><name>sequentialEdit</name><values/></attribute><attribute><name>publishingState</name><values><value>Unpublished</value></values></attribute><attribute><name>caption</name><values><value>${file_name}</value></values></attribute><attribute><name>copiedFrom</name><values/></attribute><attribute><name>hasLinkedDataFields</name><values/></attribute><attribute><name>allowDropUpdate</name><values><value>false</value></values></attribute><attribute><name>preregisteredids</name><values/></attribute><attribute><name>annotations</name><values/></attribute><attribute><name>pinnedEntity</name><values><value>false</value></values></attribute><attribute><name>allowedFileType</name><values/></attribute></attributes><data><dataInfo mimeType="${mime_type}" fileType="${file_type}" dataType="${data_type}"/><data><dataBinary>${encoded_file}</dataBinary></data></data></entityDefinition>
    Set Request Body    ${request_body}
    POST    ${CACHE ENTITY SERVICE ENDPOINT}/${parent_entity_id}/children
    ${entity_id}=    Get Response Body
    Response Status Code Should Equal    200
    [Return]    ${entity_id}    # The if of the created entity

Add TEXT_COMPONENT With File Data
    [Arguments]    ${parent_entity_id}    ${file_path}    ${mime_type}    ${data_type}    ${item_type}=Uploaded Document
    [Documentation]    Used to update an entity
    ...
    ...    *Arguments*
    ...
    ...    $(parent_entity_id) The parent (record) entity id.
    ...
    ...    $(file_path) The file path including the file name. The file path separator MUST be '\\'.
    ...
    ...    ${mime_type} The MIME type, e.g., application/x-idbs-ewbimage
    ...
    ...    ${data_type} The IDBS data type, e.g., FILE or SVG_IMAGE
    ...
    ...    *Return value*
    ...    The updated entity version id
    ...
    ...    *Precondition*
    ...    Entity must be locked.
    ...
    ...    *Example*
    XML HTTP Header Setup
    ${file_name}=    String.Fetch From Right    ${file_path}    \\
    ${file_name}=    String.Fetch From Right    ${file_name}    /
    ${file_type}=    String.Fetch From Right    ${file_path}    .
    ${file_type}=    Set Variable    .${file_type}
    ${binary_file}=    Get Binary File    ${file_path}
    ${encoded_file}=    Base64 Encode String    ${binary_file}
    ${request_body}=    Set Variable    <?xml version="1.0" encoding="utf-8"?><entityDefinition xmlns="http://entity.services.ewb.idbs.com"><entityType>TEXT_COMPONENT</entityType><entityName>${file_name}</entityName><attributes><attribute><name>name</name><values><value>${file_name}</value></values></attribute></attributes><data><dataInfo mimeType="${mime_type}" fileType="${file_type}" dataType="${data_type}"/><preview><dataBinary>${encoded_file}</dataBinary></preview></data></entityDefinition>
    Set Request Body    ${request_body}
    POST    ${CACHE ENTITY SERVICE ENDPOINT}/${parent_entity_id}/children
    ${entity_id}=    Get Response Body
    Response Status Code Should Equal    200
    [Return]    ${entity_id}    # The if of the created entity

Sign Entity
    [Arguments]    ${record_id}    ${document_id}    ${reason}=Signing Reason    ${additional_comment}=Signing Additional Reason    ${expected_http_status}=204
    [Documentation]    Signs a single document in a record.
    ...
    ...    *Arguments*
    ...
    ...    _record_id_ - the id of he record containing the document to be signed.
    ...
    ...    _document_id_ - the id of he document to be signed.
    ...
    ...    _expected_http_status_ - the expected http status. Defaulf set to 204
    ...
    ...    *Return value*
    ...
    ...    None
    ...
    ...    *Precondition*
    ...
    ...    The document must be versioned
    ...
    ...    *Example*
    XML HTTP Header Setup
    ${author_header}=    Base64 Encode String    ${SERVICES USERNAME}:${SERVICES PASSWORD}
    Set Request Header    X-Web-Client-Author-Credentials    Basic ${author_header}
    ${sign_off_dto}=    Build Sign Off DTO    Actioner    ${reason}    ${additional_comment}    ${document_id}
    Set Request Body    ${sign_off_dto}
    Next Request May Not Succeed
    POST    ${RECORD SERVICE ENDPOINT}/${record_id}/signatures
    Response Status Code Should Equal    ${expected_http_status}
    Connect To Database    ${POOL_USERNAME}    ${POOL_PASSWORD}    ${DB_SERVER}    ${ORACLE_SID}
    execute    update notebook_signatures set notebook_signatures.time_stamp = TO_TIMESTAMP('1-JAN-2013 10:15:00','DD-MON-YY HH24:MI:SS') \ where notebook_signatures.signature_id in (select signature_id from latest_entity_ver_signatures evs, latest_entity_versions ev where ev.entity_id = '${document_id}' and evs.entity_version_id = ev.entity_version_id)
    comment    update notebook_signatures set notebook_signatures.time_stamp = TO_TIMESTAMP('1-JAN-2013 10:15:00','DD-MON-YY HH24:MI:SS') where notebook_signatures.signature_id in \ (select evs.signature_id from entity_ver_signatures evs, entity_versions ev where ev.entity_id = '${document_id}' and evs.entity_version_id = ev.entity_version_id)    #old_nonCDC format
    Disconnect From Database

Add Page Break Entity
    [Arguments]    ${parent_entity_id}
    [Documentation]    Used to add a page break entity to a record
    ...
    ...    *Arguments*
    ...
    ...    $(parent_entity_id) The parent (record) entity id.
    ...
    ...    *Return value*
    ...    The updated entity version id
    ...
    ...    *Precondition*
    ...    Entity must be locked.
    ...
    ...    *Example*
    ${page_break_dto}=    Build Page Break DTO
    ${page_break_id}=    Add Cache Entity With Custom DTO    ${parent_entity_id}    ${page_break_dto}
    [Return]    ${page_break_id}    # The if of the created entity

Add Link Entity
    [Arguments]    ${parent_entity_id}    ${entity_name}    ${link_type}    ${data_text}    ${expected_http_status}=200
    [Documentation]    Used to add a page break entity to a record
    ...
    ...    *Arguments*
    ...
    ...    $(parent_entity_id) The parent (record) entity id.
    ...
    ...    *Return value*
    ...    The updated entity version id
    ...
    ...    *Precondition*
    ...    Entity must be locked.
    ...
    ...    *Example*
    ${link_entity_dto}=    Build Link Entity DTO    ${entity_name}    ${link_type}    ${data_text}
    XML HTTP Header Setup
    Set Request Body    ${link_entity_dto}
    POST    ${CACHE ENTITY SERVICE ENDPOINT}/${parent_entity_id}/children
    ${entity_id}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${entity_id}    # The id of the created entity

Add Web Link Entity
    [Arguments]    ${parent_entity_id}    ${url}    ${expected_http_status}=200
    [Documentation]    Used to add a web link
    ...
    ...    *Arguments*
    ...
    ...    _parent_entity_id_ - the parent (record) entity id.
    ...
    ...    _url_ - the link URL
    ...
    ...    _expected_http_status_ - the expected http status. Defaulf set to 200
    ...
    ...    *Return value*
    ...
    ...    The entity id for the created web link
    ...
    ...    *Precondition*
    ...
    ...    Parent entity must be locked.
    ...
    ...    *Example*
    ${web_link_dto}=    Build Web Link DTO    Web Link    ${url}
    ${entity_id}=    Add Cache Entity With Custom DTO    ${parent_entity_id}    ${web_link_dto}    ${expected_http_status}
    [Return]    ${entity_id}    # The id of the created entity

Add Comment
    [Arguments]    ${entity_id}    ${entity_version_id}    ${comment}    ${expected_http_status}=200
    [Documentation]    Used to add a comment to an entity
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the entity to add the comment to
    ...
    ...    _entity_version_id_ - the entity version id
    ...
    ...    _comment_ - the comment to add
    ...
    ...    *Return value*
    ...
    ...    The comment id
    ...
    ...    *Example*
    XML HTTP Header Setup
    Set Request Body    ${comment}
    Next Request May Not Succeed
    POST    ${ENTITY SERVICE ENDPOINT}/${entity_id}/comments?entityVersionId=${entity_version_id}
    ${response}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    @{comment_id_list}=    Run Keyword If    ${expected_http_status}==200    Get Element Value    ${response}    http://entity.services.ewb.idbs.com    id
    ${comment_id}=    Set Variable If    ${expected_http_status}==200    @{comment_id_list}[0]
    [Return]    ${comment_id}    # The id of the comment

Update Comment
    [Arguments]    ${entity_id}    ${entity_version_id}    ${comment_id}    ${comment}    ${expected_http_status}=204
    [Documentation]    Used to update a comment
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the entity to update the comment for
    ...
    ...    _entity_version_id_ - the entity version id
    ...
    ...    _comment_id_ - the id of comment to update
    ...
    ...    _comment_ - the updated comment text
    ...
    ...    _expected_http_status_ - the expected http status. Defaulf set to 204
    ...
    ...    *Return value*
    ...
    ...    None
    ...
    ...    *Example*
    XML HTTP Header Setup
    Set Request Body    ${comment}
    Next Request May Not Succeed
    PUT    ${ENTITY SERVICE ENDPOINT}/${entity_id}/comments/${comment_id}?entityVersionId=${entity_version_id}
    Response Status Code Should Equal    ${expected_http_status}

Delete Comment
    [Arguments]    ${entity_id}    ${entity_version_id}    ${comment_id}    ${expected_http_status}=204
    [Documentation]    Deletes an entity comment
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the entity to update the comment for
    ...
    ...    _entity_version_id_ - the entity version id
    ...
    ...    _comment_id_ - the id of comment to update
    ...
    ...    _expected_http_status_ - the expected http status. Defaulf set to 204
    ...
    ...    *Return value*
    ...
    ...    None
    ...
    ...    *Example*
    XML HTTP Header Setup
    Next Request May Not Succeed
    DELETE    ${ENTITY SERVICE ENDPOINT}/${entity_id}/comments/${comment_id}?entityVersionId=${entity_version_id}
    Response Status Code Should Equal    ${expected_http_status}

Add Comment Reply
    [Arguments]    ${entity_id}    ${entity_version_id}    ${comment_id}    ${reply_comment}    ${expected_http_status}=200
    [Documentation]    Adda a reply to an entity comment
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the entity to add the reply to
    ...
    ...    _entity_version_id_ - the entity to add the reply to
    ...
    ...    _comment_id_ - the id of comment to update
    ...
    ...    _reply_comment_ - the updated comment text
    ...
    ...    _expected_http_status_ - the expected http status. Defaulf set to 204
    ...
    ...    *Return value*
    ...
    ...    The comment reply id
    ...
    ...    *Example*
    XML HTTP Header Setup
    Next Request May Not Succeed
    Set Request Body    ${reply_comment}
    POST    ${ENTITY SERVICE ENDPOINT}/${entity_id}/comments/${comment_id}/replies?entityVersionId=${entity_version_id}
    ${response}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    @{comment_id_list}=    Run Keyword If    ${expected_http_status}==200    Get Element Value    ${response}    http://entity.services.ewb.idbs.com    id
    ${comment_id}=    Set Variable If    ${expected_http_status}==200    @{comment_id_list}[0]
    [Return]    ${comment_id}    # The id of the reply

Add Tag
    [Arguments]    ${entity_id}    ${entity_version_id}    ${tag}    ${expected_http_status}=200
    [Documentation]    Used to add a tag to an entity
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the entity to add the tag to
    ...
    ...    _entity_version_id_ - the entity version id
    ...
    ...    _tag_ - the tag to add
    ...
    ...    _expected_http_status_ - the expected http status. Defaulf set to 204
    ...
    ...    *Return value*
    ...
    ...    The id of the tag
    ...
    ...    *Example*
    XML HTTP Header Setup
    Set Request Body    ${tag}
    Next Request May Not Succeed
    POST    ${ENTITY SERVICE ENDPOINT}/${entity_id}/tags?entityVersionId=${entity_version_id}
    ${response}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    @{tag_id_list}=    Run Keyword If    ${expected_http_status}==200    Get Element Value    ${response}    http://entity.services.ewb.idbs.com    tagId
    ${tag_id}=    Set Variable If    ${expected_http_status}==200    @{tag_id_list}[0]
    [Return]    ${tag_id}    # The id of the tag

Delete Tag
    [Arguments]    ${entity_id}    ${entity_version_id}    ${tag_id}    ${expected_http_status}=204
    [Documentation]    Used to remove a tag from an entity
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the entity to add the tag to
    ...
    ...    _entity_version_id_ - the entity version id
    ...
    ...    _tag_id_ - the id of the tag to delete
    ...
    ...    _expected_http_status_ - the expected http status. Default set to 204
    ...
    ...    *Return value*
    ...
    ...    None
    ...
    ...    *Example*
    XML HTTP Header Setup
    Next Request May Not Succeed
    DELETE    ${ENTITY SERVICE ENDPOINT}/${entity_id}/tags/${tag_id}?entityVersionId=${entity_version_id}
    Response Status Code Should Equal    ${expected_http_status}

Sign Document
    [Arguments]    ${entity_id}    ${reason}    ${additional_comment}    ${role}    ${user_name}=${SERVICES USERNAME}    ${user_password}=${SERVICES PASSWORD}
    ...    ${expected_http_status}=204
    [Documentation]    Digitally signs the given entity. Note this is used for PDF signatures and not EWB signatures
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the id of the entity to sign
    ...
    ...    _reason_ - the usually catalogue mapped comment
    ...
    ...    _additional_comment_ - some other comment
    ...
    ...    _role_ - the role of the user e.g. reviewer
    ...
    ...    *Return value*
    ...
    ...    Nothing
    ...
    ...    *Precondition*
    ...
    ...    The PDF must exist.
    ...
    ...    *Example*
    HTTP Header Setup
    Set Basic Auth    ${user_name}    ${user_password}
    ${author_header}=    Base64 Encode String    ${user_name}:${user_password}
    Set Request Header    X-Web-Client-Author-Credentials    Basic ${author_header}
    Next Request May Not Succeed
    POST    ${ENTITY SERVICE ENDPOINT}/${entity_id}/signatures?reason=${reason}&additionalcomment=${additional_comment}&role=${role}
    Response Status Code Should Equal    ${expected_http_status}

Add SPREADSHEET_DOCUMENT (and Preview) With File Data
    [Arguments]    ${parent_entity_id}    ${data_file_path}    ${preview_file_path}    ${mime_type}    ${data_type}    ${item_type}=Uploaded Document
    [Documentation]    Used to update an entity
    ...
    ...    *Arguments*
    ...
    ...    $(parent_entity_id) The parent (record) entity id.
    ...
    ...    $(data_file_path) The file path of the data including the file name. The file path separator MUST be '\\'.
    ...
    ...    $(preview_file_path) The file path of the preview including the file name. The file path separator MUST be '\\'.
    ...
    ...    ${mime_type} The MIME type, e.g., application/x-idbs-ewbimage
    ...
    ...    ${data_type} The IDBS data type, e.g., FILE or SVG_IMAGE
    ...
    ...    *Return value*
    ...    The updated entity version id
    ...
    ...    *Precondition*
    ...    Entity must be locked.
    ...
    ...    *Example*
    XML HTTP Header Setup
    ${file_name}=    String.Fetch From Right    ${data_file_path}    \\
    ${file_name}=    String.Fetch From Right    ${file_name}    /
    ${file_type}=    String.Fetch From Right    ${data_file_path}    .
    ${file_type}=    Set Variable    .${file_type}
    ${binary_file}=    Get Binary File    ${data_file_path}
    ${data_encoded_file}=    Base64 Encode String    ${binary_file}
    ${binary_file}=    Get Binary File    ${preview_file_path}
    ${preview_encoded_file}=    Base64 Encode String    ${binary_file}
    ${request_body}=    Set Variable    <?xml version="1.0" encoding="utf-8"?><entityDefinition xmlns="http://entity.services.ewb.idbs.com"><entityType>SPREADSHEET_DOCUMENT</entityType><entityName>${file_name}</entityName><attributes><attribute><name>registeredids</name><values/></attribute><attribute><name>allowedDataType</name><values/></attribute><attribute><name>link</name><values/></attribute><attribute><name>itemType</name><values><value>${item_type}</value></values></attribute><attribute><name>hasDataExchangeTables</name><values/></attribute><attribute><name>sequentialEdit</name><values/></attribute><attribute><name>publishingState</name><values><value>Unpublished</value></values></attribute><attribute><name>caption</name><values><value>${file_name}</value></values></attribute><attribute><name>copiedFrom</name><values/></attribute><attribute><name>hasLinkedDataFields</name><values/></attribute><attribute><name>allowDropUpdate</name><values><value>false</value></values></attribute><attribute><name>preregisteredids</name><values/></attribute><attribute><name>annotations</name><values/></attribute><attribute><name>pinnedEntity</name><values><value>false</value></values></attribute><attribute><name>allowedFileType</name><values/></attribute></attributes><data><dataInfo mimeType="${mime_type}" fileType="${file_type}" dataType="${data_type}"/><data><dataBinary>${data_encoded_file}</dataBinary></data><preview><dataBinary>${preview_encoded_file}</dataBinary></preview></data></entityDefinition>
    Set Request Body    ${request_body}
    POST    ${CACHE ENTITY SERVICE ENDPOINT}/${parent_entity_id}/children
    ${entity_id}=    Get Response Body
    Response Status Code Should Equal    200
    [Return]    ${entity_id}    # The id of the created entity

Add SPREADSHEET_DOCUMENT (and Tidy)
    [Arguments]    ${parent_entity_id}    ${data_file_path}    ${data_encoded}    ${mime_type}    ${data_type}    ${item_type}=Uploaded Document
    [Documentation]    Used to update an entity
    ...
    ...    *Arguments*
    ...
    ...    $(parent_entity_id) The parent (record) entity id.
    ...
    ...    $(data_file_path) The file path of the data including the file name. The file path separator MUST be '\\'.
    ...
    ...    ${mime_type} The MIME type, e.g., application/x-idbs-ewbimage
    ...
    ...    ${data_type} The IDBS data type, e.g., FILE or SVG_IMAGE
    ...
    ...    *Return value*
    ...    The updated entity version id
    ...
    ...    *Precondition*
    ...    Entity must be locked.
    ...
    ...    *Example*
    XML HTTP Header Setup
    ${file_name}=    String.Fetch From Right    ${data_file_path}    \\
    ${file_name}=    String.Fetch From Right    ${file_name}    /
    ${file_type}=    String.Fetch From Right    ${data_file_path}    .
    ${file_type}=    Set Variable    .${file_type}
    ${request_body}=    Set Variable    <?xml version="1.0" encoding="utf-8"?><entityDefinition xmlns="http://entity.services.ewb.idbs.com"><entityType>SPREADSHEET_DOCUMENT</entityType><entityName>${file_name}</entityName><attributes><attribute><name>registeredids</name><values/></attribute><attribute><name>allowedDataType</name><values/></attribute><attribute><name>link</name><values/></attribute><attribute><name>itemType</name><values><value>${item_type}</value></values></attribute><attribute><name>hasDataExchangeTables</name><values/></attribute><attribute><name>sequentialEdit</name><values/></attribute><attribute><name>publishingState</name><values><value>Unpublished</value></values></attribute><attribute><name>caption</name><values><value>${file_name}</value></values></attribute><attribute><name>copiedFrom</name><values/></attribute><attribute><name>hasLinkedDataFields</name><values/></attribute><attribute><name>allowDropUpdate</name><values><value>false</value></values></attribute><attribute><name>preregisteredids</name><values/></attribute><attribute><name>annotations</name><values/></attribute><attribute><name>pinnedEntity</name><values><value>false</value></values></attribute><attribute><name>allowedFileType</name><values/></attribute></attributes><data><dataInfo mimeType="${mime_type}" fileType="${file_type}" dataType="${data_type}"/><data><dataBinary>${data_encoded}</dataBinary></data><preview/></data></entityDefinition>
    Set Request Body    ${request_body}
    POST    ${CACHE ENTITY SERVICE ENDPOINT}/${parent_entity_id}/spreadsheets
    ${entity_id}=    Get Response Body
    Response Status Code Should Equal    200
    [Return]    ${entity_id}    # The id of the created entity

Add ANALYTICDATA (and Preview) With File Data
    [Arguments]    ${parent_entity_id}    ${data_file_path}    ${preview_file_path}    ${mime_type}    ${data_type}    ${item_type}=Uploaded Document
    [Documentation]    Used to update an entity
    ...
    ...    *Arguments*
    ...
    ...    $(parent_entity_id) The parent (record) entity id.
    ...
    ...    $(data_file_path) The file path of the data including the file name. The file path separator MUST be '\\'.
    ...
    ...    $(preview_file_path) The file path of the preview including the file name. The file path separator MUST be '\\'.
    ...
    ...    ${mime_type} The MIME type, e.g., application/x-idbs-ewbimage
    ...
    ...    ${data_type} The IDBS data type, e.g., FILE or SVG_IMAGE
    ...
    ...    *Return value*
    ...    The updated entity version id
    ...
    ...    *Precondition*
    ...    Entity must be locked.
    ...
    ...    *Example*
    XML HTTP Header Setup
    ${file_name}=    String.Fetch From Right    ${data_file_path}    \\
    ${file_name}=    String.Fetch From Right    ${file_name}    /
    ${file_type}=    String.Fetch From Right    ${data_file_path}    .
    ${file_type}=    Set Variable    .${file_type}
    ${binary_file}=    Get Binary File    ${data_file_path}
    ${data_encoded_file}=    Base64 Encode String    ${binary_file}
    ${binary_file}=    Get Binary File    ${preview_file_path}
    ${preview_encoded_file}=    Base64 Encode String    ${binary_file}
    ${request_body}=    Set Variable    <?xml version="1.0" encoding="utf-8"?><entityDefinition xmlns="http://entity.services.ewb.idbs.com"><entityType>DOCUMENT</entityType><entityName>${file_name}</entityName><attributes><attribute><name>registeredids</name><values/></attribute><attribute><name>allowedDataType</name><values/></attribute><attribute><name>link</name><values/></attribute><attribute><name>itemType</name><values><value>${item_type}</value></values></attribute><attribute><name>hasDataExchangeTables</name><values/></attribute><attribute><name>sequentialEdit</name><values/></attribute><attribute><name>publishingState</name><values><value>Unpublished</value></values></attribute><attribute><name>caption</name><values><value>${file_name}</value></values></attribute><attribute><name>copiedFrom</name><values/></attribute><attribute><name>hasLinkedDataFields</name><values/></attribute><attribute><name>allowDropUpdate</name><values><value>false</value></values></attribute><attribute><name>preregisteredids</name><values/></attribute><attribute><name>annotations</name><values/></attribute><attribute><name>pinnedEntity</name><values><value>false</value></values></attribute><attribute><name>allowedFileType</name><values/></attribute></attributes><data><dataInfo mimeType="${mime_type}" fileType="${file_type}" dataType="${data_type}"/><data><dataBinary>${data_encoded_file}</dataBinary></data><preview><dataBinary>${preview_encoded_file}</dataBinary></preview></data></entityDefinition>
    Set Request Body    ${request_body}
    POST    ${CACHE ENTITY SERVICE ENDPOINT}/${parent_entity_id}/children
    ${entity_id}=    Get Response Body
    Response Status Code Should Equal    200
    [Return]    ${entity_id}    # The if of the created entity

Add CHEMISTRY_DOCUMENT (and Preview) With File Data
    [Arguments]    ${parent_entity_id}    ${data_file_path}    ${preview_file_path}    ${mime_type}    ${data_type}    ${item_type}=Uploaded Document
    [Documentation]    Used to update an entity
    ...
    ...    *Arguments*
    ...
    ...    $(parent_entity_id) The parent (record) entity id.
    ...
    ...    $(data_file_path) The file path of the data including the file name. The file path separator MUST be '\\'.
    ...
    ...    $(preview_file_path) The file path of the preview including the file name. The file path separator MUST be '\\'.
    ...
    ...    ${mime_type} The MIME type, e.g., application/x-idbs-ewbimage
    ...
    ...    ${data_type} The IDBS data type, e.g., FILE or SVG_IMAGE
    ...
    ...    *Return value*
    ...    The updated entity version id
    ...
    ...    *Precondition*
    ...    Entity must be locked.
    ...
    ...    *Example*
    XML HTTP Header Setup
    ${file_name}=    String.Fetch From Right    ${data_file_path}    \\
    ${file_name}=    String.Fetch From Right    ${file_name}    /
    ${file_type}=    String.Fetch From Right    ${data_file_path}    .
    ${file_type}=    Set Variable    .${file_type}
    ${binary_file}=    Get Binary File    ${data_file_path}
    ${data_encoded_file}=    Base64 Encode String    ${binary_file}
    ${binary_file}=    Get Binary File    ${preview_file_path}
    ${preview_encoded_file}=    Base64 Encode String    ${binary_file}
    ${request_body}=    Set Variable    <?xml version="1.0" encoding="utf-8"?><entityDefinition xmlns="http://entity.services.ewb.idbs.com"><entityType>CHEMISTRY_DOCUMENT</entityType><entityName>${file_name}</entityName><attributes><attribute><name>registeredids</name><values/></attribute><attribute><name>allowedDataType</name><values/></attribute><attribute><name>link</name><values/></attribute><attribute><name>itemType</name><values><value>${item_type}</value></values></attribute><attribute><name>hasDataExchangeTables</name><values/></attribute><attribute><name>sequentialEdit</name><values/></attribute><attribute><name>publishingState</name><values><value>Unpublished</value></values></attribute><attribute><name>caption</name><values><value>${file_name}</value></values></attribute><attribute><name>copiedFrom</name><values/></attribute><attribute><name>hasLinkedDataFields</name><values/></attribute><attribute><name>allowDropUpdate</name><values><value>false</value></values></attribute><attribute><name>preregisteredids</name><values/></attribute><attribute><name>annotations</name><values/></attribute><attribute><name>pinnedEntity</name><values><value>false</value></values></attribute><attribute><name>allowedFileType</name><values/></attribute></attributes><data><dataInfo mimeType="${mime_type}" fileType="${file_type}" dataType="${data_type}"/><data><dataBinary>${data_encoded_file}</dataBinary></data><preview><dataBinary>${preview_encoded_file}</dataBinary></preview></data></entityDefinition>
    Set Request Body    ${request_body}
    POST    ${CACHE ENTITY SERVICE ENDPOINT}/${parent_entity_id}/children
    ${entity_id}=    Get Response Body
    Response Status Code Should Equal    200
    [Return]    ${entity_id}    # The if of the created entity

Get Comments
    [Arguments]    ${entity_id}    ${entity_version_id}    ${expected_http_status}=200
    [Documentation]    GET : /services/1.0/entities/{entityId}/comments
    ...
    ...    Used to retrieve a comment
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id} The id of the entity that has the comment
    ...
    ...    ${entity_version_id} The version of the entity that has the comment
    ...
    ...    *Return value*
    ...    $(response) Response body containing the comment text as a SAPIEntityCommentSequence
    ...
    ...    *Precondition*
    ...    The entity must exist.
    ...
    ...    *Example*
    XML HTTP Header Setup
    Next Request May Not Succeed
    GET    ${ENTITY SERVICE ENDPOINT}/${entity_id}/comments?entityVersionId=${entity_version_id}
    ${sapi_entity_comment_sequence}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${sapi_entity_comment_sequence}

Update Entity
    [Arguments]    ${entity_id}    ${entity_version_id}    ${versioned_save}    ${sapi_entity_definition}    ${comment}=Updated    ${additional_comment}=Updated
    ...    ${expected_http_status}=204
    [Documentation]    POST : /services/1.0/entities/{entityId}
    ...
    ...    Updates the information for a specific entity. The entity may be versioned or not (this is defined in the flexible hierarchy)
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the id of the entity that has the comment
    ...
    ...    _entity_version_id_ - the version of the entity that has the comment
    ...
    ...    _versioned_save_ - the boolean value that specifies whether the update is for a version save
    ...
    ...    _ sapi_entity_definition_ - the SAPIEntityDefinition DTO
    ...
    ...    _comment_ - comment for the update (only required if version save is true)
    ...
    ...    _additional_comment_ - additional comment for the update (only required if version save is true)
    ...
    ...    *Return value*
    ...
    ...    *Precondition*
    ...
    ...    The entity must exist.
    ...
    ...    *Example*
    XML HTTP Header Setup
    Set Request Body    ${sapi_entity_definition}
    Next Request May Not Succeed
    POST    ${ENTITY SERVICE ENDPOINT}/${entity_id}?entityVersionId=${entity_version_id}&versionedSave=${versioned_save}&comment=${comment}&additionalComment=${additional_comment}
    Response Status Code Should Equal    ${expected_http_status}

Get Allowed Child Entity Types
    [Arguments]    ${entity_id}    ${http_response_code}=200
    [Documentation]    GET : /services/1.0/entities/{entityid}/allowedTypes
    ...
    ...    Retrieves all the valid entity type names for children of the specified entity. This information is gleaned from the flexible hierarchy.
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id} The id of the entity
    ...
    ...    *Return value*
    ...
    ...    $(child_entities) A list of valid child entity type names as a SAPIEntityTypeNameSequence
    ...
    ...    *Precondition*
    ...    The entity must exist.
    ...
    ...    *Example*
    XML HTTP Header Setup
    Next Request May Not Succeed
    GET    ${ENTITY SERVICE ENDPOINT}/${entity_id}/allowedTypes
    ${child_entities}=    Get Response Body
    Response Status Code Should Equal    ${http_response_code}
    [Return]    ${child_entities}    # A list of valid child entity type names as a SAPIEntityTypeNameSequence

Get Attributes
    [Arguments]    ${entity_id}    ${entity_version_id}    ${expected_http_status}=200
    [Documentation]    GET : services/1.0/entities/{entityId}/attributes
    ...
    ...    Used to retrieve the attributes for a given entity
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id} The id of the entity that has the comment
    ...
    ...    ${entity_version_id} The version of the entity that has the comment
    ...
    ...    *Return value*
    ...
    ...    $(attributes) Response body containing the attribute(s) as a SAPIAttributeSequence
    ...
    ...    *Precondition*
    ...    The entity must exist.
    ...
    ...    *Example*
    XML HTTP Header Setup
    Next Request May Not Succeed
    GET    ${ENTITY SERVICE ENDPOINT}/${entity_id}/attributes?entityVersionId=${entity_version_id}
    ${attributes}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${attributes}    # the SAPIAttributeSequence class instance containing the entity attributes

Move Entity
    [Arguments]    ${entity_id}    ${parent_entity_id}    ${reason}    ${comment}    ${expected_http_status}=204
    [Documentation]    PUT : services/1.0/entities/{entityId}/parent
    ...
    ...    Moves an entity to a new parent
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the id of the entity to move
    ...
    ...    _entity_version_id_ - the new parent entity id
    ...
    ...    _reason_ - the reason for the move
    ...
    ...    _comment_ - any further comments
    ...
    ...    _expected_http_status_ - the expected http status. Defaulf set to 204
    ...
    ...    *Return value*
    ...
    ...    None
    ...
    ...    *Precondition*
    ...
    ...    The entity must exist.
    ...
    ...    The parent entity must exist.
    ...
    ...    *Example*
    XML HTTP Header Setup
    Set Request Body    <?xml version="1.0" encoding="UTF-8"?> <userActionInfo xmlns="http://entity.services.ewb.idbs.com" reason="${reason}" additionalComment="${comment}" />
    Next Request May Not Succeed
    PUT    ${ENTITY SERVICE ENDPOINT}/${entity_id}/parent?parentEntityId=${parent_entity_id}
    Response Status Code Should Equal    ${expected_http_status}

Move Entity - No Authentication
    [Arguments]    ${entity_id}    ${parent_entity_id}    ${expected_http_status}=204
    [Documentation]    PUT : services/1.0/entities/{entityId}/parent
    ...
    ...    Used to moves an entity to a new parent.
    ...
    ...    As Move Entity but does not require a reason/comment
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id} The id of the entity to move
    ...
    ...    ${parent_entity_id} The new parent entity id
    ...
    ...    *Return value*
    ...
    ...
    ...    *Precondition*
    ...
    ...    The entity must exist.
    ...    The parent entity must exist.
    ...
    ...
    ...
    ...    *Example*
    XML HTTP Header Setup
    Next Request May Not Succeed
    PUT    ${ENTITY SERVICE ENDPOINT}/${entity_id}/parent?parentEntityId=${parent_entity_id}
    Response Status Code Should Equal    ${expected_http_status}

Get Signature Image
    [Arguments]    ${entity_id}    ${entity_version_id}    ${signature_id}    ${expected_http_status}=200
    [Documentation]    GET : /{entityId}/signatures/{signatureId}/image
    ...
    ...    Retrieves the signature image associated associate with a specific entity versions signature.
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the id of the entity that has the comment
    ...
    ...    _entity_version_id_ - the version of the entity that has the comment
    ...
    ...    _signatureId_ - the string representing the signature id
    ...
    ...    *Return value*
    ...
    ...    _response_ - the signature image as a javax.ws.rs.core.Response
    ...
    ...    *Precondition*
    ...
    ...    The entity must exist.
    ...
    ...    *Example*
    XML HTTP Header Setup
    Set Request Header    Accept    image/png
    Next Request May Not Succeed
    GET    ${ENTITY SERVICE ENDPOINT}/${entity_id}/signatures/${signature_id}/image?entityVersionId=${entity_version_id}
    ${response}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${response}    # The signature image

Revoke Signature
    [Arguments]    ${entity_id}    ${reason}    ${comment}    ${expected_http_status}=204
    [Documentation]    POST : /{entityId}/signatures/revoked
    ...
    ...    Revokes all the signatures associated with a specific entity version. The revocation can only be carried out by the user logged in.
    ...
    ...    The signature is not actually removed, it only sets for that entity a property in the user settings revoked = true
    ...    needs to be in conjunction with a workflow resave as version
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the id of the entity that has the comment
    ...
    ...    _reason_ - the reason for the signature revocation
    ...
    ...    _additionalComment_ - the additional comment from the revocation (this is optional.)
    ...
    ...    *Return value*
    ...
    ...    None
    ...
    ...    *Precondition*
    ...
    ...    The entity must exist.
    ...
    ...    *Example*
    XML HTTP Header Setup
    Next Request May Not Succeed
    POST    ${ENTITY SERVICE ENDPOINT}/${entity_id}/signatures/revoked?reason=${reason}&additionalComment=${comment}
    Response Status Code Should Equal    ${expected_http_status}

Find Entities by Tag
    [Arguments]    ${tag_value}    ${start}=1    ${limit}=10    ${include_attributes}=false    ${include_version_info}=false    ${include_signatures}=false
    ...    ${include_path}=false    ${include_data_info}=false    ${include_children}=false    ${include_tags}=false    ${include_permissions}=false    ${include_comments}=false
    ...    ${expected_http_status}=200
    [Documentation]    GET : /services/1.0/entities/bytag
    ...
    ...    Retrieves all the entities relating to a specific tag
    ...
    ...    *Arguments*
    ...
    ...    _tag_value_ - the tag value
    ...
    ...    _start_ - the start position in the cursor. Default is 1
    ...
    ...    _limit_ - the maximum number of entities to be returned. Default is 10
    ...
    ...    _include_attributes_ - the boolean, <code>true</code> to include attributes
    ...
    ...    _include_version_info_ - the boolean, <code>true</code> to include version info
    ...
    ...    _include_signatures_ - the boolean, <code>true</code> to include signatures
    ...
    ...    _include_path_ - the boolean, <code>true</code> to include path
    ...
    ...    _include_data_info_ - the boolean, <code>true</code> to include data info
    ...
    ...    _include_children_ - the boolean, <code>true</code> to include children
    ...
    ...    _include_tags_ - the boolean, <code>true</code> to include tags
    ...
    ...    _include_permissions_ - the boolean, <code>true</code> to include permissions
    ...
    ...    _include_comments_ - the boolean, <code>true</code> to include comments
    ...
    ...    *Return value*
    ...
    ...    A literal XML of SAPIEntityDtoSequence
    ...
    ...    *Precondition*
    ...
    ...    The entity must exist.
    ...
    ...    *Example*
    XML HTTP Header Setup
    Next Request May Not Succeed
    GET    ${ENTITY SERVICE ENDPOINT}/bytag/?tagValue=${tag_value}&?start=${start}&limit=${limit}&includeAttributes=${include_attributes}&includeVersionInfo=${include_version_info}&includeSignatures=${include_signatures}&includePath=${include_path}&includeDataInfo=${include_data_info}&includeChildren=${include_children}&includePermissions=${include_permissions}&includeTags=${include_tags}&includeComments=${include_comments}
    ${sapi_entity_dto_sequence}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${sapi_entity_dto_sequence}    # the litera XML of SAPIEntityDTOSequence

Find Undeletable Signed Entity Paths
    [Arguments]    ${entity_id}    ${expected_http_status}=200
    [Documentation]    GET : /services/1.0/entities/{entityId}/undeletablechildren
    ...
    ...    Finds entities in the sub tree that are undeletable due to signatures that the current user does not have the necessary override permission to remove.
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id} The id of the entity that has the comment
    ...
    ...
    ...    *Return value*
    ...
    ...    ${paths} The resulting response contains a list of paths to these entities as a SAPIPathElementSequenceSequence
    ...
    ...    *Precondition*
    ...
    ...    The entity must exist.
    ...
    ...    *Example*
    XML HTTP Header Setup
    Next Request May Not Succeed
    GET    ${ENTITY SERVICE ENDPOINT}/${entity_id}/undeletablechildren
    ${paths}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${paths}    # A list of the paths for any locked entities as a SAPIPathElementSequenceSequence

Get Tags
    [Arguments]    ${entity_id}    ${entity_version_id}    ${expected_http_status}=200
    [Documentation]    GET : /services/1.0/entities/{entity_id}/tags
    ...
    ...    Get all tags of an entity item
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the entity to add the tag to
    ...
    ...    _entity_version_id_ - the entity version id
    ...
    ...    *Return value*
    ...
    ...    Response body includes a SAPIEntityTagSequence class instance containing the entity tags
    ...
    ...    *Precondition*
    ...
    ...    The entity must exist.
    ...
    ...    *Example*
    XML HTTP Header Setup
    Next Request May Not Succeed
    GET    ${ENTITY SERVICE ENDPOINT}/${entity_id}/tags?entityVersionId=${entity_version_id}
    ${sapi_entity_tag_sequence}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${sapi_entity_tag_sequence}    # Response body includes a SAPIEntityTagSequence class instance containing the entity tags

Get Ancestry
    [Arguments]    ${entity_id}    ${expected_http_status}=200
    [Documentation]    GET : /services/1.0/entities/{entityId}/ancestry
    ...
    ...    Gets the ids of the ancestors of the given entity.
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the id of the entity that has the comment
    ...
    ...    *Return value*
    ...
    ...    A literal XML of an SAPIIdSequence instance
    ...
    ...    note: The order of the ids returned will be such that the first element of the array is the most distant ancestor, and subsequently in order of ancestry up to the last element, which will be id of the given entity.
    ...
    ...    *Precondition*
    ...
    ...    The entity must exist.
    ...
    ...    *Example*
    XML HTTP Header Setup
    Next Request May Not Succeed
    GET    ${ENTITY SERVICE ENDPOINT}/${entity_id}/ancestry
    ${sapi_id_sequence}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${sapi_id_sequence}    # A literal XML of an SAPIIdSequence instance

Get Transformed Entity Data
    [Arguments]    ${entity_id}    ${entity_version_id}    ${expected_http_status}=200
    [Documentation]    GET : /services/1.0/entities/{entityId}/transformation/data
    ...
    ...    Gets transformed data for a specific entity version and transformation type.
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id} The id of the entity that has the comment
    ...
    ...    ${entity_version_id} The version of the entity that has the comment
    ...
    ...    ${transformation_type} The transformation type
    ...
    ...    *Return value*
    ...
    ...    $(response) Response body containing the requested transformed data as a javax.ws.rs.core.Response
    ...
    ...    *Precondition*
    ...
    ...    The entity must exist.
    ...
    ...    *Example*
    XML HTTP Header Setup
    Set Request Header    Accept    application/octet-stream
    Next Request May Not Succeed
    GET    ${ENTITY SERVICE ENDPOINT}/${entity_id}/transformation/data?entityVersionId=${entity_version_id}&transformationType=${transformation_type}
    ${response}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${response}    # Response body containing the requested transformed data

Get Transformed Entity Info
    [Arguments]    ${entity_id}    ${entity_version_id}    ${expected_http_status}=200
    [Documentation]    GET : /services/1.0/entities/{entityId}/transformation/info
    ...
    ...    Gets transformed data information for a specific entity version and transformation type.
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id} The id of the entity that has the comment
    ...
    ...    ${entity_version_id} The version of the entity that has the comment
    ...
    ...    ${transformation_type} The transformation type
    ...
    ...    *Return value*
    ...
    ...    $(response) Response body containing the requested transformed data information as a SAPIEntityTransformationInfo
    ...
    ...    *Precondition*
    ...
    ...    The entity must exist.
    ...
    ...    *Example*
    XML HTTP Header Setup
    Next Request May Not Succeed
    GET    ${ENTITY SERVICE ENDPOINT}/${entity_id}/transformation/info?entityVersionId=${entity_version_id}&transformationType=${transformation_type}
    ${response}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${response}    # Response body containing the requested transformed data information as a SAPIEntityTransformationInfo

Validate Entity
    [Arguments]    ${sapi_entity_definition}    ${check_status_allowable}=false    ${expected_http_status}=200
    [Documentation]    POST : /services/1.0/entities/validate
    ...
    ...    Validates the given entity definition.
    ...
    ...    Note that this does not guarantee that an entity modification with the same data will succeed as the data while valid may not be acceptable when placed in context.
    ...    eg. the case of read only attribute values
    ...    - changes to these values although not allowed will not be picked up by this function
    ...
    ...    *Arguments*
    ...
    ...    _sapi_entity_definition_ - the literal XML of a SAPIEntityDefinition instance
    ...
    ...    _check_status_allowable_ - indicates if needs check Status Allowable (false would indicate not check the status allowable property)
    ...
    ...    *Return value*
    ...
    ...    Response body containing the validation result as a SAPIEntityValidation
    ...
    ...    *Precondition*
    ...
    ...    The entity must exist.
    ...
    ...    *Example*
    XML HTTP Header Setup
    Set Request Body    ${sapi_entity_definition}
    Next Request May Not Succeed
    POST    ${ENTITY SERVICE ENDPOINT}/validate?checkStatusAllowable=${check_status_allowable}
    ${sapi_entity_validation}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${sapi_entity_validation}    # The literal XML of a SAPIEntityValidation instance

Create Template
    [Arguments]    ${parent_entity_id}    ${title}    ${expected_http_status}=200
    [Documentation]    Used to create a template with default attribute values.
    ...
    ...    *Arguments*
    ...    $(parent_entity_id) The parent entity id.
    ...    $(title) The title of the template.
    ...
    ...    *Return value*
    ...    A string contianing the entity id of the created entity.
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    ${template_dto}=    Build Template DTO    ${title}    ${title}
    ${template_id}=    Add Entity With Custom DTO    ${parent_entity_id}    ${template_dto}    ${expected_http_status}
    [Return]    ${template_id}

Add Web Link Placeholder
    [Arguments]    ${parent_entity_id}
    [Documentation]    Used to add a web link placeholder to a template
    ...
    ...    *Arguments*
    ...
    ...    $(parent_entity_id) The parent (template) entity id.
    ...
    ...    *Return value*
    ...    The updated entity version id
    ...
    ...    *Precondition*
    ...    Entity must be locked.
    ...
    ...    *Example*
    XML HTTP Header Setup
    ${request_body}=    Set Variable    <?xml version="1.0" encoding="utf-8"?> <entityDefinition xmlns="http://entity.services.ewb.idbs.com"><entityType>DOCUMENT</entityType><entityName>Generic Placeholder</entityName><attributes><attribute><name>allowedDataType</name><values><value>ANY</value></values></attribute><attribute><name>itemType</name><values><value>Generic Placeholder</value></values></attribute><attribute><name>publishingState</name><values><value>Unpublished</value></values></attribute><attribute><name>allowDropUpdate</name><values><value>true</value></values></attribute><attribute><name>pinnedEntity</name><values><value>false</value></values></attribute><attribute><name>allowedFileType</name><values><value>All Files (*.*)</value></values></attribute></attributes><data><dataInfo mimeType="application/x-idbs-placeholder" fileType=".phi" dataType="PLACE_HOLDER"/></data></entityDefinition>
    Set Request Body    ${request_body}
    POST    ${CACHE ENTITY SERVICE ENDPOINT}/${parent_entity_id}/children
    ${entity_version_id}=    Get Response Body
    Response Status Code Should Equal    200
    [Return]    ${entity_version_id}    # The id of the placeholder entity

Create Experiment from Template
    [Arguments]    ${parent_entity_id}    ${title}    ${template_id}    ${expected_http_status}=200
    [Documentation]    Adds an experiment created from a template to a parent entity
    ...
    ...    *Arguments*
    ...
    ...    _parent_entity_id_ - the parent entity id.
    ...
    ...    _title_ - The title of the experiment.
    ...
    ...    _expected_http_status_ - the expected http status. Default set to 200
    ...
    ...    *Return value*
    ...
    ...    A string contianing the entity id of the created entity.
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    ${experiment_dto}=    Build Experiment DTO    ${title}    ${title}
    XML HTTP Header Setup
    Set Request Body    ${experiment_dto}
    Next Request May Not Succeed
    POST    ${ENTITY SERVICE ENDPOINT}/${parent_entity_id}/children?templateId=${template_id}
    ${experiment_id}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${experiment_id}

Get Entity With Paged Children
    [Arguments]    ${entity_id}    ${page_number}    ${expected_http_status}=200
    [Documentation]    returns the type (cache/draft/version) of the specified entity
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the id of the entity
    ...
    ...    _page_number - the page number of children entities to retrieve
    ...
    ...
    ...    *Returns*
    ...
    ...    _sapi_filtered_entity_dto - the SAPIFilteredEntityDTO that contains a SAPIEntityEntityDTO and a SAPIFilterOption
    ...
    ...    *Example*
    ...
    ...    Get Entity With Pages Children | 1234 | 2 | 25 |
    ...
    ...    It is the same as to get the children of entity 1234 on page 2 with the page size that is in the system setting.
    XML HTTP Header Setup
    Next Request May Not Succeed
    Set Request Body    <?xml version="1.0" encoding="utf-8"?><filterRequest xmlns="http://entity.services.ewb.idbs.com"><pageNumber>${page_number}</pageNumber></filterRequest>
    POST    ${ENTITY SERVICE ENDPOINT}/${entity_id}/filtered
    ${sapi_filtered_entity_dto}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${sapi_filtered_entity_dto}    # the SAPIFilteredEntityDto

Get Entity With Paged And Sorted Children
    [Arguments]    ${entity_id}    ${page_number}    ${sort_by}    ${expected_http_status}=200
    [Documentation]    Returns the paged and sorted child entities of the specified entity.
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the id of the entity
    ...
    ...    _page_number - the page number of children entities to retrieve
    ...
    ...    _sort_by - please use one of the fixed values below
    ...
    ...    ENTITY_NAME_ASCENDING
    ...    ENTITY_NAME_DESCENDING
    ...    (.. more to be included)
    ...
    ...    *Returns*
    ...
    ...    _sapi_filtered_entity_dto - the SAPIFilteredEntityDTO that contains a SAPIEntityEntityDTO and a SAPIFilterOption
    ...
    ...    *Example*
    ...
    ...    Get Entity With Pages Children | 1234 | 2 | ENTITY_NAME_DESCENDING
    ...
    ...    It is the same as to get the children of entity 1234 on page 2 with the page size that is in the system setting, sorted by the entity name in descending order.
    XML HTTP Header Setup
    Next Request May Not Succeed
    Set Request Body    <?xml version="1.0" encoding="utf-8"?><filterRequest xmlns="http://entity.services.ewb.idbs.com"><pageNumber>${page_number}</pageNumber><sortBy>${sort_by}</sortBy></filterRequest>
    POST    ${ENTITY SERVICE ENDPOINT}/${entity_id}/filtered
    ${sapi_filtered_entity_dto}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${sapi_filtered_entity_dto}

Get Entity Filtered For Created Or Modified By Users
    [Arguments]    ${entity_id}    ${expected_http_status}=200    @{user_names}
    [Documentation]    Returns the child entities of the specified entity filtered to contain only those children created or modified by the specified users
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the id of the entity
    ...
    ...    _user_names_ - the names of the users to filter by
    ...
    ...    *Returns*
    ...
    ...    _sapi_filtered_entity_dto - the SAPIFilteredEntityDTO that contains a SAPIEntityEntityDTO and a SAPIFilterOption
    ...
    ...    *Example*
    ...
    ...    Get Entity Filtered For Created Or Modified By Users | 1234 | Administrator
    ${filter}=    Set Variable    <filterByUsers>
    : FOR    ${user_name}    IN    @{user_names}
    \    ${filter}=    Catenate    SEPARATOR=    ${filter}    <userName>
    \    ${filter}=    Catenate    SEPARATOR=    ${filter}    ${user_name}
    \    ${filter}=    Catenate    SEPARATOR=    ${filter}    </userName>
    ${filter}=    Catenate    SEPARATOR=    ${filter}    </filterByUsers>
    XML HTTP Header Setup
    Next Request May Not Succeed
    Set Request Body    <?xml version="1.0" encoding="utf-8"?><filterRequest xmlns="http://entity.services.ewb.idbs.com"><pageNumber>1</pageNumber>${filter}</filterRequest>
    POST    ${ENTITY SERVICE ENDPOINT}/${entity_id}/filtered
    ${sapi_filtered_entity_dto}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${sapi_filtered_entity_dto}

Get Entity Version Type
    [Arguments]    ${entity_id}    ${expected_http_status}=200
    [Documentation]    returns the type (cache/draft/version) of the specified entity
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the id of the entity
    ...
    ...    _expected_http_status_ - the expected http response (default is 200)
    ...
    ...    *Returns*
    ...
    ...    _version_type_ - the version type of the entity
    HTTP Header Setup
    Get    ${ENTITY SERVICE ENDPOINT}/${entity_id}?preferCachedCopy=true&includeVersionInfo=true
    ${version_info_dto}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    ${version_type}=    Get Json Value    ${version_info_dto}    /versionInfo/versionState
    Comment    strip off JSON quotes
    ${version_type}=    Get Substring    ${version_type}    1    -1
    [Return]    ${version_type}    # the version type of the entity

Get Entity Version Number
    [Arguments]    ${entity_id}    ${expected_http_status}=200
    [Documentation]    returns the version number of the specified entity
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the id of the entity
    ...
    ...    _expected_http_status_ - the expected http response (default is 200)
    ...
    ...    *Returns*
    ...
    ...    _version_number_ - the version number of the entity
    HTTP Header Setup
    Get    ${ENTITY SERVICE ENDPOINT}/${entity_id}?preferCachedCopy=true&includeVersionInfo=true
    ${version_info}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    ${version_number}=    Get Json Value    ${version_info}    /versionInfo/versionNumber
    [Return]    ${version_number}    # the version number of the entity

Get Entity Child Count
    [Arguments]    ${entity_id}    ${expected_http_status}=200
    [Documentation]    returns the number of children the specified entity has
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the id of the entity
    ...
    ...    _expected_http_status_ - the expected http response (default is 200)
    ...
    ...    *Returns*
    ...
    ...    _child_count_ - the number of children
    XML HTTP Header Setup
    Next Request May Not Succeed
    Get    ${ENTITY SERVICE ENDPOINT}/${entity_id}?preferCachedCopy=true&includeChildren=true
    ${entity_dto}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    ${children_count}=    XMLLibrary.Get Xml Element Count    ${entity_dto}    entity    elementNamespace=http://entity.services.ewb.idbs.com
    [Return]    ${children_count}    # the number of children of the entity

Create Confined Template
    [Arguments]    ${parent_entity_id}    ${title}    ${expected_http_status}=200
    [Documentation]    Used to create a confined template with default attribute values.
    ...
    ...    *Arguments*
    ...
    ...    _parent_entity_id_ - The parent entity id.
    ...
    ...    _title_ - The title of the template.
    ...
    ...    _expected_http_status_ - the expected http response (default is 200)
    ...
    ...    *Return value*
    ...
    ...    A string contianing the entity id of the created entity.
    ...
    ...    *Precondition*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    | Create Confined Template | ${project id} | My confined template
    HTTP Header Setup
    Set Request Body    { "entityType": "TEMPLATE", "entityName": "${title}", "attributes": { "attribute": [ { "name": "confinedEntity", "values": {"value": ["true"]} }, { "name": "references", "values": {} }, { "name": "keywords", "values": {} }, { "name": "sequentialEdit", "values": {} }, { "name": "statusTimestamp", "values": {} }, { "name": "createdFromTemplate" , "values": {} },{ "name": "templates" , "values": {} }, \ { "name": "prevExpRef","values": {} }, { "name": "statusName","values": { "value": ["Started"] } }, { "name": "title","values": { "value": ["${title}"] } } ] } }
    POST    ${ENTITY SERVICE ENDPOINT}/${parent_entity_id}/children
    ${template_id}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${template_id}    # the entity id of the template

Create Confined Experiment from Template
    [Arguments]    ${parent_entity_id}    ${title}    ${template_id}    ${expected_http_status}=200
    [Documentation]    Used to an experiment with default attribute values.
    ...
    ...    *Arguments*
    ...
    ...    _parent_entity_id_ - The parent entity id.
    ...
    ...    _title_ - The title of the experiment.
    ...
    ...    _expected_http_status_ - the expected http response (default is 200)
    ...
    ...    *Return value*
    ...    A string contianing the entity id of the created entity.
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    HTTP Header Setup
    Set Request Body    { "entityType": "EXPERIMENT", "entityName": "${title}", "attributes": { "attribute": [ { "name": "confinedEntity", "values": {"value": ["true"]} }, { "name": "references", "values": {} }, { "name": "keywords", "values": {} }, { "name": "sequentialEdit", "values": {} }, { "name": "statusTimestamp", "values": {} }, { "name": "createdFromTemplate" , "values": {} },{ "name": "templates" , "values": {} }, \ { "name": "prevExpRef","values": {} }, { "name": "statusName","values": { "value": ["Started"] } }, { "name": "title","values": { "value": ["${title}"] } } ] } }
    POST    ${ENTITY SERVICE ENDPOINT}/${parent_entity_id}/children?templateId=${template_id}
    ${experiment_id}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${experiment_id}    # the entity id of the experiment

Create Restricted Target Template
    [Arguments]    ${parent_entity_id}    ${title}    ${restricted_type}    ${expected_http_status}=200
    [Documentation]    Used to create a confined template with default attribute values.
    ...
    ...    *Arguments*
    ...
    ...    _parent_entity_id_ - The parent entity id.
    ...
    ...    _title_ - The title of the template.
    ...
    ...    _restricted_type_ - the entity type this template can be used to create
    ...
    ...    _expected_http_status_ - the expected http response (default is 200)
    ...
    ...    *Return value*
    ...
    ...    A string contianing the entity id of the created entity.
    ...
    ...    *Precondition*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    | Create Restricted Target Template | ${project id} | My confined template | REPORT
    HTTP Header Setup
    Set Request Body    {"entityType":"TEMPLATE","entityName":"I have contents","attributes":{"attribute":[{"name":"confinedEntity","values":{}},{"name":"references","values":{}},{"name":"keywords","values":{}},{"name":"sequentialEdit","values":{}},{"name":"statusTimestamp","values":{}},{"name":"createdFromTemplate","values":{}},{"name":"templates","values":{}},{"name":"prevExpRef","values":{}},{"name":"statusName","values":{"value":["Started"]}},{"name":"title","values":{"value":["I have contents"]}},{"name":"targetEntityType","values":{"value":["${restricted_type}"]}}]}}
    POST    ${ENTITY SERVICE ENDPOINT}/${parent_entity_id}/children
    ${template_id}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${template_id}    # the entity id of the template

Check Child Data Type
    [Arguments]    ${entity_id}    ${child index}    ${expected data type}    ${expected_http_status}=200
    [Documentation]    validates the data type of the child at the specified index of the entity
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the id of the entity (typically a record)
    ...
    ...    _child index_ - the index of the child to check
    ...
    ...    _expected data type_ - the expected data type of that child
    ...
    ...    _expected_http_status_ - the expected http response (default is 200)
    ...
    ...
    ...    *Example*
    ...
    ...    | Data type of child should be | ${experiment_id} | 0 | HTML_TEXT
    HTTP Header Setup
    Get    ${ENTITY SERVICE ENDPOINT}/${entity_id}?preferCachedCopy=true&includeChildren=true&includeDataInfo=true
    ${entity_dto}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    ${jsonpath}=    set Variable    /children/entity/${child index}/dataInfo/dataInfo/dataType
    ${actual \ data type}=    Get Json Value    ${entity_dto}    ${jsonpath}
    Comment    strip off JSON quotes
    ${actual \ data type}=    Get Substring    ${actual \ data type}    1    -1
    should be equal as strings    ${expected data type}    ${actual \ data type}

Check Child Data
    [Arguments]    ${entity_id}    ${child index}    ${expected data}    ${expected_http_status}=200
    [Documentation]    validates the data of the child at the specified index of the entity
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the id of the entity (typically a record)
    ...
    ...    _child index_ - the index of the child to check
    ...
    ...    _expected data_ - the expected data in that child
    ...
    ...    _expected_http_status_ - the expected http response (default is 200)
    ...
    ...    *Example*
    ...
    ...    | # first item should be a weblink
    ...    | Data of child should be | ${experiment_id} | 0 | http://www.google.com
    HTTP Header Setup
    Get    ${ENTITY SERVICE ENDPOINT}/${entity_id}?preferCachedCopy=true&includeChildren=true&includeDataInfo=true&includeVersionInfo=true
    ${entity_dto}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    ## child entity id
    ${jsonpath}=    set Variable    /children/entity/${child index}/entityCore/entityId
    ${child_entity_id}=    Get Json Value    ${entity_dto}    ${jsonpath}
    Comment    strip off JSON quotes
    ${child_entity_id}=    Get Substring    ${child_entity_id}    1    -1
    ## child version id
    ${jsonpath}=    set Variable    /children/entity/${child index}/versionInfo/versionId
    ${child_version_id}=    Get Json Value    ${entity_dto}    ${jsonpath}
    Comment    strip off JSON quotes
    ${child_version_id}=    Get Substring    ${child_version_id}    1    -1
    # get the data
    ${actual data}=    Get Entity Data    ${child_entity_id}    ${child_version_id}
    should be equal as strings    ${expected data}    ${actual data}

Get Entity Id Of Child At Index
    [Arguments]    ${entity_id}    ${child index}    ${expected_http_status}=200
    [Documentation]    returns the id of the child at the specified index
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the id of the entity (typically a record)
    ...
    ...    _child index_ - the index of the child to check
    ...
    ...    _expected_http_status_ - the expected http response (default is 200)
    ...
    ...    *Returns*
    ...
    ...    _child_id_ - the id of the child
    ...
    ...    *Example*
    ...
    ...    | ${child_id}= | Get entity id of child at index | ${experiment_id} | 0
    HTTP Header Setup
    Get    ${ENTITY SERVICE ENDPOINT}/${entity_id}?preferCachedCopy=true&includeChildren=true
    ${entity_dto}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    ## child entity id
    ${jsonpath}=    set Variable    /children/entity/${child index}/entityCore/entityId
    ${child_id}=    Get Json Value    ${entity_dto}    ${jsonpath}
    Comment    strip off JSON quotes
    ${child_id}=    Get Substring    ${child_id}    1    -1
    [Return]    ${child_id}    # the entity id of the child

Verify Attribute Value Is Present For Entity
    [Arguments]    ${entity_id}    ${attribute_name}    ${attribute_value}
    [Documentation]    retrieves the attributes for the specified entity and checks to see if the attribute is present, and if so, does it have the specified value
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the id of the entity to check
    ...
    ...    _attribute_name_ - the name of the attribute
    ...
    ...    _attribute_value_ - the value of the attribute
    ${version_id}=    Get Entity Version ID    ${entity_id}
    ${xml_attributes}=    Get Attributes    ${entity_id}    ${version_id}
    ${xpath}=    Set Variable    .//{http://entity.services.ewb.idbs.com}attribute[@name='${attribute_name}']/{http://entity.services.ewb.idbs.com}values/{http://entity.services.ewb.idbs.com}value
    @{values}=    Get Element Value From Xpath    ${xml_attributes}    ${xpath}
    should contain    @{values}    ${attribute_value}

Delete Entity With Custom DTO
    [Arguments]    ${entity_id}    ${sapi_user_action_info}    ${expected_http_status}=204
    [Documentation]    Used to delete an entity "As Intended"
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the entity id
    ...
    ...    _sapi_user_action_info_ - the DTO requeired to perform the request
    ...
    ...    _expected_http_status_ - the expected http response status
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    ...
    ...    Delete Entity | ${experiment_id}
    ...
    ...    Delete Entity | ${experiment_id} | <userActionInfo xmlns="http://entity.services.ewb.idbs.com" reason="As Intended hello" additionalComment=""/>
    XML HTTP Header Setup
    Set Request Body    ${sapi_user_action_info}
    Next Request May Not Succeed
    PUT    ${ENTITY SERVICE ENDPOINT}/${entity_id}
    Response Status Code Should Equal    ${expected_http_status}

Get Entity
    [Arguments]    ${entity_id}    ${entity_version_id}=    ${prefer_cached_copy}=true    ${include_attributes}=false    ${include_version_info}=false    ${include_signatures}=false
    ...    ${include_path}=false    ${include_data_info}=false    ${include_children}=false    ${include_tags}=false    ${include_permissions}=false    ${include_comments}=false
    ...    ${expected_http_status}=200
    [Documentation]    *DEPRECATED* -> Use keyword "Get Entity New"
    ...
    ...    returns the type (cache/draft/version) of the specified entity
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the id of the entity
    ...
    ...    _entity_version_id_ - the entity version id
    ...
    ...    _prefer_cached_copy_ - the boolean, <code>true</code> to get cache copy is exists
    ...
    ...    _include_attributes_ - the boolean, <code>true</code> to include attributes
    ...
    ...    _include_version_info_ - the boolean, <code>true</code> to include version info
    ...
    ...    _include_signatures_ - the boolean, <code>true</code> to include signatures
    ...
    ...    _include_path_ - the boolean, <code>true</code> to include path
    ...
    ...    _include_data_info_ - the boolean, <code>true</code> to include data info
    ...
    ...    _include_children_ - the boolean, <code>true</code> to include children
    ...
    ...    _include_tags_ - the boolean, <code>true</code> to include tags
    ...
    ...    _include_permissions_ - the boolean, <code>true</code> to include permissions
    ...
    ...    _include_comments_ - the boolean, <code>true</code> to include comments
    ...
    ...    _expected_http_status_ - the expected http response (default is 200)
    ...
    ...    *Returns*
    ...
    ...    _version_type_ - the version type of the entity
    XML HTTP Header Setup
    Next Request May Not Succeed
    Get    ${ENTITY SERVICE ENDPOINT}/${entity_id}?entityVersionId=${entity_version_id}&preferCachedCopy=${prefer_cached_copy}&includeAttributes=${include_attributes}&includeVersionInfo=${include_version_info}&includeSignatures=${include_signatures}&includePath=${include_path}&includeDataInfo=${include_data_info}&includeChildren=${include_children}&includePermissions=${include_permissions}&includeTags=${include_tags}&includeComments=${include_comments}
    ${sapi_entity_dto}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${sapi_entity_dto}    # the SAPIEntityDto

Get Entity New
    [Arguments]    ${entity_id}    ${entity_version_id}    ${expected_http_status}=200    @{retrieve_options}
    [Documentation]    returns the type (cache/draft/version) of the specified entity
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the id of the entity
    ...
    ...    _entity_version_id_ - the entity version id
    ...
    ...    _expected_http_status_ - the expected http response (default is 200)
    ...
    ...    _retrieve_options_ - the service enpoint boolean flag names and value. When a flag is not specified service default value is used. Boolean flag names are:
    ...    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ preferCachedCopy, includeAttributes, includeVersionInfo, includeSignatures,
    ...    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ includePath, includeDataInfo, includeChildren, includeTags, includePermissions, includeComments
    ...
    ...
    ...
    ...    *Returns*
    ...
    ...    _version_type_ - the version type of the entity
    ...
    ...    *Example*
    ...
    ...    Get Entity | 1234 | 4321 | 200 | preferCachedCopy=true | includeComments=true
    # Perses the array of retrieve options and build the query parameters string
    ${query_parameters}=    Set Variable    entityVersionId=${entity_version_id}
    : FOR    ${parameter_name_value}    IN    @{retrieve_options}
    \    ${query_parameters}=    Catenate    SEPARATOR=&    ${query_parameters}    ${parameter_name_value}
    XML HTTP Header Setup
    Next Request May Not Succeed
    Get    ${ENTITY SERVICE ENDPOINT}/${entity_id}?${query_parameters}
    ${sapi_entity_dto}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${sapi_entity_dto}    # The SAPIEntityDefinition as XML literal

Set Publishing State
    [Arguments]    ${entity_id}    ${entity_version_id}    ${publishing_state}    ${expected_http_status}=204
    [Documentation]    PUT : services/1.0/entities/{entityId}/attributes
    ...
    ...    Sets the publishing state for a document entity (eg. a web link in an experiment)
    ...
    ...    The "container entity" (eg. the experiment) must be locked before you can update the publishing state on the child document entity.
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ The id of the entity whose publishing state needs to be updated
    ...
    ...    _entity_version_id_ The version of the entity \ whose publishing state needs to be updated
    ...
    ...    _publishing_state_ the publishing state value, which must be one of the states defined in the catalog
    ...
    ...    *Return value*
    ...
    ...    None
    ...
    ...    *Precondition*
    ...
    ...    The document entity must exist.
    ...
    ...    The parent container entity must be locked
    ...
    ...    *Example*
    XML HTTP Header Setup
    Next Request May Not Succeed
    PUT    ${ENTITY SERVICE ENDPOINT}/${entity_id}/attributes?entityVersionId=${entity_version_id}&publishingState=${publishing_state}
    Response Status Code Should Equal    ${expected_http_status}

Add Entity To Favorites
    [Arguments]    ${username}    ${password}    ${Entity_Id}
    Create Http Context    ${SERVER}:${WEB_SERVICE_PORT}    https
    ${authorization}=    Base64 Encode String    ${username}:${password}
    Set Basic Auth    ${username}    ${password}
    Set Request Header    X-Web-Client-Author-Credentials    BASIC ${authorization}
    Set Request Header    Accept    application/xml;charset=utf-8
    Set Request Header    Content-Type    application/xml;charset=utf-8
    PUT    ${ENTITY SERVICE ENDPOINT}/${Entity_Id}/favorite

Create Experiment And Add To Favorites
    [Arguments]    ${Parent_Id}    ${Experiment_Name}    ${username}    ${password}
    ${Experiment_Id}=    rest_entity_service_resource.Create Experiment    ${Parent_Id}    ${Experiment_Name}
    Add Entity To Favorites    ${username}    ${password}    ${Experiment_Id}

Add IDBS Spreadsheet and Tidy
    [Arguments]    ${parent_entity_id}    ${data_file_path}    ${item_type}=Uploaded Document
    [Documentation]    Used to update an entity
    ...
    ...    *Arguments*
    ...
    ...    $(parent_entity_id) The parent (record) entity id.
    ...
    ...    $(data_file_path) The file path of the data including the file name. The file path separator MUST be '\\'.
    ...
    ...    ${mime_type} The MIME type, e.g., application/x-idbs-ewbimage
    ...
    ...    ${data_type} The IDBS data type, e.g., FILE or SVG_IMAGE
    ...
    ...    *Return value*
    ...    The updated entity version id
    ...
    ...    *Precondition*
    ...    Entity must be locked.
    ...
    ...    *Example*
    XML HTTP Header Setup
    ${file_name}=    String.Fetch From Right    ${data_file_path}    \\
    ${file_name}=    String.Fetch From Right    ${file_name}    /
    ${file_type}=    String.Fetch From Right    ${data_file_path}    .
    ${file_type}=    Set Variable    .${file_type}
    ${binary_file}=    Get Binary File    ${data_file_path}
    ${data_encoded}=    Base64 Encode String    ${binary_file}
    ${request_body}=    Set Variable    <?xml version="1.0" encoding="utf-8"?><entityDefinition xmlns="http://entity.services.ewb.idbs.com"><entityType>SPREADSHEET_DOCUMENT</entityType><entityName>${file_name}</entityName><attributes><attribute><name>registeredids</name><values/></attribute><attribute><name>allowedDataType</name><values/></attribute><attribute><name>link</name><values/></attribute><attribute><name>itemType</name><values><value>${item_type}</value></values></attribute><attribute><name>hasDataExchangeTables</name><values/></attribute><attribute><name>sequentialEdit</name><values/></attribute><attribute><name>publishingState</name><values><value>Unpublished</value></values></attribute><attribute><name>caption</name><values><value>${file_name}</value></values></attribute><attribute><name>copiedFrom</name><values/></attribute><attribute><name>hasLinkedDataFields</name><values/></attribute><attribute><name>allowDropUpdate</name><values><value>false</value></values></attribute><attribute><name>preregisteredids</name><values/></attribute><attribute><name>annotations</name><values/></attribute><attribute><name>pinnedEntity</name><values><value>false</value></values></attribute><attribute><name>allowedFileType</name><values/></attribute></attributes><data><dataInfo mimeType="application/x-idbs-web-spreadsheet" fileType="${file_type}" dataType="IDBS_SPREADSHEET"/><data><dataBinary>${data_encoded}</dataBinary></data><preview/></data></entityDefinition>
    Set Request Body    ${request_body}
    POST    ${CACHE ENTITY SERVICE ENDPOINT}/${parent_entity_id}/spreadsheets
    ${entity_id}=    Get Response Body
    Response Status Code Should Equal    200
    [Return]    ${entity_id}    # The id of the created entity
