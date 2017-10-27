*** Settings ***
Library           ServerControlLibrary

*** Variables ***
${ROOT_DIR}       C:/EWB Automated Tests

*** Keywords ***
Submit Thick Client Smoke Tests
    [Arguments]    ${client}    ${server}    ${db_server}    ${oracle_sid}    ${thick_client_port}=8443    ${Machine_OS}=Win7
    ...    ${Bit}=64bit    ${additional_run_arguments}=${EMPTY}
    [Documentation]    Submits the 64-bit smoke tests. Specifically:
    ...
    ...    - Smoke Tests
    ...    - Search Tests
    ...    - Workflow Tests
    ...
    ...    NOTE: This keyword does not submit config tests
    ${run_arguments}=    Set Variable    --variable SERVER:${server} --variable DB_SERVER:${db_server} --variable ORACLE_SID:${oracle_sid} --variable THICK_CLIENT_PORT:${thick_client_port} --variable MACHINE_OS:${Machine_OS} --variable BIT:${Bit} --settag desktop_client --settag Thick_Client --settag ${Bit} --settag ${Machine_OS} ${additional_run_arguments}
    Submit Robot Testsuite    ${client}    C:\\EWB Automated Tests\\Test Suites\\Thick Client\\Smoke Tests\\Smoke Test.txt    ${run_arguments} --name Smoke_Test_${Machine_OS}_${Bit}    timeout=3600s
    Submit Robot Testsuite    ${client}    C:\\EWB Automated Tests\\Test Suites\\Thick Client\\Smoke Tests\\Search Test.txt    ${run_arguments} --name Search_Test_${Machine_OS}_${Bit}    timeout=900s
    Submit Robot Testsuite    ${client}    C:\\EWB Automated Tests\\Test Suites\\Thick Client\\Smoke Tests\\Workflow Tests.txt    ${run_arguments} --name Workflow_Tests_${Machine_OS}_${Bit}    timeout=3600s

Submit Thick Client Config Smoke Tests
    [Arguments]    ${client}    ${server}    ${db_server}    ${oracle_sid}    ${thick_client_port}=8443    ${Machine_OS}=Win7
    ...    ${Bit}=64bit    ${additional_run_arguments}=${EMPTY}
    [Documentation]    Submits the 64-bit configuration smoke tests. These tests alter global EWB configurations and should be run in isolation from other test suites to minimise intereference with other suites.
    ${run_arguments}=    Set Variable    --variable SERVER:${server} --variable DB_SERVER:${db_server} --variable ORACLE_SID:${oracle_sid} --variable THICK_CLIENT_PORT:${thick_client_port} --variable MACHINE_OS:${Machine_OS} --variable BIT:${Bit} --settag desktop_client --settag Thick_Client --settag ${Bit} --settag ${Machine_OS} ${additional_run_arguments}
    Submit Robot Testsuite    ${client}    C:\\EWB Automated Tests\\Test Suites\\Thick Client\\Smoke Tests\\Configuration Test.txt    ${run_arguments} --name Configuration_Test_${Machine_OS}_${Bit}    timeout=600
    Submit Robot Testsuite    ${client}    C:\\EWB Automated Tests\\Test Suites\\Thick Client\\Smoke Tests\\Post Test Actions.txt    ${run_arguments} --name Post_Test_Actions_${Machine_OS}_${Bit}    timeout=600

Submit Asset Hub Regression Tests
    [Arguments]    ${client}    ${server}    ${db_server}    ${oracle_sid}    ${asset_hub_prefix}    ${asset_hub_id}
    ...    ${web_service_port}=8443    ${additional_run_arguments}=${EMPTY}
    [Documentation]    Submits the asset hub regression suites, specifically covering:
    ...
    ...    - Tuple Service
    ...    - Query Service
    ...    - Audit Service
    ...
    ...    *The client argument should be a single machine to ensure tests run sequentially and not in parallel.*
    ${run_arguments}=    Set Variable    --variable SERVER:${server} --variable WEB_SERVICE_PORT:${web_service_port} --variable SERVICES USERNAME:Administrator --variable SERVICES PASSWORD:Administrator --variable ASSET_HUB_ID:${asset_hub_id} --variable DB_SERVER:${db_server} --variable ORACLE_SID:${oracle_sid} --variable ASSET_DB_PREFIX:${asset_hub_prefix} --settag asset_hub ${additional_run_arguments}
    Submit Robot Testsuite    ${client}    C:\\EWB Automated Tests\\Test Suites\\Hubtech\\Asset Hub\\Tuple Web Service\\ASS-NEL-PI008-W001\\ASS-NEL-PI008-W001-1    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client}    C:\\EWB Automated Tests\\Test Suites\\Hubtech\\Asset Hub\\Tuple Web Service\\ASS-NEL-PI008-W001\\ASS-NEL-PI008-W001-2    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client}    C:\\EWB Automated Tests\\Test Suites\\Hubtech\\Asset Hub\\Tuple Web Service\\ASS-NEL-PI008-W001\\EWB-LAP-PI010-T001d_F0064532a_Creation_Operation.txt    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client}    C:\\EWB Automated Tests\\Test Suites\\Hubtech\\Asset Hub\\Tuple Web Service\\ASS-NEL-PI008-W002    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client}    C:\\EWB Automated Tests\\Test Suites\\Hubtech\\Asset Hub\\Tuple Web Service\\ASS-NEL-PI008-W003    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client}    C:\\EWB Automated Tests\\Test Suites\\Hubtech\\Asset Hub\\Tuple Web Service\\ASS-NEL-PI008-W004    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client}    C:\\EWB Automated Tests\\Test Suites\\Hubtech\\Asset Hub\\Tuple Web Service\\ASS-NEL-PI008-W005    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client}    C:\\EWB Automated Tests\\Test Suites\\Hubtech\\Asset Hub\\Tuple Web Service\\ASS-NEL-PI008-W006    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client}    C:\\EWB Automated Tests\\Test Suites\\Hubtech\\Asset Hub\\Tuple Web Service\\Defect Fixes    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client}    C:\\EWB Automated Tests\\Test Suites\\Hubtech\\Asset Hub\\Tuple Web Service\\Landscape Testing    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client}    C:\\EWB Automated Tests\\Test Suites\\Hubtech\\Asset Hub\\Query Web Service    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client}    C:\\EWB Automated Tests\\Test Suites\\Hubtech\\Asset Hub\\Audit_Web_Service    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client}    C:\\EWB Automated Tests\\Test Suites\\Hubtech\\Platform    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client}    C:\\EWB Automated Tests\\Test Suites\\Hubtech\\Tuple Web Service\\ASS-NEL-PI036 - Record Locking    ${run_arguments}    timeout=3600

