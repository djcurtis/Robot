*** Settings ***
Library           String
Library           IDBSHttpLibrary
Library           XMLLibrary
Resource          ../../../Common/common_resource.robot
Resource          ../../../Common/HTTP Common/http_common_resource.robot
Resource          ../Entity Service/rest_entity_service_resource.robot

*** Variables ***
${CACHE ENTITY SERVICE ENDPOINT}    /ewb/services/1.0/cache/entities

*** Keywords ***
Add Cache Entity With Custom DTO
    [Arguments]    ${parent_entity_id}    ${sapi_entity_definition}    ${expected_http_status}=200
    [Documentation]    Add a cache child entity to a parent entity
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
    POST    ${CACHE ENTITY SERVICE ENDPOINT}/${parent_entity_id}/children
    ${entity_id}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${entity_id}    # The newly added entity id

Replace Cache Entity
    [Arguments]    ${entity_id}    ${entity_version_id}    ${replace_entity_info}    ${expected_http_status}=200
    [Documentation]    PUT : /services/1.0/cache/entities/{entityId}
    ...
    ...    Replaces a cached entity with the new entity. \ Typically this is when a template placeholder is replaced by actual experiment data.
    ...    The request body is a SAPIReplaceEntityInfo.
    ...
    ...    *Arguments*
    ...
    ...    $(entity_id) The id of the entity to be replaced
    ...
    ...    ${entity_version_id} The version of the entity to be replaced
    ...
    ...    ${replace_entity_info} the SAPIReplaceEntityInfo class instance containing the new entity information
    ...
    ...    *Return value*
    ...    ${id} The id of the new entity
    ...
    ...    *Precondition*
    ...    The entity must exist.
    ...
    ...    *Example* \
    XML HTTP Header Setup
    Set Request Body    ${replace_entity_info}
    Next Request May Not Succeed
    PUT    ${CACHE_ENTITY SERVICE ENDPOINT}/${entity_id}?entityVersionId=${entity_version_id}
    ${entity_id}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${entity_id}    # The id of the new entity

Update Cache Entity
    [Arguments]    ${entity_id}    ${entity_version_id}    ${entity_definition}    ${expected_http_status}=200
    [Documentation]    POST : /services/1.0/cache/entities/{entityId}
    ...
    ...    Updates a cached entity. \ The request body is a SAPIEntityDefinition.
    ...
    ...    *Arguments*
    ...
    ...    $(entity_id) The id of the entity to be replaced
    ...
    ...    ${entity_version_id} The version of the entity to be updated
    ...
    ...    ${entity_definition} A SAPIEntityDto that details the entity information
    ...
    ...    *Return value*
    ...
    ...    $(version_id) The version id of the modified entity
    ...
    ...    *Precondition*
    ...
    ...    The entity must exist.
    ...
    ...    *Example*
    XML HTTP Header Setup
    Set Request Body    ${entity_definition}
    Next Request May Not Succeed
    POST    ${CACHE_ENTITY SERVICE ENDPOINT}/${entity_id}?entityVersionId=${entity_version_id}
    ${version_id}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${version_id}    # the entity version id of the modified entity

Delete Cache Entity
    [Arguments]    ${entity_id}    ${entity_version_id}    ${expected_http_status}=204
    [Documentation]    DELETE : /services/1.0/cache/entities/{entityId}
    ...
    ...    Deletes an entity from the cache.
    ...
    ...    *Arguments*
    ...
    ...    $(entity_id) The id of the entity to be deleted
    ...
    ...    ${entity_version_id} The version of the entity to be deleted
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...
    ...    The entity must exist.
    ...
    ...    The entity must be locked.
    ...
    ...    *Example* \
    XML HTTP Header Setup
    Next Request May Not Succeed
    DELETE    ${CACHE_ENTITY SERVICE ENDPOINT}/${entity_id}?entityVersionId=${entity_version_id}
    Response Status Code Should Equal    ${expected_http_status}

