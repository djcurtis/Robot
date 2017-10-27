*** Settings ***
Documentation     This resource file contains all the keywords that are needed to execute tests for the Query Web Service in the Nelson project.
Library           IDBSHttpLibrary
Library           String
Library           XMLLibrary
Library           Collections
Resource          ../../common_resource.txt

*** Variables ***
${data query address}    /landscape/services/1.0/data/queries/data
${tuple query address}    /landscape/services/1.0/data/queries/tuple
${transformer query address}    /landscape/services/1.0/data/queries/transformer
${null value}     null
${xml namespace}    http://java.sun.com/xml/ns/jdbc
${xmlns:ns2 - tuple query}    http://batch.hubtech.services.ewb.idbs.com
${xmlns:ns4 - tuple query}    http://tuple.hubtech.services.ewb.idbs.com

*** Keywords ***
_Query Request Setup
    [Arguments]    ${username}=${SERVICES USERNAME}    ${password}=${SERVICES PASSWORD}
    [Documentation]    This keyword sets up the connection to the server, and logs in with a user name and passward.
    ...
    ...    All variables used in this keyword are stored in "......\\EWB Automated Tests\\Libraries\\common_resource.txt"
    Create Http Context    ${SERVER}:${WEB_SERVICE_PORT}    ${WEB_SERVICE_HTTP_SCHEME}
    set basic auth    ${username}    ${password}

_Parse XML Response From Data Query
    [Arguments]    ${response body}
    [Documentation]    This keyword extracts the results from the XML response of a Data Query Service query.
    ...
    ...
    ...    *Arguments*
    ...
    ...    - ${response body} = This is the XML response from executing a Data Query Service query.
    ...
    ...
    ...    *Return Value*
    ...
    ...    - ${tuple data} = A list containing the results from the query. Each element in this list is a list with contains the property values from a single tuple.
    ...
    ...
    ...    *Example*
    ${response body}=    _Check For Null Response Body    ${response body}
    @{elementXML}=    Get Element Xml    ${RESPONSE BODY}    ${xml namespace}    currentRow    ${False}
    @{tuple data}=    Create List
    : FOR    ${element}    IN    @{elementXML}
    \    ${tuple values}=    Get Element Value    ${element}    ${xml namespace}    columnValue
    \    ${tuple values}=    _Format Nulls in Response From Data Query    ${tuple values}
    \    Append To List    ${tuple data}    ${tuple values}
    [Return]    ${tuple data}

_Check For Null Response Body
    [Arguments]    ${response body}
    ${status}    ${value}=    Run Keyword And Ignore Error    Should Not Be Equal    ${response body}    ${null}
    ${return response body}=    Set Variable If    "${status}"=="PASS"    ${response body}    <dummyXML></dummyXML>
    [Return]    ${return response body}

_Parse Expected Query Data
    [Arguments]    @{unparsed expected tuple data}
    @{return tuple list}=    create list
    : FOR    ${element}    IN    @{unparsed expected tuple data}
    \    ${tuple data}=    Split String    ${element}    ,
    \    Append to List    ${return tuple list}    ${tuple data}
    [Return]    ${return tuple list}

_Format Nulls in Response From Data Query
    [Arguments]    ${tuple data}
    [Documentation]    This keyword takes a list and replaces all Phyton 'None' values in that list to the string 'null'. It then returns the modified list.
    ${count}=    Count Values In List    ${tuple data}    ${None}
    : FOR    ${dummy}    IN RANGE    ${count}
    \    ${index}=    Get Index From List    ${tuple data}    ${None}
    \    Set List Value    ${tuple data}    ${index}    null
    [Return]    ${tuple data}

_Get Tuple Query Service XML Response
    [Arguments]    ${query request body}
    _Query Request Setup
    set request header    content-type    application/xml
    set request header    accept    application/xml
    set request body    ${query request body}
    Run Keyword And Continue On Failure    POST    ${tuple query address}
    Log Response Body
    ${RESPONSE BODY}=    Get Response Body
    [Return]    ${RESPONSE BODY}

