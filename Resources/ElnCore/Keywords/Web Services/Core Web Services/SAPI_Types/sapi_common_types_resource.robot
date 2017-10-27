*** Settings ***
Documentation     This resources provides keywords for building SAPI types as defined in common.xsd XML schemas
Library           XMLLibrary
Resource          ../../../Common/XML Common/xml_common_resource.robot    # Utilities for manipulating XML

*** Variables ***
${COMMON_XMLNS}    http://common.services.ewb.idbs.com

*** Keywords ***
Build SAPIIdSequence
    [Arguments]    @{ids}
    [Documentation]    Build the SAPIIdSequence as XML Object
    ...
    ...    *Arguments*
    ...
    ...    _ids_ - the list of ids
    ...
    ...    *Return value*
    ...
    ...    The SAPIIdSequence as XML Object
    ...
    ...    *Precondition*
    ...
    ...    *Example*
    ${sapi_id_sequence_node}=    XMLLibrary.Create Xml Object    ids    ${COMMON_XMLNS}
    # Loops over @{ids} list and creates attribute nodes
    : FOR    ${id}    IN    @{ids}
    \    ${id_node}=    XMLLibrary.Create Xml Object    id
    \    ${id_node}=    XMLLibrary.Set Element Attribute    ${id_node}    id    ${id}
    \    ${sapi_id_sequence_node}=    Xml_Common_Resource.Add Subelement To Xml    ${sapi_id_sequence_node}    ${id_node}
    # Logging created XML
    ${xml}=    XMLLibrary.Get Xml    ${sapi_id_sequence_node}    ${COMMON_XMLNS}
    Log    ${xml}
    [Return]    ${sapi_id_sequence_node}    # the SAPISignOff as XML Object
