*** Settings ***
Library           IDBSHttpLibrary
Library           IDBSSelenium2Library
Library           JSONLibrary

*** Keywords ***
Extract Single API Response from Batch Response
    [Arguments]    ${response}    ${index}
    [Documentation]    Extracts a single API response at the given index from the batch response json string.
    ...
    ...    *Args*
    ...
    ...    ${response} - The full batch response string
    ...
    ...    ${index} - The index of the response you are interested in (0 indexed)
    ${api_json_obj}=    Get Json Object    ${response}    /batch-response/api-responses/${index}
    ${json_string}    Convert JSON Object to String    ${api_json_obj}
    [Return]    ${json_string}

Generate API Request JSON
    [Arguments]    ${api_id}    ${api_data_object}
    [Documentation]    Generates a single api request (i.e. that which will be included in a batch request) json string and returns it.
    ...
    ...    *Args*
    ...
    ...    ${api_id} - The id of the api endpoint you wish to use - e.g. term.variables, table.structure, etc.
    ...
    ...    ${api_data_object} - The data object required for the endpoint. Note that surrounding object braces and "data" name will be added by the keyword.
    ...
    ...    ${api_version}=1.0 - The version of the api; if a different one is required, this can be overridden here
    ${req}=    Set Variable    { "api-id": "${api_id}", "api-version": "1.0" }, { "data" : { ${api_data_object} } }
    [Return]    ${req}

Generate Batch Request JSON
    [Arguments]    ${options}    @{api_requests}
    [Documentation]    Generates an api batch request json string that can be used as a request body when calling the adapt/api endpoint on the spreadsheet server.
    ...
    ...    *Args*
    ...
    ...    _@{api_requests}_ - a list of api request json objects (string representation) to include in the batch request.
    ...
    ...    ${options} This is used to control the NFR (non-functional requirements) options in a request. If 'default' is used then NFR's revert to there default behaviour. That is auditing and undo/redo are off and permissions are false (the api will adhere to the permissions of the user making the request).
    ...    To carryout a test where you need one or more of these options to be "on" then the correct json needs to be inputted instead of default.
    ...
    ...
    ...    | *Generate Batch Request JSON* | default | JSON batch request | This will create a request with the default behaviour for the NFR's |
    ...    | *Generate Batch Request JSON* | "options" : { "undoTitle" : " Undo on" } | JSON batch request | This will create a request where undo/redo is enabled |
    ...
    ...    *Returns*
    ...
    ...    ${json} - the batch request json string generated
    ${request_string}=    Catenate    @{api_requests}
    ${json}=    Set Variable IF    '${options}' == 'default'    { "batch-request": [ { "version": "1.0"}, [ ${request_string} ]]}    { "batch-request": [ { "version": "1.0", ${options} }, [ ${request_string} ]]}
    [Return]    ${json}

Generate Multiple API Request JSON
    [Arguments]    @{api_id_and_data_object_pairs}
    [Documentation]    Generates a multiple api request (i.e. those which will be included in a batch request) json string and returns it.
    ...
    ...    *Args*
    ...
    ...    @{api_id_and_data_object_pairs} - A list of api id and data object paris, where:
    ...    - ${api_id} - The id of the api endpoint you wish to use - e.g. term.variables, table.structure, etc.
    ...    - ${api_data_object} - The data object required for the endpoint. Note that surrounding object braces and "data" name will be added by the keyword.
    ${json}=    Set Variable    ${EMPTY}
    ${length}=    Get Length    ${api_id_and_data_object_pairs}
    : FOR    ${i}    IN RANGE    0    ${length}    2
    \    ${j}=    Evaluate    ${i} + 1
    \    ${api_request}=    Generate API Request JSON    ${api_id_and_data_object_pairs[${i}]}    ${api_id_and_data_object_pairs[${j}]}
    \    ${json}=    Run Keyword If    '${json}'    Catenate    ${json},    ${api_request}
    \    ...    ELSE    Catenate    SEPARATOR=    ${json}    ${api_request}
    \    ...    # If there's already json, concatenate the two requests with a space in between. If there's not already json, then we don't want a space
    [Return]    ${json}