_Get Data Query Service XML Response
    [Arguments]    ${query request body}
    _Query Request Setup
    set request header    content-type    application/xml
    set request header    accept    application/xml
    set request body    ${query request body}
    Run Keyword And Continue On Failure    POST    ${data query address}
    Log Response Body
    ${RESPONSE BODY}=    Get Response Body
    [Return]    ${RESPONSE BODY}

_Get Transformation Query Service XML Response
    [Arguments]    ${query request body}
    _Query Request Setup
    set request header    content-type    application/xml
    set request header    accept    application/xml
    set request body    ${query request body}
    Run Keyword And Continue On Failure    POST    ${transformer query address}
    Log Response Body
    ${RESPONSE BODY}=    Get Response Body
    [Return]    ${RESPONSE BODY}

_Get Paramaterised Query Request Body
    [Arguments]    ${unparsed parameterised query}
    @{unparsed parameterised query list}=    Convert To List    ${unparsed parameterised query}
    ${parameterised query}=    Remove From List    ${unparsed parameterised query list}    0
    ${query xml object}=    Create Xml Object    query
    ${query xml object}=    Set Element Attribute    ${query xml object}    queryStatement    ${parameterised query}
    : FOR    ${element}    IN    @{unparsed parameterised query list}
    \    @{parameter bindings}=    Split String    ${element}    ,
    \    ${parameterBindings xml element}=    Create Xml Object    parameterBindings
    \    ${parameterBindings xml element}=    Set Element Attribute    ${parameterBindings xml element}    className    @{parameter bindings}[0]
    \    ${parameterBindings xml element}=    Set Element Attribute    ${parameterBindings xml element}    name    @{parameter bindings}[1]
    \    @{parameter bindings values}=    Get Slice From List    ${parameter bindings}    2
    \    @{parameter bindings values xml list}=    _Get Parmeter Values XML For Parameterised Query Request Body    @{parameter bindings values}
    \    ${parameterBindings xml element}=    Add List Of Subelements To Xml    ${parameterBindings xml element}    ${parameter bindings values xml list}
    \    ${query xml object}=    Add Subelement To Xml    ${query xml object}    ${parameterBindings xml element}
    ${request body}=    Get Xml    ${query xml object}
    Log    ${request body}
    [Return]    ${request body}

_Get Paramaterised Query Request Body NEW
    [Arguments]    ${unparsed parameterised query}
    [Documentation]    _Get Paramaterised Query Request Body syntax = now deprecated syntax (because it uses the className attribute)
    ...
    ...    New queries use parameterBindings *type*
    @{unparsed parameterised query list}=    Convert To List    ${unparsed parameterised query}
    ${parameterised query}=    Remove From List    ${unparsed parameterised query list}    0
    ${query xml object}=    Create Xml Object    query
    ${query xml object}=    Set Element Attribute    ${query xml object}    queryStatement    ${parameterised query}
    : FOR    ${element}    IN    @{unparsed parameterised query list}
    \    @{parameter bindings}=    Split String    ${element}    ,
    \    ${parameterBindings xml element}=    Create Xml Object    parameterBindings
    \    ${parameterBindings xml element}=    Set Element Attribute    ${parameterBindings xml element}    type    @{parameter bindings}[0]
    \    ${parameterBindings xml element}=    Set Element Attribute    ${parameterBindings xml element}    name    @{parameter bindings}[1]
    \    @{parameter bindings values}=    Get Slice From List    ${parameter bindings}    2
    \    @{parameter bindings values xml list}=    _Get Parmeter Values XML For Parameterised Query Request Body    @{parameter bindings values}
    \    ${parameterBindings xml element}=    Add List Of Subelements To Xml    ${parameterBindings xml element}    ${parameter bindings values xml list}
    \    ${query xml object}=    Add Subelement To Xml    ${query xml object}    ${parameterBindings xml element}
    ${request body}=    Get Xml    ${query xml object}
    Log    ${request body}
    [Return]    ${request body}

_Get Parmeter Values XML For Parameterised Query Request Body
    [Arguments]    @{parameter values}
    @{parameter values xml list}=    Create List
    : FOR    ${value}    IN    @{parameter values}
    \    ${parameterBindings value element xml}=    Create Xml Object    values    elementText=${value}
    \    Append To List    ${parameter values xml list}    ${parameterBindings value element xml}
    [Return]    @{parameter values xml list}

