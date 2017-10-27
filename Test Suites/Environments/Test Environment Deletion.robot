*** Settings ***
Library           AWSLibrary
Library           AWSLibrary

*** Variables ***
${stackName}    gps-test-22329

*** Test Cases ***
Delete Stack
    Start Stack Deletion    ${stackName}
    Wait For Stack Deletion Complete    ${stackName}    600s
    Set Test Message    The stack: '${stackName}' has been successfully deleted.