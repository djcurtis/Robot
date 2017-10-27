*** Settings ***
Library           AWSLibrary
Library           WMILibrary
Library           ServerControlLibrary
Library           ParallelClientHelper
Library           String
Library           CheckLibrary
Resource          aws_environment_resource.txt

*** Variables ***
${PYPI_SERVER}    https://pypi.idbs.co.uk/automation/simple
${INSTALL_VERSION}    10.1.2
${AUTOMATED_TEST_CHECKOUT_ROOT_FULL}    http://20development2.idbs.co.uk/svn/testing-qa/trunk/Projects/E-Workbook/Automated Tests
${aws_win2008_base_image_name}    Windows_Server-2008-R2_SP1-English-64Bit-Base
${aws_win2012_base_image_name}    Windows_Server-2012-R2_RTM-English-64Bit-Base

*** Keywords ***
Create 64-bit Client Machine
    [Arguments]    ${run_id}    ${test_s3_location}    ${client_prefix}=WEB_CLIENT    ${desktop_client_msi}=${EMPTY}    ${browser}=FF38    ${application_host}=${EMPTY}
    ...    ${pypi_url_to_use}=${PYPI_SERVER}    ${instance_type}=c3.large    ${root_device_size}=30    ${team}=Automation    ${install_java}=${EMPTY}
    ${client_ip}    ${hostname}    ${admin_pwd}=    Create 64-bit Browser Client Machine    ${client_prefix}    ${pypi_url_to_use}    ${browser}
    ...    server_certificate=${CURDIR}/E-WorkBook9.2ServerSSL.crt    application_host=${application_host}    instance_type=${instance_type}    root_device_size=${root_device_size}    team=${team}
    Write Machine Name To File    ${client_ip}
    WMILibrary.Open Connection    ${client_ip}    Administrator    ${admin_pwd}
    # Test data
    Run Command On Machine    ${client_ip}    python C:\\s3-downloads\\scripts\\S3.py idbs-automation ${test_s3_location} "C:\\EWB Automated Tests" C:\\aws_credentials.conf
    #quantrixlibrary
    Run Command On Machine    ${client_ip}    pip install --upgrade robotframework-QuantrixLibrary -i ${pypi_url_to_use}
    #dynamic java library
    Run Command On Machine    ${client_ip}    pip install --upgrade robotframework-DynamicJavaLibrary -i ${pypi_url_to_use}
    #custom swing library
    Run Command On Machine    ${client_ip}    pip install --upgrade robotframework-IDBSCustomSwingComponentLibrary -i ${pypi_url_to_use}
    # Spreadsheet designer installer
    Run Command On Machine    ${client_ip}    python C:\\s3-downloads\\scripts\\S3.py idbs-automation "runs/${run_id}/ssd" "C:\\spreadsheet_designer_install" C:\\aws_credentials.conf
    Run Command On Machine    ${client_ip}    start /wait msiexec /i "C:\\spreadsheet_designer_install\\IDBS Spreadsheet Designer (64 bit) Installer.msi" /qn
    Run Command On Machine    ${client_ip}    copy "C:\\EWB Automated Tests\\Libraries\\common_resource.template" "C:\\EWB Automated Tests\\Libraries\\common_resource.txt" /Y
    Run Keyword Unless    '${desktop_client_msi}'=='${EMPTY}'    Install Desktop Client    ${client_ip}    ${hostname}\\Administrator    ${admin_pwd}    ${desktop_client_msi}
    Run Keyword If    '${install_java}'=='True'    Install Java
    Ensure Slave is running    ${client_ip}    ${hostname}\\Administrator    ${admin_pwd}
    [Return]    ${client_ip}