_Get Query Request Body
    [Arguments]    ${query}
    [Documentation]    This keyword returns the XML request body for the Data Query Service. The input for this keyword is the SQL/H query.
    ...
    ...    *Arguments*
    ...
    ...    - ${query} = The SQL/H query.
    ...
    ...
    ...    *Return Value*
    ...
    ...    - ${request body} = The XML request body that is needed to execute the ${query} for the Data Query Service.
    ${query xml object}=    Create Xml Object    query
    ${query xml object}=    Set Element Attribute    ${query xml object}    queryStatement    ${query}
    ${request body}=    Get Xml    ${query xml object}
    Log    ${request body}
    [Teardown]
    [Return]    ${request body}

Execute Query
    [Arguments]    ${query}    ${username}=${SERVICES USERNAME}    ${password}=${SERVICES PASSWORD}    ${expectedHttpStatus}=200
    [Documentation]    This keyword executes a query for the Data Query Service. It verifies that the query executed without failure.
    ...
    ...    This keyword does NOT verify the returned results of the query.
    ...
    ...
    ...
    ...    *Arguments*
    ...
    ...    - ${query} = The SQL/H query to be executed
    ...
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    Tests if a query on the term "\\a\\path\\to\\a\\term" executes without failure
    ...
    ...
    ...    | Execute Query | SELECT * \ FROM "\\a\\path\\to\\a\\term" |
    ${query request body}=    _Get Query Request Body    ${query}
    _Query Request Setup    ${username}    ${password}
    Set Request Timeout    180s    #increased timeout for query execution since the query can take 60+ seconds to return
    set request header    content-type    application/xml
    set request header    accept    application/xml
    set request body    ${query request body}
    Next Request Should Succeed
    Run Keyword And Continue On Failure    POST    ${data query address}
    Response Status Code Should Equal    ${expectedHttpStatus}
    Log Response Body
    ${query response}=    Get Response Body
    [Return]    ${query response}

Execute Query (Tuple Service)
    [Arguments]    ${term path}
    [Documentation]    This keyword executes a query for the Tuple Query Service. It verifies that the query executed without failure.
    ...
    ...    This keyword does NOT verify the returned results of the query.
    ...
    ...
    ...    *Arguments*
    ...
    ...    - ${term path} = The path to the term you want to query
    ...
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...
    ...    *Example*
    ...
    ...    A query for the Tuple Query Service is of the form: \ SELECT HUB_GUID, TUPLE_GUID, TERM_GUID FROM ${term path}
    ...
    ...    So the following example would execute the query: \ SELECT HUB_GUID, TUPLE_GUID, TERM_GUID FROM "\\a\\path\\to\\a\\term"
    ...
    ...
    ...    | Execute Query (Tuple Service) | "\\a\\path\\to\\a\\term" |
    ${query}=    Set Variable    SELECT HUB_GUID, TUPLE_GUID, TERM_GUID FROM ${term path}
    ${query request body}=    _Get Query Request Body    ${query}
    _Query Request Setup
    set request header    content-type    application/xml
    set request header    accept    application/xml
    set request body    ${query request body}
    Next Request Should Succeed
    Run Keyword And Continue On Failure    POST    ${tuple query address}?start=0&count=5
    Log Response Body

Execute Data Query and Get Results
    [Arguments]    ${query}
    [Documentation]    This keyword executes a query for the Data Query Service and returns the tuple data results from the query.
    ...
    ...
    ...
    ...    *Arguments*
    ...
    ...    - ${query} = The SQL/H query to be executed
    ...
    ...
    ...    *Return Value*
    ...
    ...    - ${query results} = A list where each element is a list containing the data from a single tuple.
    ...
    ...    *Example*
    ...
    ...
    ...    | ${query results}= | Execute Data Query and Get Results | SELECT stringProperty, "boolean Property" FROM "\\a\\path\\to\\a\\term" WHERE numberProperty = 5.82 |
    ...    | Log List | ${query results} |
    ${query request body}=    _Get Query Request Body    ${query}
    ${query response}=    _Get Data Query Service XML Response    ${query request body}
    ${query results}=    _Parse XML Response From Data Query    ${query response}
    Log List    ${query results}
    [Return]    ${query results}

