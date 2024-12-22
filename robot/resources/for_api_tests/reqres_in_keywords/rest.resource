*** Settings ***
Library    RequestsLibrary
Library    OperatingSystem

*** Variables ***
${BASE_URL}    https://reqres.in/api/

*** Keywords ***
### GET ###
Reqres API Method Get
    [Documentation]    Options: `{resource}; users; users/{id}; {resource}/{id}`
    [Arguments]    ${final_url}

    ${response}    Run Keyword And Ignore Error    GET    ${BASE_URL}${final_url}
    ${status_req}    Set Variable     ${response[1]}
    
    IF    '${status_req}' != '<Response [200]>'
        Run Keyword And Continue On Failure    Fail    Route with final "${final_url}" get status ${status_req}! Please verify.
        ${response_body_string}    Set Variable    None
    ELSE
        ${response_body_string}    Convert To String    ${response[1].json()}
        ${response_body_idented}    Evaluate    json.dumps(${response_body_string}, indent=2)
        # Log To Console    ${response_body_idented}
    END

    # Log To Console    Response body: ${response_body_string}
    RETURN    ${response_body_string}

### PUT ###
