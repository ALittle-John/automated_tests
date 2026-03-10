*** Settings ***
Library    RequestsLibrary

Resource    ../connections/api_connection_resource/create_session.resource

*** Keywords ***
Custom REST Request
    [Documentation]
    [Arguments]    ${alias}    ${base_url}    ${method}    ${final_url}    ${headers}={}    ${data}={}

    ${exists}    Session Exists    alias=${alias}
    IF    not ${exists}
        ${status}    Create Authenticated Session    alias=${alias}    base_url=${base_url}    headers=${headers}
    END

    IF    '${method}' == 'GET'
        ${_}    ${response}    Run Keyword And Ignore Error    GET On Session    alias=${alias}    url=${final_url}    expected_status=any
    ELSE IF    '${method}' == 'PUT'
        ${_}    ${response}    Run Keyword And Ignore Error    PUT On Session    alias=${alias}    url=${final_url}    json=${data}    expected_status=any
    ELSE IF    '${method}' == 'POST'
        ${_}    ${response}    Run Keyword And Ignore Error    POST On Session    alias=${alias}    url=${final_url}    json=${data}    expected_status=any
    ELSE IF    '${method}' == 'DELETE'
        ${_}    ${response}    Run Keyword And Ignore Error    DELETE On Session    alias=${alias}    url=${final_url}    json=${data}    expected_status=any
    ELSE
        Fatal Error    msg=A valid method need to be choosed: GET, PUT, POST, DELETE
    END

    IF    ${response.status_code} >= 400
        Run Keyword And Continue On Failure    Fail    msg="${final_url}" - Status code: ${response.status_code} - response text: ${response.text} ${\n}
    ELSE
        Log    message=${final_url}" - Status code: ${response.status_code} - Response text: ${response.text} ${\n} ${\n}    console=True
    END

    RETURN    ${response.text}
