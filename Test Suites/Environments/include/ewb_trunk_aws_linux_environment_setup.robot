*** Settings ***
Library           FileLibrary
Library           SSHLibrary    timeout=600
Library           AWSLibrary
Library           SubversionLibrary    C:/robotframework-settings/subversion.conf
Library           TestDataGenerationLibrary
Library           OperatingSystem
Library           String
Library           OracleLibrary
Resource          aws_environment_resource.txt

*** Variables ***
${aws_rhel_base_image_name}    RHEL-6.5_GA-20140929-x86_64
${aws_rhel_71_image_name}    AUTOMATION_RHEL71-2015
${aws_red_hat_inc_owner_id}    309956199498
${aws_rhel_oracle_11_base_image_name}    AUTOMATION_RHEL65_ORACLE11GR2-2015
${ewb_101_db_base_image_name}    AUTOMATION_EWBDB_10_1_ORA12C
${EWB_AMI_VERSION}    10.1.3 Build 10
${BASELINE_EWB_DATABASE_SERVER}    E-WorkBook ${EWB_AMI_VERSION} Database Server
${BASELINE_EWB_MODEL_SERVER}    E-WorkBook ${EWB_AMI_VERSION} Model Server
${BASELINE_EWB_APPLICATION_SERVER}    E-WorkBook ${EWB_AMI_VERSION} Application Server
${BASELINE_EWB_LINUX_MODEL_SERVER}    E-WorkBook ${EWB_AMI_VERSION} Linux Model Server

*** Keywords ***
Setup Core Database - Linux
    [Arguments]    ${server}    ${core_install_directory}    ${private_key_file}    ${root_user}=ec2-user    ${oracle_sid}=ORA11GR2    ${oracle_user}=oracle
    ...    ${oracle_sys_user}=sys    ${oracle_sys_password}=system01
    Start Oracle Process - Linux    ${server}    ${root_user}    ${private_key_file}    ${oracle_user}    ${oracle_sys_user}    ${oracle_sys_password}
    SSHLibrary.Open Connection    ${server}
    SSHLibrary.Login With Public Key    ${root_user}    ${private_key_file}
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$
    #copy database folder over
    FileLibrary.Zip Directory To Archive    ${core_install_directory}/CD Image/Database    ${OUTPUT_DIR}/db_install.zip
    SSHLibrary.Put File    ${OUTPUT_DIR}/db_install.zip    /home/${root_user}/database_install/db_install.zip
    SSHLibrary.Write    cd /home/${root_user}/database_install
    SSHLibrary.Write    unzip -q /home/${root_user}/database_install/db_install.zip
    SSHLibrary.Read Until Prompt
    #permissions modification
    SSHLibrary.Execute Command    chmod -R 777 /home/${root_user}/database_install
    SSHLibrary.Execute Command    chmod 755 /home/${oracle_user}/database_install/eworkbook.sh
    #configure ewb_site_config
    SSHLibrary.Get File    /home/${root_user}/database_install/ewbsuite_site_configuration.sql    ${OUTPUTDIR}/ewbsuite_site_configuration.sql
    Replace Regexp In File    ${OUTPUTDIR}/ewbsuite_site_configuration.sql    DEFINE EXTPROC_DLL.*=.*$    DEFINE EXTPROC_DLL = '/home/${root_user}/database_install/install/chemserver/Linux/Lin64/IDBSChemXtra9.so'
    Replace Regexp In File    ${OUTPUTDIR}/ewbsuite_site_configuration.sql    DEFINE CACHE_EXE.*=.*$    DEFINE CACHE_EXE = '/home/${root_user}/database_install/install/chemserver/Linux/Lin64'
    SSHLibrary.Put File    ${OUTPUTDIR}/ewbsuite_site_configuration.sql    /home/${root_user}/database_install/ewbsuite_site_configuration.sql
    SSHLibrary.Close Connection
    #create EWB database user
    Create EWB Database User - Linux    ${server}    ${root_user}    ${private_key_file}    ${oracle_user}    ${oracle_sys_user}    ${oracle_sys_password}
    ...    /home/${root_user}/database_install
    #run install
    SSHLibrary.Open Connection    ${server}    timeout=3000s    width=150
    SSHLibrary.Login With Public Key    ${root_user}    ${private_key_file}
    SSHLibrary.Write    sudo su ${oracle_user}
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    cd /home/${root_user}/database_install
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    mkdir /home/${root_user}/database_install/log
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    ./eworkbook.sh EWB_DATABASE_USER EWB_DATABASE_USER ${oracle_sid}
    ${val}=    SSHLibrary.Read Until    DEPLOYMENT COMPLETE
    SSHLibrary.Get Directory    /home/${root_user}/database_install/log    ${OUTPUT_DIR}/db_install_logs
    SSHLibrary.Close Connection

Setup Asset Hub Database - Linux
    [Arguments]    ${server}    ${oracle_sid}    ${oracle_username}    ${oracle_user_password}    ${asset_hub_prefix}    ${core_install_directory}
    [Documentation]    Sets up the EWB asset hub database on a given linux server.
    ...
    ...    *Arguments*
    ...    - _server_ - the server to install the database on
    ...    - _oracle_sid_ - the Oracle SID for the database instance on the server
    ...    - _oracle_username_ - \ the username for the oracle owner on the linux server
    ...    - _oracle_user_password_ - the password for the oracle owner on the linux server
    ...    - _asset_hub_prefix_ - the prefix to use for the asset hub install
    ...    - _core_install_directory_ - the root directory for the EWB build to be installed
    ...
    ...    *Preconditions*
    ...
    ...    The server must have the core EWB database installed first.
    ...
    ...    *Return Value*
    ...
    ...    None
    SSHLibrary.Open Connection    ${server}    22
    SSHLibrary.Login    root    chongololo
    #copy database folder over
    SSHLibrary.Put Directory    ${core_install_directory}/CD Image/Database/asset-hub    /asset_database_install
    #permissions modification
    SSHLibrary.Execute Command    chmod 755 /asset_database_install/install/hub_site_configuration.sql
    SSHLibrary.Execute Command    chmod 755 /asset_database_install/install/install.sh
    #configure hub_site_config
    SSHLibrary.Get File    /asset_database_install/install/hub_site_configuration.sql    ${OUTPUTDIR}/hub_site_configuration.sql
    ${regexp}=    Regexp Escape    AH1
    Replace Regexp In File    ${OUTPUTDIR}/hub_site_configuration.sql    ${regexp}    ${asset_hub_prefix}
    SSHLibrary.Put File    ${OUTPUTDIR}/hub_site_configuration.sql    /asset_database_install/install/hub_site_configuration.sql
    #run install
    SSHLibrary.Close Connection
    SSHLibrary.Open Connection    ${server}    22    prompt=$
    SSHLibrary.Login    ${oracle_username}    ${oracle_user_password}
    SSHLibrary.Write    cd /asset_database_install/install
    ${val}=    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    ./install.sh EWB_DATABASE_USER EWB_DATABASE_USER ${ORACLE_SID} install_hub.sql
    ${val}=    SSHLibrary.Read Until    Install complete

