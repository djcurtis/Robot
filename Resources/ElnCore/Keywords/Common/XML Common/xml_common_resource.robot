*** Settings ***
Library           XMLLibrary

*** Keywords ***
Add Subelement To Xml
    [Arguments]    ${xmlObject}    ${subElement}=${None}
    [Documentation]    *It wraps 'XMLLibrary.Add Subelement To Xml' keyword*
    ...
    ...    Add Subelement To Xml. If parameter _subElement_ is invalid _subElement_ isn't added to _xmlObject_ and original _xmlObject_ is returned
    ...
    ...    *Arguments*
    ...
    ...    _xmlObject_ - the parent xml object to append the sub element to subElement = the sub-element xml object to be appended to xmlObject
    ...
    ...    _subElement_ - the sub-element xml object to be appended to xmlObject
    ...
    ...    *Return*
    ...
    ...    the parent xml object with the appended sub-element if sub-element is valid, otherwise the original parent xml object.
    ${status}    ${value}=    Run Keyword And Ignore Error    XMLLibrary.Add Subelement To Xml    ${xmlObject}    ${subElement}
    ${xmlObject}=    Set Variable If    '${status}' == 'PASS'    ${value}    ${xmlObject}
    [Return]    ${xmlObject}    # The parent xml object with the appended sub-element