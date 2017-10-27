*** Settings ***
Library           AWSLibrary
Library           ServerControlLibrary
Library           OperatingSystem
Library           CheckLibrary
Library           String
Library           WMILibrary
Library           FileLibrary
Library           ParallelClientHelper
Library           IDBSHttpLibrary
Library           Collections
Library           SSHLibrary

*** Variables ***
${PYPI_SERVER}    https://pypi.idbs.co.uk/automation/simple
${aws_win2012_base_image_name}    Windows_Server-2012-R2_RTM-English-64Bit-Base
${aws_win2008_base_image_name}    Windows_Server-2008-R2_SP1-English-64Bit-Base
${aws_idbs_owner_id}    796568017366

*** Keywords ***
Create 64-bit Browser Client Machine
    [Arguments]    ${client_prefix}=IVM_CLIENT    ${pypi_url_to_use}=${PYPI_SERVER}    ${browser_to_install}=FF31    ${server_certificate}=${EMPTY}    ${application_host}=${EMPTY}    ${instance_type}=c3.large
    ...    ${root_device_size}=30    ${team}=Automation    ${enable_proxy}=false
    ${aws_ami}=    AWSLibrary.Get AMI ID    ${aws_win2008_base_image_name}
    ${device_list}=    __Create Single Device Block Device Mapping    /dev/sda1    ${root_device_size}
    ${instance_id}=    AWSLibrary.Create Instance    ${client_prefix}    ${aws_ami}    team=${team}    instance_type=${instance_type}    block_device_mappings=${device_list}
    Set Suite Metadata    instance_id    ${instance_id}
    ${admin_pwd}=    Wait Until Keyword Succeeds    15m    15s    AWSLibrary.Get Windows Administrator Password    ${instance_id}    C:/stevekp.pem
    Set Suite Metadata    admin_password    ${admin_pwd}
    ${client_ip}=    AWSLibrary.Get Instance Private IP    ${instance_id}
    Write Machine Name To File    ${client_ip}
    WMILibrary.Open Connection    ${client_ip}    Administrator    ${admin_pwd}
    ${hostname}=    WMILibrary.Run Remote Command And Return Output    hostname
    ${hostname}=    Get Line    ${hostname}    0
    ${output}=    Wait Until Keyword Succeeds    60s    5s    WMILibrary.Run Remote Command And Return Output    TZUTIL /s "GMT Standard Time"
    #Add IDBS DNS servers - allows for
    ${output}=    WMILibrary.Run Remote Command And Return Output    netsh interface ipv4 add dnsserver "Ethernet" address=10.20.10.10 index=2
    ${output}=    WMILibrary.Run Remote Command And Return Output    netsh interface ipv4 add dnsserver "Local Area Connection" address=10.20.10.10 index=2    #used interchangeably with ethernet
    ${output}=    WMILibrary.Run Remote Command And Return Output    reg add HKLM\\System\\currentcontrolset\\services\\tcpip\\parameters /v "SearchList" /d "idbs.co.uk" /f
    # Change timezone
    ${output}=    WMILibrary.Run Remote Command And Return Output    TZUTIL /s "GMT Standard Time"
    Log    ${output}
    WMILibrary.Put File    C:/robotframework-settings/aws_credentials.conf    C:/aws_credentials.conf
    WMILibrary.Put File    ${CURDIR}/download_core_environment_components.ps1    C:/download_core_environment_components.ps1
    ${output}=    WMILibrary.Run Remote Command And Return Output    start /wait powershell -ExecutionPolicy Bypass "& ""C:\\download_core_environment_components.ps1"""
    ${output}=    WMILibrary.Run Remote Command And Return Output    C:\\s3-downloads\\CloudHealthAgent.exe /S /v"/l* install.log /qn CLOUDNAME=aws CHTAPIKEY=8eb1b655-3150-495f-bcc1-045fd29e0a7a"
    ${output}=    WMILibrary.Run Remote Command And Return Output    start /wait msiexec /i C:\\s3-downloads\\7z920-x64.msi /qn
    ${output}=    WMILibrary.Run Remote Command And Return Output    start /wait msiexec /i C:\\s3-downloads\\python-2.7.8.amd64.msi /qn ALLUSERS=1
    ${output}=    WMILibrary.Run Remote Command And Return Output    start /wait msiexec /i C:\\s3-downloads\\cx_Oracle-5.1.1-11g.win-amd64-py2.7.msi /qn
    ${output}=    WMILibrary.Run Remote Command And Return Output    setx PATH "%PATH%;C\\Program Files\\7-Zip;C:\\Python27;C:\\Python27\\Scripts;C:\\oracle_client\\instantclient_11_2" /m
    ${output}=    WMILibrary.Run Remote Command And Return Output    "C:\\Program Files\\7-Zip\\7z.exe" x C:\\s3-downloads\\instantclient-basic-windows.x64-11.2.0.2.0.zip -oC:\\oracle_client -aoa
    ${output}=    WMILibrary.Run Remote Command And Return Output    "C:\\Program Files\\7-Zip\\7z.exe" x C:\\s3-downloads\\python27_patch.zip -oC:\\Python27 -aoa
    ${output}=    WMILibrary.Run Remote Command And Return Output    python C:\\s3-downloads\\scripts\\ez_setup_3212.py --version 33.1.0
    ${output}=    WMILibrary.Run Remote Command And Return Output    easy_install pip
    Log    ${output}
    __Robust_pip_install    boto3    ${pypi_url_to_use}
    # Test machine slave files
    ${rc}    ${output}=    WMILibrary.Put File Contents    C:\\test_machine_slave\\start_slave.cmd    start "" C:\\Python27\\pythonw.exe C:\\s3-downloads\\test_machine_slave\\TestMachineSlave.py -f C:\\s3-downloads\\test_machine_slave\\slave.log -L DEBUG
    # Restart machine with autologin
    WMILibrary.Configure Autologon on Remote Machine    Administrator    ${admin_pwd}    ${hostname}
    WMILibrary.Reboot Machine
    WMILibrary.Close Connection
    WMILibrary.Is Machine Running    ${client_ip}    ${hostname}\\Administrator    ${admin_pwd}
    # Disable Windows Firewall
    ${output}=    WMILibrary.Run Remote Command And Return Output    netsh advfirewall set allprofiles state off
    #increase the screen resolution to 1280x1024
    Change Client Resolution    ${client_ip}    Administrator    ${admin_pwd}
    # Browser install
    Run Keyword If    '${browser_to_install}'=='FF45'    __Install FireFox 45
    Run Keyword If    '${browser_to_install}'=='FF38'    __Install FireFox 38
    Run Keyword If    '${browser_to_install}'=='FF31'    __Install FireFox 31
    Run Keyword If    '${browser_to_install}'=='CHROME'    __Install Chrome
    Run Keyword If    '${browser_to_install}'=='IE10'    __Install IE 10    ${server_certificate}    ${application_host}
    Run Keyword If    '${browser_to_install}'=='IE11'    __Install IE 11    ${client_ip}    ${admin_pwd}    ${server_certificate}    ${application_host}
    #install Libraries
    aws_environment_resource.__Install Libraries on client    ${client_ip}    Administrator    ${admin_pwd}    ${pypi_url_to_use}
    #install secBOT - security proxy
    Run Keyword If    '${enable_proxy}'.lower()=='true'    __Install secBOT on client    ${client_ip}    Administrator    ${admin_pwd}    ${pypi_url_to_use}
    # Start test machine slave
    Run Keyword If    '${enable_proxy}'.lower()=='true'    __Start test machine slave headless    ${client_ip}    ${hostname}\\Administrator    ${admin_pwd}
    Run Keyword If    '${enable_proxy}'.lower()!='true'    __Start test machine slave    ${client_ip}    ${hostname}\\Administrator    ${admin_pwd}
    WMILibrary.Close Connection
    [Return]    ${client_ip}    ${hostname}    ${admin_pwd}

