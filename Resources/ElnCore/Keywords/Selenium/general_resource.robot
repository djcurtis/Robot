*** Settings ***
Documentation     A resource file containing IDBS defined keywords used for testing the IDBS E-WorkBook Web Client application. This resource file contains general keywords applicable across all functional areas.
...               This file is loaded by the common_resource.txt file which is automatically loaded when running tests through the Robot Framework.
...               *Version: E-WorkBook Web Client 9.1.0*
Resource          ../Common/common_resource.robot
Library           OperatingSystem
Resource          system_resource.robot
Resource          hierarchy_resource.robot
Library           StringProcessingLibrary
Library           String
Library           IDBSSelenium2Library
Resource          search_ui_resource.robot
Library           Collections
Resource          web_sign_off_resource.robot
Library           SystemUtilitiesLibrary
Library           TestDataGenerationLibrary
Library           XMLLibrary

*** Variables ***
${LOGIN URL}      https://${SERVER}:${WEB_CLIENT_PORT}/EWorkbookWebApp
${SEARCH URL}     https://${SERVER}:${WEB_CLIENT_PORT}/EWorkbookWebApp/#search/search
${TASK_VIEW_URL}    ${LOGIN URL}/#task/showTasks
${WORKFLOW_VIEW_URL}    ${LOGIN URL}/#task/showWorkflows
${ROOT URL}       https://${SERVER}:${WEB_CLIENT_PORT}/EWorkbookWebApp/#entity/displayEntity?entityId=1
${DEVICE DEFINITIONS URL}    https://${SERVER}:${WEB_CLIENT_PORT}/EWorkbookWebApp/#entity/displayEntity?entityId=3
${TEMP URL}       http://vpcs-autorunner
${HELP URL}       http://help.idbssupport.com/ewbweb_10/server?area%3Dewbweb_102%26mgr%3Dagm%26agt%3Dwsm%26wnd%3DE-WorkBook%20Suite%7Cwebhelp%26tpc%3D%2Fewbweb_10%2Fewbweb%2Fserver%2Fewbweb_102%2Fprojects%2FE-WorkBook%20Suite%2FWelcome.htm%3FRINoLog28301%3DT%26ctxid%3D%26project%3DE-WorkBook%20Suite    # 10.2 help URL
${SUPPORT URL}    https://idbs.force.com/idbs/login?ec=302&startURL=%2Fidbs%2Fs%2F
${WEB_APP_TIMEOUT}    10 minutes
${log off link}    app-header-link-log-off
${about link}     xpath=//*[@id="app-header-link-about"]/a
${search link}    xpath=//*[@id="ewb-header-link-search"]/a
${account link}    xpath=//*[@id="app-header-link-account"]/div
${navigate link}    xpath=//*[@id="app-header-widget-navigator"]/div
${help menu link}    app-header-link-help
${help link}      xpath=//*[@id="app-header-link-help"]/a
${customer support link}    xpath=//*[@id="app-header-link-customer-support"]/a
${displayed username}    app-header-username
${displayed header title}    app-header-title
${dialog close}    closeDialog
${Tile Tool Icon ID}    temporary value - should be replaced during test execution
${content header tool button}    xpath=//div[@id="application-header-toolButton"]/img
${context tool menu}    ewb-popup-menu
${content header workflows button}    ewb-record-workflows
${context workflows menu}    ewb-popup-menu
${Collapse All Documents}    x-menu-el-ewb-editor-command-collapse-all-docs
${Expand All Documents}    x-menu-el-ewb-editor-command-expand-all-docs
${Edit In E-WorkBook}    ewb-editor-command-edit-in-eworkbook
${error icon id}    xpath=//img[text()="Invalid web link"]
${insert header tool menu}    ewb-record-action-bar-add-item
${SELECT_TO_COMPLETE_TASK_LINK_ID}    ewb-record-outline-sign-off-task-select
${show-slide-in-panel}    app-header-show-slide-in-panel
${slide in panel}    xpath=//div[@class="ewb-app-slide-in-container"]
${ewb_header_link}    app-header-title

