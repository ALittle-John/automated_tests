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

Reqres API
    [Documentation]    If method is PUT, ${data} must be in dict "{}" format.
    [Arguments]    ${method}    ${final_url}    ${data}={}

    Create Authenticated Session Reqres    alias=reqres    base_url=${BASE_URL}    api_keys=reqres-free-v1

    IF    '${method}' == 'GET'
        ${response}    Run Keyword And Ignore Error    GET On Session    reqres    ${final_url}
    ELSE IF    '${method}' == 'PUT'
        ${response}    Run Keyword And Ignore Error    PUT On Session    alias=reqres    url=${final_url}    json=${data}
    # ELSE IF    '${method}' == 'POST'

    # ELSE IF    '${method}' == 'DELETE'

    ELSE
        Fatal Error    msg=A valid method need to be choosed: GET, PUT, POST, DELETE
    END

    ${has_status_code}    Run Keyword And Return Status    Log    ${response[1].status_code}
    IF    ${has_status_code} == True
        Log    message=Status code: ${response[1].status_code} | Response text: ${response[1].text} ${\n}    console=True

        RETURN    ${response[1].text}
    ELSE
        Log    ${final_url} Returned text: ${response[1]} ${\n}    level=WARN

        &{dict_text}    Create Dictionary    response_text=${response[1]}
        RETURN    ${dict_text}
    END
