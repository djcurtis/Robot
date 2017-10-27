*** Settings ***
Library           String
Library           IDBSHttpLibrary
Library           XMLLibrary
# Library           OracleLibrary
Resource          ../../../Common/HTTP Common/http_common_resource.robot    # HTTP common resources
Resource          ../Entity Service/rest_entity_service_resource.robot
Resource          ../Entity Lock Service/rest_entity_lock_service.robot
# Library           SecurityAPILibrary
Resource          ../../../Web Services/REST_SecurityService/rest_security_service_resource.robot

*** Variables ***
${RECORD SERVICE ENDPOINT}    /ewb/services/1.0/records

*** Keywords ***
Create Record PDF
    [Arguments]    ${record_id}    ${record_version_id}    ${expected_http_status}=200
    [Documentation]    POST : /services/1.0/records/{entityId}/pdf
    ...
    ...    Generates a PDF representation of the given record version.
    ...    This end point will create a PDF folder (if one does not exist) under the record and add the PDF to this folder.
    ...
    ...    *Arguments*
    ...
    ...    $(record_id) The record id
    ...
    ...    ${record_version_id} The record version id
    ...
    ...    ${expected_http_status} Optional parameter set to 200 by default
    ...
    ...    *Return value*
    ...    ${id} A string containing the entity id of the created PDF
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    HTTP Header Setup
    Next Request May Not Succeed
    POST    ${RECORD SERVICE ENDPOINT}/${record_id}/pdf?entityVersionId=${record_version_id}
    Response Status Code Should Equal    ${expected_http_status}
    ${id}=    Get Response Body
    [Return]    ${id}    # A string representing the id of the newly create entity

Delete All Record Comments
    [Arguments]    ${record_id}    ${expected_http_status}=204
    [Documentation]    DELETE : /services/1.0/records/{entityId}/comments
    ...
    ...    Used to delete all the comments for a record entity and it's children
    ...
    ...    *Arguments*
    ...    ${record_id} The record id.
    ...
    ...    ${expected_http_status} Optional parameter set to 204 by default
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    XML HTTP Header Setup
    Next Request May Not Succeed
    DELETE    ${RECORD SERVICE ENDPOINT}/${record_id}/comments
    Response Status Code Should Equal    ${expected_http_status}
    ${response}=    Get Response Body
    [Return]    ${response}

Publish Record
    [Arguments]    ${record_id}    ${expectedHttpStatus}=200    # The id of the record to publish
    [Documentation]    POST : /services/1.0/records/{entityId}/publish
    ...
    ...    Publishes a version saved record and generates a PDF representation of the published record version. Permissions required: INITIATE_PUBLISHING
    ...
    ...    *Arguments*
    ...
    ...    $(record_id) The id of the record to publish
    ...
    ...    ${expectedHttpStatus} Optional parameter set to 200 by default
    ...
    ...    *Return value*
    ...
    ...    ${pdf_entity_id} A string containing the entity id of the created PDF
    ...
    ...    *Precondition*
    ...
    ...    The user must have a lock on the record and INITIATE_PUBLISHING permission
    ...
    ...    *Example*
    HTTP Header Setup
    Set Request Timeout    360s
    Next Request May Not Succeed
    POST    ${RECORD SERVICE ENDPOINT}/${record_id}/publish
    Response Status Code Should Equal    ${expectedHttpStatus}
    ${pdf_entity_id}=    Get Response Body
    [Return]    ${pdf_entity_id}    # A string containing the entity id of the created PDF