*** Keywords ***
Suite Startup
    [Documentation]    *Suite Startup Keyword*
    ...    This keyword should be defined as the Suite Setup keyword within the settings section of a test script file. It kills any active browser sessions, sets the selenium delay according to the ${DELAY} variable set within the common_resource file or as a variable passed into the test run. It also clears the JSESSIONID cookie from the browser under test before closing the browser ready for test case execution.
    Kill Browsers
    Open Browser To Login Page without Checking
    Set Selenium Speed    ${DELAY}
    Close All Browsers

Suite Teardown
    [Documentation]    *Suite Teardown Keyword*
    ...    This keyword should be defined as the Suite Teardown keyword within the settings section of a test script file. It kills any active browser sessions before ending the test script execution.
    Close All Browsers
    Kill Browsers

Test Teardown
    [Documentation]    Standard test teardown which clears cookies regardless of test run state to ensure next test run in the file starts from the correct starting point
    Run Keyword If Test Failed    Close All Browsers    # Clear cookies before closing on failure
    Run Keyword If Test Passed    Close All Browsers    # Clear cookies before closing on pass
    Run Keyword If Timeout Occurred    Close All Browsers    # Clear cookies before closing on timeout

Login Should Have Failed - Empty
    [Documentation]    Verifies that a login attempt failed due to an empty username
    Wait Until Element Is Visible    xpath=//div[text()="Enter your user name"]    30s

Logout of Application
    [Documentation]    Logs user out of the web client
    #Check ewb-web-mask is not present if it is logging out will not succeed
    Wait For No Mask
    #Check page is loaded by checking panel headers
    Wait Until Page Contains Element    xpath=//div[contains(@class, 'ewb-panel-header-label') and string-length(text())>0]    15s
    Robust Click    app-header-link-account
    Robust Click    ${log off link}
    # Wait until the 'logged out' page is displayed
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'ewb-login-dialog')]    30s
    # Go back to the main login page, lots of tests expect this to be the case after using this keyword
    Go To    ${LOGIN URL}
    Wait Until Page Contains Element    login-submit

Open Browser To Login Page
    [Documentation]    Opens browser to login dialog and sets selenium speed according to the ${DELAY} variable.
    Open Browser To Login Page Without Checking
    Wait Until Title Is    IDBS E-WorkBook    30s

Open Browser To Login Page without Checking
    [Documentation]    Opens browser to login dialog and sets selenium speed according to the ${DELAY} variable.
    Open Browser    ${LOGIN URL}    ${BROWSER}    ff_profile_dir=${FIREFOX_PROFILE_DIR}
    Run Keyword And Ignore Error    Maximize Browser Window
    Set Selenium Speed    ${DELAY}

Go To Login Page
    [Documentation]    Clears cookies and returns to URL, user session will have been killed.
    Run Keyword And Ignore Error    Delete All Cookies
    Go To    ${LOGIN URL}
    Title Should Be    IDBS E-WorkBook

Authenticate Session
    [Arguments]    ${session user}    ${session passwd}
    [Documentation]    General keyword for authenticating session on save/delete etc. Uses the ${session user} and ${session passwd} as the credentials
    Wait Until Page Contains Element    login-userid    30s
    Input Text    login-userid    ${session user}
    Input Text    login-password    ${session passwd}
    Submit Credentials

