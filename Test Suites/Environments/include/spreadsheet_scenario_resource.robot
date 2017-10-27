*** Settings ***
Library           WMILibrary
Library           AWSLibrary
Library           SSHLibrary

*** Keywords ***
Copy Designer Logs
    [Arguments]    ${web_client_ips}    ${web_client_ids}    ${desktop_machine_ip}=${EMPTY}
    [Documentation]    Copies spreadsheet designer logs from a list of given client machines.
    ...
    ...    *Arguments*:
    ...
    ...    web_client_ips - list of client ips
    ...
    ...    web_client_ids - list of client instance ids
    ...
    ...    desktop_machine_ip - if used, the ip of the desktop client machine
    # Loop through web machines, get passwords and copy logs if they exist
    ${length}=    Run Keyword If    ${web_client_ips}    Get Length    ${web_client_ips}
    ${length}=    Set Variable If    ${web_client_ips}    ${length}    0    # length should be used except for when there are no items in the list. In this case Get Length returns 'None', so to prevent the for loop from failing with a TypeError, we set length to 0.
    : FOR    ${i}    IN RANGE    ${length}
    \    ${admin_pwd}=    Wait Until Keyword Succeeds    15m    15s    AWSLibrary.Get Windows Administrator Password    @{web_client_ids}[${i}]
    \    ...    C:/stevekp.pem
    \    ${ip}=    Set Variable    @{web_client_ips}[${i}]
    \    Run Keyword And Continue On Failure    Get client machine designer log    @{web_client_ids}[${i}]    @{web_client_ips}[${i}]    Administrator    ${admin_pwd}
    \    ...    # On occasion, the WMI connection to AWS just fails. If this happens, we don't want to stop copying, hence continue on failure.
    # Desktop Machine    (Only runs if the ip is supplied)
    ${desktop_machine_instance_index}=    Run Keyword If    '${desktop_machine_ip}'    Set Variable    ${length}    #Desktop Machine index is also the length of web machines list
    ${admin_pwd}=    Run Keyword If    '${desktop_machine_ip}'    Wait Until Keyword Succeeds    15m    15s    AWSLibrary.Get Windows Administrator Password
    ...    @{web_client_ids}[${desktop_machine_instance_index}]    C:/stevekp.pem
    Run Keyword If    '${desktop_machine_ip}'    Get client machine designer log    @{web_client_ids}[${desktop_machine_instance_index}]    ${desktop_machine_ip}    Administrator    ${admin_pwd}

Get client machine designer log
    [Arguments]    ${client_machine_id}    ${client_machine_ip}    ${admin_user}    ${admin_pwd}
    [Documentation]    Copies the spreadsheet designer log from a given client machine.
    ...
    ...    *Arguments*
    ...
    ...    client_machine_id - instance id of the client machine
    ...
    ...    client_machine_ip - ip of the client machine
    ...
    ...    admin_user - windows user for the client machine
    ...
    ...    admin_pwd - windows password for the client machine
    WMILibrary.Open Connection    ${client_machine_ip}    ${admin_user}    ${admin_pwd}
    ${file_present}=    Run Keyword And Return Status    WMILibrary.Check Directory Exists    C:/Users/Administrator/.ss-weblaunch/log
    Run Keyword Unless    ${file_present}    Log    Designer Log for the desktop client does not exist in the expected default location. Writing a tree of the user's folder to the output directory.
    ${tree}=    Run Keyword Unless    ${file_present}    WMILibrary.Run Remote Command And Return Output    tree C:/Users/Administrator
    Run Keyword Unless    ${file_present}    Log    Full tree for Admin home folder:\n\n${tree}
    Run Keyword If    ${file_present}    WMILibrary.Get Directory    C:/Users/Administrator/.ss-weblaunch/log    ${OUTPUT DIR}/Designer Logs for ${client_machine_id} - ${client_machine_ip}
    WMILibrary.Close Connection

Upload Spreadsheet Designer to Bucket
    [Arguments]    ${build_folder}    ${run_id}    ${bucket_name}=idbs-automation
    [Documentation]    Uploads the spreadsheet designer to a given s3 bucket.
    # TEMP WORKAROUND    # Copy both possible locations of spreadsheet designer and ignore error for the one that is incorrect.
    Run Keyword and Ignore Error    AWSLibrary.Upload File To Bucket    ${bucket_name}    ${build_folder}\\IDBS Spreadsheet Designer\\IDBS Spreadsheet Designer (64 bit) Installer.msi    runs/${run_id}/ssd/IDBS Spreadsheet Designer (64 bit) Installer.msi
    Run Keyword And Ignore Error    AWSLibrary.Upload File To Bucket    ${bucket_name}    ${build_folder}\\CD Image\\Install\\IDBS Spreadsheet Designer\\IDBS Spreadsheet Designer (64 bit) Installer.msi    runs/${run_id}/ssd/IDBS Spreadsheet Designer (64 bit) Installer.msi

Get Windows Spreadsheet Server Logs
    [Arguments]    ${spreadsheet_server}    ${windows_password}    ${windows_user}=Administrator    ${server_install_location}=C:/Program Files/IDBS/IDBS Spreadsheet Server (64 bit)
    [Documentation]    Gets spreadsheet server logs from a windows machine
    ...
    ...    *Arguments*
    ...
    ...    spreadsheet_server_ip - server ip
    ...
    ...    windows_password - password for the machine
    ...
    ...    server_install_location - server install location
    WMILibrary.Open Connection    ${spreadsheet_server}    ${windows_user}    ${windows_password}
    WMILibrary.Get Directory    ${server_install_location}/logs    ${OUTPUT DIR}/Model Server Logs
    WMILibrary.Close Connection

Get Linux Spreadsheet Server Logs
    [Arguments]    ${spreadsheet_server}    ${private_key_file}    ${root_user}=ec2-user    ${ssh_port}=22    ${spreadsheet_server_install_location}=/home/${root_user}/IDBS/SpreadsheetServer
    [Documentation]    Gets spreadsheet server logs from a windows machine
    ...
    ...    *Arguments*
    ...
    ...    spreadsheet_server_ip - server ip
    ...
    ...    windows_password - password for the machine
    ...
    ...    server_install_location - server install location
    SSHLibrary.Open Connection    ${spreadsheet_server}    timeout=120s    port=${ssh_port}
    SSHLibrary.Login With Public Key    ${root_user}    ${private_key_file}
    SSHLibrary.Write    export PS1="$"    #set prompt to $
    SSHLibrary.Set Client Configuration    prompt=$
    SSHLibrary.Get Directory    ${spreadsheet_server_install_location}/logs    ${OUTPUT DIR}/Spreadsheet Server Logs
    SSHLibrary.Close Connection
