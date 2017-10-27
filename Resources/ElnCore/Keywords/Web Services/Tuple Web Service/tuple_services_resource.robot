*** Settings ***
Library           IDBSHttpLibrary
Library           String
Library           XMLLibrary
Library           Collections
Resource           ../../Common/common_resource.robot    # Common Resources
Library           TestDataGenerationLibrary
#Library           ../../CatalogExportParsingLibrary/
#Library           ../../CatalogWebserviceGUIDLibrary/
Library           CheckLibrary
Library           OperatingSystem
# Library           OracleLibrary
#Resource          ../Query Web Service/query_resources.robot

*** Variables ***
${TUPLEURL}       /landscape/services/1.0/data/tuples/F20A56DFC63C4A00990B2C9B1194A334/3bd5d980b46611e184a20025649342bb/8d88c7fab7fa4c22b30a5307905ef1cf/6f0b8ce443e64c24849678522f34f011
${NON-BATCH END}    /landscape/services/1.0/data/tuples/%2A
${BATCH END}      /landscape/services/1.0/data/batch/%2A
${XMLNS2}         http://batch.hubtech.services.ewb.idbs.com
${XMLSNS3}        http://configuration.hubtech.services.ewb.idbs.com
${XMLNS4}         http://tuple.hubtech.services.ewb.idbs.com
${XMLNS5}         http://query.hubtech.services.ewb.idbs.com
${BATCH XML REQUEST HEADER}    <?xml version="1.0" encoding="UTF-8" standalone="yes"?><request xmlns:ns2="http://batch.hubtech.services.ewb.idbs.com" xmlns="http://tuple.hubtech.services.ewb.idbs.com" xmlns:ns4="http://auditing.hubtech.services.ewb.idbs.com" xmlns:ns3="http://hubtech.services.ewb.idbs.com" xmlns:ns9="http://query.hubtech.services.ewb.idbs.com" xmlns:ns5="http://configuration.hubtech.services.ewb.idbs.com" xmlns:ns6="http://rules.hubtech.services.ewb.idbs.com" xmlns:ns7="http://notification.hubtech.services.ewb.idbs.com" xmlns:ns8="http://common.hubtech.services.ewb.idbs.com"><ns3:description>some description</ns3:description><ns3:batch><ns2:batchOperationRequests>
${BATCH XML REQUEST FOOTER}    </ns2:batchOperationRequests><ns2:isTestOnly>false</ns2:isTestOnly><ns2:isAsTransaction>false</ns2:isAsTransaction></ns3:batch></request>
${XMLNS REQUEST COMMON}    http://common.hubtech.services.ewb.idbs.com
${XMLNS REQUEST RULES}    http://rules.hubtech.services.ewb.idbs.com
${XMLNS REQUEST CONFIGURATION}    http://configuration.hubtech.services.ewb.idbs.com
${XMLNS REQUEST HUBTECH}    http://hubtech.services.ewb.idbs.com
${XMLNS REQUEST AUDITING}    http://auditing.hubtech.services.ewb.idbs.com
${XMLNS REQUEST BATCH}    http://batch.hubtech.services.ewb.idbs.com
${XMLNS REQUEST QUERY}    http://query.hubtech.services.ewb.idbs.com
${XMLNS REQUEST NOTIFICATION}    http://notification.hubtech.services.ewb.idbs.com
${XMLNS REQUEST TUPLE}    http://tuple.hubtech.services.ewb.idbs.com
${XMLNS RESPONSE BATCH}    http://batch.hubtech.services.ewb.idbs.com    # Currently ns2
${XMLNS RESPONSE CONFIGURATION}    http://configuration.hubtech.services.ewb.idbs.com
${XMLNS RESPONSE TUPLE}    http://tuple.hubtech.services.ewb.idbs.com    # Currently ns4
${XMLNS RESPONSE QUERY}    http://query.hubtech.services.ewb.idbs.com
${BATCH XMLNS REQUEST BATCH}    http://batch.hubtech.services.ewb.idbs.com    # Currently ns2
${BATCH XMLNS REQUEST SERVICES}    http://hubtech.services.ewb.idbs.com    # Currently ns3

*** Keywords ***
Tuple Web Services Request Setup
    [Documentation]    - Sets host to be the EWB Application server as given by the ${SERVER} variable.
    ...
    ...    - Sets the authentication to be basic authentication using the ${SERVER USERNAME} and ${SERVICES PASSWORD}.
    ...
    ...    - Sets a content-type request header to accept application/xml:charset=utf-8
    ...
    ...    This keyword should be called from the keywords which handle the requests to the server and not from the test cases themselves.
    ...
    ...    *Arguments*
    ...
    ...    None
    ...
    ...    *Return Type*
    ...
    ...    None
    ...
    ...
    ...    *Example*
    ...
    ...    | Request Setup (Permissions) | Administrator | Administrator |
    Create Http Context    ${SERVER}:${WEB_SERVICE_PORT}    ${WEB_SERVICE_HTTP_SCHEME}
    Set Basic Auth    ${SERVICES USERNAME}    ${SERVICES PASSWORD}
    Set Request Header    Content-Type    application/xml;charset=utf-8
    Log    ${SERVICES USERNAME}

Get Number of Tuples
    [Documentation]    Uses the Query web service to obtain the number of tuples in the Asset hub.
    ...
    ...    *Arguments*
    ...
    ...    None
    ...
    ...    *Return Value*
    ...
    ...    -${count} = The total number of tuples in the Asset hub.
    ${USERNAME TEMP}=    Set Variable    ${SERVICES USERNAME}
    ${PASSWORD TEMP}=    Set Variable    ${SERVICES PASSWORD}
    ${SERVICES USERNAME}=    Set Variable    ${ADMIN USER}
    ${SERVICES PASSWORD}=    Set Variable    ${ADMIN PASSWD}
    ${count}=    Set Variable    0
    : FOR    ${base_term_path}    IN    @{Base_term_path_list}
    \    ${single_term_count_value}=    Execute Query    SELECT COUNT(*) FROM "${base_term_path}"
    \    @{single_term_count_list}=    Get Element Value    ${single_term_count_value}    http://java.sun.com/xml/ns/jdbc    columnValue
    \    ${single_term_count}=    Set Variable    @{single_term_count_list}[0]
    \    ${count}=    Evaluate    ${count}+${single_term_count}
    ${SERVICES USERNAME}=    Set Variable    ${USERNAME TEMP}
    ${SERVICES PASSWORD}=    Set Variable    ${PASSWORD TEMP}
    [Return]    ${count}

Validate Number of Tuples
    [Arguments]    ${Expected Tuple Number}
    [Documentation]    Checks the number of tuples in the asset hub is correct following a tuple operation.
    ...
    ...    *Note* This keyword is built into other keywords that execute Tuple web service operations in order to validate tuple number following the operation.
    ...
    ...    *Arguments*
    ...
    ...    -${Expected Tuple Number} = Number of tuples expected in the asset hub following the tuple operation.
    ...
    ...    *Return Values*
    ...
    ...    None
    ${number of tuples}=    Get Number of Tuples
    Check Number Equals    Check number of tuples is as expected.    ${number of tuples}    ${Expected Tuple Number}

Get Existing Tuple ID List
    [Documentation]    Obtains a list of all the tuple IDs currently in the Asset hub.
    ...
    ...    *Arguments*
    ...
    ...    None
    ...
    ...    *Return Value*
    ...
    ...    -${tuple_id_list} = List of the tuple IDs of the all the tuples currently in the Asset hub.
    ...
    ...    *Example*
    ...
    ...    | ${tuple_id_list}= | Get Existing Tuple ID List |
    @{tuple_id_list}=    Create List
    : FOR    ${base_term_path}    IN    @{Base_term_path_list}
    \    ${query_results}=    Execute Query    SELECT TUPLE_ID FROM "${base_term_path}"
    \    @{tuple_ids_returned}=    Get Element Value    ${query_results}    http://java.sun.com/xml/ns/jdbc    columnValue
    \    Append to List    ${tuple_id_list}    @{tuple_ids_returned}
    \    Log    ${tuple_id_list}
    [Return]    ${tuple_id_list}

General Response Body
    [Arguments]    ${Response Body}    ${Expected No Operation Responses}
    [Documentation]    Checks the structure and content of the features common to the xml response body returned by both a *batch* and *non-batch* creation, retrieval, update and deletion operation. Additionally, the keyword pulls out a list of the operationResponseBody xml elements for each operation within a batch or for the single operation within a non-batch.
    ...
    ...    *Note* This keyword is built into keywords that execute Tuple web service operations.
    ...
    ...
    ...    *Arguments*
    ...    - ${Response Body}= Response body xml returned by a batch or non-batch operation.
    ...    - ${Expected No Operation Responses} = The expected number of batchOperationResponse xml elements in the response body of an operation.
    ...
    ...    *Return Values*
    ...
    ...    -@{Operation Response Body} = A list of the operationResponseBody xml elements present in the response body
    log    ${Response Body}
    Should Contain    ${Response Body}    hubTechResponse
    Check XML Element Count    One batchResponse element per response (Critical check).    ${Response Body}    1    batchResponse    ${XMLNS REQUEST HUBTECH}    failure_stops_test=${True}
    Check XML Element Count    One batchOperationResponse element per response    ${Response Body}    1    batchOperationResponses    ${XMLNS REQUEST BATCH}
    Check XML Element Count    Number of Operation elements per response    ${Response Body}    ${Expected No Operation Responses}    .//{${XMLNS RESPONSE BATCH}}batchOperationResponse[\@{http://www.w3.org/2001/XMLSchema-instance}type='{${XMLNS RESPONSE BATCH}}TupleOperationResponse']    xpath=${True}
    # Retrieve list of operation responses to return
    @{Operation Response Body}=    Run Keyword If    "${Expected No Operation Responses}"!="0"    Get Element Xml From Xpath    ${Response Body}    .//{${XMLNS RESPONSE BATCH}}batchOperationResponse[\@{http://www.w3.org/2001/XMLSchema-instance}type='{${XMLNS RESPONSE BATCH}}TupleOperationResponse']
    [Return]    @{Operation Response Body}

Create Date Format With Time
    [Arguments]    ${due date}
    [Documentation]    Creates a date (and time) value in EPOCH format.
    ...
    ...    *Arguments*
    ...    ${due date} = either a specific date in the format *YYYY-MM-DD hh:mm:ss* or *YYYYMMDD hhmmss* or *number of seconds after the Unix epoch* or *NOW - {time interval}* to allow the test to run with a date correct at the point of running the test e.g. *NOW - 1 day*
    ...
    ...    * Return Value*
    ...    new due date = the due date in the correct format required for task due dates
    ${new due date}=    Get Unix Time    ${due date}
    ${timestamp}=    evaluate    ${new due date}*1000
    ${timestamp}=    Convert To String    ${timestamp}
    [Return]    ${timestamp}

Get Next Auto ID Value
    [Arguments]    ${term_path}    ${property_name}    ${sequence_type}=integer
    [Documentation]    *Obtains the expected auto ID value from the Auto ID Format sequence present in the database.*
    ...
    ...    _*NOTE: THIS WILL INCREMENT THE SEQUENCE BY ONE SO THE VALUES FOR THE PROPERTIES UTILISING THE SPECIFIC AUTO_ID SEQUENCE WILL NOT BE SEQUENTIAL*_
    ...
    ...    *Arguments*
    ...
    ...    - _term_path_ = the path of the term to be evaluated, including the leading forward slash
    ...    - _property_name_ = the name of the property
    ...    - _sequence_type_=integer = optional argument, can be set to *integer* (default) for ID's with an integer sequence or *character* for ID's with a character sequence
    ...
    ...    *Return Values*
    ...
    ...    -_next_value_ = the next value expected from the auto ID sequence
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    ...    | ${next_value}= | Get Next Auto ID Value | \ /Dictionary/Term | Auto_ID_Property |
    Connect To Database    ${DICT_USERNAME}    ${DICT_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    ${term_id}=    Query    SELECT TERM_ID FROM TERMS WHERE PATH='${term_path}'
    ${term_id}=    Set Variable    ${term_id[0][0]}
    ${property_format}=    Query    SELECT FORMAT FROM PROPERTIES WHERE TERM_ID='${term_id}' AND NAME='${property_name}'
    ${property_format}=    Set Variable    ${property_format[0][0]}
    ${property_element_1}    ${auto_id_format_sequence}    ${property_element_3}=    Split String From Right    ${property_format}    !    2
    ${next_value}=    Query    SELECT ${auto_id_format_sequence}.NEXTVAL FROM DUAL
    ${next_value_int}=    Run Keyword If    '${sequence_type}'=='integer'    Evaluate    int(${next_value[0][0]})+1
    ${next_value_char}=    Run Keyword Unless    '${sequence_type}'=='integer'    Evaluate    chr((int(${next_value[0][0]})+1)+64)    # -64 to convert from ASCII value to make A=1, B=2 etc (A bit of a hack to get this working correctly)
    ${next_value}=    Set Variable If    '${sequence_type}'=='integer'    ${next_value_int}    ${next_value_char}
    Disconnect From Database
    [Return]    ${next_value}

Check Auto ID Generation
    [Arguments]    ${auto_ID_value}    ${Expected Auto ID Suffix}    ${Auto ID Padding}=6
    [Documentation]    Checks:
    ...
    ...    - The format of a given auto ID
    ...    - The date value of the auto ID
    ...    - The suffix of the auto ID
    ...
    ...    *Arguments*
    ...
    ...    - ${auto_ID_value} = the auto ID to check
    ...    - ${Expected Auto ID Suffix} = the expected suffix of the auto ID
    ...    - ${Auto ID Padding} = (default = 6} - The padding the auto ID format has
    ...
    ...    *Return Value*
    ...
    ...    -${Expected Auto ID} = the expected auto ID
    ...
    ...    *Example*
    ...
    ...    | ${Next Auto ID}=| Get Next Auto ID Value | ${Term ID} | Auto ID Property |
    ...    | ${Operation 1 XML} = | Batch Create Operation XML | ${Term ID} | ${EMPTY} | ${Tuple ID} | ${Property XML 1} | ${Property XML 2} |
    ...    | @{Operation Response Body}= | Batch Request | +1 | 2 | ${Operation 1} |
    ...    | @{keypropvalgenerated}= | Get Element Value | @{Operation Response Body[0] | ${XMLNS RESPONSE TUPLE} | keyPropertyValue |
    ...    | Check Auto ID Generation | @{keypropvalgenerated}[0] | ${Next Auto ID} |
    ${yyyy}    ${mm}    ${dd}=    Get Time    year,month,day    UTC
    ${yy}=    Get Substring    ${yyyy}    2
    ${date}    ${end_auto_id}=    Split String    ${auto_ID_value}
    ${time}    ${end_auto_id}=    Split String    ${end_auto_id}    -
    Should Be Equal As Strings    ${date}    ${dd}/${mm}/${yy}
    @{time_components}=    Split String    ${time}    :
    Check List Length Equals    Time element should consist of hour, minute and second parts    ${time_components}    3
    : FOR    ${component}    IN    @{time_components}
    \    Check String Length Equals    Individual time component should be of length 2    ${component}    2
    ${padded_expected_suffix}=    Generate Number With Padding    ${Expected Auto ID Suffix}    ${Auto ID Padding}
    Should Be Equal As Strings    ${end_auto_id}    ${padded_expected_suffix}    Check Auto ID is ${padded_expected_suffix}
    ${Expected Auto ID}=    Set Variable    ${dd}/${mm}/${yy} ${time}-${padded_expected_suffix}
    [Return]    ${Expected Auto ID}

Create Batch Operation ID
    [Documentation]    Creates a batch operation ID in the format RF-TEST-<TIME> where <TIME> is replaced by the number of seconds after the UNIX epoch (01/01/1970 00:00:00)
    ...
    ...    *Arguments*
    ...
    ...    None
    ...
    ...    *Return Value*
    ...
    ...    Batch Operation ID - A unique ID value
    ...
    ...    *Example*
    ...
    ...    | ${new ID}= | Create Batch Operation ID |
    ${Batch Operation ID}=    Get Time    EPOCH
    ${Batch Operation ID}=    Catenate    SEPARATOR=-    RF-TEST    ${Batch Operation ID}
    Log    Batch operation ID set to: ${Batch Operation ID}
    [Return]    ${Batch Operation ID}

Create Operation Response Body
    [Arguments]    ${Operation Response Body Create}    ${Operation Response Body Retrieve}    ${Client Batch Operation ID Set}=${true}    ${Client Batch Operation ID}=${EMPTY}
    [Documentation]    Checks the structure and content of the xml of the response body batchOperationResponse element returned for both a *batch* and *non-batch* creation operation. Both batch and non-batch creation operations undertake a retrieve operation as part of the creation when the tupleEchoPolicy is CREATE (the default when unspecified). Therefore, this keywords checks the content of the batchOperationResponse element returned for the creation part of the operation and the general content features of the batchOperationResponse element returned for the retrieve part of the operation. The details of a retrieval operation that can very between operations must be checked using other keywords.
    ...
    ...
    ...    *Arguments*
    ...
    ...    - ${Operation Response Body Create} = The batchOperationResponse xml element returned for the creation part of the operation.
    ...    - ${Operation Response Body Retrieve} = The batchOperationResponse xml element retruned for the retrieval part of the operation.
    ...    - ${Client Batch Operation ID Set} (default = ${true}, must be ${true} or ${false}) = If a clientBatchOperationId has been specified.
    ...    - ${Client Batch Operation ID} (OPTIONAL, default=${EMPTY}) = The value set for the clientBatchOperationId for a batch update operation.
    ...
    ...    *Return Values*
    ...
    ...    None
    ...
    ...    *Examples*
    ...
    ...
    ...    Example: Batch Creation Operation:
    ...
    ...
    ...    | ${Property XML 1} = Batch Set Property (Non-Linked) | String Property | ${propertytermid} | ${propertyid}| String Value 1 |
    ...    | ${Creation Operation}= | Batch Create Operation XML | ${termtermid} | Key Property Value 1 | ${tuple id} | Creation Batch Operation ID 1 | ${Property XML 1} |
    ...    | @{Operation Response Body}= | Batch Request | +1 | 2 | Operation 1=${Creation Operation} |
    ...    | Create Operation Response Body | @{Operation Response Body}[0] | @{Operation Response Body}[1] | true | Creation Batch Operation ID 1 |
    ...
    ...    Example: Non-Batch Creation Operation:
    ...
    ...
    ...    | ${Property XML 1} = | Batch Set Property (Non-Linked) | String Property | ${propertytermid} | ${propertyid} | String Value 1 |
    ...    | @{Operation Response Body}= | Create Tuple | ${termtermid} | Key Property Value 1 | ${tuple id} | ${Property XML 1} |
    ...    | Create Operation Response Body | @{Operation Response Body [0] | false |
    # TUPLE RESPONSE ELEMENT VALIDATION
    Check Xml Element Count    One tupleResponse per response    ${Operation Response Body Create}    1    tupleResponse    ${XMLNS RESPONSE BATCH}
    @{Operation Response Body 2}=    Get Element Xml    ${Operation Response Body Create}    ${XMLNS RESPONSE BATCH}    tupleResponse
    Check Xml Does Not Contain Element    Check no hubTupleSequence within the tupleResponse    ${Operation Response Body 2}    hubTupleSequence    ${XMLNS RESPONSE TUPLE}
    Check Xml Does Not Contain Element    Check no hubSpecifier within the tupleResponse    ${Operation Response Body 2}    hubSpecifier    ${XMLNS RESPONSE TUPLE}
    Check Xml Does Not Contain Element    Check no tupleSequence within the tupleResponse    ${Operation Response Body 2}    tupleSequence    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Request status should be "Request Completed OK"    ${Operation Response Body 2}    Request Completed OK    status    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    Checks there is one transactionId element    ${Operation Response Body 2}    1    transactionId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Is Not Empty    Checks the transactionId has a value    ${Operation Response Body 2}    transactionId    ${XMLNS RESPONSE TUPLE}
    @{transactionId value}=    Get Element Value    ${Operation Response Body 2}    ${XMLNS RESPONSE TUPLE}    transactionId
    Run Keyword If    "${Client Batch Operation ID Set}"=="true"    Check clientBatchOperationId    @{Operation Response Body 2}    ${Client Batch Operation ID}
    Run Keyword If    "${Client Batch Operation ID Set}"=="false"    Check clientBatchOperationId    @{Operation Response Body 2}    UnspecifiedClientBatchOperationId
    Check Xml Element Count    One sourceType element per tupleResponse    ${Operation Response Body 2}    1    sourceType    ${XMLNS RESPONSE TUPLE}
    # NOTES ELEMENT VALIDATION
    Check Xml Element Count    One notes element per tupleResponse    ${Operation Response Body 2}    1    notes    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 3}=    Get Element Xml    ${Operation Response Body 2}    ${XMLNS RESPONSE TUPLE}    notes
    Check Xml Element Value Equals    Note type should be "Matching Rules Note"    ${Operation Response Body 3}    Matching Rules Note    noteType    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Summary should be "Business Rules have Matched"    ${Operation Response Body 3}    Business Rules have Matched    summary    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Description should be "Rules with following Ids had the defined Consequence(s) applied."    ${Operation Response Body 3}    Rules with following Ids had the defined Consequence(s) applied.    description    ${XMLNS RESPONSE TUPLE}
    Comment    @{ruleMatchedIdsCreate}=    Get Element Value    @{Operation Response Body 3}    ${XMLNS RESPONSE TUPLE}    ruleMatchedId
    Comment    Log Many    @{ruleMatchedIdsCreate}
    Comment    ${lengthruleMatchedIdsCreate}=    Get Length    ${ruleMatchedIdsCreate}
    Comment    Should Be True    ${lengthruleMatchedIdsCreate}>=1
    # SPLIT INTO SEPERATE KEYWORD - LONG KEYWORD
    # TUPLE RESPONSE ELEMENT VALIDATION
    # Validation of Retrieve Operation Section of the Response Body:
    Check Xml Element Count    One tupleResponse element per retrieve response body    ${Operation Response Body Retrieve}    1    tupleResponse    ${XMLNS RESPONSE BATCH}
    @{Operation Response Body 4}=    Get Element Xml    ${Operation Response Body Retrieve}    ${XMLNS RESPONSE BATCH}    tupleResponse
    Check Xml Element Value Equals    Status should be "Request Completed OK"    ${Operation Response Body 4}    Request Completed OK    status    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    Checks there is one transactionId element    ${Operation Response Body 4}    1    transactionId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Is Not Empty    Checks the transactionId has a value    ${Operation Response Body 4}    transactionId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Checks the transactionId value is equal to the transactionId value in the batchOperationResponse relating to the creation operation    ${Operation Response Body 4}    @{transactionId value}[0]    transactionId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Source type should be "RULES"    ${Operation Response Body 4}    RULES    sourceType    ${XMLNS RESPONSE TUPLE}
    # NOTES ELEMENT VALIDATION
    Check Xml Element Count    One notes element per tupleResponse    ${Operation Response Body 4}    1    notes    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 5}=    Get Element Xml    @{Operation Response Body 4}    ${XMLNS RESPONSE TUPLE}    notes
    Check Xml Element Value Equals    Note type should be "Matching Rules Note"    ${Operation Response Body 5}    Matching Rules Note    noteType    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Summary should be "Business Rules have Matched"    ${Operation Response Body 5}    Business Rules have Matched    summary    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Description should be "Rules with following Ids had the defined Consequence(s) applied."    ${Operation Response Body 5}    Rules with following Ids had the defined Consequence(s) applied.    description    ${XMLNS RESPONSE TUPLE}
    Comment    @{ruleMatchedIdsRetrieve}=    Get Element Value    @{Operation Response Body 5}    ${XMLNS RESPONSE TUPLE}    ruleMatchedId
    Comment    Log Many    @{ruleMatchedIdsRetrieve}
    Comment    ${lengthruleMatchedIdsRetrieve}=    Get Length    ${ruleMatchedIdsRetrieve}
    Comment    Should Be True    ${lengthruleMatchedIdsRetrieve}>=1
    # HUB TUPLE SEQUENCE VALIDATION
    Check Xml Element Count    One hubTupleSequence element per tupleResponse    ${Operation Response Body 4}    1    hubTupleSequence    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    One hubSpecifier element per tupleResponse    ${Operation Response Body 4}    1    hubSpecifier    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 7}=    Get Element Xml    ${Operation Response Body 4}    ${XMLNS RESPONSE TUPLE}    hubSpecifier
    #Check Xml Element Value Equals    ID should be "${ASSET_HUB_ID}"    ${Operation Response Body 7}    ${ASSET_HUB_ID}    id    ${XMLNS RESPONSE TUPLE}
    #Check Xml Element Value Equals    Description should be "Asset hub to store Assets"    ${Operation Response Body 7}    Asset hub to store Assets    description    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    One tupleSequence element per hubSpecifier    ${Operation Response Body 4}    1    tupleSequence    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 8}=    Get Element Xml    ${Operation Response Body 4}    ${XMLNS RESPONSE TUPLE}    tupleSequence
    Check Xml Contains Element    tuple element present    ${Operation Response Body 8}    tuple    ${XMLNS RESPONSE TUPLE}

Create Operation Response Body tupleExistsPolicy IGNORE
    [Arguments]    ${Operation Response Body}    ${Client Batch Operation ID Set}=${true}    ${Client Batch Operation ID}=${EMPTY}
    [Documentation]    Checks the structure and content of the xml of the response body batchOperationResponse element returned for both a *batch* and *non-batch* creation operation when the tupleExistsPolicy is specified as IGNORE and the key property value specified exists for the same term.
    ...
    ...    *Arguments*
    ...
    ...    - ${Operation Response Body} = The batchOperationResponse xml element returned for the creation part of the operation.
    ...    - ${Client Batch Operation ID Set} (default = ${true}, must be ${true} or ${false}) = If a clientBatchOperationId has been specified.
    ...    - ${Client Batch Operation ID} (OPTIONAL, default=${EMPTY}) = The value set for the clientBatchOperationId for a batch update operation.
    ...
    ...    *Return Values*
    ...
    ...    None
    ...
    ...    *Examples*
    ...
    ...
    ...    Example: Batch Creation Operation:
    ...
    ...
    ...    | ${Property XML 1} = Batch Set Property (Non-Linked) | String Property | ${propertytermid} | ${propertyid}| String Value 1 |
    ...    | ${Creation Operation}= | Batch Create Operation XML tupleExistsPolicy | ${termtermid} | Key Property Value 1 | ${tuple id} | IGNORE | ${Property XML 1} |
    ...    | @{Operation Response Body}= | Batch Request | +1 | 2 | Operation 1=${Creation Operation} |
    ...    | Create Operation Response Body tupleExistsPolicy IGNORE | @{Operation Response Body}[0] | true |
    ...
    ...    Example: Non-Batch Creation Operation:
    ...
    ...
    ...    | ${Property XML 1} = | Batch Set Property (Non-Linked) | String Property | ${propertytermid} | ${propertyid} | String Value 1 |
    ...    | @{Operation Response Body}= | Create Tuple tupleExistsPolicy | ${termtermid} | Key Property Value 1 | ${tuple id} | IGNORE | ${Property XML 1} |
    ...    | Create Operation Response Body tupleExistsPolicy IGNORE | @{Operation Response Body [0] | false |
    Check Xml Element Count    One tupleResponse element per retrieve response body    ${Operation Response Body}    1    tupleResponse    ${XMLNS RESPONSE BATCH}
    @{Operation Response Body 4}=    Get Element Xml    ${Operation Response Body}    ${XMLNS RESPONSE BATCH}    tupleResponse
    Check Xml Element Value Equals    Status should be "Request Completed OK"    ${Operation Response Body 4}    Request Completed OK    status    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    Checks there is one transactionId element    ${Operation Response Body 4}    1    transactionId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Is Not Empty    Checks the transactionId has a value    ${Operation Response Body 4}    transactionId    ${XMLNS RESPONSE TUPLE}
    Run Keyword If    "${Client Batch Operation ID Set}"=="true"    Check clientBatchOperationId    ${Operation Response Body 4}    ${Client Batch Operation ID}
    Run Keyword If    "${Client Batch Operation ID Set}"=="false"    Check clientBatchOperationId    @{Operation Response Body 2}    UnspecifiedClientBatchOperationId
    Check Xml Element Value Equals    Source type should be "RULES"    ${Operation Response Body 4}    RULES    sourceType    ${XMLNS RESPONSE TUPLE}
    # NOTES ELEMENT VALIDATION
    Check Xml Element Count    One notes element per tupleResponse    ${Operation Response Body 4}    1    notes    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 5}=    Get Element Xml    @{Operation Response Body 4}    ${XMLNS RESPONSE TUPLE}    notes
    Check Xml Element Value Equals    Note type should be "Matching Rules Note"    ${Operation Response Body 5}    Matching Rules Note    noteType    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Summary should be "Business Rules have Matched"    ${Operation Response Body 5}    Business Rules have Matched    summary    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Description should be "Rules with following Ids had the defined Consequence(s) applied."    ${Operation Response Body 5}    Rules with following Ids had the defined Consequence(s) applied.    description    ${XMLNS RESPONSE TUPLE}
    # HUB TUPLE SEQUENCE VALIDATION
    Check Xml Element Count    One hubTupleSequence element per tupleResponse    ${Operation Response Body 4}    1    hubTupleSequence    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    One hubSpecifier element per tupleResponse    ${Operation Response Body 4}    1    hubSpecifier    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 7}=    Get Element Xml    ${Operation Response Body 4}    ${XMLNS RESPONSE TUPLE}    hubSpecifier
    #Check Xml Element Value Equals    ID should be "${ASSET_HUB_ID}"    ${Operation Response Body 7}    ${ASSET_HUB_ID}    id    ${XMLNS RESPONSE TUPLE}
    #Check Xml Element Value Equals    Description should be "Asset hub to store Assets"    ${Operation Response Body 7}    Asset hub to store Assets    description    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    One tupleSequence element per hubSpecifier    ${Operation Response Body 4}    1    tupleSequence    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 8}=    Get Element Xml    ${Operation Response Body 4}    ${XMLNS RESPONSE TUPLE}    tupleSequence
    Check Xml Contains Element    tuple element present    ${Operation Response Body 8}    tuple    ${XMLNS RESPONSE TUPLE}

Create Operation Response Body tupleEchoPolicy IGNORE
    [Arguments]    ${Operation Response Body}    ${Client Batch Operation ID Set}=${true}    ${Client Batch Operation ID}=${EMPTY}
    [Documentation]    Checks the structure and content of the xml of the response body batchOperationResponse element returned for both a *batch* and *non-batch* creation operation. Both batch and non-batch creation operations undertake a retrieve operation as part of the creation when the tupleEchoPolicy is specified as IGNORE.
    ...
    ...    *Arguments*
    ...
    ...    - ${Operation Response Body Create} = The batchOperationResponse xml element returned for the creation part of the operation.
    ...    - ${Operation Response Body Retrieve} = The batchOperationResponse xml element retruned for the retrieval part of the operation.
    ...    - ${Client Batch Operation ID Set} (default = ${true}, must be ${true} or ${false}) = If a clientBatchOperationId has been specified.
    ...    - ${Client Batch Operation ID} (OPTIONAL, default=${EMPTY}) = The value set for the clientBatchOperationId for a batch update operation.
    ...
    ...    *Return Values*
    ...
    ...    None
    ...
    ...    *Examples*
    ...
    ...
    ...    Example: Batch Creation Operation:
    ...
    ...
    ...    | ${Property XML 1} = Batch Set Property (Non-Linked) | String Property | ${propertytermid} | ${propertyid}| String Value 1 |
    ...    | ${Creation Operation}= | Batch Create Operation XML tupleEchoPolicy | ${termtermid} | Key Property Value 1 | ${tuple id} | IGNORE | ${Property XML 1} |
    ...    | @{Operation Response Body}= | Batch Request | +1 | 2 | Operation 1=${Creation Operation} |
    ...    | Create Operation Response Body tupleEchoPolicy IGNORE | @{Operation Response Body}[0] | true |
    ...
    ...    Example: Non-Batch Creation Operation:
    ...
    ...
    ...    | ${Property XML 1} = | Batch Set Property (Non-Linked) | String Property | ${propertytermid} | ${propertyid} | String Value 1 |
    ...    | @{Operation Response Body}= | Create Tuple tupleEchoPolicy | ${termtermid} | Key Property Value 1 | ${tuple id} | IGNORE | ${Property XML 1} |
    ...    | Create Operation Response Body tupleEchoPolicy IGNORE | @{Operation Response Body [0] | false |
    # TUPLE RESPONSE ELEMENT VALIDATION
    Check Xml Element Count    One tupleResponse per response    ${Operation Response Body}    1    tupleResponse    ${XMLNS RESPONSE BATCH}
    @{Operation Response Body 2}=    Get Element Xml    ${Operation Response Body}    ${XMLNS RESPONSE BATCH}    tupleResponse
    Check Xml Does Not Contain Element    Check no hubTupleSequence within the tupleResponse    ${Operation Response Body 2}    hubTupleSequence    ${XMLNS RESPONSE TUPLE}
    Check Xml Does Not Contain Element    Check no hubSpecifier within the tupleResponse    ${Operation Response Body 2}    hubSpecifier    ${XMLNS RESPONSE TUPLE}
    Check Xml Does Not Contain Element    Check no tupleSequence within the tupleResponse    ${Operation Response Body 2}    tupleSequence    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Request status should be "Request Completed OK"    ${Operation Response Body 2}    Request Completed OK    status    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    Checks there is one transactionId element    ${Operation Response Body 2}    1    transactionId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Is Not Empty    Checks the transactionId has a value    ${Operation Response Body 2}    transactionId    ${XMLNS RESPONSE TUPLE}
    Run Keyword If    "${Client Batch Operation ID Set}"=="true"    Check clientBatchOperationId    @{Operation Response Body 2}    ${Client Batch Operation ID}
    Run Keyword If    "${Client Batch Operation ID Set}"=="false"    Check clientBatchOperationId    @{Operation Response Body 2}    UnspecifiedClientBatchOperationId
    Check Xml Element Count    One sourceType element per tupleResponse    ${Operation Response Body 2}    1    sourceType    ${XMLNS RESPONSE TUPLE}
    # NOTES ELEMENT VALIDATION
    Check Xml Element Count    One notes element per tupleResponse    ${Operation Response Body 2}    1    notes    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 3}=    Get Element Xml    ${Operation Response Body 2}    ${XMLNS RESPONSE TUPLE}    notes
    Check Xml Element Value Equals    Note type should be "Matching Rules Note"    ${Operation Response Body 3}    Matching Rules Note    noteType    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Summary should be "Business Rules have Matched"    ${Operation Response Body 3}    Business Rules have Matched    summary    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Description should be "Rules with following Ids had the defined Consequence(s) applied."    ${Operation Response Body 3}    Rules with following Ids had the defined Consequence(s) applied.    description    ${XMLNS RESPONSE TUPLE}
    Comment    @{ruleMatchedIdsCreate}=    Get Element Value    @{Operation Response Body 3}    ${XMLNS RESPONSE TUPLE}    ruleMatchedId
    Comment    Log Many    @{ruleMatchedIdsCreate}
    Comment    ${lengthruleMatchedIdsCreate}=    Get Length    ${ruleMatchedIdsCreate}
    Comment    Should Be True    ${lengthruleMatchedIdsCreate}>=1
    # SPLIT INTO SEPERATE KEYWORD - LONG KEYWORD
    # TUPLE RESPONSE ELEMENT VALIDATION