Create 64-bit Client Machine with External Editor
    [Arguments]    ${run_id}    ${test_s3_location}    ${client_prefix}=WEB_CLIENT    ${desktop_client_msi}=${EMPTY}    ${browser}=FF38    ${application_host}=${EMPTY}
    ...    ${pypi_url_to_use}=${PYPI_SERVER}    ${instance_type}=c3.large    ${root_device_size}=30    ${team}=Automation    ${install_java}=${EMPTY}
    ${client_ip}    ${hostname}    ${admin_pwd}=    Create 64-bit Browser Client Machine    ${client_prefix}    ${pypi_url_to_use}    ${browser}
    ...    server_certificate=${CURDIR}/E-WorkBook9.2ServerSSL.crt    application_host=${application_host}    instance_type=${instance_type}    root_device_size=${root_device_size}    team=${team}
    Write Machine Name To File    ${client_ip}
    WMILibrary.Open Connection    ${client_ip}    Administrator    ${admin_pwd}
    # Test data
    Run Command On Machine    ${client_ip}    python C:\\s3-downloads\\scripts\\S3.py idbs-automation ${test_s3_location} "C:\\EWB Automated Tests" C:\\aws_credentials.conf
    #quantrixlibrary
    Run Command On Machine    ${client_ip}    pip install --upgrade robotframework-QuantrixLibrary -i ${pypi_url_to_use}
    #dynamic java library
    Run Command On Machine    ${client_ip}    pip install --upgrade robotframework-DynamicJavaLibrary -i ${pypi_url_to_use}
    #custom swing library
    Run Command On Machine    ${client_ip}    pip install --upgrade robotframework-IDBSCustomSwingComponentLibrary -i ${pypi_url_to_use}
    # External Editor installer
    Run Command On Machine    ${client_ip}    python C:\\s3-downloads\\scripts\\S3.py idbs-automation "runs/${run_id}/External_Editor" "C:\\external_editor_install" C:\\aws_credentials.conf
    Run Command On Machine    ${client_ip}    start /wait msiexec /i "C:\\external_editor_install\\IDBS External Editor Integration Installer.msi" /qn
    # Spreadsheet designer installer
    Run Command On Machine    ${client_ip}    python C:\\s3-downloads\\scripts\\S3.py idbs-automation "runs/${run_id}/ssd" "C:\\spreadsheet_designer_install" C:\\aws_credentials.conf
    Run Command On Machine    ${client_ip}    start /wait msiexec /i "C:\\spreadsheet_designer_install\\IDBS Spreadsheet Designer (64 bit) Installer.msi" /qn
    Run Command On Machine    ${client_ip}    copy "C:\\EWB Automated Tests\\Libraries\\common_resource.template" "C:\\EWB Automated Tests\\Libraries\\common_resource.txt" /Y
    Run Keyword Unless    '${desktop_client_msi}'=='${EMPTY}'    Install Desktop Client    ${client_ip}    ${hostname}\\Administrator    ${admin_pwd}    ${desktop_client_msi}
    Run Keyword If    '${install_java}'=='True'    Install Java
    Ensure Slave is running    ${client_ip}    ${hostname}\\Administrator    ${admin_pwd}
    [Return]    ${client_ip}

Deploy Model Server to AWS Instance
    [Arguments]    ${model_server_ip}    ${model_server_instance_id}    ${admin_username}    ${admin_private_key}    ${build_folder}    ${load_balanced}=false
    ...    ${perf_log_debug}=${FALSE}
    ${admin_pwd}=    Wait Until Keyword Succeeds    15m    15s    AWSLibrary.Get Windows Administrator Password    ${model_server_instance_id}    ${admin_private_key}
    Disable Windows Firewall on AWS    ${model_server_ip}    ${admin_username}    ${admin_pwd}
    Run Model Server on AWS    ${model_server_ip}    ${admin_username}    ${admin_pwd}    ${build_folder}
    Run Keyword If    '${load_balanced}'.lower()=='true'    Run Load Balancer on AWS    ${model_server_ip}    ${admin_username}    ${admin_pwd}    ${build_folder}
    ...    7777
    Run Keyword If    ${perf_log_debug}    Set Windows Model Server Performance Logging    ${model_server_ip}    ${admin_username}    ${admin_pwd}

Run Model Server on AWS
    [Arguments]    ${server_ip}    ${admin_user}    ${admin_password}    ${core_installation_directory}
    [Documentation]    *Installs the IDBS Model Server onto the given server*
    ...
    ...    *Arguments*
    ...
    ...    - _server_ip_ - the server to install onto
    ...    - _admin_user_ - the administrator user of the machine
    ...    - _admin_password_ - the administrator password
    ...    - _core_installation_directory_ - the root folder containing the EWB CD image to be installed
    ...
    ...    *Return Value*
    ...
    ...    None
    WMILibrary.Open Connection    ${server_ip}    ${admin_user}    ${admin_password}
    #copy server
    WMILibrary.Put Directory    ${core_installation_directory}/CD Image/Install/IDBS Spreadsheet Server    C:/spreadsheet_server_install
    #run installer
    ${output}=    WMILibrary.Run Remote Command And Return Output    c:\\Windows\\System32\\msiexec.exe /i "C:\\spreadsheet_server_install\\IDBS Spreadsheet Server (64 bit) Installer.msi" /qn
    WMILibrary.Close Connection

