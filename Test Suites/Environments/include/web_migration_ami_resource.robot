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
${EWB_AMI_VERSION}    ${versionNumber} Build ${buildNumber}
${BASELINE_EWB_DATABASE_SERVER}    E-WorkBook ${EWB_AMI_VERSION} Database Server
${BASELINE_EWB_MODEL_SERVER}    E-WorkBook ${EWB_AMI_VERSION} Model Server
${BASELINE_EWB_APPLICATION_SERVER}    E-WorkBook ${EWB_AMI_VERSION} Application Server

*** Keywords ***
Set AMI ids
    Run Keyword If    '${baselineVersion}'=='none'    Use Blank AMIs    #no IDBS products installed
    Run Keyword If    '${baselineVersion}'=='10.1.2'    Use 10.1.2 AMIs    #10.1.2
    Run Keyword If    '${baselineVersion}'=='10.1.3'    Use 10.1.3 AMIs    #10.1.3
    Run Keyword If    '${baselineVersion}'=='10.2.0'    Use 10.2.0 AMIs    #10.2.0
    Run Keyword If    '${baselineVersion}'=='10.2.0.1'    Use 10.2.0.1 AMIs    #10.2.0.1
    Run Keyword If    '${baselineVersion}'=='10.2.0.2'    Use 10.2.0.2 AMIs    #10.2.0.2
    Run Keyword If    '${baselineVersion}'=='10.2.1'    Get AMI ids    ${EWB_AMI_VERSION}


Use Blank AMIs
    Set Suite Variable    ${BASELINE_EWB_DATABASE_SERVER_AMI_ID}    ami-67591814
    Set Suite Variable    ${BASELINE_EWB_MODEL_SERVER_AMI_ID}    ami-11fcd666
    Set Suite Variable    ${BASELINE_EWB_APPLICATION_SERVER_AMI_ID}    ami-11fcd666

Use 10.1.2 AMIs
    Set Suite Variable    ${BASELINE_EWB_DATABASE_SERVER_AMI_ID}    ami-34bc8852
    Set Suite Variable    ${BASELINE_EWB_MODEL_SERVER_AMI_ID}    ami-94cc57e7    # Windows only!
    Set Suite Variable    ${BASELINE_EWB_APPLICATION_SERVER_AMI_ID}    ami-29c05b5a

Use 10.1.3 AMIs
    Set Suite Variable    ${BASELINE_EWB_DATABASE_SERVER_AMI_ID}    ami-fea69298
    Set Suite Variable    ${BASELINE_EWB_MODEL_SERVER_AMI_ID}    ami-9cd394ef
    Set Suite Variable    ${BASELINE_EWB_APPLICATION_SERVER_AMI_ID}    ami-69d4931a

Use 10.2.0 AMIs
    Set Suite Variable    ${BASELINE_EWB_DATABASE_SERVER_AMI_ID}    ami-6e32141d
    Set Suite Variable    ${BASELINE_EWB_MODEL_SERVER_AMI_ID}    ami-6933151a
    Set Suite Variable    ${BASELINE_EWB_APPLICATION_SERVER_AMI_ID}    ami-a43e18d7

Use 10.2.0.1 AMIs
    Set Suite Variable    ${BASELINE_EWB_DATABASE_SERVER_AMI_ID}    ami-6e32141d    #10.2.0 - no db upgrade for 10.2.0.1
    Set Suite Variable    ${BASELINE_EWB_MODEL_SERVER_AMI_ID}    ami-2c21064a
    Set Suite Variable    ${BASELINE_EWB_APPLICATION_SERVER_AMI_ID}    ami-6924030f

Use 10.2.0.2 AMIs
    Set Suite Variable    ${BASELINE_EWB_DATABASE_SERVER_AMI_ID}    ami-b984a4df
    Set Suite Variable    ${BASELINE_EWB_MODEL_SERVER_AMI_ID}    ami-2c21064a
    Set Suite Variable    ${BASELINE_EWB_APPLICATION_SERVER_AMI_ID}    ami-4cbf9f2a

Get AMI ids
    [Arguments]    ${EWB_AMI_VERSION}
    ${BASELINE_EWB_DATABASE_SERVER_AMI_ID}=    Wait Until Keyword Succeeds    30 min    30s    Get AMI ID    ${BASELINE_EWB_DATABASE_SERVER}    owner_id=796568017366
    ${BASELINE_EWB_APPLICATION_SERVER_AMI_ID}=    Wait Until Keyword Succeeds    30 min    30s    Get AMI ID    ${BASELINE_EWB_APPLICATION_SERVER}    owner_id=796568017366
    ${BASELINE_EWB_MODEL_SERVER_AMI_ID}=    Wait Until Keyword Succeeds    30 min    30s    Get AMI ID    ${BASELINE_EWB_MODEL_SERVER}    owner_id=796568017366
    set suite variable    ${BASELINE_EWB_DATABASE_SERVER_AMI_ID}
    set suite variable    ${BASELINE_EWB_APPLICATION_SERVER_AMI_ID}
    set suite variable    ${BASELINE_EWB_MODEL_SERVER_AMI_ID}

