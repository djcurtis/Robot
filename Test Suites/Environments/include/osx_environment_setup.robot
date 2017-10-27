*** Settings ***
Library           CheckLibrary
Library           SSHLibrary
Library           String
Library           ServerControlLibrary
Library           FileLibrary

*** Variables ***
${PYPI_SERVER}    https://pypi.idbs.co.uk/automation/simple

*** Keywords ***
Check OSX Client Responsive
    [Arguments]    ${machine_name}    ${osx_version}    ${username}=automation    ${password}=automation
    SSHLibrary.Open Connection    ${machine_name}    prompt=$    width=240    height=240    timeout=30s
    SSHLibrary.Login    ${username}    ${password}
    ${output}=    SSHLibrary.Execute Command    sw_vers -productVersion
    Should Contain    ${output}    ${osx_version}
    [Teardown]    SSHLibrary.Close All Connections

Clean up OSX Client
    [Arguments]    ${osx_client}    ${osx_version}    ${username}=automation    ${password}=automation
    [Documentation]    Cleans up the OSX machines, restarts the machine and ensures the Mac clients are responsive and fatally fails if not
    ${status}    ${value}=    Run Keyword And Ignore Error    Wait Until Keyword Succeeds    180s    5s    Check OSX Client Responsive
    ...    ${osx_client}    ${osx_version}    ${username}    ${password}
    Run Keyword If    '${status}'=='FAIL'    Fatal Error    OSX Client '${osx_client}' is unresponsive. Execution stopped.
    #Delete any pre-existing virtual environments
    SSHLibrary.Open Connection    ${osx_client}    prompt=$    width=240    height=240    timeout=30s
    SSHLibrary.Login    ${username}    ${password}
    Sleep    5s
    SSHLibrary.Write    sudo rm -r /Users/${username}/.virtualenvs/*
    SSHLibrary.Write    ${username}
    ${passed}=    Run Keyword And Return Status    SSHLibrary.Read Until Prompt
    Run Keyword Unless    ${passed}    SSHLibrary.Write    ${password}    # some OSX clients do not receive \ the password from stdin correctly
    Run Keyword Unless    ${passed}    SSHLibrary.Read Until Prompt
    #Remove any previous Spreadsheet designer installs
    SSHLibrary.Write    sudo rm -r "/Applications/Spreadsheet Designer.app/Contents"
    SSHLibrary.Read Until Prompt
    #Empty automated test results folder
    SSHLibrary.Write    sudo rm -r /Automated_Test_Results/*
    SSHLibrary.Read Until Prompt
    #Restart client
    SSHLibrary.Write    sudo shutdown -r now
    Run Keyword And Ignore Error    SSHLibrary.Read Until Prompt    #shutdown command may not return prompt
    Sleep    60s
    ${status}    ${value}=    Run Keyword And Ignore Error    Wait Until Keyword Succeeds    180s    5s    Check OSX Client Responsive
    ...    ${osx_client}    ${osx_version}    ${username}    ${password}
    Run Keyword If    '${status}'=='FAIL'    Fatal Error    OSX Client '${osx_client}' is unresponsive. Execution stopped.

Start Standalone WebDriver Server OSX
    [Arguments]    ${machine_name}    ${auto_env}
    SSHLibrary.Open Connection    ${machine_name}    prompt=$    width=240    height=240
    SSHLibrary.Login    automation    automation
    SSHLibrary.Write    nohup java -jar /Users/automation/.virtualenvs/${auto_env}/lib/python2.7/site-packages/IDBSSelenium2Library/standalone_server/selenium-standalone-2.41.0-IDBS.jar &
    SSHLibrary.Write    exit
    SSHLibrary.Read Until Prompt
    [Teardown]    SSHLibrary.Close All Connections

Boot OSX Clients
    [Arguments]    ${osx_version}    ${10_8_machines}    ${10_9_machines}    ${10_10_machines}    ${10_11_machines}    ${username}=automation
    ...    ${password}=automation
    #check correct machine status - will fail if one of the machines is not on
    ${10_8_status}=    Run Keyword And Return Status    __ensure_osx_machines_on    ${10_8_machines}    10.8    ${username}    ${password}
    ${10_9_status}=    Run Keyword And Return Status    __ensure_osx_machines_on    ${10_9_machines}    10.9    ${username}    ${password}
    ${10_10_status}=    Run Keyword And Return Status    __ensure_osx_machines_on    ${10_10_machines}    10.10    ${username}    ${password}
    ${10_11_status}=    Run Keyword And Return Status    __ensure_osx_machines_on    ${10_11_machines}    10.11    ${username}    ${password}
    #return if the correct machines are already on
    Return From Keyword If    '${osx_version}'=='10.8' and ${10_8_status}
    Return From Keyword If    '${osx_version}'=='10.9' and ${10_9_status}
    Return From Keyword If    '${osx_version}'=='10.10' and ${10_10_status}
    Return From Keyword If    '${osx_version}'=='10.11' and ${10_11_status}
    #switch machines as applicable
    Run Keyword If    ${10_8_status}    __switch_osx_machines    ${10_8_machines}    ${osx_version}    10.8    ${username}
    ...    ${password}
    Run Keyword If    ${10_9_status}    __switch_osx_machines    ${10_9_machines}    ${osx_version}    10.9    ${username}
    ...    ${password}
    Run Keyword If    ${10_10_status}    __switch_osx_machines    ${10_10_machines}    ${osx_version}    10.10    ${username}
    ...    ${password}
    Run Keyword If    ${10_11_status}    __switch_osx_machines    ${10_11_machines}    ${osx_version}    10.11    ${username}
    ...    ${password}
    #wait for OSX clients to be responsive since the correct machines should now be on
    Run Keyword If    '${osx_version}'=='10.8'    Wait Until Keyword Succeeds    180s    5s    __ensure_osx_machines_on    ${10_8_machines}
    ...    10.8    ${username}    ${password}
    Run Keyword If    '${osx_version}'=='10.9'    Wait Until Keyword Succeeds    180s    5s    __ensure_osx_machines_on    ${10_9_machines}
    ...    10.9    ${username}    ${password}
    Run Keyword If    '${osx_version}'=='10.10'    Wait Until Keyword Succeeds    180s    5s    __ensure_osx_machines_on    ${10_10_machines}
    ...    10.10    ${username}    ${password}
    Run Keyword If    '${osx_version}'=='10.11'    Wait Until Keyword Succeeds    180s    5s    __ensure_osx_machines_on    ${10_11_machines}
    ...    10.11    ${username}    ${password}

__switch_osx_machines
    [Arguments]    ${machine_list}    ${osx_version}    ${current_osx_version}    ${username}=automation    ${password}=automation
    : FOR    ${machine}    IN    @{machine_list}
    \    Run Keyword And Ignore Error    __switch_osx_machine_partition    ${machine}    ${osx_version}    ${current_osx_version}    ${username}
    \    ...    ${password}

__switch_osx_machine_partition
    [Arguments]    ${machine_name}    ${osx_version}    ${current_osx_version}    ${username}=automation    ${password}=automation
    ${partition_script}=    Set Variable If    '${osx_version}'=='10.8'    /Users/${username}/reboot_scripts/reboot_to_mountain_lion.scpt
    ${partition_script}=    Set Variable If    '${osx_version}'=='10.9'    /Users/${username}/reboot_scripts/reboot_to_mavericks.scpt
    ${partition_script}=    Set Variable If    '${osx_version}'=='10.10'    /Users/${username}/reboot_scripts/reboot_to_yosemite.scpt    ${partition_script}
    Check OSX Client Responsive    ${machine_name}    ${current_osx_version}
    SSHLibrary.Open Connection    ${machine_name}    prompt=$    width=240    height=240
    SSHLibrary.Login    ${username}    ${password}
    Comment    SSHLibrary.Write    ls /Volumes
    Comment    ${output}=    SSHLibrary.Read Until Prompt
    Comment    ${status}=    Run Keyword And Return Status    Check String Contains    Checking that the partition is present on the OSX machine    ${output}    ${partition_name}
    Comment    Run Keyword If    ${status} is ${False}    Fail    machine did not contain the relevant boot partition
    #set the boot partition to the correct volume and restart
    SSHLibrary.Write    osascript ${partition_script}
    Sleep    60s

__ensure_osx_machines_on
    [Arguments]    ${machines}    ${osx_version}    ${username}=automation    ${password}=automation
    : FOR    ${machine}    IN    @{machines}
    \    Check OSX Client Responsive    ${machine}    ${osx_version}    ${username}    ${password}

__Setup OSX Client
    [Arguments]    ${machine_name}    ${auto_env}    ${spreadsheet_designer_installation_directory}=${EMPTY}    ${username}=automation    ${password}=automation
    [Documentation]    Configures the OSX clients for automation testing and installs the necessary libraries.
    ...
    ...
    ...    Arguments:
    ...
    ...
    ...
    ...    ${machine_name} - The name of the client machine.
    ...
    ...    ${auto_env} - The environment folder on the client machine.
    ...
    ...    ${installation_directory} - The EWB installation directory.
    ...
    ...
    ...    ${username} - The username to log onto the machine. This should also be the name of the user on the OSX system.
    ...
    ...
    ...    ${password} - The password to log onto the machine.
    ...
    ...
    ...    Resturn Values:
    ...
    ...    ${slave_pid}
    SSHLibrary.Open Connection    ${machine_name}    prompt=$    width=240    height=240    timeout=1800
    SSHLibrary.Login    ${username}    ${password}
    #create virtual environment on Mac
    SSHLibrary.Write    mkvirtualenv ${auto_env}
    SSHLibrary.Read Until Prompt
    #install cx_Oracle into virtual env
    SSHLibrary.Write    cd /Users/${username}/cx_oracle/cx_Oracle-5.1.1/
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    /Users/${username}/.virtualenvs/${auto_env}/bin/python setup.py build
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    /Users/${username}/.virtualenvs/${auto_env}/bin/python setup.py install
    SSHLibrary.Read Until Prompt
    #install test libs into virtualenv
    SSHLibrary.Execute Command    /Users/${username}/.virtualenvs/${auto_env}/bin/pip install --upgrade pip -i ${PYPI_SERVER}
    SSHLibrary.Execute Command    /Users/${username}/.virtualenvs/${auto_env}/bin/pip install --upgrade IDBS-Automation-Core -i ${PYPI_SERVER}
    SSHLibrary.Execute Command    /Users/${username}/.virtualenvs/${auto_env}/bin/pip install --upgrade robotframework-IDBS-Selenium2Library -i ${PYPI_SERVER}
    SSHLibrary.Execute Command    /Users/${username}/.virtualenvs/${auto_env}/bin/pip install --upgrade robotframework-IDBS-httplibrary -i ${PYPI_SERVER}
    SSHLibrary.Execute Command    /Users/${username}/.virtualenvs/${auto_env}/bin/pip install --upgrade robotframework-xmllibrary -i ${PYPI_SERVER}
    SSHLibrary.Execute Command    /Users/${username}/.virtualenvs/${auto_env}/bin/pip install --upgrade robotframework-imagelibrary -i ${PYPI_SERVER}
    SSHLibrary.Execute Command    /Users/${username}/.virtualenvs/${auto_env}/bin/pip install --upgrade robotframework-oraclelibrary -i ${PYPI_SERVER}
    SSHLibrary.Execute Command    /Users/${username}/.virtualenvs/${auto_env}/bin/pip install --upgrade robotframework-checkpdflibrary -i ${PYPI_SERVER}
    SSHLibrary.Execute Command    /Users/${username}/.virtualenvs/${auto_env}/bin/pip install --upgrade robotframework-RobotRemoteAgent -i ${PYPI_SERVER}/
    SSHLibrary.Execute Command    /Users/${username}/.virtualenvs/${auto_env}/bin/pip install --upgrade robotframework-IDBSSwingLibrary -i ${PYPI_SERVER}/
    SSHLibrary.Execute Command    /Users/${username}/.virtualenvs/${auto_env}/bin/pip install --upgrade robotframework-systemutilitieslibrary -i ${PYPI_SERVER}/
    SSHLibrary.Execute Command    /Users/${username}/.virtualenvs/${auto_env}/bin/pip install --upgrade robotframework-QuantrixLibrary -i ${PYPI_SERVER}/
    SSHLibrary.Execute Command    /Users/${username}/.virtualenvs/${auto_env}/bin/pip install --upgrade robotframework-DynamicJavaLibrary -i ${PYPI_SERVER}/
    SSHLibrary.Execute Command    /Users/${username}/.virtualenvs/${auto_env}/bin/pip install --upgrade robotframework-IDBSCustomSwingComponentLibrary -i ${PYPI_SERVER}/
    SSHLibrary.Execute Command    /Users/${username}/.virtualenvs/${auto_env}/bin/pip install --upgrade boto3 -i ${PYPI_SERVER}/
    SSHLibrary.Execute Command    /Users/${username}/.virtualenvs/${auto_env}/bin/pip install --upgrade EntityAPILibrary -i ${PYPI_SERVER}
    SSHLibrary.Execute Command    /Users/${username}/.virtualenvs/${auto_env}/bin/pip install --upgrade SecurityAPILibrary -i ${PYPI_SERVER}
    SSHLibrary.Execute Command    /Users/${username}/.virtualenvs/${auto_env}/bin/pip install --upgrade robotframework-jsonlibrary -i ${PYPI_SERVER}
    SSHLibrary.Execute Command    /Users/${username}/.virtualenvs/${auto_env}/bin/pip install --upgrade robotframework-Timinglibrary -i ${PYPI_SERVER}
    SSHLibrary.Execute Command    /Users/${username}/.virtualenvs/${auto_env}/bin/pip install pymongo==2.8    # Only Inventory should need this. Move this out into an Inventory only wrapper.
    #install reporting listener
    SSHLibrary.Execute Command    /Users/${username}/.virtualenvs/${auto_env}/bin/pip install --upgrade wheel -i ${PYPI_SERVER}
    SSHLibrary.Execute Command    /Users/${username}/.virtualenvs/${auto_env}/bin/pip install --upgrade robotframework-clientListener -i ${PYPI_SERVER}
    SSHLibrary.Write    /Users/${username}/.virtualenvs/${auto_env}/bin/pip install --upgrade psutil -i ${PYPI_SERVER}
    SSHLibrary.Read Until Prompt
    #install Spreadsheet designer
    Run Keyword If    '${spreadsheet_designer_installation_directory}' != '${EMPTY}'    Install Spreadsheet Designer    ${spreadsheet_designer_installation_directory}
    #launch test slave
    SSHLibrary.Write    svn checkout "http://20development2/svn/testing-qa/trunk/Robot Framework Tools/TestMachineSlave" "/Users/${username}/.virtualenvs/${auto_env}/TestMachineSlave" --password F1rEf0xTD72
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    export AWS_ACCESS_KEY_ID=AKIAIXVA2AKAAVS52QAA
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    export AWS_SECRET_ACCESS_KEY=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
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    export AWS_DEFAULT_REGION=eu-west-1
    SSHLibrary.Read Until Prompt
    SSHLibrary.Write    nohup /Users/${username}/.virtualenvs/${auto_env}/bin/python /Users/${username}/.virtualenvs/${auto_env}/TestMachineSlave/TestMachineSlave.py &
    ${output}=    SSHLibrary.Read Until Prompt
    @{output_parts}=    Split String    ${output}    ${SPACE}    3
    ${slave_pid}=    Set Variable    @{output_parts}[1]
    #Remove launched file from robotremoteagent folder - file gets created when the Selenium standalone server starts
    SSHLibrary.Write    rm /Users/${username}/.robotframework/robotremoteagent/launched.txt
    SSHLibrary.Read Until Prompt
    Wait For Machine    ${machine_name}
    [Teardown]    SSHLibrary.Close All Connections
    [Return]    ${slave_pid}

Get Test Assets From Git OSX
    [Arguments]    ${target_machine_ip}    ${git_repository_url}    ${automation_subdirectory}    ${output_location}    ${branch}=master
    [Documentation]    Gets test assets from a Git repository onto a remote machine.
    ...
    ...    *Arguments*
    ...    - _target_machine_ip_ - the machine IP address or network name to download the test assets onto
    ...    - _git_repository_url_ - the URL of the git repository, including username and password credentials
    ...    - _automation_subdirectory_ - the path to the subdirectory containing the tests in the form dir1/dir2/ (note that forward slashes are used and the path must include the trailing slash)
    ...    - _output_location_ - the output location for the tests (the automation subdirectory will be below this)
    ...    - _branch_ - the branch to download from within the repository. Defaults to master
    ...
    ...    *Return Value*
    ...
    ...    The path to the downloaded automation directory (no trailing slash)
    ...
    ...    *Example*
    ...    | ${checkout_dir}= | Get Test Assets From Git | http://test:test@vpc-asset01:7990/scm/gn/main.git | Automation/ | C:/Automated Tests |
    ...
    ...    The output from this example is:
    ...    ${checkout_dir} = C:/Automated Tests/Automation
    Run Command On Machine    ${target_machine_ip}    git init ${output_location}
    Run Command On Machine    ${target_machine_ip}    git --git-dir=${output_location}/.git --work-tree=${output_location} config core.sparseCheckout true
    Run Command On Machine    ${target_machine_ip}    git --git-dir=${output_location}/.git --work-tree=${output_location} remote add -f origin ${git_repository_url}
    Run Command On Machine    ${target_machine_ip}    echo ${automation_subdirectory} > ${output_location}/.git/info/sparse-checkout
    Run Command On Machine    ${target_machine_ip}    git --git-dir=${output_location}/.git --work-tree=${output_location} checkout master
    ${return_folder}=    Catenate    SEPARATOR=/    ${output_location}    ${automation_subdirectory}
    ${return_folder}=    Evaluate    '${return_folder}'[:-1]
    [Return]    ${return_folder}

Clean Up OSX Clients and Ensure Responsive
    [Arguments]    ${osx_version}    ${client_username}    ${client_password}
    [Documentation]    Description:
    ...
    ...    This keyword cleans up the OSX clients by removing any virtual environments and tests that were set up by previous runs.
    ...
    ...
    ...    *Note: Should be run before the client setup keyword.*
    ...
    ...
    ...
    ...    Arguments:
    ...
    ...    ${osx_version} - The version of OSX that is required for the client machine.
    ...
    ...    ${client_username} - The username required to log into the client VM.
    ...
    ...    ${client_machine} - The password required to log into the client VM.
    ...
    ...
    ...
    ...    Return Values:
    ...
    ...    None
    ...
    ...
    ...
    ...    *Note: Should be run before the client setup keyword.*
    #set machines based on OSX_VERSION
    @{10_11_machines}=    Create List    southkenton2
    @{10_10_machines}=    Create List    AUTO-YM-1
    @{10_9_machines}=    Create List    southfields    canarywharf    southkenton
    @{10_8_machines}=    Create List    charingcross
    @{WEB_CLIENT_MACHINES}=    Set Variable If    '${osx_version}'=='10.9'    ${10_9_machines}    ${10_8_machines}
    @{WEB_CLIENT_MACHINES}=    Set Variable If    '${osx_version}'=='10.10'    ${10_10_machines}    ${WEB_CLIENT_MACHINES}
    @{WEB_CLIENT_MACHINES}=    Set Variable If    '${osx_version}'=='10.11'    ${10_11_machines}    ${WEB_CLIENT_MACHINES}
    Set Global Variable    @{WEB_CLIENT_MACHINES}
    ${10_8_metadata}=    Set Variable    Safari 6.1
    ${10_9_metadata}=    Set Variable    Safari 7.0
    ${10_10_metadata}=    Set Variable    Safari 8.0
    ${10_11_metadata}=    Set Variable    Safari 9.0
    ${BROWSER_METADATA}=    Set Variable If    '${osx_version}'=='10.9'    ${10_9_metadata}    ${10_8_metadata}
    ${BROWSER_METADATA}=    Set Variable If    '${osx_version}'=='10.10'    ${10_10_metadata}    ${BROWSER_METADATA}
    ${BROWSER_METADATA}=    Set Variable If    '${osx_version}'=='10.11'    ${10_11_metadata}    ${BROWSER_METADATA}
    Set Global Variable    ${BROWSER_METADATA}
    Boot OSX Clients    ${osx_version}    ${10_8_machines}    ${10_9_machines}    ${10_10_machines}    ${10_11_machines}    ${client_username}
    ...    ${client_password}
    #cleanup machines
    : FOR    ${osx_client}    IN    @{WEB_CLIENT_MACHINES}
    \    Clean up OSX Client    ${osx_client}    ${osx_version}    ${client_username}    ${client_password}

Install Spreadsheet Designer
    [Arguments]    ${installation_directory}
    [Documentation]    Description:
    ...
    ...    Installs the spreadsheet designer.
    ...
    ...
    ...
    ...    Arguments:
    ...
    ...    - ${installation directory} - The location to get the spreadsheet installer from.
    ...
    ...
    ...
    ...    Example:
    ...
    ...    | Install Spreadsheet Designer | \\20resource1\Temp Build\E-WorkBook\10.2.0\Build 107 |
    ${UID}=    Get Time    epoch
    Extract Zipped Archive To Folder    ${installation_directory}/IDBS Spreadsheet Designer/IDBS Spreadsheet Designer OS X.zip    ${TEMPDIR}/${UID}
    SSHLibrary.Put Directory    ${TEMPDIR}/${UID}/Spreadsheet Designer.app/Contents    /Applications/Spreadsheet Designer.app/Contents    0755    recursive=${True}