Submit Web Client New Functionality Tests
    [Arguments]    ${client_list}    ${server}    ${db_server}    ${oracle_sid}    ${browser}=FIREFOX    ${web_client_port}=8443
    ...    ${version_number}=10.2.0    ${firefox_profile_dir}=${ROOT_DIR}/Test Suites/Web Client/Profile Management/    ${additional_run_arguments}=${EMPTY}
    [Documentation]    Submits the web client new functionality tests, covering:
    ...
    ...    - EWB Spreadsheet LITE Editor
    ...
    ...    Note: that the ${client_list} argument can be a list of clients or a single client machine
    ${run_arguments}=    Set Variable    --variable BROWSER:${browser} --variable SERVER:${server} --variable WEB_CLIENT_PORT:${web_client_port} --variable ORACLE_SID:${oracle_sid} --variable FIREFOX_PROFILE_DIR:${firefox_profile_dir} --variable ASSET_DB_PREFIX:${asset_hub_prefix} --variable DB_SERVER:${db_server} --variable VERSION_NUMBER:${version_number} --variable DELAY:0 --settag web_client --settag web_spreadsheet --exclude exclusive_access --exclude requires_desktop ${additional_run_arguments}
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\Embedded_Search    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\Saved_Search    ${run_arguments}    timeout=10800
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\Transform    ${run_arguments}    timeout=18000
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\Catalog    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\Experiment Previews and Printing    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\File_Import    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\Spreadsheet Item    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\Variables    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\Functions    ${run_arguments}    timeout=10800
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\Instruction_Sheet    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\Locale Support    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\Navigation    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\Perspectives    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\Smart_Fill    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\Instrument_Reader    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\Label Printing    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\Asset_Hub\\Asset_Hub_Designer    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\Asset_Hub\\Asset_Hub_Web    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\Audit_Events    ${run_arguments}    timeout=7200
    ${run_arguments}=    Set Variable    --variable BROWSER:${browser} --variable SERVER:${server} --variable WEB_CLIENT_PORT:${web_client_port} --variable ORACLE_SID:${oracle_sid} --variable FIREFOX_PROFILE_DIR:${firefox_profile_dir} --variable DB_SERVER:${db_server} --variable VERSION_NUMBER:${version_number} --variable DELAY:0 --settag web_client --exclude exclusive_access --exclude requires_desktop ${additional_run_arguments}
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\Spreadsheet Editor    ${run_arguments}    timeout=14400

Submit Web and Desktop Regression Tests - ELNCore
    [Arguments]    ${client_list}    ${server}    ${db_server}    ${oracle_sid}    ${browser}=FIREFOX    ${web_client_port}=8443
    ...    ${version_number}=10.2.0    ${firefox_profile_dir}=${ROOT_DIR}/Test Suites/Web Client/Profile Management/    ${additional_run_arguments}=${EMPTY}
    [Documentation]    Submits the web client regression tests *which also require desktop client access*. Covering:
    ...
    ...    - Searching
    ...    - Record Viewing
    ...    - Entity Management
    ...
    ...    Note: that the ${client_list} argument can be a list of clients or a single client machine, but must have the EWB desktop client installed as well as the libraries required for Java desktop client automation (IDBSSwingLibrary).
    ${run_arguments}=    Set Variable    --variable BROWSER:${browser} --variable SERVER:${server} --variable WEB_CLIENT_PORT:${web_client_port} --variable ORACLE_SID:${oracle_sid} --variable FIREFOX_PROFILE_DIR:${firefox_profile_dir} --variable DB_SERVER:${db_server} --variable VERSION_NUMBER:${version_number} --variable DELAY:0 --settag web_client --exclude exclusive_access ${additional_run_arguments}
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Security    ${run_arguments} --include requires_desktop    timeout=7200
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Entity Management\\01-Entity Deletion.txt    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Entity Management\\02-Experiment_Creation.txt    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Entity Management\\03-Experiment Locking.txt    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Entity Management\\05-Non-Record_Creation_And_Editing.txt    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Entity Management\\06-Editing Attributes.txt    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Entity Management\\08-Create_Records_from_Records    ${run_arguments}    timeout=14400
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Entity Management\\09-Create_and_Edit_Templates    ${run_arguments}    timeout=14400
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Entity Management\\11-Create_clones_of_existing_records.txt    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Entity Management\\Move_entities.txt    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Entity Management\\Restore_previous_document_version.txt    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Entity Management\\Restore_previous_record_version.txt    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Entity Management\\Toggle_The_Experiment_Locked_Status.txt    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Entity Management\\View_version_history_for_record.txt    ${run_arguments}    timeout=1800

Submit Web Service Regression Tests
    [Arguments]    ${client_list}    ${server}    ${db_server}    ${oracle_sid}    ${web_service_port}=8443    ${additional_run_arguments}=${EMPTY}
    [Documentation]    Submits the web service tests for the following REST services:
    ...
    ...    - Catalog Service
    ...    - Security Administration Service
    ...    - Workflow Service
    ...    - Record Service
    ...
    ...    Note: that the ${client_list} argument can be a list of clients or a single client machine
    ${run_arguments}=    Set Variable    --variable SERVER:${server} --variable DB_SERVER:${db_server} --variable WEB_SERVICE_PORT:${web_service_port} --variable ORACLE_SID:${oracle_sid} --variable SERVER_NO_PORT:${server} --variable ORACLE_INSTANCE_NAME:${oracle_sid} --settag web_service --settag Services --exclude exclusive_access ${additional_run_arguments}
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Core Web Services\\Workflow_Service    --settag workflow_service ${run_arguments}    timeout=9000
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Core Web Services\\Activity_Feed_Service    --settag activity_feed_service ${run_arguments}    timeout=9000
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Core Web Services\\Entity Version Service    --settag entity_version_service ${run_arguments}    timeout=9000
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Core Web Services\\Security Service    --settag security_service ${run_arguments}    timeout=9000
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Core Web Services\\Cache_Entity_Service    --settag cache_entity_service ${run_arguments}    timeout=9000
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Core Web Services\\Catalog_Service    --settag catalog_service ${run_arguments}    timeout=9000
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Core Web Services\\Entity Config Service    --settag entity_config_service ${run_arguments}    timeout=9000
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Core Web Services\\Entity Lock Service    --settag entity_lock_service ${run_arguments}    timeout=9000
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Core Web Services\\Entity Tree Service    --settag entity_tree_service ${run_arguments}    timeout=9000
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Core Web Services\\Entity_Service    --settag entity_service ${run_arguments}    timeout=9000
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Core Web Services\\Record Service    --settag record_service ${run_arguments}    timeout=9000
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Core Web Services\\Settings Service    --settag settings_service ${run_arguments}    timeout=9000
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Core Web Services\\OAuth_Service    --settag settings_service ${run_arguments}    timeout=9000