Open Browser to Page
    [Arguments]    ${Web Client Page}    ${user}    ${password}    ${expected_error}=${None}
    [Documentation]    Opens browser to ${Web Client Page} and logs in using ${user} and ${password} credentials and waits for page to load.
    ...
    ...    *Arguments*
    ...
    ...    - _web client page_ - The URL to open the browser to
    ...    - _user_ - the user to login with
    ...    - _password_ - the password to use during login
    ...    - _expected_error=None_ - (Optional) if opening the page with the given user should present an error dialog to the user set this argument to the expected text. If left blank no check is made.
    ...
    ...    *Return Value*
    ...
    ...    _alias_ = The alias of the browser that has been opened
    ${alias}=    Open Browser    ${Web Client Page}    ${BROWSER}    ff_profile_dir=${FIREFOX_PROFILE_DIR}
    Run Keyword And Ignore Error    Maximize Browser Window
    Set Selenium Speed    ${DELAY}
    Title Should Be    IDBS E-WorkBook
    Input Username    ${user}
    Input Password    ${password}
    Submit Credentials
    Wait Until Page Contains Element    app-header-title    30s
    Run Keyword If    '${expected_error}'=='${None}'    Wait Until Page Contains Element    xpath=//div[contains(@class, 'ewb-panel-header-label') and string-length(text())>0]    60s
    Run Keyword Unless    '${expected_error}'=='${None}'    Wait Until Page Contains    ${expected_error}
    [Return]    ${alias}

Open Browser To Search Page
    [Documentation]    Opens browser to ${SEARCH URL} and logs in as ${VALID USER} and waits for page to load
    Open Browser to Page    ${SEARCH URL}    ${VALID USER}    ${VALID PASSWD}
    Wait Until Title Is    IDBS E-WorkBook - Search    30s

Open Browser To Root
    [Documentation]    Opens browser to ${ROOT URL} and logs in using ${user} and ${password} credentials and waits for page to load
    Open Browser to Page    ${ROOT URL}    ${VALID USER}    ${VALID PASSWD}
    Wait Until Title Is    IDBS E-WorkBook - Root    30s

Open Browser To Exp
    [Arguments]    ${user}    ${password}
    [Documentation]    Opens browser to ${EXP URL} and logs in using ${user} and ${password} credentials and waits for page to load
    Open Browser to Page    ${EXP URL}    ${user}    ${password}
    Wait Until Title Is    IDBS E-WorkBook - Experiment 1    30s

Robust Click
    [Arguments]    ${locator}    ${type}=element
    [Documentation]    Waits for the presence of an element identified by ${locator} before clicking on the element.
    ...    This keyword is more robust to unpredictable page loading times.
    Wait Until Page Contains Element    ${locator}    30s
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${locator}
    Wait Until Element Is Visible    ${locator}    30s
    Run Keyword If    '${type}'=='link'    Wait Until Keyword Succeeds    30s    1s    Click Link    ${locator}
    Run Keyword If    '${type}'=='image'    Wait Until Keyword Succeeds    30s    1s    Click Image    ${locator}
    Run Keyword If    '${type}'=='button'    Wait Until Element Is Enabled    ${locator}    30s
    Run Keyword If    '${type}'=='button'    Wait Until Keyword Succeeds    30s    1s    Click Button    ${locator}
    Run Keyword If    '${type}'=='element'    Wait Until Keyword Succeeds    30s    1s    Click Element    ${locator}

Robust Double Click Element
    [Arguments]    ${locator}
    [Documentation]    Waits for the presence of an element identified by ${locator} before double clicking on the element.
    ...    This keyword is more robust to unpredictable page loading times.
    Wait Until Page Contains Element    ${locator}    30s
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${locator}
    Wait Until Element Is Visible    ${locator}    30s
    Wait Until Keyword Succeeds    30s    1s    Run Keyword Unless    '${OPERATING_SYSTEM}'=='OSX'    Double Click Element    ${locator}
    Wait Until Keyword Succeeds    30s    1s    Run Keyword If    '${OPERATING_SYSTEM}'=='OSX'    Simulate    ${locator}
    ...    dblclick

Robust Link Click
    [Arguments]    ${locator}
    [Documentation]    Waits for the presence of a link identified by ${locator} before clicking on the link.
    ...    This keyword is more robust to unpredictable page loading times.
    Wait Until Keyword Succeeds    30s    1s    Page Should Contain Link    ${locator}
    Wait Until Keyword Succeeds    30s    1s    Click Link    ${locator}

Wait Twenty Seconds
    [Documentation]    Waits for large pages to load by issuing a 20 second sleep command.
    Sleep    20s    reason=Waiting for page to load

