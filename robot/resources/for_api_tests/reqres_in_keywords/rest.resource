*** Settings ***
Library    RequestsLibrary
Library    OperatingSystem

*** Variables ***
${BASE_URL}    https://reqres.in/api/

*** Keywords ***
Create Authenticated Session Reqres
    [Arguments]    ${alias}    ${base_url}    ${api_keys}

    &{headers}    Create Dictionary    x-api-key=${api_keys}
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
        Log    message=Status code: ${response[1].status_code}    console=True
        Log    message=Response text: ${response[1].text} ${\n}    console=True
    ELSE
        Log    ${final_url} Returned: ${response[1]}${\n}    level=ERROR
    END

### PUT ###
Reqres API Method Put
    [Documentation]    Options: `users/{id}; {resource}/{id}`
    ...
    ...    ${data} -> Must be in JSON format. The necessary data is *"name": "XXX"* and *"job": "zion resident"*.
    [Arguments]    ${final_url}    ${data}

    Create Authenticated Session Reqres    alias=reqres    base_url=${BASE_URL}    api_keys=reqres-free-v1
    ${response}    Run Keyword And Ignore Error    PUT On Session    alias=reqres    url=${final_url}    json=${data}

    ${has_status_code}    Run Keyword And Return Status    Log    ${response[1].status_code}
    IF    ${has_status_code} == True
        Log    message=Status code: ${response[1].status_code}    console=True
        Log    message=Response text: ${response[1].text} ${\n}    console=True
    ELSE
        Log    ${final_url} Returned: ${response[1]} ${\n}    level=ERROR
    END