__Install Libraries on client
    [Arguments]    ${client_ip}    ${admin_user}    ${admin_password}    ${pypi_url_to_use}=${PYPI_SERVER}
    #install test libraries
    WMILibrary.Open Connection    ${client_ip}    ${admin_user}    ${admin_password}
    __Robust_pip_install    wheel    ${pypi_url_to_use}
    __Robust_pip_install    IDBS-Automation-Core    ${pypi_url_to_use}
    __Robust_pip_install    robotframework-IDBS-Selenium2Library    ${pypi_url_to_use}
    __Robust_pip_install    robotframework-IDBS-httplibrary    ${pypi_url_to_use}
    __Robust_pip_install    robotframework-xmllibrary    ${pypi_url_to_use}
    __Robust_pip_install    robotframework-imagelibrary    ${pypi_url_to_use}
    __Robust_pip_install    robotframework-oraclelibrary    ${pypi_url_to_use}
    __Robust_pip_install    robotframework-PyWinAutoLibrary    ${pypi_url_to_use}
    __Robust_pip_install    robotframework-ClipboardLibrary    ${pypi_url_to_use}
    __Robust_pip_install    robotframework-checkpdflibrary    ${pypi_url_to_use}
    __Robust_pip_install    robotframework-systemutilitieslibrary    ${pypi_url_to_use}
    __Robust_pip_install    robotframework-Timinglibrary    ${pypi_url_to_use}
    __Robust_pip_install    robotframework-jsonlibrary    ${pypi_url_to_use}
    __Robust_pip_install    robotframework-WMILibrary    ${pypi_url_to_use}
    __Robust_pip_install    pymongo    ${pypi_url_to_use}
    __Robust_pip_install    EntityAPILibrary    ${pypi_url_to_use}
    __Robust_pip_install    SecurityAPILibrary    ${pypi_url_to_use}
    #listeners
    __Robust_pip_install    robotframework-dbConnector    ${pypi_url_to_use}
    __Robust_pip_install    robotframework-clientListener    ${pypi_url_to_use}
    [Teardown]    WMILibrary.Close Connection

__Install IE 10
    [Arguments]    ${server_certificate}=${EMPTY}    ${application_host}=${EMPTY}
    ${output}=    WMILibrary.Run Remote Command And Return Output    FORFILES /P %WINDIR%\\servicing\\Packages /M Microsoft-Windows-InternetExplorer-*11.*.mum /c "cmd /c echo Uninstalling package @fname && start /w pkgmgr /up:@fname /quiet /norestart
    Log    ${output}
    __Configure IE Security    ${server_certificate}    ${application_host}

__Install IE 11
    [Arguments]    ${client_machine}    ${client_admin_password}    ${server_certificate}=${EMPTY}    ${application_host}=${EMPTY}
    __Configure IE Security    ${server_certificate}    ${application_host}
    WMILibrary.Reboot Machine
    WMILibrary.Is Machine Running    ${client_machine}    Administrator    ${client_admin_password}