Execute Parameterised Data Query and Get Results
    [Arguments]    ${unparsed parameterised query}
    [Documentation]    This keyword executes a parameterised query for the Data Query Service and returns the tuple data results from the query.
    ...
    ...
    ...    *Arguments*
    ...
    ...    - ${unparsed parameterised query} = A list where the first element is the parameterised SQL/H query, and subsequent elements are the parameter bindings. Each binding is input as: \ \ \ \ \ className,bindingParamter,bindingValue1,bindingValue2,bindingValue3,.......,bindingValueN
    ...
    ...
    ...
    ...    *Return Value*
    ...
    ...    - ${query results} = A list where each element is a list containing the data from a single tuple.
    ...
    ...    *Example*
    ...
    ...    A parameterised query with two parameters, p and q, which are of datatypes String and Float.
    ...
    ...    | @{parameterised query}= | Create List | SELECT stringProperty, numberProperty, booleanProperty FROM "\\a\\path\\to\\a\\term" AS WHERE stringProperty = :p OR numberProperty = :q | java.lang.String,p,ddffg | java.lang.Float,q,-8.401 |
    ...    | ${query results}= | Execute Parameterised Data Query And Get Results | ${parameterised query} |
    ...
    ...
    ...    A parameterised query where a single parameter has multiple binding values.
    ...
    ...    | @{parameterised query}= | Create List | SELECT stringProperty, numberProperty FROM "\\a\\path\\to\\a\\term" AS t WHERE t.floatProperty IN(:p) | java.lang.Float,p,2.984,8.001,19.7,6.76,224.502 |
    ...    | ${query results}= | Execute Parameterised Data Query And Get Results | ${parameterised query} |
    ${query request body}=    _Get Paramaterised Query Request Body    ${unparsed parameterised query}
    ${query response}=    _Get Data Query Service XML Response    ${query request body}
    ${query results}=    _Parse XML Response From Data Query    ${query response}
    [Return]    ${query results}

Execute Parameterised Data Query and Get Results NEW
    [Arguments]    ${unparsed parameterised query}
    [Documentation]    This keyword executes a parameterised query for the Data Query Service and returns the tuple data results from the query.
    ...
    ...
    ...    *Arguments*
    ...
    ...    - ${unparsed parameterised query} = A list where the first element is the parameterised SQL/H query, and subsequent elements are the parameter bindings. Each binding is input as: \ \ \ \ \ className,bindingParamter,bindingValue1,bindingValue2,bindingValue3,.......,bindingValueN
    ...
    ...
    ...
    ...    *Return Value*
    ...
    ...    - ${query results} = A list where each element is a list containing the data from a single tuple.
    ...
    ...    *Example*
    ...
    ...    A parameterised query with two parameters, p and q, which are of datatypes String and Float.
    ...
    ...    | @{parameterised query}= | Create List | SELECT stringProperty, numberProperty, booleanProperty FROM "\\a\\path\\to\\a\\term" AS WHERE stringProperty = :p OR numberProperty = :q | java.lang.String,p,ddffg | java.lang.Float,q,-8.401 |
    ...    | ${query results}= | Execute Parameterised Data Query And Get Results | ${parameterised query} |
    ...
    ...
    ...    A parameterised query where a single parameter has multiple binding values.
    ...
    ...    | @{parameterised query}= | Create List | SELECT stringProperty, numberProperty FROM "\\a\\path\\to\\a\\term" AS t WHERE t.floatProperty IN(:p) | java.lang.Float,p,2.984,8.001,19.7,6.76,224.502 |
    ...    | ${query results}= | Execute Parameterised Data Query And Get Results | ${parameterised query} |
    ${query request body}=    _Get Paramaterised Query Request Body NEW    ${unparsed parameterised query}
    ${query response}=    _Get Data Query Service XML Response    ${query request body}
    ${query results}=    _Parse XML Response From Data Query    ${query response}
    [Return]    ${query results}

