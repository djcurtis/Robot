*** Settings ***
Documentation     A resource file containing IDBS defined keywords used for\ntesting the IDBS E-WorkBook Web Client application. This\nresource file contains keywords used for validating the\nsearch URL produced when running a search.\nThis file is loaded by the common_resource.txt file which\nis automatically loaded when running tests through the\nRobot Framework.\n*Version: E-WorkBook Web Client 9.1.0*

*** Variables ***
${invalid scope flag}    TRUE
${invalid search in flag}    TRUE
${invalid date event flag}    TRUE
${invalid date value flag}    TRUE
${invalid user event flag}    TRUE

*** Keywords ***
URL Validation Variable Invalid
    [Documentation]    Used within other URL validation keywords to fail the test due to invalid\nvalidation variables being passed to the keyword.\n*Should not be used as a stand-alone keyword in test scripts*
    Fail    Invalid validation variable specified - valid variables are specified in search_url_resource

URL Scope Record
    [Documentation]    Validates that the URL contains the search scope of "Record"\n*Should not be used as a stand-alone keyword in test scripts*
    Location Should Contain    searchScope=RECORD_DATA
    Set Global Variable    ${invalid scope flag}    FALSE

URL Scope Everything
    [Documentation]    Validates that the URL contains the search scope of "Everything"\n*Should not be used as a stand-alone keyword in test scripts*
    Location Should Contain    searchScope=ALL_DATA
    Set Global Variable    ${invalid scope flag}    FALSE

Validate Search URL Scope
    [Arguments]    ${scope}
    [Documentation]    Validates the scope part of the URL formed for the search being performed.\nValid ${scope} variable values are *RECORD* and *EVERYTHING*. All other variable values will cause the test to fail.
    Set Global Variable    ${invalid scope flag}    TRUE
    Run Keyword If    '${scope}' == 'RECORD'    URL Scope Record
    Run Keyword If    '${scope}' == 'EVERYTHING'    URL Scope Everything
    Run Keyword If    '${invalid scope flag}' == 'TRUE'    URL Validation Variable Invalid

URL Search In Properties
    [Documentation]    Validates that the URL contains the search in values of "Attributes" and "Tags"\n*Should not be used as a stand-alone keyword in test scripts*
    Location Should Contain    matchIn=ATTRIBUTE_TEXT
    Location Should Contain    matchIn=TAG_TEXT
    Set Global Variable    ${invalid search in flag}    FALSE

URL Search In Content
    [Documentation]    Validates that the URL contains the search in value of "Content"\n*Should not be used as a stand-alone keyword in test scripts*
    Location Should Contain    matchIn=FULL_DOCUMENT_TEXT
    Set Global Variable    ${invalid search in flag}    FALSE

URL Search In Comments
    [Documentation]    Validates that the URL contains the search in value of "Comments"\n*Should not be used as a stand-alone keyword in test scripts*
    Location Should Contain    matchIn=COMMENT_TEXT
    Set Global Variable    ${invalid search in flag}    FALSE

Validate Search URL Search in
    [Arguments]    ${search in}
    [Documentation]    Validates the search in part of the URL formed for the search being performed.\nValid variable values are *PROPERTIES*, *PROPERTIESCONTENT*, *PROPERTIESCOMMENTS*,\n*PROPERTIESCONTENTCOMMENTS*, *CONTENT*, *CONTENTCOMMENTS* and *COMMENTS*.\nAll other variable values with cause the test to fail
    Set Global Variable    ${invalid search in flag}    TRUE
    Run Keyword If    '${search in}' == 'PROPERTIES'    URL Search In Properties
    Run Keyword If    '${search in}' == 'PROPERTIESCONTENT'    URL Search In Properties
    Run Keyword If    '${search in}' == 'PROPERTIESCONTENT'    URL Search In Content
    Run Keyword If    '${search in}' == 'PROPERTIESCOMMENTS'    URL Search In Properties
    Run Keyword If    '${search in}' == 'PROPERTIESCOMMENTS'    URL Search In Comments
    Run Keyword If    '${search in}' == 'PROPERTIESCONTENTCOMMENTS'    URL Search In Properties
    Run Keyword If    '${search in}' == 'PROPERTIESCONTENTCOMMENTS'    URL Search In Content
    Run Keyword If    '${search in}' == 'PROPERTIESCONTENTCOMMENTS'    URL Search In Comments
    Run Keyword If    '${search in}' == 'CONTENT'    URL Search In Content
    Run Keyword If    '${search in}' == 'CONTENTCOMMENTS'    URL Search In Content
    Run Keyword If    '${search in}' == 'CONTENTCOMMENTS'    URL Search In Comments
    Run Keyword If    '${search in}' == 'COMMENTS'    URL Search In Comments
    Run Keyword If    '${invalid search in flag}' == 'TRUE'    URL Validation Variable Invalid

URL Date Event Created
    [Documentation]    Validates that the URL contains the search date value of "Created"\n*Should not be used as a stand-alone keyword in test scripts*
    Location Should Contain    dateEvent=CREATION
    Set Global Variable    ${invalid date event flag}    FALSE

URL Date Event Modified
    [Documentation]    Validates that the URL contains the search date value of "Last Modified"\n*Should not be used as a stand-alone keyword in test scripts*
    Location Should Contain    dateEvent=LAST_MODIFICATION
    Set Global Variable    ${invalid date event flag}    FALSE

