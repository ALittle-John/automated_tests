*** Settings ***
Library    RequestsLibrary

Resource    ../../variables.resource

*** Keywords ***
Create Authenticated Session
    [Arguments]    ${alias}

    IF    '${alias}' == 'reqres'
        ${base_url}    Set Variable    https://reqres.in/api
        &{headers}    Create Dictionary
        ...    x-api-key=reqres-free-v1
        ...    Content-Type=application/json
    # ELSE

    END
    Create Session    alias=${alias}    url=${base_url}    headers=${headers}    disable_warnings=1