Wait Five Seconds
    [Documentation]    Waits for large pages to load by issuing a 5 second sleep command.
    Sleep    5s    reason=Waiting for page to load


Check and Dismiss No Open Edit Error Message
    [Documentation]    Checks for the presence of the error message that should appear for users that do not have open or edit permissions for the entity type being selected and subsquently dismisses the error dialog.
    Wait Until Page Contains    You do not have permissions to open the requested record    30s
    Page Should Contain Element    okButton
    Element Text Should Be    okButton    Close
    Click Element    okButton

Check Reauthentication Dialog Present
    [Documentation]    Checks that reauthentication dialog is displayed to the user and that the username field is disabled and the password field is enabled.
    Wait Until Page Contains Element    xpath=//div[text()="Reauthentication Required"]    30s    # reauth dialog
    Page Should Contain Element    login-userid    # userid field
    Page Should Contain Element    login-password    # userpassword field
    Page Should Contain Element    login-submit    # submit link
    Element Should Be Disabled    login-userid
    Element Should Be Enabled    login-password

Reauthenticate Session
    [Arguments]    ${password}
    [Documentation]    Re-authenticates a users session using the ${password} variable.
    Input Text    login-password    ${password}
    Submit Credentials



Get Entity URL
    [Arguments]    ${name}
    [Documentation]    Obtains the URL of an entity based on its display name given by ${name} and stores the URL in the variable defined by ${URL variable}
    ${URL variable} =    IDBSSelenium2Library.Get Element Attribute    xpath=//a[text()="${name}"]@href
    Set Suite Variable    ${URL variable}



Dialog Should Be Present
    [Arguments]    ${Dialog Name}    ${timeout}=30s
    Wait Until Page Contains Element    xpath=//div[contains(@class, 'ewb-window-header-title') and text()="${Dialog Name}"]    ${timeout}

Popup Should Be Present
    [Arguments]    ${Dialog Name}
    Wait Until Page Contains Element    xpath=//div[contains(@class, 'ewb-popup-panel')]//div[text()="${Dialog Name}"]    30s

Dialog Should Not Be Present
    [Arguments]    ${Dialog Name}
    Wait Until Page Does Not Contain Element    xpath=//div[contains(@class, 'ewb-window-header-title') and text()="${Dialog Name}"]    10s

Click OK
    Robust Click    okButton    button

Click Cancel
    Robust Click    cancelButton    button

Click No
    Robust Click    xpath=//button[contains(@class,"ewb-button-second") and text()="No"]    button


