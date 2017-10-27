*** Settings ***
Library    IDBSSelenium2Library
Resource          ../../Selenium/general_resource.robot

*** Variables ***
${LOGIN_USERID_FIELD} =   xpath=//*[@id="login-userid"]
${SUBMIT_BUTTON} =    login-submit
${INVALID_LOGIN_MESSAGE} =   xpath=//*[@class='message-field'][contains(text(),'Sign in failed: invalid user name / password')]
${INVALID_PERMISSIOONS_MESSAGE} =    xpath=//*[@class='message-field'][contains(text(),'You do not have permission to use the E-WorkBook web client. Please contact your administrator')]

*** Keywords ***

Load Landing Page
    [Documentation]    Opens the Browser at the URL passed to the keyword by the arguments.
    ...
    ...    *Arguments*
    ...    browser - The Browser to use for the test
    ...    url - The URL to open the browser at
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Example
    ...    |Open Browser  |   browser=${BROWSER}  |    url=${URL}                                           |
    ...    |Open Browser  |   browser=Chrome      |    url= https://ewbserver-dev.com:8443/EWorkbookWebApp/ |
    [Arguments]    ${BROWSER}    ${URL}
    Open Browser   browser=${BROWSER}    url=${URL}


Verify Login Page Loaded
    [Documentation]    Validates the Login page is displayed by checking the Username field is visible
    ...     and then confirms the Title of the page is correctly defined.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Example
    ...    |Verify Login Page Loaded  |
    wait until page contains element    xpath=//*[@id='login-userid']
    Title Should Be    IDBS E-WorkBook

Verify SSO Login Page Loaded
    [Documentation]    Validates the SSO Login page is displayed by checking the Username field is visible
    ...    Note: This may need to be updated depending on the SSO set up being used.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Example
    ...    |Verify SSO Login Page Loaded  |
    wait until page contains element    xpath=//*[@id='cred_userid_inputtext']

Verify SAML Login Page Loaded
    [Documentation]    Validates the SSO Login page is displayed by checking the Username field is visible
    ...    Note: This may need to be updated depending on the SAML set up being used.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Example
    ...    |Verify SAML Login Page Loaded  |
    wait until page contains element    xpath=//*[@id='username']


Check Signin Error
    [Documentation]    Checks the correct error message is displayed during sign in. This should be "Sign in failed: invalid user name / password"
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Example
    ...    |Check Signin Error  |
    wait until page contains element  ${INVALID_LOGIN_MESSAGE}

Check SSO Signin Error
    [Documentation]    Checks the correct error message is displayed during sign in. This would vary depending on the SSO implementation
    ...    Therefore the test confirms the correct error message class is displayed as opposed to specifically checking the text of the message.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Example
    ...    |Check SSO Signin Error  |
    wait until page contains element  xpath=//div[contains(@class,'client_error_msg 30064')]

Check SAML Signin Error
    [Documentation]    Checks the correct error message is displayed during sign in. This would vary depending on the SSO implementation
    ...    Therefore the test confirms the correct error message class is displayed as opposed to specifically checking the text of the message.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Example
    ...    |Check SAML Signin Error  |
    wait until page contains element  xpath=//div[contains(@class,'client_error_msg 30064')]


Check Signin Permission Error
    [Documentation]    Checks the correct error message is displayed during sign in due to permissions.
    ...    This should be "You do not have permission to use the E-WorkBook web client. Please contact your administrator".
    ...
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Example
    ...    |Check Signin Permission Error  |
    wait until page contains element     ${INVALID_PERMISSIOONS_MESSAGE}

Check SSO Signin Permission Error
    [Documentation]    Checks the correct error message is displayed during sign in due to permissions.
    ...    This should contain "not a valid E-WorkBook user.". The selenium speed has been restricted due to time delay
    ...    during SSO authentication.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Example
    ...    |Check SSO Signin Permission Error  |
    set selenium speed    2
    wait until page contains element     xpath=//*[@class='ewb-label message'][contains(text(),'not a valid E-WorkBook user')]
    set selenium speed    1

Check SAML Signin Permission Error
    [Documentation]    Checks the correct error message is displayed during sign in due to permissions.
    ...    This should contain "not a valid E-WorkBook user.". The selenium speed has been restricted due to time delay
    ...    during SSO authentication.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Example
    ...    |Check SSO Signin Permission Error  |
    set selenium speed    2
    wait until page contains element     xpath=//*[@class='ewb-label message'][contains(text(),'not a valid E-WorkBook user')]
    set selenium speed    1

Enter Login Credentials
    [Documentation]    Logs in via the Standard login dialog on EWBServer installations using the ${user} and ${password} variables.
    ...
    ...    *Arguments*
    ...    ${USER}     - Username to signin with
    ...    ${PASSWORD} - Password to signin with
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Example
    ...    |Enter Login Credentials | username  | password  |
    [Arguments]    ${USER}    ${PASSWORD}
    Input Username    ${user}
    Input Password    ${password}

