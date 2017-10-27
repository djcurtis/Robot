*** Settings ***
Documentation     This resource file is for testing the audit query service API.
...
...               This resource file contains keywords that allow the user to query the audit web service API. Results can be filtered, sorted and managed to allow the testing of data returned from an audit query.
Library           IDBSHttpLibrary
Library           String
Library           XMLLibrary
Library           Collections
Library           IDBSCollectionsLibrary
Resource          ../../../Common/common_resource.robot    # Common Resource Library

*** Variables ***
${REST URL END}    /landscape/services/1.0/data/auditing/search
${ADVANCED MISSING}    WARNING: There is no Advanced Audit Results for this query. If you specified 'BASIC_AND_ADVANCED' in the parameters, results are not being returned
${DEFAULT REASON}    UnspecifiedClientReasonForChange
${CATALOG PATH}    ${CURDIR}/../../../Test Data/Hubtech/Asset Hub/Audit Web Service/Audit Web Services.xml
${BAD PARAMETER}    Gibberish
${AA TERM PATH}    /Audit Web Services/Aggregate Asset
${AA KEY PROP}    AA Key    # Aggregate Asset Key Property
${AA GEN PROP}    AA Property    # Aggregate Asset General Property
${AA KEY TEXT}    AA Audit Key
${AA GEN TEXT}    AA Audit General
${A TERM PATH}    /Audit Web Services/Asset
${A KEY PROP}     A Key    # Asset Key Property
${A GEN PROP}     A Property    # Asset General Property
${C TERM PATH}    /Audit Web Services/Container
${C KEY PROP}     C Key    # Container Key Property
${C GEN PROP}     C Property    # Container General Property
${CT TERM PATH}    /Audit Web Services/Container Type
${CT KEY PROP}    CT Key    # Container Type Key Property
${CT GEN PROP}    CT Property    # Container Type General Property
${QA TERM PATH}    /Audit Web Services/Quantified Asset
${QA KEY PROP}    QA Key    # Quantified Asset Key Property
${QA GEN PROP}    QA Property    # Quantified Asset General Property
${A KEY TEXT}     A Audit Key
${A GEN TEXT}     A Audit General
${C KEY TEXT}     C Audit Key
${C GEN TEXT}     C Audit General
${CT KEY TEXT}    CT Audit Key
${CT GEN TEXT}    CT Audit General
${QA KEY TEXT}    QA Audit Key
${QA GEN TEXT}    QA Audit General

*** Keywords ***
SET Bad Parameters
    [Documentation]    This keyword is a set up step for the ASS-NEL-PI002 - Bad Parameters Suite
    ...
    ...    It pulls term and property IDs from the catalogue via the txt file
    ...
    ...    It uses the property and term IDs to save and delete a tuple against the hub
    ...
    ...    It gets the Audit ID and transaction ID for the audit logs created when saving and delting the tuple
    ...
    ...    *Arguments*
    ...
    ...    There are no arguments for this keyword
    ...
    ...    *Output*
    ...
    ...    The keyword outputs the following SUITE variables:
    ...
    ...    - ${TERM ID}
    ...    - ${KEY PROPERTY ID}
    ...    - ${GUID1}
    ...    - ${AUDIT ID BP}
    ...    - ${Date BP}
    ...    - ${Response Date BP}
    ...    - ${TRAN ID BP}
    ...
    ...    These are not returned as arguments
    # Set Term ID
    ${term_id}=    Get Catalog Term Id From Catalog Export    ${CATALOG PATH}    ${C TERM PATH}
    Set Suite Variable    ${TERM ID}    ${term_id}
    # Set Key Property ID
    ${key_id}=    Get Catalog Term Property Id From Catalog Export    ${CATALOG PATH}    ${C TERM PATH}    ${C KEY PROP}
    Set Suite Variable    ${KEY PROPERTY ID}    ${key_id}
    # Set Tuple IDs
    ${GUID A}=    Create Hex GUID
    Set Suite Variable    ${GUID 01}    ${GUID A}
    # Create
    ${Property XML 1}=    Batch Set Property Element (Non-Linked)    ${C KEY PROP}    ${TERM ID}    ${KEY PROPERTY ID}    ${C KEY TEXT}
    ${Operation 1}=    Batch Create Operation XML    ${TERM ID}    ${C KEY TEXT}    ${GUID 01}    ${Property XML 1}
    @{Operation Response Body}=    Batch Request    +1    2    ${Operation 1}
    # Delete
    ${Operation 2}=    Batch Delete Operation XML    ${TERM ID}    ${C KEY TEXT}    ${GUID 01}
    @{Operation Response Body 2}=    Batch Request    -1    1    ${Operation 2}
    # Set Transaction ID and Audit ID Variables
    Get Audit ID from DB    BP    ${GUID 01}    CREATE    ${TERM ID}
    Get Transaction ID    BP    0    @{Operation Response Body 2}

SET CREATE
    [Documentation]    This keyword is a set up step for the ASS-NEL-PI002 -CREATE Suite
    ...
    ...    It pulls term and property IDs from the catalogue via the txt file
    ...
    ...    It uses the property and term IDs to save and delete a tuples against the hub
    ...
    ...    It gets the Audit ID and transaction ID for the audit logs created when saving and delting the tuple
    ...
    ...    *Arguments*
    ...
    ...    There are no arguments for this keyword
    ...
    ...    *Output*
    ...
    ...    The keyword outputs the following SUITE variables:
    ...
    ...    - ${TERM ID}
    ...    - ${KEY PROPERTY ID}
    ...    - ${GUID A}
    ...    - ${GUID B}
    ...    - ${AUDIT ID C01}
    ...    - ${AUDIT ID CR1}
    ...    - ${AUDIT ID C02}
    ...    - ${Date C01}
    ...    - ${Date CR1}
    ...    - ${Date CR2}
    ...    - ${Response Date C01}
    ...    - ${Response Date CR1}
    ...    - ${Response Date C02}
    ...    - ${TRAN ID C01}
    ...    - ${TRAN ID CR1}
    ...    - ${TRAN ID C02}
    ...
    ...    These are not returned as arguments
    # Set Term ID
    ${term_id}=    Get Catalog Term Id From Catalog Export    ${CATALOG PATH}    ${AA TERM PATH}
    Set Suite Variable    ${TERM ID}    ${term_id}
    # Set Key Property ID
    ${key_id}=    Get Catalog Term Property Id From Catalog Export    ${CATALOG PATH}    ${AA TERM PATH}    ${AA KEY PROP}
    Set Suite Variable    ${KEY PROPERTY ID}    ${key_id}
    # Set General Property ID
    ${general_id}=    Get Catalog Term Property Id From Catalog Export    ${CATALOG PATH}    ${AA TERM PATH}    ${AA GEN PROP}
    Set Suite Variable    ${GENERAL PROPERTY ID}    ${general_id}
    # Set Tuple IDs
    ${GUID A}=    Create Hex GUID
    ${GUID B}=    Create Hex GUID
    Set Suite Variable    ${GUID 01}    ${GUID A}
    Set Suite Variable    ${GUID 02}    ${GUID B}
    # Create Key
    ${Property XML 1}=    Batch Set Property Element (Non-Linked)    ${AA KEY PROP}    ${TERM ID}    ${KEY PROPERTY ID}    ${AA KEY TEXT}
    ${Operation 1}=    Batch Create Operation XML    ${TERM ID}    ${AA KEY TEXT}    ${GUID 01}    ${Property XML 1}
    @{Operation Response Body}=    Batch Request    +1    2    ${Operation 1}
    # Delete
    ${Operation 2}=    Batch Delete Operation XML    ${TERM ID}    ${AA KEY TEXT}    ${GUID 01}
    @{Operation Response Body 2}=    Batch Request    -1    1    ${Operation 2}
    # Set Transaction ID and Audit ID Variables
    Get Audit ID from DB    C01    ${GUID 01}    ${ACTION}    ${TERM ID}
    Get Audit ID from DB    CR1    ${GUID 01}    RETRIEVE    ${TERM ID}    # The retrieve that is echoed with the create request
    Get Transaction ID    C01    0    @{Operation Response Body}
    # Get Rules Applied
    Get Rules from Batch    KEY    @{Operation Response Body}
    # Create General
    ${Property XML 1}=    Batch Set Property Element (Non-Linked)    ${AA GEN PROP}    ${TERM ID}    ${GENERAL PROPERTY ID}    ${AA GEN TEXT}
    ${Operation 1}=    Batch Create Operation XML    ${TERM ID}    ${AA GEN TEXT}    ${GUID 02}    ${Property XML 1}
    @{Operation Response Body}=    Batch Request    +1    2    ${Operation 1}
    # Delete
    ${Operation 2}=    Batch Delete Operation XML    ${TERM ID}    ${AA GEN TEXT}    ${GUID 02}
    @{Operation Response Body 2}=    Batch Request    -1    1    ${Operation 2}
    # Set Transaction ID and Audit ID Variables
    Get Audit ID from DB    C02    ${GUID 02}    ${ACTION}    ${TERM ID}
    Get Transaction ID    C02    0    @{Operation Response Body}
    # Get Rules Applied
    Get Rules from Batch    GENERAL    @{Operation Response Body}

SET DELETE
    [Documentation]    This keyword is a set up step for the ASS-NEL-PI002 -DELETE Suite
    ...
    ...    It pulls term and property IDs from the catalogue via the txt file
    ...
    ...    It uses the property and term IDs to save and delete a tuples against the hub
    ...
    ...    It gets the Audit ID and transaction ID for the audit logs created when saving and delting the tuple
    ...
    ...    *Arguments*
    ...
    ...    There are no arguments for this keyword
    ...
    ...    *Output*
    ...
    ...    The keyword outputs the following SUITE variables:
    ...
    ...    - ${TERM ID}
    ...    - ${KEY PROPERTY ID}
    ...    - ${GUID A}
    ...    - ${GUID B}
    ...    - ${AUDIT ID D01}
    ...    - ${AUDIT ID D02}
    ...    - ${Date D01}
    ...    - ${Date D02}
    ...    - ${Response Date D01}
    ...    - ${Response Date D02}
    ...    - ${TRAN ID D01}
    ...    - ${TRAN ID D02}
    ...
    ...    These are not returned as arguments
    # Set Term ID
    ${term_id}=    Get Catalog Term Id From Catalog Export    ${CATALOG PATH}    ${QA TERM PATH}
    Set Suite Variable    ${TERM ID}    ${term_id}
    # Set Key Property ID
    ${key_id}=    Get Catalog Term Property Id From Catalog Export    ${CATALOG PATH}    ${QA TERM PATH}    ${QA KEY PROP}
    Set Suite Variable    ${KEY PROPERTY ID}    ${key_id}
    # Set General Property ID
    ${general_id}=    Get Catalog Term Property Id From Catalog Export    ${CATALOG PATH}    ${QA TERM PATH}    ${QA GEN PROP}
    Set Suite Variable    ${GENERAL PROPERTY ID}    ${general_id}
    # Set Tuple IDs
    ${GUID A}=    Create Hex GUID
    ${GUID B}=    Create Hex GUID
    Set Suite Variable    ${GUID 01}    ${GUID A}
    Set Suite Variable    ${GUID 02}    ${GUID B}
    # Create Tuples
    ${Property XML 1}=    Batch Set Property Element (Non-Linked)    ${QA KEY PROP}    ${TERM ID}    ${KEY PROPERTY ID}    ${QA KEY TEXT}
    ${Operation 1}=    Batch Create Operation XML    ${TERM ID}    ${QA KEY TEXT}    ${GUID 01}    ${Property XML 1}
    @{Operation Response Body}=    Batch Request    +1    2    ${Operation 1}
    # Delete
    ${Operation 2}=    Batch Delete Operation XML    ${TERM ID}    ${QA KEY TEXT}    ${GUID 01}
    @{Operation Response Body 2}=    Batch Request    -1    1    ${Operation 2}
    # Set Transaction ID and Audit ID Variables
    Get Audit ID from DB    D01    ${GUID 01}    ${ACTION}    ${TERM ID}
    Get Transaction ID    D01    0    @{Operation Response Body 2}
    # Get Rules Applied
    Get Rules from Batch    KEY    @{Operation Response Body 2}
    # Create Tuples
    ${Property XML 1}=    Batch Set Property Element (Non-Linked)    ${QA GEN PROP}    ${TERM ID}    ${GENERAL PROPERTY ID}    ${QA GEN TEXT}
    ${Operation 1}=    Batch Create Operation XML    ${TERM ID}    ${QA GEN TEXT}    ${GUID 02}    ${Property XML 1}
    @{Operation Response Body}=    Batch Request    +1    2    ${Operation 1}
    # Delete
    ${Operation 2}=    Batch Delete Operation XML    ${TERM ID}    ${QA GEN TEXT}    ${GUID 02}
    @{Operation Response Body 2}=    Batch Request    -1    1    ${Operation 2}
    # Set Transaction ID and Audit ID Variables
    Get Audit ID from DB    D02    ${GUID 02}    ${ACTION}    ${TERM ID}
    Get Transaction ID    D02    0    @{Operation Response Body 2}
    # Get Rules Applied
    Get Rules from Batch    GENERAL    @{Operation Response Body 2}

