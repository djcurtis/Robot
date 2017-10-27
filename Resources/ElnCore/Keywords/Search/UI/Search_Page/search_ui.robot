*** Settings ***
Documentation     Keywords for Search screen
Library           IDBSHttpLibrary
Library           IDBSSelenium2Library
Resource          ../../../../Libraries/common_resource.txt
Resource          ../../../../Libraries/Web Client/Selenium/graphical_resource.txt
Resource          ../../../../Libraries/Core Web Services/Record Service/rest_record_service_resource.txt
Resource          ../../../../Libraries/Web Client/Selenium/general_resource.txt
Resource          advanced_search_term.txt
Resource          save_search_dialog.txt
Resource          ../../../../Libraries/Web Client/Selenium/general_resource.txt
Resource          locators/search_ui.txt
Resource          locators/new_search_term_dialog.txt
Resource          locators/save_search_dialog.txt
Resource          search_result_ui.txt

*** Variables ***

*** Keywords ***
Perform Text Search
    [Arguments]    ${search_text}
    [Documentation]    Insert text to search ${search_text} into the Text Search text field
    unselect frame
    Wait Until Element Is Visible    ${searchFrame}    30s
    select frame    ${searchFrame}
    Wait Until Element Is Visible    ${freeTextInput}    30s
    sleep    3s
    Input Text    ${freeTextInput}    ${search_text}
    sleep    3s

Verify Search Text Field
    [Arguments]    ${textSearch}
    [Documentation]    Verify text in Text Search Field' equals ${textSearch}
    unselect frame
    Wait Until Page Contains Element    ${searchFrame}
    select frame    ${searchFrame}
    Wait Until Page Contains Element    ${freeTextInput}
    sleep    5s
    ${actualSearchText}    get value    //*[@id="searchBox"]/div/input[2]
    Should Be Equal As Strings    ${textSearch}    ${actualSearchText}

Verify Advanced Search Item
    [Arguments]    ${name}    ${operator}    ${value}
    [Documentation]    Verify Advanced Search item is present on the Search screen by \ its Name ${name} , condition operator ${operator}, and value ${value}
    ${xpath}=    set variable    //div[@class='termsView']//div[@query-term-id]//span[text()='${name}']/../span[text()='${operator}']/../span[text()='${value}']
    unselect frame
    Wait until page contains element    ${searchFrame}
    select frame    ${searchFrame}
    Wait until page contains element    ${xpath}    20s

Verify Number Of Advanced Search Items
    [Arguments]    ${exp_Number}    ${exp_Number_active}
    [Documentation]    Verify that number on Advanced Search item in the Search screen equal ${exp_Number} number
    ${xpath}    set variable    ${advSearchTermsInSearchPage}
    wait until page contains element    ${advancedLink}
    ${actual_number}    Get Matching Xpath Count    ${xpath}
    Should be Equal As Integers    ${exp_Number}    ${actual_number}
    ${link_search_number}    Get Text    ${advancedLink}
    ${number_in_bracket}    set variable    (${exp_Number_active})
    Should Contain    ${link_search_number}    ${number_in_bracket}

Verify Advanced Search Items
    [Arguments]    @{items}    # one advanced search should be in the following format {search Term Name}|{property name}|{operator}|{value}
    [Documentation]    Verify that advanced search items from @{items} are in the screen.
    ${ind}    set variable    0
    : FOR    ${item}    IN    @{items}
    \    @{advSearch}    Split String    ${item}    |
    \    Verify Advanced Search Item    ${advSearch[0]}    ${advSearch[1]}    ${advSearch[2]}
    \    ${ind}    evaluate    ${ind}+1
    ${ind_active}    Get Matching Xpath Count    ${enabledAdvSearchItems}
    Verify Number Of Advanced Search Items    ${ind}    ${ind_active}