Enter SSO Login Credentials
    [Documentation]    Logs in via the SSO login dialog using the ${user} and ${password} variables.
    ...
    ...    *Arguments*
    ...    ${USER}     - Username to signin with
    ...    ${PASSWORD} - Password to signin with
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Example
    ...    |Enter SSO Login Credentials | username  | password  |
    [Arguments]    ${USER}    ${PASSWORD}
    Input SSO Username    ${user}
    Input SSO Password    ${password}

Enter SAML Login Credentials
    [Documentation]    Logs in via the SAML login dialog using the ${user} and ${password} variables.
    ...
    ...    *Arguments*
    ...    ${USER}     - Username to signin with
    ...    ${PASSWORD} - Password to signin with
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Example
    ...    |Enter SAML Login Credentials | username  | password  |
    [Arguments]    ${USER}    ${PASSWORD}
    Input SAML Username    ${user}
    Input SAML Password    ${password}


Enter SAML ReAuth Login Credentials
    [Documentation]    Logs in via the SAML login dialog using the ${user} and ${password} variables.
    ...
    ...    *Arguments*
    ...    ${USER}     - Username to signin with
    ...    ${PASSWORD} - Password to signin with
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Example
    ...    |Enter SAML Login Credentials | username  | password  |
    [Arguments]    ${USER}    ${PASSWORD}
    unselect frame
    select frame   xpath=//*[contains(@src,'/EWorkbookWebApp/signin')]
    Input SAML Username    ${user}
    Input SAML Password    ${password}
    Submit SAML Signin



Submit SSO Signin
    [Documentation]    Select the Signin Submit button on an SSO login form. The selenium speed has been restricted due
    ...    to time delay during SSO authentication.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Example
    ...    |Submit SSO Signin  |
    set selenium speed    1
    Robust Click    cred_sign_in_button
    set selenium speed    0

Submit SAML Signin
    [Documentation]    Select the Signin Submit button on an SAML login form. The selenium speed has been restricted due
    ...    to time delay during SAML authentication.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Example
    ...    |Submit SAML Signin  |
    set selenium speed    1
    Robust Click    xpath=//button[contains(text(),'Sign in')]
    set selenium speed    0

#Verify Page Failed
#    Fail Message    xpath=//div[text()="Sign in failed: invalid user name / password"

Input Username
    [Arguments]    ${username}
    [Documentation]    Waits until the Username field appears and then Inputs ${username} into the field on the login dialog
    ...
    ...    *Arguments*
    ...    Username - Username of the user
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Example
    ...    |Input Username  |User1  |
    Wait Until Page Contains Element    login-userid    30s
    Input Text    login-userid    ${username}

Input Password
    [Arguments]    ${password}
    [Documentation]    Waits until the Password field appears and then Inputs ${password} into the field on the login dialog
    ...
    ...    *Arguments*
    ...    Password - Password of the user
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Example
    ...    |Input Password  |Password1  |
    Wait Until Page Contains Element    login-password
    Input Text    login-password    ${password}

Input SSO Username
    [Arguments]    ${username}
    [Documentation]    Waits until the Username field appears and then Inputs ${username} into the field on the SSO login dialog
    ...
    ...    *Arguments*
    ...    Username - Username of the user
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Example
    ...    |Input SSO Username  |User1  |
    Wait Until Page Contains Element    cred_userid_inputtext    30s
    Input Text    cred_userid_inputtext    ${username}

Input SAML Username
    [Arguments]    ${username}
    [Documentation]    Waits until the Username field appears and then Inputs ${username} into the field on the SSO login dialog
    ...
    ...    *Arguments*
    ...    Username - Username of the user
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Example
    ...    |Input SSO Username  |User1  |
    Wait Until Page Contains Element    xpath=//input[@id='username']    30s
    Input Text    username    ${username}


Input SSO Password
    [Arguments]    ${password}
    [Documentation]    Waits until the Password field appears and then Inputs ${password} into the field on the SSO login dialog
    ...
    ...    *Arguments*
    ...    Password - Password of the user
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Example
    ...    |Input SSO Password  |Password1  |
    Wait Until Page Contains Element    cred_password_inputtext
    Input Text    cred_password_inputtext    ${password}

Input SAML Password
    [Arguments]    ${password}
    [Documentation]    Waits until the Password field appears and then Inputs ${password} into the field on the SAML login dialog
    ...
    ...    *Arguments*
    ...    Password - Password of the user
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Example
    ...    |Input SAML Password  |Password1  |
    Wait Until Page Contains Element    xpath=//input[@id='password']
    Input Text    password    ${password}


Submit Credentials
    [Documentation]    Submits credentials and waits for the submission is sucessful by checking login dialog is no longer present
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Precondition*
    ...    Username and Password fields must be filled in correctly before calling this keyword
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Example*
    ...    | Input Username | Administrator |
    ...    | Input Password | Administrator |
    ...    | _Submit Credentials And Ensure Logged In |
    Robust Click    ${SUBMIT_BUTTON}