Execute Data Query and Verify Values
    [Arguments]    ${query}    @{unparsed expected query results}
    [Documentation]    This keyword executes a query for the Data Query Service and checks that the tuples returned from the query are as expected. The keyword fails if the tuples returned from the query are different from those as expected.
    ...
    ...    *Arguments*
    ...
    ...    - ${query} = The SQL/H query to be executed
    ...
    ...    - @{unparsed expected query results} = A list containing the expected results. Each element in this list should be comma seperated expected data from a single tuple.
    ...
    ...
    ...    *Return Value*
    ...
    ...    ${query results} = The Query Results are returned (JH)
    ...
    ...    *Example*
    ...
    ...    A query which is expected to return 2 tuples each with 3 specific properties values. NOTE: If any property value is expected to be NULL, put the value 'null' in its place as shown in the example.
    ...
    ...
    ...    | Execute Data Query and Verify Values | SELECT stringProperty, numberProperty, booleanProperty FROM "\\a\\path\\to\\a\\term" | sdssd,567,T | null,null,F |
    ${query results}=    Execute Data Query and Get Results    ${query}
    ${expected results}=    _Parse Expected Query Data    @{unparsed expected query results}
    Sort List    ${query results}
    Sort List    ${expected results}
    Log List    ${query results}
    Log List    ${expected results}
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${query results}    ${expected results}
    [Return]    ${query results}

Execute Data Query and Verify Values (Unsorted)
    [Arguments]    ${query}    @{unparsed expected query results}
    [Documentation]    This keyword executes a query for the Data Query Service and checks that the tuples returned from the query are as expected. The keyword fails if the tuples returned from the query are different from those as expected.
    ...
    ...    NOTE: This keyword keeps the order of the returned tuples. So, it should only be used if you want to keep the order of the returned tuples. For example, if you would use it if you want to compare results from a query with "ORDER BY" in it. \ *Arguments*
    ...
    ...    - ${query} = The SQL/H query to be executed
    ...
    ...    - @{unparsed expected query results} = A list containing the expected results. Each element in this list should be comma seperated expected data from a single tuple.
    ...
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    A query which is expected to return 2 tuples each with 3 specific properties values. NOTE: If any property value is expected to be NULL, put the value 'null' in its place as shown in the example.
    ...
    ...
    ...    | Execute Data Query and Verify Values | SELECT stringProperty, numberProperty, booleanProperty FROM "\\a\\path\\to\\a\\term" ORDER BY someProperty | sdssd,567,T | null,null,F |
    ${query results}=    Execute Data Query and Get Results    ${query}
    ${expected results}=    _Parse Expected Query Data    @{unparsed expected query results}
    Log List    ${query results}
    Log List    ${expected results}
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${query results}    ${expected results}

Execute Parameterised Data Query And Verify Values
    [Arguments]    ${unparsed parameterised query}    @{unparsed expected query results}
    [Documentation]    This keyword executes a parameterised query for the Data Query Service and checks that the tuples returned from the query are as expected. The keyword fails if the tuples returned from the query are different from those as expected.
    ...
    ...    *Arguments*
    ...
    ...    - ${unparsed parameterised query} = A list where the first element is the parameterised SQL/H query, and subsequent elements are the parameter bindings. Each binding is input as: \ \ \ \ className,bindingParamter,bindingValue1,bindingValue2,bindingValue3,.......,bindingValueN
    ...
    ...    - @{unparsed expected query results} = A list containing the expected results. Each element in this list should be comma seperated expected data from a single tuple.
    ...
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    A parameterised query which is expected to return 2 tuples each with 3 specific properties values. NOTE: If any property value is expected to be NULL, put the value 'null' in its place as shown in the example.
    ...
    ...    | @{parameterised query}= | Create List | SELECT stringProperty, numberProperty, booleanProperty FROM "\\a\\path\\to\\a\\term" AS t WHERE t.stringProperty = :p OR t.numberProperty = :q | java.lang.String,p,ddffg | java.lang.Float,q,-8.401 |
    ...    | Execute Parameterised Data Query And Verify Values | ${parameterised query} | sdssd,567,T | null,null,F |
    ...
    ...    A parameterised query where a single parameter has multiple binding values.
    ...
    ...    | @{parameterised query}= | Create List | SELECT stringProperty, numberProperty FROM "\\a\\path\\to\\a\\term" AS t WHERE t.floatProperty IN(:p) | java.lang.Float,p,2.984,8.001,19.7,6.76,224.502 |
    ...    | Execute Parameterised Data Query And Verify Values | ${parameterised query} | sdssd,137 | gergg,789 |
    ${query results}=    Execute Parameterised Data Query and Get Results    ${unparsed parameterised query}
    ${expected results}=    _Parse Expected Query Data    @{unparsed expected query results}
    Sort List    ${query results}
    Sort List    ${expected results}
    Log List    ${query results}
    Log List    ${expected results}
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${query results}    ${expected results}