Perform Advanced Search
    [Arguments]    ${freeText}    @{advancedItems}    # @{advancedItems} one advanced search should be in the following format {search Term Name}|{property name}|{operator}|{value}
    [Documentation]    Fill Search window with free text value ${freeText} and Advanced Search items @{advancedItems}
    Perform Text Search    ${freeText}
    ${advanced_panel_open}    ${value}=    Run Keyword And Ignore Error    Element Should Be Visible    ${newAdvancedTermLink}
    Run Keyword If    '${advanced_panel_open}'=='FAIL'    Robust Click    ${advancedLink}
    Robust Click    ${newAdvancedTermLink}
    Wait Until Element Is Visible    ${newSearchTermDialog}    10s
    : FOR    ${advItem}    IN    @{advancedItems}
    \    @{advSearch}    Split String    ${advItem}    |
    \    Add New Advanced Search Term    ${advSearch[0]}    ${advSearch[1]}    ${advSearch[2]}    ${advSearch[3]}
    Robust Click    ${advancedDoneButton}

Save Search To Navigator Via UI
    [Arguments]    ${searchName}    ${treePath}    # ${treePath} should have tree items separated by "/" like Root/Project1/Exeperiment1
    [Documentation]    Save Search from screen to the Navigator with name ${searchName} by path ${treePath}
    Open Save Search Dialog
    Select From Save Search DropDown    Save to Navigator
    Input Text    ${searchNameTextField}    ${searchName}
    Robust Click    ${saveSearchButton}
    @{treePathArr}    Split String    ${treePath}    /
    ${treeCount}    Get Count    ${treePath}    /
    : FOR    ${treePaElement}    IN    @{treePathArr}
    \    Wait Until Page contains element    xpath=//div[contains(@class, 'jstree')]//a[text()='${treePaElement}']/../i    10s
    \    Click Element    xpath=//div[contains(@class, 'jstree')]//a[text()='${treePaElement}']/../i
    Robust Click    //div[contains(@class, 'jstree ')]//a[text()='${treePathArr[${treeCount}]}']
    Robust click    ${saveSearchNavigatorButton}
    Verify Toast Message    Search saved

Save Search Via UI
    [Arguments]    ${searchName}    ${search description}
    [Documentation]    Save Search from screenn with name ${searchName} and description ${search description}
    Open Save Search Dialog
    Select From Save Search DropDown    Save new (My Searches)
    Input Text    ${searchNameTextField}    ${searchName}
    Run Keyword If    "${search description}" != ""    Input Text    ${searchDescriptionTextFiled}    ${search description}
    Robust Click    ${saveSearchButton}
    Verify Toast Message    Search saved

Verify Toast Message
    [Arguments]    ${toast message}
    [Documentation]    Verifies the toast message that appears contain the specified argument text ${toast message}
    Wait Until Element Is Visible    ${toastMessagePopup}
    Element Should Contain    ${toastMessagePopup}    ${toast message}

Verify Search In Saving Search Navigator
    [Arguments]    ${searchName}    ${treePath}    # ${treePath} tree items should be separated by "/", like Root/project1/exp1...
    [Documentation]    Verify that search with name ${searchName} is present in Save Search to Navigator dialog tree by path ${treePath}
    Open Save Search Dialog
    Select From Save Search DropDown    Save to Navigator
    Input Text    ${searchNameTextField}    ${searchName}
    Robust Click    ${saveSearchButton}
    @{treePathArr}    Split String    ${treePath}    /
    ${treeCount}    Get Count    ${treePath}    /
    : FOR    ${treePaElement}    IN    @{treePathArr}
    \    Robust Click    //div[contains(@class, 'jstree ')]//a[text()='${treePaElement}']/../i
    log    ${treePathArr[0]}
    wait until page contains element    //div[contains(@class, 'jstree ')]//a[text()='${searchName}']
    Robust click    ${cancelSearchNavigatorButton}