__Configure IE Security
    [Arguments]    ${server_certificate}    ${application_host}
    Comment    Disabled IE ESC
    ${output}=    WMILibrary.Run Remote Command And Return Output    REG ADD "HKLM\\SOFTWARE\\Microsoft\\Active Setup\\Installed Components\\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" /v IsInstalled /t REG_DWORD /d 00000000 /f
    Log    ${output}
    ${output}=    WMILibrary.Run Remote Command And Return Output    REG ADD "HKLM\\SOFTWARE\\Microsoft\\Active Setup\\Installed Components\\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" /v IsInstalled /t REG_DWORD /d 00000000 /f
    Log    ${output}
    Comment    Disable warning about certificate being for different site
    ${output}=    WMILibrary.Run Remote Command And Return Output    reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" /V "WarnonBadCertRecving" /t REG_DWORD /d 00000000 /f
    Log    ${output}
    Comment    Disable welcome screen
    ${output}=    WMILibrary.Run Remote Command And Return Output    reg add "HKLM\\SOFTWARE\\Policies\\Microsoft\\Internet Explorer\\Main" /V "DisableFirstRunCustomize" /t REG_DWORD /d 00000001 /f
    Log    ${output}
    Comment    configure IE11 to allow connections
    ${output}=    WMILibrary.Run Remote Command And Return Output    reg add "HKLM\\SOFTWARE\\Wow6432Node\\Microsoft\\Internet Explorer\\MAIN\\FeatureControl\\FEATURE_BFCACHE" /V "iexplore.exe" /t REG_DWORD /d 00000000 /f
    Log    ${output}
    ${output}=    WMILibrary.Run Remote Command And Return Output    reg add "HKLM\\SOFTWARE\\Microsoft\\Internet Explorer\\MAIN\\FeatureControl\\FEATURE_BFCACHE" /V "iexplore.exe" /t REG_DWORD /d 00000000 /f
    Log    ${output}
    Comment    Disable warning: You are aboput to view page over secure connection
    ${output}=    WMILibrary.Run Remote Command And Return Output    reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" /V "WarnOnIntranet" /t REG_DWORD /d 00000000 /f
    Log    ${output}
    ${output}=    WMILibrary.Run Remote Command And Return Output    reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" /V "WarnonZoneCrossing" /t REG_DWORD /d 00000000 /f
    Log    ${output}
    Comment    Disable protected mode for all four zones
    ${output}=    WMILibrary.Run Remote Command And Return Output    reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\1" /V "2500" /t REG_DWORD /d 00000003 /f
    Log    ${output}
    ${output}=    WMILibrary.Run Remote Command And Return Output    reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\2" /V "2500" /t REG_DWORD /d 00000003 /f
    Log    ${output}
    ${output}=    WMILibrary.Run Remote Command And Return Output    reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\3" /V "2500" /t REG_DWORD /d 00000003 /f
    Log    ${output}
    ${output}=    WMILibrary.Run Remote Command And Return Output    reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\4" /V "2500" /t REG_DWORD /d 00000003 /f
    Log    ${output}
    Comment    Disable pop-up blocker for all zones
    ${output}=    WMILibrary.Run Remote Command And Return Output    reg add "HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\New Windows" /V "PopupMgr" /t REG_DWORD /d 00000000 /f
    Log    ${output}
    Comment    Add application host to local intranet zone
    ${output}=    WMILibrary.Run Remote Command And Return Output    reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\ZoneMap\\EscRanges\\Range1" /V "https" /t REG_DWORD /d 00000002 /f
    Log    ${output}
    ${output}=    WMILibrary.Run Remote Command And Return Output    reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\ZoneMap\\EscRanges\\Range1" /V ":Range" /d ${application_host} /f
    Log    ${output}
    Comment    Add local:blank to the escaped domains
    ${output}=    WMILibrary.Run Remote Command And Return Output    reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\ZoneMap\\EscDomains\\blank" /V "about" /t REG_DWORD /d 00000002 /f
    Log    ${output}
    Comment    Load application certificate
    Run Keyword If    "${server_certificate}"!="${EMPTY}"    WMILibrary.Put File    ${server_certificate}    C:/server_cert/server_cert.crt
    ${output}=    Run Keyword If    "${server_certificate}"!="${EMPTY}"    WMILibrary.Run Remote Command And Return Output    Certutil -addstore -f "TRUSTEDPEOPLE" C://server_cert//server_cert.crt
    Log    ${output}

__Wait for machine using IP address
    [Arguments]    ${machine_name}
    ${server_ip}=    Get Virtual Server Ip Address    ${machine_name}
    Wait For Machine    ${server_ip}    10s

__Start test machine slave
    [Arguments]    ${client_ip}    ${admin_user}    ${admin_pwd}
    WMILibrary.Open Connection    ${client_ip}    ${admin_user}    ${admin_pwd}
    WMILibrary.Run Interactive Program    C:\\test_machine_slave\\start_slave.cmd
    ServerControlLibrary.Wait For Machine    ${client_ip}    60s
    WMILibrary.Close Connection

Change Client Resolution
    [Arguments]    ${client_ip}    ${admin_username}    ${admin_password}    ${retry_count}=0
    ${retry_count}=    Evaluate    int(${retry_count})+1
    WMILibrary.Open Connection    ${client_ip}    ${admin_username}    ${admin_password}
    Run Keyword And Ignore Error    WMILibrary.Delete File    C:/Users/Administrator/AppData/Local/Temp/display_resolution.log
    Wait Until Keyword Succeeds    60s    5s    WMILibrary.Run Interactive Program    python C:\\s3-downloads\\scripts\\display_helper.py
    Wait For Process To Finish Running On Remote Machine    python.exe    300s
    ${status}=    Run Keyword And Return Status    WMILibrary.Get File    C:/Users/Administrator/AppData/Local/Temp/display_resolution.log    ${OUTPUT_DIR}/display_resolution.log
    ${res_log}=    Run Keyword If    ${status}    WMILibrary.Get Text File Contents    C:/Users/Administrator/AppData/Local/Temp/display_resolution.log
    ${passed}=    Run Keyword If    ${status}    Run Keyword And Return Status    Check String Contains    Checking correct resolution is set    ${res_log}
    ...    new resolution: (1280, 1024)
    Return From Keyword If    ${passed}
    Run Keyword Unless    ${passed} or ${retry_count}>=5    Change Client Resolution    ${client_ip}    ${admin_username}    ${admin_password}    ${retry_count}
    Run Keyword If    ${retry_count}>=5    Fail    Failed to set client display resolution
    [Teardown]    WMILibrary.Close Connection