Is Record Publishable
    [Arguments]    ${record_id}    ${expected_http_status}=200    # The id of the record to publish
    [Documentation]    GET : /services/1.0/records/{entityId}/publishable
    ...
    ...    Checks whether the user can publish a record, i.e., if the current user has the permission to publish it and the record has unpublished items.
    ...
    ...    *Arguments*
    ...
    ...    $(record_id) The id of the record to publish
    ...
    ...
    ...    *Return value*
    ...
    ...    A SAPIBooleanResponse that is 'true' if the record is publishable, 'false' otherwise
    ...
    ...    *Precondition*
    ...
    ...    The user must have a lock on the record and INITIATE_PUBLISHING permission
    ...
    ...    *Example*
    HTTP Header Setup
    Next Request May Not Succeed
    GET    ${RECORD SERVICE ENDPOINT}/${record_id}/publishable
    Response Status Code Should Equal    ${expected_http_status}
    ${is_publishable}=    Get Response Body
    [Return]    ${is_publishable}    # A SAPIBooleanResponse that is 'true' if the record is publishable, 'false' otherwise

Export Record To PDF
    [Arguments]    ${record_id}    ${entity_version_id}=${EMPTY}    ${expectedHttpStatus}=200    # The id of the record to publish
    [Documentation]    GET : /services/1.0/records/{entityId}/pdf
    ...
    ...    Generates and returns a PDF representation of the given record version. Permissions required: CREATE_PDF , OPEN_ OR EDIT_
    ...
    ...    *Arguments*
    ...
    ...    $(record_id) The id of the record to publish
    ...
    ...    ${entity_version_id} the entity version id. If not specified the latest version is assumed.
    ...
    ...    ${expectedHttpStatus} Optional parameter set to 200 by default
    ...
    ...
    ...    *Return value*
    ...
    ...    The bytes of the generated PDF
    ...
    ...    *Precondition*
    ...
    ...    The user must have a lock on the record and CREATE_PDF , OPEN_ OR EDIT_ permission
    ...
    ...    *Example*
    HTTP Header Setup
    ${url}=    Set Variable    ${RECORD SERVICE ENDPOINT}/${record_id}/pdf
    ${url}=    Set Variable If    '${entity_version_id}'!='${EMPTY}'    ${RECORD SERVICE ENDPOINT}/${record_id}/pdf?entityVersionId=${entity_version_id}    ${url}
    Next Request May Not Succeed
    GET    ${url}
    Response Status Code Should Equal    ${expectedHttpStatus}
    ${pdf_bytes}=    Get Response Body
    [Return]    ${pdf_bytes}    # The bytes of the PDF