Execute Parameterised Data Query And Verify Values NEW
    [Arguments]    ${unparsed parameterised query}    @{unparsed expected query results}
    [Documentation]    This keyword executes a parameterised query for the Data Query Service and checks that the tuples returned from the query are as expected. The keyword fails if the tuples returned from the query are different from those as expected.
    ...
    ...    *Arguments*
    ...
    ...    - ${unparsed parameterised query} = A list where the first element is the parameterised SQL/H query, and subsequent elements are the parameter bindings. Each binding is input as: \ \ \ \ className,bindingParamter,bindingValue1,bindingValue2,bindingValue3,.......,bindingValueN
    ...
    ...    - @{unparsed expected query results} = A list containing the expected results. Each element in this list should be comma seperated expected data from a single tuple.
    ...
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    A parameterised query which is expected to return 2 tuples each with 3 specific properties values. NOTE: If any property value is expected to be NULL, put the value 'null' in its place as shown in the example.
    ...
    ...    | @{parameterised query}= | Create List | SELECT stringProperty, numberProperty, booleanProperty FROM "\\a\\path\\to\\a\\term" AS t WHERE t.stringProperty = :p OR t.numberProperty = :q | java.lang.String,p,ddffg | java.lang.Float,q,-8.401 |
    ...    | Execute Parameterised Data Query And Verify Values | ${parameterised query} | sdssd,567,T | null,null,F |
    ...
    ...    A parameterised query where a single parameter has multiple binding values.
    ...
    ...    | @{parameterised query}= | Create List | SELECT stringProperty, numberProperty FROM "\\a\\path\\to\\a\\term" AS t WHERE t.floatProperty IN(:p) | java.lang.Float,p,2.984,8.001,19.7,6.76,224.502 |
    ...    | Execute Parameterised Data Query And Verify Values | ${parameterised query} | sdssd,137 | gergg,789 |
    ${query results}=    Execute Parameterised Data Query and Get Results NEW    ${unparsed parameterised query}
    ${expected results}=    _Parse Expected Query Data    @{unparsed expected query results}
    Sort List    ${query results}
    Sort List    ${expected results}
    Log List    ${query results}
    Log List    ${expected results}
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${query results}    ${expected results}