__Install FireFox 31
    ${output}=    WMILibrary.Run Remote Command And Return Output    python C:\\s3-downloads\\scripts\\S3.py idbs-automation environment/browsers/firefox C:\\browser_install C:\\aws_credentials.conf
    Log    ${output}
    ${output}=    WMILibrary.Run Remote Command And Return Output    start /wait "" "C:\\browser_install\\Firefox Setup 31.0esr.exe" -ms
    Log    ${output}

__Install Chrome
    ${output}=    WMILibrary.Run Remote Command And Return Output    python C:\\s3-downloads\\scripts\\S3.py idbs-automation environment/browsers/chrome C:\\browser_install C:\\aws_credentials.conf
    Log    ${output}
    ${output}=    WMILibrary.Run Remote Command And Return Output    start /wait msiexec /i C:\\browser_install\\googlechromestandaloneenterprise.msi /q
    Log    ${output}

__Install FireFox 38
    ${output}=    WMILibrary.Run Remote Command And Return Output    python C:\\s3-downloads\\scripts\\S3.py idbs-automation environment/browsers/firefox C:\\browser_install C:\\aws_credentials.conf
    Log    ${output}
    ${output}=    WMILibrary.Run Remote Command And Return Output    start /wait "" "C:\\browser_install\\Firefox Setup 38.2.1esr.exe" -ms
    Log    ${output}

__Install FireFox 45
    ${output}=    WMILibrary.Run Remote Command And Return Output    python C:\\s3-downloads\\scripts\\S3.py idbs-automation environment/browsers/firefox C:\\browser_install C:\\aws_credentials.conf
    Log    ${output}
    ${output}=    WMILibrary.Run Remote Command And Return Output    start /wait "" "C:\\browser_install\\Firefox Setup 45.4.0esr.exe" -ms
    Log    ${output}

Ensure slave is running
    [Arguments]    ${client_ip}    ${admin_user}    ${admin_pwd}
    ${result}    Run Keyword And Return Status    ServerControlLibrary.Wait For Machine    ${client_ip}    20s
    Run Keyword Unless    ${result}    __Start test machine slave    ${client_ip}    ${admin_user}    ${admin_pwd}

Update AWS RHEL Oracle Settings
    [Arguments]    ${server_ip}    ${private_key_file}    ${root_user}=ec2-user    ${oracle_user}=oracle    ${oracle_home}=/u01/app/oracle/product/11.2.0/db1    ${edit_sqlnet_ora}=${False}
    ...    ${ssh_port}=22
    SSHLibrary.Open Connection    ${server_ip}    timeout=30s    width=150    port=${ssh_port}
    SSHLibrary.Login With Public Key    ${root_user}    ${private_key_file}
    SSHLibrary.Set Client Configuration    prompt=>
    SSHLibrary.Write    sudo su oracle
    SSHLibrary.Read Until Prompt
    #update Oracle listener
    Run Keyword And Ignore Error    SSHLibrary.Write    sed -ie s/CHANGEME/${server_ip}/ ${oracle_home}/network/admin/listener.ora
    Run Keyword And Ignore Error    SSHLibrary.Write    sed -ie 's/\(HOST = [0-9.]*\)/\(HOST = ${server_ip}\)/' ${oracle_home}/network/admin/listener.ora
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    sed -ie 's/\(PORT = [0-9]*\)/\(PORT = 1521\)/' ${oracle_home}/network/admin/listener.ora
    SSHLibrary.Read Until Prompt
    #update Oracle TNSnames
    SSHLibrary.Write    sed -ie s/CHANGEME/${server_ip}/ ${oracle_home}/network/admin/tnsnames.ora
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    sed -ie 's/\(HOST = [0-9.]*\)/\(HOST = ${server_ip}\)/' ${oracle_home}/network/admin/tnsnames.ora
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    sed -ie 's/\(PORT = [0-9]*\)/\(PORT = 1521\)/' ${oracle_home}/network/admin/tnsnames.ora
    SSHLibrary.Read Until Prompt
    #update Oracle sqlnet.ora
    Run Keyword If    ${edit_sqlnet_ora}    SSHLibrary.Write    sed -ie s/SQLNET\.ALLOWED_LOGON_VERSION=[0-9]*/SQLNET.ALLOWED_LOGON_VERSION=8/ ${oracle_home}/network/admin/sqlnet.ora
    Run Keyword If    ${edit_sqlnet_ora}    SSHLibrary.Read Until Prompt
    SSHLibrary.Close Connection

Wait for SSH Connection
    [Arguments]    ${server}    ${root_user}    ${private_key_file}
    Wait Until Keyword Succeeds    300s    10s    __attempt_ssh_connection    ${server}    ${root_user}    ${private_key_file}

Start Oracle Process - Linux
    [Arguments]    ${server}    ${root_user}    ${private_key}    ${oracle_user}    ${oracle_sys_user}    ${oracle_sys_password}
    ...    ${port}=22
    # Database restart
    Wait Until Keyword Succeeds    120s    10s    __Restart Database    ${server}    ${root_user}    ${private_key}
    ...    ${oracle_user}    ${oracle_sys_user}    ${oracle_sys_password}    port=${port}
    Wait Until Keyword Succeeds    120s    10s    __Check Database Open    ${server}    ${root_user}    ${private_key}
    ...    ${oracle_user}    ${oracle_sys_user}    ${oracle_sys_password}    port=${port}
    #Listener restart
    Wait Until Keyword Succeeds    120s    10s    __Restart Listener    ${server}    ${root_user}    ${private_key}
    ...    ${oracle_user}    ${oracle_sys_user}    ${oracle_sys_password}    port=${port}