Submit Web Service Config Regression Tests
    [Arguments]    ${client_list}    ${server}    ${db_server}    ${oracle_sid}    ${web_service_port}=8443    ${additional_run_arguments}=${EMPTY}
    [Documentation]    Submits the web service tests for the following REST services:
    ...
    ...    - Catalog Service
    ...    - Security Administration Service
    ...    - Workflow Service
    ...    - Record Service
    ...
    ...    Note: that the ${client_list} argument can be a list of clients or a single client machine
    ${run_arguments}=    Set Variable    --variable SERVER:${server} --variable DB_SERVER:${db_server} --variable WEB_SERVICE_PORT:${web_service_port} --variable ORACLE_SID:${oracle_sid} --variable SERVER_NO_PORT:${server} --variable ORACLE_INSTANCE_NAME:${oracle_sid} --settag web_service --settag Services --include exclusive_access ${additional_run_arguments}
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Core Web Services\\Cache_Entity_Service    --settag cache_entity_service ${run_arguments}    timeout=9000
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Core Web Services\\Entity_Service    --settag entity_service ${run_arguments}    timeout=9000

Submit Thick and Web Client Config Smoke Tests
    [Arguments]    ${client}    ${server}    ${db_server}    ${oracle_sid}    ${browser}=FIREFOX    ${thick_client_port}=8443
    ...    ${web_client_port}=8443    ${version_number}=10.1.0    ${firefox_profile_dir}=C:\\SeleniumProfile    ${additional_run_arguments}=${EMPTY}
    [Documentation]    Submits the configuration tests which span both the thick and web clients. These tests alter global EWB configurations and should be run in isolation from other test suites to minimise intereference with other suites.
    ${run_arguments}=    Set Variable    --variable BROWSER:${browser} --variable SERVER:${server} --variable WEB_CLIENT_PORT:${web_client_port} --variable THICK_CLIENT_PORT:${thick_client_port} --variable ORACLE_SID:${oracle_sid} --variable FIREFOX_PROFILE_DIR:${firefox_profile_dir} --variable DB_SERVER:${db_server} --variable VERSION_NUMBER:${version_number} --variable DELAY:0 --include exclusive_access ${additional_run_arguments}
    Submit Robot Testsuite    ${client}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Entity Management\\10-Copying_Records.txt    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Landing and User Pages\\Widgets\\03_-_10_Most_Recent_Widget.txt    ${run_arguments}    timeout=1800