Patch Application Server
    [Arguments]    ${root_user}    ${build_folder}
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$
    SSHLibrary.Put Directory    ${build_folder}${/}CD Image${/}IDBS E-WorkBook (Server)${/}Linux    /home/${root_user}/ewb_upgrade    recursive=True
    ${output}=    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    cp -a -f /home/${root_user}/ewb_upgrade/Linux/. /home/${root_user}/IDBS/EWB
    sleep    20
    ${output}=    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    PID=`ps -ef | grep ewb | awk '{ print $2 }'`
    ${output}=    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    kill -9 $PID    # I tried to be nice, honest. But it wasn't playing ball.
    ${output}=    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    chmod -R 777 /home/${root_user}/IDBS/EWB/
    ${output}=    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    cd /home/${root_user}/IDBS/EWB
    ${output}=    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    ./patchServer.sh
    ${output}=    SSHLibrary.Read Until Prompt
    #SSHLibrary.Write    sed -i "s|https://.*.idbs-dev.com|https://${PATCH_NAME}.idbs-dev.com|" /home/${root_user}/IDBS/EWB/EWBServer/wildfly/standalone/deployments/ewb-web-application.war/WEB-INF/web.xml
    #${output}=    SSHLibrary.Read Until Prompt
    #will need the above line at some point so leaving it in for now as a comment

Patch Database Standard
    [Arguments]    ${root_user}    ${build_folder}
    #copy over database upgrade folder
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$
    SSHLibrary.Put Directory    ${build_folder}${/}CD Image${/}Database    /home/${root_user}/database_patch    mode=755    recursive=True
    ${output}=    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    chmod -R 777 /home/${root_user}/database_patch
    ${output}=    SSHLibrary.Read Until Prompt
    #configure upgrade.sql
    SSHLibrary.Get File    /home/${root_user}/database_patch/patch.sql    ${OUTPUTDIR}/${run_id}/patch.sql
    Replace Regexp In File    ${OUTPUTDIR}/${run_id}/patch.sql    ORCL    ORA12C
    SSHLibrary.Put File    ${OUTPUTDIR}/${run_id}/patch.sql    /home/${root_user}/database_patch/patch.sql
    Remove Directory    ${OUTPUTDIR}/${run_id}    recursive=True
    SSHLibrary.Write    sudo cp -R -f /home/${root_user}/database_patch/ /u01/database_patch/
    #run upgrade
    ${output}=    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    sudo su - oracle
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$
    SSHLibrary.Write    cd /u01/database_patch
    ${output}=    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    nohup sqlplus EWB_DATABASE_USER/EWB_DATABASE_USER @patch.sql
    ${output}=    SSHLibrary.Read Until Prompt
    log    ${output}
    SSHLibrary.Write    exit    #from sqlplus
    Sleep    20
    SSHLibrary.Write    sudo cp /home/oracle/nohup.out /home/ec2-user/nohup.out
    ${output}=    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    sudo chmod 777 /home/ec2-user/nohup.out
    ${output}=    SSHLibrary.Read Until Prompt

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

Get Instance ID
    [Documentation]    Assumes an open SSH connection.
    ...
    ...    Return value = AWS Instance ID
    ${instance_id}=    SSHLibrary.Execute Command    curl http://169.254.169.254/latest/meta-data/instance-id
    [Return]    ${instance_id}

Check Application Server Is Running
    [Arguments]    ${console_path}=/home/ec2-user/IDBS/EWB/EWBServer/wildfly/standalone/log/console.log
    ${rc}=    SSHLibrary.Execute Command    grep -i 'started in' ${console_path}    return_stdout=${False}    return_stderr=${False}    return_rc=${True}
    Should Be Equal As Integers    ${rc}    0    Aplication server hasn't started correctly yet.

check oracle has started
    Wait Until Keyword Succeeds    10 min    15s    aws_environment_resource.SSH Connect with private key    ${NAT_SERVER}    ${root_user}    ${private_key_file}
    ...    ssh_port=2223
    ${stdout}=    SSHLibrary.Execute Command    ps -ef | grep oracleora12c    return_stdout=${True}    return_stderr=${False}    return_rc=${False}
    log    ${stdout}
    Should Contain    ${stdout}    LOCAL    oracle is not running yet
    SSHLibrary.Close Connection

Restart Application Server
    Wait Until Keyword Succeeds    10 min    15s    aws_environment_resource.SSH Connect with private key    ${NAT_SERVER}    ${root_user}    ${private_key_file}
    ...    ssh_port=2222
    SSHLibrary.Write    PID=`ps -ef | grep ewb | awk '{ print $2 }'`
    SSHLibrary.Write    kill -9 $PID
    sleep    5
    SSHLibrary.Write    /home/${root_user}/IDBS/EWB/EWBServer/bin/eworkbook.sh start
    SSHLibrary.Read Until Prompt
    sleep    120    #sometimes console.log is still present from before
    Wait Until Keyword Succeeds    1200s    15s    Check Application Server is Running
    SSHLibrary.Close Connection

Restart Database Server
    Wait Until Keyword Succeeds    10 min    15s    aws_environment_resource.SSH Connect with private key    ${NAT_SERVER}    ${root_user}    ${private_key_file}
    ...    ssh_port=2223
    SSHLibrary.Write    sudo reboot    #this is to make sure that oracle starts up OK
    SSHLibrary.Close Connection

Abandon Run If Test Fails
    [Documentation]    Stops run execution if a critical test fails.
    Run Keyword If Test Failed    Fatal Error    A fatal error occurred. Abandoning test run.