Set Cache Entity Data
    [Arguments]    ${entity_id}    ${data_type}    ${file_type}    ${data}    ${mime_type}=${EMPTY}    ${filename}=${EMPTY}
    ...    ${expected_http_status}=200    # filename is optional (defaults to null/empty)
    [Documentation]    *DEPRECATED*, use "Set Cache Entity Data Text"
    ...
    ...    POST : /services/1.0/cache/entities/{entityId}/data/text
    ...
    ...    Set an entity data by replacing any existing data.
    ...    The data provided MUST be a literal.
    ...
    ...
    ...    *Arguments*
    ...
    ...    $(entity_id) The id of the entity
    ...
    ...    ${data_type} The data type
    ...
    ...    ${file_type} The file type
    ...
    ...    ${data} the string data that will replace the exiting one. The data provided MUST be a literal.
    ...
    ...    ${mime_type} The mime type
    ...
    ...    ${filename} (optional) allows the file name to be specified
    ...
    ...    *Return value*
    ...
    ...    ${version_id} The entity version id of the modified entity
    ...
    ...    *Precondition*
    ...
    ...    The entity must exist.
    ...
    ...    *Example* \
    ${version_id}=    Set Cache Entity Data Text    ${entity_id}    ${data_type}    ${file_type}    ${mime_type}    ${filename}
    ...    ${data}    ${expected_http_status}
    [Return]    ${version_id}    # The entity version id of the modified entity

Set Cache Entity Data Text
    [Arguments]    ${entity_id}    ${data_type}    ${file_type}    ${mime_type}    ${file_name}    ${text_data}
    ...    ${expected_http_status}=200    # filename is optional (defaults to null/empty)
    [Documentation]    POST : /services/1.0/cache/entities/{entityId}/data/text
    ...
    ...    Set an entity data by replacing any existing data. The data provided MUST be a literal.
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the id of the entity
    ...
    ...    _data_type_ - the data type, e.g. FILE, SVG_IMAGE
    ...
    ...    _file_type_ - the file type as file extension, e.g., .HTML, .TXT, and .DOC
    ...
    ...    _mime_type_ - the mime type, e.g. text/plain, application/pdf, image/png
    ...
    ...    _file_name_ - (optional) allows the file name to be specified
    ...
    ...    _text_data_ - the string data that will replace the exiting one. The data provided MUST be a literal.
    ...
    ...    *Return value*
    ...
    ...    The entity version id of the modified entity
    ...
    ...    *Precondition*
    ...
    ...    The entity must exist.
    ...
    ...    *Example*
    HTTP Header Setup
    Set Request Body    ${text_data}
    Next Request May Not Succeed
    POST    ${CACHE_ENTITY SERVICE ENDPOINT}/${entity_id}/data/text?dataType=${data_type}&fileType=${file_type}&mimeType=${mime_type}&fileName=${file_name}
    ${entity_version_id}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    [Return]    ${entity_version_id}    # The entity version id of the modified entity

Set Cache Entity Data Binary
    [Arguments]    ${entity_id}    ${data_type}    ${file_type}    ${data}    ${expected_http_status}=200    # filename is optional (defaults to null/empty)
    [Documentation]    POST : /services/1.0/cache/entities/{entityId}/data
    ...
    ...    Sets an entity data by replacing any existing data. Data is provided as HTTP multipart content in request body.
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the id of the entity
    ...
    ...    _data_type_ - the data type, e.g. FILE, SVG_IMAGE
    ...
    ...    _file_type_ - the file type as file extension, e.g., .HTML, .TXT, and .DOC
    ...
    ...    _data_ - the data that will replace the exiting one.
    ...
    ...    *Return value*
    ...
    ...    The entity version id of the modified entity
    ...
    ...    *Precondition*
    ...
    ...    The entity must exist.
    ...
    ...    *Example*
    # Creates temporary file
    ${unique_id}=    Create Unique ID
    ${file_name}=    Set Variable    ${unique_id}${file_type}
    ${file_path}=    Set Variable    ${OUTPUT_DIR}/${file_name}
    OperatingSystem.Create File    ${file_path}    ${data}
    # Posts the file
    Binary HTTP Header Setup
    Next Request May Not Succeed
    ${file_attachment}=    Create Form Data Object    ${file_name}    ${file_path}
    POST    ${CACHE_ENTITY SERVICE ENDPOINT}/${entity_id}/data?dataType=${data_type}&fileType=${file_type}    ${file_attachment}
    ${entity_version_id}=    Get Response Body
    Response Status Code Should Equal    ${expected_http_status}
    # Removes temporary file
    OperatingSystem.Remove File    ${file_path}
    HTTP Header Setup
    [Return]    ${entity_version_id}    # The entity version id of the modified entity