Submit Search Regression Tests
    [Arguments]    ${client_list}    ${server}    ${db_server}    ${oracle_sid}    ${web_service_port}=8443    ${additional_run_arguments}=${EMPTY}
    ...    ${browser}=FIREFOX    ${virtual_env_path}=${EMPTY}
    [Documentation]    Submits the regression tests for Search functionality:
    ...
    ...    Note: that the ${client_list} argument can be a list of clients or a single client machine
    ${run_arguments}=    Set Variable    --variable BROWSER:${browser} --variable SERVER:${server} --variable DB_SERVER:${db_server} --variable WEB_SERVICE_PORT:${web_service_port} --variable ORACLE_SID:${oracle_sid} --variable SERVER_NO_PORT:${server} --variable ORACLE_INSTANCE_NAME:${oracle_sid} --settag web_service --settag Services --exclude exclusive_access ${additional_run_arguments} --exclude Ignore
    ${base_indexing_path}=    Set Variable If    '${virtual_env_path}' != ''    ${virtual_env_path}/Test Suites/Tests/Web Services/Search_Indexing    C:\\Search Tests\\Test Suites\\Tests\\Web Services\\Search_Indexing
    ${base_service_path}=    Set Variable If    '${virtual_env_path}' != ''    ${virtual_env_path}/Test Suites/Tests/Web Services/Search_Services    C:\\Search Tests\\Test Suites\\Tests\\Web Services\\Search_Services
    ${base_client_path}=    Set Variable If    '${virtual_env_path}' != ''    ${virtual_env_path}/Test Suites/Tests/Web Client/Search    C:\\Search Tests\\Test Suites\\Tests\\Web Client\\Search
    ${path_sep}=    Set Variable If    '${virtual_env_path}' != ''    /    \\
    # Search Index Tests
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Clone${path_sep}Item_Attribute.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Clone${path_sep}Record_Attribute.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Clone${path_sep}text_document.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Create${path_sep}Item_Attribute.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Create${path_sep}Record_Attribute.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Create${path_sep}text_document.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Delete${path_sep}Item_Attribute${path_sep}Delete_Attribute.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Delete${path_sep}Item_Attribute${path_sep}Delete_Document.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Delete${path_sep}Item_Attribute${path_sep}Delete_Group.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Delete${path_sep}Item_Attribute${path_sep}Delete_Project.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Delete${path_sep}Item_Attribute${path_sep}Delete_Record.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Delete${path_sep}Record_Attribute${path_sep}Delete_Attribute.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Delete${path_sep}Record_Attribute${path_sep}Delete_Group.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Delete${path_sep}Record_Attribute${path_sep}Delete_Project.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Delete${path_sep}Record_Attribute${path_sep}Delete_Record.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Delete${path_sep}Text_Document${path_sep}delete_document.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Delete${path_sep}Text_Document${path_sep}delete_group.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Delete${path_sep}Text_Document${path_sep}delete_project.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Delete${path_sep}Text_Document${path_sep}delete_record.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Edit${path_sep}Item_Attribute.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Edit${path_sep}Record_Attribute.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Edit${path_sep}text_document.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Move${path_sep}Item_Attribute.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Move${path_sep}Record_Attribute.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Move${path_sep}text_document.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Restore${path_sep}Item_Attribute.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Restore${path_sep}Record_Attribute.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_indexing_path}${path_sep}Restore${path_sep}text_document.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_service_path}${path_sep}text_search${path_sep}verify_different_documents_type_is_searchable.txt    ${run_arguments}    timeout=900
    # Web Services
    Submit Robot Testsuite    ${client_list}    ${base_service_path}${path_sep}Result_Filtering${path_sep}filter_by_creator_verification_after_editing.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_service_path}${path_sep}advanced_search.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_service_path}${path_sep}check_chemistry_db_indexing.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_service_path}${path_sep}check_chemistry_searching.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_service_path}${path_sep}chemaxon_integration_and_indexing.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_service_path}${path_sep}enable_search_within_ewb_webapp_no_nodejs.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_service_path}${path_sep}search_results.txt    ${run_arguments}    timeout=900
    #Web Client
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Advanced_Search${path_sep}Catalog_Search${path_sep}catalog_term_property_value_picklist.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Advanced_Search${path_sep}Catalog_Search${path_sep}find_catalog_search_term_via_typeahead.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Advanced_Search${path_sep}Catalog_Search${path_sep}measure_level_advanced_search_term.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Advanced_Search${path_sep}advanced_search_terms_limitation.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Advanced_Search${path_sep}edit_search.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Advanced_Search${path_sep}searching_with_ancestral_type_entities.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Advanced_Search${path_sep}template_search_term.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Advanced_Search${path_sep}verify_disable_and_enable_query_criteria.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Advanced_Search${path_sep}verify_match_all_search_terms_in_same_item.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Advanced_Search${path_sep}verify_operator_dropdown_content.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Advanced_Search${path_sep}verify_select_search_terms.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Chemistry_Search${path_sep}Cancel_MarvinJS_Button_Verification.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Chemistry_Search${path_sep}Chemistry_Search_Result_Filtering.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Chemistry_Search${path_sep}Perform_Search.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Chemistry_Search${path_sep}Verify Chemistry Benzene Button.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Chemistry_Search${path_sep}Verify_Prepreview_Chemistry_Search_Result_Screen.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Chemistry_Search${path_sep}Verify_Toasts.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Save_Search${path_sep}Save_Search_To_Navigator${path_sep}restore_search_from_navigator.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Save_Search${path_sep}Save_Search_To_Navigator${path_sep}save_search_to_navigator.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Save_Search${path_sep}Set_Saved_Search_As_Default${path_sep}could_be_only_one_default_search.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Save_Search${path_sep}Set_Saved_Search_As_Default${path_sep}verify_no_default_searches.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Save_Search${path_sep}Set_Saved_Search_As_Default${path_sep}verify_old_default_search.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Save_Search${path_sep}delete_saved_search_from_my_searches.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Save_Search${path_sep}display_list_of_saved_searches.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Save_Search${path_sep}edit_saved_search_in_my_searches.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Save_Search${path_sep}saving_search.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Save_Search${path_sep}update_a_saved_search.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Searched_Experiment_Preview${path_sep}experiment_list.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Searched_Experiment_Preview${path_sep}experiment_preview.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Text_Search${path_sep}Spreadsheet${path_sep}text_search_for_draft_saved_spreadsheet.txt    ${run_arguments}    timeout=900
    Submit Robot Testsuite    ${client_list}    ${base_client_path}${path_sep}Text_Search${path_sep}Spreadsheet${path_sep}text_search_for_spreadsheet.txt    ${run_arguments}    timeout=900

Submit Web Client Spreadsheet Regression Tests
    [Arguments]    ${client_list}    ${server}    ${db_server}    ${oracle_sid}    ${browser}=FIREFOX    ${web_client_port}=8443
    ...    ${version_number}=10.2.0    ${firefox_profile_dir}=${ROOT_DIR}/Test Suites/Web Client/Profile Management/    ${additional_run_arguments}=${EMPTY}    ${virtual_env_path}=${EMPTY}    ${db_private_ip}=${EMPTY}
    [Documentation]    Submits the web client new functionality tests, covering:
    ...
    ...    - EWB Spreadsheet LITE Editor
    ...
    ...    Note: that the ${client_list} argument can be a list of clients or a single client machine
    Set Variable If    not '${db_private_ip}'    ${db_server}    ${db_private_ip}
    ${run_arguments}=    Set Variable    --variable BROWSER:${browser} --variable SERVER:${server} --variable WEB_CLIENT_PORT:${web_client_port} --variable ORACLE_SID:${oracle_sid} --variable FIREFOX_PROFILE_DIR:${firefox_profile_dir} --variable ASSET_DB_PREFIX:${asset_hub_prefix} --variable DB_SERVER:${db_server} --variable DB_SERVER_PRIVATE_IP:${db_private_ip} --variable VERSION_NUMBER:${version_number} --variable DELAY:0 --settag web_client --settag web_spreadsheet --exclude exclusive_access --exclude requires_desktop ${additional_run_arguments}
    ${base_path}=    Set Variable If    '${virtual_env_path}' != ''    ${virtual_env_path}/EWB/Test Suites/Web Client/EWB Web - Spreadsheet    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet
    ${web_service_base_path}=    Set Variable If    '${virtual_env_path}' != ''    ${virtual_env_path}/EWB/Test Suites/Core Web Services    C:\\EWB Automated Tests\\Test Suites\\Core Web Services
    ${path_sep}=    Set Variable If    '${virtual_env_path}' != ''    /    \\
    Submit Transform Web Client Tests    ${client_list}    ${run_arguments}    ${base_path}    ${path_sep}
    Submit Web Client Spreadsheet Saved Search Tests    ${client_list}    ${run_arguments}    ${base_path}    ${path_sep}
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Smart_Fill    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Spreadsheet Editor    ${run_arguments}    timeout=14400
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Spreadsheet Item    ${run_arguments}    timeout=3600
    Submit Web Client Spreadsheet Catalog Tests    ${client_list}    ${run_arguments}    ${base_path}    ${path_sep}
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Embedded_Search    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}File_Import    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Functions    ${run_arguments}    timeout=10800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Curve_Fitting    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Open_Editors    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    ${web_service_base_path}${path_sep}Spreadsheet Specific Service Tests    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Experiment Previews and Printing    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Locale Support    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Asset_Hub    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Quantrix Feature Checks    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Variables    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Instruction_Sheet    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Perspectives    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Live_LookUp    ${run_arguments}    timeout=3600