Create Operation Response Body tupleEchoPolicy VALUES
    [Arguments]    ${Operation Response Body Create}    ${Operation Response Body Retrieve}    ${Client Batch Operation ID Set}=${true}    ${Client Batch Operation ID}=${EMPTY}
    [Documentation]    Checks the structure and content of the xml of the response body batchOperationResponse element returned for both a *batch* and *non-batch* creation operation. Both batch and non-batch creation operations undertake a retrieve operation as part of the creation when the tupleEchoPolicy is specified as VALUES. A pseudo retrieval is undertaken as part of the batch/non-batch operation. Therefore, this keywords checks the content of the batchOperationResponse element returned for the creation part of the operation and the general content features of the batchOperationResponse element returned for the pseudo-retrieve part of the operation. The details of a pseudo-retrieval operation that can very between operations must be checked using other keywords.
    ...
    ...
    ...    *Arguments*
    ...
    ...    - ${Operation Response Body Create} = The batchOperationResponse xml element returned for the creation part of the operation.
    ...    - ${Operation Response Body Retrieve} = The batchOperationResponse xml element retruned for the retrieval part of the operation.
    ...    - ${Client Batch Operation ID Set} (default = ${true}, must be ${true} or ${false}) = If a clientBatchOperationId has been specified.
    ...    - ${Client Batch Operation ID} (OPTIONAL, default=${EMPTY}) = The value set for the clientBatchOperationId for a batch update operation.
    ...
    ...    *Return Values*
    ...
    ...    None
    ...
    ...    *Examples*
    ...
    ...
    ...    Example: Batch Creation Operation:
    ...
    ...
    ...    | ${Property XML 1} = Batch Set Property (Non-Linked) | String Property | ${propertytermid} | ${propertyid}| String Value 1 |
    ...    | ${Creation Operation}= | Batch Create Operation XML tupleEchoPolicy | ${termtermid} | Key Property Value 1 | ${tuple id} | VALUES | ${Property XML 1} |
    ...    | @{Operation Response Body}= | Batch Request | +1 | 2 | Operation 1=${Creation Operation} |
    ...    | Create Operation Response Body tupleEchoPolicy VALUES | @{Operation Response Body}[0] | @{Operation Response Body}[1] | true |
    ...
    ...    Example: Non-Batch Creation Operation:
    ...
    ...
    ...    | ${Property XML 1} = | Batch Set Property (Non-Linked) | String Property | ${propertytermid} | ${propertyid} | String Value 1 |
    ...    | @{Operation Response Body}= | Create Tuple tupleEchoPolicy | ${termtermid} | Key Property Value 1 | ${tuple id} | VALUES | ${Property XML 1} |
    ...    | Create Operation Response Body tupleEchoPolicy VALUES | @{Operation Response Body [0] | false |
    # TUPLE RESPONSE ELEMENT VALIDATION
    Check Xml Element Count    One tupleResponse per response    ${Operation Response Body Create}    1    tupleResponse    ${XMLNS RESPONSE BATCH}
    @{Operation Response Body 2}=    Get Element Xml    ${Operation Response Body Create}    ${XMLNS RESPONSE BATCH}    tupleResponse
    Check Xml Does Not Contain Element    Check no hubTupleSequence within the tupleResponse    ${Operation Response Body 2}    hubTupleSequence    ${XMLNS RESPONSE TUPLE}
    Check Xml Does Not Contain Element    Check no hubSpecifier within the tupleResponse    ${Operation Response Body 2}    hubSpecifier    ${XMLNS RESPONSE TUPLE}
    Check Xml Does Not Contain Element    Check no tupleSequence within the tupleResponse    ${Operation Response Body 2}    tupleSequence    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Request status should be "Request Completed OK"    ${Operation Response Body 2}    Request Completed OK    status    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    Checks there is one transactionId element    ${Operation Response Body 2}    1    transactionId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Is Not Empty    Checks the transactionId has a value    ${Operation Response Body 2}    transactionId    ${XMLNS RESPONSE TUPLE}
    Run Keyword If    "${Client Batch Operation ID Set}"=="true"    Check clientBatchOperationId    @{Operation Response Body 2}    ${Client Batch Operation ID}
    Run Keyword If    "${Client Batch Operation ID Set}"=="false"    Check clientBatchOperationId    @{Operation Response Body 2}    UnspecifiedClientBatchOperationId
    Check Xml Element Count    One sourceType element per tupleResponse    ${Operation Response Body 2}    1    sourceType    ${XMLNS RESPONSE TUPLE}
    # NOTES ELEMENT VALIDATION
    Check Xml Element Count    One notes element per tupleResponse    ${Operation Response Body 2}    1    notes    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 3}=    Get Element Xml    ${Operation Response Body 2}    ${XMLNS RESPONSE TUPLE}    notes
    Check Xml Element Value Equals    Note type should be "Matching Rules Note"    ${Operation Response Body 3}    Matching Rules Note    noteType    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Summary should be "Business Rules have Matched"    ${Operation Response Body 3}    Business Rules have Matched    summary    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Description should be "Rules with following Ids had the defined Consequence(s) applied."    ${Operation Response Body 3}    Rules with following Ids had the defined Consequence(s) applied.    description    ${XMLNS RESPONSE TUPLE}
    Comment    @{ruleMatchedIdsCreate}=    Get Element Value    @{Operation Response Body 3}    ${XMLNS RESPONSE TUPLE}    ruleMatchedId
    Comment    Log Many    @{ruleMatchedIdsCreate}
    Comment    ${lengthruleMatchedIdsCreate}=    Get Length    ${ruleMatchedIdsCreate}
    Comment    Should Be True    ${lengthruleMatchedIdsCreate}>=1
    # SPLIT INTO SEPERATE KEYWORD - LONG KEYWORD
    # TUPLE RESPONSE ELEMENT VALIDATION
    # Validation of Retrieve Operation Section of the Response Body:
    Check Xml Element Count    One tupleResponse element per retrieve response body    ${Operation Response Body Retrieve}    1    tupleResponse    ${XMLNS RESPONSE BATCH}
    @{Operation Response Body 4}=    Get Element Xml    ${Operation Response Body Retrieve}    ${XMLNS RESPONSE BATCH}    tupleResponse
    Check Xml Element Value Equals    Status should be "Request Completed OK"    ${Operation Response Body 4}    Request Completed OK    status    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    Checks there is one transactionId element    ${Operation Response Body 4}    1    transactionId    ${XMLNS RESPONSE TUPLE}
    #Need a keyword that checks element does not have a value
    Check Xml Element Value Equals    Source type should be "RULES"    ${Operation Response Body 4}    RULES    sourceType    ${XMLNS RESPONSE TUPLE}
    # NOTES ELEMENT VALIDATION
    Check Xml Element Count    One notes element per tupleResponse    ${Operation Response Body 4}    1    notes    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 5}=    Get Element Xml    @{Operation Response Body 4}    ${XMLNS RESPONSE TUPLE}    notes
    Check Xml Element Value Equals    Note type should be "Matching Rules Note"    ${Operation Response Body 5}    Matching Rules Note    noteType    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Summary should be "Business Rules have Matched"    ${Operation Response Body 5}    Business Rules have Matched    summary    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Description should be "Rules with following Ids had the defined Consequence(s) applied."    ${Operation Response Body 5}    Rules with following Ids had the defined Consequence(s) applied.    description    ${XMLNS RESPONSE TUPLE}
    Comment    @{ruleMatchedIdsRetrieve}=    Get Element Value    @{Operation Response Body 5}    ${XMLNS RESPONSE TUPLE}    ruleMatchedId
    Comment    Log Many    @{ruleMatchedIdsRetrieve}
    Comment    ${lengthruleMatchedIdsRetrieve}=    Get Length    ${ruleMatchedIdsRetrieve}
    Comment    Should Be True    ${lengthruleMatchedIdsRetrieve}>=1
    # HUB TUPLE SEQUENCE VALIDATION
    Check Xml Element Count    One hubTupleSequence element per tupleResponse    ${Operation Response Body 4}    1    hubTupleSequence    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    One hubSpecifier element per tupleResponse    ${Operation Response Body 4}    1    hubSpecifier    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 7}=    Get Element Xml    ${Operation Response Body 4}    ${XMLNS RESPONSE TUPLE}    hubSpecifier
    #Check Xml Element Value Equals    ID should be "${ASSET_HUB_ID}"    ${Operation Response Body 7}    ${ASSET_HUB_ID}    id    ${XMLNS RESPONSE TUPLE}
    #Check Xml Element Value Equals    Description should be "Asset hub to store Assets"    ${Operation Response Body 7}    Asset hub to store Assets    description    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    One tupleSequence element per hubSpecifier    ${Operation Response Body 4}    1    tupleSequence    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 8}=    Get Element Xml    ${Operation Response Body 4}    ${XMLNS RESPONSE TUPLE}    tupleSequence
    Check Xml Contains Element    tuple element present    ${Operation Response Body 8}    tuple    ${XMLNS RESPONSE TUPLE}

Retrieve Operation Response Body
    [Arguments]    ${Operation Response Body}    ${Client Batch Operation ID Set}=${true}    ${Client Batch Operation ID}=${EMPTY}
    [Documentation]    Checks the structure and general content features of the xml of the response body batchOperationResponse element returned for both a *batch* and *non-batch* retrieval operation. The details of a retrieval operation that can very between operations must be checked using other keywords.
    ...
    ...    *Arguments*
    ...    - ${Operation Response Body} = The batchOperationResponse xml element returned for the retrieval operation.
    ...    - ${Client Batch Operation ID Set} (default = ${true}, must be ${true} or ${false}) = If a clientBatchOperationId has been specified.
    ...    - ${Client Batch Operation ID} (OPTIONAL, default=${EMPTY}) = The value set for the clientBatchOperationId for a batch update operation.
    ...
    ...    *Return Values*
    ...
    ...    None
    ...
    ...    *Examples*
    ...
    ...
    ...    Example: Batch Retrieve Operation:
    ...
    ...
    ...    | ${Retrieve Operation}= | Batch Retrieve Operation XML | ${termtermid} | Key Property Value 1 | ${tuple id} | Retrieve Batch Operation ID 1 |
    ...    | @{Operation Response Body}= | Batch Request | +0 | 1 | Operation 1=${Retrieve Operation |
    ...    | Retrieve Operation Response Body | @{Operation Response Body}[0] | true | Retrieve Batch Operation ID 1 |
    ...
    ...    Example: Non-Batch Retrieve Operation:
    ...
    ...
    ...    | @{Operation Response Body}= | Retrieve Tuples | ${termtermid} | Key Property Value 1 | ${tuple id} |
    ...    | Retrieve Operation Response Body | @{Operation Response Body}[0] | false |
    Check Xml Element Count    One tupleResponse per response body    ${Operation Response Body}    1    tupleResponse    ${XMLNS RESPONSE BATCH}
    @{Operation Response Body 2}=    Get Element Xml    ${Operation Response Body}    ${XMLNS RESPONSE BATCH}    tupleResponse
    Check Xml Element Value Equals    Status should be "Request Completed OK"    ${Operation Response Body 2}    Request Completed OK    status    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    Checks there is one transactionId element    ${Operation Response Body 2}    1    transactionId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Is Not Empty    Checks the transactionId has a value    ${Operation Response Body 2}    transactionId    ${XMLNS RESPONSE TUPLE}
    Run Keyword If    " ${Client Batch Operation ID Set}"=="true"    Check clientBatchOperationId    @{Operation Response Body 2}    ${Client Batch Operation ID}
    Run Keyword If    "$ ${Client Batch Operation ID Set}"=="false"    Check Xml Does Not Contain Element    Check no clientBatchOperationId within tupleResponse    ${Operation Response Body 2}    clientBatchOperationId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    sourceType should be "CLIENT"    ${Operation Response Body 2}    CLIENT    sourceType    ${XMLNS RESPONSE TUPLE}
    Check XML Element Count    one notes element per tupleResponse    ${Operation Response Body 2}    1    notes    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 3}=    Get Element Xml    @{Operation Response Body 2}    ${XMLNS RESPONSE TUPLE}    notes
    Check Xml Element Value Equals    noteType should be "Matching Rules Note"    ${Operation Response Body 3}    Matching Rules Note    noteType    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    summary should be "Business Rules have Matched"    ${Operation Response Body 3}    Business Rules have Matched    summary    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    description should be "Rules with following Ids had the defined Consequence(s) applied."    ${Operation Response Body 3}    Rules with following Ids had the defined Consequence(s) applied.    description    ${XMLNS RESPONSE TUPLE}
    ${number_of_rules_matched}=    Get Xml Element Count    @{Operation Response Body 3}    ruleMatchedId    ${XMLNS RESPONSE TUPLE}
    Comment    Should Be True    ${number_of_rules_matched}>=1    Retrieve operation did not contain 1 or more rule matches.
    Check Xml Element Count    one hubTupleSequence element per tupleResponse    ${Operation Response Body 2}    1    hubTupleSequence    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    one hubSpecifier element per tupleResponse    ${Operation Response Body 2}    1    hubSpecifier    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 5}=    Get Element Xml    ${Operation Response Body 2}    ${XMLNS RESPONSE TUPLE}    hubSpecifier
    #Check Xml Element Value Equals    hubSpecifier ID should be "${ASSET_HUB_ID}"    ${Operation Response Body 5}    ${ASSET_HUB_ID}    id    ${XMLNS RESPONSE TUPLE}
    #Check Xml Element Value Equals    hubSpecifier description should be "Asset hub to store Assets"    ${Operation Response Body 5}    Asset hub to store Assets    description    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    one tupleSequence per tupleResponse    ${Operation Response Body 2}    1    tupleSequence    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 6}=    Get Element Xml    ${Operation Response Body 2}    ${XMLNS RESPONSE TUPLE}    tupleSequence
    Check Xml Contains Element    tuple element present    @{Operation Response Body 6}    tuple    ${XMLNS RESPONSE TUPLE}

Retrieve Operation Response Body NO TUPLES RETURNED
    [Arguments]    ${Operation Response Body}    ${Client Batch Operation ID Set}=${true}    ${Client Batch Operation ID}=${EMPTY}
    [Documentation]    Checks the structure and general content features of the xml of the response body batchOperationResponse element returned for both a *batch* and *non-batch* retrieval operation that does NOT return any tuples.
    ...
    ...    *Arguments*
    ...    - ${Operation Response Body} = The batchOperationResponse xml element returned for the retrieval operation.
    ...    - ${Client Batch Operation ID Set} (default = ${true}, must be ${true} or ${false}) = If a clientBatchOperationId has been specified.
    ...    - ${Client Batch Operation ID} (OPTIONAL, default=${EMPTY}) = The value set for the clientBatchOperationId for a batch update operation.
    ...
    ...    *Return Values*
    ...
    ...    None
    ...
    ...    *Examples*
    ...
    ...
    ...    Example: Batch Retrieve Operation:
    ...
    ...
    ...    | ${Retrieve Operation}= | Batch Retrieve Operation XML | ${termtermid} | Key Property Value 1 | ${tuple id} | Retrieve Batch Operation ID 1 |
    ...    | @{Operation Response Body}= | Batch Request | +0 | 1 | Operation 1=${Retrieve Operation |
    ...    | Retrieve Operation Response Body NO TUPLES RETURNED | @{Operation Response Body}[0] | true | Retrieve Batch Operation ID 1 |
    ...
    ...    Example: Non-Batch Retrieve Operation:
    ...
    ...
    ...    | @{Operation Response Body}= | Retrieve Tuples | ${termtermid} | Key Property Value 1 | ${tuple id} |
    ...    | Retrieve Operation Response Body NO TUPLES RETURNED | @{Operation Response Body}[0] | false |
    Check Xml Element Count    One tupleResponse per response    ${Operation Response Body}    1    tupleResponse    ${XMLNS RESPONSE BATCH}
    Check Xml Element Count    One tupleResponse per response body    ${Operation Response Body}    1    tupleResponse    ${XMLNS RESPONSE BATCH}
    @{Operation Response Body 2}=    Get Element Xml    ${Operation Response Body}    ${XMLNS RESPONSE BATCH}    tupleResponse
    Check Xml Element Value Equals    Status should be "Request Completed OK"    ${Operation Response Body 2}    Request Completed OK    status    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    Checks there is one transactionId element    ${Operation Response Body 2}    1    transactionId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Is Not Empty    Checks the transactionId has a value    ${Operation Response Body 2}    transactionId    ${XMLNS RESPONSE TUPLE}
    Run Keyword If    "${Client Batch Operation ID Set}"=="true"    Check clientBatchOperationId    @{Operation Response Body 2}    ${Client Batch Operation ID}
    Run Keyword If    "${Client Batch Operation ID Set}"=="false"    Check clientBatchOperationId    @{Operation Response Body 2}    UnspecifiedClientBatchOperationId
    Check Xml Element Value Equals    sourceType should be "CLIENT"    ${Operation Response Body 2}    CLIENT    sourceType    ${XMLNS RESPONSE TUPLE}
    Check XML Element Count    one notes element per tupleResponse    ${Operation Response Body 2}    1    notes    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 3}=    Get Element Xml    @{Operation Response Body 2}    ${XMLNS RESPONSE TUPLE}    notes
    Check Xml Element Value Equals    noteType should be "Matching Rules Note"    ${Operation Response Body 3}    Matching Rules Note    noteType    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    summary should be "Business Rules have Matched"    ${Operation Response Body 3}    Business Rules have Matched    summary    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    description should be "Rules with following Ids had the defined Consequence(s) applied."    ${Operation Response Body 3}    Rules with following Ids had the defined Consequence(s) applied.    description    ${XMLNS RESPONSE TUPLE}
    ${number_of_rules_matched}=    Get Xml Element Count    @{Operation Response Body 3}    ruleMatchedId    ${XMLNS RESPONSE TUPLE}
    Should Be True    ${number_of_rules_matched}>=1    Retrieve operation did not contain 1 or more rule matches.
    Check Xml Element Count    one hubTupleSequence element per tupleResponse    ${Operation Response Body 2}    1    hubTupleSequence    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    one hubSpecifier element per tupleResponse    ${Operation Response Body 2}    1    hubSpecifier    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 5}=    Get Element Xml    ${Operation Response Body 2}    ${XMLNS RESPONSE TUPLE}    hubSpecifier
    #Check Xml Element Value Equals    hubSpecifier ID should be "${ASSET_HUB_ID}"    ${Operation Response Body 5}    ${ASSET_HUB_ID}    id    ${XMLNS RESPONSE TUPLE}
    #Check Xml Element Value Equals    hubSpecifier description should be "Asset hub to store Assets"    ${Operation Response Body 5}    Asset hub to store Assets    description    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    one tupleSequence per tupleResponse    ${Operation Response Body 2}    1    tupleSequence    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 6}=    Get Element Xml    ${Operation Response Body 2}    ${XMLNS RESPONSE TUPLE}    tupleSequence
    Check Xml Does Not Contain Element    No tuple element    ${Operation Response Body 6}    tuple    ${XMLNS RESPONSE TUPLE}

Update Operation Response Body
    [Arguments]    ${Operation Response Body}    ${Client Batch Operation ID Set}=${true}    ${Client Batch Operation ID}=${EMPTY}    ${transactionId returned}=true
    [Documentation]    Checks the structure and content of the xml of the response body batchOperationResponse element returned for a both a *batch* and *non-batch* update operation when the tupleEchoPolicy is IGNORE (the default when unspecified).
    ...
    ...    *Arguments*
    ...    - ${Operation Response Body} = The batchOperationResponse xml element returned for the update operation.
    ...    - ${Client Batch Operation ID Set} (default = ${true}, must be ${true} or ${false}) = If a clientBatchOperationId has been specified.
    ...    - ${Client Batch Operation ID} (OPTIONAL, default=${EMPTY}) = The value set for the clientBatchOperationId for a batch update operation.
    ...
    ...    *Return Values*
    ...
    ...    None
    ...
    ...    *Examples*
    ...
    ...    Example: Batch Update Operation:
    ...
    ...    | ${Property XML 1} = Batch Set Property (Non-Linked) | String Property | ${propertytermid} | ${propertyid}| String Value 1 |
    ...    | ${Update Operation}= | Batch Update Operation XML | ${termtermid} | Key Property Value 1 | ${tuple id} |Update Batch Operation ID 1 | ${Property XML 1} |
    ...    | @{Operation Response Body}= | Batch Request | +0 | 1 | Operation 1=${Update Operation}
    ...    | Update Operation Response Body | @{Operation Response Body}[0] | true | Update Batch Operation ID 1 |
    ...
    ...    Example: Non-Batch Update Operation:
    ...
    ...    | ${Property XML 1} = | Batch Set Property (Non-Linked) | String Property | ${propertytermid} | ${propertyid} | String Value 1 |
    ...    | @{Operation Response Body}= | Update Tuple | ${termtermid} | Key Property Value 1 | ${tuple id} | ${Property XML 1} |
    ...    | Update Operation Response Body | @{Operation Response Body [0] | false |
    Check Xml Element Count    check one tupleResponse in response body    ${Operation Response Body}    1    tupleResponse    ${XMLNS RESPONSE BATCH}
    @{Operation Response Body 2}=    Get Element Xml    ${Operation Response Body}    ${XMLNS RESPONSE BATCH}    tupleResponse
    Check Xml Does Not Contain Element    tupleResponse should not contain tuple element    ${Operation Response Body 2}    tuple    ${XMLNS RESPONSE TUPLE}
    Check Xml Does Not Contain Element    tupleResponse should not contain hubTupleSequence element    ${Operation Response Body 2}    hubTupleSequence    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    tupleResponse status should be "Request Completed OK"    ${Operation Response Body 2}    Request Completed OK    status    ${XMLNS RESPONSE TUPLE}
    Run Keyword If    "${transactionId returned}"=="true"    Check Xml Element Count    Checks there is one transactionId element    ${Operation Response Body 2}    1    transactionId
    ...    ${XMLNS RESPONSE TUPLE}
    Run Keyword If    "${transactionId returned}"=="true"    Check Xml Element Value Is Not Empty    Checks the transactionId has a value    ${Operation Response Body 2}    transactionId    ${XMLNS RESPONSE TUPLE}
    Run Keyword If    "${transactionId returned}"=="false"    Should Not Contain    ${Operation Response Body}    transactionId
    Check Xml Element Count    tupleResponse should contain one source type    ${Operation Response Body 2}    1    sourceType    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    Check only one client batch operation ID per response    ${Operation Response Body 2}    1    clientBatchOperationId    ${XMLNS RESPONSE TUPLE}
    Run Keyword If    "${Client Batch Operation ID Set}"=="true"    Check clientBatchOperationId    @{Operation Response Body 2}    ${Client Batch Operation ID}
    Run Keyword If    "${Client Batch Operation ID Set}"=="false"    Check clientBatchOperationId    @{Operation Response Body 2}    UnspecifiedClientBatchOperationId
    @{Operation Response Body 3}=    Get Element Xml    @{Operation Response Body 2}    ${XMLNS RESPONSE TUPLE}    notes
    Check Xml Element Value Equals    noteType should be "Matching Rules Note"    ${Operation Response Body 3}    Matching Rules Note    noteType    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    summary should be "Business Rules have Matched"    ${Operation Response Body 3}    Business Rules have Matched    summary    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    description should be "Rules with following Ids had the defined Consequence(s) applied."    ${Operation Response Body 3}    Rules with following Ids had the defined Consequence(s) applied.    description    ${XMLNS RESPONSE TUPLE}
    ${number_of_rules_matched}=    Get Xml Element Count    @{Operation Response Body 3}    ruleMatchedId    ${XMLNS RESPONSE TUPLE}
    Should Be True    ${number_of_rules_matched}>=1    Update operation did not contain 1 or more rule matches.

Update Operation Response Body tupleEchoPolicy CREATE
    [Arguments]    ${Operation Response Body Update}    ${Operation Response Body Retrieve}    ${Client Batch Operation ID Set}=${true}    ${Client Batch Operation ID}=${EMPTY}
    [Documentation]    Checks the structure and content of the xml of the response body batchOperationResponse element returned for a both a *batch* and *non-batch* update operation when the tupleEchoPolicy is CREATE. A retrieval operation will be undertaken as part of the update operation. Therefore, this keywords checks the content of the batchOperationResponse element returned for the creation part of the operation and the general content features of the batchOperationResponse element returned for the retrieve part of the operation. The details of a retrieval operation that can very between operations must be checked using other keywords.
    ...
    ...
    ...    *Arguments*
    ...    - ${Operation Response Body} = The batchOperationResponse xml element returned for the update operation.
    ...    - ${Client Batch Operation ID Set} (default = ${true}, must be ${true} or ${false}) = If a clientBatchOperationId has been specified.
    ...    - ${Client Batch Operation ID} (OPTIONAL, default=${EMPTY}) = The value set for the clientBatchOperationId for a batch update operation.
    ...
    ...    *Return Values*
    ...
    ...    None
    ...
    ...    *Examples*
    ...
    ...    Example: Batch Update Operation:
    ...
    ...    | ${Property XML 1} = Batch Set Property (Non-Linked) | String Property | ${propertytermid} | ${propertyid}| String Value 1 |
    ...    | ${Update Operation}= | Batch Update Operation XML tupleEchoPolicy | ${termtermid} | Key Property Value 1 | ${tuple id} | CREATE | ${Property XML 1} |
    ...    | @{Operation Response Body}= | Batch Request | +0 | 1 | Operation 1=${Update Operation}
    ...    | Update Operation Response Body tupleEchoPolicy CREATE | @{Operation Response Body}[0] | true | Update Batch Operation ID 1 |
    ...
    ...    Example: Non-Batch Update Operation:
    ...
    ...    | ${Property XML 1} = | Batch Set Property (Non-Linked) | String Property | ${propertytermid} | ${propertyid} | String Value 1 |
    ...    | @{Operation Response Body}= | Update Tuple tupleEchoPolicy | ${termtermid} | Key Property Value 1 | ${tuple id} | CREATE | ${Property XML 1} |
    ...    | Update Operation Response Body tupleEchoPolicy CREATE | @{Operation Response Body [0] | false |
    # Validation of the Update Operation Section of the Response body:
    Check Xml Element Count    check one tupleResponse in response body    ${Operation Response Body Update}    1    tupleResponse    ${XMLNS RESPONSE BATCH}
    @{Operation Response Body 2}=    Get Element Xml    ${Operation Response Body Update}    ${XMLNS RESPONSE BATCH}    tupleResponse
    Check Xml Does Not Contain Element    tupleResponse should not contain tuple element    ${Operation Response Body 2}    tuple    ${XMLNS RESPONSE TUPLE}
    Check Xml Does Not Contain Element    tupleResponse should not contain hubTupleSequence element    ${Operation Response Body 2}    hubTupleSequence    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    tupleResponse status should be "Request Completed OK"    ${Operation Response Body 2}    Request Completed OK    status    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    Checks there is one transactionId element    ${Operation Response Body 2}    1    transactionId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Is Not Empty    Checks the transactionId has a value    ${Operation Response Body 2}    transactionId    ${XMLNS RESPONSE TUPLE}
    @{transactionId value}=    Get Element Value    ${Operation Response Body 2}    ${XMLNS RESPONSE TUPLE}    transactionId
    Check Xml Element Count    tupleResponse should contain one source type    ${Operation Response Body 2}    1    sourceType    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    Check only one client batch operation ID per response    ${Operation Response Body 2}    1    clientBatchOperationId    ${XMLNS RESPONSE TUPLE}
    Run Keyword If    "${Client Batch Operation ID Set}"=="true"    Check clientBatchOperationId    @{Operation Response Body 2}    ${Client Batch Operation ID}
    Run Keyword If    "${Client Batch Operation ID Set}"=="false"    Check clientBatchOperationId    @{Operation Response Body 2}    UnspecifiedClientBatchOperationId
    @{Operation Response Body 3}=    Get Element Xml    @{Operation Response Body 2}    ${XMLNS RESPONSE TUPLE}    notes
    Check Xml Element Value Equals    noteType should be "Matching Rules Note"    ${Operation Response Body 3}    Matching Rules Note    noteType    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    summary should be "Business Rules have Matched"    ${Operation Response Body 3}    Business Rules have Matched    summary    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    description should be "Rules with following Ids had the defined Consequence(s) applied."    ${Operation Response Body 3}    Rules with following Ids had the defined Consequence(s) applied.    description    ${XMLNS RESPONSE TUPLE}
    ${number_of_rules_matched}=    Get Xml Element Count    @{Operation Response Body 3}    ruleMatchedId    ${XMLNS RESPONSE TUPLE}
    Should Be True    ${number_of_rules_matched}>=1    Update operation did not contain 1 or more rule matches.
    # Validation of Retrieve Operation Section of the Response Body:
    Check Xml Element Count    One tupleResponse element per retrieve response body    ${Operation Response Body Retrieve}    1    tupleResponse    ${XMLNS RESPONSE BATCH}
    @{Operation Response Body 4}=    Get Element Xml    ${Operation Response Body Retrieve}    ${XMLNS RESPONSE BATCH}    tupleResponse
    Check Xml Element Value Equals    Status should be "Request Completed OK"    ${Operation Response Body 4}    Request Completed OK    status    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    Checks there is one transactionId element    ${Operation Response Body 4}    1    transactionId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Is Not Empty    Checks the transactionId has a value    ${Operation Response Body 4}    transactionId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Checks the transactionId value is equal to the transactionId value in the batchOperationResponse relating to the update operation    ${Operation Response Body 4}    @{transactionId value}[0]    transactionId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Source type should be "RULES"    ${Operation Response Body 4}    RULES    sourceType    ${XMLNS RESPONSE TUPLE}
    # NOTES ELEMENT VALIDATION
    Check Xml Element Count    One notes element per tupleResponse    ${Operation Response Body 4}    1    notes    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 5}=    Get Element Xml    @{Operation Response Body 4}    ${XMLNS RESPONSE TUPLE}    notes
    Check Xml Element Value Equals    Note type should be "Matching Rules Note"    ${Operation Response Body 5}    Matching Rules Note    noteType    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Summary should be "Business Rules have Matched"    ${Operation Response Body 5}    Business Rules have Matched    summary    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Description should be "Rules with following Ids had the defined Consequence(s) applied."    ${Operation Response Body 5}    Rules with following Ids had the defined Consequence(s) applied.    description    ${XMLNS RESPONSE TUPLE}
    Comment    @{ruleMatchedIdsRetrieve}=    Get Element Value    @{Operation Response Body 5}    ${XMLNS RESPONSE TUPLE}    ruleMatchedId
    Comment    Log Many    @{ruleMatchedIdsRetrieve}
    Comment    ${lengthruleMatchedIdsRetrieve}=    Get Length    ${ruleMatchedIdsRetrieve}
    Comment    Should Be True    ${lengthruleMatchedIdsRetrieve}>=1
    # HUB TUPLE SEQUENCE VALIDATION
    Check Xml Element Count    One hubTupleSequence element per tupleResponse    ${Operation Response Body 4}    1    hubTupleSequence    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    One hubSpecifier element per tupleResponse    ${Operation Response Body 4}    1    hubSpecifier    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 7}=    Get Element Xml    ${Operation Response Body 4}    ${XMLNS RESPONSE TUPLE}    hubSpecifier
    #Check Xml Element Value Equals    ID should be "${ASSET_HUB_ID}"    ${Operation Response Body 7}    ${ASSET_HUB_ID}    id    ${XMLNS RESPONSE TUPLE}
    #Check Xml Element Value Equals    Description should be "Asset hub to store Assets"    ${Operation Response Body 7}    Asset hub to store Assets    description    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    One tupleSequence element per hubSpecifier    ${Operation Response Body 4}    1    tupleSequence    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 8}=    Get Element Xml    ${Operation Response Body 4}    ${XMLNS RESPONSE TUPLE}    tupleSequence
    Check Xml Contains Element    tuple element present    ${Operation Response Body 8}    tuple    ${XMLNS RESPONSE TUPLE}

Delete Operation Response Body
    [Arguments]    ${Operation Response Body}    ${Client Batch Operation ID Set}=${true}    ${Client Batch Operation ID}=${EMPTY}
    [Documentation]    Checks the structure and content of the xml of the response body batchOperationResponse element returned for both a *batch* and *non-batch* deletion operation when the tupleEchoPolicy is IGNORE (the default when unspecified).
    ...
    ...    *Arguments*
    ...    - ${Operation Response Body} = The batchOperationResponse xml element returned for the deletion operation.
    ...    - ${Client Batch Operation ID Set} (default = ${true}, must be ${true} or ${false}) = If a clientBatchOperationId has been specified.
    ...    - ${Client Batch Operation ID} (OPTIONAL, default=${EMPTY}) = The value set for the clientBatchOperationId for a batch update operation.
    ...
    ...    *Return Values*
    ...
    ...    None
    ...
    ...    *Examples*
    ...
    ...    Example: Batch Deletion Operation:
    ...
    ...    | ${Delete Operation}= | Batch Delete Operation XML | ${termtermid} | Key Property Value 1 | ${tuple id} | Delete Batch Operation ID 1 |
    ...    | @{Operation Response Body}= | Batch Request | +0 | 1 | Operation 1=${Delete Operation |
    ...    | Delete Operation Response Body | @{Operation Response Body}[0] | true | Delete Batch Operation ID 1 |
    ...
    ...    Example: Non-Batch Deletion Operation:
    ...
    ...    | @{Operation Response Body}= | Delete Tuple | ${termtermid} | Key Property Value 1 | ${tuple id} |
    ...    | Delete Operation Response Body | @{Operation Response Body}[0] | false |
    Check Xml Element Count    One tupleResponse per response    ${Operation Response Body}    1    tupleResponse    ${XMLNS RESPONSE BATCH}
    @{Operation Response Body 2}=    Get Element Xml    ${Operation Response Body}    ${XMLNS RESPONSE BATCH}    tupleResponse
    Check Xml Does Not Contain Element    Check no hubTupleSequence within the tupleResponse    ${Operation Response Body 2}    hubTupleSequence    ${XMLNS RESPONSE TUPLE}
    Check Xml Does Not Contain Element    Check no hubSpecifier within the tupleResponse    ${Operation Response Body 2}    hubSpecifier    ${XMLNS RESPONSE TUPLE}
    Check Xml Does Not Contain Element    Check no tupleSequence within the tupleResponse    ${Operation Response Body 2}    tupleSequence    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Request status should be "Request Completed OK"    ${Operation Response Body 2}    Request Completed OK    status    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    Checks there is one transactionId element    ${Operation Response Body 2}    1    transactionId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Is Not Empty    Checks the transactionId has a value    ${Operation Response Body 2}    transactionId    ${XMLNS RESPONSE TUPLE}
    Run Keyword If    "${Client Batch Operation ID Set}"=="true"    Check clientBatchOperationId    @{Operation Response Body 2}    ${Client Batch Operation ID}
    Run Keyword If    " ${Client Batch Operation ID Set}"=="false"    Check Xml Does Not Contain Element    Check no clientBatchOperationId within tupleResponse    ${Operation Response Body 2}    clientBatchOperationId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    One sourceType element per tupleResponse    ${Operation Response Body 2}    1    sourceType    ${XMLNS RESPONSE TUPLE}
    # NOTES ELEMENT VALIDATION
    Check Xml Element Count    One notes element per tupleResponse    ${Operation Response Body 2}    1    notes    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 3}=    Get Element Xml    ${Operation Response Body 2}    ${XMLNS RESPONSE TUPLE}    notes
    Check Xml Element Value Equals    Note type should be "Matching Rules Note"    ${Operation Response Body 3}    Matching Rules Note    noteType    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Summary should be "Business Rules have Matched"    ${Operation Response Body 3}    Business Rules have Matched    summary    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Description should be "Rules with following Ids had the defined Consequence(s) applied."    ${Operation Response Body 3}    Rules with following Ids had the defined Consequence(s) applied.    description    ${XMLNS RESPONSE TUPLE}
    ${number_of_rules_matched}=    Get Xml Element Count    @{Operation Response Body 3}    ruleMatchedId    ${XMLNS RESPONSE TUPLE}
    Should Be True    ${number_of_rules_matched}>=1    Delete operation did not contain 1 or more rule matches.