Record Outline
    [Arguments]    ${entity_id}    ${entity_version_id}    ${expected_http_status}=200
    [Documentation]    GET : /services/1.0/records/{entityId}
    ...
    ...    Returns the record outline information for the specified entity.
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id} The entity id
    ...
    ...    ${entity_version_id} The entity version id
    ...
    ...    *Return value*
    ...
    ...    ${outline} SAPIRecordOutlineDto, a record outline object
    ...
    ...    *Precondition*
    ...
    ...
    ...    *Example*
    ...
    ...    SAPIRecordOutline DTO :
    ...
    ...    <?xml version="1.0" encoding="UTF-8"?>
    ...    <recordOutline xmlns="http://entity.services.ewb.idbs.com">
    ...    <entityDto>
    ...    <entityCore>
    ...    <entityId>...</entityId>
    ...    <visibleUniqueId>...</visibleUniqueId>
    ...    <viewableInEntityId>...</viewableInEntityId>
    ...    <entityTypeName>...</entityTypeName>
    ...    <entityNature>...</entityNature>
    ...    <nodeDisplayText>...</nodeDisplayText>
    ...    <entityName>...</entityName>
    ...    <publishedFlag>...</publishedFlag>
    ...    <lockedAgainstEdit>...</lockedAgainstEdit>
    ...    <iconUrl>...</iconUrl>
    ...    </entityCore>
    ...    <attributes>
    ...    <attribute name="..." caption="...">
    ...    <values>
    ...    <value>...</value>
    ...    <value>...</value>
    ...    <!--...more "value" elements...-->
    ...    </values>
    ...    <links>
    ...    <link name="..." id="..." versionId="..." />
    ...    <link name="..." id="..." versionId="...">
    ...    <!--...-->
    ...    </link>
    ...    <!--...more "link" elements...-->
    ...    </links>
    ...    <displayValues>
    ...    <value>...</value>
    ...    <value>...</value>
    ...    <!--...more "value" elements...-->
    ...    </displayValues>
    ...    </attribute>
    ...    <attribute name="..." caption="...">
    ...    <!--...-->
    ...    </attribute>
    ...    <!--...more "attribute" elements...-->
    ...    </attributes>
    ...    <signatures>
    ...    <signature>
    ...    <userName>...</userName>
    ...    <timestamp>...</timestamp>
    ...    <reason>...</reason>
    ...    <additionalComment>...</additionalComment>
    ...    <legalStatement>...</legalStatement>
    ...    <role>...</role>
    ...    <imageUrl>...</imageUrl>
    ...    </signature>
    ...    <signature>
    ...    <!--...-->
    ...    </signature>
    ...    <!--...more "signature" elements...-->
    ...    </signatures>
    ...    <versionInfo>
    ...    <versionState>...</versionState>
    ...    <versionNumber>...</versionNumber>
    ...    <versionId>...</versionId>
    ...    <timeSaved>...</timeSaved>
    ...    <userName>...</userName>
    ...    <userFullName>...</userFullName>
    ...    <authorComment>...</authorComment>
    ...    <authorAdditionalComment>...</authorAdditionalComment>
    ...    <witness>...</witness>
    ...    <witnessComment>...</witnessComment>
    ...    <witnessAdditionalComment>...</witnessAdditionalComment>
    ...    </versionInfo>
    ...    <path>
    ...    <pathElement>
    ...    <entityName>...</entityName>
    ...    <entityId>...</entityId>
    ...    </pathElement>
    ...    <pathElement>
    ...    <!--...-->
    ...    </pathElement>
    ...    <!--...more "pathElement" elements...-->
    ...    </path>
    ...    <dataInfo>
    ...    <dataInfo mimeType="..." dataType="..." fileType="..." numberOfSections="..." />
    ...    </dataInfo>
    ...    <previewInfo>
    ...    <dataInfo mimeType="..." dataType="..." fileType="..." numberOfSections="..." />
    ...    </previewInfo>
    ...    <tags>
    ...    <tag>
    ...    <tagId>...</tagId>
    ...    <tag>...</tag>
    ...    <username>...</username>
    ...    <timestamp>...</timestamp>
    ...    </tag>
    ...    <tag>
    ...    <!--...-->
    ...    </tag>
    ...    <!--...more "tag" elements...-->
    ...    </tags>
    ...    <permissions>
    ...    <canEditTags>...</canEditTags>
    ...    <canEditAnyTag>...</canEditAnyTag>
    ...    <canEditComments>...</canEditComments>
    ...    <canEditAnyComment>...</canEditAnyComment>
    ...    </permissions>
    ...    <comments>
    ...    <comments>
    ...    <id>...</id>
    ...    <value>...</value>
    ...    <userName>...</userName>
    ...    <createdTime>...</createdTime>
    ...    <modifiedTime>...</modifiedTime>
    ...    <version>...</version>
    ...    <children>
    ...    <!--...-->
    ...    </children>
    ...    </comments>
    ...    <comments>
    ...    <!--...-->
    ...    </comments>
    ...    <!--...more "comments" elements...-->
    ...    </comments>
    ...    <children>
    ...    <entity>
    ...    <!--...-->
    ...    </entity>
    ...    <entity>
    ...    <!--...-->
    ...    </entity>
    ...    <!--...more "entity" elements...-->
    ...    </children>
    ...    </entityDto>
    ...    <creationInfo>
    ...    <createdByUserFullName>...</createdByUserFullName>
    ...    <timeCreated>...</timeCreated>
    ...    </creationInfo>
    ...    <documentPanelAttributesArrangement verticalPosition="...">
    ...    <left>
    ...    <attributeReference>
    ...    <attributeName>...</attributeName>
    ...    <systemAttribute key="..." />
    ...    </attributeReference>
    ...    <attributeReference>
    ...    <!--...-->
    ...    </attributeReference>
    ...    <!--...more "attributeReference" elements...-->
    ...    </left>
    ...    <right>
    ...    <attributeReference>
    ...    <attributeName>...</attributeName>
    ...    <systemAttribute key="..." />
    ...    </attributeReference>
    ...    <attributeReference>
    ...    <!--...-->
    ...    </attributeReference>
    ...    <!--...more "attributeReference" elements...-->
    ...    </right>
    ...    <textFormat>
    ...    <titlesFormat>...</titlesFormat>
    ...    <valuesFormat>...</valuesFormat>
    ...    </textFormat>
    ...    </documentPanelAttributesArrangement>
    ...    <recordMetadataArrangement>
    ...    <iconUrl>...</iconUrl>
    ...    <attributesArrangement>
    ...    <headerLeft>
    ...    <attributeReference>
    ...    <attributeName>...</attributeName>
    ...    <systemAttribute key="..." />
    ...    </attributeReference>
    ...    <attributeReference>
    ...    <!--...-->
    ...    </attributeReference>
    ...    <!--...more "attributeReference" elements...-->
    ...    </headerLeft>
    ...    <headerRight>
    ...    <attributeReference>
    ...    <attributeName>...</attributeName>
    ...    <systemAttribute key="..." />
    ...    </attributeReference>
    ...    <attributeReference>
    ...    <!--...-->
    ...    </attributeReference>
    ...    <!--...more "attributeReference" elements...-->
    ...    </headerRight>
    ...    <footerLeft>
    ...    <attributeReference>
    ...    <attributeName>...</attributeName>
    ...    <systemAttribute key="..." />
    ...    </attributeReference>
    ...    <attributeReference>
    ...    <!--...-->
    ...    </attributeReference>
    ...    <!--...more "attributeReference" elements...-->
    ...    </footerLeft>
    ...    <footerRight>
    ...    <attributeReference>
    ...    <attributeName>...</attributeName>
    ...    <systemAttribute key="..." />
    ...    </attributeReference>
    ...    <attributeReference>
    ...    <!--...-->
    ...    </attributeReference>
    ...    <!--...more "attributeReference" elements...-->
    ...    </footerRight>
    ...    <textFormat>
    ...    <titlesFormat>...</titlesFormat>
    ...    <valuesFormat>...</valuesFormat>
    ...    </textFormat>
    ...    </attributesArrangement>
    ...    </recordMetadataArrangement>
    ...    <signatureTextFormat>
    ...    <titlesFormat>...</titlesFormat>
    ...    <valuesFormat>...</valuesFormat>
    ...    </signatureTextFormat>
    ...    <versionSaveConfiguration>
    ...    <dualCredentialSave>...</dualCredentialSave>
    ...    <allowAdditionalCommentsForVersionSave>...</allowAdditionalCommentsForVersionSave>
    ...    <allowAdditionalCommentsForSignOff>...</allowAdditionalCommentsForSignOff>
    ...    </versionSaveConfiguration>
    ...    </recordOutline>
    XML HTTP Header Setup
    Next Request May Not Succeed
    GET    ${RECORD SERVICE ENDPOINT}/${entity_id}?entityVersionId=${entity_version_id}
    Response Status Code Should Equal    ${expected_http_status}
    ${outline}=    Get Response Body
    [Return]    ${outline}    # SAPIRecordOutlineDto a record outline object