Submit Web Client Performance Tests
    [Arguments]    ${client_list}    ${server}    ${db_server}    ${oracle_sid}    ${browser}=FIREFOX    ${web_client_port}=8443
    ...    ${version_number}=10.2.0    ${firefox_profile_dir}=${ROOT_DIR}/Test Suites/Web Client/Profile Management/    ${additional_run_arguments}=${EMPTY}    ${virtual_env_path}=${EMPTY}
    [Documentation]    Submits the web client regression tests, covering all aspects of the web client. Note that any suites requiring the use of the desktop client for testing or setup purposes are found in "Submit Web and Desktop Regression Tests"
    ...
    ...    Note: that the ${client_list} argument can be a list of clients or a single client machine
    ${run_arguments}=    Set Variable    --variable BROWSER:${browser} --variable SERVER:${server} --variable WEB_CLIENT_PORT:${web_client_port} --variable ORACLE_SID:${oracle_sid} --variable FIREFOX_PROFILE_DIR:${firefox_profile_dir} --variable DB_SERVER:${db_server} --variable VERSION_NUMBER:${version_number} --variable DELAY:0 --settag web_client --exclude exclusive_access --exclude requires_desktop ${additional_run_arguments}
    ${base_path}=    Set Variable If    '${virtual_env_path}' != ''    ${virtual_env_path}/EWB/Test Suites/Web Client    C:\\EWB Automated Tests\\Test Suites\\Web Client
    ${path_sep}=    Set Variable If    '${virtual_env_path}' != ''    /    \\
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB-Web - Performance Smoke Checks    ${run_arguments}    timeout=18000

Submit Thick Client Performance Tests
    [Arguments]    ${client}    ${server}    ${db_server}    ${oracle_sid}    ${thick_client_port}=8443    ${Machine_OS}=Win7
    ...    ${Bit}=64bit    ${additional_run_arguments}=${EMPTY}
    [Documentation]    Submits the 64-bit performance tests.
    ${run_arguments}=    Set Variable    --variable SERVER:${server} --variable DB_SERVER:${db_server} --variable ORACLE_SID:${oracle_sid} --variable THICK_CLIENT_PORT:${thick_client_port} --variable MACHINE_OS:${Machine_OS} --variable BIT:${Bit} --settag desktop_client --settag Thick_Client --settag ${Bit} --settag ${Machine_OS} ${additional_run_arguments}
    Submit Robot Testsuite    ${client}    C:\\EWB Automated Tests\\Test Suites\\Thick Client\\Smoke Tests\\Performance Smoke Checks.txt    ${run_arguments} --name Performance_Smoke_Checks_${Machine_OS}_${Bit}    timeout=3600s

Submit Web and Desktop Regression Tests - Spreadsheet
    [Arguments]    ${client_list}    ${server}    ${db_server}    ${oracle_sid}    ${browser}=FIREFOX    ${web_client_port}=8443
    ...    ${version_number}=10.2.0    ${firefox_profile_dir}=${ROOT_DIR}/Test Suites/Web Client/Profile Management/    ${additional_run_arguments}=${EMPTY}    ${TIER_LEVEL}=${EMPTY}    ${db_private_ip}=${EMPTY}
    [Documentation]    Submits the web client regression tests *which also require desktop client access*. Covering:
    ...
    ...    - Searching
    ...    - Record Viewing
    ...    - Entity Management
    ...
    ...    Note: that the ${client_list} argument can be a list of clients or a single client machine, but must have the EWB desktop client installed as well as the libraries required for Java desktop client automation (IDBSSwingLibrary).
    Set Variable If    not '${db_private_ip}'    ${db_server}    ${db_private_ip}
    ${run_arguments}=    Set Variable    --variable BROWSER:${browser} --variable SERVER:${server} --variable WEB_CLIENT_PORT:${web_client_port} --variable ORACLE_SID:${oracle_sid} --variable FIREFOX_PROFILE_DIR:${firefox_profile_dir} --variable DB_SERVER:${db_server} --variable DB_SERVER_PRIVATE_IP:${db_private_ip} --variable VERSION_NUMBER:${version_number} --variable DELAY:0 --settag web_client --exclude exclusive_access ${additional_run_arguments} --variable ROOT_DIR:${ROOT_DIR}
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\EWB_Permissions    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\Spreadsheet_Tidy-Up_Actions    ${run_arguments}    timeout=3600
    Submit Transform Desktop Client Tests    ${client_list}    ${run_arguments}
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\Generic_Transforms    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\SQL_DataLinks    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\Audit_Events    ${run_arguments}    timeout=7200

Submit Spreadsheet Tests
    [Arguments]    ${client_list}    ${server}    ${db_server}    ${oracle_sid}    ${browser}=FIREFOX    ${web_client_port}=8443
    ...    ${version_number}=10.2.0    ${firefox_profile_dir}=${ROOT_DIR}/Test Suites/Web Client/Profile Management/    ${additional_run_arguments}=${EMPTY}    ${virtual_env_path}=${EMPTY}
    ${run_arguments}=    Set Variable    --variable BROWSER:${browser} --variable SERVER:${server} --variable WEB_CLIENT_PORT:${web_client_port} --variable ORACLE_SID:${oracle_sid} --variable FIREFOX_PROFILE_DIR:${firefox_profile_dir} --variable ASSET_DB_PREFIX:${asset_hub_prefix} --variable DB_SERVER:${db_server} --variable VERSION_NUMBER:${version_number} --variable DELAY:0 --settag web_client --settag web_spreadsheet --include tier_1_spreadsheet_smoke_test
    ${base_path}=    Set Variable If    '${virtual_env_path}' != ''    ${virtual_env_path}/EWB/Test Suites/Web Client/EWB Web - Spreadsheet    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet
    ${path_sep}=    Set Variable If    '${virtual_env_path}' != ''    /    \\
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Audit_Events    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Experiment Previews and Printing    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Asset_Hub${path_sep}Asset_Hub_Web    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Saved_Search    ${run_arguments}    timeout=10800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Transform    ${run_arguments}    timeout=18000
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Open_Editors    ${run_arguments}    timeout=3600

