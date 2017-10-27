*** Settings ***
Documentation     This resources provides keywords for building SAPI types as defined in cacheentities.xsd XML schemas
Library           XMLLibrary
Resource          ../../../Common/XML Common/xml_common_resource.robot    # Utilities for manipulating XML
Library           Collections

*** Variables ***
${CACHE_XMLNS}    http://cacheentity.services.ewb.idbs.com

*** Keywords ***
Build SAPIInboxDetailSequence
    [Arguments]    @{inbox_detail_list}    # Each element argument MUST be provided as scalar, e.g. ${details1} | ${details2}
    [Documentation]    Build the SAPIInboxDetailSequence to add inbox items to a record
    ...
    ...    *Arguments*
    ...
    ...    _inbox_detail_list_ - the list of inbox details. Each element argument MUST be provided as scalar, e.g. ${details1} | ${details2}. Each inbox detail element is a list with the following item (order matters): inbox entity id, entity type .name, file name, mime type, data type. See example.
    ...
    ...    *Return value*
    ...
    ...    The SAPIInboxDetailSequence as XML literal
    ...
    ...    *Precondition*
    ...
    ...    *Example*
    ...
    ...    @{inbox_detail_1}= Create List ${inboxId1} ${typeName1} ${fileName1} ${mimeType1} ${dataType1}
    ...
    ...    @{inbox_detail_2}= Create List ${inboxId2} ${typeName2} ${fileName2} ${mimeType2} ${dataType2}
    ...
    ...    ${xml}= Build SAPIInboxDetailSequence ${inbox_detail_1} ${inbox_detail_2} \
    ${list_of_inbox_detail_node}=    Create List
    : FOR    ${inbox_detail}    IN    @{inbox_detail_list}
    \    @{inbox_detail_paramaters}=    Collections.Convert To List    ${inbox_detail}
    \    ${inbox_entity_id}=    Set Variable    @{inbox_detail_paramaters}[0]
    \    ${entity_type}=    Set Variable    @{inbox_detail_paramaters}[1]
    \    ${file_type}=    Set Variable    @{inbox_detail_paramaters}[2]
    \    ${mime_type}=    Set Variable    @{inbox_detail_paramaters}[3]
    \    ${data_type}=    Set Variable    @{inbox_detail_paramaters}[4]
    \    ${sapi_inbox_detail_node}=    Build SAPIInboxDetail    ${inbox_entity_id}    ${entity_type}    ${file_type}    ${mime_type}
    \    ...    ${data_type}
    \    Collections.Append To List    ${list_of_inbox_detail_node}    ${sapi_inbox_detail_node}
    @{nodes}=    Collections.Convert To List    ${list_of_inbox_detail_node}
    ${sapi_inbox_detail_sequence_node}=    create xml object    inboxDetailSequence    elementNamespace=${CACHE_XMLNS}
    ${sapi_inbox_detail_sequence_node}=    Add List Of Subelements To Xml    ${sapi_inbox_detail_sequence_node}    @{nodes}
    [Return]    ${sapi_inbox_detail_sequence_node}    # the SAPISignOff as XML Object

Build SAPIInboxDetail
    [Arguments]    ${inbox_entity_id}    ${entity_type}    ${file_type}    ${mime_type}    ${data_type}
    [Documentation]    Build the SAPIInboxDetail as XML Object
    ...
    ...    *Arguments*
    ...
    ...    _inbox_entity_id_ - the id of the entity in the inbox
    ...
    ...    _entity_type_ - the desired type of the entity that will be created (e.g. DOCUMENT, or TEXT_DOCUMENT)
    ...
    ...    _file_type_ - the desired file type (extension) of the content
    ...
    ...    _mime_type_ - \ the desired mime type of the content
    ...
    ...    _data_type_ - the desired data type of the content (used to determine the renderer to use when viewing in a record, e.g. HTML_TEXT, or PLAIN_TEXT)
    ...
    ...    *Returns*
    ...
    ...    the SAPIInboxDetail as XML Object
    ...
    ...    *Example*
    ...
    ...    | ${detail1}= | Create inbox item detail | ${id} | TEXT_DOCUMENT | .html | text/html | HTML_TEXT
    ...    | ${detail2}= | Create inbox item detail | ${id} | DOCUMENT | .png| image/png | PNG_IMAGE
    ...    | ${detail_sequence} = | Create inbox item detail sequence | ${detail1} | ${detail2}
    ${sapi_inbox_detail_node}=    Create Xml Object    item    elementNamespace=${CACHE_XMLNS}
    ${xml}=    Create Xml Object    inboxId    elementText=${inbox_entity_id}    elementNamespace=${CACHE_XMLNS}
    ${sapi_inbox_detail_node}=    XMLLibrary.Add Subelement To Xml    ${sapi_inbox_detail_node}    ${xml}
    ${xml}=    Create Xml Object    entityTypeName    elementText=${entity_type}    elementNamespace=${CACHE_XMLNS}
    ${sapi_inbox_detail_node}=    XMLLibrary.Add Subelement To Xml    ${sapi_inbox_detail_node}    ${xml}
    ${xml}=    Create Xml Object    fileType    elementText=${file_type}    elementNamespace=${CACHE_XMLNS}
    ${sapi_inbox_detail_node}=    XMLLibrary.Add Subelement To Xml    ${sapi_inbox_detail_node}    ${xml}
    ${xml}=    Create Xml Object    mimeType    elementText=${mime_type}    elementNamespace=${CACHE_XMLNS}
    ${sapi_inbox_detail_node}=    XMLLibrary.Add Subelement To Xml    ${sapi_inbox_detail_node}    ${xml}
    ${xml}=    Create Xml Object    dataType    elementText=${data_type}    elementNamespace=${CACHE_XMLNS}
    ${sapi_inbox_detail_node}=    XMLLibrary.Add Subelement To Xml    ${sapi_inbox_detail_node}    ${xml}
    [Return]    ${sapi_inbox_detail_node}    # the SAPIInboxDetail as XML Object
