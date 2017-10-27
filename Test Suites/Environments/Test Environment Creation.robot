*** Settings ***
Library    AWSLibrary
Resource    include/web_migration_ami_resource.txt
Resource    include/aws_environment_resource.txt
Library           AWSLibrary
Resource          include/web_migration_ami_resource.robot
Resource          include/aws_environment_resource.robot

*** Variables ***
${SYSTEM_KEYPAIR}    gps_testing
${private_key_file}    c:/ssh_keys/${SYSTEM_KEYPAIR}.pem
${root_user}      ec2-user
${baselineVersion}    none

*** Test Cases ***
Create AWS Test System
    Set AMI ids
    ${run_id}=    AWSLibrary.Get Run ID
    Set Suite Variable    ${run_id}
    set suite variable    ${stackName}    gps-test-${run_id}
    set suite variable    ${NAT_SERVER}    ${stackName}-nat.idbs-dev.com
    Start Stack Creation    ${stackName}    No_Run_Tags_EWB_Test_System    keypair=${SYSTEM_KEYPAIR}    team=GPS EMEA    product=EWB    AppServerAMI=${BASELINE_EWB_APPLICATION_SERVER_AMI_ID}
    ...    DBServerAMI=${BASELINE_EWB_DATABASE_SERVER_AMI_ID}    ModelServerAMI=${BASELINE_EWB_MODEL_SERVER_AMI_ID}    AppServerInstanceProfile=${EMPTY}
    Wait For Stack Creation Complete    ${stack_name}    600s
    run keyword if    '${baselineVersion}'=='none'    Do nothing    ELSE    Restart Servers
    run keyword if    '${baselineVersion}'=='none'    Set Test Message    Stack '${stackName}' created successfully. No IDBS products are currently installed.    ELSE    set test message    Stack '${stackName}' created successfully. Version of EWB currently installed: EWB ${baselineVersion}, URL: https://${stackName}.idbs-dev.com:8443/EWorkbookWebApp/,
    Set Test Message    NAT address: ${stackName}-nat.idbs-dev.com    append=true
    [Teardown]    Abandon Run If Test Fails

*** Keywords ***
Do Nothing
    Log    No IDBS products are installed, hence not checking app server status.

Restart Servers
    Restart Database Server
    wait until keyword succeeds    1200    60    check oracle has started
    Restart Application Server

Abandon Run If Test Fails
    Run Keyword If Test Failed    Cleanup Run

Cleanup Run
    Start Stack Deletion    ${stack_name}
    Wait For Stack Deletion Complete    ${stack_name}    600s
    AWSLibrary.Terminate All Run Instances
    # delete runs folder and everything within it
    AWSLibrary.Delete From Bucket    idbs-automation    runs/${run_id}