Verify Search Is Not In Saving Search Navigator
    [Arguments]    ${searchName}    ${treePath}
    [Documentation]    Veify that search with name ${searchName} is not on the Navigatoro tree by the provided path ${treePath}
    Open Save Search Dialog
    Select From Save Search DropDown    Save to Navigator
    Input Text    ${searchNameTextField}    ${searchName}
    Robust Click    ${saveSearchButton}
    @{treePathArr}    Split String    ${treePath}    /
    ${treeCount}    Get Count    ${treePath}    /
    : FOR    ${treePaElement}    IN    @{treePathArr}
    \    Robust Click    //div[contains(@class, 'jstree ')]//a[text()='${treePaElement}']/../i
    log    ${treePathArr[0]}
    Wait until Page does not contain element    //div[contains(@class, 'jstree ')]//a[text()='${searchName}']
    Robust click    ${cancelSearchNavigatorButton}
    [Teardown]    # ${treePath} tree items should be separated by "/", like Root/project1/exp1...

Verify Result List Size
    [Arguments]    ${number}
    [Documentation]    Verify that displayed number of search result is equal ${number}
    Wait Until Element Contains    matches    1 of ${number}    30s

Execute Text Search
    [Arguments]    ${text}
    [Documentation]    Populate free-text search with ${text} and click search button
    Perform Text Search    ${text}
    Robust Click    ${searchButton}
    Wait Until Element Is Not Visible    ${searchingSpinner}    30s

Clear Search
    [Documentation]    Clear free-text and advanced search terms by OPTIONS > Clear
    unselect frame
    select frame    ${searchFrame}
    Wait Until Page Contains Element    ${optionsDropdown}    20s
    Robust Click    ${optionsDropdown}
    Wait Until Page Contains Element    ${optionsMenu}    30s
    Robust click    ${optionsClear}

Click Search Button
    [Documentation]    Click Search Button on Search screen
    Robust Click    ${searchButton}
    Wait Until Element Is Not Visible    ${searchingSpinner}    30s
    sleep    1s

Verify Too Many Search Dialog Appears
    [Documentation]    Verify that "Too Many Search terms" dialog is in the screen and contains correct text.
    ${xpathDialog}    set variable    //div[@id='dialog']
    ${title_expected}    set variable    Too many search terms
    ${line1_expected}    set variable    Advanced search is currently limited to a maximum of 6 enabled search terms.
    ${line2_expected}    set variable    You will need to remove or disable some of your search terms.
    Wait Until Page contains Element    ${xpathDialog}
    Wait Until Page contains Element    ${xpathDialog}//p[@class='title']
    ${title}    Get Text    ${xpathDialog}//p[@class='title']
    ${line1}    Get Text    ${xpathDialog}//p[@class='line'][1]
    ${line2}    Get Text    ${xpathDialog}//p[@class='line'][2]
    Should be Equal As strings    ${title_expected}    ${title}
    Should be Equal As strings    ${line1_expected}    ${line1}
    Should be Equal As strings    ${line2_expected}    ${line2}

Verify Too Many Search Dialog Not Appears
    [Documentation]    Verify, that "Too Many Search terms" dialog does not appear in the screen
    unselect frame
    select frame    ${searchFrame}
    ${xpathDialog_Block}    set variable    //div[@id='dialog' and contains(@style, 'display: block')]
    Wait Until Page Does Not Contain Element    ${xpathDialog_Block}    2s

Select Search By Option
    [Arguments]    ${searchBy}    # option name
    [Documentation]    Select Search by Option
    ...    - select Search By on Search screen from drop-down (Text, Chemistry, Tag...)
    ${xpath_searchOption}    set variable    //div[@id='ewb-popup-menu']//a[text()='${searchBy}']
    unselect frame
    select frame    ${searchFrame}
    Robust Click    ${searchByLink}
    Robust Click    ${xpath_searchOption}

Verify Benzene Ring Contains Green Dot
    [Documentation]    Verfiy Benzene Ring Contains \ Green Dot
    ...    - verify green dot is present on benzene ring button
    unselect frame
    select frame    ${searchFrame}
    Wait Until Page Contains Element    ${benzeneWithDot}    10s