Delete Operation Response Body tupleEchoPolicy CREATE
    [Arguments]    ${Operation Response Body Retrieve}    ${Operation Response Body Delete}    ${Client Batch Operation ID Set}=${true}    ${Client Batch Operation ID}=${EMPTY}
    [Documentation]    Checks the structure and content of the xml of the response body batchOperationResponse element returned for both a *batch* and *non-batch* deletion operation when the tupleEchoPolicy is CREATE.
    ...
    ...    *Arguments*
    ...    - ${Operation Response Body} = The batchOperationResponse xml element returned for the deletion operation.
    ...    - ${Client Batch Operation ID Set} (default = ${true}, must be ${true} or ${false}) = If a clientBatchOperationId has been specified.
    ...    - ${Client Batch Operation ID} (OPTIONAL, default=${EMPTY}) = The value set for the clientBatchOperationId for a batch update operation.
    ...
    ...    *Return Values*
    ...
    ...    None
    ...
    ...    *Examples*
    ...
    ...    Example: Batch Deletion Operation:
    ...
    ...    | ${Delete Operation}= | Batch Delete Operation XML | ${termtermid} | Key Property Value 1 | ${tuple id} | Delete Batch Operation ID 1 |
    ...    | @{Operation Response Body}= | Batch Request | +0 | 1 | Operation 1=${Delete Operation |
    ...    | Delete Operation Response Body tupleEchoPolicy CREATE | @{Operation Response Body}[0] | true | Delete Batch Operation ID 1 |
    ...
    ...    Example: Non-Batch Deletion Operation:
    ...
    ...    | @{Operation Response Body}= | Delete Tuple | ${termtermid} | Key Property Value 1 | ${tuple id} |
    ...    | Delete Operation Response Body tupleEchoPolicy CREATE | @{Operation Response Body}[0] | false |
    # Validation of Retrieve Operation Section of the Response Body:
    Check Xml Element Count    One tupleResponse element per retrieve response body    ${Operation Response Body Retrieve}    1    tupleResponse    ${XMLNS RESPONSE BATCH}
    @{Operation Response Body 4}=    Get Element Xml    ${Operation Response Body Retrieve}    ${XMLNS RESPONSE BATCH}    tupleResponse
    Check Xml Element Value Equals    Status should be "Request Completed OK"    ${Operation Response Body 4}    Request Completed OK    status    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    Checks there is one transactionId element    ${Operation Response Body 4}    1    transactionId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Is Not Empty    Checks the transactionId has a value    ${Operation Response Body 4}    transactionId    ${XMLNS RESPONSE TUPLE}
    @{transactionId value}=    Get Element Value    ${Operation Response Body 4}    ${XMLNS RESPONSE TUPLE}    transactionId
    Check Xml Element Value Equals    Source type should be "RULES"    ${Operation Response Body 4}    RULES    sourceType    ${XMLNS RESPONSE TUPLE}
    # NOTES ELEMENT VALIDATION
    Check Xml Element Count    One notes element per tupleResponse    ${Operation Response Body 4}    1    notes    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 5}=    Get Element Xml    @{Operation Response Body 4}    ${XMLNS RESPONSE TUPLE}    notes
    Check Xml Element Value Equals    Note type should be "Matching Rules Note"    ${Operation Response Body 5}    Matching Rules Note    noteType    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Summary should be "Business Rules have Matched"    ${Operation Response Body 5}    Business Rules have Matched    summary    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Description should be "Rules with following Ids had the defined Consequence(s) applied."    ${Operation Response Body 5}    Rules with following Ids had the defined Consequence(s) applied.    description    ${XMLNS RESPONSE TUPLE}
    Comment    @{ruleMatchedIdsRetrieve}=    Get Element Value    @{Operation Response Body 5}    ${XMLNS RESPONSE TUPLE}    ruleMatchedId
    Comment    Log Many    @{ruleMatchedIdsRetrieve}
    Comment    ${lengthruleMatchedIdsRetrieve}=    Get Length    ${ruleMatchedIdsRetrieve}
    Comment    Should Be True    ${lengthruleMatchedIdsRetrieve}>=1
    # HUB TUPLE SEQUENCE VALIDATION
    Check Xml Element Count    One hubTupleSequence element per tupleResponse    ${Operation Response Body 4}    1    hubTupleSequence    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    One hubSpecifier element per tupleResponse    ${Operation Response Body 4}    1    hubSpecifier    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 7}=    Get Element Xml    ${Operation Response Body 4}    ${XMLNS RESPONSE TUPLE}    hubSpecifier
    #Check Xml Element Value Equals    ID should be "${ASSET_HUB_ID}"    ${Operation Response Body 7}    ${ASSET_HUB_ID}    id    ${XMLNS RESPONSE TUPLE}
    #Check Xml Element Value Equals    Description should be "Asset hub to store Assets"    ${Operation Response Body 7}    Asset hub to store Assets    description    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    One tupleSequence element per hubSpecifier    ${Operation Response Body 4}    1    tupleSequence    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 8}=    Get Element Xml    ${Operation Response Body 4}    ${XMLNS RESPONSE TUPLE}    tupleSequence
    Check Xml Contains Element    tuple element present    ${Operation Response Body 8}    tuple    ${XMLNS RESPONSE TUPLE}
    # Validation of the Deletion Operation Section of the Response Body:
    Check Xml Element Count    One tupleResponse per response    ${Operation Response Body Delete}    1    tupleResponse    ${XMLNS RESPONSE BATCH}
    @{Operation Response Body 2}=    Get Element Xml    ${Operation Response Body Delete}    ${XMLNS RESPONSE BATCH}    tupleResponse
    Check Xml Does Not Contain Element    Check no hubTupleSequence within the tupleResponse    ${Operation Response Body 2}    hubTupleSequence    ${XMLNS RESPONSE TUPLE}
    Check Xml Does Not Contain Element    Check no hubSpecifier within the tupleResponse    ${Operation Response Body 2}    hubSpecifier    ${XMLNS RESPONSE TUPLE}
    Check Xml Does Not Contain Element    Check no tupleSequence within the tupleResponse    ${Operation Response Body 2}    tupleSequence    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Request status should be "Request Completed OK"    ${Operation Response Body 2}    Request Completed OK    status    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    Checks there is one transactionId element    ${Operation Response Body 2}    1    transactionId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Is Not Empty    Checks the transactionId has a value    ${Operation Response Body 2}    transactionId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Checks the transactionId value is equal to the transactionId value in the batchOperationResponse relating to the retrieval operation    ${Operation Response Body 2}    @{transactionId value}[0]    transactionId    ${XMLNS RESPONSE TUPLE}
    Run Keyword If    "${Client Batch Operation ID Set}"=="true"    Check clientBatchOperationId    @{Operation Response Body 2}    ${Client Batch Operation ID}
    Run Keyword If    " ${Client Batch Operation ID Set}"=="false"    Check Xml Does Not Contain Element    Check no clientBatchOperationId within tupleResponse    ${Operation Response Body 2}    clientBatchOperationId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    One sourceType element per tupleResponse    ${Operation Response Body 2}    1    sourceType    ${XMLNS RESPONSE TUPLE}
    # NOTES ELEMENT VALIDATION
    Check Xml Element Count    One notes element per tupleResponse    ${Operation Response Body 2}    1    notes    ${XMLNS RESPONSE TUPLE}
    @{Operation Response Body 3}=    Get Element Xml    ${Operation Response Body 2}    ${XMLNS RESPONSE TUPLE}    notes
    Check Xml Element Value Equals    Note type should be "Matching Rules Note"    ${Operation Response Body 3}    Matching Rules Note    noteType    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Summary should be "Business Rules have Matched"    ${Operation Response Body 3}    Business Rules have Matched    summary    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Description should be "Rules with following Ids had the defined Consequence(s) applied."    ${Operation Response Body 3}    Rules with following Ids had the defined Consequence(s) applied.    description    ${XMLNS RESPONSE TUPLE}
    ${number_of_rules_matched}=    Get Xml Element Count    @{Operation Response Body 3}    ruleMatchedId    ${XMLNS RESPONSE TUPLE}
    Should Be True    ${number_of_rules_matched}>=1    Delete operation did not contain 1 or more rule matches.

Retrieve Response Body for Property of a Tuple (Non-Linked)
    [Arguments]    ${Response Body}    ${Response Body Tuple ID}    ${Response Body Term ID}    ${Response Body Key Property Value}    ${Response Body Property Name}    ${Response Body Property TermID}
    ...    ${Response Body Property ID}    ${if value}    ${if units}    ${Response Body Property Value}=${EMPTY}    ${Response Body Units}=${EMPTY}
    [Documentation]    Validates the values returned in a retrieve operation response body for a particular property of *non-linked* type of a particular tuple. Includes checking the following have just one value:
    ...
    ...    - tupleId in the tupleSpecifier
    ...    - name in the propertySpecifier
    ...
    ...    Includes checking the following have just one value that this value is correct:
    ...    - termId in the tupleSpecifier
    ...    - keyPropertyValue in the tupleSpecifier
    ...    - termId in the propertySpecifier
    ...    - propertyId in the propertySpecifier
    ...    - value in the propertySpecifier
    ...
    ...    *Arguments*
    ...
    ...    ${Response Body} = XML chunk to check
    ...
    ...    ${Response Body Tuple ID} = ID of the tuple
    ...
    ...    ${Response Body Term ID} = ID of the term of the tuple
    ...
    ...    ${Response Body Key Property Value} = Value of the key property of the tuple
    ...
    ...    ${Response Body Property Name} = Name of the property
    ...
    ...    ${Response Body Property Term ID} = ID of the term the property the property belongs to
    ...
    ...    ${Response Body Property ID}= ID of the property
    ...
    ...    ${ifvalue} = Set as true if property has a value
    ...
    ...    ${if units} = Set as true if property has units, otherwise set as false
    ...
    ...    ${Response Body Property Value} = Value of the property (OPTIONAL only if ${ifvalue}=false)
    ...
    ...    ${if units} = Set as true if property has units, otherwise set as false
    ...
    ...    ${Response Body Units} = Value of the unit (OPTIONAL only if ${ifunits}=false)
    ...
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...
    ...    *Example*
    ...
    ...    | ${Operation Retrieve}= | Batch Retrieve Operation XML | ${Response Body Term Term ID} | Key Property Value 1 | ${Response Body Tuple ID} |
    ...    | @{Operation Response body} = | Batch Request | +0 | 1 | ${Operation Retrieve} |
    ...    | Retreive Response Body for Property of a Tuple (Non-Linked) | @{Operation Response Body}[0] | ${Response Body Tuple ID} | ${Response Body Term ID} | Key Property Value 1 | Property 1 | ${Response Body Property Term ID} | ${Response Body Property ID} | true | true | Property 1 Value 1 | cm |
    @{Response Body 2}=    Get Element Xml From Child Value    ${Response Body}    ${XMLNS RESPONSE TUPLE}    tuple    ${XMLNS RESPONSE TUPLE}    tupleId
    ...    ${Response Body Tuple ID}
    ${lengthresponsebody2}=    Get Length    ${Response Body 2}
    Check Number Equals    One tuple element which has a tuple ID of ${Response Body Tuple ID}    ${lengthresponsebody2}    1
    Check Xml Element Count    One tupleSpecifier element per tuple    ${Response Body 2}    1    tupleSpecifier    ${XMLNS RESPONSE TUPLE}
    @{Response Body 3}=    Get Element Xml    @{Response Body 2}    ${XMLNS RESPONSE TUPLE}    tupleSpecifier
    Check Xml Element Value Equals    termId value should be ${Response Body Term ID}    ${Response Body 3}    ${Response Body Term ID}    termId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Key property value should be ${Response Body Term ID}    ${Response Body 3}    ${Response Body Key Property Value}    keyPropertyValue    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    One tuple ID per tupleSpecifier    ${Response Body 3}    1    tupleId    ${XMLNS RESPONSE TUPLE}
    @{Response Body 4}=    Get Element Xml From Child Value    @{Response Body 2}    ${XMLNS RESPONSE TUPLE}    property    ${XMLNS4}    name
    ...    ${Response Body Property Name}
    ${lengthresponsebody4}=    Get Length    ${Response Body 4}
    Check Number Equals    One property element which has a name of ${Response Body Property Name}    ${lengthresponsebody4}    1
    Check Xml Element Count    One propertySpecifier per property element    ${Response Body 4}    1    propertySpecifier    ${XMLNS RESPONSE TUPLE}
    @{Response Body 5}=    Get Element Xml    @{Response Body 4}    ${XMLNS RESPONSE TUPLE}    propertySpecifier
    Check Xml Element Count    One name per property specifier element    ${Response Body 5}    1    name    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    term ID should be ${Response Body Property Term ID}    ${Response Body 5}    ${Response Body Property TermID}    termId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    property ID should be ${Response Body Property ID}    ${Response Body 5}    ${Response Body Property ID}    propertyId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    One propertyValue per property element    ${Response Body 4}    1    propertyValue    ${XMLNS RESPONSE TUPLE}
    @{Response Body 6}=    Get Element Xml    @{Response Body 4}    ${XMLNS RESPONSE TUPLE}    propertyValue
    Run Keyword If    '${if value}'=='true'    Check Xml Element Value Equals    property value should be ${Response Body Property Value}    ${Response Body 6}    ${Response Body Property Value}    value
    ...    ${XMLNS RESPONSE TUPLE}
    Run Keyword Unless    '${if value}'=='true'    Check Xml Does Not Contain Element    property value element should not be present in XML    ${Response Body 6}    value    ${XMLNS RESPONSE TUPLE}
    Run Keyword If    '${if units}'=='true'    Check Xml Element Value Equals    property units should be ${Response Body Units}    ${Response Body 6}    ${Response Body Units}    unit
    ...    ${XMLNS RESPONSE TUPLE}
    Run Keyword Unless    '${if units}'=='true'    Check Xml Does Not Contain Element    property unit element should not be present in XML    ${Response Body 6}    unit    ${XMLNS RESPONSE TUPLE}

Retrieve Response Body for Property of a Tuple (Linked)
    [Arguments]    ${Response Body}    ${Response Body Tuple ID}    ${Response Body Term ID}    ${Response Body Key Property Value}    ${Response Body Property Name}    ${Response Body Property TermID}
    ...    ${Response Body Property ID}    ${if values set}    ${Response Body Linked Property Tuple ID}=${EMPTY}    ${Response Body Linked Property Term ID}=${EMPTY}
    [Documentation]    Validates the values returned in the response body for a particular property of *linked* type of a particular tuple. Includes checking the following have just one value:
    ...
    ...    - tupleId in the tupleSpecifier
    ...    - name in the propertySpecifier
    ...    Includes checking the following have just one value that this value is correct:
    ...
    ...    - termId in the tupleSpecifier
    ...    - keyPropertyValue in the tupleSpecifier
    ...    - termId in the propertySpecifier
    ...    - propertyId in the propertySpecifier
    ...    - linkedPropertyTermId in the propertySpecifier
    ...    - linkedPropertyTupleId in the propertySpecifier
    ...
    ...    *Arguments*
    ...
    ...    -${Response Body} = XML chunk to check
    ...
    ...    -${Response Body Tuple ID} = ID of the tuple
    ...
    ...    -${Response Body Term Term ID} = ID of the term of the tuple
    ...
    ...    -${Response Body Key Property Value} = Value of the key property of the tuple
    ...
    ...    -${Response Body Property Name} = Name of the property
    ...
    ...    -${Response Body Property Term ID} = ID of the term the property the property belongs too
    ...
    ...    -${Response Body Property ID}= ID of the property
    ...
    ...    -{if values set} = Set as true if value set, otherwiser set as false
    ...
    ...    -${Response Body Linked Property Tuple ID} - ID of the tuple the property is linked to (OPTIONAL only if ${if values set}= false}
    ...
    ...    -${Response Body Linked Property Term ID} - ID of the term the property is linked to (OPTIONAL only if ${if values set}= false}
    ...
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...
    ...    *Example*
    ...
    ...    | ${Operation Retrieve}= | Batch Retrieve Operation XML | ${Response Body Term Term ID} | Key Property Value 1 | ${Response Body Tuple ID} |
    ...    | @{Operation Response body} = | Batch Request | +0 | 1 | ${Operation Retrieve} |
    ...    | Retreive Response Body for Property of a Tuple (Non-Linked) | @{Operation Response Body}[0] | ${Response Body Tuple ID} | ${Response Body Term ID} | Key Property Value 1 | Property 1 | ${Response Body Property Term ID} | ${Response Body Property ID} | true | ${Response Body Linked Tuple ID} | ${Response Body Linked Term ID} |
    @{Response Body 2}=    Get Element Xml From Child Value    ${Response Body}    ${XMLNS RESPONSE TUPLE}    tuple    ${XMLNS RESPONSE TUPLE}    tupleId
    ...    ${Response Body Tuple ID}
    ${lengthresponsebody2}=    Get Length    ${Response Body 2}
    Check Number Equals    One tuple element which has a tuple ID of ${Response Body Tuple ID}    ${lengthresponsebody2}    1
    Check Xml Element Count    one tupleSpecifier element per term    ${Response Body 2}    1    tupleSpecifier    ${XMLNS RESPONSE TUPLE}
    @{Response Body 3}=    Get Element Xml    @{Response Body 2}    ${XMLNS RESPONSE TUPLE}    tupleSpecifier
    Check Xml Element Value Equals    term ID value should equal ${Response Body Term ID}    ${Response Body 3}    ${Response Body Term ID}    termId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    key property value should equal ${Response Body Key Property Value}    ${Response Body 3}    ${Response Body Key Property Value}    keyPropertyValue    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    One tuple ID element per tuple specifier    ${Response Body 3}    1    tupleId    ${XMLNS RESPONSE TUPLE}
    @{Response Body 4}=    Get Element Xml From Child Value    @{Response Body 2}    ${XMLNS RESPONSE TUPLE}    property    ${XMLNS RESPONSE TUPLE}    name
    ...    ${Response Body Property Name}
    ${lengthresponsebody4}=    Get Length    ${Response Body 4}
    Check Number Equals    One property element which has a name of ${Response Body Property Name}    ${lengthresponsebody4}    1
    Check Xml Element Count    One property specifier per property    ${Response Body 4}    1    propertySpecifier    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Term ID should be ${Response Body Property Term ID}    ${Response Body 4}    ${Response Body Property TermID}    termId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    Property ID should be ${Response Body Property ID}    ${Response Body 4}    ${Response Body Property ID}    propertyId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    One link element per property    ${Response Body 4}    1    link    ${XMLNS RESPONSE TUPLE}
    @{Response Body 6}=    Get Element Xml    @{Response Body 4}    ${XMLNS RESPONSE TUPLE}    link
    Run Keyword If    '${if values set}'=='true'    Check Xml Element Value Equals    Link tuple ID should be ${Response Body Linked Property Tuple ID}    ${Response Body 6}    ${Response Body Linked Property Tuple ID}    linkTupleId
    ...    ${XMLNS RESPONSE TUPLE}
    Run Keyword Unless    '${if values set}'=='true'    Check Xml Does Not Contain Element    Property should not contain link tuple ID element    ${Response Body 6}    linkTupleId    ${XMLNS RESPONSE TUPLE}
    Run Keyword If    '${if values set}'=='true'    Check Xml Element Value Equals    Link term should be ${Response Body Linked Property Term ID}    ${Response Body 6}    ${Response Body Linked Property Term ID}    linkTermId
    ...    ${XMLNS RESPONSE TUPLE}
    Run Keyword Unless    '${if values set}'=='true'    Check Xml Does Not Contain Element    Property should not contain link term ID element    ${Response Body 6}    linkTermId    ${XMLNS RESPONSE TUPLE}

Retrieve Response Body for an Individual Tuple
    [Arguments]    ${Response Body}    ${Response Body Tuple ID}    ${Response Body Term Term ID}    ${Response Body Key Property Value}    ${Expected No Properties}    ${Expected No Property Names}
    ...    ${propertynamelist}    ${Expected No Property Term IDs}    ${propertytermIdlist}    ${Expected No Property IDs}    ${propertyIdlist}    ${Expected No propertyValue}
    ...    ${Expecte No Values}    ${propertyvaluelist}    ${Expected No Linked Properties}    ${if units}    ${if linked properties}    ${Expected No Units}=${EMPTY}
    ...    ${listunits}=${EMPTY}    ${Expected No Linked Property Tuple IDs}=${EMPTY}    ${listlinkedPropertyTupleId}=${EMPTY}    ${Expected No Linked Property Term IDs}=${EMPTY}    ${listlinkedPropertyTermId}=${EMPTY}
    [Documentation]    Validates structure and content of the tuple element section of a response body for an indivdual tuple returned ny either a batch or non-batch operation that uses either a valid value or wildcards in the URL for the Key Property Value and Tuple ID.
    ...
    ...    Checks include:
    ...
    ...    - there is only one tuple element for the tuple ID in the response body
    ...    - there is only one propertySpecifier element per tuple ID
    ...    - there is only one value for each the term termId, keyPropertyValue and tupleId in the propertySpecifier and the correct values are set for the term termId and keyPropertyValue
    ...    - there is the correct number of propertySpecifiers according to the number of properties of the term
    ...    - there is the correct number of entries for name, property termId, propertyId and value within the propertySpecifiers according to the number of properties the tuple has and that the correct values have been set for these
    ...
    ...    *Arguments*
    ...
    ...    ${Response Body} = XML chunk to check
    ...
    ...    ${Response Body Tuple ID} _ ID of the tuple
    ...
    ...    ${Response Body Term Term ID} - Term ID of the term of the tuple
    ...
    ...    ${Response Body Key Property Value} - Value of the key property of the tuple
    ...
    ...    ${Expected No propertySpecifiers}-Expected number of propertySpecifers in response
    ...
    ...    ${Expected No Property Names} - Expected number of properties
    ...
    ...    ${propertynamelist} - List of property names of the term of the tuple - Create List keyword must be used to supply this
    ...
    ...    ${Expected No Property Term IDs} - Expected number of property term IDs
    ...
    ...    ${propertytermIdlist} - List of IDs of the property terms - Create List keyword must be used to supply this
    ...
    ...    ${Expected No Property IDs} - Expected number of property term IDs
    ...
    ...    ${propertyIdlist} - List of the IDs of the properties - Create List keyword muct be used to supply this
    ...
    ...    ${Expected No propertyValue} - Number of propertyValue elements
    ...
    ...    ${Expecte No Values} - Expected number of property values - Note: Null values included in count
    ...
    ...    ${propertyvaluelist} - List of the expected property values - Create List keyword must be used to supply this.
    ...
    ...    ${Expected No Linked Properties} = No of linked properties
    ...
    ...    ${if units} = set to true if tuple properties have units
    ...
    ...    ${if linked properties} = set to true if linked properties have values
    ...
    ...    ${Expected No Units} = Expected number of unit values (Optional)
    ...
    ...    ${listunits}= List of the unit values expected - Must be created using the Create List keyword (Optional)
    ...
    ...    ${Expected No Linked Property Tuple IDs} = Expected number of tuple IDs from linked properties (Optional)
    ...
    ...    ${listlinkedPropertyTupleId}= List of the expected tuple ID values - Muct be provided by the Create List keyword (Optional)
    ...
    ...    ${Expected No Linked Property Term IDs} = Expected number of term IDs for linked properties (Optional)
    ...
    ...    ${listlinkedPropertyTermId} = List of the expected term ID values - Must be provided by the Create List keyword (Optional)
    ...
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    | ${Operation Retrieve}= | Batch Retrieve Operation XML | ${Response Body Term Term ID} | Key Property Value 1 | ${Response Body Tuple ID} |
    ...    | @{Operation Response body} = | Batch Request | +0 | 1 | ${Operation Retrieve} |
    ...    | Retrieve Response Body for an Individual Tuple | @{Operation Response Body}[0] | ${Response Body Tuple ID} | ${Response Body Term Term ID} | Key Property Value 1 | 15 | 15 | ${propertynamelist} | 15 | ${propertytermIdlist} | 15 | ${propertyIdlist} | 13 | 10 | ${propertyvaluelist} | 2 | true | true | 1 | ${listunits} | 2 | ${listlinkedPropertyTupleId} | 2 | ${listlinkedPropertyTermId} |
    @{Response Body 2}=    Get Element Xml    ${Response Body}    ${XMLNS RESPONSE TUPLE}    tupleSequence
    @{Response Body 3}=    Get Element Xml From Child Value    @{Response Body 2}    ${XMLNS RESPONSE TUPLE}    tuple    ${XMLNS RESPONSE TUPLE}    tupleId
    ...    ${Response Body Tuple ID}
    Log    Tuple elements which match a tuple ID of ${Response Body Tuple ID}: ${Response Body 3}
    ${lengthresponsebody3}=    Get Length    ${Response Body 3}
    Check Number Equals    Check only 1 tuple element with a tuple ID of ${Response Body Tuple ID}    ${lengthresponsebody3}    1
    Check Xml Element Count    one tupleSpecifier element per tuple    ${Response Body 3}    1    tupleSpecifier    ${XMLNS RESPONSE TUPLE}
    @{Response Body 4}=    Get Element Xml    @{Response Body 3}    ${XMLNS RESPONSE TUPLE}    tupleSpecifier
    Check Xml Element Value Equals    check termId value matches: ${Response Body Term Term ID}    ${Response Body 4}    ${Response Body Term Term ID}    termId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Value Equals    check keyPropertyValue value matches: ${Response Body Key Property Value}    ${Response Body 4}    ${Response Body Key Property Value}    keyPropertyValue    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    one tupleId per tupleSpecifier    ${Response Body 4}    1    tupleId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    one property sequence per tuple element    ${Response Body 3}    1    propertySequence    ${XMLNS RESPONSE TUPLE}
    @{Response Body 5}=    Get Element Xml    @{Response Body 3}    ${XMLNS RESPONSE TUPLE}    propertySequence
    Check Xml Element Count    Number of property elements should be: ${Expected No Properties}    ${Response Body 5}    ${Expected No Properties}    property    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    Number of name elements should be: ${Expected No Property Names}    ${Response Body 5}    ${Expected No Property Names}    name    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Values Contain Sublist    Property name elements should contain the following property names: ${propertynamelist}    ${Response Body 5}    ${propertynamelist}    name    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    Property sequence should contain ${Expected No Property Term IDs} propertySequence/termId elements    ${Response Body 5}    ${Expected No Property Term IDs}    .//{${XMLNS RESPONSE TUPLE}}propertySpecifier/{${XMLNS RESPONSE TUPLE}}termId    xpath=${True}
    Check Xml Element Values Contain Sublist    Property sequence should contain propertySequence/termId elements with the following values: ${propertytermIdlist}    ${Response Body 5}    ${propertytermIdlist}    .//{${XMLNS RESPONSE TUPLE}}propertySpecifier/{${XMLNS RESPONSE TUPLE}}termId    xpath=${True}
    Check Xml Element Count    Property sequence should contain ${Expected No Property IDs} property ID elements    ${Response Body 5}    ${Expected No Property IDs}    propertyId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Values Contain Sublist    Property sequence should contain property ID elements with the following values: ${propertyIdlist}    ${Response Body 5}    ${propertyIdlist}    propertyId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    Property sequence should contain ${Expected No propertyValue} property value elements    ${Response Body 5}    ${Expected No propertyValue}    propertyValue    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    Property sequence should contain ${Expecte No Values} property value elements    ${Response Body 5}    ${Expecte No Values}    value    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Values Contain Sublist    Property sequence should contain value elements with the following values: ${propertyvaluelist}    ${Response Body 5}    ${propertyvaluelist}    value    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    Property sequence should contain ${Expected No Linked Properties} property link elements    ${Response Body 5}    ${Expected No Linked Properties}    link    ${XMLNS RESPONSE TUPLE}
    Run Keyword If    "${if units}"=="true"    Retrieve Response Body Units    @{Response Body 5}    ${Expected No Units}    ${listunits}
    Run Keyword If    "${if linked properties}"=="true"    Retrieve Response Body Linked Properties for Tuples    @{Response Body 5}    ${Expected No Linked Property Tuple IDs}    ${listlinkedPropertyTupleId}    ${Expected No Linked Property Term IDs}
    ...    ${listlinkedPropertyTermId}

Retreive Response Body for Tuples of a Key Property Value
    [Arguments]    ${Response Body}    ${Response Body Key Property Value}    ${Expected No Response Tuples}    ${TermTermId}    ${tupleIdlist}
    [Documentation]    Validates structure of the response body within the tupleSequence element for all the tuples returned by a retrieval operation for a particular key property value.
    ...    Checks:
    ...    - The correct number of tuple elements are returned according to the number of tuples the term has
    ...    - The tuple elements within the tupleSequence have the same term termId
    ...    - The correct number of keyPropertyValues are present in the tupleSequence according to the number of tuples of the term and the values set are correct
    ...    - The tupleIds are correct and unique within the tupleSequence
    ...
    ...    *Arguments*
    ...    - ${Response Body} = XML chunk to check
    ...    - ${Response Body Key Property Value} = The key property value of interest.
    ...    - ${Expected No Response Tuples} - Expected number of tuples in the response
    ...    - ${Term Term ID} - ID of the term
    ...    - ${tupleIdlist} - List of the IDs of the tuples of the term
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    | ${tupleIdlist}= | Create List | ${tupleid}
    ...    | ${Operation Retrieve}= | Batch Retrieve Operation XML | ${Response Body Term Term ID} | Key Property Value 1 | ${Response Body Tuple ID} |
    ...    | @{Operation Response body} = | Batch Request | +0 | 1 | ${Operation Retrieve} |
    ...    | Retrieve Response Body for Tuples of a Key Property Value | @{Operation Response Body}[0] | Key Property Value 1 | 1 | ${TermTermId} | ${tupleIdlist} |
    @{Response Body 2}=    Get Element Xml From Child Value    ${Response Body}    ${XMLNS RESPONSE TUPLE}    tuple    ${XMLNS RESPONSE TUPLE}    keyPropertyValue
    ...    ${Response Body Key Property Value}
    ${lengthkeyProVa}=    Get Length    ${Response Body 2}
    Should Be Equal As Numbers    ${lengthkeyProVa}    ${Expected No Response Tuples}
    @{rettermtermId}=    Get Element Value From Xpath    ${Response Body}    .//{${XMLNS RESPONSE TUPLE}}tupleSpecifier/{${XMLNS RESPONSE TUPLE}}termId
    ${lengthrettermtermId}=    Get Length    ${rettermtermId}
    Should Be Equal As Numbers    ${lengthrettermtermId}    ${Expected No Response Tuples}
    Should Contain    ${rettermtermId}    ${TermTermId}
    @{tupleId}=    Get Element Value    ${Response Body}    ${XMLNS RESPONSE TUPLE}    tupleId
    ${lengthtupleId}=    Get Length    ${tupleId}
    Should Be Equal As Numbers    ${lengthtupleId}    ${Expected No Response Tuples}
    List Should Contain Sub List    ${tupleId}    ${tupleIdlist}

Retrieve Response Body Linked Properties for Tuples
    [Arguments]    ${Tuple Response Body to Query Linked}    ${Expected No Linked Property Tuple IDs}    ${listlinkedPropertyTupleId}    ${Expected No Linked Property Term IDs}    ${listlinkedPropertyTermId}
    [Documentation]    Validates response body structure and content of linked properties for a non-batch GET operation.
    ...    Checks include:
    ...
    ...    - there are the correct number of linkedPropertyTermIds within the propertySpecifier and these are set to the correct value
    ...    - there are the correct number of linkedPropertyTupleIds within the propertySpecifier and these are set to the correct value.
    ...
    ...    *Arguments*
    ...
    ...    ${Tuple Response Body to Query Linked} - XML to query
    ...
    ...    ${Expected No link} = Number of linked properties the term has
    ...
    ...    ${Expected No Linked Property Term IDs} = Expected number of term IDs for linked properties
    ...
    ...    ${listlinkedPropertyTermId} = List of the expected term ID values - Must be provided by the Create List keyword
    ...
    ...    ${Expected No Linked Property Tuple IDs} = Expected number of tuple IDs from linked properties
    ...
    ...    ${listlinkedPropertyTupleId}= List of the expected tuple ID values - Muct be provided by the Create List keyword
    Log    ${Tuple Response Body to Query Linked}
    Check Xml Element Count    XML should contain ${Expected No Linked Property Tuple IDs} of property tuple ID's    ${Tuple Response Body to Query Linked}    ${Expected No Linked Property Tuple IDs}    linkTupleId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Values Contain Sublist    XML should contain the following property Tuple ID's: ${listlinkedPropertyTupleId}    ${Tuple Response Body to Query Linked}    ${listlinkedPropertyTupleId}    linkTupleId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Count    XML should contain ${Expected No Linked Property Term IDs} of property term ID's    ${Tuple Response Body to Query Linked}    ${Expected No Linked Property Term IDs}    linkTermId    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Values Contain Sublist    XML should contain the following property Term ID's: ${listlinkedPropertyTermId}    ${Tuple Response Body to Query Linked}    ${listlinkedPropertyTermId}    linkTermId    ${XMLNS RESPONSE TUPLE}

Retrieve Response Body Units
    [Arguments]    ${Tuple Response Body to Query Units}    ${Expected No Units}    ${listunits}
    [Documentation]    Validates the number and value of units within the propertySpecifier of the response body for a non-linked property retrieved by a successful non-batch GET operation.
    ...
    ...    *Arguments*
    ...
    ...    ${Tuple Response Body to Query Units} = XML to query
    ...
    ...    ${Expected No Units} = Expected number of unit values
    ...
    ...    ${listunits}= List of the unit values expected - Must be created using the Create List keyword
    ...
    ...    *Return Value*
    ...
    ...    None
    Check Xml Element Count    XML should contain ${Expected No Units} unit elements    ${Tuple Response Body to Query Units}    ${Expected No Units}    units    ${XMLNS RESPONSE TUPLE}
    Check Xml Element Values Contain Sublist    XML should contain the following unit element values: ${listunits}    ${Tuple Response Body to Query Units}    ${listunits}    units    ${XMLNS RESPONSE TUPLE}

Check clientBatchOperationId
    [Arguments]    ${response body}    ${Client Batch Operation ID Value}
    [Documentation]    Confirms that value of the clientBatchOperationId in the response body is as expected.
    ...
    ...    *Arguments*
    ...
    ...    -${response body} = The response body xml to confirm the clientBatchOperationId value within.
    ...    -${Client batch Operation ID Value} = Value specified in the request for the clientBatchOperationId.
    ...
    ...    *Return Value*
    ...
    ...    None
    Check Xml Element Count    Check only one client batch operation ID per response    ${response body}    1    clientBatchOperationId    ${XMLNS RESPONSE TUPLE}
    Run Keyword If    '${Client Batch Operation ID Value}'!='${EMPTY}'    Check Xml Element Value Equals    Check client batch operation ID is correct    ${response body}    ${Client Batch Operation ID Value}    clientBatchOperationId
    ...    ${XMLNS RESPONSE TUPLE}

Create Request Body
    [Arguments]    @{properties}
    [Documentation]    Creates the request body xml string for a non-batch create or update operation. *
    ...
    ...    *Arguments*
    ...    -@{properties} = The xml generated by the Set Property Element (Non-Linked) and Set Property Element (Linked) keywords.
    ...
    ...    *Return Value*
    ...    - ${request xml} = hubTechPropertySequence request body xml string for a non-batch create or update operation.
    ${request xml}=    Create Xml Object    hubTechPropertySequence    elementNamespace=${XMLNS REQUEST HUBTECH}
    ${request xml}=    Add List Of Subelements To Xml    ${request xml}    ${properties}
    ${request xml}=    Get Xml    ${request xml}
    [Return]    ${request xml}

Set Property Element (Non-Linked)
    [Arguments]    ${Property Name}    ${Property Term ID}    ${Property ID}    ${Property Value}    ${Property Value Units}=${EMPTY}
    [Documentation]    Creates the request body property element xml for an individual non-linked property for a *non-batch create or update operation*.
    ...
    ...    *Arguments*
    ...    - ${Property Name} = Name of the property
    ...    - ${Property Term ID} = Term ID of the property (i.e. the inherited term ID)
    ...    - ${Property ID} = ID of the property
    ...    - ${Property Value} = Value of the property
    ...    - ${Property Value Units} (OPTIONAL), default = ${EMPTY) = Units of the property value
    ...
    ...    *Return Value*
    ...    - ${property xml} = property request body xml string for a single non-linked property within a non-batch create/update operation.
    ...
    ...    *Example*
    ...
    ...    | ${Property XML 1}= | Set Property Element (Non-Linked) | Property 1 | ${Property Term ID} | ${Property ID} | Property 1 Value 1 Updated | mm
    ...    | @{Operation Response Body}= | Update Tuple | ${URL Term ID} | Key Property Value 1 | ${Tuple ID} | ${Property XML 1} |
    Comment    ${property xml}=    Set Variable    <ns10:property> <ns10:propertySpecifier> <ns10:name>${Property Name}</ns10:name> <ns10:termId>${Property Term ID}</ns10:termId> <ns10:propertyId>${Property ID}</ns10:propertyId> </ns10:propertySpecifier> <ns10:propertyValue> <ns10:value>${Property Value}</ns10:value> <ns10:unit>${Property Value Units}</ns10:unit> </ns10:propertyValue> </ns10:property>
    ${property xml}=    Create Xml Object    property    elementNamespace=${XMLNS REQUEST TUPLE}
    ${propertySpecifier}=    Create Xml Object    propertySpecifier    elementNamespace=${XMLNS REQUEST TUPLE}
    ${name}=    Create Xml Object    name    elementText=${Property Name}    elementNamespace=${XMLNS REQUEST TUPLE}
    ${termId}=    Create Xml Object    termId    elementText=${Property Term ID}    elementNamespace=${XMLNS REQUEST TUPLE}
    ${propertyId}=    Create Xml Object    propertyId    elementText=${Property ID}    elementNamespace=${XMLNS REQUEST TUPLE}
    ${propertySpecifier}=    Add Subelement To Xml    ${propertySpecifier}    ${name}
    ${propertySpecifier}=    Add Subelement To Xml    ${propertySpecifier}    ${termId}
    ${propertySpecifier}=    Add Subelement To Xml    ${propertySpecifier}    ${propertyId}
    ${propValue}=    Create Xml Object    propertyValue    elementNamespace=${XMLNS REQUEST TUPLE}
    ${value}=    Create Xml Object    value    elementText=${Property Value}    elementNamespace=${XMLNS REQUEST TUPLE}
    ${units}=    Create Xml Object    unit    elementText=${Property Value Units}    elementNamespace=${XMLNS REQUEST TUPLE}
    ${propValue}=    Add Subelement To Xml    ${propValue}    ${value}
    ${propValue}=    Add Subelement To Xml    ${propValue}    ${units}
    ${property xml}=    Add Subelement To Xml    ${property xml}    ${propertySpecifier}
    ${property xml}=    Add Subelement To Xml    ${property xml}    ${propValue}
    Comment    ${property xml}=    Get Xml    ${property xml}
    [Return]    ${property xml}

Set Property Element (Linked)
    [Arguments]    ${Property Name}    ${Property Term ID}    ${Property ID}    ${Linked Property Tuple ID}    ${Linked Property Term ID}
    [Documentation]    Creates the request body property element xml for the an individual linked property for a *non-batch create or update operation*.
    ...
    ...    *Arguments*
    ...    - ${Property Name} = Name of the property
    ...    - ${Property Term ID} = Term ID of the property (i.e. the inherited term ID)
    ...    - ${Property ID} = ID of the property
    ...    - ${Linked Property Tuple ID} = ID of the tuple being linked to
    ...    - ${Linked Property Term ID} = Term ID of the term being linked to
    ...
    ...    *Return Value*
    ...    - ${property xml} = property request body xml string for a single non-linked property within a non-batch create/update operation.
    ...
    ...    *Example*
    ...
    ...    | ${Property XML 1}= | Set Property Element (Linked) | Linked Property 1 | ${Property Term ID} | ${Property ID} | ${Linked Property Tuple ID} \ | ${Linked Property Term ID} |
    ...    @{Operation Response Body}= | Create Tuple | ${URL Term ID} | Key Property Value 1 | ${Tuple ID} | ${Property XML 1} |
    ${property xml}=    Create Xml Object    property    elementNamespace=${XMLNS REQUEST TUPLE}
    ${propertySpecifier}=    Create Xml Object    propertySpecifier    elementNamespace$={XMLNS REQUEST TUPLE}
    ${name}=    Create Xml Object    name    elementText=${Property Name}    elementNamespace=${XMLNS REQUEST TUPLE}
    ${termId}=    Create Xml Object    termId    elementText=${Property Term ID}    elementNamespace=${XMLNS REQUEST TUPLE}
    ${propertyId}=    Create Xml Object    propertyId    elementText=${Property ID}    elementNamespace=${XMLNS REQUEST TUPLE}
    ${propertySpecifier}=    Add Subelement To Xml    ${propertySpecifier}    ${name}
    ${propertySpecifier}=    Add Subelement To Xml    ${propertySpecifier}    ${termId}
    ${propertySpecifier}=    Add Subelement To Xml    ${propertySpecifier}    ${propertyId}
    ${link}=    Create Xml Object    link    elementNamespace=${XMLNS REQUEST TUPLE}
    ${linkTupleId}=    Create Xml Object    linkTupleId    elementText=${Linked Property Tuple ID}    elementNamespace=${XMLNS REQUEST TUPLE}
    ${linkTermId}=    Create Xml Object    linkTermId    elementText=${Linked Property Term ID}    elementNamespace=${XMLNS REQUEST TUPLE}
    ${link}=    Add Subelement To Xml    ${link}    ${linkTupleId}
    ${link}=    Add Subelement To Xml    ${link}    ${linkTermId}
    ${property xml}=    Add Subelement To Xml    ${property xml}    ${propertySpecifier}
    ${property xml}=    Add Subelement To Xml    ${property xml}    ${link}
    ${property xml}=    Get Xml    ${property xml}
    [Return]    ${property xml}

