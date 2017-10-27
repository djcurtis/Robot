*** Settings ***
Library           String
Library           XMLLibrary
## Library           OracleLibrary
Library           IDBSSelenium2Library
Library           OperatingSystem
Resource          ../User Settings/user_setting_resource.txt

*** Variables ***

*** Keywords ***
Insert Entity Config
    [Arguments]    ${entity id}    ${config type}    ${config data}
    Comment    Creates the function string_to_blob to be used in the INSERT statement as the function utl_raw.cast_to_raw has input size limitation
    Execute    CREATE OR REPLACE FUNCTION string_to_blob(p_config_data IN VARCHAR2) RETURN BLOB IS RESULT BLOB; BEGIN RESULT := utl_raw.cast_to_raw(p_config_data); RETURN(RESULT); END string_to_blob;
    Comment    Inserts the configuration
    Execute    INSERT INTO ENTITY_CONFIGURATIONS (ENTITY_ID, CONFIG_TYPE, CONFIG_DATA) VALUES ('${entity id}', '${config type}', string_to_blob('${config data}'))
    Comment    Drop the function string_to_blob to restore the default number of objects in the database
    Execute    DROP FUNCTION string_to_blob

Delete Entity Config
    [Arguments]    ${entity id}    ${configuration_type}
    ${entity config delete statement}    Set Variable    delete from ENTITY_CONFIGURATIONS where ENTITY_ID = '${entity id}' and config_type = '${configuration_type}'
    Execute    ${entity config delete statement}
    [Return]    ${entity config delete statement}

Replace Entity Config
    [Arguments]    ${entity_id}    ${configuration_type}    ${configuration_xml}
    Connect To Database    ${CORE_USERNAME}    ${CORE_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    Delete Entity Config    ${entity_id}    ${configuration_type}
    Insert Entity Config    ${entity_id}    ${configuration_type}    ${configuration_xml}
    Disconnect From Database

Reset Entity Config
    [Arguments]    ${entity_id}    ${configuration_type}
    Connect To Database    ${POOL_USERNAME}    ${POOL_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    Delete Entity Config    ${entity_id}    ${configuration_type}
    Disconnect From Database

Set Record Config to [default decoration 1]
    [Arguments]    ${entity_id}
    [Documentation]    Keyword configures a record to have the headers, footers, print publishing options and experiment fonts as defined in the [default decoration 1] column of the PDF testing spreadsheet
    ${PATH1}=    Get File    ${CURDIR}/../../../Test Data/Core Web Services/Record Service/default decorations/[default decoration 1]/default decoration1.xml
    ${PATH2}=    Get File    ${CURDIR}/../../../Test Data/Core Web Services/Record Service/default decorations/[default decoration 1]/experiment fonts config placeholder.xml
    ${PATH3}=    Get File    ${CURDIR}/../../../Test Data/Core Web Services/Record Service/default decorations/[default decoration 1]/header and footer config placeholder.xml
    Configure Page Settings    5    5    1    A4
    Replace Entity Config    ${entity_id}    PRINT_PUB_PDF_SETTINGS    ${PATH1}
    Replace Entity Config    ${entity_id}    EXPERIMENT_FONTS    ${PATH2}
    Replace Entity Config    ${entity_id}    HEADERFOOTER    ${PATH3}

Set Record Config to [default decoration 2]
    [Arguments]    ${entity_id}
    [Documentation]    Keyword configures a record to have the headers, footers, print publishing options and experiment fonts as defined in the [default decoration 2] column of the PDF testing spreadsheet
    ${PATH1}=    Get File    ${CURDIR}/../../../Test Data/Core Web Services/Record Service/default decorations/[default decoration 2]/default decoration 2.xml
    ${PATH3}=    Get File    ${CURDIR}/../../../Test Data/Core Web Services/Record Service/default decorations/[default decoration 2]/header and footer config placeholder.xml
    Configure Page Settings    5    5    1    A4
    Replace Entity Config    ${entity_id}    PRINT_PUB_PDF_SETTINGS    ${PATH1}
    Replace Entity Config    ${entity_id}    HEADERFOOTER    ${PATH3}

Set Record Config to [default decoration 3]
    [Arguments]    ${entity_id}
    [Documentation]    Keyword configures a record to have the headers, footers, print publishing options and experiment fonts as defined in the [default decoration 3] column of the PDF testing spreadsheet
    ${PATH1}=    Get File    ${CURDIR}/../../../Test Data/Core Web Services/Record Service/default decorations/[default decoration 3]/default decoration 3.xml
    ${PATH2}=    Get File    ${CURDIR}/../../../Test Data/Core Web Services/Record Service/default decorations/[default decoration 3]/display item properties config placeholder.xml
    ${PATH3}=    Get File    ${CURDIR}/../../../Test Data/Core Web Services/Record Service/default decorations/[default decoration 3]/header and footer config placeholder.xml
    Configure Page Settings    5    5    1    A4
    Replace Entity Config    ${entity_id}    PRINT_PUB_PDF_SETTINGS    ${PATH1}
    Replace Entity Config    ${entity_id}    DISPLAY_ITEM_ATTRIBUTES    ${PATH2}
    Replace Entity Config    ${entity_id}    HEADERFOOTER    ${PATH3}

Configure Page Settings
    [Arguments]    ${v_margin}=15    ${h_margin}=15    ${orientation}=1    ${page_size}=A4    # An orientation of 0 is portrait and 1 is landscape
    [Documentation]    Sets the ful lpage config
    ...
    ...    *Arguments*
    ...    ${v_margin} The vertical margin (default 15)
    ...
    ...    ${h_margin} The horizontal margin (default 15)
    ...
    ...    ${orientation} The orienation (default portrait - 1)
    ...
    ...    ${page_size} The page size (default A4)
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Replace User Setting    vMargin    ${v_margin}
    Replace User Setting    hMargin    ${h_margin}
    Replace User Setting    orientation    ${orientation}
    Replace User Setting    paperSize    ${page_size}
