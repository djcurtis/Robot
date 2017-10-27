*** Settings ***
Documentation     This resources provides keywords for building SAPI types as defined in entities.xsd XML schemas
Library           String
Library           XMLLibrary
Resource          ../../XML Common/xml_common_resource.txt    # Utilities for manipulating XML
Resource          sapi_common_types_resource.txt    # SAPI Common types builders
Resource          ../../../Libraries/XML Common/xml_common_resource.txt

*** Variables ***
${ENTITY_XMLNS}    http://entity.services.ewb.idbs.com

*** Keywords ***
Build SAPIEntityDefinition
    [Arguments]    ${entity_type}    ${entity_name}    ${sapi_data_update_info}=${EMPTY}    ${sapi_attribute_update_sequence}=${EMPTY}
    [Documentation]    Build the SAPIEntityDefinition as XML Object
    ...
    ...    *Arguments*
    ...
    ...    _entity_type_ - the entity type, e.g. FILE, EXPERIMENT, DOCUMENT
    ...
    ...    _entity_name_ - the entity name
    ...
    ...    _sapi_data_update_info_ - the SAPIDataUpdateInfo as XML Object. Default value is ${None}
    ...
    ...    _sapi_attribute_update_sequence_ - the SAPIAttributeUpdateSequence as XML Object. Default value is ${None}
    ...
    ...    *Return value*
    ...
    ...    The SAPIEntityDefinition as XML Object
    ...
    ...    *Precondition*
    ...
    ...    *Example*
    ${entity_definition_node}=    XMLLibrary.Create Xml Object    entityDefinition    ${ENTITY_XMLNS}
    ${entity_type_node}=    XMLLibrary.Create Xml Object    entityType    ${ENTITY_XMLNS}    ${entity_type}
    ${entity_name_node}=    XMLLibrary.Create Xml Object    entityName    ${ENTITY_XMLNS}    ${entity_name}
    ${entity_definition_node}=    XMLLibrary.Add Subelement To Xml    ${entity_definition_node}    ${entity_type_node}
    ${entity_definition_node}=    XMLLibrary.Add Subelement To Xml    ${entity_definition_node}    ${entity_name_node}
    # Adds data_update_info element
    ${entity_definition_node}=    Xml_Common_Resource.Add Subelement To Xml    ${entity_definition_node}    ${sapi_data_update_info}
    # Adds attribute_update_sequence element
    ${entity_definition_node}=    Xml_Common_Resource.Add Subelement To Xml    ${entity_definition_node}    ${sapi_attribute_update_sequence}
    [Return]    ${entity_definition_node}    # The SAPIEntityDefinition as XML Object

Build SAPIDataUpdate
    [Arguments]    ${data_text}=${EMPTY}    ${data_binary}=${EMPTY}
    [Documentation]    Build the SAPIDataUpdate as XML Object
    ...
    ...    *Arguments*
    ...
    ...    _data_text_ - the text data as UTF-8 literal
    ...
    ...    _data_binay_ - the binary data as Base64 encoded literal
    ...
    ...
    ...    *Return value*
    ...
    ...    The SAPIDataUpdate as XML Object
    ...
    ...    *Precondition*
    ...
    ...    *Example*
    ${sapi_data_update_node}=    XMLLibrary.Create Xml Object    data    ${ENTITY_XMLNS}
    # Adds text node
    ${double_quote_free_string}=    String.Replace String    ${data_text}    "    '
    ${data_text_node}=    Run Keyword If    "${double_quote_free_string}" != "${EMPTY}"    XMLLibrary.Create Xml Object    dataText    ${ENTITY_XMLNS}    ${data_text}
    ${sapi_data_update_node}=    Xml_Common_Resource.Add Subelement To Xml    ${sapi_data_update_node}    ${data_text_node}
    # Adds binary node
    ${double_quote_free_string}=    String.Replace String    ${data_binary}    "    '
    ${data_binary_node}=    Run Keyword If    "${double_quote_free_string}" != "${EMPTY}"    XMLLibrary.Create Xml Object    dataBinary    ${ENTITY_XMLNS}    ${data_binary}
    ${sapi_data_update_node}=    Xml_Common_Resource.Add Subelement To Xml    ${sapi_data_update_node}    ${data_binary_node}
    [Return]    ${sapi_data_update_node}    # The SAPIDataUpdate as XML Object

