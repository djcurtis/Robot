*** Settings ***
Documentation     Perform search actions via UI
Library           IDBSHttpLibrary
Library           JSONLibrary
Library           OperatingSystem
Library           Collections
Library           OracleLibrary
Library           FileLibrary
Resource          ../../../../Libraries/Web Client/Selenium/comments_resource.txt
Resource          ../../../../Libraries/Web Client/Selenium/general_resource.txt

*** Keywords ***
Create Search Via API
    [Arguments]    ${requestContent}
    [Documentation]    Create Search Via API by using XML content - ${requestContent}
    # Fetch the search configuration
    ${saved_adv_search}    Get File    ${requestContent}
    # Call the save function
    ${status}    ${response_body}    POST And Response Saved Search    ${SERVICES USERNAME}    ${SERVICES PASSWORD}    ${saved_adv_search}
    # Check PUT response
    Should Start With    ${status}    200 OK

POST And Response Saved Search
    [Arguments]    ${testcase_username}    ${testcase_password}    ${request_body}
    [Documentation]    This keyword constructs the HTTP POST request, from the arguments passed in by the test case, to perform a Save Search operation using the API. The POST response (HTTP status and response body) are passed back as return values to the calling test case.
    Create HTTP Context    ${SERVER}:${WEB_SERVICE_PORT}    ${WEB_SERVICE_HTTP_SCHEME}
    Set Basic Auth    ${testcase_username}    ${testcase_password}
    Set Request Header    content-type    application/json
    Set Request Body    ${request_body}
    POST    /ewb/services/1.0/entities/4/children
    ${status}    Get Response Status
    ${response_body}    Get Response Body
    [Return]    ${status}    ${response_body}

Delete All Searches Via API
    [Documentation]    Remove all Saved My Searches for Administrator user via API
    ${ids}=    Get Search Ids List Via API
    Run KeyWord If    ${ids} == {} or ${ids} == None    log    No Seaved Searched To Delete
    Return From Keyword if    ${ids} == {} or ${ids} == None
    ${count}=    Get Length    ${ids}
    : FOR    ${i}    IN RANGE    ${count}
    \    Delete Search By Ids Via API    ${ids[${i}]}    ${SERVICES USERNAME}    ${SERVICES PASSWORD}

Get Search Ids List Via API
    [Documentation]    Get List of search ids for Administrator user via API. Return ${Ids} list.
    Create HTTP Context    ${SERVER}:${WEB_SERVICE_PORT}    ${WEB_SERVICE_HTTP_SCHEME}
    Set Basic Auth    ${SERVICES USERNAME}    ${SERVICES PASSWORD}
    Set Request Header    accept    application/json
    Set Request Header    content-type    application/json
    GET    /ewb/services/1.0/entitytree/4/
    ${responseBody}    Get Response Body
    ${Ids}=    Create List
    ${l}=    Get length    ${responseBody}
    Return From keyword If    ${l} < 4
    ${Ids}=    Parse All Search JSON    ${responseBody}
    [Return]    ${Ids}

Delete Search By Ids Via API
    [Arguments]    ${id}    ${testcase_username}    ${testcase_password}
    [Documentation]    Remove saved search based on its id - ${id}. Username- ${testcase_username} and password ${testcase_password} need to be specified.
    Create HTTP Context    ${SERVER}:${WEB_SERVICE_PORT}    ${WEB_SERVICE_HTTP_SCHEME}
    Set Basic Auth    ${testcase_username}    ${testcase_password}
    Set Request Header    accept    application/json
    Set Request Header    content-type    application/json
    Set Request Body    {"reason": "Delete from My Search", "additionalComment": ""}
    ${url}=    catenate    SEPARATOR=    /ewb/services/1.0/entities/    ${id}    /delete
    log    deleteing SavedSearch with id= ${id}
    POST    ${url}
    # Check DELETE result
    ${status}=    Get Response Status

Parse All Search JSON
    [Arguments]    ${responseBody}
    [Documentation]    Parse JSON to get saved search id list.
    ...    ${responceBody} - JSON to parse
    ...    ${Ids} - ids list to be returned
    ${Ids}    Create List
    @{json_obj}=    Get JSON Object    ${responseBody}    /entity
    : FOR    ${item}    IN    @{json_obj}
    \    ${id}=    Get JSON Object    ${item}    /entityId
    \    Append To List    ${Ids}    ${id}
    [Return]    ${Ids}

Create Search Via API By Name
    [Arguments]    ${searchName}
    [Documentation]    Create Search with specific name (${searchName})Via API. Use SaveSeach_Template.xml as template.
    log    ${CURDIR}
    ${templateXML}    set variable    ${CURDIR}/Test_Data/SaveSearch_Template.xml
    ${tempXML}    set variable    ${CURDIR}/Test_Data/Temp.xml
    Copy File    ${templateXML}    ${tempXML}
    Replace Regexp In File    ${tempXML}    {Search_Name}    ${searchName}
    Create Search Via API    ${tempXML}
    Delete File    ${tempXML}

Create Old Default Search Via API
    [Arguments]    ${fileName}=${CURDIR}/Test_Data/SaveDefault.xml
    [Documentation]    Create default search for 10.1 EWB version.
    ...    ${fileName } is XML filewith search content.
    ${saved_adv_search}    Get File    ${fileName}
    Create HTTP Context    ${SERVER}:${WEB_SERVICE_PORT}    ${WEB_SERVICE_HTTP_SCHEME}
    Set Basic Auth    ${SERVICES USERNAME}    ${SERVICES PASSWORD}
    Set Request Header    content-type    application/json
    Set Request Body    ${saved_adv_search}
    PUT    /ewb/services/1.0/settings/usersettings/structuredsearch
    ${status}    Get Response Status
    ${response_body}    Get Response Body
    Should Start With    ${status}    204
    sleep    5s
    [Return]    ${response_body}

Create Searches Via API
    [Arguments]    @{name_list}
    [Documentation]    Create Saved Searchs via API with names from @{name_list} list
    : FOR    ${name}    IN    @{name_list}
    \    Create Search Via API By Name    ${name}

Create Advanced Search Via API By Name
    [Arguments]    ${searchName}
    [Documentation]    Create Advanced Search with specific name (${searchName})Via API. Use SaveSeacrhAdvanced_Template.xml as template.
    ${templateSearch}    set variable    ${CURDIR}/Test_Data/SaveSearchAdvanced_Template.xml
    ${tempXML}    set variable    ${CURDIR}/Test_Data/Temp.xml
    Copy File    ${templateSearch}    ${tempXML}
    Replace Regexp In File    ${tempXML}    {Search_Name}    ${searchName}
    Create Search Via API    ${tempXML}
    Delete File    ${tempXML}

Create Saved Search In Navigator Via API
    [Arguments]    ${treePath}    #${treePath} displays hierarchy elements in navigator, where search should be saved
    [Documentation]    Save search to navigator for particulat ${treePath} via API
    ${entityId}    EntityAPILibrary.Get Entity ID    ${treePath}
    ${request_file}    Get File    ${CURDIR}/Test_Data/RestoreSave.json
    # Create Saved Search
    Create HTTP Context    ${SERVER}:${WEB_SERVICE_PORT}    ${WEB_SERVICE_HTTP_SCHEME}
    Set Basic Auth    ${SERVICES USERNAME}    ${SERVICES PASSWORD}
    Set Request Header    Accept    application/json
    Set Request Header    Content-Type    application/json
    Set Request Body    ${request_file}
    POST    /ewb/services/1.0/entities/${entityID}/children
    # Check POST result
    Response Status Code Should Equal    200
    ${response_body}    Get Response Body