SET RETRIEVE
    [Documentation]    This keyword is a set up step for the ASS-NEL-PI002 -RETRIEVE Suite
    ...
    ...    It pulls term and property IDs from the catalogue via the txt file
    ...
    ...    It uses the property and term IDs to save and delete a tuples against the hub
    ...
    ...    It gets the Audit ID and transaction ID for the audit logs created when saving and delting the tuple
    ...
    ...    *Arguments*
    ...
    ...    There are no arguments for this keyword
    ...
    ...    *Output*
    ...
    ...    The keyword outputs the following SUITE variables:
    ...
    ...    - ${TERM ID}
    ...    - ${KEY PROPERTY ID}
    ...    - ${GUID 01}
    ...    - ${GUID 02}
    ...    - ${AUDIT ID R01}
    ...    - ${AUDIT ID R02}
    ...    - ${Date R01}
    ...    - ${Date R02}
    ...    - ${Response Date R01}
    ...    - ${Response Date R02}
    ...    - ${TRAN ID R01}
    ...    - ${TRAN ID R02}
    ...
    ...    These are not returned as arguments
    # Set Term ID
    ${term_id}=    Get Catalog Term Id From Catalog Export    ${CATALOG PATH}    ${CT TERM PATH}
    Set Suite Variable    ${TERM ID}    ${term_id}
    # Set Key Property ID
    ${key_id}=    Get Catalog Term Property Id From Catalog Export    ${CATALOG PATH}    ${CT TERM PATH}    ${CT KEY PROP}
    Set Suite Variable    ${KEY PROPERTY ID}    ${key_id}
    # Set General Property ID
    ${general_id}=    Get Catalog Term Property Id From Catalog Export    ${CATALOG PATH}    ${CT TERM PATH}    ${CT GEN PROP}
    Set Suite Variable    ${GENERAL PROPERTY ID}    ${general_id}
    # Set Tuple IDs
    ${GUID A}=    Create Hex GUID
    ${GUID B}=    Create Hex GUID
    Set Suite Variable    ${GUID 01}    ${GUID A}
    Set Suite Variable    ${GUID 02}    ${GUID B}
    # Create Tuple
    ${Property XML 1}=    Batch Set Property Element (Non-Linked)    ${CT KEY PROP}    ${TERM ID}    ${KEY PROPERTY ID}    ${CT KEY TEXT}
    ${Operation 1}=    Batch Create Operation XML    ${TERM ID}    ${CT KEY TEXT}    ${GUID 01}    ${Property XML 1}
    @{Operation Response Body 1}=    Batch Request    +1    2    ${Operation 1}
    # Retrieve Tuple
    ${Operation 2}=    Batch Retrieve Operation XML    ${TERM ID}    ${CT KEY TEXT}    ${GUID 01}
    @{Operation Response Body 2}=    Batch Request    +0    1    ${Operation 2}
    # Delete Tuple
    ${Operation 3}=    Batch Delete Operation XML    ${TERM ID}    ${CT KEY TEXT}    ${GUID 01}
    @{Operation Response Body 3}=    Batch Request    -1    1    ${Operation 3}
    # Set Transaction ID and Audit ID Variables
    Get Audit ID from DB    R01    ${GUID 01}    ${ACTION}    ${TERM ID}
    # Create Tuple
    ${Property XML 1}=    Batch Set Property Element (Non-Linked)    ${CT GEN PROP}    ${TERM ID}    ${GENERAL PROPERTY ID}    ${CT GEN TEXT}
    ${Operation 1}=    Batch Create Operation XML    ${TERM ID}    ${CT GEN TEXT}    ${GUID 02}    ${Property XML 1}
    @{Operation Response Body 1}=    Batch Request    +1    2    ${Operation 1}
    # Retreive Tuple
    ${Operation 2}=    Batch Retrieve Operation XML    ${TERM ID}    ${CT GEN TEXT}    ${GUID 02}
    @{Operation Response Body 2}=    Batch Request    +0    1    ${Operation 2}
    # Delete Tuple
    ${Operation 3}=    Batch Delete Operation XML    ${TERM ID}    ${CT GEN TEXT}    ${GUID 02}
    @{Operation Response Body 3}=    Batch Request    -1    1    ${Operation 3}
    # Set Transaction ID and Audit ID Variables
    Get Audit ID from DB    R02    ${GUID 02}    ${ACTION}    ${TERM ID}

SET UPDATE
    [Documentation]    This keyword is a set up step for the ASS-NEL-PI002 -UPDATE Suite
    ...
    ...    It pulls term and property IDs from the catalogue via the txt file
    ...
    ...    It uses the property and term IDs to save, update and delete a tuples against the hub
    ...
    ...    It gets the Audit ID and transaction ID for the audit logs created when saving and delting the tuple
    ...
    ...    *Arguments*
    ...
    ...    There are no arguments for this keyword
    ...
    ...    *Output*
    ...
    ...    The keyword outputs the following SUITE variables:
    ...
    ...    - ${TERM ID}
    ...    - ${KEY PROPERTY ID}
    ...    - ${GUID 01}
    ...    - ${GUID 02}
    ...    - ${AUDIT ID U01}
    ...    - ${AUDIT ID U02}
    ...    - ${Date U01}
    ...    - ${Date U02}
    ...    - ${Response Date U01}
    ...    - ${Response Date U02}
    ...    - ${TRAN ID U01}
    ...    - ${TRAN ID U02}
    ...
    ...    These are not returned as arguments
    # Set Term ID
    ${term_id}=    Get Catalog Term Id From Catalog Export    ${CATALOG PATH}    ${A TERM PATH}
    Set Suite Variable    ${TERM ID}    ${term_id}
    # Set Key Property ID
    ${key_id}=    Get Catalog Term Property Id From Catalog Export    ${CATALOG PATH}    ${A TERM PATH}    ${A KEY PROP}
    Set Suite Variable    ${KEY PROPERTY ID}    ${key_id}
    # Set General Property ID
    ${general_id}=    Get Catalog Term Property Id From Catalog Export    ${CATALOG PATH}    ${A TERM PATH}    ${A GEN PROP}
    Set Suite Variable    ${GENERAL PROPERTY ID}    ${general_id}
    # Set Tuple IDs
    ${GUID A}=    Create Hex GUID
    ${GUID B}=    Create Hex GUID
    Set Suite Variable    ${GUID 01}    ${GUID A}
    Set Suite Variable    ${GUID 02}    ${GUID B}
    # Create Tuple
    ${Property XML 1}=    Batch Set Property Element (Non-Linked)    ${A KEY PROP}    ${TERM ID}    ${KEY PROPERTY ID}    ${A KEY TEXT}
    ${Operation 1}=    Batch Create Operation XML    ${TERM ID}    ${A KEY TEXT}    ${GUID 01}    ${Property XML 1}
    @{Operation Response Body 1}=    Batch Request    +1    2    ${Operation 1}
    # Update Tuple
    ${Property XML 2}=    Batch Set Property Element (Non-Linked)    ${A KEY PROP}    ${TERM ID}    ${KEY PROPERTY ID}    ${A KEY TEXT} Update
    ${Operation 2}=    Batch Update Operation XML    ${TERM ID}    ${A KEY TEXT}    ${GUID 01}    ${Property XML 2}
    @{Operation Response Body 2}=    Batch Request    +0    1    ${Operation 2}
    # Delete Tuple
    ${Operation 3}=    Batch Delete Operation XML    ${TERM ID}    ${A KEY TEXT} Update    ${GUID 01}
    @{Operation Response Body 3}=    Batch Request    -1    1    ${Operation 3}
    # Set Transaction ID and Audit ID Variables
    Get Audit ID from DB    U01    ${GUID 01}    UPDATE    ${TERM ID}
    Get Transaction ID    U01    0    @{Operation Response Body 2}
    # Get Rules Applied
    Get Rules from Batch    KEY    @{Operation Response Body 2}
    # Create Tuple
    ${Property XML 1}=    Batch Set Property Element (Non-Linked)    ${A GEN PROP}    ${TERM ID}    ${GENERAL PROPERTY ID}    ${A GEN TEXT}
    ${Operation 1}=    Batch Create Operation XML    ${TERM ID}    ${A GEN TEXT}    ${GUID 02}    ${Property XML 1}
    @{Operation Response Body 1}=    Batch Request    +1    2    ${Operation 1}
    # Update Tuple
    ${Property XML 2}=    Batch Set Property Element (Non-Linked)    ${A KEY PROP}    ${TERM ID}    ${KEY PROPERTY ID}    ${A GEN TEXT} Update
    ${Property XML 2a}=    Batch Set Property Element (Non-Linked)    ${A GEN PROP}    ${TERM ID}    ${GENERAL PROPERTY ID}    ${A GEN TEXT} Update
    ${Operation 2}=    Batch Update Operation XML    ${TERM ID}    ${A GEN TEXT}    ${GUID 02}    ${Property XML 2}    ${Property XML 2a}
    @{Operation Response Body 2}=    Batch Request    +0    1    ${Operation 2}
    # Delete Tuple
    ${Operation 3}=    Batch Delete Operation XML    ${TERM ID}    ${A GEN TEXT} Update    ${GUID 02}
    @{Operation Response Body 3}=    Batch Request    -1    1    ${Operation 3}
    # Set Transaction ID and Audit ID Variables
    Get Audit ID from DB    U02    ${GUID 02}    UPDATE    ${TERM ID}
    Get Transaction ID    U02    0    @{Operation Response Body 2}
    # Get Rules Applied
    Get Rules from Batch    GENERAL    @{Operation Response Body 2}

SET SEARCH
    [Documentation]    This keyword is a set up step for the ASS-NEL-PI002 -SEARCH Suite
    ...
    ...    It runs a search against /Asset in the hub
    ...
    ...    The audit log is then pulled for this search
    ...
    ...    It pulls term and property IDs from the catalogue via the txt file
    ...
    ...    It uses the property and term IDs to save a tuple against the hub
    ...
    ...    It runs a query for this tuple and retrives the audit log for the query
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
    ...    - ${LSCAPE_HUB_ID}
    ...    - ${TERM ID}
    ...    - ${KEY PROPERTY ID}
    ...    - ${GUID 01}
    ...    - ${AUDIT ID S01}
    ...    - ${AUDIT ID CS1}
    ...    - ${AUDIT ID S02}
    ...    - ${AUDIT ID SR2}
    ...    - ${Date S01}
    ...    - ${Date S02}
    ...    - ${Date SR1}
    ...    - ${Date CS1}
    ...    - ${Response Date S01}
    ...    - ${Response Date S02}
    ...    - ${Response Date SR1}
    ...    - ${Response Date CS1}
    ...    - ${TRAN ID S01}
    ...    - ${TRAN ID S02}
    ...    - ${TRAN ID SR1}
    ...    - ${TRAN ID CS1}
    ...
    ...    These are not returned as arguments
    ...
    ...    THIS TEST WILL FAIL PERIODICALLY DUE TO RUN ORDER. IT CAN BE MANUALLY CHECKED
    Get Lscape Hub ID
    # Run Query
    query_resources.Execute Query (Tuple Service)    "/IDBS-Applications/Core/Asset Hub/Asset"    # Queries a core asset hub term
    # Get Audit ID
    Get Audit ID from DB    S01    NULL    ${ACTION}    NULL    # No Tuple ID for search logs
    # Create Tuple to Search
    # Set Tuple IDs
    ${GUID A}=    Create Hex GUID
    Set Suite Variable    ${GUID 01}    ${GUID A}
    # Set Term ID
    ${term_id}=    Get Catalog Term Id From Catalog Export    ${CATALOG PATH}    ${A TERM PATH}
    Set Suite Variable    ${TERM ID}    ${term_id}
    # Set Key Property ID
    ${key_id}=    Get Catalog Term Property Id From Catalog Export    ${CATALOG PATH}    ${A TERM PATH}    ${A KEY PROP}
    Set Suite Variable    ${KEY PROPERTY ID}    ${key_id}
    # Create Tuple
    ${Property XML 1}=    Batch Set Property Element (Non-Linked)    ${A KEY PROP}    ${TERM ID}    ${KEY PROPERTY ID}    ${A KEY TEXT}
    ${Operation 1}=    Batch Create Operation XML    ${TERM ID}    ${A KEY TEXT}    ${GUID 01}    ${Property XML 1}
    @{Operation Response Body}=    Batch Request    +1    2    ${Operation 1}
    # Get create audit log
    Get Audit ID from DB    CS    ${GUID 01}    CREATE    ${TERM ID}
    # Search for Tuple
    # Run Query
    ${path}=    Set Variable    "${A TERM PATH}"    # Path needs quotes to work
    ${string column}=    Set Variable    ${A KEY PROP}
    @{expected tupleids}    Create List    ${GUID 01}
    Execute Tuple Query Service and Verify Tuples    ${path}    SELECT HUB_GUID, TUPLE_GUID, TERM_GUID FROM ${path} WHERE TUPLE_GUID = '${GUID 01}'    @{expected tupleids}
    # Get Audit ID
    Get Audit ID from DB    S02    NULL    ${ACTION}    NULL    # No Tuple ID for search logs
    Get Audit ID from DB    SR2    ${GUID 01}    RETRIEVE    ${TERM ID}
    # Delete Tuple
    # Delete
    ${Operation 2}=    Batch Delete Operation XML    ${TERM ID}    ${A KEY TEXT}    ${GUID 01}
    @{Operation Response Body 2}=    Batch Request    -1    1    ${Operation 2}

