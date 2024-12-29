*** Settings ***
Library    RequestsLibrary
# Library    requests
Library    OperatingSystem

*** Variables ***
${BASE_URL}    https://reqres.in/api/

*** Keywords ***
### GET ###
Reqres API Method Get
    [Documentation]    Options: `{resource}; users; users/{id}; {resource}/{id}`
    [Arguments]    ${final_url}

    ${url_request}    Set Variable    ${BASE_URL}${final_url}

    Log    message=Request in ${url_request}    html=True    console=True

    ${response}    Run Keyword And Ignore Error    GET    ${url_request}
    ${has_status_code}    Run Keyword And Return Status    Log    ${response[1].status_code}
    IF    ${has_status_code} == True
        ${response_status}    Set Variable    ${response[1].status_code}
        Log    Status code captured: ${response_status}    console=True
    ELSE
        ${response_status}    Set Variable    ${response[1]}
        Log    Response beyond status 200 - 299. Returned: ${response_status}    level=ERROR
    END

### PUT ###
