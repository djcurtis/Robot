*** Settings ***
Resource    ../Access Control/Resource Objects/LoginPage.robot
Resource    ../Navigation/HomePage.robot

*** Variables ***
${BROWSER} =    Chrome

*** Keywords ***

Login to ElnCore
     [Documentation]    Load the Landing Page Login screen and submit the user credentials. The test checks whether
     ...    SSO or EWBServer is being used before implementing the specific keywords appropriate for those Auth systems.
     ...
     ...    *Arguments*
     ...    Username - Username of the user
     ...    Password - Password of the user
     ...    URL - URL of the landing page login into
     ...
     ...    *Precondition*
     ...    None
     ...
     ...    *Return Value*
     ...    None
     ...
     ...    *Example
     ...    |Login to ElnCore  |${User1} |${User1PWD}  |${URL-EWBServer}  |
     ...    |Login to ElnCore  |User1 |User1PWD  |https://EWBSERVER:8443/EWorkbookWebApp/  |
     [Arguments]    ${USERNAME}  ${PASSWORD}    ${URL}
     LoginPage.Load Landing Page    ${BROWSER}    ${URL}
     Run Keyword If    '${AuthType}' == 'EWBSERVER'    LoginPage.Verify Login Page Loaded
     Run Keyword If    '${AuthType}' == 'SSO'    LoginPage.Verify SSO Login Page Loaded
     Run Keyword If    '${AuthType}' == 'SAML'    LoginPage.Verify SAML Login Page Loaded
     Run Keyword If    '${AuthType}' == 'EWBSERVER'    LoginPage.Enter Login Credentials    ${USERNAME}    ${PASSWORD}
     Run Keyword If    '${AuthType}' == 'SSO'    LoginPage.Enter SSO Login Credentials    ${USERNAME}    ${PASSWORD}
     Run Keyword If    '${AuthType}' == 'SAML'    LoginPage.Enter SAML Login Credentials    ${USERNAME}    ${PASSWORD}
     Run Keyword If    '${AuthType}' == 'EWBSERVER'    LoginPage.Submit Credentials
     Run Keyword If    '${AuthType}' == 'SSO'    LoginPage.Submit SSO Signin
     Run Keyword If    '${AuthType}' == 'SAML'    LoginPage.Submit SAML Signin

Login Success
     set selenium speed    2
     HomePage.Verify Login Successful
     set selenium speed    0

# Commented out by Dan Curtis as this is functionality that we could work towards in the future. Descoped as most customers will use LDAP which will not reveal the issue seen with Password Expiry.
#Login to ElnCore
#    [Arguments]    ${USERNAME}  ${PASSWORD}    ${URL}
#    Web Client Login    ${USERNAME}  ${PASSWORD}    ${URL}
#    ${pwd_expired}=     wait until page contains  xpath=//div[contains(@class,'ewb-message-box-text')][contains(text(),'Your password has expired, you will need to enter a new password in order to log in')
#    run keyword if  ${pwd_expired} == 'TRUE'    Reset Expired Password

#Password Reset
#    [Arguments]    ${password}  ${PASSWORD}    ${URL}
#    Robust Click  xpath=//*[@id='okButton']
#    wait until page contains  xpath=//div[@class='ewb-account-settings-username-label-wrapper']/div[@class='ewb-account-settings-username-label'][contains(text(),'OQ_User1')]
#    Input Text    oldPasswordTextBox    ${autosetpassword}
#    Input Text    newPasswordTextBox    ${password}
#    Input Text    confirmPasswordTextBox    ${password}
#    Robust Click    changePasswordButton
#    Web Client Login    ${USERNAME}  ${password}    ${URL}

#Web Client Login
#    [Arguments]    ${USERNAME}  ${PASSWORD}    ${URL}
#    LoginPage.Load Landing Page    ${BROWSER}    ${URL}
#    LoginPage.Verify Login Page Loaded
#    LoginPage.Enter Login Credentials    ${USERNAME}    ${PASSWORD}
#    LoginPage.Submit Credentials
#    HomePage.Verify Login Successful

Verify Access Denied - Permissions
    Run Keyword If    '${AuthType}' == 'EWBSERVER'    LoginPage.Check Signin Permission Error
    Run Keyword If    '${AuthType}' == 'SSO'    LoginPage.Check SSO Signin Permission Error
    Run Keyword If    '${AuthType}' == 'SAML'    LoginPage.Check SAML Signin Permission Error

Verify Access Denied - Credentials
    Run Keyword If    '${AuthType}' == 'EWBSERVER'    LoginPage.Check Signin Error
    Run Keyword If    '${AuthType}' == 'SSO'    LoginPage.Check SSO Signin Error
    Run Keyword If    '${AuthType}' == 'SAML'    LoginPage.Check SAML Signin Error