Get Audit ID from DB
    [Arguments]    ${Identifier}    ${Tuple ID}    ${Action}    ${Term ID}
    [Documentation]    Gets the Audit ID from the POOL schema. Sets the audit ID as a suite variable with the suffix ${identifier}. Set
    ...
    ...    Also Sets Date (dd/MM/yy) and Response Date (yyyy-MM-dd) variables with the prefix ${identifier}.
    ...
    ...    *Arguments*
    ...
    ...    ${Identifier} = \ The suffix used to define the returned variables
    ...
    ...    ${Tuple ID} \ = The tuple GUID
    ...
    ...    ${Action} = The CRUDS event
    ...
    ...    ${term ID} = The term GUID for which the tuple was created against
    ...
    ...
    ...
    ...    *Return Values*
    ...
    ...    - *The values are set as suite variables and are not retunred directly from the keyword*
    ...
    ...
    ...
    ...    AUDIT ID ${Identifier}
    ...
    ...    Date ${Identifier}
    ...
    ...    Response Date ${Identifier}
    ...
    ...
    ...
    ...    *Precondition*
    ...
    ...    - An audit log must be ready to retrieve from the database.
    ...    - The keyword pulls only the most recent event, and does not discriminate between multiple logs of the same type. It is therefore advisable to run the keyword directly after the action that the causes the log to record.
    ...
    ...
    ...
    ...    *Example*
    ...
    ...    | Get Audit ID from DB | SUF1 | ${tuple GUID} | CREATE | ${term GUID} |
    ...    | | | | |
    ...    | *Returns* | | *Value* | |
    ...    | ${AUDIT ID SUF1} | | an Audit GUID | |
    ...    | ${Date SUF1} | | dd/MM/yy | |
    ...    | ${Response Date SUF1} | | yyyy-MM-dd | |
    ${TupleQuery}=    Set Variable if    '${Tuple ID}' == 'NULL'    IS NULL    = '${Tuple ID}'
    ${TermQuery}=    Set Variable if    '${Term ID}' == 'NULL'    IS NULL    = '${Term ID}'
    # Audit ID from Database
    Connect To Database    ${POOL_USERNAME}    ${POOL_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    log    select * from Lan_v_Hub_Audit where TUPLE_ID ${TupleQuery} and AUDIT_ACTION = '${Action}' and TERM_ID ${TermQuery} order by AUDIT_TIMESTAMP desc
    ${queryResults}=    Query    select * from Lan_v_Hub_Audit where TUPLE_ID ${TupleQuery} and AUDIT_ACTION = '${Action}' and TERM_ID ${TermQuery} order by AUDIT_TIMESTAMP desc
    log    ${queryResults}
    ${auditId}=    Set Variable    ${queryResults[0][0]}
    log    ${auditId}
    Disconnect From Database
    # Set Suite Variables
    Set Suite Variable    ${AUDIT ID ${Identifier}}    ${auditId}
    ${Date}    ${Response Date}=    _Get Date
    # Date
    Set Suite Variable    ${Date ${Identifier}}    ${Date}
    Set Suite Variable    ${Response Date ${Identifier}}    ${Response Date}

Get Transaction ID
    [Arguments]    ${Identifier}    ${Order Number}    @{Operation Response Body}
    [Documentation]    Get the Transaction ID from a batch request operation. Filters through the Batch response and pulls the transaction ID from the XML
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Identifier} = a suffix used to define the transaction ID variable
    ...
    ...    ${Order Number} = Where multiple transaction IDs exist, use to chose the item from the list , starting at 0. e.g. @{LIST}[Order Number]
    ...
    ...    @{Operation Response Body} = The tuple service response body
    ...
    ...
    ...
    ...    *Example*
    ...
    ...
    ...    | Get Transaction ID | SUF1 | 0 | @{Response Body XML} | |
    ...    | | | | |
    ...    | *Returns* | | *Value* | |
    ...    | ${TRAN ID SUF1} | | a transaction ID | |
    @{Transaction}=    Get Element Value    ${Operation Response Body}    ${XMLNS4}    transactionId
    ${Transaction}=    Set Variable    @{Transaction}[${Order Number}]
    log    ${Transaction}
    Set Suite Variable    ${TRAN ID ${Identifier}}    ${Transaction}