Build SAPIDataInfo
    [Arguments]    ${mime_type}    ${file_type}    ${data_type}
    [Documentation]    Build the SAPIDataInfo as XML Object
    ...
    ...    *Arguments*
    ...
    ...    _mime_type_- the data mime type, e.g. text/plain, application/x-url
    ...
    ...    _file_type_ - the data file type, e.g. .txt, .pdf
    ...
    ...    _data_type_ - the data type, e.g. WEB_LINK, FILE
    ...
    ...    *Return value*
    ...
    ...    The SAPIDataInfo as XML Object
    ...
    ...    *Precondition*
    ...
    ...    *Example*
    ${data_info_node}=    XMLLibrary.Create Xml Object    dataInfo    ${ENTITY_XMLNS}
    ${data_info_node}=    XMLLibrary.Set Element Attribute    ${data_info_node}    mimeType    ${mime_type}
    ${data_info_node}=    XMLLibrary.Set Element Attribute    ${data_info_node}    fileType    ${file_type}
    ${data_info_node}=    XMLLibrary.Set Element Attribute    ${data_info_node}    dataType    ${data_type}
    [Return]    ${data_info_node}    # The SAPIDataInfo as XML Object

Build SAPIDataUpdateInfo
    [Arguments]    ${sapi_data_update}=${EMPTY}    ${sapi_data_info}=${EMPTY}
    [Documentation]    Build the SAPIDataUpdateInfo as XML Object
    ...
    ...    *Arguments*
    ...
    ...    _sapi_data_update_ - the SAPIDataUpdate as XML Object. Default value is set to ${EMPTY}
    ...
    ...    _sapi_data_info_ - the SAPIDataInfo as XML Object. Default value is set to ${EMPTY}
    ...
    ...
    ...    *Return value*
    ...
    ...    The SAPIDataUpdateInfo as XML Object
    ...
    ...    *Precondition*
    ...
    ...    *Example*
    ${data_update_info_node}=    XMLLibrary.Create Xml Object    data    ${ENTITY_XMLNS}
    # Adds data_update element
    ${data_update_info_node}=    Xml_Common_Resource.Add Subelement To Xml    ${data_update_info_node}    ${sapi_data_update}
    # Adds data_info element
    ${data_update_info_node}=    Xml_Common_Resource.Add Subelement To Xml    ${data_update_info_node}    ${sapi_data_info}
    [Return]    ${data_update_info_node}    # The SAPIDataUpdate as XML Object

Build SAPIAttributeUpdateSequence
    [Arguments]    @{attributes}
    [Documentation]    Build the SAPIAttributeUpdateSequence as XML Object
    ...
    ...    *Arguments*
    ...
    ...    _attributes_ - a list of <attribute name, attribute value> pairs. Each cell is of the form attributeName=value
    ...
    ...    *Return value*
    ...
    ...    The SAPIAttributeUpdateSequence as XML Object
    ...
    ...    *Precondition*
    ...
    ...    *Example*
    ...
    ...    BuildSAPIAttributeUpdateSequence | title=myTitle | publishingState=Unpublished
    ${sapi_attribute_update_saquence_node}=    XMLLibrary.Create Xml Object    attributes    ${ENTITY_XMLNS}
    # Loops over @{attributes} list and creates attribute nodes
    : FOR    ${attribute_name_value}    IN    @{attributes}
    \    @{attribute}=    String.Split String    ${attribute_name_value}    =
    \    #    initializing nodes
    \    ${attribute_node}=    XMLLibrary.Create Xml Object    attribute
    \    ${name_node}=    XMLLibrary.Create Xml Object    name    ${ENTITY_XMLNS}    @{attribute}[0]
    \    ${values_node}=    XMLLibrary.Create Xml Object    values
    \    ${value_node}=    XMLLibrary.Create Xml Object    value    ${ENTITY_XMLNS}    @{attribute}[1]
    \    #    building xml structure
    \    ${values_node}=    Xml_Common_Resource.Add Subelement To Xml    ${values_node}    ${value_node}
    \    ${attribute_node}=    XMLLibrary.Add List Of Subelements To Xml    ${attribute_node}    ${name_node}    ${values_node}
    \    #    Adds the attribute node to attributes
    \    ${sapi_attribute_update_saquence_node}=    Xml_Common_Resource.Add Subelement To Xml    ${sapi_attribute_update_saquence_node}    ${attribute_node}
    ${sapi_attribute_update_saquence}=    Set Variable    ${sapi_attribute_update_saquence_node}
    [Return]    ${sapi_attribute_update_saquence}    # The SAPIAttributeUpdateSequence as XML Object