__Robust_pip_install
    [Arguments]    ${package_name}    ${pypi_server_url}    ${attempted_retries}=5
    [Documentation]    Designed to robustly install pip packages, checking for errors in the installataion log and retrying where required.
    ...
    ...    *Preconditions*
    ...
    ...    An active WMI connection to the client machine (where the package is to be installed) is present
    ...
    ...    *Arguments*
    ...
    ...    - _package_name_ - the name of the package as it appears on the PYPI server
    ...    - _pypi_server_ip_ - the IP address of the PYPI server
    ...    - _pypi_server_port=8080_ - the port running the PYPI server, defaults to 8080
    ...    - _trusted_host=${True}_ - whether to set the trusted host flag, defaults to ${True}, set to ${False} to disable
    ...    - _attempted_retries=5_ - number of retries before failing, defaults to 5
    ...
    ...    *Return Value*
    ...
    ...    None
    ...
    ...    *Example*
    ...    | __Robust Pip Install | robotframework-IDBS-selenium2library | 127.0.0.1 |
    ${output}=    WMILibrary.Run Remote Command And Return Output    pip install --upgrade ${package_name} -i ${pypi_server_url}
    ${output}=    Convert To Lowercase    ${output}
    ${passed_error}=    Run Keyword And Return Status    Should Not Contain    ${output}    error
    ${passed_exception}=    Run Keyword And Return Status    Should Not Contain    ${output}    exception
    Return From Keyword If    ${passed_error} and ${passed_exception}
    ${attempted_retries}=    Evaluate    int(${attempted_retries})-1
    Run Keyword If    ${attempted_retries} == 0    Fail    Failed to install pip package ${package_name}
    __Robust_pip_install    ${package_name}    ${pypi_server_url}    ${attempted_retries}

__Create Single Device Block Device Mapping
    [Arguments]    ${root_device}    ${size}    ${type}=Ebs
    ${size}=    Convert To Integer    ${size}
    ${device_volume}=    Create Dictionary    VolumeSize    ${size}
    ${root_device}=    Create Dictionary    DeviceName    ${root_device}    ${type}    ${device_volume}
    ${device_list}=    Create List    ${root_device}
    [Return]    ${device_list}

__Restart Database
    [Arguments]    ${server}    ${root_user}    ${private_key}    ${oracle_user}    ${oracle_sys_user}    ${oracle_sys_password}
    ...    ${port}=22
    [Documentation]    Shutsdown and restarts the Oracle database
    SSHLibrary.Open Connection    ${server}    width=150    port=${port}
    SSHLibrary.Login With Public Key    ${root_user}    ${private_key}
    SSHLibrary.Write    sudo su ${oracle_user}
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$
    SSHLibrary.Read Until Prompt
    SSHLibrary.Set Client Configuration    timeout=600s    prompt=>
    SSHLibrary.Write    sqlplus ${oracle_sys_user}/${oracle_sys_password} as sysdba
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    shutdown immediate
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    startup
    ${output}=    SSHLibrary.Read Until Prompt
    Should Contain    ${output}    Database mounted
    Should Contain    ${output}    Database opened
    SSHLibrary.Write    exit
    SSHLibrary.Set Client Configuration    prompt=$
    SSHLibrary.Read Until Prompt
    [Teardown]    SSHLibrary.Close All Connections

__attempt_ssh_connection
    [Arguments]    ${server}    ${root_user}    ${private_key_file}
    SSHLibrary.Open Connection    ${server}
    SSHLibrary.Login With Public Key    ${root_user}    ${private_key_file}
    [Teardown]    SSHLibrary.Close All Connections

__Check Database Open
    [Arguments]    ${server}    ${root_user}    ${private_key}    ${oracle_user}    ${oracle_sys_user}    ${oracle_sys_password}
    ...    ${port}=22
    [Documentation]    Checks that the following DB parameters are set:
    ...
    ...    - v$database.OPEN_MODE = READ WRITE
    ...    - v$instance.STATUS = OPEN
    SSHLibrary.Open Connection    ${server}    width=150    port=${port}
    SSHLibrary.Login With Public Key    ${root_user}    ${private_key}
    SSHLibrary.Write    sudo su ${oracle_user}
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$
    SSHLibrary.Read Until Prompt
    SSHLibrary.Set Client Configuration    timeout=300s    prompt=>
    SSHLibrary.Write    sqlplus ${oracle_sys_user}/${oracle_sys_password} as sysdba
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    select OPEN_MODE from v$database;
    ${output}=    SSHLibrary.Read Until Prompt
    Should Contain    ${output}    READ WRITE
    SSHLibrary.Write    select STATUS from v$instance;
    ${output}=    SSHLibrary.Read Until Prompt
    Should Contain    ${output}    OPEN
    SSHLibrary.Write    exit
    SSHLibrary.Set Client Configuration    prompt=$
    SSHLibrary.Read Until Prompt
    [Teardown]    SSHLibrary.Close All Connections

__Restart Listener
    [Arguments]    ${server}    ${root_user}    ${private_key}    ${oracle_user}    ${oracle_sys_user}    ${oracle_sys_password}
    ...    ${port}=22
    SSHLibrary.Open Connection    ${server}    width=150    prompt=$    timeout=300s    port=${port}
    SSHLibrary.Login With Public Key    ${root_user}    ${private_key}
    SSHLibrary.Write    sudo su - ${oracle_user} -c 'lsnrctl stop'
    ${output}=    SSHLibrary.Read Until Prompt
    ${status}=    Run Keyword And Return Status    Should Contain    ${output}    The command completed successfully
    Run Keyword Unless    ${status}    Should Contain    ${output}    No listener    # if the previous command did not pass check that the failure was because the listener was not running
    SSHLibrary.Write    sudo su - ${oracle_user} -c 'lsnrctl start'
    ${output}=    SSHLibrary.Read Until Prompt
    Should Contain    ${output}    The command completed successfully
    [Teardown]    SSHLibrary.Close All Connections