Verify Benzene Ring Does Not Contain Green Dot
    [Documentation]    Verfiy Benzene Ring Does Not Contain Green Dot
    ...    - verify green dot is absent on benzene ring button
    unselect frame
    select frame    ${searchFrame}
    Wait Until Page Contains Element    ${benzeneNoDot}    10s

Click Clear Chemistry Search Cross Button
    [Documentation]    Click Cross Benzene Button
    ...    - click cross link next to benzene ring for chemistry search
    unselect frame
    select frame    ${searchFrame}
    Wait Until Page Contains Element    ${benzeneCrossButton}    5s
    Click Element    ${benzeneCrossButton}

Disable Advanced Search Terms
    [Arguments]    @{advancedItems}    # one advanced search should be in the following format {property name}|{operator}|{value}
    [Documentation]    Disable Advanced search terms on Search screen by clicking \ disable link in the lift conner on each terms from @{advancedItems} list.
    unselect frame
    select frame    ${searchFrame}
    : FOR    ${advItem}    IN    @{advancedItems}
    \    @{advSearch}    Split String    ${advItem}    |
    \    ${xpathDisabledItem}    set variable    //div[@class='termsView']//span[text()='${advSearch[0]}']/../span[text()='${advSearch[1]}']/../span[text()='${advSearch[2]}']/../../span[@class='query-control']
    \    ${tileXpath}    Set Variable    //div[@class='termsView']//span[text()='${advSearch[0]}']/../span[text()='${advSearch[1]}']/../span[text()='${advSearch[2]}']
    \    Wait Until Element Is Visible    ${tileXpath}
    \    ${advancedItemStatus}    IDBSSelenium2Library.Get Element Attribute    ${xpathDisabledItem}@title
    \    Run Keyword If    '${advancedItemStatus}'=='Disable Search Term'    Click Element    ${xpathDisabledItem}

Enable Advanced Search Terms
    [Arguments]    @{advancedItems}    # one advanced search should be in the following format {property name}|{operator}|{value}
    [Documentation]    Enable Advanced search terms on Search screen by clicking enable link in the lift conner on each terms from @{advancedItems} list.
    unselect frame
    select frame    ${searchFrame}
    : FOR    ${advItem}    IN    @{advancedItems}
    \    @{advSearch}    Split String    ${advItem}    |
    \    ${xpathDisabledItem}    set variable    //div[@class='termsView']//span[text()='${advSearch[0]}']/../span[text()='${advSearch[1]}']/../span[text()='${advSearch[2]}']/../../span[@class='query-control']
    \    ${tileXpath}    Set Variable    //div[@class='termsView']//span[text()='${advSearch[0]}']/../span[text()='${advSearch[1]}']/../span[text()='${advSearch[2]}']
    \    Wait Until Element Is Visible    ${tileXpath}
    \    ${advancedItemStatus}    IDBSSelenium2Library.Get Element Attribute    ${xpathDisabledItem}@title
    \    Run Keyword If    '${advancedItemStatus}'=='Enable Search Term'    Click Element    ${xpathDisabledItem}

Open 'New Search Term' Dialog
    [Documentation]    Perform openning 'New Search Term' dialog from Search screen
    unselect frame
    Wait Until Page Contains Element    ${searchFrame}
    select frame    ${searchFrame}
    ${text}    IDBSSelenium2Library.Get Element Attribute    ${advancedLink}@title
    Run Keyword If    '${text}'=='Advanced'    Robust Click    ${advancedLink}
    Wait Until Element Is Visible    ${newAdvancedTermLink}
    Robust Click    ${newAdvancedTermLink}
    Wait Until Page Contains Element    ${advancedDoneButton}    20s
    Wait Until Element Is Visible    ${advancedDoneButton}    20s