Get Timestamp
    [Arguments]    ${format}    ${date_to_be_formatted}=NOW
    [Documentation]    Gets todays date in the format specified by the $[format} argument. Can also format a date passed to the keyword in the format YYYY-MM-DD hh:mm:ss or YYYYMMDD hhmmss or NOW + 1 Day (replace the + 1 Day with the correct date increment/decrement - see Get Time keyword for more information)
    ...
    ...    *Arguments*
    ...    format = The required format to be returned. Valid formats are: "DEFAULT", "EU SHORT", "US SHORT"
    ...
    ...    date = Optional date to be formatted, if not specified todays date will be used
    ...
    ...    *Preconditions*
    ...    None
    ...
    ...    *Return Value*
    ...    timestamp = the timestamp in the specified format
    ...
    ...    *Examples* (Assuming "todays date" of 15/12/2011)
    ...    | ${default}= | Get Timestamp | DEFAULT |
    ...    | ${eushort}= | Get Timestamp | EU SHORT |
    ...    | ${usshort}= | Get Timestamp | US SHORT |
    ...    | ${tomorrow}= | Get Time | time=NOW + 1 Day |
    ...    | ${tomorrow}= | Get Timestamp | DEFAULT |
    ...    =>
    ...    - ${default} = '15-Dec-2011'
    ...    - ${eushort} = '15/12/11'
    ...    - ${usshort} = '12/15/11'
    ...    - ${tomorrow} = '16-Dec-2011)
    ${yyyy}    ${mm}    ${unconverted dd}=    Get Time    year,month,day    ${date_to_be_formatted}
    ${dd}=    Set Variable If    '${unconverted dd}'=='01'    01    '${unconverted dd}'=='02'    02    '${unconverted dd}'=='03'
    ...    03    '${unconverted dd}'=='04'    04    '${unconverted dd}'=='05'    05    '${unconverted dd}'=='06'
    ...    06    '${unconverted dd}'=='07'    07    '${unconverted dd}'=='08'    08    '${unconverted dd}'=='09'
    ...    09    '${unconverted dd}'=='10'    10    '${unconverted dd}'=='11'    11    '${unconverted dd}'=='12'
    ...    12    '${unconverted dd}'=='13'    13    '${unconverted dd}'=='14'    14    '${unconverted dd}'=='15'
    ...    15    '${unconverted dd}'=='16'    16    '${unconverted dd}'=='17'    17    '${unconverted dd}'=='18'
    ...    18    '${unconverted dd}'=='19'    19    '${unconverted dd}'=='20'    20    '${unconverted dd}'=='21'
    ...    21    '${unconverted dd}'=='22'    22    '${unconverted dd}'=='23'    23    '${unconverted dd}'=='24'
    ...    24    '${unconverted dd}'=='25'    25    '${unconverted dd}'=='26'    26    '${unconverted dd}'=='27'
    ...    27    '${unconverted dd}'=='28'    28    '${unconverted dd}'=='29'    29    '${unconverted dd}'=='30'
    ...    30    '${unconverted dd}'=='31'    31
    ${short year}=    Set Variable If    '${yyyy}'=='2011'    11    '${yyyy}'=='2012'    12    '${yyyy}'=='2013'
    ...    13    '${yyyy}'=='2014'    14    '${yyyy}'=='2015'    15    '${yyyy}'=='2016'
    ...    16    '${yyyy}'=='2017'    17    '${yyyy}'=='2018'    18
    ${short month}=    Set Variable If    '${mm}'=='01'    Jan    '${mm}'=='02'    Feb    '${mm}'=='03'
    ...    Mar    '${mm}'=='04'    Apr    '${mm}'=='05'    May    '${mm}'=='06'
    ...    Jun    '${mm}'=='07'    Jul    '${mm}'=='08'    Aug    '${mm}'=='09'
    ...    Sep    '${mm}'=='10'    Oct    '${mm}'=='11'    Nov    '${mm}'=='12'
    ...    Dec
    ${timestamp}=    Set Variable If    '${format}'=='DEFAULT'    ${dd}-${short month}-${yyyy}    '${format}'=='EU SHORT'    ${dd}/${mm}/${short year}    '${format}'=='US SHORT'
    ...    ${mm}/${dd}/${short year}
    [Return]    ${timestamp}

Click Close
    [Documentation]    Simulates clicking a button with the text "Close"
    Robust Click    xpath=//button[text()="Close"]    button


Click Tertiary Button
    [Documentation]    The third button (usually cancel)
    Robust Click    tertiaryButton    button


Get Current Element Attribute Value
    [Arguments]    ${element_id}    ${attribute}
    [Documentation]    Uses javascript to pull out the current value of an element as it exists in the DOM. This is often useful for elements who's value is set/changed after the element is created since "Get Element Attribute" will often fail to return the current value in these circumstances.
    ...
    ...    *Arugments*
    ...
    ...    - _element_id_ - the ID of the element to get the current value of
    ...    - _attribute_ - the name of the attribute to retrieve a value for
    ...
    ...    *Return Value*
    ...
    ...    - _element_value_ - the current value of the element attribute
    ...
    ...    *Precondition*
    ...
    ...    Element must be present on the page before calling this keyword. If the element is not present the javascript call will fail.
    ...
    ...    *Example*
    ...    | Get Current Element Attribute Value | my_element | value |
    ${element_value}=    Execute Javascript    window.document.getElementById('${element_id}').${attribute}
    [Return]    ${element_value}


