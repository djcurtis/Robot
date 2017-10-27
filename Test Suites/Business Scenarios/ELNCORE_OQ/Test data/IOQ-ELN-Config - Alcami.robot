*** Settings ***
Library           IDBSSelenium2Library
Library           IDBSHttpLibrary
Library           DateTime
Library           SecurityAPILibrary
Library           OperatingSystem
Library           EntityAPILibrary


*** Variables ***
${DATE}
#${EWB_SERVER}     alcami-uat.idbs-eworkbook.com
${EWB_SERVER}     canonspark
${EWB_THICK_SERVER}     canonspark
${URL-LDAP} =    https://${EWB_SERVER}:8443/EWorkbookWebApp/
${URL-EWBServer} =    https://${EWB_SERVER}:8443/EWorkbookWebApp/
${URL-SSO} =    https://${EWB_SERVER}:8443/EWorkbookWebApp/
${ADMIN_USR}     Administrator
${ADMIN_PW}       Admin1
#${ADMIN_PW}       Admin
${User1}          OQ_User01
${User1PWD}       OQUser1PWD
${User2}          OQ_User02
${User2PWD}       OQUser2PWD
${User3}          OQ_User03
${User3PWD}       OQUser3PWD
${User4}          OQ_User04
${User4PWD}       OQUser4PWD
${User5}          OQ_User05
${User5PWD}       OQUser5PWD
#${User1}          idbs_oquser1
#${User1PWD}       OQUser1PWD
#${User2}          idbs_oquser2
#${User2PWD}       OQUser2PWD
#${User3}          idbs_oquser3
#${User3PWD}       OQUser3PWD
#${User4}          idbs_oquser4
#${User4PWD}       OQUser4PWD
#${User5}          idbs_oquser5
#${User5PWD}       OQUser5PWD
${CORE_USERNAME}    IDBS_EWB_CORE
${CORE_PASSWORD}    IDBS_EWB_CORE
${DB_SERVER}      ewb-daily-nat.idbs-dev.com
${ORACLE_SID}     ora12c
${rest_api_host}    ${EWB_SERVER}
${rest_api_port}    8443
${rest_api_user}    Administrator
${rest_api_password}    Admin1
#${rest_api_password}       Admin
${AuthType}    EWBSERVER


*** Keywords ***

