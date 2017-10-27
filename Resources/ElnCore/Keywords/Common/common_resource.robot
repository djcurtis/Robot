*** Settings ***
Documentation     A template of the common_resource.txt file for E-WorkBook test suites.
...               This resource file should be edited with the correct parameters for your local environment and saved as
...               common_resource.txt to "EWB Automated Tests/Libraries". Any new environment variables should be defined in this common_resource.template file, checked into subversion and communicated to other users.
...               No environment variables should be defined in functionality specific resource files or individual test suites.



*** Variables ***
${ROOT_DIR}       C:\EWB SVN\E-Workbook\Automated Tests
#####
#Application server variables
#####
# EWB Application server
${SERVER}         VQA-EWB-RAD01
# Whether the web client is running over 'http' or 'https'
${WEB_CLIENT_HTTP_SCHEME}    https
# Whether the web services are running over 'http' or 'https'
${WEB_SERVICE_HTTP_SCHEME}    https
# The port used for thick client communications. Default port - 5277
${THICK_CLIENT_PORT}    8443
# The port used for web client communications. Default ports - HTTP: 6060, HTTPS: 8443
${WEB_CLIENT_PORT}    8443
# The port used for web service communications. Default ports - HTTP: 6060, HTTPS: 8443
${WEB_SERVICE_PORT}    8443
# App server host OS
${APP_SERVER_OS}    Windows
#DB server host OS
${DB_SERVER_OS}    Windows
#####
#Core database variables
#####
# EWB database server machine name
${DB_SERVER}      VQA-EWB-RAD01
# Oracle database SID
${ORACLE_SID}     CUSTOM01
# Machine_OS
${Machine_OS}     ${EMPTY}
# Bit
${Bit}            ${EMPTY}
# EWB database prefix
${DB_PREFIX}      IDBS
#Database schema names and passwords
${CORE_USERNAME}    IDBS_EWB_CORE
${CORE_PASSWORD}    IDBS_EWB_CORE
${POOL_USERNAME}    IDBS_EWB_POOL
${POOL_PASSWORD}    IDBS_EWB_POOL
${VIEW_USERNAME}    IDBS_EWB_VIEW
${VIEW_PASSWORD}    IDBS_EWB_VIEW
${DICT_USERNAME}    IDBS_EWB_DICT
${DICT_PASSWORD}    IDBS_EWB_DICT
${SEC_USERNAME}    IDBS_EWB_SEC
${SEC_PASSWORD}    IDBS_EWB_SEC
${WIDGETS_USERNAME}    IDBS_EWB_WIDGETS
${WIDGETS_PASSWORD}    IDBS_EWB_WIDGETS
${BIOMART_USERNAME}    IDBS_EWB_DW
${BIOMART_PASSWORD}    IDBS_EWB_DW
${SA_USERNAME}    IDBS_EWB_SA
${SA_PASSWORD}    IDBS_EWB_SA
${CATALOG_HUB_USERNAME}    IDBS_CATALOG_HUB
${CATALOG_HUB_PASSWORD}    IDBS_CATALOG_HUB
${FHR_HUB_USERNAME}    IDBS_FHR_HUB
${FHR_HUB_PASSWORD}    IDBS_FHR_HUB
${LANDSCAPE_HUB_USERNAME}    IDBS_LSCAPE_HUB
${LANDSCAPE_HUB_PASSWORD}    IDBS_LSCAPE_HUB
#####
#EWB version variables
#####
# Copyright version year
${version year}    2016
# EWB version number
${VERSION_NUMBER}    10.1.2
# Applicable to nightly builds which display a revision number in the web client
${REVISION NUMBER}    ${EMPTY}
#####
#Hub Technology variables
#####
# Asset hub database prefix
${ASSET_DB_PREFIX}    AH1
# Asset hub ID
${ASSET_HUB_ID}    HUB1
# Clinical data hub database prefix
${CLINICAL_DB_PREFIX}    CDH
# Biomolecular hub database prefix
${BIOMOLECULAR_DB_PREFIX}    BMH
# Base term path list - this is the path to the base term(s) which all other terms in the hub inherit from. Multiple terms can be specified by splitting each term by a double space.
@{Base_term_path_list}    /IDBS-Applications/Core/Asset Hub/Asset
#####
#General web service variables
#####
# The server hosting the E-WorkBook web services
${rest_api_host}    ${SERVER}
# The username to use for web service requests unless overriden within an individual test case
${SERVICES USERNAME}    Administrator
${rest_api_user}    ${SERVICES USERNAME}
# The user password to use for web service requests unless overriden within an individual test case
${SERVICES PASSWORD}    2$RedCross2!
${rest_api_password}    ${SERVICES PASSWORD}
#####
#Catalog web service variables - change only if different from the core server/ variables defined above
#####
# Catalog service server
${CATALOG_WS_SERVER}    ${SERVER}
# Catalog service port
${CATALOG_WS_PORT}    ${WEB_SERVICE_PORT}
# Catalog service protocol, either 'http' and 'https'
${CATALOG_WS_SCHEME}    ${WEB_SERVICE_HTTP_SCHEME}
# Catalog service username
${CATALOG_WS_USER}    ${SERVICES USERNAME}
# Catalog service password
${CATALOG_WS_PASSWORD}    ${SERVICES PASSWORD}
#####
#Tuple web service variables
#####
# EWB catalog export file location - checked out with EWB Llbraries and test suites
${CATALOG EXPORT FILEPATH}    ${ROOT_DIR}/Test Data/Hubtech/Asset Hub/Tuple Web Service/Tuple Services Solution Terms.xml
${BAKING SOLUTION CATALOG EXPORT PATH}    ${ROOT_DIR}/Test Data/Hubtech/Asset Hub/Baking.xml
#####
# Web client variables
#####
# The browser to use in web client tests, can be FIREFOX, IE, CHROME, EDGE
${BROWSER}        CHROME
# The Operating system being used, can be WINDOWS or OSX
${OPERATING_SYSTEM}    WINDOWS
#Only used by the automation system, does not need setting locally
${FIREFOX_PROFILE_DIR}    ${ROOT_DIR}/Test Suites/Web Client/Profile Management/
# Delay between Selenium actions, in seconds
${DELAY}          0
# Set to DEBUG to show highlighting of actions in browser for debugging purposes
${DEBUG LEVEL}    none
${ADMIN USER}     Administrator
${ADMIN PASSWD}    Administrator
${VALID USER}     Administrator
${VALID PASSWD}    Administrator
${SECOND USER}    Steve
${SECOND PASSWD}    Steve1
${NO VIEW USER}    Noview
${NO VIEW PASSWD}    Noview1
${VIEW USER}      View
${VIEW PASSWD}    View1
${OPEN USER}      Open
${OPEN PASSWD}    Open1
${EDIT USER}      Edit
${EDIT PASSWD}    Edit1
${VIEW OPEN USER}    View Open
${VIEW OPEN PASSWD}    View Open1
${VIEW EDIT USER}    View Edit
${VIEW EDIT PASSWD}    View Edit1
${VIEW OPEN EDIT USER}    View Open Edit
${VIEW OPEN EDIT PASSWD}    View Open Edit1
${VIEWONLY USER}    Viewonly
${VIEWONLY PASSWD}    Viewonly1
${EXP USER USER}    Andy
${EXP USER PASSWD}    Andy1
${EXP ADMIN USER}    Nathan
${EXP ADMIN PASSWD}    Nathan1
${ADMIN ID}       1
${ADMIN_ROLE}     1
${SPREADSHEET_SERVER_HTTP_SCHEME}    http    # Whether the spreadsheet server is running over http or https(currently unsupported)
${SPREADSHEET_SERVER_PORT}    7777    # The port used for Spreadsheet Server communications. Default ports - 7777
${SPREADSHEET_SERVER}    <SpreadsheetServer>    # The EWB Spreadsheet Server
${SPREADSHEET_SERVER_ADMIN_USER}    ${SPREADSHEET_SERVER}\\Administrator    #User login for the spreadsheet server
${SPREADSHEET_SERVER_ADMIN_PASSWORD}    Password99!    # Password for the spreadsheet server
${SPREADSHEET_SERVER_OS}    Windows    # Spreadsheet server operating system
${APP_SERVER_ADMIN_USER}    ${SERVER}\\Administrator    #User login for the app server instance
${APP_SERVER_ADMIN_PASSWORD}    Password99!    # Password for the app server instance
${APP_SERVER_PORT}    2222
${APP_SERVER_NAT}    ewb-daily-nat.idbs-dev.com
${KEY_PAIR}       C:\\Users\\dcurtis\\Documents\\Automation\\ewb-daily-KeyPair.pem