SSH Connect with private key
    [Arguments]    ${server}    ${user}    ${private_key_file}    ${ssh_port}=22
    SSHLibrary.Open Connection    ${server}    timeout=120s    port=${ssh_port}
    SSHLibrary.Login With Public Key    ${user}    ${private_key_file}
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$

__Stop Database
    [Arguments]    ${server}    ${root_user}    ${private_key}    ${oracle_user}    ${oracle_sys_user}    ${oracle_sys_password}
    ...    ${port}=22
    [Documentation]    Shutsdown the Oracle database
    SSHLibrary.Open Connection    ${server}    width=150    port=${port}
    SSHLibrary.Login With Public Key    ${root_user}    ${private_key}
    SSHLibrary.Write    sudo su ${oracle_user}
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$
    SSHLibrary.Read Until Prompt
    SSHLibrary.Set Client Configuration    timeout=300s    prompt=>
    SSHLibrary.Write    sqlplus ${oracle_sys_user}/${oracle_sys_password} as sysdba
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    shutdown immediate
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    exit
    SSHLibrary.Set Client Configuration    prompt=$
    SSHLibrary.Read Until Prompt
    [Teardown]    SSHLibrary.Close All Connections

__wait_for_server_start
    [Arguments]    ${server}    ${user}    ${private_key_file}    ${console_path}=/home/ec2-user/IDBS/EWB/EWBServer/wildfly/standalone/log/console.log    ${timeout_secs}=300    ${ssh_port}=22
    Wait Until Keyword Succeeds    300    5    SSH Connect with private key    ${server}    ${user}    ${private_key_file}
    ...    ${ssh_port}
    ${rc}=    SSHLibrary.Execute Command    grep -i 'started in' ${console_path}    return_stdout=${False}    return_stderr=${False}    return_rc=${True}
    Return From Keyword If    int(${rc})==0
    ${sleep_interval}=    Set Variable    20
    Sleep    ${sleep_interval}
    ${new_timeout}=    Evaluate    int(${timeout_secs})-int(${sleep_interval})
    Run Keyword Unless    int(${new_timeout})>=0    Fail    Application server did not start correctly
    Run Keyword If    int(${rc})!=0    __wait_for_server_start    ${server}    ${user}    ${private_key_file}    timeout_secs=${new_timeout}
    [Teardown]    Run Keyword And Ignore Error    SSHLibrary.Close Connection

