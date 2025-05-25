*** Settings ***
Library    RequestsLibrary
Library    OperatingSystem

*** Variables ***
${BASE_URL}    https://reqres.in/api/

*** Keywords ***
Create Authenticated Session Reqres
    [Arguments]    ${alias}    ${base_url}    ${api_keys}

    &{headers}    Create Dictionary    x-api-key=${api_keys}
    # Create Session    alias=${alias}    url=${base_url}    headers=${headers}
    Create Session    alias=${alias}    url=${base_url}    headers=${headers}    disable_warnings=1

### GET ###
Reqres API Method Get
    [Documentation]    Options: `{resource}; users; users/{id}; {resource}/{id}`
    [Arguments]    ${final_url}

    Log    message=Request in ${final_url}    html=True    console=True

    Create Authenticated Session Reqres    alias=reqres    base_url=${BASE_URL}    api_keys=reqres-free-v1
    ${response}    Run Keyword And Ignore Error    GET On Session    reqres    ${final_url}

    ${has_status_code}    Run Keyword And Return Status    Log    ${response[1].status_code}
    IF    ${has_status_code} == True
        ${response_status}    Set Variable    ${response[1].status_code}
        Log    Status code captured: ${response_status}    console=True
    ELSE
        ${response_status}    Set Variable    ${response[1]}
        Log    ERROR TO GET. Returned: ${response_status}    level=ERROR
    END

### PUT ###
Reqres API Method Put
    [Documentation]    Options: `users/{id}; {resource}/{id}`
    ...
    ...    ${data} -> Must be in JSON format. The necessary data is *"name": "XXX"* and *"job": "zion resident"*.
    [Arguments]    ${final_url}    #${data}

    ${url_request}    Set Variable    ${BASE_URL}${final_url}

    Log    message=Request in ${url_request}    html=True    console=True

    ${response}    Run Keyword And Ignore Error    PUT    url=${url_request}    #data=${data}