Create Tuple
    [Arguments]    ${URL Term ID}    ${Key Property Value}    ${Tuple ID}    @{Properties}
    [Documentation]    Creates a tuple by use of a *non-batch POST operation*.
    ...
    ...    *Arguments*
    ...    - ${URL Term ID} = ID of the term for which the tuple is being created.
    ...    - ${Key Property Value} = Value of the key property to which the created tuple will be associated
    ...    - ${Tuple ID} = The unique GUID of the tuple created.
    ...    -@{properties} = request body property element xml for each property to be specified - Must be supplied by either the Set Property Element (Non-Linked) or Set Property Element (Linked) keyword depending on the property type.
    ...
    ...    *Return Value*
    ...    - @{Operation Response Body} = The batchOperationResponse xml element of the response body.
    ...
    ...    *Example*
    ...    | ${Property XML 1}= | Set Property Element (Non-Linked) | Property 1 | ${propertytermid) | ${propertyid} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Set Property Element (Linked) | Property 2 | ${propertytermid} | ${propertyid} | ${linkTupleId} | ${linkTermId} |
    ...    | @{Operation Response Body} = | Create Tuple | ${URL Term ID} | Key Property 1 | ${Tuple ID} | ${Property XML 1} | ${Property XML 2} |
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected}=    Evaluate    ${tuple count}+1
    Tuple Web Services Request Setup
    ${request body}=    Create Request Body    @{Properties}
    Log    ${request body}
    Set Request Body    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>${request body}
    Run Keyword Unless    '${Key Property Value}'=='${EMPTY}'    POST    ${NON-BATCH END}/${URL Term ID}/${Key Property Value}/${Tuple ID}
    Run Keyword If    '${Key Property Value}'=='${EMPTY}'    POST    ${NON-BATCH END}/${URL Term ID}
    ${Response Body}=    Get Response Body
    Log    ${Response Body}
    Response Status Code Should Equal    200
    Validate Number of Tuples    ${tuple count expected}
    @{Operation Response Body}=    General Response Body    ${Response Body}    2
    Create Operation Response Body    @{Operation Response Body}[0]    @{Operation Response Body}[1]    false
    [Return]    @{Operation Response Body}

Create Tuple User Defined Operation ID
    [Arguments]    ${URL Term ID}    ${Key Property Value}    ${Tuple ID}    ${Batch Operation ID}    @{Properties}
    [Documentation]    Creates a tuple by use of a *non-batch POST operation* including specification of a clientBatchOperationId.
    ...
    ...
    ...
    ...    *Arguments*
    ...    - ${URL Term ID} = ID of the term for which the tuple is being created.
    ...    - ${Key Property Value} = Value of the key property to which the created tuple will be associated
    ...    - ${Tuple ID} = The unique GUID of the tuple created.
    ...    -${Batch Operation ID} = Value of the clientBatchOperationId
    ...    -@{properties} = request body property element xml for each property to be specified - Must be supplied by either the Set Property Element (Non-Linked) or Set Property Element (Linked) keyword depending on the property type.
    ...
    ...    *Return Value*
    ...    - @{Operation Response Body} = The batchOperationResponse xml element of the response body.
    ...
    ...    *Example*
    ...    | ${Property XML 1}= | Set Property Element (Non-Linked) | Property 1 | ${propertytermid} | ${propertyid} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Set Property Element (Linked) | Property 2 |${propertytermid} | ${propertyid} | ${linkTupleId} | ${linkTermId} |
    ...    | @{Operation Response Body} = | Create Tuple | ${URL Term ID} | Key Property 1 | ${Tuple ID} | Client Batch Operation ID 1 | ${Property XML 1} | ${Property XML 2} |
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected}=    Evaluate    ${tuple count}+1
    Tuple Web Services Request Setup
    ${request body}=    Create Request Body    @{Properties}
    Log    ${request body}
    Set Request Body    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>${request body}
    POST    ${NON-BATCH END}/${URL Term ID}/${Key Property Value}/${Tuple ID}/?clientBatchOperationId=${Batch Operation ID}
    ${Response Body}=    Get Response Body
    Log    ${Response Body}
    Response Status Code Should Equal    200
    Validate Number of Tuples    ${tuple count expected}
    @{Operation Response Body}=    General Response Body    ${Response Body}    2
    Create Operation Response Body    @{Operation Response Body}[0]    @{Operation Response Body}[1]    true    ${Batch Operation ID}
    [Return]    @{Operation Response Body}

Create Tuple tupleExistsPolicy
    [Arguments]    ${URL Term ID}    ${Key Property Value}    ${Tuple ID}    ${tupleExistsPolicy}    ${Expected Increase In Tuple Count}    ${Response Expected}
    ...    @{Properties}
    [Documentation]    Creates a tuple by use of a *non-batch POST operation* including specification of the tupleExistsPolicy.
    ...
    ...    *Arguments*
    ...    - ${URL Term ID} = ID of the term for which the tuple is being created.
    ...    - ${Key Property Value} = Value of the key property to which the created tuple will be associated
    ...    - ${Tuple ID} = The unique GUID of the tuple created.
    ...    -${tupleExistsPolicy} = The policy value for the tupleExistsPolicy.
    ...    - ${Response Expected} = The response expected for the operation. Set as Operation Response Body, No Operation Response Body, IGNORE Operation Response Body or Response Body Error as approrpiate.
    ...    -@{properties} = request body property element xml for each property to be specified - Must be supplied by either the Set Property Element (Non-Linked) or Set Property Element (Linked) keyword depending on the property type.
    ...
    ...    *Return Value*
    ...    - @{Operation Response Body} = The batchOperationResponse xml element of the response body.
    ...
    ...    *Example*
    ...    | ${Property XML 1}= | Set Property Element (Non-Linked) | Property 1 | ${propertytermid} | ${propertyid} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Set Property Element (Linked) | Property 2 |${propertytermid} | ${propertyid} | ${linkTupleId} | ${linkTermId} |
    ...    | @{Operation Response Body} = | Create Tuple | ${URL Term ID} | Key Property 1 | ${Tuple ID} | FAIL | Operation Response Body | ${Property XML 1} | ${Property XML 2} |
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected}=    Evaluate    ${tuplecount}+${Expected Increase In Tuple Count}
    Tuple Web Services Request Setup
    ${request body}=    Create Request Body    @{Properties}
    Log    ${request body}
    Set Request Body    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>${request body}
    Run Keyword Unless    "${tupleExistsPolicy}"=="FAIL" or "${tupleExistsPolicy}"=="IGNORE" or "${tupleExistsPolicy}"=="UPSERT"    Next Request Should Not Succeed
    POST    ${NON-BATCH END}/${URL Term ID}/${Key Property Value}/${Tuple ID}/?tupleExistsPolicy=${tupleExistsPolicy}
    Run Keyword If    "${tupleExistsPolicy}"=="FAIL" or "${tupleExistsPolicy}"=="IGNORE" or "${tupleExistsPolicy}"=="UPSERT"    Response Status Code Should Equal    200
    Run Keyword Unless    "${tupleExistsPolicy}"=="FAIL" or "${tupleExistsPolicy}"=="IGNORE" or "${tupleExistsPolicy}"=="UPSERT"    Response Status Code Should Equal    404
    ${Response Body}=    Run Keyword If    "${tupleExistsPolicy}"=="FAIL" or "${tupleExistsPolicy}"=="IGNORE" or "${tupleExistsPolicy}"=="UPSERT"    Get Response Body
    Run Keyword If    "${tupleExistsPolicy}"=="FAIL" or "${tupleExistsPolicy}"=="IGNORE" or "${tupleExistsPolicy}"=="UPSERT"    Log    ${Response Body}
    Validate Number of Tuples    ${tuple count expected}
    @{Operation Response Body 1}=    Run Keyword If    "${Response Expected}"=="Operation Response Body"    General Response Body    ${Response Body}    2
    @{Operation Response Body 2}=    Run Keyword If    "${Response Expected}"=="IGNORE Operation Response Body"    General Response Body    ${Response Body}    1
    @{Operation Response Body}=    Set Variable If    "${Response Expected}"=="Operation Response Body"    ${Operation Response Body 1}    ${Operation Response Body 2}
    Run Keyword If    "${Response Expected}"=="No Operation Response Body"    General Response Body    ${Response Body}    0
    Run Keyword If    "${Response Expected}"=="Operation Response Body"    Create Operation Response Body    @{Operation Response Body}[0]    @{Operation Response Body}[1]    false
    Run Keyword If    "${Response Expected}"=="IGNORE Operation Response Body"    Create Operation Response Body tupleExistsPolicy IGNORE    @{Operation Response Body}[0]    false
    Run Keyword If    "${Response Expected}"=="Response Body Error"    Should Not Contain    ${Response Body}    Request Completed OK
    Run Keyword If    "${Response Expected}"=="Response Body Error"    Check Xml Element Value Equals    checking the value of the description element    ${Response Body}    ERROR    description
    ...    ${XMLNS REQUEST BATCH}
    Run Keyword If    "${Response Expected}"=="Response Body Error"    Should Not Contain    ${Response Body}    MISSING_TUPLE_ERROR
    [Return]    @{Operation Response Body}

Create Tuple tupleEchoPolicy
    [Arguments]    ${URL Term ID}    ${Key Property Value}    ${Tuple ID}    ${tupleEchoPolicy}    @{Properties}
    [Documentation]    Creates a tuple by use of a *non-batch POST operation* including specification of the tupleEchoPolicy.
    ...
    ...    *Arguments*
    ...    - ${URL Term ID} = ID of the term for which the tuple is being created.
    ...    - ${Key Property Value} = Value of the key property to which the created tuple will be associated
    ...    - ${Tuple ID} = The unique GUID of the tuple created.
    ...    -${tupleEchoPolicy} = The policy value for the tupleExistsPolicy.
    ...    -@{properties} = request body property element xml for each property to be specified - Must be supplied by either the Set Property Element (Non-Linked) or Set Property Element (Linked) keyword depending on the property type.
    ...
    ...    *Return Value*
    ...    - @{Operation Response Body} = The batchOperationResponse xml element of the response body.
    ...
    ...    *Example*
    ...    | ${Property XML 1}= | Set Property Element (Non-Linked) | Property 1 | ${propertytermid} | ${propertyid} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Set Property Element (Linked) | Property 2 |${propertytermid} | ${propertyid} | ${linkTupleId} | ${linkTermId} |
    ...    | @{Operation Response Body} = | Create Tuple | ${URL Term ID} | Key Property 1 | ${Tuple ID} | IGNORE | ${Property XML 1} | ${Property XML 2} |
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected 1}=    Run Keyword Unless    "${tupleEchoPolicy}"!="IGNORE" and "${tupleEchoPolicy}"!="CREATE" and "${tupleEchoPolicy}"!="VALUES"    Evaluate    ${tuplecount}+1
    ${tuple count expected 2}=    Run Keyword Unless    "${tupleEchoPolicy}"=="IGNORE" and "${tupleEchoPolicy}"=="CREATE"    Evaluate    ${tuplecount}+0
    ${tuple count expected}=    Set Variable If    "${tupleEchoPolicy}"!="IGNORE" and "${tupleEchoPolicy}"!="CREATE" and "${tupleEchoPolicy}"!="VALUES"    ${tuple count expected 2}    ${tuple count expected 1}
    Tuple Web Services Request Setup
    ${request body}=    Create Request Body    @{Properties}
    Log    ${request body}
    Set Request Body    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>${request body}
    Run Keyword Unless    "${tupleEchoPolicy}"=="IGNORE" or "${tupleEchoPolicy}"=="CREATE" or "${tupleEchoPolicy}"=="VALUES"    Next Request Should Not Succeed
    POST    ${NON-BATCH END}/${URL Term ID}/${Key Property Value}/${Tuple ID}/?tupleEchoPolicy=${tupleEchoPolicy}
    ${Response Body}=    Run Keyword Unless    "${tupleEchoPolicy}"!="IGNORE" and "${tupleEchoPolicy}"!="CREATE" and "${tupleEchoPolicy}"!="VALUES"    Get Response Body
    Run Keyword Unless    "${tupleEchoPolicy}"!="IGNORE" and "${tupleEchoPolicy}"!="CREATE" and "${tupleEchoPolicy}"!="VALUES"    Log    ${Response Body}
    Run Keyword Unless    "${tupleEchoPolicy}"!="IGNORE" and "${tupleEchoPolicy}"!="CREATE" and "${tupleEchoPolicy}"!="VALUES"    Response Status Code Should Equal    200
    Run Keyword Unless    "${tupleEchoPolicy}"=="IGNORE" or "${tupleEchoPolicy}"=="CREATE" or "${tupleEchoPolicy}"=="VALUES"    Response Status Code Should Equal    404
    Validate Number of Tuples    ${tuple count expected}
    ${Expected No Operation Responses}=    Set Variable If    "${tupleEchoPolicy}"=="IGNORE"    1    2
    @{Operation Response Body}=    Run Keyword Unless    "${tupleEchoPolicy}"!="IGNORE" and "${tupleEchoPolicy}"!="CREATE" and "${tupleEchoPolicy}"!="VALUES"    General Response Body    ${Response Body}    ${Expected No Operation Responses}
    Run Keyword If    "${tupleEchoPolicy}"=="CREATE"    Create Operation Response Body    @{Operation Response Body}[0]    @{Operation Response Body}[1]    false
    Run Keyword If    "${tupleEchoPolicy}"=="IGNORE"    Create Operation Response Body tupleEchoPolicy IGNORE    @{Operation Response Body}[0]    false
    Run Keyword If    "${tupleEchoPolicy}"=="VALUES"    Create Operation Response Body tupleEchoPolicy VALUES    @{Operation Response Body}[0]    @{Operation Response Body}[1]    false
    [Return]    @{Operation Response Body}

Create Tuple clientReasonForChange
    [Arguments]    ${URL Term ID}    ${Key Property Value}    ${Tuple ID}    ${Client Reason For Change}    @{Properties}
    [Documentation]    Creates a tuple by use of a *non-batch POST operation* including specification of the clientReasonForChange.
    ...
    ...    *Arguments*
    ...    - ${URL Term ID} = ID of the term for which the tuple is being created.
    ...    - ${Key Property Value} = Value of the key property to which the created tuple will be associated
    ...    - ${Tuple ID} = The unique GUID of the tuple created.
    ...    -${Client Reason For Change} = A user defined reason for the tuple creation.
    ...    -@{properties} = request body property element xml for each property to be specified - Must be supplied by either the Set Property Element (Non-Linked) or Set Property Element (Linked) keyword depending on the property type.
    ...
    ...    *Return Value*
    ...    - @{Operation Response Body} = The batchOperationResponse xml element of the response body.
    ...
    ...    *Example*
    ...    | ${Property XML 1}= | Set Property Element (Non-Linked) | Property 1 | ${propertytermid} | ${propertyid} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Set Property Element (Linked) | Property 2 |${propertytermid} | ${propertyid} | ${linkTupleId} | ${linkTermId} |
    ...    | @{Operation Response Body} = | Create Tuple | ${URL Term ID} | Key Property 1 | ${Tuple ID} | A new tuple for \ a new asset | ${Property XML 1} | ${Property XML 2} |
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected}=    Evaluate    ${tuple count}+1
    Tuple Web Services Request Setup
    ${request body}=    Create Request Body    @{Properties}
    Log    ${request body}
    Set Request Body    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>${request body}
    POST    ${NON-BATCH END}/${URL Term ID}/${Key Property Value}/${Tuple ID}/?clientReasonForChange=${Client Reason For Change}
    ${Response Body}=    Get Response Body
    Log    ${Response Body}
    Response Status Code Should Equal    200
    Validate Number of Tuples    ${tuple count expected}
    @{Operation Response Body}=    General Response Body    ${Response Body}    2
    Create Operation Response Body    @{Operation Response Body}[0]    @{Operation Response Body}[1]    false
    [Return]    @{Operation Response Body}

Create Tuple and Expect Error
    [Arguments]    ${URL Term ID}    ${Key Property Value}    ${Tuple ID}    @{Properties}
    [Documentation]    Attempts to create a tuple for a non-linked property by a non-batch POST operation that fails and checks the HTTP status code returned. If the status code is 200 also checks that an error response body is issued.
    ...
    ...    *Arguments*
    ...    - ${URL Term ID} = ID of the term for which the tuple is being created
    ...    - ${Key Property Value} = Value of the key property to which the created tuple will be associated
    ...    - ${Tuple ID} = The unique GUID of the tuple to be created
    ...    -@{properties} = request body property element xml for each property to be specified - Must be supplied by either the Set Property Element (Non-Linked) or Set Property Element (Linked) keyword depending on the property type.
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    | ${Property XML 1}= | Set Property Element (Non-Linked) | Property 1 | ${propertytermid) | ${propertyid} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Set Property Element (Linked) | Property 2 | ${propertytermid} | ${propertyid} | ${linkTupleId} | ${linkTermId} |
    ...    | Create Tuple and Expect Error | ${URL Term ID} | Key Property 1 | ${Tuple ID} | ${Property XML 1} | ${Property XML 2} |
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected}=    Evaluate    ${tuple count}+0
    Tuple Web Services Request Setup
    ${request body}=    Create Request Body    @{Properties}
    Log    ${request body}
    Set Request Body    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>${request body}
    Run Keyword If    '${URL Term ID}'!='${EMPTY}' and '${Key Property Value}'!='${EMPTY}' and '${Tuple ID}'!='${EMPTY}'    POST    ${NON-BATCH END}/${URL Term ID}/${Key Property Value}/${Tuple ID}
    Run Keyword If    '${URL Term ID}'=='${EMPTY}' and '${Key Property Value}'=='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    Next Request Should Not Succeed
    Run Keyword If    '${URL Term ID}'=='${EMPTY}' and '${Key Property Value}'=='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    POST    ${NON-BATCH END}
    Run Keyword If    '${URL Term ID}'=='${EMPTY}' and '${Key Property Value}'!='${EMPTY}' and '${Tuple ID}'!='${EMPTY}'    Next Request Should Not Succeed
    Run Keyword If    '${URL Term ID}'=='${EMPTY}' and '${Key Property Value}'!='${EMPTY}' and '${Tuple ID}'!='${EMPTY}'    POST    ${NON-BATCH END}//${Key Property Value}/${Tuple ID}
    Run Keyword If    '${URL Term ID}'!='${EMPTY}' and '${Key Property Value}'=='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    POST    ${NON-BATCH END}/${URL Term ID}
    Run Keyword If    '${Key Property Value}'!='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    Next Request Should Not Succeed
    Run Keyword If    '${Key Property Value}'!='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    POST    ${NON-BATCH END}/${URL Term ID}/${Key Property Value}
    Next Request Should Succeed
    ${response_status}=    Get Response Status
    Run Keyword If    '${URL Term ID}'!='${EMPTY}' and '${Key Property Value}'!='${EMPTY}' and '${Tuple ID}'!='${EMPTY}'    Response Status Code Should Equal    200
    Run Keyword If    '${URL Term ID}'!='${EMPTY}' and '${Key Property Value}'=='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    Response Status Code Should Equal    200
    Run Keyword If    '${URL Term ID}'=='${EMPTY}' and '${Key Property Value}'=='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    Response Status Code Should Equal    404
    Run Keyword If    '${URL Term ID}'=='${EMPTY}' and '${Key Property Value}'!='${EMPTY}' and '${Tuple ID}'!='${EMPTY}'    Response Status Code Should Equal    404
    Run Keyword If    '${Key Property Value}'!='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    Response Status Code Should Equal    405
    ${Response Body}=    Run Keyword If    '${response_status}'=='200 OK'    Get Response Body
    Run Keyword If    '${response_status}'=='200 OK'    Log    ${Response Body}
    Run Keyword If    '${response_status}'=='200 OK'    Check Xml Contains Element    Checks the response body contains an exception element.    ${Response Body}    exceptionType    ${XMLNS REQUEST COMMON}

Update Tuple
    [Arguments]    ${URL Term ID}    ${Key Property Value}    ${Tuple ID}    @{properties}
    [Documentation]    Updates a tuple by use of a *non-batch PUT operation*.
    ...
    ...    *Arguments*
    ...    - ${URL Term ID} = ID of the term of the tuple specified for update.
    ...    - ${Key Property Value} = Value of the key property of the tuple specified for update.
    ...    - ${Tuple ID} = The unique GUID of the tuple specified for update.
    ...    -@{properties} = request body property element xml for each property to be specified - Must be supplied by either the Set Property Element (Non-Linked) or Set Property Element (Linked) keyword depending on the property type.
    ...
    ...    *Return Value*
    ...    - @{Operation Response Body} = The batchOperationResponse xml element of the response body.
    ...
    ...    *Example*
    ...    | ${Property XML 1}= | Set Property Element (Non-Linked) | Property 1 | ${propertytermid) | ${propertyid} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Set Property Element (Linked) | Property 2 | ${propertytermid} | ${propertyid} | ${linkTupleId} | ${linkTermId} |
    ...    | @{Operation Response Body} = | Update Tuple | ${URL Term ID} | Key Property 1 | ${Tuple ID} | ${Property XML 1} | ${Property XML 2} |
    Tuple Web Services Request Setup
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected}=    Evaluate    ${tuple count}+0
    Tuple Web Services Request Setup
    ${request body}=    Create Request Body    @{properties}
    Log    ${request body}
    Set Request Body    <?xml version="1.0" encoding="UTF-8" standalone="yes"?> ${request body}
    Run Keyword If    '${Tuple ID}'!='${EMPTY}'    PUT    ${NON-BATCH END}/${URL Term ID}/${Key Property Value}/${Tuple ID}
    Run Keyword If    '${Tuple ID}'=='${EMPTY}'    PUT    ${NON-BATCH END}/${URL Term ID}/${Key Property Value}
    ${Response Body}=    Get Response Body
    Log    ${Response Body}
    Response Status Code Should Equal    200
    Validate Number of Tuples    ${tuple count expected}
    @{Operation Response Body}=    General Response Body    ${Response Body}    1
    Update Operation Response Body    @{Operation Response Body}[0]    false
    [Return]    @{Operation Response Body}

Update Tuple By Term ID and Key Property Value Only tupleExistsPolicy
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${tupleExistsPolicy}    ${Response Expected}    @{Properties}
    [Documentation]    Updates a tuple by term ID and key property value only by use of a *non-batch PUT operation* with the tupleExistsPolicy specified.
    ...
    ...    *Arguments*
    ...    - ${URL Term ID} = ID of the term of the tuple specified for update.
    ...    - ${Key Property Value} = Value of the key property of the tuple specified for update.
    ...    - ${Tuple ID} = The unique GUID of the tuple specified for update.
    ...    -${tupleExistsPolicy} = Value of the tupleExistsPolicy.
    ...    - ${Response Expected} = The response expected for the operation. Set as Operation Response Body, No Operation Response Body, IGNORE Operation Response Body, Operation Response Body no transactionId, Response Body Error or Invalid as approrpiate.
    ...    -@{properties} = request body property element xml for each property to be specified - Must be supplied by either the Set Property Element (Non-Linked) or Set Property Element (Linked) keyword depending on the property type.
    ...
    ...    *Return Value*
    ...    - @{Operation Response Body} = The batchOperationResponse xml element of the response body.
    ...
    ...    *Example*
    ...    | ${Property XML 1}= | Set Property Element (Non-Linked) | Property 1 | ${propertytermid) | ${propertyid} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Set Property Element (Linked) | Property 2 | ${propertytermid} | ${propertyid} | ${linkTupleId} | ${linkTermId} |
    ...    | @{Operation Response Body} = | Update Tuple By Term ID and Key Property Value Only tupleExistsPolicy | ${URL Term ID} | Key Property 1 | ${Tuple ID} | UPSERT | Operation Response Body | ${Property XML 1} | ${Property XML 2} |
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected}=    Evaluate    ${tuplecount}+0
    Tuple Web Services Request Setup
    ${request body}=    Create Request Body    @{Properties}
    Log    ${request body}
    Set Request Body    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>${request body}
    Run Keyword Unless    '${tupleExistsPolicy}'=='FAIL' or '${tupleExistsPolicy}'=='IGNORE' or '${tupleExistsPolicy}'=='UPSERT'    Next Request Should Not Succeed
    PUT    ${NON-BATCH END}/${Term ID}/${Key Property Value}/?tupleExistsPolicy=${tupleExistsPolicy}
    Next Request Should Succeed
    ${Response Body}=    Run Keyword If    '${tupleExistsPolicy}'=='FAIL' or '${tupleExistsPolicy}'=='IGNORE' or '${tupleExistsPolicy}'=='UPSERT'    Get Response Body
    Run Keyword If    '${tupleExistsPolicy}'=='FAIL' or '${tupleExistsPolicy}'=='IGNORE' or '${tupleExistsPolicy}'=='UPSERT'    Log    ${Response Body}
    Run Keyword If    '${tupleExistsPolicy}'=='FAIL' or '${tupleExistsPolicy}'=='IGNORE' or '${tupleExistsPolicy}'=='UPSERT'    Response Status Code Should Equal    200
    Run Keyword Unless    '${tupleExistsPolicy}'=='FAIL' or '${tupleExistsPolicy}'=='IGNORE' or '${tupleExistsPolicy}'=='UPSERT'    Response Status Code Should Equal    404
    Next Request Should Succeed
    Validate Number of Tuples    ${tuple count expected}
    ${Expected No Operation Responses 1}=    Run Keyword If    "${Response Expected}"=="Operation Response Body"    Set Variable    1
    ${Expected No Operation Responses 2}=    Run Keyword If    "${Response Expected}"=="No Operation Response Body"    Set Variable    0
    ${Expected No Operation Responses}=    Set Variable If    "${Response Expected}"=="Operation Response Body"    ${Expected No Operation Responses 1}    ${Expected No Operation Responses 2}
    @{Operation Response Body 1}=    Run Keyword If    "${Response Expected}"=="Operation Response Body"    General Response Body    ${Response Body}    1
    @{Operation Response Body 2}=    Run Keyword If    "${Response Expected}"=="IGNORE Operation Response Body"    General Response Body    ${Response Body}    0
    @{Operation Response Body}=    Set Variable If    "${Response Expected}"=="Operation Response Body"    ${Operation Response Body 1}    ${Operation Response Body 2}
    Run Keyword If    "${Response Expected}"=="No Operation Response Body"    General Response Body    ${Response Body}    0
    Run Keyword If    "${Response Expected}"=="Operation Response Body"    Update Operation Response Body    @{Operation Response Body}[0]    false
    Run Keyword If    "${Response Expected}"=="Operation Response Body no transactionId"    Update Operation Response Body    @{Operation Response Body}[0]    Client Batch Operation ID Set=false    transactionId returned=false
    Run Keyword If    "${Response Expected}"=="IGNORE Operation Response Body"    Check Xml Does Not Contain Element    Checks the xml does not contain an status element    ${Response Body}    status    ${XMLNS REQUEST TUPLE}
    Run Keyword If    "${Response Expected}"=="IGNORE Operation Response Body"    Check Xml Does Not Contain Element    Checks the xml does not contain an exceptionType element    ${Response Body}    exceptionType    ${XMLNS REQUEST COMMON}
    Run Keyword If    "${Response Expected}"=="Response Body Error"    Check Xml Does Not Contain Element    Checks the xml does not contain an status element    ${Response Body}    status    ${XMLNS REQUEST TUPLE}
    Run Keyword If    "${Response Expected}"=="Response Body Error"    Check Xml Element Value Equals    checking the value of the description element    ${Response Body}    ERROR    description
    ...    ${XMLNS REQUEST BATCH}
    Run Keyword If    "${Response Expected}"=="Invalid"    Check Xml Does Not Contain Element    Checks the xml does not contain an status element    ${Response Body}    status    ${XMLNS REQUEST TUPLE}
    Run Keyword If    "${Response Expected}"=="Invalid"    Check Xml Contains Element    Checks the xml contains the exception element    ${Response Body}    exception    ${XMLNS REQUEST HUBTECH}
    Run Keyword If    "${Response Expected}"=="Invalid"    Check Xml Element Value Equals    checking the value of the exceptionType element    ${Response Body}    INVALID_INPUTS    exceptionType
    ...    ${XMLNS REQUEST COMMON}

Update Tuple tupleExistsPolicy
    [Arguments]    ${URL Term ID}    ${Key Property Value}    ${Tuple ID}    ${tupleExistsPolicy}    ${Expected Increase In Tuple Count}    ${Response Expected}
    ...    @{Properties}
    [Documentation]    Updates a tuple by use of a *non-batch PUT operation* including specification of the tupleExistsPolicy.
    ...
    ...    *Arguments*
    ...    - ${URL Term ID} = ID of the term of the tuple specified for update.
    ...    - ${Key Property Value} = Value of the key property of the tuple specified for update.
    ...    - ${Tuple ID} = The unique GUID of the tuple specified for update.
    ...    - ${tupleExistsPolicy} = Value of the tupleExistsPolicy.
    ...    - ${Expected Increase In Tuple Count} = Number by which the total number of tuples in the Asset hub is expected to change by.
    ...    - ${Response Expected} = The response expected for the operation. Set as Operation Response Body, No Operation Response Body, IGNORE Operation Response Body, Operation Response Body no transactionId or Response Body Error as approrpiate.
    ...    - @{properties} = request
    ...    - @{properties} = request body property element xml for each property to be specified - Must be supplied by either the Set Property Element (Non-Linked) or Set Property Element (Linked) keyword depending on the property type.
    ...
    ...    *Return Value*
    ...    - @{Operation Response Body} = The batchOperationResponse xml element of the response body.
    ...
    ...    *Example*
    ...    | ${Property XML 1}= | Set Property Element (Non-Linked) | Property 1 | ${propertytermid) | ${propertyid} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Set Property Element (Linked) | Property 2 | ${propertytermid} | ${propertyid} | ${linkTupleId} | ${linkTermId} |
    ...    | @{Operation Response Body} = | Update Tuple tupleExistsPolicy | ${URL Term ID} | Key Property 1 | ${Tuple ID}| FAIL | Operation Response Body | ${Property XML 1} | ${Property XML 2} |
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected}=    Evaluate    ${tuplecount}+${Expected Increase In Tuple Count}
    Tuple Web Services Request Setup
    ${request body}=    Create Request Body    @{Properties}
    Log    ${request body}
    Set Request Body    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>${request body}
    Run Keyword Unless    "${tupleExistsPolicy}"=="FAIL" or "${tupleExistsPolicy}"=="IGNORE" or "${tupleExistsPolicy}"=="UPSERT"    Next Request Should Not Succeed
    PUT    ${NON-BATCH END}/${URL Term ID}/${Key Property Value}/${Tuple ID}/?tupleExistsPolicy=${tupleExistsPolicy}
    Run Keyword If    "${tupleExistsPolicy}"=="FAIL" or "${tupleExistsPolicy}"=="IGNORE" or "${tupleExistsPolicy}"=="UPSERT"    Response Status Code Should Equal    200
    Run Keyword Unless    "${tupleExistsPolicy}"=="FAIL" or "${tupleExistsPolicy}"=="IGNORE" or "${tupleExistsPolicy}"=="UPSERT"    Response Status Code Should Equal    404
    ${Response Body}=    Run Keyword If    "${tupleExistsPolicy}"=="FAIL" or "${tupleExistsPolicy}"=="IGNORE" or "${tupleExistsPolicy}"=="UPSERT"    Get Response Body
    log    ${Response Body}
    Run Keyword If    "${tupleExistsPolicy}"=="FAIL" or "${tupleExistsPolicy}"=="IGNORE" or "${tupleExistsPolicy}"=="UPSERT"    Log    ${Response Body}
    Validate Number of Tuples    ${tuple count expected}
    ${Expected No Operation Responses 1}=    Run Keyword If    "${Response Expected}"=="Operation Response Body"    Set Variable    1
    ${Expected No Operation Responses 2}=    Run Keyword If    "${Response Expected}"=="No Operation Response Body"    Set Variable    0
    ${Expected No Operation Responses}=    Set Variable If    "${Response Expected}"=="Operation Response Body"    ${Expected No Operation Responses 1}    ${Expected No Operation Responses 2}
    @{Operation Response Body 1}=    Run Keyword If    "${Response Expected}"=="Operation Response Body"    General Response Body    ${Response Body}    1
    @{Operation Response Body 2}=    Run Keyword If    "${Response Expected}"=="IGNORE Operation Response Body"    General Response Body    ${Response Body}    0
    @{Operation Response Body}=    Set Variable If    "${Response Expected}"=="Operation Response Body"    ${Operation Response Body 1}    ${Operation Response Body 2}
    Run Keyword If    "${Response Expected}"=="No Operation Response Body"    General Response Body    ${Response Body}    0
    Run Keyword If    "${Response Expected}"=="Operation Response Body"    Update Operation Response Body    @{Operation Response Body}[0]    false
    Run Keyword If    "${Response Expected}"=="IGNORE Operation Response Body"    Check Xml Does Not Contain Element    Checks the xml does not contain an status element    ${Response Body}    status    ${XMLNS REQUEST TUPLE}
    Run Keyword If    "${Response Expected}"=="IGNORE Operation Response Body"    Check Xml Does Not Contain Element    Checks the xml does not contain an exceptionType element    ${Response Body}    exceptionType    ${XMLNS REQUEST HUBTECH}
    Run Keyword If    "${Response Expected}"=="Response Body Error"    Check Xml Does Not Contain Element    Checks the xml does not contain an status element    ${Response Body}    status    ${XMLNS REQUEST TUPLE}
    Run Keyword If    "${Response Expected}"=="Response Body Error"    Check Xml Element Value Equals    checking the value of the description element    ${Response Body}    ERROR    description
    ...    ${XMLNS REQUEST BATCH}
    Run Keyword If    "${Response Expected}"=="Operation Response Body no transactionId"    Update Operation Response Body    @{Operation Response Body}[0]    Client Batch Operation ID Set=false    transactionId returned=false
    [Return]    @{Operation Response Body}

Update Tuple tupleEchoPolicy
    [Arguments]    ${URL Term ID}    ${Key Property Value}    ${Tuple ID}    ${tupleEchoPolicy}    @{properties}
    [Documentation]    Updates a tuple by use of a *non-batch PUT operation* including specification of the tupleEchoPolicy.
    ...
    ...    *Arguments*
    ...    - ${URL Term ID} = ID of the term od the tuple specified for update.
    ...    - ${Key Property Value} = Value of the key property of the tuple specified for update.
    ...    - ${Tuple ID} = The unique GUID of the tuple specified for update.
    ...    -${tupleEchoPolicy} = Value of the tupleEchoPolicy.
    ...    -@{properties} = request body property element xml for each property to be specified - Must be supplied by either the Set Property Element (Non-Linked) or Set Property Element (Linked) keyword depending on the property type.
    ...
    ...    *Return Value*
    ...    - @{Operation Response Body} = The batchOperationResponse xml element of the response body.
    ...
    ...    *Example*
    ...    | ${Property XML 1}= | Set Property Element (Non-Linked) | Property 1 | ${propertytermid) | ${propertyid} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Set Property Element (Linked) | Property 2 | ${propertytermid} | ${propertyid} | ${linkTupleId} | ${linkTermId} |
    ...    | @{Operation Response Body} = | Update Tuple tupleEchoPolicy | ${URL Term ID} | Key Property 1 | ${Tuple ID} | IGNORE | ${Property XML 1} | ${Property XML 2} |
    Tuple Web Services Request Setup
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected}=    Evaluate    ${tuple count}+0
    Tuple Web Services Request Setup
    ${request body}=    Create Request Body    @{properties}
    Log    ${request body}
    Set Request Body    <?xml version="1.0" encoding="UTF-8" standalone="yes"?> ${request body}
    Run Keyword Unless    "${tupleEchoPolicy}"=="IGNORE" or "${tupleEchoPolicy}"=="CREATE"    Next Request Should Not Succeed
    PUT    ${NON-BATCH END}/${URL Term ID}/${Key Property Value}/${Tuple ID}/?tupleEchoPolicy=${tupleEchoPolicy}
    ${Response Body}=    Run Keyword If    "${tupleEchoPolicy}"=="IGNORE" or "${tupleEchoPolicy}"=="CREATE"    Get Response Body
    Run Keyword If    "${tupleEchoPolicy}"=="IGNORE" or "${tupleEchoPolicy}"=="CREATE"    Log    ${Response Body}
    Run Keyword If    "${tupleEchoPolicy}"=="IGNORE" or "${tupleEchoPolicy}"=="CREATE"    Response Status Code Should Equal    200
    Run Keyword If    "${tupleEchoPolicy}"!="IGNORE" and "${tupleEchoPolicy}"!="CREATE"    Response Status Code Should Equal    404
    Validate Number of Tuples    ${tuple count expected}
    ${Expected No Operation Responses}=    Set Variable If    "${tupleEchoPolicy}"=="IGNORE"    1    2
    @{Operation Response Body}=    Run Keyword If    "${tupleEchoPolicy}"=="IGNORE" or "${tupleEchoPolicy}"=="CREATE"    General Response Body    ${Response Body}    ${Expected No Operation Responses}
    Run Keyword If    "${tupleEchoPolicy}"=="IGNORE"    Update Operation Response Body    @{Operation Response Body}[0]    false
    Run Keyword If    "${tupleEchoPolicy}"=="CREATE"    Update Operation Response Body tupleEchoPolicy CREATE    @{Operation Response Body}[0]    @{Operation Response Body}[1]    false
    [Return]    @{Operation Response Body}