Get Published Record PDF
    [Arguments]    ${entity_id}    ${entity_version_id}    ${pdf_version}=PDF_1_4    ${expected_http_status}=200
    [Documentation]    GET : /services/1.0/records/{entityId}/publish/pdf
    ...
    ...    Retrieves the PDF that was created when a record was published.
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id} The entity id (eg. experiment id)
    ...
    ...    ${entity_version_id} The entity version id
    ...
    ...    ${pdf_version} the version of the PDF to retrieve(SAPIPdfVersion)
    ...
    ...    e.g. PDF_A (default PDF_1_4).
    ...    Supported PDF versions are: PDF_1_4 and PDF_A.
    ...
    ...    *Return value*
    ...
    ...    ${pdf} the bytes of the retrieved PDF
    ...
    ...    *Precondition*
    ...
    ...
    ...    *Example*
    HTTP Header Setup
    ${version}=    Set Variable If    '${pdf_version}'!='${EMPTY}'    ${pdf_version}    PDF_1_4
    Next Request May Not Succeed
    GET    ${RECORD SERVICE ENDPOINT}/${entity_id}/publish/pdf?entityVersionId=${entity_version_id}&pdfVersion=${version}
    Response Status Code Should Equal    ${expected_http_status}
    ${pdf}=    Get Response Body
    [Return]    ${pdf}    # the bytes of the retrieved PDF