Submit MS Office Reliant Tests
    [Arguments]    ${client}    ${server}    ${db_server}    ${oracle_sid}    ${thick_client_port}=8443    ${Machine_OS}=Win7
    ...    ${Bit}=64bit    ${additional_run_arguments}=${EMPTY}
    ${run_arguments}=    Set Variable    --variable SERVER:${server} --variable DB_SERVER:${db_server} --variable ORACLE_SID:${oracle_sid} --variable THICK_CLIENT_PORT:${thick_client_port} --variable MACHINE_OS:${Machine_OS} --variable BIT:${Bit} --settag desktop_client --settag Thick_Client --settag ${Bit} --settag ${Machine_OS} ${additional_run_arguments}
    Submit Robot Testsuite    ${client}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Display Pages\\Display Special Characters from Desktop.txt    ${run_arguments} --name Smoke_Test_${Machine_OS}_${Bit} --include requires_desktop    timeout=7200s

Submit Chemistry Regression Tests
    [Arguments]    ${client_list}    ${server}    ${db_server}    ${oracle_sid}    ${browser}=CHROME    ${web_service_port}=8443
    ...    ${additional_run_arguments}=${EMPTY}    ${virtual_env_path}=${EMPTY}
    [Documentation]    Submits the regression tests for Search functionality:
    ...
    ...    Note: that the ${client_list} argument can be a list of clients or a single client machine
    Comment    ${character_encoding}=    Set Variable If    '${DB_SERVER_OS}'.lower()=='linux'    --exclude CHEM_905    ${EMPTY}
    ${DAILY}=    Set Variable If    '${TIER_LEVEL}'.upper()=='DAILY'    ANDDAILY    ${EMPTY}
    ${run_in_multiple_browsers}=    Set Variable If    '${BROWSER_REGRESSION}'.lower()=='true'    ANDbrowser_regression    ${EMPTY}
    ${NO_IE}=    Set Variable If    '${browser}'.upper()=='IE'    --exclude NO_IE    ${EMPTY}
    ${NO_FF}=    Set Variable If    '${browser}'.upper()=='FIREFOX'    --exclude NO_FF    ${EMPTY}
    ${NO_CHROME}=    Set Variable If    '${browser}'.upper()=='CHROME'    --exclude NO_CHROME    ${EMPTY}
    ${NO_SAFARI}=    Set Variable If    '${browser}'.upper()=='SAFARI'    --exclude NO_SAFARI    ${EMPTY}
    ${NO_EDGE}=    Set Variable If    '${browser}'.upper()=='EDGE'    --exclude NO_EDGE    ${EMPTY}
    ${run_arguments}=    Set Variable    --variable BROWSER:${browser} --variable SERVER:${server} --variable DB_SERVER:${db_server} --variable WEB_SERVICE_PORT:${web_service_port} --variable ORACLE_SID:${oracle_sid} --variable SERVER_NO_PORT:${server} --variable ORACLE_INSTANCE_NAME:${oracle_sid} --settag web_service --settag Services --exclude exclusive_access ${additional_run_arguments} --exclude ignore --variable WIDGETS_USERNAME:Administrator --variable WIDGETS_PASSWORD:Administrator ${NO_IE} ${NO_FF} ${NO_CHROME} ${NO_SAFARI} ${NO_EDGE}
    ${base_path}=    Set Variable If    '${virtual_env_path}' != ''    ${virtual_env_path}/Test Suites    C:\\Chemistry Automated Tests\\Test Suites
    ${path_sep}=    Set Variable If    '${virtual_env_path}' != ''    /    \\
    Submit Robot Testsuite    ${client_list}    ${base_path}    ${run_arguments} --include Stoichiometry_calculations${DAILY}${run_in_multiple_browsers}    timeout=7200
    @{suites}=    Create List    Addition_of_more_of_an_existing_component    Addition_of_more_of_an_existing_component_v2    Analytical    Analytical_v2    Cloning_stoichiometry_item
    ...    Compliance_checker_integration    Compound_registration    Compound_registration_v2    Compound_registration_v4_-_Q1_2017    Create_Stoichiometry_Item    Database
    ...    Health_and_safety_data    Health_and_safety_data_v2    Hotlinking    Procedure_Predefined_Phrases    Procedure_write_up    Procedure_write_up_v2
    ...    Procedure_write_up_-_v4-10.2.1    Reagent_look_up    Reagent_look_up_by_structure    Reagent_look_up_by_structure_10.2.1    Reagent_look_up_enhancements_10.2    Reagent_look_up_v2
    ...    Salt_and_Solvate    Saving_Stoichiometry_And_Populating_DB_V2    Searching_enhancements    Securing_Chemistry_Services    Solvent_calculations    Stoichiometry_calculations_V2
    ...    Stoichiometry_enhancements_Q4_2016    Stoichiometry_table_UX_improvements
    : FOR    ${suite}    IN    @{suites}
    \    Submit Robot Testsuite    ${client_list}    ${base_path}    ${run_arguments} --include ${suite}${DAILY}${run_in_multiple_browsers}    timeout=3600

Submit Stickerbook IE11 Browser Regression Tests
    [Arguments]    ${client_list}    ${server}    ${db_server}    ${oracle_sid}    ${browser}=FIREFOX    ${web_client_port}=8443
    ...    ${version_number}=10.2.0    ${firefox_profile_dir}=${ROOT_DIR}/Test Suites/Web Client/Profile Management/    ${additional_run_arguments}=${EMPTY}    ${virtual_env_path}=${EMPTY}
    ${run_arguments}=    Set Variable    --variable BROWSER:${browser} --variable SERVER:${server} --variable WEB_CLIENT_PORT:${web_client_port} --variable ORACLE_SID:${oracle_sid} --variable FIREFOX_PROFILE_DIR:${firefox_profile_dir} --variable DB_SERVER:${db_server} --variable VERSION_NUMBER:${version_number} --variable DELAY:0 --settag web_client --exclude exclusive_access --exclude requires_desktop ${additional_run_arguments}
    ${base_path}=    Set Variable If    '${virtual_env_path}' != ''    ${virtual_env_path}/EWB/Test Suites/Web Client    C:\\EWB Automated Tests\\Test Suites\\Web Client
    ${path_sep}=    Set Variable If    '${virtual_env_path}' != ''    /    \\
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Display Pages    ${run_arguments}    timeout=5400
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Login    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Navigation    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Tagging    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Comments    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Security    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Record Editing    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Sign Off    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Workflows    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Landing and User Pages    ${run_arguments}    timeout=5400
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Account Settings    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Publishing    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Custom Panel Extension    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Chemistry    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Audit Log    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Timezones    ${run_arguments}    timeout=1800