Execute Parameterised Data Query And Verify Values (Unsorted)
    [Arguments]    ${unparsed parameterised query}    @{unparsed expected query results}
    [Documentation]    This keyword executes a parameterised query for the Data Query Service and checks that the tuples returned from the query are as expected. The keyword fails if the tuples returned from the query are different from those as expected.
    ...
    ...    NOTE: This keyword keeps the order of the returned tuples. So, it should only be used if you want to keep the order of the returned tuples. For example, if you would use it if you want to compare results from a query with "ORDER BY" in it.
    ...
    ...    *Arguments*
    ...
    ...    - ${unparsed parameterised query} = A list where the first element is the parameterised SQL/H query, and subsequent elements are the parameter bindings. Each binding is input as: \ \ \ \ \ className,bindingParamter,bindingValue1,bindingValue2,bindingValue3,.......,bindingValueN
    ...
    ...    - @{unparsed expected query results} = A list containing the expected results. Each element in this list should be comma seperated expected data from a single tuple.
    ...
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    A parameterised query which is expected to return 2 tuples each with 3 specific properties values. NOTE: If any property value is expected to be NULL, put the value 'null' in its place as shown in the example.
    ...
    ...    | @{parameterised query}= | Create List | SELECT stringProperty, numberProperty, booleanProperty FROM "\\a\\path\\to\\a\\term" AS t WHERE t.stringProperty = :p OR t.numberProperty = :q ORDER BY t.numberProperty | java.lang.String,p,ddffg | java.lang.Float,q,-8.401 |
    ...    | Execute Parameterised Data Query And Verify Values (Unsorted) | ${parameterised query} | sfsd,5,T | null,12,F | hjsf,566,null |
    ...
    ...
    ...    A parameterised query where a single parameter has multiple binding values.
    ...
    ...    | @{parameterised query}= | Create List | SELECT stringProperty, numberProperty FROM "\\a\\path\\to\\a\\term" AS t WHERE t.floatProperty IN(:p) ORDER BY t.numberProperty | Float,p,2.984,8.001,19.7,6.76,224.502 |
    ...    | Execute Parameterised Data Query And Verify Values (Unsorted) | ${parameterised query} | sdssd,137 | gergg,789 |
    ${query results}=    Execute Parameterised Data Query and Get Results    ${unparsed parameterised query}
    ${expected results}=    _Parse Expected Query Data    @{unparsed expected query results}
    Log List    ${query results}
    Log List    ${expected results}
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${query results}    ${expected results}

Execute Invalid Data Query and Verify Error
    [Arguments]    ${query}    ${expected status code}
    [Documentation]    This keyword is used to check that the correct response code is returned when providing an invalid query to the Data Query Service.
    ...
    ...    This keyword will fail if the response code from the query requets is >= 400 OR the response code is not equal to the ${expected response code}
    ...
    ...    *Arguments*
    ...
    ...    - ${query}= The query to be executed.
    ...
    ...    - ${expected status code}= The expected response code from the executed query.
    ...
    ...
    ...    *Example*
    ...
    ...    The query is invalid as the the name of the term path is not enclosed in quotation marks, and a 400 Bad Request response should be returned.
    ...
    ...    | Execute Invalid Data Query and Verify Error | SELECT * FROM /Path/To/a/Term | 400 |
    ${query request body}=    _Get Query Request Body    ${query}
    _Query Request Setup
    set request header    content-type    application/xml
    set request header    accept    application/xml
    set request body    ${query request body}
    Next Request Should Not Succeed
    POST    ${data query address}
    Response Status Code Should Equal    ${expected status code}

Execute Parameterised Invalid Data Query and Verify Error
    [Arguments]    ${parameterised query}    ${expected status code}
    [Documentation]    This keyword is used to check that the correct response code is returned when providing an invalid parameterised query to the Data Query Service.
    ...
    ...    This keyword will fail if the response code from the query request is >= 400 OR the response code is not equal to the ${expected response code}
    ...
    ...    *Arguments*
    ...
    ...    - ${parameterised query}= The parameterised query to be executed.
    ...
    ...    - ${expected status code}= The expected response code from the executed query.
    ...
    ...
    ...    *Example*
    ...
    ...    The query is invalid due to an incorrect parameter reference, and a 400 Bad Request response should be returned.
    ...
    ...
    ...    | @{invalid parameterised query}= | Create List | SELECT stringProperty FROM "/Path/To/A/Term" AS t WHERE t.numberProperty = :q | java.lang.Integer,p,321 |
    ...    | Execute Parameterised Invalid Data Query and Verify Error | ${invalid parameterised query} | 400 |
    ${query request body}=    _Get Paramaterised Query Request Body    ${parameterised query}
    _Query Request Setup
    set request header    content-type    application/xml
    set request header    accept    application/xml
    set request body    ${query request body}
    Next Request Should Not Succeed
    POST    ${data query address}
    Response Status Code Should Equal    ${expected status code}