Install Desktop Client
    [Arguments]    ${client_ip}    ${admin_user}    ${admin_password}    ${msi_name}
    WMILibrary.Open Connection    ${client_ip}    ${admin_user}    ${admin_password}
    ${output}=    WMILibrary.Run Remote Command And Return Output    python C:\\s3-downloads\\scripts\\S3.py idbs-automation "runs/${run_id}/desktop" "C:\\desktop_client_install" C:\\aws_credentials.conf
    ${output}=    WMILibrary.Run Remote Command And Return Output    start /wait msiexec /i "C:\\desktop_client_install\\${msi_name}" /qn /norestart
    [Teardown]    WMILibrary.Close Connection

Run Load Balancer on AWS
    [Arguments]    ${server_ip}    ${admin_user}    ${admin_password}    ${core_installation_directory}    @{model_server_ports}
    [Documentation]    *Installs the IDBS Model Server Load Balancer onto the given server*
    ...
    ...    *Arguments*
    ...
    ...    - _server_ip_ - the server to install onto
    ...    - _admin_user_ - the administrator user of the machine
    ...    - _admin_password_ - the administrator password
    ...    - _core_installation_directory_ - the root folder containing the EWB CD image to be installed
    ...
    ...    *Return Value*
    ...
    ...    None
    WMILibrary.Open Connection    ${server_ip}    ${admin_user}    ${admin_password}
    #copy server
    WMILibrary.Put Directory    ${core_installation_directory}/CD Image/Install/IDBS Spreadsheet Server Load Balancer    C:/spreadsheet_server_lb_install
    #run installer
    ${output}=    WMILibrary.Run Remote Command And Return Output    c:\\Windows\\System32\\msiexec.exe /i "C:\\spreadsheet_server_lb_install\\IDBS Spreadsheet Server Load Balancer Installer.msi" /qn
    WMILibrary.Delete File    C:/Program Files/IDBS/IDBS Spreadsheet Server Load Balancer/WEB-INF/loadbalance.xml
    WMILibrary.Put File Contents    C:/Program Files/IDBS/IDBS Spreadsheet Server Load Balancer/WEB-INF/loadbalance.xml    <?xml version="1.0" encoding="UTF-8"?>    <loadbalance algorithm="roundrobin" logLevel="info">
    : FOR    ${port}    IN    @{model_server_ports}
    \    WMILibrary.Append Remote File Contents    C:/Program Files/IDBS/IDBS Spreadsheet Server Load Balancer/WEB-INF/loadbalance.xml    <server><id>model-server-${port}</id><host>localhost</host><port>${port}</port><token>idbs</token></server>
    WMILibrary.Append Remote File Contents    C:/Program Files/IDBS/IDBS Spreadsheet Server Load Balancer/WEB-INF/loadbalance.xml    </loadbalance>
    WMILibrary.Close Connection

Disable Windows Firewall on AWS
    [Arguments]    ${server_ip}    ${admin_user}    ${admin_password}
    [Documentation]    *Disables the Windows firewall on a given server*
    ...
    ...    *Arguments*
    ...
    ...    - _server_ip_ - the server to install onto
    ...    - _admin_user_ - the administrator user of the machine
    ...    - _admin_password_ - the administrator password
    ...
    ...    *Return Value*
    ...
    ...    None
    WMILibrary.Open Connection    ${server_ip}    ${admin_user}    ${admin_password}
    #disable windows firewall
    ${output}=    WMILibrary.Run Remote Command And Return Output    netsh advfirewall set allprofiles state off
    WMILibrary.Close Connection

Install Java
    ${output}=    WMILibrary.Run Remote Command And Return Output    python C:\\s3-downloads\\scripts\\S3.py idbs-automation environment/framework/JRE/ C:\\java_install C:\\aws_credentials.conf
    Log    ${output}
    WMILibrary.Put File Contents    C:/java_install/Install_java.cmd    C:\\java_install\\jre-8u92-windows-x64.exe /s /L C:\\java_install\\java_install.log
    ${output}=    WMILibrary.Run Remote Command And Return Output    C:/java_install/Install_java.cmd
    Log    ${output}
    ${output}=    WMILibrary.Run Remote Command And Return Output    setx PATH "%PATH%;C:\\Program Files\\Java\\jre1.8.0_92\\bin"