Request Audit
    [Arguments]    ${auditId}=${EMPTY}    ${tupleId}=${EMPTY}    ${transactionId}=${EMPTY}    ${user}=${EMPTY}    ${auditTimestamp}=${EMPTY}    ${auditAction}=${EMPTY}
    ...    ${auditText}=${EMPTY}    ${auditDataView}=BASIC
    [Documentation]    This keyword sets the parameters and POSTs an audit query, returning the response body
    ...
    ...    - All parameters are set to EMPTY unless defined, except auditDataView which defaults to BASIC
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${auditId} = An ID assigned to an audit log entry
    ...
    ...    ${tupleId} = An ID assigned to a Tuple on creation
    ...
    ...    ${transactionId} =An ID assigned to the change event in the database
    ...
    ...    ${user} = The user responsible for the event; e.g. Administrator
    ...
    ...    ${auditTimestamp} = A date for when the Tuple event originated. Can be a Range; e.g. dd/MM/yy.dd/MM/yy
    ...
    ...    ${auditAction} = The Tuple event; CREATE, RETRIEVE, UPDATE, DELETE
    ...
    ...    ${auditText} = The human readable format of the Tuple event
    ...
    ...    ${auditDataView} = In addition User can specify if the full (BASIC_AND_ADVANCED), or just basic (BASIC), audit record is returned.
    ...
    ...
    ...
    ...    *Return Values*
    ...
    ...
    ...    ${Audit Response} = XML response body returned from this request. Results, if any, will be within this XML
    ...
    ...
    ...
    ...    *Example*
    ...
    ...
    ...    | ${Audit Response} = | Request Audit | ${auditId} | ${tupleId} | ${transactionId} | ${user} | ${auditTimestamp} | ${auditAction} | ${auditText} | ${auditDataView} |
    ...    | Response XML = | Request Audit | b7f09a0c35434d5c8fb15b516c92c146 | 62c78a376dfa4567a253364b73b9731e | 2.19.3149 | Administrator | dd/MM/yy | CREATE | Key Property Value For Non-Batch Delete Operation Term ID Testing | BASIC_AND_ADVANCED |
    ${auditSearchParameters}=    Create Xml Object    auditSearchParameters    ${XMLNS REQUEST AUDITING}
    ${tupleIdXML}=    Create Xml Object    tupleId    elementText=${tupleId}
    ${auditDataViewXML}=    Create Xml Object    auditDataView    elementText=${auditDataView}
    ${transactionIdXML}=    Create Xml Object    transactionId    elementText=${transactionId}
    ${auditActionXML}=    Create Xml Object    auditAction    elementText=${auditAction}
    ${auditTextXML}=    Create Xml Object    auditText    elementText=${auditText}
    ${userXML}=    Create Xml Object    user    elementText=${user}
    ${auditIdXML}=    Create Xml Object    auditId    elementText=${auditId}
    ${auditTimestampXML}=    Create Xml Object    auditTimestamp    elementText=${auditTimestamp}
    # Add XML items together
    ${audit property XML}=    Add Subelement To Xml    ${auditSearchParameters}    ${tupleIdXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${auditDataViewXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${transactionIdXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${auditActionXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${auditTextXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${userXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${auditIdXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${auditTimestampXML}
    # Return XML as string
    ${audit property XML}=    Get Xml    ${audit property XML}    ${XMLNS REQUEST AUDITING}
    ${audit xml DEBUG}=    Log    ${audit property XML}
    # POST Request
    ${Audit Response}=    _POST Audit Request    ${audit property XML}
    Log    ${Audit Response}
    [Return]    ${Audit Response}

Process Audit Response
    [Arguments]    ${Audit Response Body}
    [Documentation]    Takes the response from 'POST Audit Request' and splits into a list of the search results based on the defined list item
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Audit Response Body} = The audit response body XML
    ...
    ...    - Response body can be returned from Request Audit keyword
    ...
    ...
    ...
    ...    *Return Values*
    ...
    ...
    ...    @{Audit Search Results} = A XML list of the Search results, each item in the list being the data for an audit log
    ...
    ...
    ...
    ...    *Example*
    ...
    ...
    ...    | @{Audit Search Results} = | Process Audit Response | ${Audit Response body} |
    Comment    Should Contain    ${Audit Response Body}    hubTechResponse    # Checks that the search result contains hubTechResonse
    @{Audit Search Results}=    Get Element Xml    ${Audit Response Body}    ${XMLNS REQUEST AUDITING}    searchResults    # Splits the string into a list of the search results in XML
    @{Audit Error Message}=    Get Element Xml    ${Audit Response Body}    ${XMLNS REQUEST AUDITING}    errorMessage    # Notes the error Message Deleivered with the Response
    Log Many    @{Audit Error Message}    # Logs the list items
    Log Many    @{Audit Search Results}    # Logs the list items
    ${Audit Search Length}=    Get Length    ${Audit Search Results}    # Returns how many search results
    Log    ${Audit Search Length}
    : FOR    ${element}    IN    @{Audit Search Results}
    \    Should Not Contain    ${element}    hubTechResponse    # Confirms that the string has been split into a list
    [Return]    @{Audit Search Results}

Return Audit Values
    [Arguments]    ${Search Result Number}    @{Audit Search Results}
    [Documentation]    Takes processed XML from the 'Process Audit Response' keyword and splits into the component parts of an audit log. The user can define which audit log they chose from the list.
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Search Result Number} = When set to [0] will take the first result from the @{Audit Search Results} list and return the XML values for each of the parameters.
    ...
    ...    @{Audit Search Results} = The return value from 'Process Audit Response'; an XML list of the audit log entries and their values.
    ...
    ...
    ...
    ...    *Return Values*
    ...
    ...
    ...    ${auditId} = The audit GUID
    ...
    ...    ${tupleId} = The tuple GUID
    ...
    ...    ${hubGuid} = The hub GUID
    ...
    ...    ${termId} = The term GUID
    ...
    ...    ${keyPropertyValue} = The key property value
    ...
    ...    ${transactionId} = The transaction ID
    ...
    ...    ${auditAction} =The CRUD action type
    ...
    ...    ${reasonForChange} = The user defined reason for change given
    ...
    ...    ${auditText} = The human readable audit log
    ...
    ...    ${auditTimestamp} = The audit timestamp
    ...
    ...    ${user} = The user
    ...
    ...    ${rulesRan} = The business rules run
    ...
    ...
    ...
    ...    *Example*
    ...
    ...
    ...    | Return Audit Values | @{Audit Search Results} |
    ${Search Choice}=    Set Variable    @{Audit Search Results}[${Search Result Number}]    # Selects a result from the unsorted list of search results from the response body and returns as a string
    Log    ${Search Choice}
    # Splits the Search Result XML into it's child XML
    @{auditIdlist}=    Get Element Value    ${Search Choice}    ${XMLNS REQUEST AUDITING}    auditId
    ${auditId}=    Set Variable    @{auditIdlist}[0]
    ${status}    ${value}=    Run Keyword And Ignore Error    Should Contain    ${Search Choice}    tupleId    # Checks to see if there is any tupleId and captures them if so
    @{tupleId}=    Run Keyword If    '${status}' == 'PASS'    Get Element Value    ${Search Choice}    ${XMLNS REQUEST AUDITING}    tupleId
    ...    # Returns tupleId
    ${tupleId}=    Set Variable If    '${status}' == 'PASS'    @{tupleId}[0]
    @{hubGuidlist}=    Get Element Value    ${Search Choice}    ${XMLNS REQUEST AUDITING}    hubGuid
    ${hubGuid}=    Set Variable    @{hubGuidlist}[0]
    ${status}    ${value}=    Run Keyword And Ignore Error    Should Contain    ${Search Choice}    termId    # Checks to see if there is any termId and captures them if so
    @{termId}=    Run Keyword If    '${status}' == 'PASS'    Get Element Value    ${Search Choice}    ${XMLNS REQUEST AUDITING}    termId
    ...    # Returns termId
    ${termId}=    Set Variable If    '${status}' == 'PASS'    @{termId}[0]
    ${status}    ${value}=    Run Keyword And Ignore Error    Should Contain    ${Search Choice}    keyPropertyValue    # Checks to see if there is any keyPropertyValue and captures them if so
    @{keyPropertyValue}=    Run Keyword If    '${status}' == 'PASS'    Get Element Value    ${Search Choice}    ${XMLNS REQUEST AUDITING}    keyPropertyValue
    ...    # Returns keyPropertyValue
    ${keyPropertyValue}=    Set Variable If    '${status}' == 'PASS'    @{keyPropertyValue}[0]
    @{auditActionlist}=    Get Element Value    ${Search Choice}    ${XMLNS REQUEST AUDITING}    auditAction
    ${auditAction}=    Set Variable    @{auditActionlist}[0]
    @{auditTextlist}=    Get Element Value    ${Search Choice}    ${XMLNS REQUEST AUDITING}    auditText
    ${auditText}=    Set Variable    @{auditTextlist}[0]
    @{auditTimestamplist}=    Get Element Value    ${Search Choice}    ${XMLNS REQUEST AUDITING}    auditTimestamp
    ${auditTimestamp}=    Set Variable    @{auditTimestamplist}[0]
    @{userlist}=    Get Element Value    ${Search Choice}    ${XMLNS REQUEST AUDITING}    user
    ${user}=    Set Variable    @{userlist}[0]
    ${status}    ${value}=    Run Keyword And Ignore Error    Should Contain    ${Search Choice}    reasonForChange    # Checks to see if there is any reasonForChange and captures them if so
    @{reasonForChange}=    Run Keyword If    '${status}' == 'PASS'    Get Element Value    ${Search Choice}    ${XMLNS REQUEST AUDITING}    reasonForChange
    ...    # Returns reasonForChange
    ${reasonForChange}=    Set Variable If    '${status}' == 'PASS'    @{reasonForChange}[0]
    ${status}    ${value}=    Run Keyword And Ignore Error    Should Contain    ${Search Choice}    transactionId    # Checks to see if there is any transactionId and captures them if so
    @{transactionId}=    Run Keyword If    '${status}' == 'PASS'    Get Element Value    ${Search Choice}    ${XMLNS REQUEST AUDITING}    transactionId
    ...    # Returns transactionId
    ${transactionId}=    Set Variable If    '${status}' == 'PASS'    @{transactionId}[0]
    Log    ${transactionId}
    @{rulesRan}=    Get Element Value    ${Search Choice}    ${XMLNS REQUEST AUDITING}    auditRuleName
    Sort List    ${rulesRan}
    Log    ${rulesRan}
    [Return]    ${auditId}    ${tupleId}    ${hubGuid}    ${termId}    ${keyPropertyValue}    ${transactionId}
    ...    ${auditAction}    ${reasonForChange}    ${auditText}    ${auditTimestamp}    ${user}    ${rulesRan}

Return Advanced Audit Values
    [Arguments]    ${Search Result Number}    @{Audit Search Results}
    [Documentation]    This takes the result XML from 'Process Audit Response' and returns the XML containing the advanced audit data
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Search Result Number} = The audit log entry number from a list of audit logs, starting at [0]
    ...
    ...    @{Audit Search Results} = The XML retunred from the 'Process Audit Response' keyword
    ...
    ...
    ...
    ...    *Return Values*
    ...
    ...
    ...    ${advancedAuditResults} = The advanced audit log data for the chosen audit log
    ...
    ...
    ...
    ...    *Example*
    ...
    ...
    ...    | @{Audit Search Results}= | Return Advanced Audit Values | ${Search Result Number} | @{Audit Search Results} |
    ${Advanced Choice}=    Set Variable    @{Audit Search Results}[${Search Result Number}]    # Selects a result from the unsorted list of search results from the response body and returns as a string
    Log    ${Advanced Choice}
    # Returns the Advanced XML
    @{advancedAuditRecordlist}=    Get Element XML    ${Advanced Choice}    ${XMLNS REQUEST AUDITING}    advancedAuditRecord
    ${advancedAuditRecord}    Set Variable    @{advancedAuditRecordlist}[0]
    log    ${advancedAuditRecord}
    [Return]    ${advancedAuditRecord}

Get Rules from Batch
    [Arguments]    ${property_type}    @{Operation Response}
    [Documentation]    Returns a list of the Rules Applied from a tuple operation response
    ...
    ...    *Arguments*
    ...
    ...
    ...    @{Operation Response} = The Response Body from a Tuple Operation Request
    ...
    ...    ${property_type} = identifier used for the returned suite variable
    ...
    ...
    ...
    ...    *Return Values*
    ...
    ...
    ...    - *SETS SUITE VARIABLES:* using ${property_type} as an identifier
    ...
    ...    @{${property_type} TUPLE RULES} : Rules applied to Tuple
    ...
    ...    *Example*
    ...
    ...
    ...    | Get Batch Rules | ${property_type} | @{Operation Response}|
    Log    ${Operation Response}
    # Get the list of Rules Applied
    @{tuple_rules}=    Get Element Value    ${Operation Response}    ${XMLNS4}    ruleMatchedId    # List of the rules
    Sort List    ${tuple_rules}
    Log    ${tuple_rules}
    Set Suite Variable    @{${property_type} TUPLE RULES}    @{tuple_rules}

Audit Parameter Should Contain
    [Arguments]    ${Audit Parameter}    ${Value}    ${Audit Search Results}
    [Documentation]    Checks that a given ${Value} does appear in the ${Audit Search Results} list under the ${Audit Parameter}
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Value} = User defined value that should be present under the XML defined by ${Audit Parameter}
    ...
    ...    ${Audit Search Results} = Results returned by the 'Process Audit Response' keyword
    ...
    ...    ${Audit Parameter}= Can be: | auditId | tupleId | hubGuid | transactionId | auditAction | auditText | auditTimestamp | user |
    ...
    ...
    ...
    ...    - *Note:* Should not be used for Advanced Results parameter
    ...
    ...    *Example*
    ...
    ...
    ...    | Audit Parameter Should Contain | ${Audit Parameter} | ${Value} | ${Audit Search Results} |
    ...    | Audit Parameter Should Contain | auditId | b1a16e960af94ac5bd3e080ba5da45ca | ${Audit Search Results} |
    @{Parameter}=    Get Element Value    ${Audit Search Results}    ${XMLNS REQUEST AUDITING}    ${Audit Parameter}    # Splits into a list of the values based on the parameter defined
    Log    ${Parameter}
    ${Parameter Length}=    Get Length    ${Parameter}
    Log    ${Parameter Length}
    @{Parameter}=    IDBSCollectionsLibrary.Remove Duplicates    ${Parameter}
    Should Contain    ${Parameter}    ${Value}    # Ensures that the results contain the user defined value

Audit Parameter Should Not Contain
    [Arguments]    ${Audit Parameter}    ${Value}    ${Audit Search Results}
    [Documentation]    Checks that a given ${Value} does not appear in the ${Audit Search Results} list under the ${Audit Parameter}
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Value} = User defined value that should be present under the XML defined by ${Audit Parameter}
    ...
    ...    ${Audit Search Results} = Results returned by the 'Process Audit Response' keyword
    ...
    ...    ${Audit Parameter}= Can be: | auditId | tupleId | hubGuid | transactionId | auditAction | auditText | auditTimestamp | user |
    ...
    ...
    ...
    ...    - *Note:* Should not be used for Advanced Results parameter
    ...
    ...    *Example*
    ...
    ...
    ...    | Audit Parameter Should Not Contain | ${Audit Parameter} | ${Value} | ${Audit Search Results} |
    ...    | Audit Parameter Should Not Contain | auditId | b1a16e960af94ac5bd3e080ba5da45ca | ${Audit Search Results} |
    @{Parameter}=    Get Element Value    ${Audit Search Results}    ${XMLNS REQUEST AUDITING}    ${Audit Parameter}    # Splits into a list of the values based on the parameter defined
    Log    ${Parameter}
    ${Parameter Length}=    Get Length    ${Parameter}
    Log    ${Parameter Length}
    @{Parameter}=    IDBSCollectionsLibrary.Remove Duplicates    ${Parameter}
    Should Not Contain    ${Parameter}    ${Value}    # Ensures that the results do not contain the user defined value

Audit Parameter Item Should Contain
    [Arguments]    ${Audit Parameter}    ${Value}    ${Audit Search Results}
    [Documentation]    Checks that a given ${Value} does appear in the ${Audit Search Results} list item under the ${Audit Parameter}
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Value} = User defined value that should be present under the XML defined by ${Audit Parameter}
    ...
    ...    ${Audit Search Results} = Results returned by the 'Process Audit Response' keyword
    ...
    ...    ${Audit Parameter}= Can be: | auditId | tupleId | hubGuid | transactionId | auditAction | auditText | auditTimestamp | user |
    ...
    ...
    ...
    ...    - *Note:* Should not be used for Advanced Results parameter
    ...
    ...    *Example*
    ...
    ...
    ...    | Audit Parameter Should Contain | ${Audit Parameter} | ${Value} | ${Audit Search Results} |
    ...    | Audit Parameter Should Contain | auditId | b1a16e960af94ac5bd3e080ba5da45ca | ${Audit Search Results} |
    @{Parameter}=    Get Element Value    ${Audit Search Results}    ${XMLNS REQUEST AUDITING}    ${Audit Parameter}    # Splits into a list of the values based on the parameter defined
    Log    ${Parameter}
    ${Parameter Length}=    Get Length    ${Parameter}
    Log    ${Parameter Length}
    @{Parameter}=    IDBSCollectionsLibrary.Remove Duplicates    ${Parameter}
    : FOR    ${parameter item}    IN    @{Parameter}
    \    Should Contain    ${parameter item}    ${Value}    # Ensures that the results contain the user defined value

Audit Parameter Item Should Not Contain
    [Arguments]    ${Audit Parameter}    ${Value}    ${Audit Search Results}
    [Documentation]    Checks that a given ${Value} does not appear in the ${Audit Search Results} list item under the ${Audit Parameter}
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Value} = User defined value that should be present under the XML defined by ${Audit Parameter}
    ...
    ...    ${Audit Search Results} = Results returned by the 'Process Audit Response' keyword
    ...
    ...    ${Audit Parameter}= Can be: | auditId | tupleId | hubGuid | transactionId | auditAction | auditText | auditTimestamp | user |
    ...
    ...
    ...
    ...    - *Note:* Should not be used for Advanced Results parameter
    ...
    ...    *Example*
    ...
    ...
    ...    | Audit Parameter Should Not Contain | ${Audit Parameter} | ${Value} | ${Audit Search Results} |
    ...    | Audit Parameter Should Not Contain | auditId | b1a16e960af94ac5bd3e080ba5da45ca | ${Audit Search Results} |
    @{Parameter}=    Get Element Value    ${Audit Search Results}    ${XMLNS REQUEST AUDITING}    ${Audit Parameter}    # Splits into a list of the values based on the parameter defined
    Log    ${Parameter}
    ${Parameter Length}=    Get Length    ${Parameter}
    Log    ${Parameter Length}
    @{Parameter}=    IDBSCollectionsLibrary.Remove Duplicates    ${Parameter}
    : FOR    ${parameter item}    IN    @{Parameter}
    \    Should Not Contain    ${parameter item}    ${Value}    # Ensures that the results contain the user defined value

Return List of Dates
    [Arguments]    ${Audit Search Results}
    [Documentation]    When the audit timestamp parameter values are rteurned as a list they include the time in addition to a date. This keyword strips the date from a list of key words and appends to a new list. Only unique items are appended to the list.
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Audit Search Results} = Results returned by the 'Process Audit Response' keyword
    ...
    ...    *Return Values*
    ...
    ...
    ...    @{Date List} = List of Dates
    ...
    ...    | @{Date List} = | Return a list of Dates | ${Audit Search Results} |
    @{Date List}=    Create List
    @{Parameter}=    Get Element Value From Xpath    ${Audit Search Results}    .//{${XMLNS REQUEST AUDITING}}searchResults/{${XMLNS REQUEST AUDITING}}auditTimestamp    # Will get a list of the timestamp values from only the search result XML (strips the search parameter XML)
    Log    ${Parameter}
    ${Parameter Length}=    Get Length    ${Parameter}    # How many timestamp items in the search result list
    Log    ${Parameter Length}
    : FOR    ${Timestamp Value}    IN    @{Parameter}
    \    ${Date}=    Evaluate    '${Timestamp Value}'[:10]    # Takes only the date (first 10 characters) from each value
    \    IDBSCollectionsLibrary.Append Unique Values To List    ${Date List}    ${Date}
    Log    ${Date List}    # Details List
    [Return]    @{Date List}