Update Tuple clientReasonForChange
    [Arguments]    ${URL Term ID}    ${Key Property Value}    ${Tuple ID}    ${Client Reason For Change}    @{properties}
    [Documentation]    Updated a tuple by use of a *non-batch PUT operation* including specification of the clientReasonForChange.
    ...
    ...    *Arguments*
    ...    - ${URL Term ID} = ID of the term of the tuple specified for update.
    ...    - ${Key Property Value} = Value of the key property of the tuple specified for update.
    ...    - ${Tuple ID} = The unique GUID of the tuple specified for update,
    ...    -${Client Reason For Change} = A user defined reason for the tuple update.
    ...    -@{properties} = request body property element xml for each property to be specified - Must be supplied by either the Set Property Element (Non-Linked) or Set Property Element (Linked) keyword depending on the property type.
    ...
    ...    *Return Value*
    ...    - @{Operation Response Body} = The batchOperationResponse xml element of the response body.
    ...
    ...    *Example*
    ...    | ${Property XML 1}= | Set Property Element (Non-Linked) | Property 1 | ${propertytermid} | ${propertyid} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Set Property Element (Linked) | Property 2 |${propertytermid} | ${propertyid} | ${linkTupleId} | ${linkTermId} |
    ...    | @{Operation Response Body} = | Update Tuple clientReasonForChange | ${URL Term ID} | Key Property 1 | ${Tuple ID} | Updating tuple due to change to the asset | ${Property XML 1} | ${Property XML 2} |
    Tuple Web Services Request Setup
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected}=    Evaluate    ${tuple count}+0
    Tuple Web Services Request Setup
    ${request body}=    Create Request Body    @{properties}
    Log    ${request body}
    Set Request Body    <?xml version="1.0" encoding="UTF-8" standalone="yes"?> ${request body}
    PUT    ${NON-BATCH END}/${URL Term ID}/${Key Property Value}/${Tuple ID}/?clientReasonForChange=${Client Reason For Change}
    ${Response Body}=    Get Response Body
    Log    ${Response Body}
    Response Status Code Should Equal    200
    Validate Number of Tuples    ${tuple count expected}
    @{Operation Response Body}=    General Response Body    ${Response Body}    1
    Update Operation Response Body    @{Operation Response Body}[0]    false
    [Return]    @{Operation Response Body}

Update Tuple and Expect Error
    [Arguments]    ${URL Term ID}    ${Key Property Value}    ${Tuple ID}    @{properties}
    [Documentation]    Attempts to update a tuple for a non-linked property by a non-batch PUT operation that fails and checks the HTTP status code returned. If the status code is 200 also checks that an error response body is issued.
    ...
    ...    *Arguments*
    ...    - ${URL Term ID} = ID of the term of the tuple specified for update
    ...    - ${Key Property Value} = Value of the key property of the tuple specified for update
    ...    - ${Tuple ID} = The unique GUID of the tuple specified to update
    ...    -@{properties} = request body property element xml for each property to be specified - Must be supplied by either the Set Property Element (Non-Linked) or Set Property Element (Linked) keyword depending on the property type.
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    | ${Property XML 1}= | Set Property Element (Non-Linked) | Property 1 | ${propertytermid) | ${propertyid} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Set Property Element (Linked) | Property 2 | ${propertytermid} | ${propertyid} | ${linkTupleId} | ${linkTermId} |
    ...    | Update Tuple and Expect Error | ${URL Term ID} | Key Property 1 | ${Tuple ID} | ${Property XML 1} | ${Property XML 2} |
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected}=    Evaluate    ${tuple count}+0
    Tuple Web Services Request Setup
    ${request body}=    Create Request Body    @{properties}
    Log    ${request body}
    Set Request Body    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>${request body}
    Run Keyword If    '${URL Term ID}'!='${EMPTY}' and '${Key Property Value}'!='${EMPTY}' and '${Tuple ID}'!='${EMPTY}'    PUT    ${NON-BATCH END}/${URL Term ID}/${Key Property Value}/${Tuple ID}
    Run Keyword If    '${URL Term ID}'=='${EMPTY}' and '${Key Property Value}'=='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    Next Request Should Not Succeed
    Run Keyword If    '${URL Term ID}'=='${EMPTY}' and '${Key Property Value}'=='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    PUT    ${NON-BATCH END}
    Run Keyword If    '${URL Term ID}'=='${EMPTY}' and '${Key Property Value}'!='${EMPTY}' and '${Tuple ID}'!='${EMPTY}'    Next Request Should Not Succeed
    Run Keyword If    '${URL Term ID}'=='${EMPTY}' and '${Key Property Value}'!='${EMPTY}' and '${Tuple ID}'!='${EMPTY}'    PUT    ${NON-BATCH END}//${Key Property Value}/${Tuple ID}
    Run Keyword If    '${Key Property Value}'=='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    Next Request Should Not Succeed
    Run Keyword If    '${Key Property Value}'=='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    PUT    ${NON-BATCH END}/${URL Term ID}
    Run Keyword If    '${Key Property Value}'!='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    Next Request Should Not Succeed
    Run Keyword If    '${Key Property Value}'!='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    PUT    ${NON-BATCH END}/${URL Term ID}/${Key Property Value}
    Next Request Should Succeed
    ${response_status}=    Get Response Status
    Run Keyword If    '${URL Term ID}'!='${EMPTY}' and '${Key Property Value}'!='${EMPTY}' and '${Tuple ID}'!='${EMPTY}'    Response Status Code Should Equal    200
    Run Keyword If    '${URL Term ID}'=='${EMPTY}' and '${Key Property Value}'=='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    Response Status Code Should Equal    400
    Run Keyword If    '${URL Term ID}'=='${EMPTY}' and '${Key Property Value}'!='${EMPTY}' and '${Tuple ID}'!='${EMPTY}'    Response Status Code Should Equal    404
    Run Keyword If    '${Key Property Value}'=='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    Response Status Code Should Equal    400
    Run Keyword If    '${Key Property Value}'!='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    Response Status Code Should Equal    405
    ${Response Body}=    Run Keyword If    '${response_status}'=='200 OK'    Get Response Body
    Run Keyword If    '${response_status}'=='200 OK'    Log    ${Response Body}
    Validate Number of Tuples    ${tuple count expected}
    Run Keyword If    '${URL Term ID}'!='${EMPTY}' and '${Key Property Value}'!='${EMPTY}' and '${Tuple ID}'!='${EMPTY}'    Should Not Contain    ${Response Body}    Request Completed OK
    [Return]    ${Response Body}=

Update Tuple No transactionId
    [Arguments]    ${URL Term ID}    ${Key Property Value}    ${Tuple ID}    @{properties}
    [Documentation]    Attempts to updates a tuple by use of a *non-batch PUT operation*.
    ...
    ...    *Arguments*
    ...    - ${URL Term ID} = ID of the term of the tuple specified for update.
    ...    - ${Key Property Value} = Value of the key property of the tuple specified for update.
    ...    - ${Tuple ID} = The unique GUID of the tuple specified for update.
    ...    -@{properties} = request body property element xml for each property to be specified - Must be supplied by either the Set Property Element (Non-Linked) or Set Property Element (Linked) keyword depending on the property type.
    ...
    ...    *Return Value*
    ...    - @{Operation Response Body} = The batchOperationResponse xml element of the response body.
    ...
    ...    *Example*
    ...    | ${Property XML 1}= | Set Property Element (Non-Linked) | Property 1 | ${propertytermid) | ${propertyid} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Set Property Element (Linked) | Property 2 | ${propertytermid} | ${propertyid} | ${linkTupleId} | ${linkTermId} |
    ...    | @{Operation Response Body} = | Update Tuple | ${URL Term ID} | Key Property 1 | ${Tuple ID} | ${Property XML 1} | ${Property XML 2} |
    Tuple Web Services Request Setup
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected}=    Evaluate    ${tuple count}+0
    Tuple Web Services Request Setup
    ${request body}=    Create Request Body    @{properties}
    Log    ${request body}
    Set Request Body    <?xml version="1.0" encoding="UTF-8" standalone="yes"?> ${request body}
    Run Keyword If    '${Tuple ID}'!='${EMPTY}'    PUT    ${NON-BATCH END}/${URL Term ID}/${Key Property Value}/${Tuple ID}
    Run Keyword If    '${Tuple ID}'=='${EMPTY}'    PUT    ${NON-BATCH END}/${URL Term ID}/${Key Property Value}
    ${Response Body}=    Get Response Body
    Log    ${Response Body}
    Response Status Code Should Equal    200
    Validate Number of Tuples    ${tuple count expected}
    @{Operation Response Body}=    General Response Body    ${Response Body}    1
    Update Operation Response Body    @{Operation Response Body}[0]    false    transactionId returned=false
    [Return]    @{Operation Response Body}

Delete Tuple
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${Expected Reduction In Tuple Count}=1
    [Documentation]    Deletes a tuple by use of a *non-batch DELETE operation*.
    ...
    ...    *Arguments*
    ...    - ${URL Term ID} = ID of the term of the tuple specified for deletion.
    ...    - ${Key Property Value} = Value of the key property of the tuple specified for deletion.
    ...    - ${Tuple ID} = The unique GUID of the tuple specified for deletion.
    ...    - ${Expected Reduction In Tuple Count} = Expected decrease in the number of tuples present in the asset hub following the operation.
    ...
    ...    *Return Value*
    ...    - @{Operation Response Body} = The batchOperationResponse xml element of the response body.
    ...
    ...    *Example*
    ...    | @{Operation Response Body} = | Delete Tuple | ${URL Term ID} | Key Property 1 | ${Tuple ID} | 1 |
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected}=    Evaluate    ${tuplecount}-${Expected Reduction In Tuple Count}
    Tuple Web Services Request Setup
    Run Keyword If    "${Tuple ID}"!="${EMPTY}"    DELETE    ${NON-BATCH END}/${Term ID}/${Key Property Value}/${Tuple ID}
    Run Keyword If    "${Tuple ID}"=="${EMPTY}"    DELETE    ${NON-BATCH END}/${Term ID}/${Key Property Value}
    ${Response Body}=    Get Response Body
    Log    ${Response Body}
    Validate Number of Tuples    ${tuple count expected}
    Response Status Code Should Equal    200
    @{Operation Response Body}=    General Response Body    ${Response Body}    1
    Delete Operation Response Body    @{Operation Response Body}[0]    false
    [Return]    @{Operation Response Body}

Delete Tuple By Term ID and Key Property Value Only tupleExistsPolicy
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${tupleExistsPolicy}    ${Expected Reduction In Tuple Count}    ${Response Expected}
    [Documentation]    Deletes a tuple by term ID and key property value only by use of a *non-batch DELETE operation* with the tupleExistsPolicy specified.
    ...
    ...    *Arguments*
    ...    - ${URL Term ID} = ID of the term of the tuple specified for deletion.
    ...    - ${Key Property Value} = Value of the key property of the tuple specified for deletion.
    ...    - ${Tuple ID} = The unique GUID of the tuple specified for deletion.
    ...    -${tupleExistsPolicy} = Value of the tupleExistsPolicy.
    ...    - ${Expected Reduction In Tuple Count} = Expected decrease in the number of tuples present in the asset hub following the operation.
    ...    - ${Response Expected} = The response expected for the operation. Set as Operation Response Body, No Operation Response Body or Response Body Error as approrpiate.
    ...
    ...    *Return Value*
    ...    - @{Operation Response Body} = The batchOperationResponse xml element of the response body.
    ...
    ...    *Example*
    ...    | @{Operation Response Body} = | Delete Tuple By Term ID and Key Property Value Only tupleExistsPolicy | ${URL Term ID} | Key Property 1 | ${Tuple ID} | UPSERT | 1 | Operation Response Body |
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected}=    Evaluate    ${tuplecount}-${Expected Reduction In Tuple Count}
    Tuple Web Services Request Setup
    Run Keyword Unless    "${tupleExistsPolicy}"=="FAIL" or "${tupleExistsPolicy}"=="IGNORE" or "${tupleExistsPolicy}"=="UPSERT"    Next Request Should Not Succeed
    DELETE    ${NON-BATCH END}/${Term ID}/${Key Property Value}/?tupleExistsPolicy=${tupleExistsPolicy}
    Run Keyword If    "${tupleExistsPolicy}"=="FAIL" or "${tupleExistsPolicy}"=="IGNORE" or "${tupleExistsPolicy}"=="UPSERT"    Response Status Code Should Equal    200
    Run Keyword Unless    "${tupleExistsPolicy}"=="FAIL" or "${tupleExistsPolicy}"=="IGNORE" or "${tupleExistsPolicy}"=="UPSERT"    Response Status Code Should Equal    404
    ${Response Body}=    Run Keyword If    "${tupleExistsPolicy}"=="FAIL" or "${tupleExistsPolicy}"=="IGNORE" or "${tupleExistsPolicy}"=="UPSERT"    Get Response Body
    Run Keyword If    "${tupleExistsPolicy}"=="FAIL" or "${tupleExistsPolicy}"=="IGNORE" or "${tupleExistsPolicy}"=="UPSERT"    Log    ${Response Body}
    Validate Number of Tuples    ${tuple count expected}
    ${Expected No Operation Responses 1}=    Run Keyword If    "${Response Expected}"=="Operation Response Body"    Set Variable    1
    ${Expected No Operation Responses 2}=    Run Keyword If    "${Response Expected}"=="No Operation Response Body"    Set Variable    0
    ${Expected No Operation Responses}=    Set Variable If    "${Response Expected}"=="Operation Response Body"    ${Expected No Operation Responses 1}    ${Expected No Operation Responses 2}
    @{Operation Response Body}=    Run Keyword If    "${Response Expected}"=="Operation Response Body" or "${Response Expected}"=="No Operation Response Body"    General Response Body    ${Response Body}    ${Expected No Operation Responses}
    Run Keyword If    "${Response Expected}"=="Operation Response Body"    Delete Operation Response Body    @{Operation Response Body}[0]    false
    Run Keyword If    "${Response Expected}"=="No Operation Response Body"    Check Xml Does Not Contain Element    Checks that the response body does NOT contain a status.    ${Response Body}    status
    Run Keyword If    "${Response Expected}"=="No Operation Response Body"    Check Xml Does Not Contain Element    Checks the the response body does NOT contain an error.    ${Response Body}    exception
    Run Keyword If    "${Response Expected}"=="Response Body Error"    Should Not Contain    ${Response Body}    Request Completed OK
    Run Keyword If    "${Response Expected}"=="Response Body Error"    Check Xml Element Value Equals    checking the value of the description element    ${Response Body}    ERROR    description
    ...    ${XMLNS REQUEST BATCH}

Delete Tuple tupleExistsPolicy
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${tupleExistsPolicy}    ${Expected Reduction In Tuple Count}    ${Response Expected}
    [Documentation]    Deletes a tuple by use of a *non-batch DELETE operation* including specification of the tupleExistsPolicy.
    ...
    ...    *Arguments*
    ...    - ${URL Term ID} = ID of the term of the tuple specified for deletion.
    ...    - ${Key Property Value} = Value of the key property of the tuple specified for deletion.
    ...    - ${Tuple ID} = The unique GUID of the tuple specified for deletion.
    ...    -${tupleExistsPolicy} = Value of the tupleExistsPolicy.
    ...    -${Expected Increase In Tuple Count} = Number by which the total number of tuples in the Asset hub is expected to change by.
    ...    - ${Response Expected} = The response expected for the operation. Set as Operation Response Body, No Operation Response Body or Response Body Error as approrpiate.
    ...
    ...    *Return Value*
    ...    - @{Operation Response Body} = The batchOperationResponse xml element of the response body.
    ...
    ...    *Example*
    ...    | @{Operation Response Body} = | Delete Tuple tupleExistsPolicy | ${URL Term ID} | Key Property 1 | ${Tuple ID}| 1 | FAIL | Operation Response Body |
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected}=    Evaluate    ${tuplecount}-${Expected Reduction In Tuple Count}
    Tuple Web Services Request Setup
    Run Keyword Unless    "${tupleExistsPolicy}"=="FAIL" or "${tupleExistsPolicy}"=="IGNORE" or "${tupleExistsPolicy}"=="UPSERT"    Next Request Should Not Succeed
    DELETE    ${NON-BATCH END}/${Term ID}/${Key Property Value}/${Tuple ID}/?tupleExistsPolicy=${tupleExistsPolicy}
    Run Keyword If    "${tupleExistsPolicy}"=="FAIL" or "${tupleExistsPolicy}"=="IGNORE" or "${tupleExistsPolicy}"=="UPSERT"    Response Status Code Should Equal    200
    Run Keyword Unless    "${tupleExistsPolicy}"=="FAIL" or "${tupleExistsPolicy}"=="IGNORE" or "${tupleExistsPolicy}"=="UPSERT"    Response Status Code Should Equal    404
    ${Response Body}=    Run Keyword If    "${tupleExistsPolicy}"=="FAIL" or "${tupleExistsPolicy}"=="IGNORE" or "${tupleExistsPolicy}"=="UPSERT"    Get Response Body
    Run Keyword If    "${tupleExistsPolicy}"=="FAIL" or "${tupleExistsPolicy}"=="IGNORE" or "${tupleExistsPolicy}"=="UPSERT"    Log    ${Response Body}
    Validate Number of Tuples    ${tuple count expected}
    ${Expected No Operation Responses 1}=    Run Keyword If    "${Response Expected}"=="Operation Response Body"    Set Variable    1
    ${Expected No Operation Responses 2}=    Run Keyword If    "${Response Expected}"=="No Operation Response Body"    Set Variable    0
    ${Expected No Operation Responses}=    Set Variable If    "${Response Expected}"=="Operation Response Body"    ${Expected No Operation Responses 1}    ${Expected No Operation Responses 2}
    @{Operation Response Body}=    Run Keyword If    "${Response Expected}"=="Operation Response Body" or "${Response Expected}"=="No Operation Response Body"    General Response Body    ${Response Body}    ${Expected No Operation Responses}
    Run Keyword If    "${Response Expected}"=="Operation Response Body"    Delete Operation Response Body    @{Operation Response Body}[0]    false
    Run Keyword If    "${Response Expected}"=="No Operation Response Body"    Check Xml Does Not Contain Element    Checks that the response body does NOT contain a status.    ${Response Body}    status
    Run Keyword If    "${Response Expected}"=="No Operation Response Body"    Check Xml Does Not Contain Element    Checks the the response body does NOT contain an error.    ${Response Body}    exception
    Run Keyword If    "${Response Expected}"=="Response Body Error"    Should Not Contain    ${Response Body}    Request Completed OK
    Run Keyword If    "${Response Expected}"=="Response Body Error"    Check Xml Element Value Equals    checking the value of the description element    ${Response Body}    ERROR    description
    ...    ${XMLNS REQUEST BATCH}
    [Return]    @{Operation Response Body}

Delete Tuple tupleEchoPolicy
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${tupleEchoPolicy}
    [Documentation]    Deletes a tuple by use of a *non-batch DELETE operation* including specification of the tupleEchoPolicy.
    ...
    ...    *Arguments*
    ...    - ${URL Term ID} = ID of the term od the tuple specified for deletion.
    ...    - ${Key Property Value} = Value of the key property of the tuple specified for deletion.
    ...    - ${Tuple ID} = The unique GUID of the tuple specified for update.
    ...    -${tupleEchoPolicy} = Value of the tupleEchoPolicy.
    ...
    ...    *Return Value*
    ...    - @{Operation Response Body} = The batchOperationResponse xml element of the response body.
    ...
    ...    *Example*
    ...    | @{Operation Response Body} = | Delete Tuple tupleEchoPolicy | ${URL Term ID} | Key Property 1 | ${Tuple ID} | IGNORE |
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected 1}=    Run Keyword If    "${tupleEchoPolicy}"=="IGNORE" or "${tupleEchoPolicy}"=="CREATE"    Evaluate    ${tuplecount}-1
    ${tuple count expected 2}=    Run Keyword Unless    "${tupleEchoPolicy}"=="IGNORE" or "${tupleEchoPolicy}"=="CREATE"    Evaluate    ${tuplecount}+0
    ${tuple count expected}=    Set Variable If    "${tupleEchoPolicy}"=="IGNORE" or "${tupleEchoPolicy}"=="CREATE"    ${tuple count expected 1}    ${tuple count expected 2}
    Tuple Web Services Request Setup
    Run Keyword If    "${tupleEchoPolicy}"=="IGNORE" or "${tupleEchoPolicy}"=="CREATE"    Next Request Should Succeed
    Run Keyword If    "${tupleEchoPolicy}"!="IGNORE" and "${tupleEchoPolicy}"!="CREATE"    Next Request Should Not Succeed
    DELETE    ${NON-BATCH END}/${Term ID}/${Key Property Value}/${Tuple ID}/?tupleEchoPolicy=${tupleEchoPolicy}
    Run Keyword If    "${tupleEchoPolicy}"=="IGNORE" or "${tupleEchoPolicy}"=="CREATE"    Response Status Code Should Equal    200
    Run Keyword If    "${tupleEchoPolicy}"!="IGNORE" and "${tupleEchoPolicy}"!="CREATE"    Response Status Code Should Equal    404
    ${Response Body}=    Run Keyword If    "${tupleEchoPolicy}"=="IGNORE" or "${tupleEchoPolicy}"=="CREATE"    Get Response Body
    Run Keyword If    "${tupleEchoPolicy}"=="IGNORE" or "${tupleEchoPolicy}"=="CREATE"    Log    ${Response Body}
    Validate Number of Tuples    ${tuple count expected}
    ${Expected Number Operation Responses 1}=    Run Keyword If    "${tupleEchoPolicy}"!="CREATE"    Set Variable    1
    ${Expected Number Operation Responses 2}=    Run Keyword If    "${tupleEchoPolicy}"=="CREATE"    Set Variable    2
    ${Expected Number Operation Responses}=    Set Variable If    "${tupleEchoPolicy}"=="IGNORE"    ${Expected Number Operation Responses 1}    ${Expected Number Operation Responses 2}
    @{Operation Response Body}=    Run Keyword If    "${tupleEchoPolicy}"=="IGNORE" or "${tupleEchoPolicy}"=="CREATE"    General Response Body    ${Response Body}    ${Expected Number Operation Responses}
    Run Keyword If    "${tupleEchoPolicy}"=="IGNORE"    Delete Operation Response Body    @{Operation Response Body}[0]    false
    Run Keyword If    "${tupleEchoPolicy}"=="CREATE"    Delete Operation Response Body tupleEchoPolicy CREATE    @{Operation Response Body}[0]    @{Operation Response Body}[1]    false
    [Return]    @{Operation Response Body}

Delete Tuple clientReasonForChange
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${Client Reason For Change}
    [Documentation]    Deletes a tuple by use of a *non-batch DELETE operation* including specification of the clientReasonForChange.
    ...
    ...    *Arguments*
    ...    - ${URL Term ID} = ID of the term of the tuple specified for deletion.
    ...    - ${Key Property Value} = Value of the key property of the tuple specified for deletion.
    ...    - ${Tuple ID} = The unique GUID of the tuple specified for deletion.
    ...    -${Client Reason For Change} = A user defined reason for the tuple deletion.
    ...
    ...
    ...    *Return Value*
    ...    - @{Operation Response Body} = The batchOperationResponse xml element of the response body.
    ...
    ...    *Example*
    ...    | @{Operation Response Body} = | Delete Tuple clientReasonForChange | ${URL Term ID} | Key Property 1 | ${Tuple ID} | Removal of an asset that doesn't exist anymore |
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected}=    Evaluate    ${tuplecount}-1
    Tuple Web Services Request Setup
    DELETE    ${NON-BATCH END}/${Term ID}/${Key Property Value}/${Tuple ID}/?clientReasonForChange=${Client Reason For Change}
    ${Response Body}=    Get Response Body
    Log    ${Response Body}
    Validate Number of Tuples    ${tuple count expected}
    Response Status Code Should Equal    200
    @{Operation Response Body}=    General Response Body    ${Response Body}    1
    Delete Operation Response Body    @{Operation Response Body}[0]    false
    [Return]    @{Operation Response Body}

Delete Tuple and Expect Error
    [Arguments]    ${URL Term ID}    ${Key Property Value}    ${Tuple ID}    ${Status Code}
    [Documentation]    Attempts to delete a tuple for a non-linked property by a non-batch DELETE operation that fails and checks the HTTP status code returned. If the status code is 200 also checks that an error response body is issued.
    ...
    ...    *Arguments*
    ...    - ${URL Term ID} = ID of the term of the tuple specified for deletion
    ...    - ${Key Property Value} = Value of the key property of the tuple specified for deletion
    ...    - ${Tuple ID} = The unique GUID of the tuple specified for deletion
    ...    - ${Status Code} = Response status code expected.
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    | Delete Tuple and Expect Error | ${URL Term ID} | Key Property 1 | ${Tuple ID} |
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected}=    Evaluate    ${tuple count}-0
    Tuple Web Services Request Setup
    Run Keyword If    "${URL Term ID}"!="${EMPTY}" and "${Key Property Value}"!="${EMPTY}"    DELETE    ${NON-BATCH END}/${URL Term ID}/${Key Property Value}/${Tuple ID}
    Run Keyword If    "${URL Term ID}"=="${EMPTY}"    Next Request Should Not Succeed
    Run Keyword If    "${URL Term ID}"=="${EMPTY}"    DELETE    ${NON-BATCH END}
    Run Keyword If    "${URL Term ID}"!="${EMPTY}" and "${Key Property Value}"=="${EMPTY}"    Next Request Should Not Succeed
    Run Keyword If    "${URL Term ID}"!="${EMPTY}" and "${Key Property Value}"=="${EMPTY}"    DELETE    ${NON-BATCH END}/${Key Property Value}
    Response Status Code Should Equal    ${Status Code}
    ${Response Body}=    Run Keyword If    "${Status Code}"=="200"    Get Response Body
    Run Keyword If    "${Status Code}"=="200"    Log    ${Response Body}
    Validate Number of Tuples    ${tuple count}
    Next Request Should Succeed
    Run Keyword If    "${Status Code}"=="200"    Should Not Contain    ${Response Body}    Request Completed OK
    Run Keyword If    "${Status Code}"=="200"    Check Xml Contains Element    Checks the response body contains an exception element.    ${Response Body}    exceptionType    ${XMLNS REQUEST COMMON}
    [Return]    ${Response Body}

Retrieve Tuples
    [Arguments]    ${URL Term ID}    ${Key Property Value}    ${Tuple ID}    ${No Tuples Should Be Returned}=${false}
    [Documentation]    Retrieves tuples by use of a *non-batch GET operation*.
    ...
    ...    *Arguments*
    ...    - ${Term ID} = ID of the term of the tuple(s)
    ...    - ${Key Property Value} = Value of the key property of the tuples(s) - Set as * if deleting by Term ID only
    ...    - ${Tuple ID} = ID of tuple to be deleted - Set as * if deleting by Term ID only or Term ID and Key Property Value
    ...    - ${No Tuples Should Be Rturned} (DEAFULT = false) = Whether the response body should not contain retrieved tuples.
    ...
    ...    *Return Value*
    ...    - @{Operation Response Body} = The batchOperationResponse xml element of the response body.
    ...
    ...    *Example*
    ...    | @{Operation Response Body} = | Retrieve Tuples | ${URL Term ID} | Key Property 1 | ${Tuple ID} | true |
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected}=    Evaluate    ${tuplecount}+0
    Tuple Web Services Request Setup
    Run Keyword If    '${URL Term ID}'!='${EMPTY}' and '${Key Property Value}'!='${EMPTY}' and '${Tuple ID}'!='${EMPTY}'    GET    ${NON-BATCH END}/${URL Term ID}/${Key Property Value}/${Tuple ID}
    Run Keyword If    '${URL Term ID}'!='${EMPTY}' and '${Key Property Value}'=='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    GET    ${NON-BATCH END}/${URL Term ID}
    Run Keyword If    '${URL Term ID}'!='${EMPTY}' and '${Key Property Value}'!='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    GET    ${NON-BATCH END}/${URL Term ID}/${Key Property Value}
    Response Status Code Should Equal    200
    ${Response Body}=    Get Response Body
    Log    ${Response Body}
    @{Operation Response Body}=    General Response Body    ${Response Body}    1
    Run Keyword If    "${No Tuples Should Be Returned}"=="False"    Retrieve Operation Response Body    @{Operation Response Body}[0]    false
    Run Keyword If    "${No Tuples Should Be Returned}"=="True"    Retrieve Operation Response Body NO TUPLES RETURNED    @{Operation Response Body}[0]    false
    [Return]    ${Operation Response Body}

Retrieve Tuples clientReasonForChange
    [Arguments]    ${URL Term ID}    ${Key Property Value}    ${Tuple ID}    ${Client Reason For Change}
    [Documentation]    Retrieves tuples by use of a *non-batch GET operation* including specification of the clientReasonForChange.
    ...
    ...    *Arguments*
    ...    - ${URL Term ID} = ID of the term of the tuple specified for deletion.
    ...    - ${Key Property Value} = Value of the key property of the tuple specified for deletion.
    ...    - ${Tuple ID} = The unique GUID of the tuple specified for deletion.
    ...    -${Client Reason For Change} = A user defined reason for the tuple deletion.
    ...
    ...
    ...    *Return Value*
    ...    - @{Operation Response Body} = The batchOperationResponse xml element of the response body.
    ...
    ...    *Example*
    ...    | @{Operation Response Body} = | Retrieve Tuple clientReasonForChange | ${URL Term ID} | Key Property 1 | ${Tuple ID} | Retrieving a tuple of interest |
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected}=    Evaluate    ${tuplecount}+0
    Tuple Web Services Request Setup
    GET    ${NON-BATCH END}/${URL Term ID}/${Key Property Value}/${Tuple ID}/?clientReasonForChange=${Client Reason For Change}
    Response Status Code Should Equal    200
    ${Response Body}=    Get Response Body
    Log    ${Response Body}
    @{Operation Response Body}=    General Response Body    ${Response Body}    1
    Retrieve Operation Response Body    @{Operation Response Body}[0]    false
    [Return]    ${Operation Response Body}

Retrieve Tuples and Expect Error
    [Arguments]    ${URL Term ID}    ${Key Property Value}    ${Tuple ID}
    [Documentation]    Attempts to retrieve for a non-linked property by a non-batch GET operation that fails and checks the HTTP status code returned. If the status code is 200 also checks that an error response body is issued.
    ...
    ...    *Arguments*
    ...    - ${Term ID} = ID of the term of the tuple
    ...    - ${Key Property Value} = Value of the key property associated to the tuple
    ...    - ${Tuple ID} = ID of the tuple
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...    | Retrieve Tuples and Expect Error | ${URL Term ID} | Key Property 1 | ${Tuple ID} |
    Tuple Web Services Request Setup
    Run Keyword If    '${URL Term ID}'!='${EMPTY}' and '${Key Property Value}'!='${EMPTY}' and '${Tuple ID}'!='${EMPTY}'    GET    ${NON-BATCH END}/${URL Term ID}/${Key Property Value}/${Tuple ID}
    Run Keyword If    '${URL Term ID}'!='${EMPTY}' and '${Key Property Value}'!='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    GET    ${NON-BATCH END}/${URL Term ID}/${Key Property Value}
    Run Keyword If    '${URL Term ID}'!='${EMPTY}' and '${Key Property Value}'=='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    GET    ${NON-BATCH END}/${URL Term ID}
    Run Keyword If    '${URL Term ID}'=='${EMPTY}' and '${Key Property Value}'=='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    Next Request Should Not Succeed
    Run Keyword If    '${URL Term ID}'=='${EMPTY}' and '${Key Property Value}'=='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    GET    ${NON-BATCH END}
    Next Request Should Succeed
    Run Keyword Unless    '${URL Term ID}'=='${EMPTY}' and '${Key Property Value}'=='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    Response Status Code Should Equal    200
    Run Keyword If    '${URL Term ID}'=='${EMPTY}' and '${Key Property Value}'=='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    Response Status Code Should Equal    404
    ${Response Body}=    Run Keyword Unless    '${URL Term ID}'=='${EMPTY}' and '${Key Property Value}'=='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    Get Response Body
    Run Keyword Unless    '${URL Term ID}'=='${EMPTY}' and '${Key Property Value}'=='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    Log    ${Response Body}
    Run Keyword Unless    '${URL Term ID}'=='${EMPTY}' and '${Key Property Value}'=='${EMPTY}' and '${Tuple ID}'=='${EMPTY}'    Should Not Contain    ${Response Body}    Request Completed OK    Response body should not have contained "Request Completed OK".

Batch Set Property Element (Non-Linked)
    [Arguments]    ${Property Name}    ${Property Term ID}    ${Property ID}    ${Property Value}    ${Property Value Units}=${EMPTY}
    [Documentation]    Creates the request body property element xml for an individual non-linked property for a *batch create or update operation*.
    ...
    ...    *Arguments*
    ...    - ${Property Name} = Name of the property
    ...    - ${Property Term ID} = Term ID of the property (i.e. the inherited term ID)
    ...    - ${Property ID} = ID of the property
    ...    - ${Property Value} = Value of the property
    ...    - ${Property Value Units} (OPTIONAL), default = ${EMPTY) = Units of the property value
    ...
    ...    *Return Value*
    ...    - ${property xml} = property request body xml string for a single non-linked property within a non-batch create/update operation.
    ...
    ...    *Example*
    ...
    ...    | ${Property XML 1}= | Set Property Element (Non-Linked) | Property 1 | ${Property Term ID} | ${Property ID} | Property 1 Value 1 Updated | mm
    ...    | ${Operation Create}= | Batch Update Operation XML | ${Term ID} | Key Property Value 1 | ${Tuple ID} | ${Property XML 1} |
    ...    | @{Operation Response Body}= | Batch Request | +0 | 1 | ${Operation Create} |
    ${property}=    Create Xml Object    property
    ${propertySpecifier}=    Create Xml Object    propertySpecifier
    ${name}=    Create Xml Object    name    elementText=${Property Name}
    ${propertytermId}=    Create Xml Object    termId    elementText=${Property Term Id}
    ${propertyId}=    Create Xml Object    propertyId    elementText=${Property ID}
    ${propertySpecifier xml}=    Add Subelement To Xml    ${propertySpecifier}    ${name}
    ${propertySpecifier xml}=    Add Subelement To Xml    ${propertySpecifier xml}    ${propertytermId}
    ${propertySpecifier xml}=    Add Subelement To Xml    ${propertySpecifier xml}    ${propertyId}
    ${propertyValue element}=    Create Xml Object    propertyValue
    ${value}=    Create Xml Object    value    elementText=${Property Value}
    ${unit}=    Create Xml Object    unit    elementText=${Property Value Units}
    ${propertyValue xml}=    Add Subelement To Xml    ${propertyValue element}    ${value}
    ${propertyValue xml}=    Add Subelement To Xml    ${propertyValue xml}    ${unit}
    ${property xml}=    Add Subelement To Xml    ${property}    ${propertySpecifier xml}
    ${property xml}=    Add Subelement To Xml    ${property xml}    ${propertyValue xml}
    [Return]    ${property xml}