Set Cache Entity Position
    [Arguments]    ${entity_id}    ${entity_version_id}    ${position_index}    ${expected_http_status}=204
    [Documentation]    POST : /services/1.0/cache/entities/{entityId}/position/{positionIndex}
    ...
    ...    Sets the entity position in a record. Position index is 0 based, i.e. the first position is 0. Valid indexes are 0 <= position index < number of record items. For instance, in a record containing 5 items allowed indexes are [0, 4].
    ...
    ...    *Arguments*
    ...
    ...    $(entity_id) The id of the entity
    ...
    ...    ${entity_version_id} The version of the entity (set to latest version)
    ...
    ...    ${position_index} An integer representing the entity position in a record
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    The entity must exist.
    ...
    ...    *Example* \
    XML HTTP Header Setup
    Next Request May Not Succeed
    POST    ${CACHE_ENTITY SERVICE ENDPOINT}/${entity_id}/position/${position_index}?entityVersionId=${entity_version_id}
    Response Status Code Should Equal    ${expected_http_status}

Set Cache Preview Data
    [Arguments]    ${entity_id}    ${preview_data}    ${expected_http_status}=204
    [Documentation]    POST : /services/1.0/cache/entities/{entityId}/preview
    ...
    ...    Update the preview backing data. This is for use in the case where the preview data is generated externally,
    ...    currently used by spreadsheet previews, where the preview consists of a .zip file containing the preview PDF and
    ...    preview configuration data as a file embedded in the zip.
    ...
    ...    *Arguments*
    ...
    ...    $(entity_id) The id of the entity
    ...
    ...    ${preview_data} The preview data as multipart input
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    The entity must currently be in the CACHED state
    ...
    ...    *Example*
    ...
    ...    The preview data as multipart input. The input should be of the form:
    ...
    ...    | name | Content-Type | Description |
    ...    | bin | application/octet-stream | Mandatory: The preview data |
    ...    | previewConfiguration | application/xml | Optional: An XML encoded version of the \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ SAPIPreviewsConfiguration which will be applied to the saved preview data |
    XML HTTP Header Setup
    Set Request Body    ${preview_data}
    Next Request May Not Succeed
    POST    ${CACHE_ENTITY SERVICE ENDPOINT}/${entity_id}/preview
    Response Status Code Should Equal    ${expected_http_status}

Insert Template Contents Into Record
    [Arguments]    ${recordId}    ${templateId}    ${clear_pinned_status}    ${expected_http_status}=200
    [Documentation]    uses the cache service to insert a templates contents into a record.
    ...
    ...    *Arguments*
    ...
    ...    _recordId_ - \ the entity id of the record to insert into
    ...
    ...    _templateId_ - the entity id of the template whose contents we want to insert
    ...
    ...    _clear_pinned_status_ - true/false indicating if the cleared status should be cleared from the new items (or not)
    ...
    ...    _expected_http_status_ - the expected http status for this request (default is 200)
    ...
    ...    *Pre-requisites*
    ...
    ...    The user must have a lock on the experiment and be able to add items (i.e. not locked against edit, and not confined)
    ...
    ...    *Example*
    ...
    ...    | Insert template into record | ${recordId} | ${templatesId} | ${True} | 200
    HTTP Header Setup
    ${url}=    Set Variable    ${CACHE ENTITY SERVICE ENDPOINT}/${recordId}/children/append/fromtemplate?
    ${url}=    Set Variable If    '${templateId}' == '${EMPTY}'    ${url}    ${url}templateId=${templateId}&
    ${url}=    Set Variable    ${url}clearPinnedStatus=${clear_pinned_status}
    Next Request May Not Succeed
    POST    ${url}
    Response Status Code Should Equal    ${expected_http_status}