Must Use Template
    [Arguments]    ${parent_id}    ${expected_http_status}=200
    [Documentation]    GET : /services/1.0/records/{parentId}/template/mandate
    ...
    ...    Checks if template is required for new record entity creation.
    ...
    ...    *Arguments*
    ...
    ...    ${parent_id} The parent entity id
    ...
    ...
    ...    *Return value*
    ...
    ...    ${result} SAPIResponseStatus, True if template is required
    ...
    ...    *Precondition*
    ...
    ...
    ...    *Example*
    XML HTTP Header Setup
    Next Request May Not Succeed
    GET    ${RECORD SERVICE ENDPOINT}/${parent_id}/template/mandate
    Response Status Code Should Equal    ${expected_http_status}
    ${result}=    Get Response Body
    [Return]    ${result}    # SAPIResponseStatus : true if required

Can Use Template
    [Arguments]    ${parent_id}    ${template_id}    ${entity_type}    ${expected_http_status}=200
    [Documentation]    GET : /services/1.0/records/{parentId}/template/validate
    ...
    ...    Checks if template is valid for new entity creation.
    ...
    ...    *Arguments*
    ...
    ...    ${parent_id} The parent entity id
    ...
    ...    ${template_id} The template id
    ...
    ...    ${entity_type} the entity type
    ...
    ...    *Return value*
    ...
    ...    ${result} SAPITemplateValidationResponse, True if template is valid
    ...
    ...    *Precondition*
    ...
    ...
    ...    *Example*
    HTTP Header Setup
    Next Request May Not Succeed
    GET    ${RECORD SERVICE ENDPOINT}/${parent_id}/template/validate?templateId=${template_id}&entityType=${entity_type}
    Response Status Code Should Equal    ${expected_http_status}
    ${result}=    Get Response Body
    [Return]    ${result}    # SAPITemplateValidationResponse: true if valid

Get Root Entities
    [Arguments]    ${entity_type}    ${include_type}=${EMPTY}    ${exclude_child}=${EMPTY}    ${expected_http_status}=200
    [Documentation]    GET : /services/1.0/records/{parentId}/templatetree
    ...
    ...    Returns the list of root entities for template selection.
    ...    Optional filters can be specified to limit the scope of the results.
    ...
    ...    ***note: at the moment, the parent id is not used as there are no root entities of type RECORD_NATURE
    ...
    ...    *Arguments*
    ...
    ...    ${parent_id} The parent entity id. \ This is the location in the hierachy where you are creating the new record entity (from a template)
    ...
    ...    ${entity_type} the entity type
    ...
    ...    ${include type} The entity type to filter the results.
    ...    Only the entities that can contain included entity type will be returned.
    ...
    ...    ${exclude child} The entity type name of the child entities to avoid in the results. Entities that contain or can contain excluded entity type will not be returned.
    ...
    ...    *Return value*
    ...
    ...    ${root_entities} The list of the root entities as a SAPIEntityCoreSequence
    ...
    ...    *Precondition*
    ...
    ...
    ...    *Example*
    XML HTTP Header Setup
    ${url}=    Set Variable    ${RECORD SERVICE ENDPOINT}/{parentId}/templatetree?entityType=${entity_type}
    ${url}=    Set Variable If    '${include_type}'!='${EMPTY}'    ${url}&includeType=${include_type}    ${url}
    ${url}=    Set Variable If    '${exclude_child}'!='${EMPTY}'    ${url}&excludeChild=${exclude_child}    ${url}
    Next Request May Not Succeed
    GET    ${url}
    Response Status Code Should Equal    ${expected_http_status}
    ${root_entities}=    Get Response Body
    [Return]    ${root_entities}    # The list of the root entities as a SAPIEntityCoreSequence

