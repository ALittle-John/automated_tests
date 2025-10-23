*** Settings ***
Library    RequestsLibrary

Resource    ../variables.resource
Resource    ../connections/create_session.resource

*** Keywords ***
Reqres API
    [Documentation]
    [Arguments]    ${method}    ${final_url}    ${data}={}

    Create Authenticated Session    alias=${ALIAS}

    IF    '${method}' == 'GET'
        ${_}    ${response}    Run Keyword And Ignore Error    GET On Session    alias=reqres    url=${final_url}
    ELSE IF    '${method}' == 'PUT'
        ${_}    ${response}    Run Keyword And Ignore Error    PUT On Session    alias=reqres    url=${final_url}    json=${data}    expected_status=any
    ELSE IF    '${method}' == 'POST'
        ${_}    ${response}    Run Keyword And Ignore Error    POST On Session    alias=reqres    url=${final_url}    json=${data}    expected_status=any
    ELSE IF    '${method}' == 'DELETE'
        ${_}    ${response}    Run Keyword And Ignore Error    DELETE On Session    alias=reqres    url=${final_url}    json=${data}    expected_status=any
    ELSE
        Fatal Error    msg=A valid method need to be choosed: GET, PUT, POST, DELETE
    END

    ${has_status_code}    Run Keyword And Return Status    Log    ${response.status_code}
    IF    ${has_status_code} == True
        IF    ${response.status_code} >= 400
            Run Keyword And Continue On Failure    Fail    msg=${final_url} Returned text: ${response.text} ${\n}
        ELSE
            Log    message=Status code: ${response.status_code} | Response text: ${response.text} ${\n}    console=True
        END

        RETURN    ${response.text}
    ELSE
        Log    ${final_url} Returned text: ${response} ${\n}    level=WARN

        &{dict_text}    Create Dictionary    response_text=${response}
        RETURN    ${dict_text}
    END