Execute Advanced Catalog Search
    [Arguments]    @{advancedItems}
    [Documentation]    ExecuteAdvanced Catalog Search
    ...    - open 'New Search Term' dialog
    ...    - @{advancedItems} is pipe-separated. Format is the following: dictionaryName|termName|propertyName|operatortextFieldOrPickLis|value
    ...
    ...    - operatortextFieldOrPickList are TEXTFIELD or PICKLIST
    ...
    ...    - click Done Button
    Performe Advanced Catalog Search    @{advancedItems}
    Robust Click    ${searchButton}
    Wait Until Element Is Not Visible    ${searchingSpinner}    30s

Performe Advanced Catalog Search
    [Arguments]    @{advancedItems}
    [Documentation]    Performe Advanced Catalog Search
    ...    - open 'New Search Term' dialog
    ...    - @{advancedItems} is pipe-separated. Format is the following: dictionaryName|termName|propertyName|operatortextFieldOrPickLis|value
    ...
    ...    - operatortextFieldOrPickList are TEXTFIELD or PICKLIST
    Open 'New Search Term' Dialog
    Wait Until Element Is Visible    ${advancedDoneButton}    20s
    : FOR    ${advItem}    IN    @{advancedItems}
    \    @{advSearch}    Split String    ${advItem}    |
    \    ${dictionary}    Replace String    ${advSearch[0]}    ${SPACE}    %20
    \    ${term}    Replace String    ${advSearch[1]}    ${SPACE}    %20
    \    ${property}    Replace String    ${advSearch[2]}    ${SPACE}    %20
    \    Add New Catalog Term    ${dictionary}    ${term}    ${property}    ${advSearch[3]}    ${advSearch[4]}
    \    ...    ${advSearch[5]}
    Robust Click    ${advancedDoneButton}

Verify Advanced Term PickList Value
    [Arguments]    ${name}    ${operator}    ${value}    ${expected}    # ${expected} - list values should be separated by | (item1|item2|item3|....)
    [Documentation]    Verify Advanced Term Pick-List Value
    ...    - select advanced search term on serahc screen by its:
    ...    - ${name}
    ...    - ${operator}
    ...    - $ {value}
    ...    - click on items
    ...    - verify item list equals ${expected}
    ${xpath}    set variable    //div[@class='termsView']//div[@query-term-id]//span[text()='${name}']/../span[text()='${operator}']/../span[text()='${value}']
    unselect frame
    Wait until page contains element    ${searchFrame}
    select frame    ${searchFrame}
    Robust Click    ${xpath}
    Robust Click    css=.query-term-popover .selectize-input.items
    @{expectedList}    Split String    ${expected}    |
    @{actualElements}    Get WebElements    css=.query-term-popover .selectize-dropdown-content > div
    ${expectedLength}    Get Length    ${actualElements}
    : FOR    ${i}    IN RANGE    0    ${expectedLength}
    \    ${iexp}    Evaluate    ${i}+1
    \    ${actualText}    IDBSSelenium2Library.Get Element Attribute    css=.query-term-popover .selectize-dropdown-content > div:nth-child(${iexp})@data-value
    \    Should Be Equal As Strings    ${expectedList[${i}]}    ${actualText}

Edit Advanced Term PickList Value
    [Arguments]    ${name}    ${operator}    ${value}    ${newvalue}
    [Documentation]    Edit Advanced Term PickList Value
    ...    - edit value in advanced search term from search screen
    ...    - find advanced search term by it ${name}, ${operator}, ${value}
    ...    - select ${newvalue} from pick-list for this term
    ${xpath}    set variable    //div[@class='termsView']//div[@query-term-id]//span[text()='${name}']/../span[text()='${operator}']/../span[text()='${value}']
    unselect frame
    Wait until page contains element    ${searchFrame}
    select frame    ${searchFrame}
    Robust Click    ${xpath}
    Sleep    1s
    Robust Click    css=.query-term-popover .selectize-input.items
    Robust Click    css=.query-term-popover .selectize-dropdown-content > div[data-value='${newvalue}']
    ${xpath}    set variable    //div[@class='termsView']//div[@query-term-id]//span[text()='${name}']/../span[text()='${operator}']/../span[text()='${newvalue}']
    Robust Click    ${xpath}