Get Entity Children
    [Arguments]    ${parent_id}    ${entity_id}    ${entity_type}    ${include_type}=${EMPTY}    ${exclude_child}=${EMPTY}    ${expected_http_status}=200
    [Documentation]    GET : /services/1.0/records/{parentId}/templatetree/{entityId}
    ...
    ...    Returns the list of child entities for template selection.
    ...    Optional filters can be specified to limit the scope of the results.
    ...
    ...    *Arguments*
    ...
    ...    ${parent_id} The parent entity id. \ This is the location in the hierarchy where a new entity is to be created.
    ...
    ...    ${entity_id} the entity id. \ This is the parent id of the template you wish to use (to create a new entity)
    ...
    ...    ${entity_type} the entity type
    ...
    ...    ${include type} The entity type to filter the results.
    ...    Only the entities that can contain included entity type will be returned.
    ...
    ...    ${exclude child} The entity type name of the child entities to avoid in the results. Entities that contain or can contain excluded entity type will not be returned.
    ...
    ...    *Return value*
    ...
    ...    ${child_entities} The list of the child entities as a SAPIEntityCoreSequence
    ...
    ...    *Precondition*
    ...
    ...
    ...    *Example*
    XML HTTP Header Setup
    ${url}=    Set Variable    ${RECORD SERVICE ENDPOINT}/${parent_id}/templatetree/${entity_id}?entityType=${entity_type}
    ${url}=    Set Variable If    '${include_type}'!='${EMPTY}'    ${url}&includeType=${include_type}    ${url}
    ${url}=    Set Variable If    '${exclude_child}'!='${EMPTY}'    ${url}&excludeChild=${exclude_child}    ${url}
    Next Request May Not Succeed
    GET    ${url}
    Response Status Code Should Equal    ${expected_http_status}
    ${child_entities}=    Get Response Body
    [Return]    ${child_entities}    # The list of the child entities as a SAPIEntityCoreSequence

Set Read Only
    [Arguments]    ${entity_id}    ${expected_http_status}=204
    [Documentation]    PUT : /services/1.0/records/{entityId}/readonly
    ...
    ...    Marks a record as read only.
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id} The entity id
    ...
    ...
    ...    *Return value*
    ...
    ...
    ...    *Precondition*
    ...
    ...    The entity must be locked before the read only status can be set
    ...
    ...    *Example*
    HTTP Header Setup
    Next Request May Not Succeed
    PUT    ${RECORD SERVICE ENDPOINT}/${entity_id}/readonly
    Response Status Code Should Equal    ${expected_http_status}
    ${response}=    Get Response Body
    [Return]    ${response}

Clear Read Only
    [Arguments]    ${entity_id}    ${expected_http_status}=204
    [Documentation]    DELETE : /services/1.0/records/{entityId}/readonly
    ...
    ...    Removes the read only status for a record.
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id} The entity id
    ...
    ...
    ...    *Return value*
    ...
    ...
    ...    *Precondition*
    ...
    ...    The entity must not be locked prior to being deleted
    ...
    ...    *Example*
    HTTP Header Setup
    Next Request May Not Succeed
    DELETE    ${RECORD SERVICE ENDPOINT}/${entity_id}/readonly
    Response Status Code Should Equal    ${expected_http_status}
    ${response}=    Get Response Body
    [Return]    ${response}