Batch Set Property Element (Linked)
    [Arguments]    ${Property Name}    ${Property Term ID}    ${Property ID}    ${Linked Property Tuple ID}    ${Linked Property Term ID}
    [Documentation]    Creates the request body property element xml for the an individual linked property for a *batch create or update operation*.
    ...
    ...    *Arguments*
    ...    - ${Property Name} = Name of the property
    ...    - ${Property Term ID} = Term ID of the property (i.e. the inherited term ID)
    ...    - ${Property ID} = ID of the property
    ...    - ${Linked Property Tuple ID} = ID of the tuple being linked to
    ...    - ${Linked Property Term ID} = Term ID of the term being linked to
    ...
    ...    *Return Value*
    ...    - ${property xml} = property request body xml string for a single non-linked property within a non-batch create/update operation.
    ...
    ...    *Example*
    ...
    ...    | ${Property XML 1}= | Batch Set Property Element (Linked) | Linked Property 1 | ${Property Term ID} | ${Property ID} | ${Linked Property Tuple ID} \ | ${Linked Property Term ID} |
    ...    | ${Operation Create}= | Batch Create Operation XML | ${Term ID} | Key Property Value 1 | ${tuple id}
    ...    @{Operation Response Body}= | Batch Request | +1 | 2 | ${Operation Create} |
    ${property}=    Create Xml Object    property
    ${propertySpecifier}=    Create Xml Object    propertySpecifier
    ${name}=    Create Xml Object    name    elementText=${Property Name}
    ${term Id}=    Create Xml Object    termId    elementText=${Property Term ID}
    ${propertyId}=    Create Xml Object    propertyId    elementText=${Property ID}
    ${propertySpecifier xml}=    Add Subelement To Xml    ${propertySpecifier}    ${name}
    ${propertySpecifier xml}=    Add Subelement To Xml    ${propertySpecifier xml}    ${term Id}
    ${propertySpecifier xml}=    Add Subelement To Xml    ${propertySpecifier xml}    ${propertyId}
    ${link}=    Create Xml Object    link
    ${linkTupleId}=    Create Xml Object    linkTupleId    elementText=${Linked Property Tuple ID}
    ${linkTermId}=    Create Xml Object    linkTermId    elementText=${Linked Property Term ID}
    ${link xml}=    Add Subelement To Xml    ${link}    ${linkTupleId}
    ${link xml}=    Add Subelement To Xml    ${link xml}    ${linkTermId}
    ${property xml}=    Add Subelement To Xml    ${property}    ${propertySpecifier xml}
    ${property xml}=    Add Subelement To Xml    ${property xml}    ${link xml}
    [Return]    ${property xml}