Select Match Conditions
    [Arguments]    ${conditions}
    [Documentation]    Select Match Conditions
    ...
    ...    - click 'Match all search terms' link
    ...    - select 'Match ALL search terms in the same records' if ${conditions}=ALL
    ...    - select 'Match ANY search terms' if ${conditions}=ANY
    ...    - select 'Match ALL search terms in the same measure' \ if ${conditions}= ALL MEASURE
    unselect frame
    select frame    ${searchFrame}
    Robust Click    ${matchMode}
    Run Keyword If    '${conditions}' == 'ANY'    Robust click    css=#query-term-matchAny
    Run Keyword If    '${conditions}' == 'ALL'    Robust click    css=#query-term-matchAll
    Run Keyword If    '${conditions}' == 'ALL MEASURE'    Robust click    css=#query-term-matchAllInMeasure
    Run Keyword If    '${conditions}' == 'ALL ITEM'    Robust click    css=#query-term-matchAllInItem

Edit Advanced Term Text Value And Operator
    [Arguments]    ${name}    ${operator}    ${value}    ${newOperator}    ${newValue}
    [Documentation]    Edit Advanced Term Pick-List Value
    ...    - edit value in advanced search term from search screen
    ...    - find advanced search term by it ${name}, ${operator}, ${value}
    ...    - select ${newvalue} from pick-list for this term
    ${xpath}    set variable    //div[@class='termsView']//div[@query-term-id]//span[text()='${name}']/../span[text()='${operator}']/../span[text()='${value}']
    unselect frame
    Wait until page contains element    ${searchFrame}
    select frame    ${searchFrame}
    Robust Click    ${xpath}
    Wait Until Page Contains Element    ${operatorPickList}
    ${newOperator}    Replace String    ${newOperator}    ${SPACE}    ${EMPTY}
    IDBSSelenium2Library.select from list    ${operatorPickList}    ${newOperator}
    Wait until page contains element    ${valueTextFiled}
    Input Text And Press Enter    ${valueTextFiled}    ${newValue}

Verify Advanced Search Link Text
    [Arguments]    ${expectedText}
    unselect frame
    select frame    ${searchFrame}
    Wait Until Element Text Is    ${advancedLink}    ${expectedText}
    unselect frame

Click Advanced Search Link
    unselect frame
    select frame    ${searchFrame}
    Robust Click    ${advancedLink}
    unselect frame

Verify 'Please Enter Something To Search' Message
    [Documentation]    Verify 'Please Enter Sommething To Search' Message
    ...
    ...    verify \ 'Please Enter Sommething To Search' message is on the screen
    unselect frame
    select frame    ${searchFrame}
    Wait until page Contains Element    ${pleaseEnterSomethingToSearchMessage}
    unselect frame

Delete Advanced Search Item
    [Arguments]    @{advancedItems}    # one advanced search should be in the following format {property name}|{operator}|{value}
    [Documentation]    Delete Advanced search terms on Search screen by clicking cross link in the lift conner on each terms from @{advancedItems} list.
    unselect frame
    select frame    ${searchFrame}
    : FOR    ${advItem}    IN    @{advancedItems}
    \    @{advSearch}    Split String    ${advItem}    |
    \    ${xpathDisabledItem}    set variable    //div[@class='termsView']//span[text()='${advSearch[0]}']/../span[text()='${advSearch[1]}']/../span[text()='${advSearch[2]}']/../i[contains(@class,'remove')]
    \    ${tileXpath}    Set Variable    //div[@class='termsView']//span[text()='${advSearch[0]}']/../span[text()='${advSearch[1]}']/../span[text()='${advSearch[2]}']
    \    Wait Until Element Is Visible    ${tileXpath}
    \    Click Element    ${xpathDisabledItem}