Change EWB Password Policy
    [Arguments]    ${Mixed_Case}    ${Numeric}    ${Punctuation}    ${Max_Length}    ${Min_Length}    ${Max_Failed_Logins}
    ...    ${Password_Expiry}
    [Documentation]    This keyword sets the EWB Password policy for use with an EWB Password server
    ...
    ...    _All values must be set!_
    ...
    ...    *${Mixed_Case}* = Accepts values of 'true' or 'false'
    ...    *${Numeric}* = Accepts values of 'true' or 'false'
    ...    *${Punctuation}* = Accepts values of 'true' or 'false'
    ...    *${Max_Length}* = Accepts integer values between 10 and 20
    ...    *${Min_Length}* = Accepts integer values between 0 and 10
    ...    *${Max_Failed_Logins}* = Accepts integer values between 1 and 10
    ...    *${Password_Expiry}* = Accepts values of 7, 14, 30, 60 and 90 *ONLY*
    Connect To Database    ${CORE_USERNAME}    ${CORE_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    Execute    UPDATE system_settings SET string_data = '${Mixed_Case}' WHERE settings_name LIKE '%Policy Mixed Case Required'
    Execute    UPDATE system_settings SET string_data = '${Numeric}' WHERE settings_name LIKE '%Policy Numeric Required'
    Execute    UPDATE system_settings SET string_data = '${Punctuation}' WHERE settings_name LIKE '%Policy Punctuation Required'
    Execute    UPDATE system_settings SET string_data = '${Max_Length}' WHERE settings_name LIKE '%Policy Max Length'
    Execute    UPDATE system_settings SET string_data = '${Min_Length}' WHERE settings_name LIKE '%Policy Min Length'
    Execute    UPDATE system_settings SET string_data = '${Max_Failed_Logins}' WHERE settings_name LIKE '%Policy Max Failed Logins'
    Execute    UPDATE system_settings SET string_data = '${Password_Expiry}' WHERE settings_name LIKE '%Policy Password TTL'
    Disconnect From Database

Open Browser To Record
    [Arguments]    ${RecordID}    ${username}    ${password}    ${record_name}=${EMPTY}
    ${record_url}=    Create Entity URL    ${RecordID}
    Open Browser To Page    ${record_url}    ${username}    ${password}
    Run Keyword If    '${record_name}'!='${EMPTY}'    Wait Until Title Is    IDBS E-WorkBook - ${record_name}    30s
    Sleep    5s

Create Entity URL
    [Arguments]    ${entity_id}
    [Documentation]    *Creates a URL for the given entity ID - useful if you have created an entity via the entity service and want to get the URL to navigate to the entity directly.*
    ...
    ...    *Arguments*
    ...    - _entity_id_ - the entity ID of the the entity to be used
    ...
    ...    *Return Value*
    ...    - _entity_url_ - the full URL for the entity
    ...
    ...    *Preconditions*
    ...
    ...    The entity ID must be valid - this keyword does no validation that the entity ID is valid
    ...
    ...    *Example*
    ...
    ...    | ${experiment_id}= | EntityAPILibrary.Create Experiment | ${project_id} | Test_Experiment |
    ...    | ${experiment_url}= | Create Entity URL | ${experiment_id} |
    ${entity_url}=    Set Variable    ${LOGIN URL}/#entity/displayEntity?entityId=${entity_id}
    [Return]    ${entity_url}

Open Browser To Tag Search Results Page
    [Arguments]    ${Tag Name}    ${username}    ${password}
    Open Browser To Page    ${WEB_CLIENT_HTTP_SCHEME}://${SERVER}:${WEB_CLIENT_PORT}/EWorkbookWebApp/#entity/entitiesByTag?tag=${Tag Name}    ${username}    ${password}

Open Browser To Account Settings Page
    [Arguments]    ${username}    ${password}    ${tab}=FollowUsers
    Open Browser To Page    ${WEB_CLIENT_HTTP_SCHEME}://${SERVER}:${WEB_CLIENT_PORT}/EWorkbookWebApp/#showAccountSettings?tab=${tab}    ${username}    ${password}

Open Browser To Activities Page
    [Arguments]    ${username}=${VALID USER}    ${password}=${VALID PASSWD}
    Open Browser To Page    ${WEB_CLIENT_HTTP_SCHEME}://${SERVER}:${WEB_CLIENT_PORT}/EWorkbookWebApp/#activities/myActivity    ${username}    ${password}

Set Rest API User
    [Arguments]    ${username}=${VALID USER}    ${password}=${VALID PASSWD}
    [Documentation]    Provides a quick and easy way to set the user name/password used for Rest API calls
    Set Suite Variable    ${rest_api_user}    ${username}
    Set Suite Variable    ${rest_api_password}    ${password}

Reset Expired Password
    [Arguments]    ${user}
    [Documentation]    Resets the password update date for the given user to todays date/time
    Connect To Database    ${SEC_USERNAME}    ${SEC_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    Execute    update USERS set DISABLED='F',FAILED_AUTH_COUNT='0',LAST_PASSWORD_UPDATE=CURRENT_TIMESTAMP(3) where NAME='${user}'
    Disconnect From Database

Remove User Roles
    [Arguments]    ${user}
    [Documentation]    Removes all the roles currently assigned to a user. *BE CAREFUL WHEN USING THIS !*
    ...    This keyword is intended for use when setting up users for tests.
    Connect To Database    ${SEC_USERNAME}    ${SEC_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    Execute    delete from USER_ENTITY_ROLES where USER_ID in (select USER_ID from USERS where NAME='${user}')
    Disconnect From Database

Set Maximum Password Length
    [Documentation]    Sets the password length to the maximum allowed value (20) so that automation test users can be created
    Connect To Database    ${CORE_USERNAME}    ${CORE_PASSWORD}    //${DB_SERVER}/${ORACLE_SID}
    Run Keyword And Ignore Error    Execute    insert into SYSTEM_SETTINGS (ORDER_KEY,DATA_TYPE,STRING_DATA,NUMBER_DATA,SETTINGS_NAME) values (0,'INTEGER','20','20','Policy Management/Policy Max Length')
    Execute    update SYSTEM_SETTINGS set STRING_DATA='20',NUMBER_DATA='20' where SETTINGS_NAME='Policy Management/Policy Max Length'
    Disconnect From Database

Create Test User
    [Arguments]    ${user-name}    ${password}
    [Documentation]    Creates a user for use in the automated tests
    Set Maximum Password Length
    Set Suite Variable    ${rest_api_host}    ${SERVER}
    Set Rest API User    ${VALID USER}    ${VALID PASSWD}
    SecurityAPILibrary.Create User    ${user-name}    ${user-name}    ${password}
    Remove User Roles    ${user-name}
    Reset Expired Password    ${user-name}

Wait For Mask
    [Documentation]    Waits until the page is masked
    Wait Until Page Contains Element    xpath=//body[contains(@class,'ewb-mask-present')]

Wait For No Mask
    [Documentation]    Waits until the page is no longer masked
    Wait Until Page Contains Element    xpath=//body[contains(@class,'ewb-no-mask-present')]    60s
    # Sometimes a mask is removed, then added, then removed (for multi-step operations), catch this by waiting for a while and then checking again
    Sleep    1s
    Wait Until Page Contains Element    xpath=//body[contains(@class,'ewb-no-mask-present')]    60s

Kill Browsers
    [Documentation]    Kills all processes of the browser currently being tested.
    ...
    ...    This kewyord relies on the BROWSER variable to identify the name of teh process to kill.
    Run Keyword If    '${BROWSER}'=='IE'    Kill Processes With Name    iexplore.exe
    Run Keyword If    '${BROWSER}'=='IE'    Kill Processes With Name    mshta.exe
    Run Keyword If    '${BROWSER}'=='FIREFOX'    Kill Processes With Name    firefox.exe
    Run Keyword If    '${BROWSER}'=='CHROME'    Kill Processes With Name    chrome.exe