Batch Create Operation XML
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    @{Properties}
    [Documentation]    Creates the request xml string for a single create operation within a batch.
    ...
    ...    *Arguments*
    ...    - ${Term ID} = Term ID of the term to create a tuple for
    ...    - ${Key Property Value}= Value of the key property of the tuple to be created
    ...    - ${Tuple ID} = ID of the tuple of the tuple to be created
    ...    - @{Properties} = (OPTIONAL) The Property element XML segments. Must be supplied by either the Batch Set Property Element (Non-Linked) or Batch Set Property Element (Linked) keyword depending on the property type. Can be either a single argument/list argument or multiple arguments.
    ...
    ...    *Return Value*
    ...    - ${batch create request xml} = batchOperationRequest xml string for a single create operation.
    ...
    ...    *Example*
    ...
    ...    | ${Property XML 1}= | Batch Set Property Element (Non-Linked) | Property 1 | ${propertytermid} | ${propertyid} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Batch Set Property Element (Linked) | Linked Property 1 | ${propertytermid | ${propertyid} | ${linkTupleId} | ${linkTermId |
    ...    | ${Operation 1 XML} = | Batch Create Operation XML | ${Term ID} | Key Property Value 1 | ${Tuple ID} | ${Property XML 1} | ${Property XML 2} |
    ...    | Batch Request | +1 | 2 | ${Operation 1} |
    ${Batch Operation ID}=    Create Batch Operation ID
    ${batch create request xml}=    Batch Create Operation XML With Operation ID    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${Batch Operation ID}    @{Properties}
    [Return]    ${batch create request xml}

Batch Create Operation XML With Operation ID
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${Client Batch Operation ID Value}    @{Properties}
    [Documentation]    Creates the request xml string for a single create operation within a batch including spcification of the clientBatchOperationId.
    ...
    ...    *Arguments*
    ...    - ${Term ID} = Term ID of the term to create a tuple for
    ...    - ${Key Property Value}= Value of the key property of the tuple to be created
    ...    - ${Tuple ID} = ID of the tuple of the tuple to be created
    ...    - ${Client Batch Operation ID Value} = Value of the clientBatchOperationId
    ...    - @{Properties} = (OPTIONAL) The Property element XML segments. Must be supplied by either the Batch Set Property Element (Non-Linked) or Batch Set Property Element (Linked) keyword depending on the property type. Can be either a single argument/list argument or multiple arguments.
    ...
    ...    *Return Value*
    ...    - ${batch create request xml} = batchOperationRequest xml string for a single create operation.
    ...
    ...    *Example*
    ...
    ...    | ${Property XML 1}= | Batch Set Property Element (Non-Linked) | Property 1 | ${propertytermid} | ${propertyid} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Batch Set Property Element (Linked) | Linked Property 1 | ${propertytermid | ${propertyid} | ${linkTupleId} | ${linkTermId |
    ...    | ${Operation 1 XML} = | Batch Create Operation XML With Operation ID | ${Term ID} | Key Property Value 1 | ${Tuple ID} | Batch Operation ID 123 | ${Property XML 1 | ${Property XML 2} |
    ...    | Batch Request | +1 | 2 | ${Operation 1} |
    ${batchOperationRequest}=    Create Xml Object    batchOperationRequest    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${batchOperationRequest}=    Set Element Attribute    ${batchOperationRequest}    {http://www.w3.org/2001/XMLSchema-instance}type    TupleOperationRequest    ${BATCH XMLNS REQUEST BATCH}
    ${type}=    Create Xml Object    type    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=CREATE
    ${clientBatchOperationId}=    Create Xml Object    clientBatchOperationId    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Batch Operation ID Value}
    ${tupleSpecifier}=    Create Xml Object    tupleSpecifier
    ${termId}=    Create Xml Object    termId    elementText=${Term ID}
    ${keyPropertyValue}=    Create Xml Object    keyPropertyValue    elementText=${Key Property Value}
    ${tupleId}=    Create Xml Object    tupleId    elementText=${Tuple ID}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${tupleSpecifier}    ${termId}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${keyPropertyValue}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${tupleId}
    ${create request xml propertySequence}=    Create Xml Object    propertySequence
    ${create request xml propertySequence}=    Add List Of Subelements To Xml    ${create request xml propertySequence}    ${Properties}
    ${tuple}=    Create Xml Object    tuple    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${create request xml tuple}=    Add Subelement To Xml    ${tuple}    ${create request xml tupleSpecifier}
    ${create request xml tuple}=    Add Subelement To Xml    ${create request xml tuple}    ${create request xml propertySequence}
    ${batch create request xml}=    Add Subelement To Xml    ${batchOperationRequest}    ${type}
    ${batch create request xml}=    Add Subelement To Xml    ${batch create request xml}    ${clientBatchOperationId}
    ${batch create request xml}=    Add Subelement To Xml    ${batch create request xml}    ${tuple}
    [Return]    ${batch create request xml}

Batch Create Operation XML tupleExistsPolicy
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${tupleExistsPolicy}    @{Properties}
    [Documentation]    Creates the request xml string for a single create operation within a batch including spcification of the tupleExistsPolicy.
    ...
    ...    *Arguments*
    ...    - ${Term ID} = Term ID of the term to create a tuple for
    ...    - ${Key Property Value}= Value of the key property of the tuple to be created
    ...    - ${Tuple ID} = ID of the tuple of the tuple to be created
    ...    - ${tupleExistsPolicy} = Value of the tupleExistsPolicy
    ...    - @{Properties} = (OPTIONAL) The Property element XML segments. Must be supplied by either the Batch Set Property Element (Non-Linked) or Batch Set Property Element (Linked) keyword depending on the property type. Can be either a single argument/list argument or multiple arguments.
    ...
    ...    *Return Value*
    ...    - ${batch create request xml} = batchOperationRequest xml string for a single create operation.
    ...
    ...    *Example*
    ...
    ...    | ${Property XML 1}= | Batch Set Property Element (Non-Linked) | Property 1 | ${propertytermid} | ${propertyid} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Batch Set Property Element (Linked) | Linked Property 1 | ${propertytermid | ${propertyid} | ${linkTupleId} | ${linkTermId |
    ...    | ${Operation 1 XML} = | Batch Create Operation XML tupleExistsPolicy | ${Term ID} | Key Property Value 1 | ${Tuple ID} | IGNORE | ${Property XML 1 | ${Property XML 2} |
    ...    | Batch Request | +1 | 2 | ${Operation 1} |
    ${Client Batch Operation ID}=    Create Batch Operation ID
    ${batchOperationRequest}=    Create Xml Object    batchOperationRequest    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${batchOperationRequest}=    Set Element Attribute    ${batchOperationRequest}    {http://www.w3.org/2001/XMLSchema-instance}type    TupleOperationRequest    ${BATCH XMLNS REQUEST BATCH}
    ${type}=    Create Xml Object    type    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=CREATE
    ${clientBatchOperationId}=    Create Xml Object    clientBatchOperationId    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Batch Operation ID}
    ${tupleExistsPolicy}=    Create Xml Object    tupleExistsPolicy    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${tupleExistsPolicy}
    ${tupleSpecifier}=    Create Xml Object    tupleSpecifier
    ${termId}=    Create Xml Object    termId    elementText=${Term ID}
    ${keyPropertyValue}=    Create Xml Object    keyPropertyValue    elementText=${Key Property Value}
    ${tupleId}=    Create Xml Object    tupleId    elementText=${Tuple ID}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${tupleSpecifier}    ${termId}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${keyPropertyValue}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${tupleId}
    ${create request xml propertySequence}=    Create Xml Object    propertySequence
    ${create request xml propertySequence}=    Add List Of Subelements To Xml    ${create request xml propertySequence}    ${Properties}
    ${tuple}=    Create Xml Object    tuple    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${create request xml tuple}=    Add Subelement To Xml    ${tuple}    ${create request xml tupleSpecifier}
    ${create request xml tuple}=    Add Subelement To Xml    ${create request xml tuple}    ${create request xml propertySequence}
    ${batch create request xml}=    Add Subelement To Xml    ${batchOperationRequest}    ${type}
    ${batch create request xml}=    Add Subelement To Xml    ${batch create request xml}    ${clientBatchOperationId}
    ${batch create request xml}=    Add Subelement To Xml    ${batch create request xml}    ${tuple}
    ${batch create request xml}=    Add Subelement To Xml    ${batch create request xml}    ${tupleExistsPolicy}
    ${request body}=    Get Xml    ${batch create request xml}
    Log    ${request body}
    [Return]    ${batch create request xml}

Batch Create Operation XML tupleEchoPolicy
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${tupleEchoPolicy}    @{Properties}
    [Documentation]    Creates the request xml string for a single create operation within a batch including spcification of the tupleEchoPolicy.
    ...
    ...    *Arguments*
    ...    - ${Term ID} = Term ID of the term to create a tuple for
    ...    - ${Key Property Value}= Value of the key property of the tuple to be created
    ...    - ${Tuple ID} = ID of the tuple of the tuple to be created
    ...    - ${tupleEchoPolicy} = Value of the tupleEchoPolicy
    ...    - @{Properties} = (OPTIONAL) The Property element XML segments. Must be supplied by either the Batch Set Property Element (Non-Linked) or Batch Set Property Element (Linked) keyword depending on the property type. Can be either a single argument/list argument or multiple arguments.
    ...
    ...    *Return Value*
    ...    - ${batch create request xml} = batchOperationRequest xml string for a single create operation.
    ...
    ...    *Example*
    ...
    ...    | ${Property XML 1}= | Batch Set Property Element (Non-Linked) | Property 1 | ${propertytermid} | ${propertyid} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Batch Set Property Element (Linked) | Linked Property 1 | ${propertytermid | ${propertyid} | ${linkTupleId} | ${linkTermId |
    ...    | ${Operation 1 XML} = | Batch Create Operation XML tupleEchoPolicy | ${Term ID} | Key Property Value 1 | ${Tuple ID} | IGNORE | ${Property XML 1 | ${Property XML 2} |
    ...    | Batch Request | +1 | 2 | ${Operation 1} |
    ${Client Batch Operation ID}=    Create Batch Operation ID
    ${batchOperationRequest}=    Create Xml Object    batchOperationRequest    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${batchOperationRequest}=    Set Element Attribute    ${batchOperationRequest}    {http://www.w3.org/2001/XMLSchema-instance}type    TupleOperationRequest    ${BATCH XMLNS REQUEST BATCH}
    ${type}=    Create Xml Object    type    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=CREATE
    ${clientBatchOperationId}=    Create Xml Object    clientBatchOperationId    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Batch Operation ID}
    ${tupleEchoPolicy}=    Create Xml Object    tupleEchoPolicy    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${tupleEchoPolicy}
    ${tupleSpecifier}=    Create Xml Object    tupleSpecifier
    ${termId}=    Create Xml Object    termId    elementText=${Term ID}
    ${keyPropertyValue}=    Create Xml Object    keyPropertyValue    elementText=${Key Property Value}
    ${tupleId}=    Create Xml Object    tupleId    elementText=${Tuple ID}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${tupleSpecifier}    ${termId}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${keyPropertyValue}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${tupleId}
    ${create request xml propertySequence}=    Create Xml Object    propertySequence
    ${create request xml propertySequence}=    Add List Of Subelements To Xml    ${create request xml propertySequence}    ${Properties}
    ${tuple}=    Create Xml Object    tuple    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${create request xml tuple}=    Add Subelement To Xml    ${tuple}    ${create request xml tupleSpecifier}
    ${create request xml tuple}=    Add Subelement To Xml    ${create request xml tuple}    ${create request xml propertySequence}
    ${batch update request xml}=    Add Subelement To Xml    ${batchOperationRequest}    ${type}
    ${batch update request xml}=    Add Subelement To Xml    ${batch update request xml}    ${clientBatchOperationId}
    ${batch update request xml}=    Add Subelement To Xml    ${batch update request xml}    ${tuple}
    ${batch update operation xml}=    Add Subelement To Xml    ${batch update request xml}    ${tupleEchoPolicy}
    ${request body}=    Get Xml    ${batch update request xml}
    Log    ${request body}
    [Return]    ${batch update request xml}

Batch Create Operation XML clientReasonForChange
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${Client Reason For Change}    @{Properties}
    [Documentation]    Creates the request body xml string for a single create operation within a batch operation including specification of the clientReasonForChange.
    ...
    ...    *Arguments*
    ...    - ${Term ID} = Term ID of the term
    ...    - ${Key Property Value}= Value of the key property of the tuple
    ...    - ${Tuple ID} = ID of the tuple
    ...    ${Client Reason For Change} = A user defined reason for the creation operation.
    ...    - @{Properties} = (OPTIONAL) The Property element XML segments. Must be supplied by either the Batch Set Property Element (Non-Linked) or Batch Set Property Element (Linked) keyword depending on the property type. Can be either a single argument/list argument or multiple arguments.
    ...
    ...    *Return Value*
    ...    - ${batch create request xml} = batchOperationRequest xml string for a single create operation.
    ...
    ...    *Example*
    ...
    ...    | ${Property XML 1}= | Batch Set Property Element (Non-Linked) | Property 1 | ${propertytermid} | ${propertyid} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Batch Set Property Element (Linked) | Linked Property 1 | ${propertytermid | ${propertyid} | ${linkTupleId} | ${linkTermId |
    ...    | ${Operation 1 XML} = | Batch Create Operation XML clientReasonForChange | ${Term ID} | Key Property Value 1 | ${Tuple ID} | Creating a tuple for a new asset | ${Property XML 1 | ${Property XML 2} |
    ...    | Batch Request | +1 | 2 | ${Operation 1} |
    ${Client Batch Operation ID}=    Create Batch Operation ID
    ${batchOperationRequest}=    Create Xml Object    batchOperationRequest    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${batchOperationRequest}=    Set Element Attribute    ${batchOperationRequest}    {http://www.w3.org/2001/XMLSchema-instance}type    TupleOperationRequest    ${BATCH XMLNS REQUEST BATCH}
    ${type}=    Create Xml Object    type    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=CREATE
    ${clientBatchOperationId}=    Create Xml Object    clientBatchOperationId    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Batch Operation ID}
    ${clientReasonForChange}=    Create Xml Object    clientReasonForChange    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Reason For Change}
    ${tupleSpecifier}=    Create Xml Object    tupleSpecifier
    ${termId}=    Create Xml Object    termId    elementText=${Term ID}
    ${keyPropertyValue}=    Create Xml Object    keyPropertyValue    elementText=${Key Property Value}
    ${tupleId}=    Create Xml Object    tupleId    elementText=${Tuple ID}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${tupleSpecifier}    ${termId}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${keyPropertyValue}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${tupleId}
    ${create request xml propertySequence}=    Create Xml Object    propertySequence
    ${create request xml propertySequence}=    Add List Of Subelements To Xml    ${create request xml propertySequence}    ${Properties}
    ${tuple}=    Create Xml Object    tuple    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${create request xml tuple}=    Add Subelement To Xml    ${tuple}    ${create request xml tupleSpecifier}
    ${create request xml tuple}=    Add Subelement To Xml    ${create request xml tuple}    ${create request xml propertySequence}
    ${batch create request xml}=    Add Subelement To Xml    ${batchOperationRequest}    ${type}
    ${batch create request xml}=    Add Subelement To Xml    ${batch create request xml}    ${clientBatchOperationId}
    ${batch create request xml}=    Add Subelement To Xml    ${batch create request xml}    ${clientReasonForChange}
    ${batch create request xml}=    Add Subelement To Xml    ${batch create request xml}    ${tuple}
    ${request body}=    Get Xml    ${batch create request xml}
    Log    ${request body}
    [Return]    ${batch create request xml}

Batch Create Operation XML With Operation ID clientReasonForChange
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${Client Batch Operation ID}    ${Client Reason For Change}    @{Properties}
    [Documentation]    Creates the request body xml string for a single create operation within a batch operation including *setting a user defined client batch operation ID*.
    ...
    ...    *Update \ example to include exprected no of response bodies setting and talk about validation in description*
    ...
    ...    *Arguments*
    ...    - ${Term ID} = Term ID of the term
    ...    - ${Key Property Value}= Value of the key property of the tuple
    ...    - ${Tuple ID} = ID of the tuple
    ...    - ${Client Batch Operation ID} = an ID supplied by the user for the operation.
    ...    - @{Properties} = (OPTIONAL) xml for indivdidual properties of a term - Must be supplied by either the Batch Set Property Element (Non-Linked) or Batch Set Property Element (Linked) keyword depending on the property type.
    ...
    ...    *Return Value*
    ...    - ${batch create request xml} = batchOperationRequest xml string for a single create operation.
    ...
    ...    *Example*
    ...
    ...    Create a tuple for a term including setting the value of two properties within a batch operation:
    ...
    ...    | ${Property XML 1}= | Batch Set Property Element (Non-Linked) | Property 1 | 78538a20baa011e1aabf0025649342bb | 6507cfd0baa011e1aabf0025649342bb | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Batch Set Property Element (Linked) | Linked Property 1 | 8538a20baa011e1aabf0025649342bb | 6707cfd0baa011e1aabf0025649342bb | de67bb2697ac45fca2b2e881cf454149 | cca4d420bb6911e18e260025649342bb |
    ...    | ${Operation 1 XML} = | Batch Create Operation XML | 78538a20baa011e1aabf0025649342bb \ | Key Property Value 1 | 17874e993bcd47eebf11a178dd840dd6 | 111e57594c0f57b3bc3583eabaaf2ccd |
    ...    | Batch Request | +1 | ***** | Operation 1=${Operation 1} |
    ${batchOperationRequest}=    Create Xml Object    batchOperationRequest    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${batchOperationRequest}=    Set Element Attribute    ${batchOperationRequest}    {http://www.w3.org/2001/XMLSchema-instance}type    TupleOperationRequest    ${BATCH XMLNS REQUEST BATCH}
    ${type}=    Create Xml Object    type    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=CREATE
    ${clientBatchOperationId}=    Create Xml Object    clientBatchOperationId    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Batch Operation ID}
    ${clientReasonForChange}=    Create Xml Object    clientReasonForChange    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Reason For Change}
    ${tupleSpecifier}=    Create Xml Object    tupleSpecifier
    ${termId}=    Create Xml Object    termId    elementText=${Term ID}
    ${keyPropertyValue}=    Create Xml Object    keyPropertyValue    elementText=${Key Property Value}
    ${tupleId}=    Create Xml Object    tupleId    elementText=${Tuple ID}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${tupleSpecifier}    ${termId}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${keyPropertyValue}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${tupleId}
    ${create request xml propertySequence}=    Create Xml Object    propertySequence
    ${create request xml propertySequence}=    Add List Of Subelements To Xml    ${create request xml propertySequence}    ${Properties}
    ${tuple}=    Create Xml Object    tuple    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${create request xml tuple}=    Add Subelement To Xml    ${tuple}    ${create request xml tupleSpecifier}
    ${create request xml tuple}=    Add Subelement To Xml    ${create request xml tuple}    ${create request xml propertySequence}
    ${batch create request xml}=    Add Subelement To Xml    ${batchOperationRequest}    ${type}
    ${batch create request xml}=    Add Subelement To Xml    ${batch create request xml}    ${clientBatchOperationId}
    ${batch create request xml}=    Add Subelement To Xml    ${batch create request xml}    ${clientReasonForChange}
    ${batch create request xml}=    Add Subelement To Xml    ${batch create request xml}    ${tuple}
    ${request body}=    Get Xml    ${batch create request xml}
    Log    ${request body}
    [Return]    ${batch create request xml}

Batch Update Operation XML
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    @{Properties}
    [Documentation]    Creates the request body xml string for a single update operation within a batch.
    ...
    ...    *Arguments*
    ...    - ${Term ID} = Term ID of the term
    ...    - ${Key Property Value}= Value of the key property of the tuple
    ...    - ${Tuple ID} = ID of the tuple
    ...    - @{Properties} = (OPTIONAL) xml for indivdidual properties of a term - Must be supplied by either the Batch Set Property Element (Non-Linked) or Batch Set Property Element (Linked) depending on the property type.
    ...
    ...    *Return Value*
    ...    - ${batch update request xml} = batchOperationRequest request body xml string for a single update operation.
    ...
    ...    *Example*
    ...
    ...    | ${Property XML 1}= | Batch Set Property Element (Non-Linked) | Property 1 | ${propertytermid}| ${propertyid | Property 1 Value 1 Updated |
    ...    | ${Property XML 2}= | Batch Set Property Element (Linked) | Linked Property 1 | ${propertytermid} | ${propertyid} | ${linkedTupleId} | ${linkedTupleId} |
    ...    | ${Operation 1 XML} = | Batch Update Operation XML | ${Term ID}| Key Property Value 1 | ${Tuple ID} | ${Property XML 1} | ${Property XML 2} |
    ...    | Batch Request | +0 | 1 | ${Operation 1} |
    ${Batch Operation ID}=    Create Batch Operation ID
    ${batch update request xml}=    Batch Update Operation XML With Operation ID    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${Batch Operation ID}    @{Properties}
    [Return]    ${batch update request xml}

Batch Update Operation XML With Operation ID
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${Client Batch Operation ID}    @{Properties}
    [Documentation]    Creates the request body xml string for a single update operation within a batch including specification of a clientBatchOperationId.
    ...
    ...    *Arguments*
    ...    - ${Term ID} = Term ID of the term
    ...    - ${Key Property Value}= Value of the key property of the tuple
    ...    - ${Tuple ID} = ID of the tuple
    ...    - ${Client Batch Operation ID} = an ID supplied by the user for the operation.
    ...    - @{Properties} = (OPTIONAL) xml for indivdidual properties of a term - Must be supplied by either the Batch Set Property Element (Non-Linked) or Batch Set Property Element (Linked) depending on the property type.
    ...
    ...    *Return Value*
    ...    - ${batch update request xml} = batchOperationRequest request body xml string for a single update operation.
    ...
    ...    *Example*
    ...
    ...    | ${Property XML 1}= | Batch Set Property Element (Non-Linked) | Property 1 | ${propertytermid}| ${propertyid | Property 1 Value 1 Updated |
    ...    | ${Property XML 2}= | Batch Set Property Element (Linked) | Linked Property 1 | ${propertytermid} | ${propertyid} | ${linkedTupleId} | ${linkedTupleId} |
    ...    | ${Operation 1 XML} = | Batch Update Operation XML With Operation ID | ${Term ID}| Key Property Value 1 | ${Tuple ID} | Client Batch Operation ID 123| ${Property XML 1} | ${Property XML 2} |
    ...    | Batch Request | +0 | 1 | ${Operation 1} |
    ${batchOperationRequest}=    Create Xml Object    batchOperationRequest    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${batchOperationRequest}=    Set Element Attribute    ${batchOperationRequest}    {http://www.w3.org/2001/XMLSchema-instance}type    TupleOperationRequest    ${BATCH XMLNS REQUEST BATCH}
    ${type}=    Create Xml Object    type    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=UPDATE
    ${clientBatchOperationId}=    Create Xml Object    clientBatchOperationId    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Batch Operation ID}
    ${tupleSpecifier}=    Create Xml Object    tupleSpecifier
    ${termId}=    Create Xml Object    termId    elementText=${Term ID}
    ${keyPropertyValue}=    Create Xml Object    keyPropertyValue    elementText=${Key Property Value}
    ${tupleId}=    Create Xml Object    tupleId    elementText=${Tuple ID}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${tupleSpecifier}    ${termId}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${keyPropertyValue}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${tupleId}
    ${create request xml propertySequence}=    Create Xml Object    propertySequence
    ${create request xml propertySequence}=    Add List Of Subelements To Xml    ${create request xml propertySequence}    ${Properties}
    ${tuple}=    Create Xml Object    tuple    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${create request xml tuple}=    Add Subelement To Xml    ${tuple}    ${create request xml tupleSpecifier}
    ${create request xml tuple}=    Add Subelement To Xml    ${create request xml tuple}    ${create request xml propertySequence}
    ${batch update request xml}=    Add Subelement To Xml    ${batchOperationRequest}    ${type}
    ${batch update request xml}=    Add Subelement To Xml    ${batch update request xml}    ${clientBatchOperationId}
    ${batch update request xml}=    Add Subelement To Xml    ${batch update request xml}    ${tuple}
    ${request body}=    Get Xml    ${batch update request xml}
    Log    ${request body}
    [Return]    ${batch update request xml}

Batch Update Operation XML tupleExistsPolicy
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${tupleExistsPolicy}    @{Properties}
    [Documentation]    Creates the request body xml string for a single update operation within a batch *including the xml for the tupleExistsPolicy*.
    ...
    ...    *Arguments*
    ...    - ${Term ID} = Term ID of the term
    ...    - ${Key Property Value}= Value of the key property of the tuple
    ...    - ${Tuple ID} = ID of the tuple
    ...    - ${tupleExistsPolicy} = the setting of the tupleExistsPolicy
    ...    - @{Properties} = (OPTIONAL) xml for indivdidual properties of a term - Must be supplied by either the Batch Set Property Element (Non-Linked) or Batch Set Property Element (Linked) depending on the property type.
    ...
    ...    *Return Value*
    ...    - ${batch update request xml} = batchOperationRequest request body xml string for a single update operation.
    ...
    ...    *Example*
    ...
    ...    | ${Property XML 1}= | Batch Set Property Element (Non-Linked) | Property 1 | ${propertytermid}| ${propertyid | Property 1 Value 1 Updated |
    ...    | ${Property XML 2}= | Batch Set Property Element (Linked) | Linked Property 1 | ${propertytermid} | ${propertyid} | ${linkedTupleId} | ${linkedTupleId} |
    ...    | ${Operation 1 XML} = | Batch Update Operation XML tupleExistsPolicy | ${Term ID}| Key Property Value 1 | ${Tuple ID} | FAIL | ${Property XML 1} | ${Property XML 2} |
    ...    | Batch Request | +0 | 1 | ${Operation 1} |
    ${Client Batch Operation ID}=    Create Batch Operation ID
    ${batchOperationRequest}=    Create Xml Object    batchOperationRequest    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${batchOperationRequest}=    Set Element Attribute    ${batchOperationRequest}    {http://www.w3.org/2001/XMLSchema-instance}type    TupleOperationRequest    ${BATCH XMLNS REQUEST BATCH}
    ${type}=    Create Xml Object    type    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=UPDATE
    ${clientBatchOperationId}=    Create Xml Object    clientBatchOperationId    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Batch Operation ID}
    ${tupleExistsPolicy}=    Create Xml Object    tupleExistsPolicy    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${tupleExistsPolicy}
    ${tupleSpecifier}=    Create Xml Object    tupleSpecifier
    ${termId}=    Create Xml Object    termId    elementText=${Term ID}
    ${keyPropertyValue}=    Create Xml Object    keyPropertyValue    elementText=${Key Property Value}
    ${tupleId}=    Create Xml Object    tupleId    elementText=${Tuple ID}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${tupleSpecifier}    ${termId}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${keyPropertyValue}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${tupleId}
    ${create request xml propertySequence}=    Create Xml Object    propertySequence
    ${create request xml propertySequence}=    Add List Of Subelements To Xml    ${create request xml propertySequence}    ${Properties}
    ${tuple}=    Create Xml Object    tuple    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${create request xml tuple}=    Add Subelement To Xml    ${tuple}    ${create request xml tupleSpecifier}
    ${create request xml tuple}=    Add Subelement To Xml    ${create request xml tuple}    ${create request xml propertySequence}
    ${batch update request xml}=    Add Subelement To Xml    ${batchOperationRequest}    ${type}
    ${batch update request xml}=    Add Subelement To Xml    ${batch update request xml}    ${clientBatchOperationId}
    ${batch update request xml}=    Add Subelement To Xml    ${batch update request xml}    ${tuple}
    ${batch update request xml}=    Add Subelement To Xml    ${batch update request xml}    ${tupleExistsPolicy}
    ${request body}=    Get Xml    ${batch update request xml}
    Log    ${request body}
    [Return]    ${batch update request xml}

Batch Update Operation XML tupleEchoPolicy
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${tupleEchoPolicy}    @{Properties}
    [Documentation]    Creates the request body xml string for a single update operation within a batch including specification of the tupleEchoPolicy.
    ...
    ...    *Arguments*
    ...    - ${Term ID} = Term ID of the term
    ...    - ${Key Property Value}= Value of the key property of the tuple
    ...    - ${Tuple ID} = ID of the tuple
    ...    - ${tupleEchoPolicy} = the setting of the tupleEchoPolicy
    ...    - @{Properties} = (OPTIONAL) xml for indivdidual properties of a term - Must be supplied by either the Batch Set Property Element (Non-Linked) or Batch Set Property Element (Linked) depending on the property type.
    ...
    ...    *Return Value*
    ...    - ${batch update request xml} = batchOperationRequest request body xml string for a single update operation.
    ...
    ...    *Example*
    ...
    ...    | ${Property XML 1}= | Batch Set Property Element (Non-Linked) | Property 1 | ${propertytermid}| ${propertyid | Property 1 Value 1 Updated |
    ...    | ${Property XML 2}= | Batch Set Property Element (Linked) | Linked Property 1 | ${propertytermid} | ${propertyid} | ${linkedTupleId} | ${linkedTupleId} |
    ...    | ${Operation 1 XML} = | Batch Update Operation XML tupleEchoPolicy | ${Term ID}| Key Property Value 1 | ${Tuple ID} | CREATE | ${Property XML 1} | ${Property XML 2} |
    ...    | Batch Request | +0 | 1 | ${Operation 1} |
    ${Client Batch Operation ID}=    Create Batch Operation ID
    ${batchOperationRequest}=    Create Xml Object    batchOperationRequest    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${batchOperationRequest}=    Set Element Attribute    ${batchOperationRequest}    {http://www.w3.org/2001/XMLSchema-instance}type    TupleOperationRequest    ${BATCH XMLNS REQUEST BATCH}
    ${type}=    Create Xml Object    type    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=UPDATE
    ${clientBatchOperationId}=    Create Xml Object    clientBatchOperationId    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Batch Operation ID}
    ${tupleEchoPolicy}=    Create Xml Object    tupleEchoPolicy    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${tupleEchoPolicy}
    ${tupleSpecifier}=    Create Xml Object    tupleSpecifier
    ${termId}=    Create Xml Object    termId    elementText=${Term ID}
    ${keyPropertyValue}=    Create Xml Object    keyPropertyValue    elementText=${Key Property Value}
    ${tupleId}=    Create Xml Object    tupleId    elementText=${Tuple ID}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${tupleSpecifier}    ${termId}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${keyPropertyValue}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${tupleId}
    ${create request xml propertySequence}=    Create Xml Object    propertySequence
    ${create request xml propertySequence}=    Add List Of Subelements To Xml    ${create request xml propertySequence}    ${Properties}
    ${tuple}=    Create Xml Object    tuple    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${create request xml tuple}=    Add Subelement To Xml    ${tuple}    ${create request xml tupleSpecifier}
    ${create request xml tuple}=    Add Subelement To Xml    ${create request xml tuple}    ${create request xml propertySequence}
    ${batch update request xml}=    Add Subelement To Xml    ${batchOperationRequest}    ${type}
    ${batch update request xml}=    Add Subelement To Xml    ${batch update request xml}    ${clientBatchOperationId}
    ${batch update request xml}=    Add Subelement To Xml    ${batch update request xml}    ${tuple}
    ${batch update request xml}    Add Subelement To Xml    ${batch update request xml}    ${tupleEchoPolicy}
    Comment    ${request body}=    Get Xml    ${batch update operation xml}
    Comment    Log    ${request body}
    [Return]    ${batch update request xml}

Batch Update Operation XML clientReasonForChange
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${Client Reason For Change}    @{Properties}
    [Documentation]    Creates the request body xml string for a single update operation within a batch including specification of the clientReasonForChange
    ...
    ...    *Arguments*
    ...    - ${Term ID} = Term ID of the term
    ...    - ${Key Property Value}= Value of the key property of the tuple
    ...    - ${Tuple ID} = ID of the tuple
    ...    - ${Client Reason For Change} = A user defined reason for the update operation.
    ...    - @{Properties} = (OPTIONAL) xml for indivdidual properties of a term - Must be supplied by either the Batch Set Property Element (Non-Linked) or Batch Set Property Element (Linked) depending on the property type.
    ...
    ...    *Return Value*
    ...    - ${batch update request xml} = batchOperationRequest request body xml string for a single update operation.
    ...
    ...    *Example*
    ...
    ...    | ${Property XML 1}= | Batch Set Property Element (Non-Linked) | Property 1 | ${propertytermid}| ${propertyid | Property 1 Value 1 Updated |
    ...    | ${Property XML 2}= | Batch Set Property Element (Linked) | Linked Property 1 | ${propertytermid} | ${propertyid} | ${linkedTupleId} | ${linkedTupleId} |
    ...    | ${Operation 1 XML} = | Batch Update Operation XML clientReasonForChange | ${Term ID}| Key Property Value 1 | ${Tuple ID} | Updating an existing asset | ${Property XML 1} | ${Property XML 2} |
    ...    | Batch Request | +0 | 1 | ${Operation 1} |
    ${Client Batch Operation ID}=    Create Batch Operation ID
    ${batchOperationRequest}=    Create Xml Object    batchOperationRequest    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${batchOperationRequest}=    Set Element Attribute    ${batchOperationRequest}    {http://www.w3.org/2001/XMLSchema-instance}type    TupleOperationRequest    ${BATCH XMLNS REQUEST BATCH}
    ${type}=    Create Xml Object    type    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=UPDATE
    ${clientBatchOperationId}=    Create Xml Object    clientBatchOperationId    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Batch Operation ID}
    ${clientReasonForChange}=    Create Xml Object    clientReasonForChange    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Reason For Change}
    ${tupleSpecifier}=    Create Xml Object    tupleSpecifier
    ${termId}=    Create Xml Object    termId    elementText=${Term ID}
    ${keyPropertyValue}=    Create Xml Object    keyPropertyValue    elementText=${Key Property Value}
    ${tupleId}=    Create Xml Object    tupleId    elementText=${Tuple ID}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${tupleSpecifier}    ${termId}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${keyPropertyValue}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${tupleId}
    ${create request xml propertySequence}=    Create Xml Object    propertySequence
    ${create request xml propertySequence}=    Add List Of Subelements To Xml    ${create request xml propertySequence}    ${Properties}
    ${tuple}=    Create Xml Object    tuple    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${create request xml tuple}=    Add Subelement To Xml    ${tuple}    ${create request xml tupleSpecifier}
    ${create request xml tuple}=    Add Subelement To Xml    ${create request xml tuple}    ${create request xml propertySequence}
    ${batch update request xml}=    Add Subelement To Xml    ${batchOperationRequest}    ${type}
    ${batch update request xml}=    Add Subelement To Xml    ${batch update request xml}    ${clientBatchOperationId}
    ${batch update request xml}=    Add Subelement To Xml    ${batch update request xml}    ${clientReasonForChange}
    ${batch update request xml}=    Add Subelement To Xml    ${batch update request xml}    ${tuple}
    ${request body}=    Get Xml    ${batch update request xml}
    Log    ${request body}
    [Return]    ${batch update request xml}

Batch Delete Operation XML
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}
    [Documentation]    Creates the request body xml string for an individual delete operation within a batch.
    ...
    ...    *Arguments*
    ...    - ${Term ID} = ID of the term of the tuple soecified for deletion
    ...    - ${Key Property Value} = Value of the Key Property of the tuple specified for deletion
    ...    - ${Tuple ID} = ID of the tuple specified for deletion
    ...
    ...    *Return Value*
    ...    - ${batch delete request xml} = batchOperationRequest request body xml string for a single delete operation within a batch operation.
    ...
    ...    *Example*
    ...
    ...    | ${Operation XML}= | Batch Delete Operation XML | ${Term ID} | Key Property Value 1 | ${Tuple ID} |
    ...    | Batch Request | -1 | 1 | ${Operation XML} |
    ${Batch Operation ID}=    Create Batch Operation ID
    ${batch delete operation xml}=    Batch Delete Operation XML With Operation ID    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${Batch Operation ID}
    [Return]    ${batch delete operation xml}

Batch Delete Operation XML With Operation ID
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${Client Batch Operation ID}
    [Documentation]    Creates the request body xml string for an indivdidual delete operation within a batch operation including *setting a user defined client batch operation ID*.
    ...
    ...    *Update \ example to include exprected no of response bodies setting and talk about validation in description*
    ...
    ...    *Arguments*
    ...    - ${Term ID} = ID of the term of the tuple(s)
    ...    - ${Key Property Value} = Value of the Key Property of the tuple(s)
    ...    - ${Tuple ID} = ID of the tuple
    ...    - ${Client Batch Operation ID} = An ID supplied by the user for the operation.
    ...
    ...    *Return Value*
    ...    - ${batch delete request xml} = batchOperationRequest request body xml string for a single delete operation within a batch operation.
    ...
    ...    *Example*
    ...
    ...    | ${Operation XML}= | Batch Delete Operation XML With Operation ID | ${Term ID} | Key Property Value 1 | ${Tuple ID} | Client Batch Operation ID 123 |
    ...    | Batch Request | -1 | 1 | ${Operation XML} |
    ${batchOperationRequest}=    Create Xml Object    batchOperationRequest    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${batchOperationRequest}=    Set Element Attribute    ${batchOperationRequest}    {http://www.w3.org/2001/XMLSchema-instance}type    TupleOperationRequest    ${BATCH XMLNS REQUEST BATCH}
    ${type}=    Create Xml Object    type    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=DELETE
    ${clientBatchOperationId}=    Create Xml Object    clientBatchOperationId    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Batch Operation ID}
    ${tuple}=    Create Xml Object    tuple    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${tupleSpecifier}=    Create Xml Object    tupleSpecifier
    ${termId}=    Create Xml Object    termId    elementText=${Term ID}
    ${keyPropertyValue}=    Create Xml Object    keyPropertyValue    elementText=${Key Property Value}
    ${tupleId}=    Create Xml Object    tupleId    elementText=${Tuple ID}
    ${tupleSpecifier xml}=    Add Subelement To Xml    ${tupleSpecifier}    ${termId}
    ${tupleSpecifier xml}=    Add Subelement To Xml    ${tupleSpecifier xml}    ${keyPropertyValue}
    ${tupleSpecifier xml}=    Add Subelement To Xml    ${tupleSpecifier xml}    ${tupleId}
    ${tuple xml}=    Add Subelement To Xml    ${tuple}    ${tupleSpecifier xml}
    ${batch delete operation xml}=    Add Subelement To Xml    ${batchOperationRequest}    ${type}
    ${batch delete operation xml}=    Add Subelement To Xml    ${batch delete operation xml}    ${clientBatchOperationId}
    ${batch delete operation xml}=    Add Subelement To Xml    ${batch delete operation xml}    ${tuple xml}
    [Return]    ${batch delete operation xml}

Batch Delete Operation XML tupleExistsPolicy
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${tupleExistsPolicy}
    [Documentation]    Creates the request body xml string for an indivdidual delete operation within a batch operation including specification of the tupleExistsPolicy.
    ...
    ...    *Arguments*
    ...    - ${Term ID} = ID of the term of the tuple(s)
    ...    - ${Key Property Value} = Value of the Key Property of the tuple(s)
    ...    - ${Tuple ID} = ID of the tuple
    ...    - ${tupleExistsPolicy} = the setting of the tupleExistsPolicy
    ...
    ...    *Return Value*
    ...    - ${batch delete request xml} = batchOperationRequest request body xml string for a single delete operation within a batch operation.
    ...
    ...    *Example*
    ...
    ...    | ${Operation XML}= | Batch Delete Operation XML tupleExistsPolicy | ${Term ID} | Key Property Value 1 | ${Tuple ID} | FAIL |
    ...    | Batch Request | -1 | 1 | ${Operation XML} |
    ${Client Batch Operation ID}=    Create Batch Operation ID
    ${batchOperationRequest}=    Create Xml Object    batchOperationRequest    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${batchOperationRequest}=    Set Element Attribute    ${batchOperationRequest}    {http://www.w3.org/2001/XMLSchema-instance}type    TupleOperationRequest    ${BATCH XMLNS REQUEST BATCH}
    ${type}=    Create Xml Object    type    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=DELETE
    ${clientBatchOperationId}=    Create Xml Object    clientBatchOperationId    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Batch Operation ID}
    ${tupleExistsPolicy}=    Create Xml Object    tupleExistsPolicy    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${tupleExistsPolicy}
    ${tuple}=    Create Xml Object    tuple    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${tupleSpecifier}=    Create Xml Object    tupleSpecifier
    ${termId}=    Create Xml Object    termId    elementText=${Term ID}
    ${keyPropertyValue}=    Create Xml Object    keyPropertyValue    elementText=${Key Property Value}
    ${tupleId}=    Create Xml Object    tupleId    elementText=${Tuple ID}
    ${tupleSpecifier xml}=    Add Subelement To Xml    ${tupleSpecifier}    ${termId}
    ${tupleSpecifier xml}=    Add Subelement To Xml    ${tupleSpecifier xml}    ${keyPropertyValue}
    ${tupleSpecifier xml}=    Add Subelement To Xml    ${tupleSpecifier xml}    ${tupleId}
    ${tuple xml}=    Add Subelement To Xml    ${tuple}    ${tupleSpecifier xml}
    ${batch delete operation xml}=    Add Subelement To Xml    ${batchOperationRequest}    ${type}
    ${batch delete operation xml}=    Add Subelement To Xml    ${batch delete operation xml}    ${clientBatchOperationId}
    ${batch delete operation xml}=    Add Subelement To Xml    ${batch delete operation xml}    ${tuple xml}
    ${batch delete operation xml}=    Add Subelement To Xml    ${batch delete operation xml}    ${tupleExistsPolicy}
    ${request body}=    Get Xml    ${batch delete operation xml}
    Log    ${request body}
    [Return]    ${batch delete operation xml}

Batch Delete Operation XML tupleEchoPolicy
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${tupleEchoPolicy}
    [Documentation]    Creates the request body xml string for an indivdidual delete operation within a batch operation including specification of the tupleEchoPolicy.
    ...
    ...    *Arguments*
    ...    - ${Term ID} = ID of the term of the tuple(s)
    ...    - ${Key Property Value} = Value of the Key Property of the tuple(s)
    ...    - ${Tuple ID} = ID of the tuple
    ...    - ${tupleEchoPolicy} = the setting of the tupleEchoPolicy
    ...
    ...    *Return Value*
    ...    - ${batch delete request xml} = batchOperationRequest request body xml string for a single delete operation within a batch operation.
    ...
    ...    *Example*
    ...
    ...    | ${Operation XML}= | Batch Delete Operation XML tupleEchoPolicy | ${Term ID} | Key Property Value 1 | ${Tuple ID} | CREATE |
    ...    | Batch Request | -1 | 1 | ${Operation XML} |
    ${Client Batch Operation ID}=    Create Batch Operation ID
    ${batchOperationRequest}=    Create Xml Object    batchOperationRequest    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${batchOperationRequest}=    Set Element Attribute    ${batchOperationRequest}    {http://www.w3.org/2001/XMLSchema-instance}type    TupleOperationRequest    ${BATCH XMLNS REQUEST BATCH}
    ${type}=    Create Xml Object    type    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=DELETE
    ${clientBatchOperationId}=    Create Xml Object    clientBatchOperationId    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Batch Operation ID}
    ${tupleEchoPolicy}=    Create Xml Object    tupleEchoPolicy    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${tupleEchoPolicy}
    ${tuple}=    Create Xml Object    tuple    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${tupleSpecifier}=    Create Xml Object    tupleSpecifier
    ${termId}=    Create Xml Object    termId    elementText=${Term ID}
    ${keyPropertyValue}=    Create Xml Object    keyPropertyValue    elementText=${Key Property Value}
    ${tupleId}=    Create Xml Object    tupleId    elementText=${Tuple ID}
    ${tupleSpecifier xml}=    Add Subelement To Xml    ${tupleSpecifier}    ${termId}
    ${tupleSpecifier xml}=    Add Subelement To Xml    ${tupleSpecifier xml}    ${keyPropertyValue}
    ${tupleSpecifier xml}=    Add Subelement To Xml    ${tupleSpecifier xml}    ${tupleId}
    ${tuple xml}=    Add Subelement To Xml    ${tuple}    ${tupleSpecifier xml}
    ${batch delete operation xml}=    Add Subelement To Xml    ${batchOperationRequest}    ${type}
    ${batch delete operation xml}=    Add Subelement To Xml    ${batch delete operation xml}    ${clientBatchOperationId}
    ${batch delete operation xml}=    Add Subelement To Xml    ${batch delete operation xml}    ${tuple xml}
    ${batch delete operation xml}=    Add Subelement To Xml    ${batch delete operation xml}    ${tupleEchoPolicy}
    ${request body}=    Get Xml    ${batch delete operation xml}
    Log    ${request body}
    [Return]    ${batch delete operation xml}

Batch Delete Operation XML clientReasonForChange
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${Client Reason For Change}
    [Documentation]    Creates the request body xml string for an indivdidual delete operation within a batch operation including specification of the clientReasonForChange.
    ...
    ...    *Arguments*
    ...    - ${Term ID} = ID of the term of the tuple(s)
    ...    - ${Key Property Value} = Value of the Key Property of the tuple(s)
    ...    - ${Tuple ID} = ID of the tuple
    ...    - ${Client Reason For Change} = A user defined reason for the deletion operation.
    ...
    ...    *Return Value*
    ...    - ${batch delete request xml} = batchOperationRequest request body xml string for a single delete operation within a batch operation.
    ...
    ...    *Example*
    ...
    ...    | ${Operation XML}= | Batch Delete Operation XML clientReasonForChange | ${Term ID} | Key Property Value 1 | ${Tuple ID} | Deletion of a tuple that doesn't exist |
    ...    | Batch Request | -1 | 1 | ${Operation XML} |
    ${Client Batch Operation ID}=    Create Batch Operation ID
    ${batchOperationRequest}=    Create Xml Object    batchOperationRequest    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${batchOperationRequest}=    Set Element Attribute    ${batchOperationRequest}    {http://www.w3.org/2001/XMLSchema-instance}type    TupleOperationRequest    ${BATCH XMLNS REQUEST BATCH}
    ${type}=    Create Xml Object    type    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=DELETE
    ${clientBatchOperationId}=    Create Xml Object    clientBatchOperationId    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Batch Operation ID}
    ${clientReasonForChange}=    Create Xml Object    clientReasonForChange    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Reason For Change}
    ${tuple}=    Create Xml Object    tuple    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${tupleSpecifier}=    Create Xml Object    tupleSpecifier
    ${termId}=    Create Xml Object    termId    elementText=${Term ID}
    ${keyPropertyValue}=    Create Xml Object    keyPropertyValue    elementText=${Key Property Value}
    ${tupleId}=    Create Xml Object    tupleId    elementText=${Tuple ID}
    ${tupleSpecifier xml}=    Add Subelement To Xml    ${tupleSpecifier}    ${termId}
    ${tupleSpecifier xml}=    Add Subelement To Xml    ${tupleSpecifier xml}    ${keyPropertyValue}
    ${tupleSpecifier xml}=    Add Subelement To Xml    ${tupleSpecifier xml}    ${tupleId}
    ${tuple xml}=    Add Subelement To Xml    ${tuple}    ${tupleSpecifier xml}
    ${batch delete operation xml}=    Add Subelement To Xml    ${batchOperationRequest}    ${type}
    ${batch delete operation xml}=    Add Subelement To Xml    ${batch delete operation xml}    ${clientBatchOperationId}
    ${batch delete operation xml}=    Add Subelement To Xml    ${batch delete operation xml}    ${clientReasonForChange}
    ${batch delete operation xml}=    Add Subelement To Xml    ${batch delete operation xml}    ${tuple xml}
    ${request body}=    Get Xml    ${batch delete operation xml}
    Log    ${request body}
    [Return]    ${batch delete operation xml}

Batch Retrieve Operation XML
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}
    [Documentation]    Creates the request body xml string for a single retrieve operations within a batch.
    ...
    ...    *Arguments*
    ...    - ${Term ID} = ID of the term of the tuple(s)
    ...    - ${Key Property Value} = Value of the Key Property of the tuple(s)
    ...    - ${Tuple ID} = ID of the tuple
    ...
    ...    *Return Value*
    ...    - ${batch retrieve request xml} = batchOperationRequest request body xml string for a single retrieve operation within a batch.
    ...
    ...    *Example*
    ...
    ...    | ${Operation XL}= | Batch Retrieve Operation XML | ${Term ID} | Key Property Value 1 | ${Tuple ID} |
    ...    | Batch Request | +0 | 1 | ${Operation XML} |
    ${Batch Operation ID}=    Create Batch Operation ID
    ${batch retrieve operation xml}=    Batch Retrieve Operation XML With Operation ID    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${Batch Operation ID}
    [Return]    ${batch retrieve operation xml}

Batch Retrieve Operation XML With Operation ID
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${Client Batch Operation ID}
    [Documentation]    Creates the request body xml string for a single retrieve operations within a batch including specification of the clientBatchOperationId.
    ...
    ...    *Arguments*
    ...    - ${Term ID} = ID of the term of the tuple(s)
    ...    - ${Key Property Value} = Value of the Key Property of the tuple(s)
    ...    - ${Tuple ID} = ID of the tuple
    ...    - ${Client Batch Operation ID} = Value of the clientBatchOperationId
    ...
    ...    *Return Value*
    ...    - ${batch retrieve request xml} = batchOperationRequest request body xml string for a single retrieve operation within a batch.
    ...
    ...    *Example*
    ...
    ...    Retrieve a specific tuple by term ID, key property value and tuple ID.
    ...
    ...    | ${Operation XL}= | Batch Retrieve Operation XML With Operation ID | ${Term ID} | Key Property Value 1 | ${Tuple ID} | BatchOperationID123 |
    ...    | Batch Request | +0 | 1 | ${Operation XML} |
    ${batchOperationRequest}=    Create Xml Object    batchOperationRequest    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${batchOperationRequest}=    Set Element Attribute    ${batchOperationRequest}    {http://www.w3.org/2001/XMLSchema-instance}type    TupleOperationRequest    ${BATCH XMLNS REQUEST BATCH}
    ${type}=    Create Xml Object    type    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=RETRIEVE
    ${clientBatchOperationId}=    Create Xml Object    clientBatchOperationId    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Batch Operation ID}
    ${tuple}=    Create Xml Object    tuple    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${tupleSpecifier}=    Create Xml Object    tupleSpecifier
    ${termId}=    Create Xml Object    termId    elementText=${Term ID}
    ${keyPropertyValue}=    Create Xml Object    keyPropertyValue    elementText=${Key Property Value}
    ${tupleId}=    Create Xml Object    tupleId    elementText=${Tuple ID}
    ${tupleSpecifier xml}=    Add Subelement To Xml    ${tupleSpecifier}    ${termId}
    ${tupleSpecifier xml}=    Add Subelement To Xml    ${tupleSpecifier xml}    ${keyPropertyValue}
    ${tupleSpecifier xml}=    Add Subelement To Xml    ${tupleSpecifier xml}    ${tupleId}
    ${tuple xml}=    Add Subelement To Xml    ${tuple}    ${tupleSpecifier xml}
    ${batch retrieve operation xml}=    Add Subelement To Xml    ${batchOperationRequest}    ${type}
    ${batch retrieve operation xml}=    Add Subelement To Xml    ${batch retrieve operation xml}    ${clientBatchOperationId}
    ${batch retrieve operation xml}=    Add Subelement To Xml    ${batch retrieve operation xml}    ${tuple xml}
    [Return]    ${batch retrieve operation xml}

Batch Retrieve Operation XML clientReasonForChange
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${Client Reason For Change}
    [Documentation]    Creates the request body xml string for a single retrieve operations within a batch including specification of the cleintReasonForChange.
    ...
    ...    *Arguments*
    ...    - ${Term ID} = ID of the term of the tuple(s)
    ...    - ${Key Property Value} = Value of the Key Property of the tuple(s)
    ...    - ${Tuple ID} = ID of the tuple
    ...    - ${Client Reason For Change} = Value of the clientReasonForChange
    ...
    ...    *Return Value*
    ...    - ${batch retrieve request xml} = batchOperationRequest request body xml string for a single retrieve operation within a batch including the clientReasonForChange element.
    ...
    ...    *Example*
    ...
    ...    Retrieve a specific tuple by term ID, key property value and tuple ID.
    ...
    ...    | ${Operation XL}= | Batch Retrieve Operation XML clientReasonForChange | ${Term ID} | Key Property Value 1 | ${Tuple ID} | Changed Just Because |
    ...    | Batch Request | +0 | 1 | ${Operation XML} |
    ${Client Batch Operation ID}=    Create Batch Operation ID
    ${batchOperationRequest}=    Create Xml Object    batchOperationRequest    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${batchOperationRequest}=    Set Element Attribute    ${batchOperationRequest}    {http://www.w3.org/2001/XMLSchema-instance}type    TupleOperationRequest    ${BATCH XMLNS REQUEST BATCH}
    ${type}=    Create Xml Object    type    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=RETRIEVE
    ${clientBatchOperationId}=    Create Xml Object    clientBatchOperationId    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Batch Operation ID}
    ${clientReasonForChange}=    Create Xml Object    clientReasonForChange    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Reason For Change}
    ${tuple}=    Create Xml Object    tuple    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${tupleSpecifier}=    Create Xml Object    tupleSpecifier
    ${termId}=    Create Xml Object    termId    elementText=${Term ID}
    ${keyPropertyValue}=    Create Xml Object    keyPropertyValue    elementText=${Key Property Value}
    ${tupleId}=    Create Xml Object    tupleId    elementText=${Tuple ID}
    ${tupleSpecifier xml}=    Add Subelement To Xml    ${tupleSpecifier}    ${termId}
    ${tupleSpecifier xml}=    Add Subelement To Xml    ${tupleSpecifier xml}    ${keyPropertyValue}
    ${tupleSpecifier xml}=    Add Subelement To Xml    ${tupleSpecifier xml}    ${tupleId}
    ${tuple xml}=    Add Subelement To Xml    ${tuple}    ${tupleSpecifier xml}
    ${batch retrieve operation xml}=    Add Subelement To Xml    ${batchOperationRequest}    ${type}
    ${batch retrieve operation xml}=    Add Subelement To Xml    ${batch retrieve operation xml}    ${clientBatchOperationId}
    ${batch retrieve operation xml}=    Add Subelement To Xml    ${batch retrieve operation xml}    ${clientReasonForChange}
    ${batch retrieve operation xml}=    Add Subelement To Xml    ${batch retrieve operation xml}    ${tuple xml}
    ${request body}=    Get Xml    ${batch retrieve operation xml}
    Log    ${request body}
    [Return]    ${batch retrieve operation xml}

Batch Request
    [Arguments]    ${Expected Change in Tuple Count}    ${Expected No Operation Responses}    @{Operations}
    [Documentation]    Undertakes a batch request operation.
    ...
    ...
    ...    *Arguments*
    ...    - ${Expected Change in Tuple Count} = Change in tuple count expected following the batch operation
    ...    - ${Expected No Operation Responses} = The expected number of operation responses returned by the server
    ...    - @{Operations} = (OPTIONAL) - List of individual tuple requests to be undertaken by the batch. These are defined using the releavnt keyword for determining the XML of the operation. - optional
    ...
    ...    *Return Value*
    ...    - @{Operation Response Body} = The batchOperationResponse xml element of the response body.
    ...
    ...    *Example*
    ...
    ...    | ${Property XML 1}= | Batch Set Property Element (Non-Linked) | Property 1 | ${propertytermid} | ${propertyid} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Batch Set Property Element (Linked) | Linked Property 1 | ${propertytermid | ${propertyid} | ${linkTupleId} | ${linkTermId |
    ...    | ${Operation 1 XML} = | Batch Create Operation XML | ${Term ID} | Key Property Value 1 | ${Tuple ID} | ${Property XML 1} | ${Property XML 2} |
    ...    | Batch Request | +1 | 2 | ${Operation 1} |
    @{Operation Response Body}=    Batch Request With Non-Default Parameters    ${Expected Change in Tuple Count}    ${Expected No Operation Responses}    ${EMPTY}    @{Operations}
    [Return]    @{Operation Response Body}

Batch Request With Non-Default Parameters
    [Arguments]    ${Expected Change in Tuple Count}    ${Expected No Operation Responses}    ${Batch Request Description}    @{Operations}
    [Documentation]    Undertakes a batch request operation including specification of a description.
    ...
    ...
    ...    *Arguments*
    ...    - ${Expected Change in Tuple Count} = Change in tuple count expected following the batch operation
    ...    - ${Expected No Operation Responses} = The expected number of operation responses returned by the server
    ...    - ${Batch Request Description} = User defined description for the batch operation.
    ...    - @{Operations} = (OPTIONAL) - List of individual tuple requests to be undertaken by the batch. These are defined using the releavnt keyword for determining the XML of the operation. - optional
    ...
    ...    *Return Value*
    ...    - @{Operation Response Body} = The batchOperationResponse xml element of the response body.
    ...
    ...    *Example*
    ...
    ...    | ${Property XML 1}= | Batch Set Property Element (Non-Linked) | Property 1 | ${propertytermid} | ${propertyid} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Batch Set Property Element (Linked) | Linked Property 1 | ${propertytermid | ${propertyid} | ${linkTupleId} | ${linkTermId |
    ...    | ${Operation 1 XML} = | Batch Create Operation XML | ${Term ID} | Key Property Value 1 | ${Tuple ID} | ${Property XML 1} | ${Property XML 2} |
    ...    | Batch Request | +1 | 2 | A description for the batch operation | ${Operation 1} |
    #Get current number of tuples
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected}=    Evaluate    ${tuple count}${Expected Change in Tuple Count}
    #Perform Batch Request
    ${Response Body}=    Execute Batch Request With Non-Default Parameters    ${Batch Request Description}    @{Operations}
    #Validate Number of Tuples and general response body
    Validate Number of Tuples    ${tuple count expected}
    @{Operation Response Body}=    General Response Body    ${Response Body}    ${Expected No Operation Responses}
    [Return]    @{Operation Response Body}

Execute Batch Request
    [Arguments]    @{Operations}
    [Documentation]    *Undertakes a batch request with default parameters with no validation.*
    ...
    ...    *Note* This keyword does not do any validation
    ...
    ...    *Arguments*
    ...    - @{Operations} = List of individual tuple requests to be undertaken by the batch. These are defined using the releavnt keyword for determining the XML of the operation.
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    | ${Property XML 1}= | Batch Set Property (Non-Linked) | Property 1 | ${Property Term ID} | ${Property ID} | Property 1 Value 1 |
    ...    | ${Operation Create}= | Batch Create Operation XML | ${Term ID} | Key Property Value 1 | ${Tuple ID} | ${Property XML 1} |
    ...    | Execute Batch Request | ${Operation Create} |
    ${Response Body}=    Execute Batch Request With Non-Default Parameters    ${EMPTY}    @{Operations}
    @{Operation Response Body}=    Get Element Xml From Xpath    ${Response Body}    .//{${XMLNS RESPONSE BATCH}}batchOperationResponse[\@{http://www.w3.org/2001/XMLSchema-instance}type='{${XMLNS RESPONSE BATCH}}TupleOperationResponse']
    [Return]    @{Operation Response Body}

Execute Batch Request With Non-Default Parameters
    [Arguments]    ${Batch Request Description}    @{Operations}
    [Documentation]    *Undertakes a batch request.*
    ...
    ...    *Use Execute Request" in preference to this keyword unless you need to set all of the parameters listed as arguments.*
    ...
    ...    *Note* This keyword performs a batch request action with no validation
    ...
    ...    *Arguments*
    ...    - ${Batch Request Description} = A description for the operation supplied by the user.
    ...    - @{Operations} = (OPTIONAL) - List of individual tuple requests to be undertaken by the batch. These are defined using the releavnt keyword for determining the XML of the operation. - optional
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    | ${Property XML 1}= | Batch Set Property (Non-Linked) | Property 1 | ${Property Term ID} | ${Property ID} | Property 1 Value 1 |
    ...    | ${Operation Create}= | Batch Create Operation XML | ${Term ID} | Key Property Value 1 | ${Tuple ID} | ${Property XML 1} |
    ...    | Execute Batch Request With Non-Default Parameters | A description for the batch operation | ${Operation Create} |
    Tuple Web Services Request Setup
    ${request}=    Create Xml Object    hubTechRequest
    Set Element Attribute    ${request}    xmlns    ${XMLNS REQUEST HUBTECH}
    ${description}=    Create Xml Object    description    elementNamespace=${BATCH XMLNS REQUEST SERVICES}    elementText=${Batch Request Description}
    ${batch}=    Create Xml Object    batch    elementNamespace=${BATCH XMLNS REQUEST SERVICES}
    ${batch operation requests set}=    Create Xml Object    batchOperationRequests    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${batch operation requests set}=    Add List Of Subelements To Xml    ${batch operation requests set}    @{Operations}
    ${batch request set}=    Add Subelement To Xml    ${batch}    ${batch operation requests set}
    ${batch_request_xml}=    Add Subelement To Xml    ${request}    ${description}
    ${batch_request_xml}=    Add Subelement To Xml    ${batch_request_xml}    ${batch request set}
    ${batch_request_xml}    Get Xml    ${batch_request_xml}
    Log    ${batch_request_xml}
    Set Request Timeout    180s
    Set Request Body    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>${batch_request_xml}
    POST    ${BATCH END}
    ${Response Body}=    Get Response Body
    Log    ${Response Body}
    Response Status Code Should Equal    200
    Check Xml Contains Element    status value present in response from Server. No status value suggests an error has been returned. Check log file for full response.    ${Response Body}    .//{${XMLNS RESPONSE TUPLE}}status    xpath=${True}    failure_stops_test=${True}
    @{status}=    Get Element Value From Xpath    ${Response Body}    .//{${XMLNS RESPONSE TUPLE}}status
    Check String Equals    Status should be "Request Completed OK"    @{status}[0]    Request Completed OK
    [Return]    ${Response Body}

Batch Request and Expect Error
    [Arguments]    @{Operations}
    [Documentation]    *Undertakes a batch request and expects an error to occur.*
    ...
    ...    *Request carried out with a default description and the isTestOnly and isAsTransaction values set to false. If these values need to be changed, use "Batch Request and Expect Error With Non-Default Parameters"*
    ...
    ...    *Update example to include exprected no of response bodies setting and talk about validation in description. Also need to sort return value out*
    ...
    ...    *Arguments*
    ...    - ${Expected Change in Tuple Count} = Change in tuple count expected following the batch operation
    ...    - ${Batch Request Description} = (DEFAULT SET) A description for the operation supplied by the user.
    ...    - ${isTestOnly Setting} = (DEFAULT SET)
    ...    - ${isAsTransaction} = (DEFAULT SET)
    ...    - @{Operations} = (OPTIONAL) - List of individual tuple requests to be undertaken by the batch. These are defined using the releavnt keyword for determining the XML of the operation. - optional
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    Undertake a create, update, retrieve and delete operation within a single batch operation:
    ...
    ...    | ${Property Create XML 1} = | Batch Set Property Element (Non-Linked) | Property 1 | 78538a20baa011e1aabf0025649342bb | 6507cfd0baa011e1aabf0025649342bb | Property 1 Value 3 | mm |
    ...    | ${PropertyCreate XML 2}= |Batch Set Property Element (Linked) | Linked Property | 78538a20baa011e1aabf0025649342bb | 6707cfd0baa011e1aabf0025649342bb | 6004aaf2ae6b4fd7ab7cbf1e0bf343a2 | cca4d420bb6911e18e260025649342bb |
    ...    | ${Operation 1 XML} = | Batch Create Operation XML | \ 78538a20baa011e1aabf0025649342bb | Key Property Value 3 | 41853c2559f34ae6bde49306295369a6 | Property XML 1=${Property Create XML 1} | Property XML 2=${Property Create XML 2} |
    ...    | ${Property Update XML 1}= | Batch Set Property Element (Non-Linked) | Property 1 | 78538a20baa011e1aabf0025649342bb | 6507cfd0baa011e1aabf0025649342bb | Property 1 Value 2 Update |
    ...    | ${Operation 2 XML}= | Batch Update Operation XML | 78538a20baa011e1aabf0025649342bb | Key Property Value 2 | 9a163049c1bc416eb9ccd67b08a11faf | 111e57594c0f57b3bc3583eabaaf2cce |${Property Update XML 1} |
    ...    | ${Operation 3 XML}= | Batch Retrieve Operation XML | 78538a20baa011e1aabf0025649342bb | * | * |
    ...    | ${Operation 4 XML}= | Batch Delete Operation XML | 78538a20baa011e1aabf0025649342bb | Key Property Value 1 | e234564c0c0a499c9644c81928bc9dba | +0 | *** | a description | true | true | ${Operation 1 XML} | ${Operation 2 XML} | ${Operation 3 XML} | ${Operation 4 XML} |
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected}=    Evaluate    ${tuple count}+0
    Tuple Web Services Request Setup
    ${request}=    Create Xml Object    hubTechRequest
    Set Element Attribute    ${request}    xmlns    ${XMLNS REQUEST HUBTECH}
    ${description}=    Create Xml Object    description    elementNamespace=${BATCH XMLNS REQUEST SERVICES}    elementText=A batch request that is expected to fail.
    ${batch}=    Create Xml Object    batch    elementNamespace=${BATCH XMLNS REQUEST SERVICES}
    ${batch operation requests set}=    Create Xml Object    batchOperationRequests    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${batch operation requests set}=    Add List Of Subelements To Xml    ${batch operation requests set}    @{Operations}
    ${batch request set}=    Add Subelement To Xml    ${batch}    ${batch operation requests set}
    ${batch request xml}=    Add Subelement To Xml    ${request}    ${description}
    ${batch request xml}=    Add Subelement To Xml    ${batch request xml}    ${batch request set}
    ${batch request xml}=    Get Xml    ${batch request xml}
    Log    ${batch request xml}
    Set Request Body    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>${batch request xml}
    POST    ${BATCH END}
    ${Error Response Body}=    Get Response Body
    Log    ${Error Response Body}
    Validate Number of Tuples    ${tuple count expected}
    Should Not Contain    ${Error Response Body}    Request Completed OK    Response body should not have contained "Request Completed OK".
    Check Xml Element Value Equals    checking the value of the description element    ${Error Response Body}    ERROR    description    ${XMLNS REQUEST BATCH}
    [Return]    ${Error Response Body}

Error Response
    [Arguments]    ${Error Response Body}    ${exceptionType Value}=${EMPTY}    ${exceptionCode Value}=${EMPTY}    ${headline Value}=${EMPTY}    ${description Value}=${EMPTY}    ${locationCode Value}=${EMPTY}
    ...    ${advice Value}=${EMPTY}
    [Documentation]    Validates the structure and content of an error response body.
    ...
    ...    *Arguments*
    ...
    ...    -${Error Response Body} = Response body returned by the tuple operation
    ...    -${exceptionType Value} = Value expected for the exceptionType element
    ...    -${exceptionCode Value} = Value expected for the exceptionCode element
    ...    -${headline Value} = Value expected for the headline element
    ...    -${description Value} = Value expected for the description element within the exception element
    ...    -${locationCode Value} = Value expected for the advice element.
    ...    -${advice Value} = Value expected for the advice element.
    ...
    ...
    ...
    ...
    ...    ${Error Response Body} | ${exceptionType Value}=${EMPTY} | ${exceptionCode Value}=${EMPTY} | ${headline Value}=${EMPTY} | ${description Value}=${EMPTY} | ${locationCode Value}=${EMPTY} | ${advice Value}=${EMPTY}
    Should Contain    ${Error Response Body}    hubTechResponse
    Check XML Element Count    One batchResponse element per error response (Critical check).    ${Error Response Body}    1    batchResponse    ${XMLNS REQUEST HUBTECH}    failure_stops_test=${True}
    Check Xml Does Not Contain Element    Checks error response body does not contain batchOperationResponses element.    ${Error Response Body}    batchOperationResponses
    Check Xml Does Not Contain Element    Checks error response body does not contain batchOperationResponse elements.    ${Error Response Body}    batchOperationResponse
    Check Xml Does Not Contain Element    Checks error response body does not contain tupleResponse elements.    ${Error Response Body}    tupleResponse    ${XMLNS RESPONSE BATCH}
    Check Xml Element Count    One description element ....    ${Error Response Body}    1    description    ${XMLNS RESPONSE BATCH}
    Check Xml Element Value Is Not Empty    Checks the description element within the batch namespace has a value.    ${Error Response Body}    description    ${XMLNS RESPONSE BATCH}
    Check Xml Element Value Equals    Checks ...    ${Error Response Body}    ERROR    description    ${XMLNS RESPONSE BATCH}
    Check Xml Element Count    Checks one exception element per error response body.    ${Error Response Body}    1    exception    ${XMLNS RESPONSE BATCH}
    @{Error Response Body 2}=    Get Element Xml    ${Error Response Body}    ${XMLNS RESPONSE BATCH}    exception
    Check Xml Element Count    Check one exceptionType element per exception element.    @{Error Response Body 2}[0]    1    exceptionType    ${XMLNS REQUEST COMMON}
    Check Xml Element Value Is Not Empty    Checks the exceptionType element has a value.    @{Error Response Body 2}[0]    exceptionType    ${XMLNS REQUEST COMMON}
    Run Keyword If    '${exceptionType Value}'!='${EMPTY}'    Check Xml Element Value Equals    Checks the value of the exceptionType element.    @{Error Response Body 2}[0]    ${exceptionType Value}    exceptionType
    ...    ${XMLNS REQUEST COMMON}
    Check Xml Element Count    Checks one exceptionCode element per exception element.    @{Error Response Body 2}[0]    1    exceptionCode    ${XMLNS REQUEST COMMON}
    Check Xml Element Value Is Not Empty    Checks the exceptionCode element has a value.    @{Error Response Body 2}[0]    exceptionCode    ${XMLNS REQUEST COMMON}
    Run Keyword If    '${exceptionCode Value}'!='${EMPTY}'    Check Xml Element Value Equals    Checks the value of the exceptionCode element.    @{Error Response Body 2}[0]    ${exceptionCode Value}    exceptionCode
    ...    ${XMLNS REQUEST COMMON}
    Check Xml Element Count    Checks one headline element per exception element.    @{Error Response Body 2}[0]    1    headline    ${XMLNS REQUEST COMMON}
    Check Xml Element Value Is Not Empty    Checks the headline element has a value.    @{Error Response Body 2}[0]    headline    ${XMLNS REQUEST COMMON}
    Run Keyword If    '${headline Value}'!='${EMPTY}'    Check Xml Element Value Equals    Checks the value of the headline value    @{Error Response Body 2}[0]    ${headline Value}    headline
    ...    ${XMLNS REQUEST COMMON}
    Check Xml Element Count    Checks one description per exception element.    @{Error Response Body 2}[0]    1    description    ${XMLNS REQUEST COMMON}
    ${response body exception element description value}=    Get Element Value    @{Error Response Body 2}[0]    ${XMLNS REQUEST COMMON}    description
    Log    ${response body exception element description value}
    ${status}    ${value}=    Run Keyword And Ignore Error    Should Be Empty    ${description Value}
    Run Keyword If    '${status}'=='FAIL'    Check Xml Element Value Is Not Empty    Checks the description element within the exception element has a value.    @{Error Response Body 2}[0]    description    ${XMLNS REQUEST COMMON}
    Run Keyword If    '${status}'=='FAIL'    Check Xml Element Value Contains    Checks the value of the description element.    @{Error Response Body 2}[0]    ${description Value}    description
    ...    ${XMLNS REQUEST COMMON}
    Check Xml Element Count    Checks one locationCode element per exception code.    @{Error Response Body 2}[0]    1    locationCode    ${XMLNS REQUEST COMMON}
    Run Keyword If    '${locationCode Value}'!='${EMPTY}'    Check Xml Element Value Equals    Checks the value of the locationCode element.    @{Error Response Body 2}[0]    ${locationCode Value}    locationCode
    ...    ${XMLNS REQUEST COMMON}
    Check Xml Element Count    Checks one advice element per exception element.    @{Error Response Body 2}[0]    1    advice    ${XMLNS REQUEST COMMON}
    ${status}    ${value}=    Run Keyword And Ignore Error    Should Be Empty    ${advice Value}
    ${response body exception element advice value}=    Run Keyword If    '${status}'=='FAIL'    Get Element Value    @{Error Response Body 2}[0]    ${XMLNS REQUEST COMMON}    advice
    Run Keyword If    '${status}'=='FAIL'    Log    ${response body exception element advice value}
    Run Keyword If    '${status}'=='FAIL'    Check Xml Element Value Contains    Checks the value of the advice element.    @{Error Response Body 2}[0]    ${advice Value}    advice
    ...    ${XMLNS REQUEST COMMON}
    Comment    Run Keyword If    '${CustomDatas}'=='false'    Check Xml Element Count    Checks no customDatas element per exception element.    @{Error Response Body 2}[0]    0
    ...    customDatas    ${XMLNS REQUEST COMMON}
    Comment    Run Keyword If    '${CustomDatas}'=='true'    Check Xml Element Count    Checks one customDatas element per exception element.    @{Error Response Body 2}[0]    1
    ...    customDatas    ${XMLNS REQUEST COMMON}
    Comment    @{Error Response Body 3}=    Run Keyword If    '${CustomDatas}'=='true'    Get Xml    @{Error Response Body 2}[0]    ${XMLNS REQUEST COMMON}
    ...    customDatas
    Comment    Run Keyword If    '${CustomDatas}'=='true'    Check Xml Element Count    Checks one customData element per customDatas element.    @{Error Response Body 3}[0]    1
    ...    customData    ${XMLNS REQUEST COMMON}
    Comment    @{Error Response Body 4}=    Run Keyword If    '${CustomDatas}'=='true'    Get Xml    @{Error Response Body 3}[0]    ${XMLNS REQUEST COMMON}
    ...    customData
    Comment    Run Keyword If    '${CustomDatas}'=='true'    Check Xml Element Count    Checks one key element per customData element.    @{Error Response Body 4}[0]    1
    ...    key    ${XMLNS REQUEST COMMON}
    Comment    Run Keyword If    '${CustomDatas}'=='true'    Check Xml Element Value Equals    Checks the value of the key element within the customData element.    @{Error Response Body 4}[0]    ${key Value}
    ...    key    ${XMLNS REQUEST COMMON}
    Comment    Run Keyword If    '${CustomDatas}'=='true'    Check Xml Element Count    Checks one value element per customData element.    @{Error Response Body 4}[0]    1
    ...    value    ${XMLNS REQUEST COMMON}
    Comment    Run Keyword If    '${CustomDatas}'=='true'    Check Xml Element Value Equals    Checks the value of value element within the customData element.    @{Error Response Body 4}[0]    ${value Value}
    ...    value    ${XMLNS REQUEST COMMON}
    [Return]    ${response body exception element description value}

Rules Matched
    [Arguments]    ${Response Body}    ${Rules}
    [Documentation]    Checks that a supplied list of rules are indicated as matched in the response body of a tuple operation.
    ...
    ...    *Arguments*
    ...
    ...    ${batchOperationResponse xml}= The batchOperationResponse element to check.
    ...    ${Rules} = List of rule names to check are present as values for the ruleMatchId elements.
    ...
    ...    *Example*
    ...
    ...    |@{Operation Response Body}= | Batch Request | +1 | 2 | ${Operation Create} |
    ...    | ${Rules}= | Create List |
    ...    | Rules Matched | @{Operation Response Body}[0] | ${Rules} |
    ${tupleResponse xml}=    Get Element Xml    ${Response Body}    ${XMLNS RESPONSE BATCH}    tupleResponse
    Check Xml Element Values Contain Sublist    Checks rule matched    ${tupleResponse xml}    ${Rules}    ruleMatchedId    ${XMLNS RESPONSE TUPLE}

Rules Should Not Be Matched
    [Arguments]    ${batchOperationResponse xml}    ${Rules}
    [Documentation]    Checks that a supplied list of rules are not indicated as matched in the response body of a tuple operation.
    ...
    ...    *Arguments*
    ...
    ...    ${batchOperationResponse xml}= The batchOperationResponse element to check.
    ...    ${Rules} = List of rule names to check are not present as values for the ruleMatchId elements.
    ...
    ...    *Example*
    ...
    ...    | Create Batch Operation XML|
    ...
    ...    |@{Operation Response Body}= | Batch Request | +1 | 2 | ${Operation Create} |
    ...    | ${Rules}= | Create List |
    ...    | Rules Should Not Be Matched | @{Operation Response Body}[0] | ${Rules} |
    ${tupleResponse xml}=    Get Element Xml    ${batchOperationResponse xml}    ${XMLNS RESPONSE BATCH}    tupleResponse
    Check Xml Element Values Do Not Contain Sublist    Checks the ruleMatchId elements within the tupleResponse do not contain the supplied values.    ${tupleResponse xml}    ${Rules}    ruleMatchedId    ${XMLNS RESPONSE TUPLE}

Get Entity Entity ID, Term ID and Tuple ID
    [Arguments]    ${Entity Name}
    [Documentation]    Obtains the entity ID, term ID and tuple ID of an entity in EWB hierarchy from the database.
    ...
    ...    *Arguments*
    ...
    ...    -${Entity Name} = Name of the entity to obtain the entity ID, term ID and tuple ID of.
    ...
    ...    *Return Value*
    ...
    ...    -${entity id} = entity ID of the entity
    ...    -${entity Term ID} = term ID of the entity
    ...    -${entity Tuple ID} = tuple ID of the entity
    Connect To Database    ${CORE_USERNAME}    ${CORE_USERNAME}    //${DB_SERVER}/${ORACLE_SID}
    @{entity id results list}=    Query    select ENTITY_NAME, ENTITY_ID from ENTITIES where ENTITY_NAME = '${Entity Name}'
    Disconnect From Database
    ${entity id}=    Set Variable    ${entity id results list[0][1]}
    Connect To Database    ${POOL_USERNAME}    ${POOL_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    Call Database Procedure    set_session_ctx    ${SERVICES USERNAME}
    @{entity query results list}=    Query    select TERM_ID, TUPLE_ID from ${FHR_HUB_USERNAME}.Q_CTPV_FLEX_HIER_REF where entity_id = '${entity id}'
    Disconnect From Database
    ${entity Term ID}=    Set Variable    ${entity query results list[0][0]}
    ${entity Tuple ID}=    Set Variable    ${entity query results list[0][1]}
    [Return]    ${entity id}    ${entity Term ID}    ${entity Tuple ID}

Batch Update Operation XML tupleEchoPolicy Record Locking
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${tupleEchoPolicy}    ${locking optimistic}    @{Properties}
    [Documentation]    Creates the request body xml string for a single creation operation within a batch when the tupleEchoPolicy and record locking parameter is specified in the request body.
    ...
    ...    *Arguments*
    ...    - ${Term ID} = Term ID of the term to create a tuple for
    ...    - ${Key Property Value}= Value of the key property of the tuple to be created
    ...    - ${Tuple ID} = ID of the tuple to be create
    ...    - ${tupleEchoPolicy} = Value of the tupleEchoPolicy.
    ...    -${locking.optimistic} = Value of the record locking paramater
    ...    - @{Properties} = (OPTIONAL) The Property element XML segments. Must be supplied by either the Batch Set Property Element (Non-Linked) or Batch Set Property Element (Linked) keyword depending on the property type. Can be either a single argument/list argument or multiple arguments.
    ...
    ...    *Return Value*
    ...    - ${batch create request xml} = batchOperationRequest xml string for a single update operation including the tupleEchoPolicy and record locking parameters.
    ...
    ...    *Example*
    ...
    ...    Update a tuple for a term including setting the value of two properties within a batch operation and specifying the tupleEchoPolicy as CREATE and the record locking parameter as true.
    ...
    ...    | ${Property XML 1}= | Batch Set Property Element (Non-Linked) | Property 1 | ${propertytermid} | ${property id} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Batch Set Property Element (Linked) | Linked Property 1 | ${propertytermid} | ${propertyid} | ${linkedTupleId} | ${linkedTermId} |
    ...    | ${Operation 1 XML} = | Batch Update Operation XML tupleEchoPolicy Record Locking | ${Term ID} | Key Property Value 1 | ${Tuple ID} | CREATE | true | ${Property XML 1} | ${Property XML 2} |
    ...    | Batch Request | +0 | 2 | Operation 1=${Operation 1} |
    ${Client Batch Operation ID}=    Create Batch Operation ID
    ${batchOperationRequest}=    Create Xml Object    batchOperationRequest    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${batchOperationRequest}=    Set Element Attribute    ${batchOperationRequest}    {http://www.w3.org/2001/XMLSchema-instance}type    TupleOperationRequest    ${BATCH XMLNS REQUEST BATCH}
    ${type}=    Create Xml Object    type    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=UPDATE
    ${clientBatchOperationId}=    Create Xml Object    clientBatchOperationId    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Batch Operation ID}
    ${tupleEchoPolicy}=    Create Xml Object    tupleEchoPolicy    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${tupleEchoPolicy}
    ${tupleSpecifier}=    Create Xml Object    tupleSpecifier
    ${termId}=    Create Xml Object    termId    elementText=${Term ID}
    ${keyPropertyValue}=    Create Xml Object    keyPropertyValue    elementText=${Key Property Value}
    ${tupleId}=    Create Xml Object    tupleId    elementText=${Tuple ID}
    ${clientParameters}=    Create Xml Object    clientParameters    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${clientParameter}=    Create Xml Object    clientParameter    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${clientParameter key}=    Create Xml Object    key    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=locking.optimistic
    ${clientParameter value}=    Create Xml Object    value    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${locking optimistic}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${tupleSpecifier}    ${termId}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${keyPropertyValue}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${tupleId}
    ${create request xml clientParameter}=    Add Subelement To Xml    ${clientParameter}    ${clientParameter key}
    ${create request xml clientParameter}=    Add Subelement To Xml    ${create request xml clientParameter}    ${clientParameter value}
    ${create Request xml clientParameters}=    Add Subelement To Xml    ${clientParameters}    ${create request xml clientParameter}
    ${create request xml propertySequence}=    Create Xml Object    propertySequence
    ${create request xml propertySequence}=    Add List Of Subelements To Xml    ${create request xml propertySequence}    ${Properties}
    ${tuple}=    Create Xml Object    tuple    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${create request xml tuple}=    Add Subelement To Xml    ${tuple}    ${create request xml tupleSpecifier}
    ${create request xml tuple}=    Add Subelement To Xml    ${create request xml tuple}    ${create request xml propertySequence}
    ${batch update request xml}=    Add Subelement To Xml    ${batchOperationRequest}    ${type}
    ${batch update request xml}=    Add Subelement To Xml    ${batch update request xml}    ${clientBatchOperationId}
    ${batch update request xml}=    Add Subelement To Xml    ${batch update request xml}    ${create Request xml clientParameters}
    ${batch update request xml}=    Add Subelement To Xml    ${batch update request xml}    ${tuple}
    ${batch update request xml}=    Add Subelement To Xml    ${batch update request xml}    ${tupleEchoPolicy}
    Comment    ${request body}=    Get Xml    ${batch update operation xml}
    Comment    Log    ${request body}
    [Return]    ${batch update request xml}

Batch Update Operation XML tupleExistsPolicy and tupleEchoPolicy Record Locking
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${tupleExistsPolicy}    ${tupleEchoPolicy}    ${locking optimistic}
    ...    @{Properties}
    [Documentation]    Creates the request body xml string for a single update operation within a batch when the tupleExistsPolicy,tupleEchoPolicy and record locking parameter is specified in the request body.
    ...
    ...    *Arguments*
    ...    - ${Term ID} = Term ID of the term of the tuple specified for update
    ...    - ${Key Property Value}= Value of the key property of the tuple specified for update
    ...    - ${Tuple ID} = ID of the tuple specified for update
    ...    - ${tupleExistsPolicy} = Value of the tupleExistsPolicy.
    ...    - ${tupleEchoPolicy} = Value of the tupleEchoPolicy.
    ...    -${locking.optimistic} = Value of the record locking paramater
    ...    - @{Properties} = (OPTIONAL) The Property element XML segments. Must be supplied by either the Batch Set Property Element (Non-Linked) or Batch Set Property Element (Linked) keyword depending on the property type. Can be either a single argument/list argument or multiple arguments.
    ...
    ...    *Return Value*
    ...    - ${batch update request xml} = batchOperationRequest xml string for a single update operation including the tupleExistsPolicy, tupleEchoPolicy and record locking parameters.
    ...
    ...    *Example*
    ...
    ...    Update a tuple for a term including setting the value of two properties within a batch operation and specifying the tupleExistsPolicy as UPSERT, the tupleEchoPolicy as CREATE and the record locking parameter as true.
    ...
    ...    | ${Property XML 1}= | Batch Set Property Element (Non-Linked) | Property 1 | ${propertytermid} | ${property id} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Batch Set Property Element (Linked) | Linked Property 1 | ${propertytermid} | ${propertyid} | ${linkedTupleId} | ${linkedTermId} |
    ...    | ${Operation 1 XML} = |Batch Update Operation XML tupleExistsPolicy and tupleEchoPolicy Record Locking | ${Term ID} | Key Property Value 1 | ${Tuple ID} | UPSERT| CREATE | true | ${Property XML 1} | ${Property XML 2} |
    ...    | Batch Request | +0 | 2 | Operation 1=${Operation 1} |
    ${Client Batch Operation ID}    Create Batch Operation ID
    ${batchOperationRequest}=    Create Xml Object    batchOperationRequest    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${batchOperationRequest}=    Set Element Attribute    ${batchOperationRequest}    {http://www.w3.org/2001/XMLSchema-instance}type    TupleOperationRequest    ${BATCH XMLNS REQUEST BATCH}
    ${type}=    Create Xml Object    type    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=UPDATE
    ${clientBatchOperationId}=    Create Xml Object    clientBatchOperationId    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Batch Operation ID}
    ${tupleExistsPolicy}=    Create Xml Object    tupleExistsPolicy    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${tupleExistsPolicy}
    ${tupleEchoPolicy}=    Create Xml Object    tupleEchoPolicy    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${tupleEchoPolicy}
    ${tupleSpecifier}=    Create Xml Object    tupleSpecifier
    ${termId}=    Create Xml Object    termId    elementText=${Term ID}
    ${keyPropertyValue}=    Create Xml Object    keyPropertyValue    elementText=${Key Property Value}
    ${tupleId}=    Create Xml Object    tupleId    elementText=${Tuple ID}
    ${clientParameters}=    Create Xml Object    clientParameters    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${clientParameter}=    Create Xml Object    clientParameter    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${clientParameter key}=    Create Xml Object    key    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=locking.optimistic
    ${clientParameter value}=    Create Xml Object    value    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${locking optimistic}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${tupleSpecifier}    ${termId}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${keyPropertyValue}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${tupleId}
    ${create request xml clientParameter}=    Add Subelement To Xml    ${clientParameter}    ${clientParameter key}
    ${create request xml clientParameter}=    Add Subelement To Xml    ${create request xml clientParameter}    ${clientParameter value}
    ${create Request xml clientParameters}=    Add Subelement To Xml    ${clientParameters}    ${create request xml clientParameter}
    ${create request xml propertySequence}=    Create Xml Object    propertySequence
    ${create request xml propertySequence}=    Add List Of Subelements To Xml    ${create request xml propertySequence}    ${Properties}
    ${tuple}=    Create Xml Object    tuple    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${create request xml tuple}=    Add Subelement To Xml    ${tuple}    ${create request xml tupleSpecifier}
    ${create request xml tuple}=    Add Subelement To Xml    ${create request xml tuple}    ${create request xml propertySequence}
    ${batch update request xml}=    Add Subelement To Xml    ${batchOperationRequest}    ${type}
    ${batch update request xml}=    Add Subelement To Xml    ${batch update request xml}    ${clientBatchOperationId}
    ${batch update request xml}=    Add Subelement To Xml    ${batch update request xml}    ${create Request xml clientParameters}
    ${batch update request xml}=    Add Subelement To Xml    ${batch update request xml}    ${tuple}
    ${batch update request xml}=    Add Subelement To Xml    ${batch update request xml}    ${tupleExistsPolicy}
    ${batch update request xml}=    Add Subelement To Xml    ${batch update request xml}    ${tupleEchoPolicy}
    ${request body}=    Get Xml    ${batch update request xml}
    Log    ${request body}
    [Return]    ${batch update request xml}

Batch Create Operation tupleExistsPolicy Record Locking
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${tupleExistsPolicy}    ${locking optimistic}    @{Properties}
    [Documentation]    Creates the request body xml string for a single creation operation within a batch when the tupleExistsPolicy and record locking parameter is specified in the request body.
    ...
    ...    *Arguments*
    ...    - ${Term ID} = Term ID of the term to create a tuple for
    ...    - ${Key Property Value}= Value of the key property of the tuple to be created
    ...    - ${Tuple ID} = ID of the tuple to be create
    ...    - ${tupleExistsPolicy} = Value of the tupleExistsPolicy.
    ...    -${locking.optimistic} = Value of the record locking paramater
    ...    - @{Properties} = (OPTIONAL) The Property element XML segments. Must be supplied by either the Batch Set Property Element (Non-Linked) or Batch Set Property Element (Linked) keyword depending on the property type. Can be either a single argument/list argument or multiple arguments.
    ...
    ...    *Return Value*
    ...    - ${batch create request xml} = batchOperationRequest xml string for a single create operation including the tupleExistsPolicy and record locking parameters.
    ...
    ...    *Example*
    ...
    ...    Create a tuple for a term including setting the value of two properties within a batch operation and specifying the tupleExistsPolicy as UPSERT and the record locking parameter as true.
    ...
    ...    | ${Property XML 1}= | Batch Set Property Element (Non-Linked) | Property 1 | ${propertytermid} | ${property id} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Batch Set Property Element (Linked) | Linked Property 1 | ${propertytermid} | ${propertyid} | ${linkedTupleId} | ${linkedTermId} |
    ...    | ${Operation 1 XML} = | Batch Create Operation tupleExistsPolicy Record Locking | ${Term ID} | Key Property Value 1 | ${Tuple ID} | UPSERT | true | ${Property XML 1} | ${Property XML 2} |
    ...    | Batch Request | +1 | 2 | Operation 1=${Operation 1} |
    ${Client Batch Operation ID}=    Create Batch Operation ID
    ${batchOperationRequest}=    Create Xml Object    batchOperationRequest    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${batchOperationRequest}=    Set Element Attribute    ${batchOperationRequest}    {http://www.w3.org/2001/XMLSchema-instance}type    TupleOperationRequest    ${BATCH XMLNS REQUEST BATCH}
    ${type}=    Create Xml Object    type    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=CREATE
    ${clientBatchOperationId}=    Create Xml Object    clientBatchOperationId    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Batch Operation ID}
    ${tupleExistsPolicy}=    Create Xml Object    tupleExistsPolicy    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${tupleExistsPolicy}
    ${tupleSpecifier}=    Create Xml Object    tupleSpecifier
    ${termId}=    Create Xml Object    termId    elementText=${Term ID}
    ${keyPropertyValue}=    Create Xml Object    keyPropertyValue    elementText=${Key Property Value}
    ${tupleId}=    Create Xml Object    tupleId    elementText=${Tuple ID}
    ${clientParameters}=    Create Xml Object    clientParameters    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${clientParameter}=    Create Xml Object    clientParameter    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${clientParameter key}=    Create Xml Object    key    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=locking.optimistic
    ${clientParameter value}=    Create Xml Object    value    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${locking optimistic}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${tupleSpecifier}    ${termId}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${keyPropertyValue}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${tupleId}
    ${create request xml clientParameter}=    Add Subelement To Xml    ${clientParameter}    ${clientParameter key}
    ${create request xml clientParameter}=    Add Subelement To Xml    ${create request xml clientParameter}    ${clientParameter value}
    ${create Request xml clientParameters}=    Add Subelement To Xml    ${clientParameters}    ${create request xml clientParameter}
    ${create request xml propertySequence}=    Create Xml Object    propertySequence
    ${create request xml propertySequence}=    Add List Of Subelements To Xml    ${create request xml propertySequence}    ${Properties}
    ${tuple}=    Create Xml Object    tuple    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${create request xml tuple}=    Add Subelement To Xml    ${tuple}    ${create request xml tupleSpecifier}
    ${create request xml tuple}=    Add Subelement To Xml    ${create request xml tuple}    ${create request xml propertySequence}
    ${batch create request xml}=    Add Subelement To Xml    ${batchOperationRequest}    ${type}
    ${batch create request xml}=    Add Subelement To Xml    ${batch create request xml}    ${clientBatchOperationId}
    ${batch create request xml}=    Add Subelement To Xml    ${batch create request xml}    ${create Request xml clientParameters}
    ${batch create request xml}=    Add Subelement To Xml    ${batch create request xml}    ${tuple}
    ${batch create request xml}=    Add Subelement To Xml    ${batch create request xml}    ${tupleExistsPolicy}
    ${request body}=    Get Xml    ${batch create request xml}
    Log    ${request body}
    [Return]    ${batch create request xml}

Batch Create Operation XML Record Locking
    [Arguments]    ${Term ID}    ${Key Property Value}    ${Tuple ID}    ${locking.optimistic}    @{Properties}
    [Documentation]    Creates the request body xml string for a single creation operation within a batch when the record locking parameter is specified in the request body.
    ...
    ...    *Arguments*
    ...    - ${Term ID} = Term ID of the term to create a tuple for
    ...    - ${Key Property Value}= Value of the key property of the tuple to be created
    ...    - ${Tuple ID} = ID of the tuple to be create
    ...    -${locking.optimistic} = Value of the record locking paramater
    ...    - @{Properties} = (OPTIONAL) The Property element XML segments. Must be supplied by either the Batch Set Property Element (Non-Linked) or Batch Set Property Element (Linked) keyword depending on the property type. Can be either a single argument/list argument or multiple arguments.
    ...
    ...    *Return Value*
    ...    - ${batch create request xml} = batchOperationRequest xml string for a single create operation including the record locking parameter.
    ...
    ...    *Example*
    ...
    ...    Create a tuple for a term including setting the value of two properties within a batch operation and specifying the record locking parameter as true.
    ...
    ...    | ${Property XML 1}= | Batch Set Property Element (Non-Linked) | Property 1 | ${propertytermid} | ${property id} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Batch Set Property Element (Linked) | Linked Property 1 | ${propertytermid} | ${propertyid} | ${linkedTupleId} | ${linkedTermId} |
    ...    | ${Operation 1 XML} = | Batch Create Operation XML Record Locking | ${Term ID} | Key Property Value 1 | ${Tuple ID} | true | ${Property XML 1} | ${Property XML 2} |
    ...    | Batch Request | +1 | 2 | Operation 1=${Operation 1} |
    ${Client Batch Operation ID Value}=    Create Batch Operation ID
    ${batchOperationRequest}=    Create Xml Object    batchOperationRequest    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${batchOperationRequest}=    Set Element Attribute    ${batchOperationRequest}    {http://www.w3.org/2001/XMLSchema-instance}type    TupleOperationRequest    ${BATCH XMLNS REQUEST BATCH}
    ${type}=    Create Xml Object    type    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=CREATE
    ${clientBatchOperationId}=    Create Xml Object    clientBatchOperationId    elementNamespace=${BATCH XMLNS REQUEST BATCH}    elementText=${Client Batch Operation ID Value}
    ${tupleSpecifier}=    Create Xml Object    tupleSpecifier
    ${termId}=    Create Xml Object    termId    elementText=${Term ID}
    ${keyPropertyValue}=    Create Xml Object    keyPropertyValue    elementText=${Key Property Value}
    ${tupleId}=    Create Xml Object    tupleId    elementText=${Tuple ID}
    ${clientParameters}=    Create Xml Object    clientParameters    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${clientParameter}=    Create Xml Object    clientParameter
    ${clientParameter key}=    Create Xml Object    key    elementText=locking.optimistic
    ${clientParameter value}=    Create Xml Object    value    elementText=${locking.optimistic}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${tupleSpecifier}    ${termId}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${keyPropertyValue}
    ${create request xml tupleSpecifier}=    Add Subelement To Xml    ${create request xml tupleSpecifier}    ${tupleId}
    ${create request xml clientParameter}=    Add Subelement To Xml    ${clientParameter}    ${clientParameter key}
    ${create request xml clientParameter}=    Add Subelement To Xml    ${create request xml clientParameter}    ${clientParameter value}
    ${create Request xml clientParameters}=    Add Subelement To Xml    ${clientParameters}    ${create request xml clientParameter}
    ${create request xml propertySequence}=    Create Xml Object    propertySequence
    ${create request xml propertySequence}=    Add List Of Subelements To Xml    ${create request xml propertySequence}    ${Properties}
    ${tuple}=    Create Xml Object    tuple    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${create request xml tuple}=    Add Subelement To Xml    ${tuple}    ${create request xml tupleSpecifier}
    ${create request xml tuple}=    Add Subelement To Xml    ${create request xml tuple}    ${create request xml propertySequence}
    ${batch create request xml}=    Add Subelement To Xml    ${batchOperationRequest}    ${type}
    ${batch create request xml}=    Add Subelement To Xml    ${batch create request xml}    ${clientBatchOperationId}
    ${batch create request xml}=    Add Subelement To Xml    ${batch create request xml}    ${create Request xml clientParameters}
    ${batch create request xml}=    Add Subelement To Xml    ${batch create request xml}    ${tuple}
    [Return]    ${batch create request xml}

Get lockTimestamp Value
    [Arguments]    ${Retrieve Response Body}
    [Documentation]    Obtains the value of the lockTimestamp value property utilised by record locking functionality from the response body of a retrieval operation.
    ...
    ...    *Arguments*
    ...
    ...    -${Retrieve Response Body} = Response body returned by a retrieval operation that contains the lockTimestamp value.
    ...
    ...    *Return Value*
    ...
    ...    -${lockTimestampValue}= Value of the lockTimestamp property in the response body of the retrieval operation.
    @{Operation Response Body 2}=    Get Element Xml From Child Value    ${Retrieve Response Body}    ${XMLNS RESPONSE TUPLE}    property    ${XMLNS4}    name
    ...    lockTimestamp
    Check Xml Element Value Is Not Empty    Checks the Lock With Timestamp property has a value.    @{Operation Response Body 2}    value    ${XMLNS RESPONSE TUPLE}
    @{lockTimestampValue}=    Get Element Value    @{Operation Response Body 2}    ${XMLNS RESPONSE TUPLE}    value
    ${lockTimestampValue}=    Set Variable    @{lockTimestampValue}[0]
    [Return]    ${lockTimestampValue}

Get Hub Detail from DB
    [Arguments]    ${hubName}    ${hubDetail}
    [Documentation]    Returns the Hub prefix of the specified hub
    ...
    ...    *Arguments*
    ...
    ...    Use : description
    ...    - ASSET : Asset Hub to store Assets
    ...
    ...    - LSCAPE : Landscape Hub
    ...
    ...    - CATALOG : Catalogue Hub
    ...
    ...    - FHR: Flexible Hierarchy Reference Hub
    ...
    ...    *Returns*
    ...
    ...    - ${hubPrefix}
    ...
    ...    *Notes*
    ...
    ...    select * from IDBS_LSCAPE_HUB.Q_HUB_INSTALLATIONS \ where HUB_TYPE = '${hubName}'
    ...
    ...    is run as an SQL query against the database details set up in the common_resource.txt
    # Hub ID from Database
    Connect To Database    ${POOL_USERNAME}    ${POOL_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    ${queryResults}=    Query    select ${hubDetail} from ${DB_PREFIX}_LSCAPE_HUB.Q_HUB_INSTALLATIONS where HUB_TYPE ='${hubName}'
    ${hubDet}=    Set Variable    ${queryResults[0][0]}
    log    ${hubDet}
    Disconnect From Database
    [Return]    ${hubDet}

Get Lscape Hub ID
    [Documentation]    Connects to the Database and sets the Global Variable: ${LSCAPE_HUB_ID} with the Landscape Hub ID
    ${queryResults}    Get Hub Detail from DB    LSCAPE    HUB_GUID
    Set Global Variable    ${LSCAPE_HUB_ID}    ${queryResults}

Get Asset Hub ID
    [Documentation]    Connects to the Database and sets the Global Variable: ${ASSET_HUB_ID} with the Asset Hub ID
    ...
    ...    Should only be used if the HUB_ID is not being configured for the Run
    ${queryResults}    Get Hub Detail from DB    ASSET    HUB_GUID
    Set Global Variable    ${ASSET_HUB_ID}    ${queryResults}

Get Asset DB Prefix
    [Documentation]    Connects to the Database and sets the Global Variable: ${ASSET_DB_PREFIX} with the Asset Hub ID
    ...
    ...    Should only be used if the HUB_ID is not being configured for the Run
    ${queryResults}    Get Hub Detail from DB    ASSET    HUB_PREFIX
    Set Global Variable    ${ASSET_DB_PREFIX}    ${queryResults}

Get asset hub Tuple guid
    [Arguments]    ${solutions or Core?}    ${Catalog}    ${target term}    ${Identifier}
    [Documentation]    Reference test to produce a list of things for a tuple in the hub.
    ...
    ...    *Arguments*
    ...
    ...
    ...    This is basically the catalog term path broken down.('IDBS-Aplications/Solutions/Baking/Ingredient' )
    ...
    ...    Solutions or Core? - string
    ...
    ...    Catalog - string
    ...
    ...    Target term - string
    ...
    ...
    ...    Identifier = this is the key property value of the tuple you are looking for
    ...
    ...
    ...    *Return Values*
    ...
    ...    TermGuid - string
    ...    Tuple Guid - string
    ...
    ...
    ...
    ...    *Precondition*
    ...
    ...
    ...    none
    ...
    ...
    ...
    ...    *Example*
    ...
    ...    Gets the tuple GUID for milk in the term 'IDBS-Aplications/Solutions/Baking/Ingredient'
    ...
    ...    |Get asset hub Tuple guid | Solutions | Baking |Ingredient|milk|
    @{Query1}=    Execute Data Query and Get Results    SELECT TERM_GUID, KEY_PROP_VAL, TUPLE_GUID FROM "/IDBS-Applications/${Solutions or Core?}/${Catalog}/${Target Term}" WHERE KEY_PROP_VAL = '${Identifier}'
    ${TermGuid}=    Set Variable    ${Query1[0][0]}
    ${TupleGUID}=    Set Variable    ${Query1[0][2]}
    [Return]    ${TermGuid}    ${TupleGUID}

Batch Request and Validate
    [Arguments]    @{Operations}
    [Documentation]    *Undertakes a batch request and expects an error to occur.*
    ...
    ...    *Request carried out with a default description and the isTestOnly and isAsTransaction values set to false. If these values need to be changed, use "Batch Request and Expect Error With Non-Default Parameters"*
    ...
    ...    *Update example to include exprected no of response bodies setting and talk about validation in description. Also need to sort return value out*
    ...
    ...    *Arguments*
    ...    - ${Expected Change in Tuple Count} = Change in tuple count expected following the batch operation
    ...    - ${Batch Request Description} = (DEFAULT SET) A description for the operation supplied by the user.
    ...    - ${isTestOnly Setting} = (DEFAULT SET)
    ...    - ${isAsTransaction} = (DEFAULT SET)
    ...    - @{Operations} = (OPTIONAL) - List of individual tuple requests to be undertaken by the batch. These are defined using the releavnt keyword for determining the XML of the operation. - optional
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    Undertake a create, update, retrieve and delete operation within a single batch operation:
    ...
    ...    | ${Property Create XML 1} = | Batch Set Property Element (Non-Linked) | Property 1 | 78538a20baa011e1aabf0025649342bb | 6507cfd0baa011e1aabf0025649342bb | Property 1 Value 3 | mm |
    ...    | ${PropertyCreate XML 2}= |Batch Set Property Element (Linked) | Linked Property | 78538a20baa011e1aabf0025649342bb | 6707cfd0baa011e1aabf0025649342bb | 6004aaf2ae6b4fd7ab7cbf1e0bf343a2 | cca4d420bb6911e18e260025649342bb |
    ...    | ${Operation 1 XML} = | Batch Create Operation XML | \ 78538a20baa011e1aabf0025649342bb | Key Property Value 3 | 41853c2559f34ae6bde49306295369a6 | Property XML 1=${Property Create XML 1} | Property XML 2=${Property Create XML 2} |
    ...    | ${Property Update XML 1}= | Batch Set Property Element (Non-Linked) | Property 1 | 78538a20baa011e1aabf0025649342bb | 6507cfd0baa011e1aabf0025649342bb | Property 1 Value 2 Update |
    ...    | ${Operation 2 XML}= | Batch Update Operation XML | 78538a20baa011e1aabf0025649342bb | Key Property Value 2 | 9a163049c1bc416eb9ccd67b08a11faf | 111e57594c0f57b3bc3583eabaaf2cce |${Property Update XML 1} |
    ...    | ${Operation 3 XML}= | Batch Retrieve Operation XML | 78538a20baa011e1aabf0025649342bb | * | * |
    ...    | ${Operation 4 XML}= | Batch Delete Operation XML | 78538a20baa011e1aabf0025649342bb | Key Property Value 1 | e234564c0c0a499c9644c81928bc9dba | +0 | *** | a description | true | true | ${Operation 1 XML} | ${Operation 2 XML} | ${Operation 3 XML} | ${Operation 4 XML} |
    ${tuple count}=    Get Number of Tuples
    ${tuple count expected}=    Evaluate    ${tuple count}+1
    Tuple Web Services Request Setup
    ${request}=    Create Xml Object    hubTechRequest
    Set Element Attribute    ${request}    xmlns    ${XMLNS REQUEST HUBTECH}
    ${description}=    Create Xml Object    description    elementNamespace=${BATCH XMLNS REQUEST SERVICES}    elementText=A batch request that is not expected to fail.
    ${batch}=    Create Xml Object    batch    elementNamespace=${BATCH XMLNS REQUEST SERVICES}
    ${batch operation requests set}=    Create Xml Object    batchOperationRequests    elementNamespace=${BATCH XMLNS REQUEST BATCH}
    ${batch operation requests set}=    Add List Of Subelements To Xml    ${batch operation requests set}    @{Operations}
    ${batch request set}=    Add Subelement To Xml    ${batch}    ${batch operation requests set}
    ${batch request xml}=    Add Subelement To Xml    ${request}    ${description}
    ${batch request xml}=    Add Subelement To Xml    ${batch request xml}    ${batch request set}
    ${batch request xml}=    Get Xml    ${batch request xml}
    Log    ${batch request xml}
    Set Request Body    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>${batch request xml}
    POST    ${BATCH END}
    ${Error Response Body}=    Get Response Body
    Log    ${Error Response Body}
    Validate Number of Tuples    ${tuple count expected}
    Should Contain    ${Error Response Body}    Request Completed OK    Response body should have contained "Request Completed OK".
    [Return]    ${Error Response Body}

SET TUPLE WS
    [Documentation]    This keyword is a set up step for the Tuple Services Suites
    ...
    ...    It runs a search to get asset db prefix
    ...
    ...    Theh tuple is then deleted
    ...
    ...    *Arguments*
    ...
    ...    There are no arguments for this keyword
    ...
    ...    *Output*
    ...
    ...    The keyword outputs the following SUITE variables:
    ...
    ...    - ${ASSET_DB_PREFIX}
    ...
    ...    This is not returned
    Get Asset DB Prefix
    Get Asset Hub ID

Batch Request With Non-Default Parameters No Count
    [Arguments]    ${Expected No Operation Responses}    ${Batch Request Description}    @{Operations}
    [Documentation]    Undertakes a batch request operation including specification of a description.
    ...
    ...
    ...    *Arguments*
    ...    - ${Expected No Operation Responses} = The expected number of operation responses returned by the server
    ...    - ${Batch Request Description} = User defined description for the batch operation.
    ...    - @{Operations} = (OPTIONAL) - List of individual tuple requests to be undertaken by the batch. These are defined using the releavnt keyword for determining the XML of the operation. - optional
    ...
    ...    *Return Value*
    ...    - @{Operation Response Body} = The batchOperationResponse xml element of the response body.
    ...
    ...    *Example*
    ...
    ...    | ${Property XML 1}= | Batch Set Property Element (Non-Linked) | Property 1 | ${propertytermid} | ${propertyid} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Batch Set Property Element (Linked) | Linked Property 1 | ${propertytermid | ${propertyid} | ${linkTupleId} | ${linkTermId |
    ...    | ${Operation 1 XML} = | Batch Create Operation XML | ${Term ID} | Key Property Value 1 | ${Tuple ID} | ${Property XML 1} | ${Property XML 2} |
    ...    | Batch Request | \ 2 | A description for the batch operation | ${Operation 1} |
    #Perform Batch Request
    ${Response Body}=    Execute Batch Request With Non-Default Parameters    ${Batch Request Description}    @{Operations}
    #Validate general response body
    @{Operation Response Body}=    General Response Body    ${Response Body}    ${Expected No Operation Responses}
    [Return]    @{Operation Response Body}

Batch Request No Count
    [Arguments]    ${Expected No Operation Responses}    @{Operations}
    [Documentation]    Undertakes a batch request operation.
    ...
    ...
    ...    *Arguments*
    ...    - ${Expected No Operation Responses} = The expected number of operation responses returned by the server
    ...    - @{Operations} = (OPTIONAL) - List of individual tuple requests to be undertaken by the batch. These are defined using the releavnt keyword for determining the XML of the operation. - optional
    ...
    ...    *Return Value*
    ...    - @{Operation Response Body} = The batchOperationResponse xml element of the response body.
    ...
    ...    *Example*
    ...
    ...    | ${Property XML 1}= | Batch Set Property Element (Non-Linked) | Property 1 | ${propertytermid} | ${propertyid} | Property 1 Value 1 |
    ...    | ${Property XML 2}= | Batch Set Property Element (Linked) | Linked Property 1 | ${propertytermid | ${propertyid} | ${linkTupleId} | ${linkTermId |
    ...    | ${Operation 1 XML} = | Batch Create Operation XML | ${Term ID} | Key Property Value 1 | ${Tuple ID} | ${Property XML 1} | ${Property XML 2} |
    ...    | Batch Request | 2 | ${Operation 1} |
    @{Operation Response Body}=    Batch Request With Non-Default Parameters No Count    ${Expected No Operation Responses}    ${EMPTY}    @{Operations}
    [Return]    @{Operation Response Body}