Perform Search By Templates
    [Arguments]    @{templates}    # list of \ tree items should be separated by "/" each, like Root/project1/template1
    [Documentation]    Performe Search By Templates
    ...    - Create advanced search tiles with 'template' as property
    Open 'New Search Term' Dialog
    : FOR    ${template}    IN    @{templates}
    \    @{templateSearch}    Split String    ${template}    |
    \    Add New Template Advanced Search Term    ${templateSearch[0]}    ${templateSearch[1]}
    Robust Click    ${advancedDoneButton}

Edit Advanced Template Term PickList Value
    [Arguments]    ${value}    ${newValue}    # ${newValue} \ tree items should be separated by "/" each, like Root/project1/template1
    [Documentation]    Edit Advanced Template Term PickList Value
    ...    - performed from Search screen
    ...    - click on search Template tile by name ${value}
    ...    - change template to ${newValue}
    ${xpath}    set variable    //div[@class='termsView']//div[@query-term-id]//span[text()='Template']/../span[text()='is']/../span[text()='${value}']
    unselect frame
    Wait until page contains element    ${searchFrame}
    select frame    ${searchFrame}
    Robust Click    ${xpath}
    Robust Click    xpath=//div[@class='query-term-popover']//a[text()='Choose']
    Select New Search Template From Tree    ${newValue}

Verify Search Button Pulsating
    [Documentation]    Verify Search Button Pulsating
    ...    - verify that 'Search' button has class 'pulsating' at the currect state
    sleep    1s
    unselect frame
    select frame    ${searchFrame}
    : FOR    ${i}    IN RANGE    5
    \    ${searchButtonClasses}    IDBSSelenium2Library.Get Element Attribute    ${searchButton}@class
    \    log    ${searchButtonClasses}
    \    ${ifContains}    Get Lines Containing String    ${searchButtonClasses}    pulsating
    \    Exit For Loop If    '${ifContains}'!='${EMPTY}'
    Should Contain    ${searchButtonClasses}    pulsating

Verify Yellow Message Bar Exist
    [Documentation]    Verify Yellow Message Bar Exist
    ...    - check that yellow bottom bar exist with requert to reexecute search
    unselect frame
    select frame    ${searchFrame}
    Wait Until Element Is Visible    ${yellowBottomMessagePanel}    5s

Verify No Search In Progress Spinner
    [Arguments]    ${spinnerTimeout}
    [Documentation]    Verify No Search In Progress Spinner
    ...    - verify, that there is spinner with "please wait" message
    ...    - there is no delay, element should not be displayed at all
    Wait Until Element Is Not Visible    ${searchingSpinner}    ${spinnerTimeout}

Verify Text Search Result
    [Arguments]    ${searchString}    @{expectedResultList}
    [Documentation]    Verify Text Search Result
    ...
    ...    - execute free text search by ${searchString}
    ...    - verify expected result @{expectedResultList}
    Execute Text Search    ${searchString}
    Verify Search Result List Exact By Title    @{expectedResultList}

Verify Text Search Result Is Blank
    [Arguments]    ${searchString}
    [Documentation]    Verify Text Search Result Is Blank
    ...
    ...    - Execute Free text search ${searchString}
    ...    - verify result is blank
    Execute Text Search    ${searchString}
    Verify Blank Search Result
    [Teardown]

Add New Advanced Search From Search Screen
    [Arguments]    @{advancedItems}    # @{advancedItems} one advanced search should be in the following format {search Term Name}|{property name}|{operator}|{value}
    unselect frame
    Wait Until Element Is Visible    ${searchFrame}    30s
    select frame    ${searchFrame}
    Robust Click    ${newAdvancedTermLink}
    Wait Until Element Is Visible    ${newSearchTermDialog}    10s
    : FOR    ${advItem}    IN    @{advancedItems}
    \    @{advSearch}    Split String    ${advItem}    |
    \    Add New Advanced Search Term    ${advSearch[0]}    ${advSearch[1]}    ${advSearch[2]}    ${advSearch[3]}
    Robust Click    ${advancedDoneButton}