Create 2012 64-bit Browser Client Machine
    [Arguments]    ${client_prefix}=IVM_CLIENT    ${pypi_url_to_use}=${PYPI_SERVER}    ${browser_to_install}=FF31    ${server_certificate}=${EMPTY}    ${application_host}=${EMPTY}    ${instance_type}=c3.large
    ...    ${root_device_size}=30    ${team}=Automation
    ${aws_ami}=    AWSLibrary.Get AMI ID    ${aws_win2012_base_image_name}
    ${device_list}=    __Create Single Device Block Device Mapping    /dev/sda1    ${root_device_size}
    ${instance_id}=    AWSLibrary.Create Instance    ${client_prefix}    ${aws_ami}    team=${team}    instance_type=${instance_type}    block_device_mappings=${device_list}
    Set Suite Metadata    instance_id    ${instance_id}
    ${admin_pwd}=    Wait Until Keyword Succeeds    15m    15s    AWSLibrary.Get Windows Administrator Password    ${instance_id}    C:/stevekp.pem
    Set Suite Metadata    admin_password    ${admin_pwd}
    ${client_ip}=    AWSLibrary.Get Instance Private IP    ${instance_id}
    Write Machine Name To File    ${client_ip}
    WMILibrary.Open Connection    ${client_ip}    Administrator    ${admin_pwd}
    ${hostname}=    WMILibrary.Run Remote Command And Return Output    hostname
    ${hostname}=    Get Line    ${hostname}    0
    ${output}=    Wait Until Keyword Succeeds    60s    5s    WMILibrary.Run Remote Command And Return Output    TZUTIL /s "GMT Standard Time"
    #Add IDBS DNS servers - allows for
    ${output}=    WMILibrary.Run Remote Command And Return Output    netsh interface ipv4 add dnsserver "Ethernet" address=10.20.10.10 index=2
    ${output}=    WMILibrary.Run Remote Command And Return Output    netsh interface ipv4 add dnsserver "Ethernet 2" address=10.20.10.10 index=2
    ${output}=    WMILibrary.Run Remote Command And Return Output    netsh interface ipv4 add dnsserver "Local Area Connection" address=10.20.10.10 index=2    #used interchangeably with ethernet
    ${output}=    WMILibrary.Run Remote Command And Return Output    reg add HKLM\\System\\currentcontrolset\\services\\tcpip\\parameters /v "SearchList" /d "idbs.co.uk" /f
    ${output}=    WMILibrary.Run Remote Command And Return Output    TZUTIL /s "GMT Standard Time"
    Log    ${output}
    WMILibrary.Put File    C:/robotframework-settings/aws_credentials.conf    C:/aws_credentials.conf
    WMILibrary.Put File    ${CURDIR}/download_core_environment_components.ps1    C:/download_core_environment_components.ps1
    ${output}=    WMILibrary.Run Remote Command And Return Output    start /wait powershell -ExecutionPolicy Bypass "& ""C:\\download_core_environment_components.ps1"""
    ${output}=    WMILibrary.Run Remote Command And Return Output    C:\\s3-downloads\\CloudHealthAgent.exe /S /v"/l* install.log /qn CLOUDNAME=aws CHTAPIKEY=8eb1b655-3150-495f-bcc1-045fd29e0a7a"
    ${output}=    WMILibrary.Run Remote Command And Return Output    start /wait msiexec /i C:\\s3-downloads\\7z920-x64.msi /qn
    ${output}=    WMILibrary.Run Remote Command And Return Output    start /wait msiexec /i C:\\s3-downloads\\python-2.7.8.amd64.msi /qn ALLUSERS=1
    ${output}=    WMILibrary.Run Remote Command And Return Output    start /wait msiexec /i C:\\s3-downloads\\cx_Oracle-5.1.1-11g.win-amd64-py2.7.msi /qn
    ${output}=    WMILibrary.Run Remote Command And Return Output    setx PATH "%PATH%;C\\Program Files\\7-Zip;C:\\Python27;C:\\Python27\\Scripts;C:\\oracle_client\\instantclient_11_2" /m
    ${output}=    WMILibrary.Run Remote Command And Return Output    "C:\\Program Files\\7-Zip\\7z.exe" x C:\\s3-downloads\\instantclient-basic-windows.x64-11.2.0.2.0.zip -oC:\\oracle_client -aoa
    ${output}=    WMILibrary.Run Remote Command And Return Output    "C:\\Program Files\\7-Zip\\7z.exe" x C:\\s3-downloads\\python27_patch.zip -oC:\\Python27 -aoa
    ${output}=    WMILibrary.Run Remote Command And Return Output    python C:\\s3-downloads\\scripts\\ez_setup_3212.py --version 33.1.0
    ${output}=    WMILibrary.Run Remote Command And Return Output    easy_install pip
    Log    ${output}
    __Robust_pip_install    boto3    ${pypi_url_to_use}
    # Test machine slave files
    ${rc}    ${output}=    WMILibrary.Put File Contents    C:\\test_machine_slave\\start_slave.cmd    start "" C:\\Python27\\pythonw.exe C:\\s3-downloads\\test_machine_slave\\TestMachineSlave.py -f C:\\s3-downloads\\test_machine_slave\\slave.log -L DEBUG
    # Restart machine with autologin
    WMILibrary.Configure Autologon on Remote Machine    Administrator    ${admin_pwd}    ${hostname}
    WMILibrary.Reboot Machine
    WMILibrary.Close Connection
    WMILibrary.Is Machine Running    ${client_ip}    ${hostname}\\Administrator    ${admin_pwd}
    # Disable Windows Firewall
    ${output}=    WMILibrary.Run Remote Command And Return Output    netsh advfirewall set allprofiles state off
    #increase the screen resolution to 1280x1024
    Comment    Change Client Resolution    ${client_ip}    Administrator    ${admin_pwd}
    # Browser install
    Run Keyword If    '${browser_to_install}'=='FF45'    __Install FireFox 45
    Run Keyword If    '${browser_to_install}'=='FF38'    __Install FireFox 38
    Run Keyword If    '${browser_to_install}'=='FF31'    __Install FireFox 31
    Run Keyword If    '${browser_to_install}'=='CHROME'    __Install Chrome
    Run Keyword If    '${browser_to_install}'=='IE10'    __Install IE 10    ${server_certificate}    ${application_host}
    Run Keyword If    '${browser_to_install}'=='IE11'    __Install IE 11    ${client_ip}    ${admin_pwd}    ${server_certificate}    ${application_host}
    #install Libraries
    aws_environment_resource.__Install Libraries on client    ${client_ip}    Administrator    ${admin_pwd}    ${pypi_url_to_use}
    # Start test machine slave
    Wait Until Keyword Succeeds    300s    10s    __Start test machine slave    ${client_ip}    ${hostname}\\Administrator    ${admin_pwd}
    WMILibrary.Close Connection
    [Return]    ${client_ip}    ${hostname}    ${admin_pwd}

Update AWS RHEL Oracle Settings Search
    [Arguments]    ${server_ip}    ${private_key_file}    ${root_user}=ec2-user    ${oracle_user}=oracle    ${oracle_home}=/u01/app/oracle/product/11.2.0/db1    ${edit_sqlnet_ora}=${False}
    SSHLibrary.Open Connection    ${server_ip}    timeout=30s    width=150
    SSHLibrary.Login With Public Key    ${root_user}    ${private_key_file}
    SSHLibrary.Set Client Configuration    prompt=>
    SSHLibrary.Write    sudo su oracle
    SSHLibrary.Read Until Prompt
    #update Oracle listener
    Run Keyword And Ignore Error    SSHLibrary.Write    sed -ie s/CHANGEME/${server_ip}/ ${oracle_home}/network/admin/listener.ora
    Run Keyword And Ignore Error    SSHLibrary.Write    sed -ie 's/\(HOST = [0-9.]*\)/\(HOST = ${server_ip}\)/' ${oracle_home}/network/admin/listener.ora
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    sed -ie 's/\(PORT = [0-9]*\)/\(PORT = 1521\)/' ${oracle_home}/network/admin/listener.ora
    SSHLibrary.Read Until Prompt
    #update Oracle TNSnames
    SSHLibrary.Write    sed -ie s/CHANGEME/${server_ip}/ ${oracle_home}/network/admin/tnsnames.ora
    SSHLibrary.Write    's/\(HOST = [0-9.]*\)/\(HOST = ${server_ip}\)/' ${oracle_home}/network/admin/tnsnames.ora
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    sed -ie 's/\(PORT = [0-9]*\)/\(PORT = 1521\)/' ${oracle_home}/network/admin/tnsnames.ora
    SSHLibrary.Read Until Prompt
    #update Oracle sqlnet.ora
    Run Keyword If    ${edit_sqlnet_ora}    SSHLibrary.Write    sed -ie s/SQLNET\.ALLOWED_LOGON_VERSION=[0-9]*/SQLNET.ALLOWED_LOGON_VERSION=8/ ${oracle_home}/network/admin/sqlnet.ora
    Run Keyword If    ${edit_sqlnet_ora}    SSHLibrary.Read Until Prompt
    SSHLibrary.Close Connection