Send API HTTP Request
    [Arguments]    ${spreadsheet_id}    ${options}    @{api_id_and_data_object_pairs}
    [Documentation]    Sends an HTTP request with the given api-data-object to the given api-id, returning the response. A spreadsheet must be open in the web editor before using this keyword.
    ...
    ...    Note that this keyword can support batch requests if the user supplies additional api_id/api_data_object pairs
    ...
    ...    See below examples for more information
    ...
    ...    *Args*
    ...
    ...    - _${spreadsheet_id}_ - The id of the currently open spreadsheet (used to predict the endpoint)
    ...    - _${options}_ - The options for the batch call. This can be used to specify auditing, undo and permissions behaviours. If 'default' is supplied, then no options will be given and the default behaviour will apply. Otherwise, the user may specify a valid options json object for the batch request to use (i.e. ' "options": { ... }' ). See the api batch call principles documentation for more information.
    ...    - _@{api_id_and_data_object_pairs}_ - The api-id part of the pair is the api endpoint you wish to use. E.g. term.variables, table.structure, etc. \ The json data object part of the pair is the data object used in the request body of the api call. E.g. for term.variables, this might be _"terms" : [ { "path": "my/path" } ]_
    ...
    ...    *Example Usage*
    ...
    ...    This will make a call to the term.variables endpoint with default options and use it to get a list of all variables in the currently open spreadsheet that are matched to the term.
    ...    | ${s_id}= | *Get Latest Entity Version Id* | ${spreadsheet_id} | # Set as suite variable in test setup |
    ...    | ${response}= | *Send API HTTP Request* | ${s_id} | default | term.variables | "terms" : [ { "path" : "my/term" } ] |
    ...    This will create a batch request containing two calls with default options. The first is identical to the above. The second is a request of the table structure for Table1:
    ...    | ${response}= | *Send API HTTP Request* | ${s_id} | default | term.variables | "terms": [ {"path" : "myterm"} ] | table.structure | "tables" : [ "Table1" ] |
    # Generic request setup - Context, auth and accept header
    API Batch Request Setup
    # Wrap unique part of the request body in the generic api request
    ${api_request}=    Generate Multiple API Request JSON    @{api_id_and_data_object_pairs}
    ${request_body}=    Generate Batch Request JSON    ${options}    ${api_request}
    Set Request Body    ${request_body}
    POST    /ewb/services/1.0/spreadsheet/data?versionId=${spreadsheet_id}
    ${response}=    Get Response Body
    [Return]    ${response}

Set JSessionID Cookie Header Using Open Spreadsheet
    [Documentation]    Sets the JSESSIONID Cookie for the next HTTP Request. Does this by getting the existing JSESSIONID from the open spreadsheet and using that in the Cookie header. Due to this, a spreadsheet must be open in order for this to work.
    ${cookie}=    Get Cookie Value    JSESSIONID
    Set Request Header    Cookie    JSESSIONID=${cookie}

API Batch Request Setup
    [Arguments]    ${set_basic_auth}=${True}
    [Documentation]    Creates the http context, sets basic auth (if required) and sets common headers for api requests.
    ...
    ...    NOTE: if you are going to use OAuth bearer access tokens then the _set_basic_auth_ value can be set to ${False}
    Create Http Context    ${SERVER}:${WEB_SERVICE_PORT}    ${WEB_CLIENT_HTTP_SCHEME}
    Run Keyword If    ${set_basic_auth}    Set Basic Auth    ${SERVICES USERNAME}    ${SERVICES PASSWORD}
    Set Request Header    Content-Type    application/json
    Set Request Header    Accept    application/json

Convert JSON Object to String
    [Arguments]    ${json_obj}
    [Documentation]    Converts a json object to a string using json.dumps. JSON library implementation uses str() for some reason, which doesn't always produce a valid json string.
    ${json_string}=    Evaluate    json.dumps(${json_obj})    json
    [Return]    ${json_string}

Convert string to JSON Object
    [Arguments]    ${json_str}
    [Documentation]    Converts a json string to a json object using json.loads.
    ${json_string}=    Evaluate    json.loads("${json_str}")    json
    [Return]    ${json_obj}

JSON Element Length Should Be
    [Arguments]    ${json_obj}    ${json_pointer}    ${length}
    [Documentation]    Converts the given json string or object to a new json object and checks the length. JSON library length checks don't support dictionaries (despite the method being no different), so this is a workaround for it.
    ...
    ...    JSON pointer path syntax is that which is used througout the JSON library. e.g with the following json:
    ...
    ...    { "myDict" : { "one" : 1, "two": ["a string", "array"], "three" : { "this is" : "another dictionary" } } }
    ...
    ...    /myDict - returns the myDict dictionary
    ...    /myDict/one - returns the value of "one" (1)
    ...    /myDict/two - returns the array element stored in "two"
    ...    /myDict/two/0 - returns the first element of the "two" array ("a string")
    ...    /myDict/three/this is - returns the value of the "this is" entry in the "three dictionary" ("another dictionary")
    ...
    ...    Thus, examples:
    ...
    ...    | *JSON Element Length Should Be* | ${json} | /myDict | 3 | # Passes |
    ...
    ...    | *JSON Element Length Should Be* | ${json} | /myDict/two | 2 | # Passes |
    ...
    ...    | *JSON Element Length Should Be* | ${json} | /myDict/three | 1 | # Passes |
    ${element}    JSONLibrary.Get Json Object    ${json_obj}    ${json_pointer}
    Length Should Be    ${element}    ${length}

Extract Status From Batch Response
    [Arguments]    ${response}
    [Documentation]    Extracts the status of the batch response from the given batch response JSON string.
    ...
    ...    *Args*
    ...
    ...    ${response} - The full batch response string
    ${api_json_obj}=    Get Json Object    ${response}    /batch-response/status
    ${json_string}=    Convert JSON Object to String    ${api_json_obj}
    [Return]    ${json_string}

Error Message Should Contain
    [Arguments]    ${api_response}    ${error_message}    ${message_index}=1
    [Documentation]    This keyword is used to check that the correct error message is returned when making an invalid request.
    ${caused_by}=    Get Json String Value    ${api_response}    /messages/${message_index}
    Should Contain    ${caused_by}    ${error_message}