Execute Tuple Query Service and Verify Tuple Properties
    [Arguments]    ${term path}    ${dict}    ${property type}
    [Documentation]    This keyword executes a Tuple Query Service and checks that certain properties of the returned tuples are as expected.
    ...
    ...    *Arguments*
    ...
    ...    - ${term path} = The path to the term to be queried.
    ...
    ...    - ${dict} = A dictionary that maps tuple GUIDs to property values. \ - ${property type} = The property type that you want to check
    ...
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    TO DO..............
    ${query}=    Set Variable    SELECT HUB_GUID, TUPLE_GUID, TERM_GUID FROM ${term path}
    ${query request body}=    _Get Query Request Body    ${query}
    ${RESPONSE BODY}=    _Get Tuple Query Service XML Response    ${query request body}
    @{tupleResponse element list}=    Get Element Xml    ${RESPONSE BODY}    ${xmlns:ns2 - tuple query}    tupleResponse
    : FOR    ${tupleResponse element}    IN    @{tupleResponse element list}
    \    @{tupleID}=    Get Element Value    ${tupleResponse element}    ${xmlns:ns4 - tuple query}    tupleId
    \    @{prop list}=    Get Element Value    ${tupleResponse element}    ${xmlns:ns4 - tuple query}    ${property type}    ${False}
    \    ${expected result}=    Get From Dictionary    ${dict}    @{tupleID}[0]
    \    Sort List    ${expected result}
    \    Sort List    ${prop list}
    \    Log List    ${expected result}
    \    Log List    ${prop list}
    \    Lists Should Be Equal    ${expected result}    ${prop list}

Execute Tuple Query Service and Verify Tuples
    [Arguments]    ${term path}    ${query}    @{expected tuple ids}
    [Documentation]    This keyword executes a Tuple Query Service query and checks that the tuples returned from the query are as expected.
    ...
    ...
    ...    *Arguments*
    ...
    ...    - ${term path} = The path to the term to be queried.
    ...
    ...    - ${query} = The Tuple Query Service query to be executed.
    ...
    ...    - @{expected tuple ids} = A list containing the tuple GUIDs of the tuples expected to be returned from the query.
    ...
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...
    ...    A Tuple Query Service query which is expected to return 3 specific tuples.
    ...
    ...    | ${term path}= | Set Variable | "\\a\\path\\to\\a\\term" |
    ...    | @{expected tuple ids}= | Create List | 15d709d9c776455683489b4bcb56df3f | b4983be895c3458480d5c57dc6866ed6 | 9f6d6337e06e4771b8d44414bf5fa352 |
    ...    | Execute Tuple Query Service and Verify Tuples | ${term path} | SELECT HUB_GUID, TERM_GUID, TUPLE_GUID FROM ${term path} WHERE numberProperty = 23 AND stringProperty LIKE 'xyys%' | @{expected tuple ids} |
    ${query request body}=    _Get Query Request Body    ${query}
    ${RESPONSE BODY}=    _Get Tuple Query Service XML Response    ${query request body}
    @{tuple ids}=    Get Element Value    ${RESPONSE BODY}    ${xmlns:ns4 - tuple query}    tupleId
    Sort List    ${expected tuple ids}
    Sort List    ${tuple ids}
    Log List    ${expected tuple ids}
    Log List    ${tuple ids}
    Run Keyword And Continue On Failure    Lists Should Be Equal    ${tuple ids}    ${expected tuple ids}

Get Translated Query
    [Arguments]    ${sqlh query}
    [Documentation]    This keyword translates a valid SQL/H query into a SQL query using the Transformation Query Service.
    ...
    ...    *Arguments*
    ...
    ...    - ${sqlh query} = The SQL/H query to be translated into native SQL.
    ...
    ...    *Return Value*
    ...
    ...    - ${translated query} = The native SQL of ${sqlh query}.
    ${query request body}=    _Get Query Request Body    ${sqlh query}
    ${query response}=    _Get Transformation Query Service XML Response    ${query request body}
    @{sql query}=    Get Element Attribute    ${query response}    transformedQuery    translatedSQLStatement    ${None}
    ${translated query}=    Set Variable    @{sql query}[0]
    [Return]    ${translated query}