Add Signatures
    [Arguments]    ${record_id}    ${document_id}    ${reason}='Signing Reason'    ${additional_comment}='Signing Additional Reason'    ${omit_request_body}=False    ${expected_http_status}=204
    [Documentation]    POST : /services/1.0/records/{entityId}/signatures
    ...
    ...    Signs a single document in a record.
    ...
    ...    *Arguments*
    ...
    ...    _record_id_ The id of the record containing the document to be signed.
    ...
    ...    _document_id_ The id of the document to be signed.
    ...
    ...    _reason_ \ Signing reason (default='Signing Reason')
    ...
    ...    _additonal_comment_ Any additional signing reason (default='Signing Additional Reason')
    ...
    ...    _omit_request_body_ Do not write a request body (default=false)
    ...
    ...    _expected_http_status_ Expected return status for the request (default=204)
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    The document must be versioned
    ...
    ...    *Example*
    HTTP Header Setup
    ${encoded}=    Base64 Encode String    ${SERVICES USERNAME}:${SERVICES PASSWORD}
    ${authorization}=    Set Variable    BASIC ${encoded}
    Set Request Header    X-Web-Client-Author-Credentials    ${authorization}
    Log    ${omit_request_body}    INFO
    ${payload}=    Set Variable If    ${omit_request_body}==True    ${EMPTY}    { "signer": { "reason": "${reason}", "additionalComment": "${additional_comment}" }, "entities": { "id": [ "${document_id}" \ ] }, "role": "Actioner" }
    Set Request Body    ${payload}
    Next Request May Not Succeed
    POST    ${RECORD SERVICE ENDPOINT}/${record_id}/signatures
    Response Status Code Should Equal    ${expected_http_status}
    ${response}=    Get Response Body
    [Return]    ${response}

Add Signatures as reviewer
    [Arguments]    ${record_id}    ${document_id}    ${reason}='Signing Reason'    ${additional_comment}='Signing Additional Reason'    ${omit_request_body}=False    ${expected_http_status}=204
    [Documentation]    POST : /services/1.0/records/{entityId}/signatures
    ...
    ...    Signs a single document in a record.
    ...
    ...    *Arguments*
    ...
    ...    _record_id_ The id of the record containing the document to be signed.
    ...
    ...    _document_id_ The id of the document to be signed.
    ...
    ...    _reason_ \ Signing reason (default='Signing Reason')
    ...
    ...    _additonal_comment_ Any additional signing reason (default='Signing Additional Reason')
    ...
    ...    _omit_request_body_ Do not write a request body (default=false)
    ...
    ...    _expected_http_status_ Expected return status for the request (default=204)
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    The document must be versioned
    ...
    ...    *Example*
    HTTP Header Setup With Custom User    ${SECOND USER}    ${SECOND PASSWD}
    ${encoded}=    Base64 Encode String    ${SECOND USER}:${SECOND PASSWD}
    ${authorization}=    Set Variable    BASIC ${encoded}
    Set Request Header    X-Web-Client-Author-Credentials    ${authorization}
    Log    ${omit_request_body}    INFO
    ${payload}=    Set Variable If    ${omit_request_body}==True    ${EMPTY}    { "signer": { "reason": "${reason}", "additionalComment": "${additional_comment}" }, "entities": { "id": [ "${document_id}" \ ] }, "role": "Reviewer" }
    Set Request Body    ${payload}
    Next Request May Not Succeed
    POST    ${RECORD SERVICE ENDPOINT}/${record_id}/signatures
    Response Status Code Should Equal    ${expected_http_status}
    ${response}=    Get Response Body
    [Return]    ${response}