Setup LDAP Application Server - Linux
    [Arguments]    ${server}    ${root_user}    ${private_key_file}    ${core_installation_directory}    ${oracle_server}    ${oracle_sid}
    ...    ${model_server}    ${chemaxon_webservice_url}=http://localhost:9080    ${model_server_port}=7777    ${custom_ldap_server_ip}=${EMPTY}    ${min_memory}=2048    ${max_memory}=4096
    [Documentation]    Sets up the EWB Application Server using LDAP authentication on the given Linux server.
    ...
    ...    *Arugments*
    ...    - _server_ - the machine to install the server on
    ...    - _install_version_ - the EWB install version
    ...    - _core_installation_directory_ - the root directory of the EWB Build you want to install
    ...    - _oracle_sid_ - the SID of the Oracle instance containing the EWB database
    ...    - _oracle_server=localhost_ - the machine containing the EWB database. Defaults to localhost.
    ...
    ...    *Preconditions*
    ...
    ...    The server must be on. The EWB database must be successfully installed
    ...
    ...    *Return Value*
    ...
    ...    None
    #LDAP Host IP
    ${ldap_ip}=    Run Keyword If    '${custom_ldap_server_ip}'=='${EMPTY}'    AWSLibrary.Get IP From Hostname    VPCS-EWB-LDAP
    ${ldap_ip}=    Set Variable If    '${custom_ldap_server_ip}'!='${EMPTY}'    ${custom_ldap_server_ip}    ${ldap_ip}
    SSHLibrary.Open Connection    ${server}    timeout=120s
    SSHLibrary.Login With Public Key    ${root_user}    ${private_key_file}
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$
    #install phantomjs dependencies
    ${rc}    ${err}    SSHLibrary.Execute Command    sudo yum -y install fontconfig    True    True
    #put server files
    SSHLibrary.Put File    ${core_installation_directory}/CD Image/Install/IDBS E-WorkBook (Unix Server)/EWBServer.tar.gz    /home/${root_user}/IDBS/EWB/
    SSHLibrary.Execute Command    tar xvfz /home/${root_user}/IDBS/EWB/EWBServer.tar.gz -C /home/${root_user}/IDBS/EWB
    SSHLibrary.Execute Command    cp -r /home/${root_user}/IDBS/EWB/EWBServer/unixjvms/64BitLinux/* /home/${root_user}/IDBS/EWB/EWBServer/_server_jvm
    #edit initial configuration script
    SSHLibrary.Get File    /home/${root_user}/IDBS/EWB/EWBServer/bin/first-time-setup.conf.sh    ${OUTPUTDIR}/first-time-setup.conf.sh
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    database_ip=.*$    database_ip='${oracle_server}'
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    database_port=.*$    database_port='1521'
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    database_instance_name=.*$    database_instance_name='${oracle_sid}'
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    server_auth=.*$    server_auth=ldap
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    ldap_url=.*$    ldap_url='ldap://${ldap_ip}:389'
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    ldap_authentication=.*$    ldap_authentication='simple'
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    ldap_principal_prefix=.*$    ldap_principal_prefix='cn='
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    ldap_principal_suffix=.*$    ldap_principal_suffix=',ou=testing,dc=eworkbook,dc=idbs,dc=com'
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    ldap_search=.*$    ldap_search='false'
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    modelserver_frontend_url=.*$    modelserver_frontend_url=http://${model_server}:${model_server_port}
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    \# this_host=.*$    this_host=${server}
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    cluster_name=.*$    cluster_name=${server}
    SSHLibrary.Put File    ${OUTPUTDIR}/first-time-setup.conf.sh    /home/${root_user}/IDBS/EWB/EWBServer/bin/first-time-setup.conf.sh
    #set JBOSS_NODE_NAME to be less than 23 characters and increase memory
    SSHLibrary.Get File    /home/${root_user}/IDBS/EWB/EWBServer/wildfly/ewb/ewb-standalone-conf.sh    ${OUTPUTDIR}/ewb-standalone-conf.sh
    Replace Regexp In File    ${OUTPUTDIR}/ewb-standalone-conf.sh    \# JBOSS_NODE_NAME=.*$    JBOSS_NODE_NAME=${SERVER}_EWB
    Replace Regexp In File    ${OUTPUTDIR}/ewb-standalone-conf.sh    (JAVA_OPTS=.*)-Xms[0-9]{3,4}m -Xmx[0-9]{1}g    \\1-Xms${min_memory}m -Xmx${max_memory}m
    SSHLibrary.Put File    ${OUTPUTDIR}/ewb-standalone-conf.sh    /home/${root_user}/IDBS/EWB/EWBServer/wildfly/ewb/ewb-standalone-conf.sh
    #set Connection Pool higher than default to handle load and performance
    SSHLibrary.Get File    /home/${root_user}/IDBS/EWB/EWBServer/wildfly/standalone/configuration/standalone-ewb-ha.xml    ${OUTPUTDIR}/ewb-standalone-conf.sh
    Replace Regexp In File    ${OUTPUTDIR}/ewb-standalone-conf.sh    <max-pool-size>15    <max-pool-size>300
    SSHLibrary.Put File    ${OUTPUTDIR}/ewb-standalone-conf.sh    /home/${root_user}/IDBS/EWB/EWBServer/wildfly/standalone/configuration/standalone-ewb-ha.xml
    #ensure line endings are correct following transfer from windows machine
    SSHLibrary.Execute Command    perl -i -pe's/\r$//;' /home/${root_user}/IDBS/EWB/EWBServer/wildfly/ewb/ewb-standalone-conf.sh
    SSHLibrary.Execute Command    perl -i -pe's/\r$//;' /home/${root_user}/IDBS/EWB/EWBServer/bin/first-time-setup.sh
    SSHLibrary.Execute Command    perl -i -pe's/\r$//;' /home/${root_user}/IDBS/EWB/EWBServer/bin/first-time-setup.conf.sh
    SSHLibrary.Execute Command    perl -i -pe's/\r$//;' /home/${root_user}/IDBS/EWB/EWBServer/bin/eworkbook.sh
    #modify permissions to allow scripts to be executed
    SSHLibrary.Execute Command    chmod 755 /home/${root_user}/IDBS/EWB/EWBServer/bin/first-time-setup.sh
    SSHLibrary.Execute Command    chmod 755 /home/${root_user}/IDBS/EWB/EWBServer/bin/eworkbook.sh
    SSHLibrary.Execute Command    chmod 755 /home/${root_user}/IDBS/EWB/EWBServer/wildfly/phantomjs/bin/linux/phantomjs
    #execute first time configuration
    SSHLibrary.Write    cd /home/${root_user}/IDBS/EWB/EWBServer/bin/
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    ./first-time-setup.sh
    SSHLibrary.Read Until Prompt
    #ensure line endings are correct following first time setup
    SSHLibrary.Execute Command    perl -i -pe's/\r$//;' /home/${root_user}/IDBS/EWB/EWBServer/wildfly/standalone/configuration/standalone-ewb-ha.xml

Add Custom Record Widgets To Application Server - Linux
    [Arguments]    ${server}    ${root_user}    ${private_key_file}
    [Documentation]    Adds the custom record widget items to the application server
    ...
    ...    *Arguments*
    ...
    ...    - _server_ - the server containing the application server
    ...
    ...    *Preconditions*
    ...
    ...    The application server must have been successfully installed before calling this keyword
    ...
    ...    *Return Value*
    ...
    ...    None
    OperatingSystem.Create Directory    ${OUTPUT_DIR}/custom_widgets
    SubversionLibrary.Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Test%20Data/Web%20Client/Custom%20Panel%20Extension/Test%20Harness%20Widgets/ewb-test-data-binary.wgt    ${OUTPUT_DIR}/custom_widgets/ewb-test-data-binary.wgt
    SubversionLibrary.Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Test%20Data/Web%20Client/Custom%20Panel%20Extension/Test%20Harness%20Widgets/ewb-test-data-file.wgt    ${OUTPUT_DIR}/custom_widgets/ewb-test-data-file.wgt
    SubversionLibrary.Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Test%20Data/Web%20Client/Custom%20Panel%20Extension/Test%20Harness%20Widgets/ewb-test-data-text.wgt    ${OUTPUT_DIR}/custom_widgets/ewb-test-data-text.wgt
    SubversionLibrary.Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Test%20Data/Web%20Client/Custom%20Panel%20Extension/Test%20Harness%20Widgets/ewb-test-doc-attr-get-set.wgt    ${OUTPUT_DIR}/custom_widgets/ewb-test-doc-attr-get-set.wgt
    SubversionLibrary.Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Test%20Data/Web%20Client/Custom%20Panel%20Extension/Test%20Harness%20Widgets/ewb-test-doc-attr-load-save.wgt    ${OUTPUT_DIR}/custom_widgets/ewb-test-doc-attr-load-save.wgt
    SubversionLibrary.Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Test%20Data/Web%20Client/Custom%20Panel%20Extension/Test%20Harness%20Widgets/ewb-test-doc-preview.wgt    ${OUTPUT_DIR}/custom_widgets/ewb-test-doc-preview.wgt
    SubversionLibrary.Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Test%20Data/Web%20Client/Custom%20Panel%20Extension/Test%20Harness%20Widgets/ewb-test-extension-command.wgt    ${OUTPUT_DIR}/custom_widgets/ewb-test-extension-command.wgt
    SubversionLibrary.Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Test%20Data/Web%20Client/Custom%20Panel%20Extension/Test%20Harness%20Widgets/ewb-test-extension-error.wgt    ${OUTPUT_DIR}/custom_widgets/ewb-test-extension-error.wgt
    SubversionLibrary.Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Test%20Data/Web%20Client/Custom%20Panel%20Extension/Test%20Harness%20Widgets/ewb-test-rec-attr-fixed.wgt    ${OUTPUT_DIR}/custom_widgets/ewb-test-rec-attr-fixed.wgt
    SubversionLibrary.Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Test%20Data/Web%20Client/Custom%20Panel%20Extension/Test%20Harness%20Widgets/ewb-test-rec-attr-get.wgt    ${OUTPUT_DIR}/custom_widgets/ewb-test-rec-attr-get.wgt
    SubversionLibrary.Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Test%20Data/Web%20Client/Custom%20Panel%20Extension/Test%20Harness%20Widgets/ewb-test-rec-attr-load.wgt    ${OUTPUT_DIR}/custom_widgets/ewb-test-rec-attr-load.wgt
    SubversionLibrary.Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Test%20Data/Web%20Client/Custom%20Panel%20Extension/Test%20Harness%20Widgets/ewb-test-server.wgt    ${OUTPUT_DIR}/custom_widgets/ewb-test-server.wgt
    SubversionLibrary.Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Test%20Data/Web%20Client/Custom%20Panel%20Extension/Test%20Harness%20Widgets/ewb-test-user.wgt    ${OUTPUT_DIR}/custom_widgets/ewb-test-user.wgt
    SubversionLibrary.Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Test%20Data/Web%20Client/Custom%20Panel%20Extension/Test%20Harness%20Widgets/ewb-web-attr.wgt    ${OUTPUT_DIR}/custom_widgets/ewb-web-attr.wgt
    SubversionLibrary.Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Test%20Data/Web%20Client/Custom%20Panel%20Extension/Test%20Harness%20Widgets/ewb-web-html.wgt    ${OUTPUT_DIR}/custom_widgets/ewb-web-html.wgt
    SubversionLibrary.Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Test%20Data/Web%20Client/Custom%20Panel%20Extension/Test%20Harness%20Widgets/ewb-web-text.wgt    ${OUTPUT_DIR}/custom_widgets/ewb-web-text.wgt
    SubversionLibrary.Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Test%20Data/Web%20Client/Custom%20Panel%20Extension/Test%20Harness%20Widgets/noEDIT.wgt    ${OUTPUT_DIR}/custom_widgets/noEDIT.wgt
    SubversionLibrary.Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Test%20Data/Web%20Client/Custom%20Panel%20Extension/Test%20Harness%20Widgets/yesEDIT.wgt    ${OUTPUT_DIR}/custom_widgets/yesEDIT.wgt
    SubversionLibrary.Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Test%20Data/Web%20Client/Custom%20Panel%20Extension/Test%20Harness%20Widgets/ewb-test-extension-error2.wgt    ${OUTPUT_DIR}/custom_widgets/ewb-test-extension-error2.wgt
    SubversionLibrary.Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Test%20Data/Web%20Client/Custom%20Panel%20Extension/Test%20Harness%20Widgets/ewb-test-fullscreen-edit.wgt    ${OUTPUT_DIR}/custom_widgets/ewb-test-fullscreen-edit.wgt
    SubversionLibrary.Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Test%20Data/Web%20Client/Custom%20Panel%20Extension/Test%20Harness%20Widgets/ewb-test-fullscreen-edit-save-exit.wgt    ${OUTPUT_DIR}/custom_widgets/ewb-test-fullscreen-edit-save-exit.wgt
    SubversionLibrary.Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Test%20Data/Web%20Client/Custom%20Panel%20Extension/Test%20Harness%20Widgets/ewb-test-override-save.wgt    ${OUTPUT_DIR}/custom_widgets/ewb-test-override-save.wgt
    SSH Connect with private key    ${server}    ${root_user}    ${private_key_file}
    SSHLibrary.Execute Command    rm -rf /home/${root_user}/IDBS/EWB/EWBServer/wildfly/CustomPanelExtensions
    SSHLibrary.Put Directory    ${OUTPUT_DIR}/custom_widgets    /home/${root_user}/IDBS/EWB/EWBServer/wildfly/CustomPanelExtensions
    SSHLibrary.Close Connection

Create EWB Database User - Linux
    [Arguments]    ${server}    ${root_user}    ${private_key}    ${oracle_user}    ${oracle_sys_user}    ${oracle_sys_password}
    ...    ${database_install_dir}
    SSHLibrary.Open Connection    ${server}    width=150    timeout=60s
    SSHLibrary.Login With Public Key    ${root_user}    ${private_key}
    SSHLibrary.Set Client Configuration    prompt=>
    SSHLibrary.Write    sudo su ${oracle_user}
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    cd ${database_install_dir}
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    sqlplus ${oracle_sys_user}/${oracle_sys_password} as sysdba
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    @CREATE_EWB_DATABASE_USER.sql
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    exit
    SSHLibrary.Read Until Prompt
    SSHLibrary.Close Connection

Deploy LDAP Application Server to AWS Instance
    [Arguments]    ${server_ip}    ${root_user}    ${root_private_key}    ${build_folder}    ${database_ip}    ${database_sid}
    ...    ${model_server_ip}    ${model_server_port}=7777    ${custom_ldap_server_ip}=${EMPTY}    ${min_app_server_memory}=2096    ${max_app_server_memory}=4096    ${perf_log_debug}=${FALSE}
    Wait for SSH Connection    ${server_ip}    ${root_user}    ${root_private_key}
    Setup LDAP Application Server - Linux    ${server_ip}    ${root_user}    ${root_private_key}    ${build_folder}    ${database_ip}    ${database_sid}
    ...    ${model_server_ip}    model_server_port=${model_server_port}    custom_ldap_server_ip=${custom_ldap_server_ip}    min_memory=${min_app_server_memory}    max_memory=${max_app_server_memory}
    Run Keyword If    ${perf_log_debug}    Set App Server Performance Logging    ${server_ip}    ${root_user}    ${root_private_key}
    Enable Landscape Auditing    ${server_ip}    ${root_user}    ${root_private_key}
    Add Custom Record Widgets To Application Server - Linux    ${server_ip}    ${root_user}    ${root_private_key}
    Apply Business Rules Configuration - Linux    ${server_ip}    ${root_user}    ${root_private_key}
    Run Keyword And Ignore Error    Setup ChemAxon Server - Linux    ${server_ip}    ${root_user}    ${root_private_key}    ${build_folder}    ${database_ip}
    ...    ${database_sid}    ${server_ip}:8443

Deploy Database to AWS Instance
    [Arguments]    ${database_ip}    ${root_user}    ${root_private_key}    ${build_folder}
    Wait for SSH Connection    ${database_ip}    ${root_user}    ${root_private_key}
    Update AWS RHEL Oracle Settings    ${database_ip}    ${root_private_key}
    Setup Core Database - Linux    ${database_ip}    ${build_folder}    ${root_private_key}
    Setup Database Monitor - Linux    ${database_ip}    ${root_user}    ${root_private_key}
    Reset Hub Metadata    ${database_ip}    ${root_user}    ${root_private_key}

Start LDAP Application Server
    [Arguments]    ${server}    ${root_user}    ${private_key_file}
    [Documentation]    Starts the EWB application server process
    SSHLibrary.Open Connection    ${server}    timeout=120s
    SSHLibrary.Login With Public Key    ${root_user}    ${private_key_file}
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$
    SSHLibrary.Write    cd /home/${root_user}/IDBS/EWB/EWBServer/bin/
    SSHLibrary.Read Until Prompt
    #run server
    SSHLibrary.Write    ./eworkbook.sh start
    SSHLibrary.Read Until Prompt
    Wait Until Keyword Succeeds    600s    15s    Check application server has started    ${server}    ${root_user}    ${private_key_file}

Run Model Server on AWS - Linux
    [Arguments]    ${server}    ${root_user}    ${private_key_file}    ${core_installation_directory}
    Wait for SSH Connection    ${server}    ${root_user}    ${private_key_file}
    SSH Connect with private key    ${server}    ${root_user}    ${private_key_file}
    SSHLibrary.Write    export PS1="DONE$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=DONE$
    # Install pre-requisites
    ${output}=    SSHLibrary.Execute Command    sudo yum-config-manager --enable rhui-REGION-rhel-server-extras rhui-REGION-rhel-server-optional
    ${output}=    SSHLibrary.Execute Command    sudo yum -y install xorg-x11-server-Xvfb
    ${output}=    SSHLibrary.Execute Command    sudo yum install libXrender -y
    ${output}=    SSHLibrary.Execute Command    sudo yum install libXtst -y
    #put server files
    SSHLibrary.Put Directory    ${core_installation_directory}/CD Image/Install/IDBS Spreadsheet Server (UNIX Server)    /home/${root_user}/IDBS/SpreadsheetServer/
    SSHLibrary.Write    cd /home/${root_user}/IDBS/SpreadsheetServer
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    tar xvzf SpreadsheetServer.tar.gz
    Wait Until Keyword Succeeds    600    120    SSHLibrary.Read Until Prompt    # apparently SSHLibrary.Read Until Prompt doesn't take a timout variable...?
    SSHLibrary.Write    ./startup.sh
    SSHLibrary.Read Until Prompt
    SSHLibrary.Close Connection

Copy Application Server Logs - Linux
    [Arguments]    ${server}    ${root_user}    ${private_key_file}    ${ssh_port}=22
    [Documentation]    Copies the application server logs to a server_logs folder within the output directory
    SSHLibrary.Open Connection    ${server}    timeout=120s    port=${ssh_port}
    SSHLibrary.Login With Public Key    ${root_user}    ${private_key_file}
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$
    SSHLibrary.Get Directory    /home/${root_user}/IDBS/EWB/EWBServer/wildfly/standalone/log    ${OUTPUT_DIR}/Server Logs
    Run Keyword And Ignore Error    SSHLibrary.Get File    /home/${root_user}/IDBS/EWB/EWBServer/wildfly/bin/*.log    ${OUTPUT_DIR}/JVM Logs
    SSHLibrary.Close Connection

Setup Database Monitor - Linux
    [Arguments]    ${server}    ${root_user}    ${private_key_file}    ${oracle_user}=oracle    ${oracle_sys_user}=sys    ${oracle_sys_password}=system01
    SSHLibrary.Open Connection    ${server}    width=150
    SSHLibrary.Login With Public Key    ${root_user}    ${private_key_file}
    SSHLibrary.Write    sudo su ${oracle_user}
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$
    SSHLibrary.Read Until Prompt
    # Set-up database monitoring tool
    ${temp_folder}=    Create Unique ID    Datbase_tools_
    ${temp_folder_full_path}=    Set Variable    ${TEMPDIR}${/}${temp_folder}
    OperatingSystem.Create Directory    ${temp_folder_full_path}
    Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Libraries/Database%20Tools/ewb_session_stats.sql    ${temp_folder_full_path}/ewb_session_stats.sql
    SSHLibrary.Put File    ${temp_folder_full_path}/ewb_session_stats.sql    /home/${root_user}/oracle_tools/ewb_session_stats.sql    0777
    SSHLibrary.Execute Command    chmod -R 777 /home/${root_user}/oracle_tools/
    Remove Directory    ${temp_folder_full_path}    recursive=True
    SSHLibrary.Set Client Configuration    timeout=120s    prompt=>
    SSHLibrary.Write    sqlplus ${oracle_sys_user}/${oracle_sys_password} as sysdba
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    @/home/${root_user}/oracle_tools/ewb_session_stats.sql
    SSHLibrary.Read Until Prompt
    SSHLibrary.Close Connection

Get Open File Descriptors
    [Arguments]    ${server}    ${root_user}    ${private_key_file}    ${ssh_port}=22
    SSH Connect with private key    ${server}    ${root_user}    ${private_key_file}    ${ssh_port}
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$
    ${open_file_descriptors}=    SSHLibrary.Execute Command    sudo sysctl fs.file-nr
    [Return]    ${open_file_descriptors}

Reset Hub Metadata
    [Arguments]    ${server}    ${root_user}    ${private_key_file}    ${oracle_user}=oracle    ${oracle_catalog_hub_user}=IDBS_CATALOG_HUB    ${oracle_catalog_hub_password}=IDBS_CATALOG_HUB
    SSHLibrary.Open Connection    ${server}    width=150
    SSHLibrary.Login With Public Key    ${root_user}    ${private_key_file}
    SSHLibrary.Write    sudo su ${oracle_user}
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$
    SSHLibrary.Read Until Prompt
    # Set-up database monitoring tool
    ${temp_folder}=    Create Unique ID    Datbase_tools_
    ${temp_folder_full_path}=    Set Variable    ${TEMPDIR}${/}${temp_folder}
    OperatingSystem.Create Directory    ${temp_folder_full_path}
    Get File From Subversion    http://20development2/svn/testing-qa/trunk/Projects/E-Workbook/Automated%20Tests/Libraries/Database%20Tools/reset_hub_metadata.sql    ${temp_folder_full_path}/reset_hub_metadata.sql
    SSHLibrary.Put File    ${temp_folder_full_path}/reset_hub_metadata.sql    /home/${root_user}/oracle_tools/reset_hub_metadata.sql    0777
    SSHLibrary.Execute Command    chmod -R 777 /home/${root_user}/oracle_tools/
    Remove Directory    ${temp_folder_full_path}    recursive=True
    SSHLibrary.Set Client Configuration    timeout=600s    prompt=>
    SSHLibrary.Write    sqlplus ${oracle_catalog_hub_user}/${oracle_catalog_hub_password}
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    @/home/${root_user}/oracle_tools/reset_hub_metadata.sql
    SSHLibrary.Read Until Prompt
    SSHLibrary.Close Connection

Apply Business Rules Configuration - Linux
    [Arguments]    ${server}    ${root_user}    ${private_key_file}    ${ssh_port}=22
    Wait Until Keyword Succeeds    10 min    15s    aws_environment_resource.SSH Connect with private key    ${server}    ${root_user}    ${private_key_file}
    ...    ssh_port=${ssh_port}
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$
    @{files}=    SSHLibrary.List Files In Directory    /home/${root_user}/IDBS/EWB/EWBServer/wildfly/standalone/deployments/landscape-ear.ear
    ${war_file_name}=    Set Variable    @{files}[0]
    ${uuid}=    Create Hex GUID
    SSHLibrary.Get File    /home/${root_user}/IDBS/EWB/EWBServer/wildfly/standalone/deployments/landscape-ear.ear/${war_file_name}    ${TEMPDIR}${/}${uuid}_${war_file_name}
    Log    E-WorkBook war file is ${war_file_name}
    Wait Until Keyword Succeeds    60s    5s    Extract Zipped Archive To Folder    ${TEMPDIR}\\${uuid}_${war_file_name}    ${TEMPDIR}\\${uuid}_extracted_landscape
    FileLibrary.Delete File    ${TEMPDIR}\\${uuid}_${war_file_name}
    Replace Regexp In File    ${TEMPDIR}\\${uuid}_extracted_landscape\\WEB-INF\\classes\\META-INF\\ruleset-assets.xml    <!--\n    \n
    Replace Regexp In File    ${TEMPDIR}\\${uuid}_extracted_landscape\\WEB-INF\\classes\\META-INF\\ruleset-assets.xml    \t-->(\n|\t|\ )    \n
    Replace Regexp In File    ${TEMPDIR}\\${uuid}_extracted_landscape\\WEB-INF\\classes\\META-INF\\ruleset-basic.xml    <!--\n    \n
    Replace Regexp In File    ${TEMPDIR}\\${uuid}_extracted_landscape\\WEB-INF\\classes\\META-INF\\ruleset-basic.xml    \t-->(\n|\t|\ )    \n
    Replace Regexp In File    ${TEMPDIR}\\${uuid}_extracted_landscape\\WEB-INF\\classes\\META-INF\\ruleset-request.xml    <!--\n\t[^*<]    \n    ${True}
    Replace Regexp In File    ${TEMPDIR}\\${uuid}_extracted_landscape\\WEB-INF\\classes\\META-INF\\ruleset-request.xml    [^*]\n\t{2,}-->(\n|\t|\ )    >\n    ${True}
    Replace Regexp In File    ${TEMPDIR}\\${uuid}_extracted_landscape\\WEB-INF\\classes\\META-INF\\ruleset-request.xml    <ref bean="declarativeRuleExample1" />    <!--ref bean="declarativeRuleExample1" /-->
    FileLibrary.Zip Directory To Archive    ${TEMPDIR}\\${uuid}_extracted_landscape    ${TEMPDIR}\\${uuid}_${war_file_name}    ${False}
    SSHLibrary.Put File    ${TEMPDIR}\\${uuid}_${war_file_name}    /home/${root_user}/IDBS/EWB/EWBServer/wildfly/standalone/deployments/landscape-ear.ear/${war_file_name}
    SSHLibrary.Close Connection
    Remove Directory    ${TEMPDIR}\\${uuid}_extracted_landscape    recursive=True
    FileLibrary.Delete File    ${TEMPDIR}\\${uuid}_${war_file_name}

Enable Landscape Auditing
    [Arguments]    ${server}    ${root_user}    ${private_key_file}    ${ssh_port}=22
    Wait Until Keyword Succeeds    10 min    15s    aws_environment_resource.SSH Connect with private key    ${server}    ${root_user}    ${private_key_file}
    ...    ssh_port=${ssh_port}
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$
    SSHLibrary.Execute Command    sed -i 's/false/true/g' /home/${root_user}/IDBS/EWB/EWBServer/wildfly/standalone/deployments/landscape-ear.ear/config/audit.properties
    SSHLibrary.Read Until Prompt
    SSHLibrary.Close Connection

Setup ChemAxon Server - Linux
    [Arguments]    ${server}    ${root_user}    ${private_key_file}    ${installation_directory}    ${db_host}    ${db_sid}
    ...    ${EWB_Server}
    [Documentation]    Sets up the EWB Application Server using LDAP authentication on the given server.
    ...
    ...    *Arugments*
    ...    - _server_ - the machine to install the server on
    ...    - _database_host=localhost_ - the machine containing the EWB database. Defaults to localhost.
    ...
    ...    *Preconditions*
    ...
    ...    The server must be on. The EWB database must be successfully installed
    ...
    ...    *Return Value*
    ...
    ...    None
    # Open Connection
    SSH Connect with private key    ${server}    ${root_user}    ${private_key_file}
    #Extract license files
    SSHLibrary.Put File    ${CURDIR}${/}chemaxon_licences_1013.tar.gz    /home/${root_user}/chemaxon_licences_1013.tar.gz
    SSHLibrary.Execute Command    tar zxvf /home/${root_user}/chemaxon_licences_1013.tar.gz
    #Create install configuration file
    SSHLibrary.Write    cat <<EOF > /home/${root_user}/install.cfg
    SSHLibrary.Write    INSTALL_TYPE="full"
    SSHLibrary.Write    ON_SERVICE_RUNNING="stop_service"
    SSHLibrary.Write    LICENCE_PATH="/home/${root_user}/chemaxon"
    SSHLibrary.Write    REMOVE_BACKUP="yes"
    SSHLibrary.Write    TOMCAT_PORT="9080"
    SSHLibrary.Write    EWB_URL="https://localhost:8443/EWorkbookWebApp"
    SSHLibrary.Write    IDBSCWS_DB_HOST="${db_host}"
    SSHLibrary.Write    IDBSCWS_DB_NAME="${db_sid}"
    SSHLibrary.Write    IDBSCWS_DB_PORT="1521"
    SSHLibrary.Write    IDBS_EWB_CHEM_SCHEMA="IDBS_EWB_CHEM"
    SSHLibrary.Write    IDBS_EWB_CHEM_PASSWD="IDBS_EWB_CHEM"
    SSHLibrary.Write    IDBS_EWB_APP_USER="Administrator"
    SSHLibrary.Write    IDBS_EWB_APP_USER_PASSWD="Administrator"
    SSHLibrary.Write    EOF
    SSHLibrary.Read Until Prompt
    # Find installer name and upload it
    ${escaped_install_directory}=    Replace String    ${installation_directory}    \\    /
    ${install_file_name}=    OperatingSystem.List Files In Directory    ${escaped_install_directory}/CD Image/Install/Web Chemistry Server (Unix Server)    IDBSWebChemistryServerInstaller*.bsx    absolute=${True}
    SSHLibrary.Put File    @{install_file_name}[0]    /home/${root_user}/IDBSWebChemistryServerInstaller.bsx
    # Run installer
    SSHLibrary.Execute Command    sudo sh /home/${root_user}/IDBSWebChemistryServerInstaller.bsx /home/${root_user}/install.cfg
    # Startup chemistry server
    SSHLibrary.Execute Command    sudo service tomcatchem start
    SSHLibrary.Close Connection

Save Oracle Data
    [Arguments]    ${host}    ${sid}    ${sys_user}    ${sys_password}    ${host_root_user}    ${host_root_key_file}
    ...    ${host_oracle_user}    ${oracle_rdbms_dir}=/u01/app/oracle/diag/rdbms/ora11gr2/ORA11GR2    ${port}=2223
    [Documentation]    Collect Oracle logs and performance stats and store in ${OUTPUT_DIR}
    OperatingSystem.Create Directory    ${OUTPUT DIR}/Oracle Usage
    Create File    ${OUTPUT DIR}/Oracle Usage/get_usage.sql    SELECT * FROM ewb_session_stats ORDER BY 1;
    Create File    ${OUTPUT DIR}/Oracle Usage/get_ewb_usage.sql    SELECT * FROM EWB_PGA_MEMORY_STATS ORDER BY 1;
    Connect To Database    ${sys_user}    ${sys_password}    //${host}/${sid}    connect_mode=SYSDBA
    Execute Sql Script And Write To Csv File    ${OUTPUT DIR}/Oracle Usage/get_usage.sql    ${OUTPUT DIR}/Oracle Usage/oracle_usage.csv
    Execute Sql Script And Write To Csv File    ${OUTPUT DIR}/Oracle Usage/get_ewb_usage.sql    ${OUTPUT DIR}/Oracle Usage/ewb_usage.csv
    Disconnect From Database
    __Stop Database    ${host}    ${host_root_user}    ${host_root_key_file}    ${host_oracle_user}    ${sys_user}    ${sys_password}
    ...    port=${port}
    SSHLibrary.Open Connection    ${host}    timeout=60    port=${port}
    SSHLibrary.Login With Public Key    ${host_root_user}    ${host_root_key_file}
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$
    SSHLibrary.Write    sudo chmod -R 777 /u01/app/oracle
    SSHLibrary.Read Until Prompt
    SSHLibrary.Get Directory    ${oracle_rdbms_dir}/alert    ${OUTPUT DIR}/Oracle Alert Log
    Zip Directory To Archive    ${OUTPUT DIR}/Oracle Alert Log    ${OUTPUT DIR}/Oracle_alert_log.zip
    Remove Directory    ${OUTPUT DIR}/Oracle Alert Log    recursive=${True}
    SSHLibrary.Get Directory    ${oracle_rdbms_dir}/trace    ${OUTPUT DIR}/Oracle Trace
    Zip Directory To Archive    ${OUTPUT DIR}/Oracle Trace    ${OUTPUT DIR}/Oracle_traces.zip
    Remove Directory    ${OUTPUT DIR}/Oracle Trace    recursive=${True}
    SSHLibrary.Close Connection

Configure EC2 Database
    [Arguments]    ${database_ip}    ${root_user}    ${root_private_key}    ${build_folder}    ${sysuserpass}=system01
    [Documentation]    Configures a EC2 hosted database through the following steps:
    ...
    ...    - Updates the Oracle settings to reflect the new hostname/IP of the EC2 instance
    ...    - Starts the Oracle listener and database instance
    Wait for SSH Connection    ${database_ip}    ${root_user}    ${root_private_key}
    Update AWS RHEL Oracle Settings    ${database_ip}    ${root_private_key}    oracle_home=/u01/app/oracle/product/12.1.0/db_1    edit_sqlnet_ora=True
    Start Oracle Process - Linux    ${database_ip}    ${root_user}    ${root_private_key}    oracle    sys    ${sysuserpass}
    Upgrade EWB Database - Linux    ${database_ip}    ${build_folder}    ${root_private_key}

Upgrade EWB Database - Linux
    [Arguments]    ${server}    ${core_install_directory}    ${private_key_file}    ${oracle_sid}=ora12c    ${oracle_user}=oracle    ${oracle_sys_user}=sys
    ...    ${oracle_sys_password}=system01
    SSH Connect with private key    ${server}    ${oracle_user}    ${private_key_file}
    #copy database folder over
    FileLibrary.Zip Directory To Archive    ${core_install_directory}/CD Image/Database    ${OUTPUT_DIR}/db_upgrade.zip
    SSHLibrary.Put File    ${OUTPUT_DIR}/db_upgrade.zip    /u01/ewb_database_upgrade/db_upgrade.zip    0777
    SSHLibrary.Write    unzip -q -o /u01/ewb_database_upgrade/db_upgrade.zip -d /u01/ewb_database_upgrade
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    mkdir /u01/ewb_database_upgrade/log
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    chmod -R 777 /u01/ewb_database_upgrade
    SSHLibrary.Read Until Prompt
    #configure ewb_site_config
    SSHLibrary.Get File    /u01/ewb_database_upgrade/ewbsuite_site_configuration.sql    ${OUTPUTDIR}/ewbsuite_site_configuration.sql
    Replace Regexp In File    ${OUTPUTDIR}/ewbsuite_site_configuration.sql    DEFINE EXTPROC_DLL.*=.*$    DEFINE EXTPROC_DLL = '/u01/ewb_database_upgrade/install/chemserver/Linux/Lin64/IDBSChemXtra9.so'
    Replace Regexp In File    ${OUTPUTDIR}/ewbsuite_site_configuration.sql    DEFINE CACHE_EXE.*=.*$    DEFINE CACHE_EXE = '/u01/ewb_database_upgrade/install/chemserver/Linux/Lin64'
    SSHLibrary.Put File    ${OUTPUTDIR}/ewbsuite_site_configuration.sql    /u01/ewb_database_upgrade/ewbsuite_site_configuration.sql
    SSHLibrary.Close Connection
    #run install
    SSH Connect with private key    ${server}    ${oracle_user}    ${private_key_file}
    SSHLibrary.Execute Command    cd /u01/ewb_database_upgrade/ ; ./eworkbook.sh EWB_DATABASE_USER EWB_DATABASE_USER ${oracle_sid}
    SSHLibrary.Get Directory    /u01/ewb_database_upgrade/log    ${OUTPUT_DIR}/db_install_logs
    SSHLibrary.Close Connection

Check application server has started
    [Arguments]    ${server}    ${user}    ${private_key_file}    ${console_path}=/home/ec2-user/IDBS/EWB/EWBServer/wildfly/standalone/log/console.log
    SSH Connect with private key    ${server}    ${user}    ${private_key_file}
    ${rc}=    SSHLibrary.Execute Command    grep -i 'started in' ${console_path}    return_stdout=${False}    return_stderr=${False}    return_rc=${True}
    Should Be Equal As Integers    ${rc}    0    Aplication server hasn't started correctly yet.
    [Teardown]    Run Keyword And Ignore Error    SSHLibrary.Close Connection

Start Model Server
    [Arguments]    ${server}    ${user}    ${key}    ${connection_port}=22
    [Documentation]    Starts up the model server on port 7777.
    ...
    ...    Arguments:
    ...    - ${server} - the ip of the server you're connecting to.
    ...    - ${user} - the user to connect to the model server as.
    ...    - ${key} - the authentication key for the machine.
    ...    - ${connection_port} - the port to connect to the machine on.
    Wait Until Keyword Succeeds    10 min    15 sec    SSH Connect with private key    ${server}    ${user}    ${key}
    ...    ${connection_port}
    SSHLibrary.Start Command    cd /home/ec2-user/IDBS/SpreadsheetServer && exec ./startserver.sh 7777
    SSHLibrary.Close Connection

Set App Server Performance Logging
    [Arguments]    ${server}    ${user}    ${key_file}    ${port}=22
    SSH Connect with private key    ${server}    ${user}    ${key_file}    ${port}
    ${output}=    SSHLibrary.Execute Command    cd /home/ec2-user/IDBS/EWB/EWBServer/wildfly/standalone/configuration && sed 's/level name=\"OFF\"/level name=\"DEBUG\"/' <standalone-ewb-ha.xml >temp.xml && mv temp.xml standalone-ewb-ha.xml
    log    ${output}
    SSHLibrary.Close Connection

Restart App Server
    [Arguments]    ${server}    ${user}    ${private_key}    ${ssh_port}=22
    SSH Connect with private key    ${server}    ${user}    ${private_key}    ${ssh_port}
    SSHLibrary.Write    /home/ec2-user/IDBS/EWB/EWBServer/bin/eworkbook.sh stop
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    /home/ec2-user/IDBS/EWB/EWBServer/bin/eworkbook.sh start
    SSHLibrary.Read Until Prompt
    Wait Until Keyword Succeeds    1200s    15s    Check App Server is Running
    SSHLibrary.Close Connection

Create Standard E-WorkBook AWS Test System
    [Arguments]    ${stack_name}    ${key_pair}    ${team}    ${product}    ${root_user}    ${private_key_file}
    ...    ${template_name}=Standard_EWB_Test_System    ${model_server_ami}=${BASELINE_EWB_MODEL_SERVER}
    ${aws_db_ami}=    Wait Until Keyword Succeeds    30 min    30s    Get AMI ID    ${BASELINE_EWB_DATABASE_SERVER}    owner_id=796568017366
    ${aws_app_ami}=    Wait Until Keyword Succeeds    30 min    30s    Get AMI ID    ${BASELINE_EWB_APPLICATION_SERVER}    owner_id=796568017366
    ${aws_ms_ami}=    Wait Until Keyword Succeeds    30 min    30s    Get AMI ID    ${model_server_ami}    owner_id=796568017366
    Start Stack Creation    ${stack_name}    ${template_name}    keypair=${key_pair}    team=${team}    product=${product}    AppServerAMI=${aws_app_ami}
    ...    DBServerAMI=${aws_db_ami}    ModelServerAMI=${aws_ms_ami}    AppServerInstanceProfile=ReadOnlyAccessToEWBSearchBuildOutput
    Wait For Stack Creation Complete    ${stack_name}    1200s
    Sleep    3 minutes    Make sure that the app server has started to reboot
    ${ewb_web_server}=    Set Variable    ${stack_name}.idbs-dev.com
    ${backend_servers}=    Set Variable    ${stack_name}-nat.idbs-dev.com
    Wait for E-WorkBook App Server to Start    ${backend_servers}    ${root_user}    ${private_key_file}    timeout=15 minutes    ssh_port=2222
    [Return]    ${ewb_web_server}    ${backend_servers}

Setup Search LDAP Application Server - Linux
    [Arguments]    ${server}    ${root_user}    ${private_key_file}    ${core_installation_directory}    ${oracle_server}    ${oracle_sid}
    ...    ${model_server}    ${chemaxon_webservice_url}=http://localhost:9080    ${model_server_port}=7777    ${custom_ldap_server_ip}=${EMPTY}    ${min_memory}=2048    ${max_memory}=4096
    [Documentation]    Sets up the EWB Application Server using LDAP authentication on the given Linux server.
    ...
    ...    *Arugments*
    ...    - _server_ - the machine to install the server on
    ...    - _install_version_ - the EWB install version
    ...    - _core_installation_directory_ - the root directory of the EWB Build you want to install
    ...    - _oracle_sid_ - the SID of the Oracle instance containing the EWB database
    ...    - _oracle_server=localhost_ - the machine containing the EWB database. Defaults to localhost.
    ...
    ...    *Preconditions*
    ...
    ...    The server must be on. The EWB database must be successfully installed
    ...
    ...    *Return Value*
    ...
    ...    None
    #LDAP Host IP
    ${ldap_ip}=    Run Keyword If    '${custom_ldap_server_ip}'=='${EMPTY}'    AWSLibrary.Get IP From Hostname    VPCS-EWB-LDAP
    ${ldap_ip}=    Set Variable If    '${custom_ldap_server_ip}'!='${EMPTY}'    ${custom_ldap_server_ip}    ${ldap_ip}
    SSHLibrary.Open Connection    ${server}    timeout=120s
    SSHLibrary.Login With Public Key    ${root_user}    ${private_key_file}
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$
    #install phantomjs dependencies
    ${rc}    ${err}    SSHLibrary.Execute Command    sudo yum -y install fontconfig    True    True
    #put server files
    SSHLibrary.Put File    ${core_installation_directory}/CD Image/Install/IDBS E-WorkBook (Unix Server)/EWBServer.tar.gz    /home/${root_user}/IDBS/EWB/
    SSHLibrary.Execute Command    tar xvfz /home/${root_user}/IDBS/EWB/EWBServer.tar.gz -C /home/${root_user}/IDBS/EWB
    SSHLibrary.Execute Command    cp -r /home/${root_user}/IDBS/EWB/EWBServer/unixjvms/64BitLinux/* /home/${root_user}/IDBS/EWB/EWBServer/_server_jvm
    #edit initial configuration script
    SSHLibrary.Get File    /home/${root_user}/IDBS/EWB/EWBServer/bin/first-time-setup.conf.sh    ${OUTPUTDIR}/first-time-setup.conf.sh
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    database_ip=.*$    database_ip='${oracle_server}'
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    database_port=.*$    database_port='1521'
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    database_instance_name=.*$    database_instance_name='orcl'
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    server_auth=.*$    server_auth=ldap
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    ldap_url=.*$    ldap_url='ldap://${ldap_ip}:389'
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    ldap_authentication=.*$    ldap_authentication='simple'
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    ldap_principal_prefix=.*$    ldap_principal_prefix='cn='
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    ldap_principal_suffix=.*$    ldap_principal_suffix=',ou=testing,dc=eworkbook,dc=idbs,dc=com'
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    ldap_search=.*$    ldap_search='false'
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    modelserver_frontend_url=.*$    modelserver_frontend_url=http://${model_server}:${model_server_port}
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    \# this_host=.*$    this_host=${server}
    Replace Regexp In File    ${OUTPUTDIR}/first-time-setup.conf.sh    cluster_name=.*$    cluster_name=${server}
    SSHLibrary.Put File    ${OUTPUTDIR}/first-time-setup.conf.sh    /home/${root_user}/IDBS/EWB/EWBServer/bin/first-time-setup.conf.sh
    #set JBOSS_NODE_NAME to be less than 23 characters and increase memory
    SSHLibrary.Get File    /home/${root_user}/IDBS/EWB/EWBServer/wildfly/ewb/ewb-standalone-conf.sh    ${OUTPUTDIR}/ewb-standalone-conf.sh
    Replace Regexp In File    ${OUTPUTDIR}/ewb-standalone-conf.sh    \# JBOSS_NODE_NAME=.*$    JBOSS_NODE_NAME=${SERVER}_EWB
    Replace Regexp In File    ${OUTPUTDIR}/ewb-standalone-conf.sh    (JAVA_OPTS=.*)-Xms[0-9]{3,4}m -Xmx[0-9]{1}g    \\1-Xms${min_memory}m -Xmx${max_memory}m
    SSHLibrary.Put File    ${OUTPUTDIR}/ewb-standalone-conf.sh    /home/${root_user}/IDBS/EWB/EWBServer/wildfly/ewb/ewb-standalone-conf.sh
    #set Connection Pool higher than default to handle load and performance
    SSHLibrary.Get File    /home/${root_user}/IDBS/EWB/EWBServer/wildfly/standalone/configuration/standalone-ewb-ha.xml    ${OUTPUTDIR}/ewb-standalone-conf.sh
    Replace Regexp In File    ${OUTPUTDIR}/ewb-standalone-conf.sh    <max-pool-size>15    <max-pool-size>300
    SSHLibrary.Put File    ${OUTPUTDIR}/ewb-standalone-conf.sh    /home/${root_user}/IDBS/EWB/EWBServer/wildfly/standalone/configuration/standalone-ewb-ha.xml
    #ensure line endings are correct following transfer from windows machine
    SSHLibrary.Execute Command    perl -i -pe's/\r$//;' /home/${root_user}/IDBS/EWB/EWBServer/wildfly/ewb/ewb-standalone-conf.sh
    SSHLibrary.Execute Command    perl -i -pe's/\r$//;' /home/${root_user}/IDBS/EWB/EWBServer/bin/first-time-setup.sh
    SSHLibrary.Execute Command    perl -i -pe's/\r$//;' /home/${root_user}/IDBS/EWB/EWBServer/bin/first-time-setup.conf.sh
    SSHLibrary.Execute Command    perl -i -pe's/\r$//;' /home/${root_user}/IDBS/EWB/EWBServer/bin/eworkbook.sh
    #modify permissions to allow scripts to be executed
    SSHLibrary.Execute Command    chmod 755 /home/${root_user}/IDBS/EWB/EWBServer/bin/first-time-setup.sh
    SSHLibrary.Execute Command    chmod 755 /home/${root_user}/IDBS/EWB/EWBServer/bin/eworkbook.sh
    SSHLibrary.Execute Command    chmod 755 /home/${root_user}/IDBS/EWB/EWBServer/wildfly/phantomjs/bin/linux/phantomjs
    #execute first time configuration
    SSHLibrary.Write    cd /home/${root_user}/IDBS/EWB/EWBServer/bin/
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    ./first-time-setup.sh
    SSHLibrary.Read Until Prompt
    #ensure line endings are correct following first time setup
    SSHLibrary.Execute Command    perl -i -pe's/\r$//;' /home/${root_user}/IDBS/EWB/EWBServer/wildfly/standalone/configuration/standalone-ewb-ha.xml

Deploy Search LDAP Application Server to AWS Instance
    [Arguments]    ${server_ip}    ${root_user}    ${root_private_key}    ${build_folder}    ${database_ip}    ${database_sid}
    ...    ${model_server_ip}    ${model_server_port}=7777    ${custom_ldap_server_ip}=${EMPTY}    ${min_app_server_memory}=2096    ${max_app_server_memory}=4096    ${perf_log_debug}=${FALSE}
    Wait for SSH Connection    ${server_ip}    ${root_user}    ${root_private_key}
    Run Keyword And Ignore Error    Setup ChemAxon Server - Linux    ${server_ip}    ${root_user}    ${root_private_key}    ${build_folder}    ${database_ip}
    ...    ${database_sid}    ${server_ip}:8443
    Setup Search LDAP Application Server - Linux    ${server_ip}    ${root_user}    ${root_private_key}    ${build_folder}    ${database_ip}    ${database_sid}
    ...    ${model_server_ip}    model_server_port=${model_server_port}    custom_ldap_server_ip=${custom_ldap_server_ip}    min_memory=${min_app_server_memory}    max_memory=${max_app_server_memory}
    Run Keyword If    ${perf_log_debug}    Set App Server Performance Logging    ${server_ip}    ${root_user}    ${root_private_key}
    Enable Landscape Auditing    ${server_ip}    ${root_user}    ${root_private_key}
    Add Custom Record Widgets To Application Server - Linux    ${server_ip}    ${root_user}    ${root_private_key}
    Apply Business Rules Configuration - Linux    ${server_ip}    ${root_user}    ${root_private_key}

Patch Application Server
    [Arguments]    ${root_user}    ${build_folder}    ${stack_name}
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$
    SSHLibrary.Put Directory    ${build_folder}${/}CD Image${/}IDBS E-WorkBook (Server)${/}Linux    /home/${root_user}/ewb_upgrade    recursive=True
    SSHLibrary.Write    cp -a -f /home/${root_user}/ewb_upgrade/. /home/${root_user}/IDBS/EWB
    sleep    20
    ${output}=    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    PID=`ps -ef | grep ewb | awk '{ print $2 }'`
    SSHLibrary.Write    kill -9 $PID    # I tried to be nice, honest. But it wasn't playing ball.
    ${output}=    SSHLibrary.Read Until Prompt
    sleep    20
    SSHLibrary.Write    chmod -R 777 /home/${root_user}/IDBS/EWB/
    ${output}=    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    cd /home/${root_user}/IDBS/EWB
    ${output}=    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    ./patchServer.sh
    ${output}=    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    sed -i "s|https://.*.idbs-dev.com|https://${PATCH_NAME}.idbs-dev.com|" /home/${root_user}/IDBS/EWB/EWBServer/wildfly/standalone/deployments/ewb-web-application.war/WEB-INF/web.xml
    ${output}=    SSHLibrary.Read Until Prompt

Patch Database 10.2.0.2
    [Arguments]    ${root_user}    ${build_folder}
    #copy over database upgrade folder
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$
    SSHLibrary.Put Directory    ${build_folder}${/}CD Image${/}Database    /home/${root_user}/ewb_database_upgrade    mode=755    recursive=True
    ${output}=    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    chmod -R 777 /home/${root_user}/ewb_database_upgrade
    ${output}=    SSHLibrary.Read Until Prompt
    #configure upgrade.sql
    SSHLibrary.Get File    /home/${root_user}/ewb_database_upgrade/patch.sql    ${OUTPUTDIR}/patch.sql
    Replace Regexp In File    ${OUTPUTDIR}/patch.sql    ORCL    ORA12C
    SSHLibrary.Put File    ${OUTPUTDIR}/patch.sql    /home/${root_user}/ewb_database_upgrade/patch.sql
    #run upgrade
    SSHLibrary.Write    sudo su - oracle
    Sleep    5
    SSHLibrary.Write    cd /home/${root_user}/ewb_database_upgrade
    SSHLibrary.Write    sqlplus EWB_DATABASE_USER EWB_DATABASE_USER $ORACLE_SID
    SSHLibrary.Write    @patch.sql
    Sleep    60
    SSHLibrary.Write    exit

Patch Spreadsheet Server
    [Arguments]    ${root_user}    ${build_folder}
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$
    SSHLibrary.Put Directory    ${build_folder}${/}CD Image${/}IDBS Spreadsheet Server (Unix Server)    /home/${root_user}/ewb_upgrade    recursive=True
    ${output}=    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    /home/${root_user}/IDBS/SpreadsheetServer/stopserver.sh
    ${output}=    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    rm -R -f /home/${root_user}/IDBS/SpreadsheetServer
    ${output}=    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    mkdir /home/${root_user}/IDBS/SpreadsheetServer
    ${output}=    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    cp -a -f /home/${root_user}/ewb_upgrade/. /home/${root_user}/IDBS/SpreadsheetServer
    ${output}=    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    chmod -R 777 /home/${root_user}/IDBS/SpreadsheetServer
    ${output}=    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    tar xvzf /home/${root_user}/IDBS/SpreadsheetServer/SpreadsheetServer.tar.gz -C /home/${root_user}/IDBS/SpreadsheetServer
    ${output}=    SSHLibrary.Read Until Prompt
    sleep    60
    SSHLibrary.Get File    /home/${root_user}/IDBS/SpreadsheetServer/startup.sh    ${OUTPUTDIR}/startup.sh
    Replace Regexp In File    ${OUTPUTDIR}/startup.sh    Xvfb :0    Xvfb :7
    Replace Regexp In File    ${OUTPUTDIR}/startup.sh    DISPLAY=:0    DISPLAY=:7
    SSHLibrary.Put File    ${OUTPUTDIR}/startup.sh    /home/${root_user}/IDBS/SpreadsheetServer/startup.sh
    ${output}=    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    /home/${root_user}/IDBS/SpreadsheetServer/startup.sh
    ${output}=    SSHLibrary.Read Until Prompt

Set Linux Spreadsheet Server Performance Logging
    [Arguments]    ${server}    ${user}    ${key_file}    ${port}=22
    SSH Connect with private key    ${server}    ${user}    ${key_file}    ${port}
    ${output}=    SSHLibrary.Execute Command    cd /home/ec2-user/IDBS/EWB/SpreadsheetServer/ewb-ss-modelserver-war/WEB-INF/classes && sed 's/logger.performance=OFF/logger.performance=DEBUG/' <log4j.properties >temp.xml && mv temp.xml log4j.properties
    log    ${output}
    SSHLibrary.Close Connection

Restart Linux Spreadsheet Server
    [Arguments]    ${server}    ${user}    ${private_key}    ${port}=22
    [Documentation]    Restarts a Linux Spreadsheet Server.
    SSH Connect with private key    ${server}    ${user}    ${private_key}    ${port}
    Execute Command    sudo su -
    SSHLibrary.Write    export PS1="DONE$"    #set prompt
    SSHLibrary.Set Client Configuration    prompt=DONE$
    Write    cd /home/ec2-user/IDBS/SpreadsheetServer && ./stopserver.sh
    ${timed_out}=    Run Keyword and Return Status    Wait Until Keyword Succeeds    30s    5s    Read Until Prompt
    Run Keyword If    ${timed_out}    Set Test Message    Stop script timed out. This may indicate that the spreadsheet server failed to start.
    Write    nohup ./startserver.sh 2>&1 > logs/server.log &
    ${timed_out}=    Run Keyword and Return Status    Wait Until Keyword Succeeds    30s    5s    Read Until Prompt
    Run Keyword If    ${timed_out}    Set Test Message    Restart script timed out. This may indicate that the spreadsheet server failed to start.
    SSHLibrary.Close Connection

Check App Server Is Running
    [Arguments]    ${console_path}=/home/ec2-user/IDBS/EWB/EWBServer/wildfly/standalone/log/console.log
    [Documentation]    Assumes an open ssh connection
    ${rc}=    SSHLibrary.Execute Command    grep -i 'started in' ${console_path}    return_stdout=${False}    return_stderr=${False}    return_rc=${True}
    Should Be Equal As Integers    ${rc}    0    Aplication server hasn't started correctly yet.

Set Echopolicy
    [Arguments]    ${server}    ${user}    ${private_key}    ${ssh_port}=22
    Wait Until Keyword Succeeds    10 min    15s    aws_environment_resource.SSH Connect with private key    ${server}    ${root_user}    ${private_key_file}
    ...    ssh_port=${ssh_port}
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$
    @{files}=    SSHLibrary.List Files In Directory    /home/${root_user}/IDBS/EWB/EWBServer/wildfly/standalone/deployments/landscape-ear.ear
    ${war_file_name}=    Set Variable    @{files}[0]
    ${uuid}=    Create Hex GUID
    SSHLibrary.Get File    /home/${root_user}/IDBS/EWB/EWBServer/wildfly/standalone/deployments/landscape-ear.ear/${war_file_name}    ${TEMPDIR}${/}${uuid}_${war_file_name}
    Log    E-WorkBook war file is ${war_file_name}
    Wait Until Keyword Succeeds    60s    5s    Extract Zipped Archive To Folder    ${TEMPDIR}\\${uuid}_${war_file_name}    ${TEMPDIR}\\${uuid}_extracted_landscape
    FileLibrary.Delete File    ${TEMPDIR}\\${uuid}_${war_file_name}
    Replace Regexp In File    ${TEMPDIR}\\${uuid}_extracted_landscape\\WEB-INF\\classes\\META-INF\\data-landscape.xml    <value type="java.lang.Boolean">false<\/value>    <value type="java.lang.Boolean">true<\/value>
    FileLibrary.Zip Directory To Archive    ${TEMPDIR}\\${uuid}_extracted_landscape    ${TEMPDIR}\\${uuid}_${war_file_name}    ${False}
    SSHLibrary.Put File    ${TEMPDIR}\\${uuid}_${war_file_name}    /home/${root_user}/IDBS/EWB/EWBServer/wildfly/standalone/deployments/landscape-ear.ear/${war_file_name}
    SSHLibrary.Close Connection
    Remove Directory    ${TEMPDIR}\\${uuid}_extracted_landscape    recursive=True
    FileLibrary.Delete File    ${TEMPDIR}\\${uuid}_${war_file_name}