Build SAPICommit
    [Arguments]    ${entity_id}    ${version_type}    ${author_reason}=${EMPTY}    ${additional_comment}=${EMPTY}
    [Documentation]    Build the SAPICommit as XML Object
    ...
    ...    *Arguments*
    ...
    ...    _entity_id_ - the id of the record entity to commit
    ...
    ...    _version_type_ - the version type, i.e. DRAFT or VERSION
    ...
    ...    _author_reason_ - the author reason to commit. Not required for DRAFT save
    ...
    ...    _additional_comment_ - the author additional commnet. This is optional.
    ...
    ...    *Return value*
    ...
    ...    The SAPICommit as XML Object
    ...
    ...    *Precondition*
    ...
    ...    *Example*
    ${sapi_user_action_info}=    Run Keyword If    '${version_type}' == 'VERSION'    Build SAPIUserActionInfo    ${author_reason}    ${additional_comment}
    ${sapi_commit}=    XMLLibrary.Create Xml Object    commit    ${ENTITY_XMLNS}
    ${sapi_commit}=    XMLLibrary.Set Element Attribute    ${sapi_commit}    entityId    ${entity_id}
    ${sapi_commit}=    XMLLibrary.Set Element Attribute    ${sapi_commit}    entityVersionType    ${version_type}
    ${sapi_commit}=    Xml_Common_Resource.Add Subelement To Xml    ${sapi_commit}    ${sapi_user_action_info}
    [Return]    ${sapi_commit}    # The SAPICommit as XML Object

Build SAPIUserActionInfo
    [Arguments]    ${reason}    ${additional_comment}=${EMPTY}
    [Documentation]    Build the SAPIUserActionInfo as XML Object
    ...
    ...    *Arguments*
    ...
    ...    _reason_ - the reason for the action
    ...
    ...    _additional_comment_ - the author additional commnet. This is optional.
    ...
    ...    *Return value*
    ...
    ...    The SAPIUserActionInfo as XML Object
    ...
    ...    *Precondition*
    ...
    ...    *Example*
    ${sapi_user_action_info}=    XMLLibrary.Create Xml Object    userActionInfo    ${ENTITY_XMLNS}
    ${sapi_user_action_info}=    XMLLibrary.Set Element Attribute    ${sapi_user_action_info}    reason    ${reason}
    ${sapi_user_action_info}=    XMLLibrary.Set Element Attribute    ${sapi_user_action_info}    additionalComment    ${additional_comment}
    [Return]    ${sapi_user_action_info}    # The SAPIUserActionInfo as XML Object

Build SAPIReplaceEntityInfo
    [Arguments]    ${entity_definition_node}=${EMPTY}    ${existing_enity_info_node}=${EMPTY}
    [Documentation]    Build the SAPIReplaceEntityInfo as XML Object
    ...
    ...    *Arguments*
    ...
    ...    _entity_definition_node_ - the SAPIEntityDefinition as XML Object. Default value is ${EMPTY}
    ...
    ...    _existing_enity_info_node_ - the SAPIExistingEntityInfo as XML Object. Default value is ${EMPTY}
    ...
    ...    *Return value*
    ...
    ...    The SAPIReplaceEntityInfo as XML Object
    ...
    ...    *Precondition*
    ...
    ...    *Example*
    ${replace_entity_info_node}=    XMLLibrary.Create Xml Object    replaceEntityInfo    ${ENTITY_XMLNS}
    ${replace_entity_info_node}=    Xml_Common_Resource.Add Subelement To Xml    ${replace_entity_info_node}    ${entity_definition_node}
    ${replace_entity_info_node}=    Xml_Common_Resource.Add Subelement To Xml    ${replace_entity_info_node}    ${existing_enity_info_node}
    [Return]    ${replace_entity_info_node}    # The SAPIReplaceEntityInfo as XML Object