URL Date Event Both
    [Documentation]    Validates that the URL contains the search date values of "Created" and "Last Modified"\n*Should not be used as a stand-alone keyword in test scripts*
    Location Should Contain    dateEvent=CREATION
    Location Should Contain    dateEvent=LAST_MODIFICATION
    Set Global Variable    ${invalid date event flag}    FALSE

Validate Search URL Date Event
    [Arguments]    ${date event}
    [Documentation]    Validates the date event part of the URL formed for the search being performed.\nValid variable values are *CREATION*, *MODIFICATION* and *BOTH*.\nAll other variable values with cause the test to fail.
    Set Global Variable    ${invalid date event flag}    TRUE
    Run Keyword If    '${date event}' == 'CREATION'    URL Date Event Created
    Run Keyword If    '${date event}' == 'MODIFICATION'    URL Date Event Modified
    Run Keyword If    '${date event}' == 'BOTH'    URL Date Event Both
    Run Keyword If    '${invalid date event flag}' == 'TRUE'    URL Validation Variable Invalid

URL Date Week
    [Documentation]    Validates that the URL contains the search date range value of "Week"\n*Should not be used as a stand-alone keyword in test scripts*
    Location Should Contain    prevDays=7
    Set Global Variable    ${invalid date value flag}    FALSE

URL Date Month
    [Documentation]    Validates that the URL contains the search date range value of "Month"\n*Should not be used as a stand-alone keyword in test scripts*
    Location Should Contain    prevDays=28
    Set Global Variable    ${invalid date value flag}    FALSE

URL Date Custom
    [Arguments]    ${start}    ${end}
    [Documentation]    Validates that the URL contains the search date range value of "Custom"\nThis keyword takes the custom ${start} and ${end} variables as part of the validation.\n*Should not be used as a stand-alone keyword in test scripts*
    Location Should Contain    fromDate=${start}
    Location Should Contain    toDate=${end}
    Set Global Variable    ${invalid date value flag}    FALSE

Validate Search URL Date Value
    [Arguments]    ${date value}
    [Documentation]    Validates the date event part of the URL formed for the search being performed.\nValid variable values are *WEEK* and *MONTH*. All other variable values with cause the test to fail
    Set Global Variable    ${invalid date value flag}    TRUE
    Run Keyword If    '${date value}' == 'WEEK'    URL Date Week
    Run Keyword If    '${date value}' == 'MONTH'    URL Date Month
    Run Keyword If    '${invalid date value flag}' == 'TRUE'    URL Validation Variable Invalid

Validate Search URL Custom Date Value
    [Documentation]    Validates the custom date event part of the URL formed for the search being performed.\n${start date} and ${end date} must be of the format *yyyy-mm-dd*.
    [Arguments] ${start date}    ${end date}
    URL Date Custom    ${start date}    ${end date}

URL User Event Created
    [Documentation]    Validates that the URL contains the search user value of "Created"\n*Should not be used as a stand-alone keyword in test scripts*
    Location Should Contain    userEvent=CREATION
    Set Global Variable    ${invalid user event flag}    FALSE

URL User Event Modified
    [Documentation]    Validates that the URL contains the search user value of "Last Modified"\n*Should not be used as a stand-alone keyword in test scripts*
    Location Should Contain    userEvent=LAST_MODIFICATION
    Set Global Variable    ${invalid user event flag}    FALSE

URL User Event Both
    [Documentation]    Validates that the URL contains the search user values of "Created" and "Modified"\n*Should not be used as a stand-alone keyword in test scripts*
    Location Should Contain    userEvent=CREATION
    Location Should Contain    userEvent=LAST_MODIFICATION
    Set Global Variable    ${invalid user event flag}    FALSE

Validate Search URL User Event
    [Arguments]    ${user event}
    [Documentation]    Validates the user event part of the URL formed for the search being performed.\nValid variable values are *CREATION*, *MODIFICATION* and *BOTH*.\nAll other variable values with cause the test to fail.
    Set Global Variable    ${invalid user event flag}    TRUE
    Run Keyword If    '${user event}' == 'CREATION'    URL User Event Created
    Run Keyword If    '${user event}' == 'MODIFICATION'    URL User Event Modified
    Run Keyword If    '${user event}' == 'BOTH'    URL User Event Both
    Run Keyword If    '${invalid user event flag}' == 'TRUE'    URL Validation Variable Invalid

Validate Search URL User Value
    [Arguments]    ${user value}
    [Documentation]    Validates the user value part of the URL formed for the search being performed.\n${user value} variable must be the user name not full name.
    Location Should Contain    user=${user value}

Validate Search URL Text Value
    [Arguments]    ${text value}
    [Documentation]    Validates the text value part of the URL formed for the search being performed.\n${text value} is the text string being searched on.
    Location Should Contain    text=${text value}

Validate Search URL Default Search In Values
    [Documentation]    Validates that the URL contains the search in values of "Attributes" and "Tags"\nThese are the default search in values
    Validate Search URL Search In    PROPERTIES

Validate Search URL Default Scope Values
    [Documentation]    Validates that the URL contains the search scope value of "Everything"\nThis is the default search scope value
    Validate Search URL Scope    EVERYTHING