Submit Spreadsheet IE11 Browser Regression Tests
    [Arguments]    ${client_list}    ${server}    ${db_server}    ${oracle_sid}    ${browser}=FIREFOX    ${web_client_port}=8443
    ...    ${version_number}=10.2.0    ${firefox_profile_dir}=${ROOT_DIR}/Test Suites/Web Client/Profile Management/    ${additional_run_arguments}=${EMPTY}    ${virtual_env_path}=${EMPTY}
    [Documentation]    Submits the web client new functionality tests, covering:
    ...
    ...    - EWB Spreadsheet LITE Editor
    ...
    ...    Note: that the ${client_list} argument can be a list of clients or a single client machine
    ${run_arguments}=    Set Variable    --variable BROWSER:${browser} --variable SERVER:${server} --variable WEB_CLIENT_PORT:${web_client_port} --variable ORACLE_SID:${oracle_sid} --variable FIREFOX_PROFILE_DIR:${firefox_profile_dir} --variable ASSET_DB_PREFIX:${asset_hub_prefix} --variable DB_SERVER:${db_server} --variable VERSION_NUMBER:${version_number} --variable DELAY:0 --settag web_client --settag web_spreadsheet --exclude exclusive_access --exclude requires_desktop ${additional_run_arguments}
    ${base_path}=    Set Variable If    '${virtual_env_path}' != ''    ${virtual_env_path}/EWB/Test Suites/Web Client/EWB Web - Spreadsheet    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet
    ${path_sep}=    Set Variable If    '${virtual_env_path}' != ''    /    \\
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Spreadsheet Item    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Embedded_Search    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Saved_Search    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Transform    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Catalog    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Experiment Previews and Printing    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}File_Import    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Variables    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Functions    ${run_arguments}    timeout=10800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Instruction_Sheet    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Locale Support    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Perspectives    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Smart_Fill    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Instrument_Reader    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Asset_Hub${path_sep}Asset_Hub_Designer    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Asset_Hub${path_sep}Asset_Hub_Web    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Audit_Events    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Spreadsheet Editor    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Label Printing    ${run_arguments}    timeout=1800
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Open_Editors    ${run_arguments}    timeout=1800

Submit Extra Web Service Regression Tests
    [Arguments]    ${client_list}    ${server}    ${db_server}    ${oracle_sid}    ${web_service_port}=8443    ${additional_run_arguments}=${EMPTY}
    ${run_arguments}=    Set Variable    --variable SERVER:${server} --variable DB_SERVER:${db_server} --variable WEB_SERVICE_PORT:${web_service_port} --variable ORACLE_SID:${oracle_sid} --variable SERVER_NO_PORT:${server} --variable ORACLE_INSTANCE_NAME:${oracle_sid} --settag web_service --settag Services --exclude exclusive_access ${additional_run_arguments}
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Core Web Services\\Record Service - Retrieve Published PDF of a Record    --settag workflow_service ${run_arguments}    timeout=9000

Submit Extra ELNCore Tests
    [Arguments]    ${client_list}    ${server}    ${db_server}    ${oracle_sid}    ${browser}=FIREFOX    ${web_client_port}=8443
    ...    ${version_number}=10.2.0    ${firefox_profile_dir}=${ROOT_DIR}/Test Suites/Web Client/Profile Management/    ${additional_run_arguments}=${EMPTY}    ${virtual_env_path}=${EMPTY}
    [Documentation]    Submits the web client regression tests, covering all aspects of the web client. Note that any suites requiring the use of the desktop client for testing or setup purposes are found in "Submit Web and Desktop Regression Tests"
    ...
    ...    Note: that the ${client_list} argument can be a list of clients or a single client machine
    ${run_arguments}=    Set Variable    --variable BROWSER:${browser} --variable SERVER:${server} --variable WEB_CLIENT_PORT:${web_client_port} --variable ORACLE_SID:${oracle_sid} --variable FIREFOX_PROFILE_DIR:${firefox_profile_dir} --variable DB_SERVER:${db_server} --variable VERSION_NUMBER:${version_number} --variable DELAY:0 --settag web_client --exclude exclusive_access --exclude requires_desktop ${additional_run_arguments}
    ${base_path}=    Set Variable If    '${virtual_env_path}' != ''    ${virtual_env_path}/EWB/Test Suites/Web Client    C:\\EWB Automated Tests\\Test Suites\\Web Client
    ${path_sep}=    Set Variable If    '${virtual_env_path}' != ''    /    \\
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Business Scenarios    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Entity Management\\10-Copying_Records.txt    ${run_arguments}    timeout=1800

Submit Transform Desktop Client Tests
    [Arguments]    ${client_list}    ${run_arguments}
    Submit Robot Testsuite    ${client_list}    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet\\Transform\\Stop_invalid_data_from_transforming.txt    ${run_arguments}    timeout=3600

Submit Transform Web Client Tests
    [Arguments]    ${client_list}    ${run_arguments}    ${base_path}    ${path_sep}
    ${transform_root}=    Set Variable    ${base_path}${path_sep}Transform
    Submit Robot Testsuite    ${client_list}    ${transform_root}${path_sep}Dimensional Context.txt    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    ${transform_root}${path_sep}Context_Data_to_include.txt    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    ${transform_root}${path_sep}Measure's Context.txt    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    ${transform_root}${path_sep}Measure_Data_to_include.txt    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    ${transform_root}${path_sep}Non-Display Property Included in Measure's Context.txt    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    ${transform_root}${path_sep}Shared_data_category.txt    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    ${transform_root}${path_sep}Treatment_Groups.txt    ${run_arguments}    timeout=3600

Submit Web Client Spreadsheet Saved Search Tests
    [Arguments]    ${client_list}    ${run_arguments}    ${base_path}    ${path_sep}
    ${saved_search_root}=    Set Variable    ${base_path}${path_sep}Saved_Search${path_sep}
    Submit Robot Testsuite    ${client_list}    ${saved_search_root}Dimensional_Context_Searching.txt    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    ${saved_search_root}Entity Searches.txt    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    ${saved_search_root}Grouped_Queries.txt    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    ${saved_search_root}Measure_Searches.txt    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    ${saved_search_root}Parameterised_Search_Web.txt    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    ${saved_search_root}Web_Editor_-_Running Searches.txt    ${run_arguments}    timeout=7200