Build SAPIExistingEntityInfo
    [Arguments]    ${source_entity_id}    ${entity_name}=${EMPTY}    ${sapi_attribute_update_sequence}=${EMPTY}
    [Documentation]    Build the SAPIExistingEntityInfo as XML Object
    ...
    ...    *Arguments*
    ...
    ...    _source_entity_id_ - the id of the entity to use to replace an existing entity
    ...
    ...    _entity_name_ - the entity name
    ...
    ...    _sapi_attribute_update_sequence_ - the SAPIAttributeUpdateSequence as XML Object. Default value is ${None}
    ...
    ...    *Return value*
    ...
    ...    The SAPIExistingEntityInfo as XML Object
    ...
    ...    *Precondition*
    ...
    ...    *Example*
    ${existing_entity_info_node}=    XMLLibrary.Create Xml Object    existingEntityInfo    ${ENTITY_XMLNS}
    ${source_entity_id_node}=    XMLLibrary.Create Xml Object    sourceEntityId    ${ENTITY_XMLNS}    ${source_entity_id}
    ${entity_name_node}=    Run Keyword If    "${entity_name}" != "${EMPTY}"    XMLLibrary.Create Xml Object    entityName    ${ENTITY_XMLNS}    ${entity_name}
    ${existing_entity_info_node}=    Xml_Common_Resource.Add Subelement To Xml    ${existing_entity_info_node}    ${source_entity_id_node}
    ${existing_entity_info_node}=    Xml_Common_Resource.Add Subelement To Xml    ${existing_entity_info_node}    ${entity_name_node}
    ${existing_entity_info_node}=    Xml_Common_Resource.Add Subelement To Xml    ${existing_entity_info_node}    ${sapi_attribute_update_sequence}
    [Return]    ${existing_entity_info_node}    # the SAPIExistingEntityInfo as XML Object

Build SAPISignOff
    [Arguments]    ${role}    ${sapi_user_action_info_node}    ${sapi_id_sequence_node}
    [Documentation]    Build the SAPISignOff as XML Object
    ...
    ...    *Arguments*
    ...
    ...    ${role} | ${sapi_user_action_info_node} | ${sapi_id_sequence_node}
    ...
    ...    _role_ - the user role when signing, e.g., Reviewer or Actioner.
    ...
    ...    _sapi_user_action_info_node_ - the SAPIUserActionInfo as XML Object
    ...
    ...    _sapi_id_sequence_node_ - the SAPIIdUpdateSequence as XML Object
    ...
    ...    *Return value*
    ...
    ...    The SAPISignOff as XML Object
    ...
    ...    *Precondition*
    ...
    ...    *Example*
    ${sapi_sign_off_node}=    XMLLibrary.Create Xml Object    signOff    ${ENTITY_XMLNS}
    ${sapi_sign_off_node}=    XMLLibrary.Set Element Attribute    ${sapi_sign_off_node}    role    ${role}
    # Creates signer node by parsing ${sapi_user_action_info_node}
    ${sapi_user_action_info}=    XMLLibrary.Get Xml    ${sapi_user_action_info_node}    ${ENTITY_XMLNS}
    @{reason}=    XMLLibrary.Get Element Attribute    ${sapi_user_action_info}    userActionInfo    reason    ${ENTITY_XMLNS}
    @{additional_comment}=    XMLLibrary.Get Element Attribute    ${sapi_user_action_info}    userActionInfo    additionalComment    ${ENTITY_XMLNS}
    ${signer_node}=    XMLLibrary.Create Xml Object    signer    ${ENTITY_XMLNS}
    ${signer_node}=    XMLLibrary.Set Element Attribute    ${signer_node}    reason    @{reason}[0]
    ${signer_node}=    XMLLibrary.Set Element Attribute    ${signer_node}    additionalComment    @{additional_comment}[0]
    # Creates entities node by parsing ${sapi_id_sequence_node}
    ${entities_node}=    XMLLibrary.Create Xml Object    entities    ${ENTITY_XMLNS}
    ${sapi_id_sequence}=    XMLLibrary.Get Xml    ${sapi_id_sequence_node}    ${COMMON_XMLNS}
    @{ids}=    XMLLibrary.Get Element Attribute    ${sapi_id_sequence}    id    id    ${COMMON_XMLNS}
    : FOR    ${id}    IN    @{ids}
    \    ${id_node}=    XMLLibrary.Create Xml Object    id    ${COMMON_XMLNS}    ${id}
    \    ${entities_node}=    Xml_Common_Resource.Add Subelement To Xml    ${entities_node}    ${id_node}
    # Adds children
    ${sapi_sign_off_node}=    Xml_Common_Resource.Add Subelement To Xml    ${sapi_sign_off_node}    ${signer_node}
    ${sapi_sign_off_node}=    Xml_Common_Resource.Add Subelement To Xml    ${sapi_sign_off_node}    ${entities_node}
    [Return]    ${sapi_sign_off_node}    # the SAPISignOff as XML Object