Timestamp Should Contain
    [Arguments]    ${Time}    @{auditTimestamp}
    [Documentation]    Checks that a given ${Time} does appear in a ${List of Dates} returned by the 'Return Audit Values' keyword
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Time} = User defined time (20yy-MM-dd)
    ...
    ...    ${auditTimestamp} = Results returned by the 'Return Audit Values' keyword
    ...
    ...
    ...    *Example*
    ...
    ...
    ...    | Timestamp Should Contain | ${Time}| ${auditTimestamp} |
    ...    | Timestamp Should Contain | 20yy-MM-dd | 2012-11-14T14:31:17.002Z |
    Should Contain    ${auditTimestamp}    ${Time}

Timestamp Should Not Contain
    [Arguments]    ${Time}    @{auditTimestamp}
    [Documentation]    Checks that a given ${Time} does NOT appear in a ${List of Dates} returned by the 'Return Audit Values' keyword
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Time} = User defined time (20yy-MM-dd)
    ...
    ...    ${auditTimestamp} = Results returned by the 'Return Audit Values' keyword
    ...
    ...
    ...    *Example*
    ...
    ...
    ...    | Timestamp Should Not Contain | ${Time}| ${auditTimestamp} |
    ...    | Timestamp Should Not Contain | 20yy-MM-dd | 2012-11-14T14:31:17.002Z |
    Should Not Contain    ${auditTimestamp}    ${Time}

Audit ID Should Contain
    [Arguments]    ${Audit}    ${auditId}
    [Documentation]    Checks that a given ${Audit} GUID does appear in a ${auditId} returned by the 'Return Audit Values' keyword
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Audit} = User supplied GUID
    ...
    ...    ${auditId} = Results returned by the 'Return Audit Values' keyword
    ...
    ...
    ...    *Example*
    ...
    ...
    ...    | Audit ID Should Contain | ${Audit}| ${auditId} |
    ...    | Audit ID Should Contain | b1a16e960af94ac5bd3e080ba5da45ca| ${auditId} |
    CheckLibrary.Check String Equals    check that audit log guid = the supplied guid    ${auditId}    ${Audit}

Tuple ID Should Contain
    [Arguments]    ${Tuple}    ${tupleId}
    [Documentation]    Checks that a given ${Tuple} GUID does appear in a ${tupleId} returned by the 'Return Audit Values' keyword
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Tuple} = User supplied GUID
    ...
    ...    ${tupleId} = Results returned by the 'Return Audit Values' keyword
    ...
    ...
    ...    *Example*
    ...
    ...
    ...    | Tuple ID Should Contain | ${Tuple} | ${tupleId} |
    ...    | Tuple ID Should Contain | b1a16e960af94ac5bd3e080ba5da45ca| ${tupleId} |
    CheckLibrary.Check String Equals    check that tuple guid = the supplied guid    ${tupleId}    ${Tuple}

Hub GUID Should Contain
    [Arguments]    ${Hub}    ${hubGuid}
    [Documentation]    Checks that a given ${Hub} GUID does appear in a ${hubGuid} returned by the 'Return Audit Values' keyword
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Hub} = User supplied GUID
    ...
    ...    ${tupleId} = Results returned by the 'Return Audit Values' keyword
    ...
    ...
    ...    *Example*
    ...
    ...
    ...    | Hub GUID Should Contain | ${Hub} | ${hubGuid} |
    ...    | Hub GUID Should Contain | E9A7A5EB4C7E48CA9268E1572DF1B69F |${hubGuid} |
    CheckLibrary.Check String Equals    check that hub guid = the supplied guid    ${hubGuid}    ${Hub}

Transaction ID Should Contain
    [Arguments]    ${Transaction}    ${transactionId}
    [Documentation]    Checks that a given ${Transaction} ID does appear in a ${transactionId} returned by the 'Return Audit Values' keyword
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Transaction} = User supplied GUID
    ...
    ...    ${transactionId} = Results returned by the 'Return Audit Values' keyword
    ...
    ...
    ...    *Example*
    ...
    ...
    ...    | Transaction ID Should Contain | ${Transaction} | ${transactionId} |
    ...    | Transaction ID Should Contain | 2.19.3149 | ${transactionId} |
    CheckLibrary.Check String Equals    check that transaction id = the supplied id    ${transactionId}    ${Transaction}

Action Should Contain
    [Arguments]    ${Action}    ${auditAction}
    [Documentation]    Checks that a given ${Action} does appear in a ${auditAction} returned by the 'Return Audit Values' keyword
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Action} = User supplied Action type (CRUDS)
    ...    ${auditAction} = Results returned by the 'Return Audit Values' keyword
    ...
    ...
    ...    *Example*
    ...
    ...
    ...    | Transaction ID Should Contain | ${Action} | ${auditAction} \ |
    ...    | Transaction ID Should Contain | CREATE |${auditAction} |
    CheckLibrary.Check String Equals    check that action = the supplied action    ${auditAction}    ${Action}

Text Should Contain
    [Arguments]    ${Text}    ${auditText}
    [Documentation]    Checks that a given ${Text} description does appear in a ${auditText} returned by the 'Return Audit Values' keyword
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Text} = User supplied audit text description
    ...    ${auditText} = Results returned by the 'Return Audit Values' keyword
    ...
    ...
    ...    *Example*
    ...
    ...
    ...    | Transaction ID Should Contain | ${Text} | ${auditText} |
    ...    | Transaction ID Should Contain | Key Property Value For Non-Batch Delete Operation Term ID Testing | ${auditText} |
    CheckLibrary.Check String Contains    check that audit text summary= the supplied text    ${auditText}    ${Text}
    log    ${auditText}
    log    ${Text}

User Should Contain
    [Arguments]    ${UserName}    ${user}
    [Documentation]    Checks that a given ${User} description does appear in a ${user} returned by the 'Return Audit Values' keyword
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${User} = User supplied
    ...    ${user} = Results returned by the 'Return Audit Values' keyword
    ...
    ...
    ...    *Example*
    ...
    ...
    ...    | User Should Contain | ${User} | ${user} |
    ...    | User Should Contain | Administrator | ${user} |
    CheckLibrary.Check String Equals    check that audit user= the supplied user    ${user}    ${UserName}

Term ID Should Contain
    [Arguments]    ${Term_ID}    ${auditTermId}
    [Documentation]    Checks that a given ${Term_ID} GUID does appear in a ${termId} returned by the 'Return Audit Values' keyword
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Term_ID} = User supplied GUID
    ...
    ...    ${auditTermId} = Results returned by the 'Return Audit Values' keyword
    ...
    ...
    ...    *Example*
    ...
    ...
    ...    | Term ID Should Contain | ${Term_ID} | ${auditTermId} |
    ...    | Term ID Should Contain | b1a16e960af94ac5bd3e080ba5da45ca | ${auditTermId} |
    CheckLibrary.Check String Equals    check that term id= the supplied id    ${auditTermId}    ${Term_ID}

Key Value Should Contain
    [Arguments]    ${KeyValue}    ${keyPropertyValue}
    [Documentation]    Checks that a given ${KeyValue} does appear in a ${keyPropertyValue} returned by the 'Return Audit Values' keyword
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${KeyValue} = User supplied
    ...
    ...    ${keyPropertyValue} = Results returned by the 'Return Audit Values' keyword
    ...
    ...
    ...    *Example*
    ...
    ...
    ...    | Key Value Should Contain | ${KeyValue} | ${keyPropertyValue} |
    ...    | Key Value Should Contain | Key Property Value | ${keyPropertyValue} |
    CheckLibrary.Check String Equals    check that the key property value= the suppliedvalue    ${keyPropertyValue}    ${KeyValue}

Reason Should Contain
    [Arguments]    ${Reason}    ${reasonForChange}
    [Documentation]    Checks that a given ${Reason} for change does appear in a ${reasonForChange} returned by the 'Return Audit Values' keyword
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Reason} = User supplied
    ...
    ...    ${reasonForChange} = Results returned by the 'Return Audit Values' keyword
    ...
    ...
    ...    *Example*
    ...
    ...
    ...    | Reason Should Contain | ${Reason} | ${reasonForChange} |
    ...    | Reason Should Contain | I changed this value | ${reasonForChange} |
    CheckLibrary.Check String Equals    check that the reason for change= the supplied text    ${reasonForChange}    ${Reason}

Rules Should Be Equal
    [Arguments]    ${Batch_Rules}    ${rulesRan}
    [Documentation]    Checks that a list of ${Batch_Rules} equals that of ${rulesRan} returned by the 'Return Audit Values' keyword
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Batch_Rules} = User supplied, returned by the 'Get Rules From Batch' Keyword
    ...
    ...    ${rulesRan} = Results returned by the 'Return Audit Values' keyword
    ...
    ...
    ...    *Example*
    ...
    ...
    ...    | Rules Should Be Equal | ${Batch_Rules} | ${rulesRan} |
    Lists Should Be Equal    ${rulesRan}    ${Batch_Rules}

Result Count Should Be
    [Arguments]    ${Result Length}    @{Audit Search Results}
    [Documentation]    Used to check that the Audit Search Result Length Should be ${Result Length}, as defined by the user
    ...
    ...    *Arguments*
    ...
    ...
    ...
    ...    @{Audit Search Result} = The audit logs given from a audit search, as given by the 'Process Audit Response' keyword
    ...
    ...    ${Result Length} = The user defined length that should equal the search result count
    ...
    ...    *Example*
    ...
    ...
    ...    | Results Count Should Be | ${Result Length} | @{Audit Search Result} |
    ...    | Results Count Should Be | 400 | @{Audit Search Result} |
    ${Result Count}=    Get Length    ${Audit Search Results}
    Should Be Equal As Integers    ${Result Length}    ${Result Count}

Get Date Range
    [Documentation]    Returns a Date Range in the format dd/MM/yy.dd/MM/yy appropriate for the Audit searching parameters +/- 3 days from the current date. Also sets Dates +/- 4,5 & 6 days either side of the current date to check that wrong dates are not returned.
    ...
    ...    *Return Values*
    ...
    ...    - *Variables:*
    ...
    ...    ${Date Range}
    ...
    ...    - *Sets Suite Variables:*
    ...
    ...    ${Date-4}
    ...
    ...    ${Date+4}
    ...
    ...    ${Date-5}
    ...
    ...    ${Date+5}
    ...
    ...    ${Date-6}
    ...
    ...    ${Date+6}
    ...
    ...
    ...    - *By calling the keywords:*
    ...
    ...    _Date4
    ...
    ...    _Date5
    ...
    ...    _Date6
    ${Date Up}=    Get Time    epoch    NOW + 3d
    ${Date Down}=    Get Time    epoch    NOW - 3d
    ${Date Range}=    Set Variable    ${Date Down}000.${Date Up}000
    log    ${Date Up}
    log    ${Date Down}
    log    ${Date Range}
    ${D+4}    ${D-4}=    _Date4
    Set Suite Variable    ${Date+4}    ${D+4}
    Set Suite Variable    ${Date-4}    ${D-4}=
    ${D+5}    ${D-5}=    _Date5
    Set Suite Variable    ${Date+5}    ${D+5}
    Set Suite Variable    ${Date-5}    ${D-5}=
    ${D+6}    ${D-6}=    _Date6
    Set Suite Variable    ${Date+6}    ${D+6}
    Set Suite Variable    ${Date-6}    ${D-6}=
    [Return]    ${Date Range}