Clean Up Run
    Start Stack Deletion    ${stack_name}
    Wait For Stack Deletion Complete    ${stack_name}    600s
    AWSLibrary.Terminate All Run Instances
    # delete runs folder and everything within it
    AWSLibrary.Delete From Bucket    idbs-automation    runs/${run_id}

__Check server has started__
    [Arguments]    ${server}    ${user}    ${private_key_file}    ${console_path}=/home/ec2-user/IDBS/EWB/EWBServer/wildfly/standalone/log/console.log    ${ssh_port}=22
    Wait Until Keyword Succeeds    300    5    SSH Connect with private key    ${server}    ${user}    ${private_key_file}
    ...    ${ssh_port}
    ${rc}=    SSHLibrary.Execute Command    grep -i 'started in' ${console_path}    return_stdout=${False}    return_stderr=${False}    return_rc=${True}
    Should Be Equal As Integers    ${rc}    0    E-WorkBook Application server hasn't started yet.
    [Teardown]    Run Keyword And Ignore Error    SSHLibrary.Close Connection

Wait for E-WorkBook App Server to Start
    [Arguments]    ${server}    ${user}    ${private_key_file}    ${console_path}=/home/ec2-user/IDBS/EWB/EWBServer/wildfly/standalone/log/console.log    ${timeout}=300    ${ssh_port}=22
    Wait Until Keyword Succeeds    ${timeout}    20 sec    __Check server has started__    ${server}    ${user}    ${private_key_file}
    ...    ${console_path}    ${ssh_port}

Non-Stack Teardown
    AWSLibrary.Terminate All Run Instances
    # delete runs folder and everything within it
    AWSLibrary.Delete From Bucket    idbs-automation    runs/${run_id}

Modify Oracle Memory Allocation - Linux
    [Arguments]    ${host}    ${host_root_key_file}    ${memory_target}    ${memory_max_target}    ${oracle_user}=oracle    ${port}=2223
    ...    ${host_root_user}=ec2-user    ${oracle_sys_user}=sys    ${oracle_sys_password}=system01
    SSHLibrary.Open Connection    ${host}    timeout=60    port=${port}
    SSHLibrary.Login With Public Key    ${host_root_user}    ${host_root_key_file}
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=>
    SSHLibrary.Write    sudo su ${oracle_user}
    SSHLibrary.Read Until Prompt
    SSHLibrary.Set Client Configuration    timeout=300s    prompt=>
    SSHLibrary.Write    sqlplus ${oracle_sys_user}/${oracle_sys_password} as sysdba
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    alter system set memory_max_target=${memory_max_target} scope=spfile;
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    alter system set memory_target=${memory_target} scope=spfile;
    SSHLibrary.Read Until Prompt
    SSHLibrary.Close Connection

Modify Max Shared Memory - Linux
    [Arguments]    ${host}    ${host_root_key_file}    ${memory_size}    ${host_root_user}=ec2-user    ${port}=2223
    SSHLibrary.Open Connection    ${host}    timeout=60    port=${port}
    SSHLibrary.Login With Public Key    ${host_root_user}    ${host_root_key_file}
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=#
    SSHLibrary.Write    sudo su -
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    mount -o remount,size=${memory_size} /dev/shm
    SSHLibrary.Read Until Prompt
    SSHLibrary.Close Connection

__Install secBOT on client
    [Arguments]    ${client_ip}    ${admin_user}    ${admin_password}    ${pypi_url_to_use}=${PYPI_SERVER}
    WMILibrary.Open Connection    ${client_ip}    ${admin_user}    ${admin_password}
    #install Java
    Wait Until Keyword Succeeds    5 minutes    10 seconds    WMILibrary.Put File    ${CURDIR}/jre-8u60-windows-x64.exe    C:/java_install/jre-8u60-windows-x64.exe
    WMILibrary.Put File Contents    C:/java_install/Install_java.cmd    C:\\java_install\\jre-8u60-windows-x64.exe /s /L C:\\java_install\\java_install.log
    ${output}=    WMILibrary.Run Remote Command And Return Output    C:/java_install/Install_java.cmd
    Log    ${output}
    ${output}=    WMILibrary.Run Remote Command And Return Output    setx PATH "%PATH%;C:\\Program Files\\Java\\jre1.8.0_60\\bin"
    Log    ${output}
    #update proxy URL
    Comment    ServerControlLibrary.Run Command On Machine    ${client_ip}    reg add "HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" /v "ProxyServer" /d "127.0.0.1:3838" /f /reg:32
    Comment    ServerControlLibrary.Run Command On Machine    ${client_ip}    reg add "HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" /v "ProxyServer" /d "127.0.0.1:3838" /f
    #install zap + secBOT
    __Robust_pip_install    python-owasp-zap-v2.4    ${pypi_url_to_use}
    __Robust_pip_install    secbot    ${pypi_url_to_use}
    [Teardown]    WMILibrary.Close Connection

__Start test machine slave headless
    [Arguments]    ${client_ip}    ${admin_user}    ${admin_pwd}
    WMILibrary.Open Connection    ${client_ip}    ${admin_user}    ${admin_pwd}
    ${discard}=    WMILibrary.Run Remote Command And Return Output    C:\\test_machine_slave\\start_slave.cmd
    ServerControlLibrary.Wait For Machine    ${client_ip}    60s
    WMILibrary.Close Connection

Ensure slave is running headless
    [Arguments]    ${client_ip}    ${admin_user}    ${admin_pwd}
    ${result}    Run Keyword And Return Status    ServerControlLibrary.Wait For Machine    ${client_ip}    20s
    Run Keyword Unless    ${result}    __Start test machine slave headless    ${client_ip}    ${admin_user}    ${admin_pwd}