Submit Web Client Spreadsheet Catalog Tests
    [Arguments]    ${client_list}    ${run_arguments}    ${base_path}    ${path_sep}
    [Documentation]    runs all catalog tests
    ${catalog_root}=    Set Variable    ${base_path}${path_sep}Catalog${path_sep}
    Submit Robot Testsuite    ${client_list}    ${catalog_root}Apply_Catalog_Mappings_with_Type-Ahead.txt    ${run_arguments}    timeout=1000
    Submit Robot Testsuite    ${client_list}    ${catalog_root}Auto-ID cross spreadsheet interaction.txt    ${run_arguments}    timeout=1000
    Submit Robot Testsuite    ${client_list}    ${catalog_root}Auto-ID.txt    ${run_arguments}    timeout=1000
    Submit Robot Testsuite    ${client_list}    ${catalog_root}Define_via_Type-ahead.txt    ${run_arguments}    timeout=1000
    Submit Robot Testsuite    ${client_list}    ${catalog_root}Formats_and_Constraints.txt    ${run_arguments}    timeout=1000
    Submit Robot Testsuite    ${client_list}    ${catalog_root}Manual_Resynch.txt    ${run_arguments}    timeout=1000
    Submit Robot Testsuite    ${client_list}    ${catalog_root}Mapping_Panel.txt    ${run_arguments}    timeout=1000
    Submit Robot Testsuite    ${client_list}    ${catalog_root}Map_Existing_Variable.txt    ${run_arguments}    timeout=1000
    Submit Robot Testsuite    ${client_list}    ${catalog_root}Overriding_Format.txt    ${run_arguments}    timeout=1000
    Submit Robot Testsuite    ${client_list}    ${catalog_root}Pick-List_Linking.txt    ${run_arguments}    timeout=1000
    Submit Robot Testsuite    ${client_list}    ${catalog_root}Remove_Mapping.txt    ${run_arguments}    timeout=1000
    Submit Robot Testsuite    ${client_list}    ${catalog_root}Resynch.txt    ${run_arguments}    timeout=1000
    Submit Robot Testsuite    ${client_list}    ${catalog_root}See all catalog mappings.txt    ${run_arguments}    timeout=1000
    Submit Robot Testsuite    ${client_list}    ${catalog_root}See_catalog_Mappings_for_Specific_Field.txt    ${run_arguments}    timeout=1000
    Submit Robot Testsuite    ${client_list}    ${catalog_root}Select_Unit_of_Measurement.txt    ${run_arguments}    timeout=1000
    Submit Robot Testsuite    ${client_list}    ${catalog_root}spreadsheet_catalog_keywords.txt    ${run_arguments}    timeout=1000
    Submit Robot Testsuite    ${client_list}    ${catalog_root}Use_Catalog_to_Define_Allowable_Values.txt    ${run_arguments}    timeout=1000

Submit Web Client ELNCore Regression Tests
    [Arguments]    ${client_list}    ${server}    ${db_server}    ${oracle_sid}    ${browser}=FIREFOX    ${web_client_port}=8443
    ...    ${version_number}=10.2.0    ${firefox_profile_dir}=${ROOT_DIR}/Test Suites/Web Client/Profile Management/    ${additional_run_arguments}=${EMPTY}    ${virtual_env_path}=${EMPTY}
    [Documentation]    Submits the web client regression tests, covering all aspects of the web client. Note that any suites requiring the use of the desktop client for testing or setup purposes are found in "Submit Web and Desktop Regression Tests"
    ...
    ...    Note: that the ${client_list} argument can be a list of clients or a single client machine
    ${run_arguments}=    Set Variable    --variable BROWSER:${browser} --variable SERVER:${server} --variable WEB_CLIENT_PORT:${web_client_port} --variable ORACLE_SID:${oracle_sid} --variable FIREFOX_PROFILE_DIR:${firefox_profile_dir} --variable DB_SERVER:${db_server} --variable VERSION_NUMBER:${version_number} --variable DELAY:0 --settag web_client --exclude exclusive_access --exclude requires_desktop ${additional_run_arguments}
    ${base_path}=    Set Variable If    '${virtual_env_path}' != ''    ${virtual_env_path}/EWB/Test Suites/Web Client    C:\\EWB Automated Tests\\Test Suites\\Web Client
    ${path_sep}=    Set Variable If    '${virtual_env_path}' != ''    /    \\
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Security    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Sign Off    ${run_arguments}    timeout=18000
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Workflows    ${run_arguments}    timeout=18000
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Landing and User Pages    ${run_arguments}    timeout=18000
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Account Settings    ${run_arguments}    timeout=18000
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Audit Log    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Timezones    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Display Pages    ${run_arguments}    timeout=18000
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Login    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Navigation    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Tagging    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Comments    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Record Editing    ${run_arguments}    timeout=14400
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Publishing    ${run_arguments}    timeout=18000
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Custom Panel Extension    ${run_arguments}    timeout=7200
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}EWB Web - Record Viewing    ${run_arguments}    timeout=7200

Submit Core Integrations Tests
    [Arguments]    ${client_list}    ${server}    ${db_server}    ${oracle_sid}    ${browser}=FIREFOX    ${web_client_port}=8443
    ...    ${firefox_profile_dir}=${ROOT_DIR}/Test Suites/Web Client/Profile Management/    ${additional_run_arguments}=${EMPTY}    ${virtual_env_path}=${EMPTY}
    [Documentation]    Submits the web client new functionality tests, covering:
    ...
    ...    - EWB Spreadsheet LITE Editor
    ...
    ...    Note: that the ${client_list} argument can be a list of clients or a single client machine
    ${run_arguments}=    Set Variable    --variable BROWSER:${browser} --variable SERVER:${server} --variable WEB_CLIENT_PORT:${web_client_port} --variable ORACLE_SID:${oracle_sid} --variable FIREFOX_PROFILE_DIR:${firefox_profile_dir} --variable DB_SERVER:${db_server} --variable DELAY:0 --settag web_client ${additional_run_arguments}
    ${base_path}=    Set Variable If    '${virtual_env_path}' != ''    ${virtual_env_path}/EWB/Test Suites/Web Client/EWB Web - Spreadsheet    C:\\EWB Automated Tests\\Test Suites\\Web Client\\EWB Web - Spreadsheet
    ${path_sep}=    Set Variable If    '${virtual_env_path}' != ''    /    \\
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Label Printing    ${run_arguments}    timeout=3600
    Submit Robot Testsuite    ${client_list}    ${base_path}${path_sep}Instrument_Reader    ${run_arguments}    timeout=7200