Check Advanced Values
    [Arguments]    ${Property_ID}    ${Property_Name}    ${Term_ID}    ${Property_Text}    ${Key_Property_Text}    ${Action}
    ...    ${Tuple_ID}    ${advancedAuditRecord}
    [Documentation]    This takes the advanced result XML from 'Return Audit Values' and splits into the component parts and compares them with the input values.
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Property_ID}
    ...
    ...    ${Property_Name}
    ...
    ...    ${Term_ID}
    ...
    ...    ${Property_Text}
    ...
    ...    ${Key_Property_Text}
    ...
    ...    ${Action}
    ...
    ...    ${Tuple_ID}
    ...
    ...    ${advancedAuditRecord}
    Run Keyword If    '${Action}' == 'CREATE'    _CREATE Advanced check    ${Property_ID}    ${Property_Name}    ${Term_ID}    ${Property_Text}
    ...    ${Key_Property_Text}    ${Action}    ${Tuple_ID}    ${advancedAuditRecord}
    Run Keyword If    '${Action}' == 'UPDATE'    _UPDATE Advanced check    ${Property_ID}    ${Property_Name}    ${Term_ID}    ${Property_Text}
    ...    ${Key_Property_Text}    ${Action}    ${Tuple_ID}    ${advancedAuditRecord}
    Run Keyword If    '${Action}' == 'RETRIEVE'    _RETRIEVE Advanced check    ${Term_ID}    ${Key_Property_Text}    ${Action}    ${Tuple_ID}
    ...    ${advancedAuditRecord}
    Run Keyword If    '${Action}' == 'DELETE'    _DELETE Advanced check    ${Term_ID}    ${Key_Property_Text}    ${Action}    ${Tuple_ID}
    ...    ${advancedAuditRecord}

SEARCH Advanced check
    [Arguments]    ${SQL_query}    ${advancedAuditRecord}
    [Documentation]    This takes the advanced result XML from 'Return Audit Values' and ensures that the supplied SQL statement matches the audit log recorded one from a SEARCH event
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${SQL_query} = The SQL statement recorded from a SEARCH event form which the subsequent audit log is recorded
    ...
    ...    @{advancedAuditRecord} = The XML containig the advanced data from an audit log
    ...
    ...
    ...
    ...    *Precondition*
    ...
    ...
    ...    - Ensure that the audit log is of SEARCH type event, otherwise there will be no SQL in the advanced XML
    ...
    ...
    ...
    ...    *Example*
    ...
    ...
    ...    | SEARCH Advanced check | ${SQL_query} | @{advancedAuditRecord} |
    log Many    ${advancedAuditRecord}
    # Gets The Query data
    @{serializedQueryObject}=    Get Element Value    ${advancedAuditRecord}    ${XMLNS REQUEST AUDITING}    serializedQueryObject
    ${unescaped_XML}=    Parse Escaped Xml    @{serializedQueryObject}[0]    # Convert to string
    Log    ${unescaped_XML}
    # Get Values
    @{querylist}=    Get Element Attribute    ${unescaped_XML}    query    queryStatement    ${None}
    ${query}=    Set Variable    @{querylist}[0]    # Convert to string
    # Retrieved
    Should Be Equal As Strings    ${SQL_query}    ${query}

Audit Web Services Request Setup
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