Create 2012 64-bit Client Machine
    [Arguments]    ${run_id}    ${test_s3_location}    ${client_prefix}=WEB_CLIENT    ${desktop_client_msi}=${EMPTY}    ${browser}=FF38    ${application_host}=${EMPTY}
    ...    ${pypi_url_to_use}=${PYPI_SERVER}    ${instance_type}=c3.large    ${root_device_size}=30    ${team}=Automation    ${install_java}=${EMPTY}
    ${client_ip}    ${hostname}    ${admin_pwd}=    Create 2012 64-bit Browser Client Machine    ${client_prefix}    ${pypi_url_to_use}    ${browser}
    ...    server_certificate=${CURDIR}/E-WorkBook9.2ServerSSL.crt    application_host=${application_host}    instance_type=${instance_type}    root_device_size=${root_device_size}    team=${team}
    Write Machine Name To File    ${client_ip}
    WMILibrary.Open Connection    ${client_ip}    Administrator    ${admin_pwd}
    # Test data
    Run Command On Machine    ${client_ip}    python C:\\s3-downloads\\scripts\\S3.py idbs-automation ${test_s3_location} "C:\\EWB Automated Tests" C:\\aws_credentials.conf
    #quantrixlibrary
    Run Command On Machine    ${client_ip}    pip install --upgrade robotframework-QuantrixLibrary -i ${pypi_url_to_use}
    #dynamic java library
    Run Command On Machine    ${client_ip}    pip install --upgrade robotframework-DynamicJavaLibrary -i ${pypi_url_to_use}
    #custom swing library
    Run Command On Machine    ${client_ip}    pip install --upgrade robotframework-IDBSCustomSwingComponentLibrary -i ${pypi_url_to_use}
    # Spreadsheet designer installer
    Run Command On Machine    ${client_ip}    python C:\\s3-downloads\\scripts\\S3.py idbs-automation "runs/${run_id}/ssd" "C:\\spreadsheet_designer_install" C:\\aws_credentials.conf
    Run Command On Machine    ${client_ip}    start /wait msiexec /i "C:\\spreadsheet_designer_install\\IDBS Spreadsheet Designer (64 bit) Installer.msi" /qn
    Run Command On Machine    ${client_ip}    copy "C:\\EWB Automated Tests\\Libraries\\common_resource.template" "C:\\EWB Automated Tests\\Libraries\\common_resource.txt" /Y
    Run Keyword Unless    '${desktop_client_msi}'=='${EMPTY}'    Install Desktop Client    ${client_ip}    ${hostname}\\Administrator    ${admin_pwd}    ${desktop_client_msi}
    Run Keyword If    '${install_java}'=='True'    Install Java
    Ensure Slave is running    ${client_ip}    ${hostname}\\Administrator    ${admin_pwd}
    [Return]    ${client_ip}

Set Windows Model Server Performance Logging
    [Arguments]    ${server}    ${username}    ${password}
    [Documentation]    Sets the performance logging on the spreadsheet server to DEBUG, so that it starts recording performance information.
    ...
    ...
    ...    Arguments:
    ...
    ...    ${server} - The IP of the server to connect to.
    ...    ${username} - The username to connect to the machine with.
    ...    ${password} - The password to connect to the machine with.
    WMILibrary.Open Connection    ${server}    ${username}    ${password}
    WMILibrary.Run Remote Command And Return Output    net stop "IDBS Spreadsheet Server"
    WMILibrary.Replace Regexp In Remote File    C:\\Program Files\\IDBS\\IDBS Spreadsheet Server (64 bit)\\WEB-INF\\classes\\log4j.properties    log4j.logger.performance=OFF    log4j.logger.performance=DEBUG
    WMILibrary.Run Remote Command And Return Output    net start "IDBS Spreadsheet Server"
    WMILibrary.Close Connection
    Comment    WMILibrary.Get File    C:\\Program Files\\IDBS\\IDBS Spreadsheet Server (64 bit)\\WEB-INF\\classes\\log4j.properties    ${OUTPUT_DIR}/ss_logs