Insert Template Contents Into Record Using Specific User
    [Arguments]    ${user}    ${pwd}    ${recordId}    ${templateId}    ${clear_pinned_status}    ${expected_http_status}=200
    [Documentation]    uses the cache service to insert a templates contents into a record using the specified user account.
    ...
    ...    *Arguments*
    ...
    ...    _user_ - the username
    ...
    ...    _pwd_ - the password for the user
    ...
    ...    _recordId_ - \ the entity id of the record to insert into
    ...
    ...    _templateId_ - the entity id of the template whose contents we want to insert
    ...
    ...    _clear_pinned_status_ - true/false indicating if the cleared status should be cleared from the new items (or not)
    ...
    ...    _expected_http_status_ - the expected http status for this request (default is 200)
    ...
    ...    *Pre-requisites*
    ...
    ...    The user must have a lock on the experiment and be able to add items (i.e. not locked against edit, and not confined)
    ...
    ...    *Example*
    ...
    ...    | Insert template into record | john | john1 | ${recordId} | ${templatesId} | ${True} | 200
    HTTP Header Setup With Custom User    ${user}    ${pwd}
    ${url}=    Set Variable    ${CACHE ENTITY SERVICE ENDPOINT}/${recordId}/children/append/fromtemplate?
    ${url}=    Set Variable If    '${templateId}' == '${EMPTY}'    ${url}    ${url}templateId=${templateId}&
    ${url}=    Set Variable    ${url}clearPinnedStatus=${clear pinned status}
    Next Request May Not Succeed
    POST    ${url}
    Response Status Code Should Equal    ${expected_http_status}

Add Inbox Items To Record
    [Arguments]    ${recordId}    ${inbox_item_details}    ${expected_http_status}=200
    [Documentation]    uses the cache service to add inbox items to a record.
    ...
    ...    *Arguments*
    ...
    ...    _recordId_ - the entity id of the record to insert into
    ...
    ...    _inbox_item_details_ - a the inbox item details in xml format
    ...
    ...
    ...    _expected_http_status_ - the expected http status for this request (default is 200)
    ...
    ...    *Pre-requisites*
    ...
    ...    The user must have a lock on the experiment and be able to add items (i.e. not locked against edit, and not confined)
    ...
    ...    *Example*
    ...
    ...    | ${inbox_details}= | build inbox item details
    ...    | Insert template into record | ${recordId} | ${inbox_details} | 200
    XML HTTP Header Setup
    ${url}=    Set Variable    ${CACHE ENTITY SERVICE ENDPOINT}/${recordId}/children/append/frominbox
    Set Request Body    ${inbox_item_details}
    Next Request May Not Succeed
    POST    ${url}
    Response Status Code Should Equal    ${expected_http_status}

Add Inbox Items To Record And Remove Them Afterwards
    [Arguments]    ${recordId}    ${inbox_item_details}    ${expected_http_status}=200
    [Documentation]    uses the cache service to add inbox items to a record, removing them from the inbox once added
    ...
    ...    *Arguments*
    ...
    ...    _recordId_ - the entity id of the record to insert into
    ...
    ...    _inbox_item_details_ - a the inbox item details in xml format
    ...
    ...
    ...    _expected_http_status_ - the expected http status for this request (default is 200)
    ...
    ...    *Pre-requisites*
    ...
    ...    The user must have a lock on the experiment and be able to add items (i.e. not locked against edit, and not confined)
    ...
    ...    *Example*
    ...
    ...    | ${inbox_details}= | build inbox item details
    ...    | Insert template into record | ${recordId} | ${inbox_details} | 200
    XML HTTP Header Setup
    ${url}=    Set Variable    ${CACHE ENTITY SERVICE ENDPOINT}/${recordId}/children/append/frominbox?removeFromInbox=True
    Set Request Body    ${inbox_item_details}
    Next Request May Not Succeed
    POST    ${url}
    Response Status Code Should Equal    ${expected_http_status}

Save As Draft Entity
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
    XML HTTP Header Setup
    ${commit_dto}=    Build Save As Draft DTO    ${entity_id}
    Set Request Body    ${commit_dto}
    Next Request May Not Succeed
    POST    ${CACHE ENTITY SERVICE ENDPOINT}/${entity_id}/commit
    Response Status Code Should Equal    ${expected_http_status}