Request Audit 401
    [Arguments]    ${auditId}=${EMPTY}    ${tupleId}=${EMPTY}    ${transactionId}=${EMPTY}    ${user}=${EMPTY}    ${auditTimestamp}=${EMPTY}    ${auditAction}=${EMPTY}
    ...    ${auditText}=${EMPTY}    ${auditDataView}=BASIC
    [Documentation]    This keyword sets the parameters and POSTs an audit query and returns the response body, passing if the request recieves a 401 HTTP error
    ...
    ...    *THIS IS USED FOR AN UNAUTHORISED username/pw COMBO only*
    ...
    ...
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${tupleId} = An ID assigned to a Tuple on creation
    ...
    ...    ${transactionId} = An ID assigned to the change event in the database
    ...
    ...    ${auditAction} = The Tuple event; CREATE, RETRIEVE, UPDATE, DELETE, SEARCH
    ...
    ...    ${auditText} = The human readable format of the Tuple event
    ...
    ...    ${user} = The user responsible for the event; e.g. Administrator
    ...
    ...    ${auditId} = An ID assigned to an audit log entry
    ...
    ...    ${auditTimestamp} = A date for when the Tuple event originated. Can be a Range; e.g. dd/MM/yy.dd/MM/yy
    ...
    ...    ${auditDataView} = In addition User can specify if the full (BASIC_AND_ADVANCED), or just basic (BASIC) audit data is returned
    ...
    ...
    ...
    ...    *Return Values*
    ...
    ...
    ...    ${Audit Response} = The audit Response
    ${auditSearchParameters}=    Create Xml Object    auditSearchParameters    ${XMLNS REQUEST AUDITING}
    ${tupleIdXML}=    Create Xml Object    tupleId    elementText=${tupleId}
    ${auditDataViewXML}=    Create Xml Object    auditDataView    elementText=${auditDataView}
    ${transactionIdXML}=    Create Xml Object    transactionId    elementText=${transactionId}
    ${auditActionXML}=    Create Xml Object    auditAction    elementText=${auditAction}
    ${auditTextXML}=    Create Xml Object    auditText    elementText=${auditText}
    ${userXML}=    Create Xml Object    user    elementText=${user}
    ${auditIdXML}=    Create Xml Object    auditId    elementText=${auditId}
    ${auditTimestampXML}=    Create Xml Object    auditTimestamp    elementText=${auditTimestamp}
    # Add XML items together
    ${audit property XML}=    Add Subelement To Xml    ${auditSearchParameters}    ${tupleIdXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${auditDataViewXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${transactionIdXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${auditActionXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${auditTextXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${userXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${auditIdXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${auditTimestampXML}
    # Return XML as string
    ${audit property XML}=    Get Xml    ${audit property XML}    ${XMLNS REQUEST AUDITING}
    ${audit xml DEBUG}=    Log    ${audit property XML}
    # POST Request
    ${Audit Response}=    _POST Audit Request 401    ${audit property XML}    # Keyword from audit services not tuple services
    [Return]    ${Audit Response}

Request Audit with User
    [Arguments]    ${auditId}=${EMPTY}    ${tupleId}=${EMPTY}    ${transactionId}=${EMPTY}    ${user}=${EMPTY}    ${auditTimestamp}=${EMPTY}    ${auditAction}=${EMPTY}
    ...    ${auditText}=${EMPTY}    ${auditDataView}=BASIC    ${401 USER}=${EMPTY}    ${401 PASS}=${EMPTY}
    [Documentation]    This keyword sets the parameters and POSTs an audit query and returns the response body, passing if the request succeeds
    ...
    ...    *THIS IS USED FOR A DEFINED username/pw*
    ...
    ...
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${tupleId} = An ID assigned to a Tuple on creation
    ...
    ...    ${transactionId} = An ID assigned to the change event in the database
    ...
    ...    ${auditAction} = The Tuple event; CREATE, RETRIEVE, UPDATE, DELETE, SEARCH
    ...
    ...    ${auditText} = The human readable format of the Tuple event
    ...
    ...    ${user} = The user responsible for the event; e.g. Administrator
    ...
    ...    ${auditId} = An ID assigned to an audit log entry
    ...
    ...    ${auditTimestamp} = A date for when the Tuple event originated. Can be a Range; e.g. dd/MM/yy.dd/MM/yy
    ...
    ...    ${auditDataView} = In addition User can specify if the full (BASIC_AND_ADVANCED), or just basic (BASIC) audit data is returned
    ...
    ...
    ...
    ...    *Return Values*
    ...
    ...
    ...    ${Audit Response} = The audit Response
    ${auditSearchParameters}=    Create Xml Object    auditSearchParameters    ${XMLNS REQUEST AUDITING}
    ${tupleIdXML}=    Create Xml Object    tupleId    elementText=${tupleId}
    ${auditDataViewXML}=    Create Xml Object    auditDataView    elementText=${auditDataView}
    ${transactionIdXML}=    Create Xml Object    transactionId    elementText=${transactionId}
    ${auditActionXML}=    Create Xml Object    auditAction    elementText=${auditAction}
    ${auditTextXML}=    Create Xml Object    auditText    elementText=${auditText}
    ${userXML}=    Create Xml Object    user    elementText=${user}
    ${auditIdXML}=    Create Xml Object    auditId    elementText=${auditId}
    ${auditTimestampXML}=    Create Xml Object    auditTimestamp    elementText=${auditTimestamp}
    # Add XML items together
    ${audit property XML}=    Add Subelement To Xml    ${auditSearchParameters}    ${tupleIdXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${auditDataViewXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${transactionIdXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${auditActionXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${auditTextXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${userXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${auditIdXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${auditTimestampXML}
    # Return XML as string
    ${audit property XML}=    Get Xml    ${audit property XML}    ${XMLNS REQUEST AUDITING}
    ${audit xml DEBUG}=    Log    ${audit property XML}
    # POST Request
    ${Audit Response}=    _POST Audit Request with User    ${audit property XML}    ${401 USER}    ${401 PASS}    # Keyword from audit services not tuple services
    [Return]    ${Audit Response}

Create Defect Dictionary
    [Documentation]    Creates a dictionary, term and 2 properties to save tuples against and a 2 min wait for Defect 17072
    ...
    ...    *Returns*
    ...
    ...    Dictionary GUID
    ...
    ...    Term GUID
    Import Resource    ${CURDIR}/../REST_CatalogService/rest_catalog_service_resource.txt
    Set Library Search Order    ${CURDIR}/../Tuple Web Service/tuple_services_resource.txt    ${CURDIR}/../REST_CatalogService/rest_catalog_service_resource.txt
    # Get GUIDs
    ${asset_term_id}=    Get Term Guid From Catalog Webservice    /IDBS-Applications/Core/Asset Hub/Asset
    # Create Term and property
    ${auditWS_term_id}=    Create Root Element    DICTIONARY    Audit Defect Auto    Automated Testing Dict    true
    ${property 1}=    Create Property JSON    Key    STRING    Short    true    true
    ${property 1a}=    Create Property JSON    General    STRING    Short    false    false
    ${properties1}=    Create Properties JSON    ${property 1}    ${property 1a}
    ${Term DEL} =    Create Non-Root Concrete Term With Inheritance    ${auditWS_term_id}    TERM    Delete Me    Delete Me    true
    ...    {"inheritedTerm":[{"inheritedTermPath":"/IDBS-Applications/Core/Asset Hub/Asset","inheritedTermId":"${asset_term_id}"}]}    ${properties1}
    # Wait for DB to UPDATE!
    Sleep    240s    # Have to wait for Term to appear in landscape before saving tuples against it
    [Return]    ${auditWS_term_id}    ${Term DEL}

_POST Audit Request
    [Arguments]    ${audit property XML}
    [Documentation]    Posts the Audit Request Body XML created within the 'Set Audit Request Body' Keyword
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${audit property XML}
    ...
    ...
    ...
    ...    *Return Values*
    ...
    ...
    ...    ${Audit Response Body}
    Audit Web Services Request Setup    # Sets the Username and Password, as well as the server
    Set Request Body    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>${audit property XML}    # Forms the XML body
    Log    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>${audit property XML}
    POST    ${REST URL END}    # Sends the XML body to the auditing REST service URL using the POST method
    ${Audit Response Body}=    Get Response Body    # Recieves the response XML
    Log    ${Audit Response Body}
    [Return]    ${Audit Response Body}

_Get Date
    [Documentation]    Returns the current date in the format (epoch-12h.epoch+12h) appropriate for the Audit searching parameters
    ...
    ...    Returns the current date in the format 20yy-MM-dd appropriate for the Audit searching parameters
    ...
    ...
    ...    *Return Values*
    ...
    ...
    ...    ${Date} = epoch time minus 12 hours.epoch time plus 12 hours
    ...
    ...    ${Response Date} = 20yy-MM-d
    ${Time}=    Get Time
    log    ${Time}
    ${yy}=    Evaluate    '${Time}'[2:4]
    ${MM}=    Get Time    month
    ${dd}=    Get Time    day
    ${Response Date}=    Set Variable    20${yy}\-${MM}\-${dd}
    log    ${Response Date}
    ${epo+12}=    Get Time    epoch    NOW + 12 hour
    ${epo-12}=    Get Time    epoch    NOW - 12 hour
    ${Date}=    Set Variable    ${epo-12}000.${epo+12}000
    log    ${Date}
    [Return]    ${Date}    ${Response Date}    # dd/MM/yy | # 20yy-MM-dd

_Date4
    [Documentation]    Returns dates in the format yyyy/MM/dd, +/- 4 days from the current date
    ...
    ...    *Return Values*
    ...
    ...
    ...    - *Variables*
    ...
    ...
    ...    ${Date-4} = The date -4 days from the current date
    ...
    ...
    ...    ${Date+4} = The date +4 days from the current date
    ${Date Up}=    Get Time    time_=NOW + 4d
    ${Date Down}=    Get Time    time_=NOW - 4d
    ${Date Up}=    Evaluate    '${Date Up}'[:10]
    ${Date Down}=    Evaluate    '${Date Down}'[:10]
    log    ${Date Up}
    log    ${Date Down}
    ${Date+4}=    Set Variable    ${Date Up}
    ${Date-4}=    Set Variable    ${Date Down}
    log    ${Date+4}
    log    ${Date-4}
    [Return]    ${Date+4}    ${Date-4}

_Date5
    [Documentation]    Returns dates in the format yyyy/MM/dd, +/- 5 days from the current date
    ...
    ...    *Return Values*
    ...
    ...
    ...    - *Variables*
    ...
    ...
    ...    ${Date-5} = The date -5 days from the current date
    ...
    ...
    ...    ${Date+5} = The date +5 days from the current date
    ${Date Up}=    Get Time    time_=NOW + 5d
    ${Date Down}=    Get Time    time_=NOW - 5d
    ${Date Up}=    Evaluate    '${Date Up}'[:10]
    ${Date Down}=    Evaluate    '${Date Down}'[:10]
    log    ${Date Up}
    log    ${Date Down}
    ${Date+5}=    Set Variable    ${Date Up}
    ${Date-5}=    Set Variable    ${Date Down}
    log    ${Date+5}
    log    ${Date-5}
    [Return]    ${Date+5}    ${Date-5}

_Date6
    [Documentation]    Returns dates in the format yyyy/MM/dd, +/- 6 days from the current date
    ...
    ...    *Return Values*
    ...
    ...
    ...    - *Variables*
    ...
    ...
    ...    ${Date-6} = The date -6 days from the current date
    ...
    ...
    ...    ${Date+6} = The date +6 days from the current date
    ${Date Up}=    Get Time    time_=NOW + 6d
    ${Date Down}=    Get Time    time_=NOW - 6d
    ${Date Up}=    Evaluate    '${Date Up}'[:10]
    ${Date Down}=    Evaluate    '${Date Down}'[:10]
    log    ${Date Up}
    log    ${Date Down}
    ${Date+6}    Set Variable    ${Date Up}
    ${Date-6}    Set Variable    ${Date Down}
    log    ${Date+6}
    log    ${Date-6}
    [Return]    ${Date+6}    ${Date-6}

_CREATE Advanced check
    [Arguments]    ${Property_ID}    ${Property_Name}    ${Term_ID}    ${Property_Text}    ${Key_Property_Text}    ${Action}
    ...    ${Tuple_ID}    ${advancedAuditRecord}
    [Documentation]    This takes the advanced result XML from 'Return Audit Values' and splits into the component parts. Comparing the sub components with the supplied inputs
    ...
    ...    Ran as part of Check Advanced Values Keyword
    ...
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Property_ID} = The property GUID
    ...
    ...    ${Property_Name} = The property name
    ...
    ...    ${Term_ID} = The term GUID
    ...
    ...    ${Property_Text} = The property value
    ...
    ...    ${Key_Property_Text} = The key property value
    ...
    ...    ${Action} = The CRUDS event type
    ...
    ...    ${Tuple_ID} = The tuple GUID
    ...
    ...    ${advancedAuditRecord} = The advanced record XML
    ...
    ...
    ...
    ...    *Return Values*
    ...
    ...
    ...    None
    ...
    ...
    ...
    ...    *Example*
    ...
    ...    | _CREATE Advanced Check | ${Property_ID} | ${Property_Name} | ${Term_ID} | ${Property_Text} | ${Key_Property_Text} | ${Action} | ${Tuple_ID} | ${advancedAuditRecord} |
    ...    | _CREATE Advanced Check | ${Property_ID} | Property 1 | 97ee7000096c11e29e4f001e4fc86865 | Value 1 | Key Value 1 | CREATE | cde477e962d54753899d97edf11e62cc | ${advancedAuditRecord} |
    log Many    ${advancedAuditRecord}
    # Gets the value from tupleBefore which is XML
    @{tupleBefore}=    Get Element Value    ${advancedAuditRecord}    ${XMLNS REQUEST AUDITING}    tupleBefore
    ${unescaped_XML}=    Parse Escaped Xml    @{tupleBefore}[0]    # Convert to string
    Log    ${unescaped_XML}
    ${tupleRequest}=    Get Element Xml    ${unescaped_XML}    ${None}    tuple
    # Takes the values from the 'tupleBefore' XML
    @{hubIdlist}=    Get Element Value    ${unescaped_XML}    ${None}    hubId
    ${hubId}=    Set Variable    @{hubIdlist}[0]    # Convert to string
    @{propertyIDlist}=    Get Element Value    ${tupleRequest}    ${None}    propertyID
    ${propertyID}=    Set Variable    @{propertyIDlist}[0]    # Convert to string
    @{propertyNamelist}=    Get Element Value    ${tupleRequest}    ${None}    propertyName
    ${propertyName}=    Set Variable    @{propertyNamelist}[0]    # Convert to string
    @{termIDlist}=    Get Element Value    ${tupleRequest}    ${None}    termID
    ${termID}=    Set Variable    @{termIDlist}[0]    # Convert to string
    @{propertyValuelist}=    Get Element Value    ${tupleRequest}    ${None}    propertyValue
    ${propertyValue}=    Set Variable    @{propertyValuelist}[0]    # Convert to string
    @{tupleKeyPropertyValuelist}=    Get Element Value    ${tupleRequest}    ${None}    tupleKeyPropertyValue
    ${tupleKeyPropertyValue}=    Set Variable    @{tupleKeyPropertyValuelist}[0]    # Convert to string
    @{tupleTermIdlist}=    Get Element Value    ${tupleRequest}    ${None}    tupleTermId
    ${tupleTermId}=    Set Variable    @{tupleTermIdlist}[0]    # Convert to string
    @{tupleTupleIdlist}=    Get Element Value    ${tupleRequest}    ${None}    tupleTupleId
    ${tupleTupleId}=    Set Variable    @{tupleTupleIdlist}[0]    # Convert to string
    @{tupleRequestTypelist}=    Get Element Value    ${unescaped_XML}    ${None}    tupleRequestType
    ${tupleRequestType}=    Set Variable    @{tupleRequestTypelist}[0]    # Convert to string
    # Check Values match test input
    Should Be Equal As Strings    ${hubId}    ${ASSET_HUB_ID}    # Global Variable
    Should Be Equal As Strings    ${propertyID}    ${Property_ID}
    Should Be Equal As Strings    ${propertyName}    ${Property_Name}
    Should Be Equal As Strings    ${termID}    ${Term_ID}
    Should Be Equal As Strings    ${propertyValue}    ${Property_Text}
    Should Be Equal As Strings    ${tupleKeyPropertyValue}    ${Key_Property_Text}
    Should Be Equal As Strings    ${tupleTermId}    ${Term_ID}
    Should Be Equal As Strings    ${tupleTupleId}    ${Tuple_ID}
    Should Be Equal As Strings    ${tupleRequestType}    ${Action}

_UPDATE Advanced check
    [Arguments]    ${Property_ID}    ${Property_Name}    ${Term_ID}    ${Property_Text}    ${Key_Property_Text}    ${Action}
    ...    ${Tuple_ID}    ${advancedAuditRecord}
    [Documentation]    This takes the advanced result XML from 'Return Audit Values' and splits into the component parts. Comparing the sub components with the supplied inputs
    ...
    ...    Ran as part of Check Advanced Values Keyword
    ...
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Property_ID} = The property GUID
    ...
    ...    ${Property_Name} = The property name
    ...
    ...    ${Term_ID} = The term GUID
    ...
    ...    ${Property_Text} = The property value
    ...
    ...    ${Key_Property_Text} = The key property value
    ...
    ...    ${Action} = The CRUDS event type
    ...
    ...    ${Tuple_ID} = The tuple GUID
    ...
    ...    ${advancedAuditRecord} = The advanced record XML
    ...
    ...
    ...
    ...    *Return Values*
    ...
    ...
    ...    None
    ...
    ...
    ...
    ...    *Example*
    ...
    ...    | _UPDATE Advanced Check | ${Property_ID} | ${Property_Name} | ${Term_ID} | ${Property_Text} | ${Key_Property_Text} | ${Action} | ${Tuple_ID} | ${advancedAuditRecord} |
    ...    | _UPDATE Advanced Check | ${Property_ID} | Property 1 | 97ee7000096c11e29e4f001e4fc86865 | Value 1 | Key Value 1 | UPDATE | cde477e962d54753899d97edf11e62cc | ${advancedAuditRecord} |
    log Many    ${advancedAuditRecord}
    # Gets the value from tupleBefore which is XML
    @{tupleBefore}=    Get Element Value    ${advancedAuditRecord}    ${XMLNS REQUEST AUDITING}    tupleBefore
    ${unescaped_XML}=    Parse Escaped Xml    @{tupleBefore}[0]    # Convert to string
    Log    ${unescaped_XML}
    ${tupleRequest}=    Get Element Xml    ${unescaped_XML}    ${None}    tuple
    # Takes the values from the 'tupleBefore' XML    ${False}
    @{hubIdlist}=    Get Element Value    ${unescaped_XML}    ${None}    hubId
    ${hubId}=    Set Variable    @{hubIdlist}[0]    # Convert to string
    @{propertyIDlist}=    Get Element Value    ${tupleRequest}    ${None}    propertyID
    ${propertyID}=    Set Variable    @{propertyIDlist}[0]    # Convert to string
    @{propertyNamelist}=    Get Element Value    ${tupleRequest}    ${None}    propertyName
    ${propertyName}=    Set Variable    @{propertyNamelist}[0]    # Convert to string
    @{termIDlist}=    Get Element Value    ${tupleRequest}    ${None}    termID
    ${termID}=    Set Variable    @{termIDlist}[0]    # Convert to string    ${False}
    @{propertyValuelist}=    Get Element Value    ${tupleRequest}    ${None}    propertyValue
    ${propertyValue}=    Set Variable    @{propertyValuelist}[0]    # Convert to string
    @{tupleKeyPropertyValuelist}=    Get Element Value    ${tupleRequest}    ${None}    tupleKeyPropertyValue
    ${tupleKeyPropertyValue}=    Set Variable    @{tupleKeyPropertyValuelist}[0]    # Convert to string
    @{tupleTermIdlist}=    Get Element Value    ${tupleRequest}    ${None}    tupleTermId
    ${tupleTermId}=    Set Variable    @{tupleTermIdlist}[0]    # Convert to string
    @{tupleTupleIdlist}=    Get Element Value    ${tupleRequest}    ${None}    tupleTupleId
    ${tupleTupleId}=    Set Variable    @{tupleTupleIdlist}[0]    # Convert to string
    @{tupleRequestTypelist}=    Get Element Value    ${unescaped_XML}    ${None}    tupleRequestType
    ${tupleRequestType}=    Set Variable    @{tupleRequestTypelist}[0]    # Convert to string
    # Check Values match test input
    Should Be Equal As Strings    ${hubId}    ${ASSET_HUB_ID}    # Global Variable
    Should Be Equal As Strings    ${propertyID}    ${Property_ID}
    Should Be Equal As Strings    ${propertyName}    ${Property_Name}
    Should Be Equal As Strings    ${termID}    ${Term_ID}
    Should Be Equal As Strings    ${propertyValue}    ${Property_Text}
    Should Be Equal As Strings    ${tupleKeyPropertyValue}    ${Key_Property_Text}
    Should Be Equal As Strings    ${tupleTermId}    ${Term_ID}
    Should Be Equal As Strings    ${tupleTupleId}    ${Tuple_ID}
    Should Be Equal As Strings    ${tupleRequestType}    ${Action}

_RETRIEVE Advanced check
    [Arguments]    ${Term_ID}    ${Key_Property_Text}    ${Action}    ${Tuple_ID}    ${advancedAuditRecord}
    [Documentation]    This takes the advanced result XML from 'Return Audit Values' and splits into the component parts. Comparing the sub components with the supplied inputs
    ...
    ...    Ran as part of Check Advanced Values Keyword
    ...
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Property_ID} = The property GUID
    ...
    ...    ${Property_Name} = The property name
    ...
    ...    ${Term_ID} = The term GUID
    ...
    ...    ${Property_Text} = The property value
    ...
    ...    ${Key_Property_Text} = The key property value
    ...
    ...    ${Action} = The CRUDS event type
    ...
    ...    ${Tuple_ID} = The tuple GUID
    ...
    ...    ${advancedAuditRecord} = The advanced record XML
    ...
    ...
    ...
    ...    *Return Values*
    ...
    ...
    ...    None
    ...
    ...
    ...
    ...    *Example*
    ...
    ...
    ...    | _RETRIEVE Advanced Check | ${Property_ID} | ${Property_Name} | ${Term_ID} | ${Property_Text} | ${Key_Property_Text} | ${Action} | ${Tuple_ID} | ${advancedAuditRecord} |
    ...    | _RETRIEVE Advanced Check | ${Property_ID} | Property 1 | 97ee7000096c11e29e4f001e4fc86865 | Value 1 | Key Value 1 | RETRIEVE | cde477e962d54753899d97edf11e62cc | ${advancedAuditRecord} |
    log Many    ${advancedAuditRecord}
    # Gets the value from tupleBefore which is XML
    @{tupleBefore}=    Get Element Value    ${advancedAuditRecord}    ${XMLNS REQUEST AUDITING}    tupleBefore
    ${unescaped_XML}=    Parse Escaped Xml    @{tupleBefore}[0]    # Convert to string
    Log    ${unescaped_XML}
    ${tupleRequest}=    Get Element Xml    ${unescaped_XML}    ${None}    tuple
    # Takes the values from the 'tupleBefore' XML
    @{hubIdlist}=    Get Element Value    ${unescaped_XML}    ${None}    hubId
    ${hubId}=    Set Variable    @{hubIdlist}[0]    # Convert to string
    @{tupleKeyPropertyValuelist}=    Get Element Value    ${tupleRequest}    ${None}    tupleKeyPropertyValue
    ${tupleKeyPropertyValue}=    Set Variable    @{tupleKeyPropertyValuelist}[0]    # Convert to string
    @{tupleTermIdlist}=    Get Element Value    ${tupleRequest}    ${None}    tupleTermId
    ${tupleTermId}=    Set Variable    @{tupleTermIdlist}[0]    # Convert to string
    @{tupleTupleIdlist}=    Get Element Value    ${tupleRequest}    ${None}    tupleTupleId
    ${tupleTupleId}=    Set Variable    @{tupleTupleIdlist}[0]    # Convert to string
    @{tupleRequestTypelist}=    Get Element Value    ${unescaped_XML}    ${None}    tupleRequestType
    ${tupleRequestType}=    Set Variable    @{tupleRequestTypelist}[0]    # Convert to string
    # Check Values match test input
    # Retrieved    Supplied
    Should Be Equal As Strings    ${hubId}    ${ASSET_HUB_ID}    # Global Variable
    Should Be Equal As Strings    ${tupleKeyPropertyValue}    ${Key_Property_Text}
    Should Be Equal As Strings    ${tupleTermId}    ${Term_ID}
    Should Be Equal As Strings    ${tupleTupleId}    ${Tuple_ID}
    Should Be Equal As Strings    ${tupleRequestType}    ${Action}

_DELETE Advanced check
    [Arguments]    ${Term_ID}    ${Key_Property_Text}    ${Action}    ${Tuple_ID}    ${advancedAuditRecord}
    [Documentation]    This takes the advanced result XML from 'Return Audit Values' and splits into the component parts. Comparing the sub components with the supplied inputs
    ...
    ...    Ran as part of Check Advanced Values Keyword
    ...
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${Property_ID} = The property GUID
    ...
    ...    ${Property_Name} = The property name
    ...
    ...    ${Term_ID} = The term GUID
    ...
    ...    ${Property_Text} = The property value
    ...
    ...    ${Key_Property_Text} = The key property value
    ...
    ...    ${Action} = The CRUDS event type
    ...
    ...    ${Tuple_ID} = The tuple GUID
    ...
    ...    ${advancedAuditRecord} = The advanced record XML
    ...
    ...
    ...
    ...    *Return Values*
    ...
    ...
    ...    None
    ...
    ...
    ...
    ...    *Example*
    ...
    ...
    ...    | _DELETE Advanced Check | ${Property_ID} | ${Property_Name} | ${Term_ID} | ${Property_Text} | ${Key_Property_Text} | ${Action} | ${Tuple_ID} | ${advancedAuditRecord} |
    ...    | _DELETE Advanced Check | ${Property_ID} | Property 1 | 97ee7000096c11e29e4f001e4fc86865 | Value 1 | Key Value 1 | DELETE | cde477e962d54753899d97edf11e62cc | ${advancedAuditRecord} |
    log Many    ${advancedAuditRecord}
    # Gets the value from tupleBefore which is XML
    @{tupleBefore}=    Get Element Value    ${advancedAuditRecord}    ${XMLNS REQUEST AUDITING}    tupleBefore
    ${unescaped_XML}=    Parse Escaped Xml    @{tupleBefore}[0]    # Convert to string
    Log    ${unescaped_XML}
    ${tupleRequest}=    Get Element Xml    ${unescaped_XML}    ${None}    tuple
    # Takes the values from the 'tupleBefore' XML
    @{hubIdlist}=    Get Element Value    ${unescaped_XML}    ${None}    hubId
    ${hubId}=    Set Variable    @{hubIdlist}[0]    # Convert to string
    @{tupleKeyPropertyValuelist}=    Get Element Value    ${tupleRequest}    ${None}    tupleKeyPropertyValue
    ${tupleKeyPropertyValue}=    Set Variable    @{tupleKeyPropertyValuelist}[0]    # Convert to string
    @{tupleTermIdlist}=    Get Element Value    ${tupleRequest}    ${None}    tupleTermId
    ${tupleTermId}=    Set Variable    @{tupleTermIdlist}[0]    # Convert to string
    @{tupleTupleIdlist}=    Get Element Value    ${tupleRequest}    ${None}    tupleTupleId
    ${tupleTupleId}=    Set Variable    @{tupleTupleIdlist}[0]    # Convert to string
    @{tupleRequestTypelist}=    Get Element Value    ${unescaped_XML}    ${None}    tupleRequestType
    ${tupleRequestType}=    Set Variable    @{tupleRequestTypelist}[0]    # Convert to string
    # Check Values match test input
    Should Be Equal As Strings    ${hubId}    ${ASSET_HUB_ID}    # Global Variable
    Should Be Equal As Strings    ${tupleKeyPropertyValue}    ${Key_Property_Text}
    Should Be Equal As Strings    ${tupleTermId}    ${Term_ID}
    Should Be Equal As Strings    ${tupleTupleId}    ${Tuple_ID}
    Should Be Equal As Strings    ${tupleRequestType}    ${Action}

_POST Audit Request 401
    [Arguments]    ${audit property XML}
    [Documentation]    Posts the Audit Request Body XML created within the 'Set Audit Request Body' Keyword
    ...
    ...    This keyword is used part of Request Audit 401 to check unauthorised access to audit log entries
    ...
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${audit property XML}
    ...
    ...    *Return Values*
    ...
    ...
    ...    ${Audit Response Body}
    _Request Setup 401    # Sets the Username and Password, as well as the server    Run from audit services resource not tuple services
    Set Request Body    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>${audit property XML}    # Forms the XML body
    Log    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>${audit property XML}
    Next Request Should Not Succeed
    POST    ${REST URL END}    # Sends the XML body to the auditing REST service URL using the POST method
    Response Status Code Should Equal    401
    ${Audit Response Body}=    Get Response Body    # Recieves the response XML
    [Return]    ${Audit Response Body}

_Request Setup 401
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
    ...
    ...    This keyword is used as part of POST Audit Request 401, to check unauthorised access to audit log entries.
    Create Http Context    ${SERVER}:${WEB_SERVICE_PORT}    ${WEB_SERVICE_HTTP_SCHEME}
    Set Basic Auth    ${VIEW USER}    ${BAD PARAMETER}
    Set Request Header    Content-Type    application/xml;charset=utf-8

_POST Audit Request with User
    [Arguments]    ${audit property XML}    ${401 USER}    ${401 PASS}
    [Documentation]    Posts the Audit Request Body XML created within the 'Set Audit Request Body' Keyword
    ...
    ...    This keyword is used part of Request Audit 401 to check unauthorised access to audit log entries
    ...
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${audit property XML}
    ...
    ...    *Return Values*
    ...
    ...
    ...    ${Audit Response Body}
    _Request Setup with User    ${401 USER}    ${401 PASS}    # Sets the Username and Password, as well as the server    Run from audit services resource not tuple services
    Set Request Body    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>${audit property XML}    # Forms the XML body
    Log    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>${audit property XML}
    POST    ${REST URL END}    # Sends the XML body to the auditing REST service URL using the POST method
    ${Audit Response Body}=    Get Response Body    # Recieves the response XML
    [Return]    ${Audit Response Body}

_Request Setup with User
    [Arguments]    ${401 USER}    ${401 PASS}
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
    ...
    ...    This keyword is used as part of POST Audit Request 401, to check unauthorised access to audit log entries.
    Create Http Context    ${SERVER}:${WEB_SERVICE_PORT}    ${WEB_SERVICE_HTTP_SCHEME}
    Set Basic Auth    ${401 USER}    ${401 PASS}
    Set Request Header    Content-Type    application/xml;charset=utf-8

Request Audit with User 401
    [Arguments]    ${auditId}=${EMPTY}    ${tupleId}=${EMPTY}    ${transactionId}=${EMPTY}    ${user}=${EMPTY}    ${auditTimestamp}=${EMPTY}    ${auditAction}=${EMPTY}
    ...    ${auditText}=${EMPTY}    ${auditDataView}=BASIC    ${401 USER}=${EMPTY}    ${401 PASS}=${EMPTY}
    [Documentation]    This keyword sets the parameters and POSTs an audit query and returns the response body, passing if the request recieves a 401 HTTP error
    ...
    ...    *THIS IS USED FOR AN UNAUTHORISED username/pw COMBO only*
    ...
    ...
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${tupleId} = An ID assigned to a Tuple on creation
    ...
    ...    ${transactionId} = An ID assigned to the change event in the database
    ...
    ...    ${auditAction} = The Tuple event; CREATE, RETRIEVE, UPDATE, DELETE, SEARCH
    ...
    ...    ${auditText} = The human readable format of the Tuple event
    ...
    ...    ${user} = The user responsible for the event; e.g. Administrator
    ...
    ...    ${auditId} = An ID assigned to an audit log entry
    ...
    ...    ${auditTimestamp} = A date for when the Tuple event originated. Can be a Range; e.g. dd/MM/yy.dd/MM/yy
    ...
    ...    ${auditDataView} = In addition User can specify if the full (BASIC_AND_ADVANCED), or just basic (BASIC) audit data is returned
    ...
    ...
    ...
    ...    *Return Values*
    ...
    ...
    ...    ${Audit Response} = The audit Response
    ${auditSearchParameters}=    Create Xml Object    auditSearchParameters    ${XMLNS REQUEST AUDITING}
    ${tupleIdXML}=    Create Xml Object    tupleId    elementText=${tupleId}
    ${auditDataViewXML}=    Create Xml Object    auditDataView    elementText=${auditDataView}
    ${transactionIdXML}=    Create Xml Object    transactionId    elementText=${transactionId}
    ${auditActionXML}=    Create Xml Object    auditAction    elementText=${auditAction}
    ${auditTextXML}=    Create Xml Object    auditText    elementText=${auditText}
    ${userXML}=    Create Xml Object    user    elementText=${user}
    ${auditIdXML}=    Create Xml Object    auditId    elementText=${auditId}
    ${auditTimestampXML}=    Create Xml Object    auditTimestamp    elementText=${auditTimestamp}
    # Add XML items together
    ${audit property XML}=    Add Subelement To Xml    ${auditSearchParameters}    ${tupleIdXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${auditDataViewXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${transactionIdXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${auditActionXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${auditTextXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${userXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${auditIdXML}
    ${audit property XML}=    Add Subelement To Xml    ${audit property XML}    ${auditTimestampXML}
    # Return XML as string
    ${audit property XML}=    Get Xml    ${audit property XML}    ${XMLNS REQUEST AUDITING}
    ${audit xml DEBUG}=    Log    ${audit property XML}
    # POST Request
    ${Audit Response}=    _POST Audit Request with User 401    ${audit property XML}    ${401 USER}    ${401 PASS}    # Keyword from audit services not tuple services
    Log    ${Audit Response}
    [Return]    ${Audit Response}

_POST Audit Request with User 401
    [Arguments]    ${audit property XML}    ${401 USER}    ${401 PASS}
    [Documentation]    Posts the Audit Request Body XML created within the 'Set Audit Request Body' Keyword
    ...
    ...    This keyword is used part of Request Audit 401 to check unauthorised access to audit log entries
    ...
    ...
    ...    *Arguments*
    ...
    ...
    ...    ${audit property XML}
    ...
    ...    *Return Values*
    ...
    ...
    ...    ${Audit Response Body}
    _Request Setup with User    ${401 USER}    ${401 PASS}    # Sets the Username and Password, as well as the server    Run from audit services resource not tuple services
    Set Request Body    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>${audit property XML}    # Forms the XML body
    Log    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>${audit property XML}
    Next Request Should Not Succeed
    POST    ${REST URL END}    # Sends the XML body to the auditing REST service URL using the POST method
    Response Status Code Should Equal    401
    ${Audit Response Body}=    Get Response Body    # Recieves the response XML
    [Return]    ${Audit Response Body}
